"""Importa una base de datos, calcula las cargas y exporta la matriz a Excel.

Uso:
    python python/importar.py DATOS.sql PLANTILLA.xlsx SALIDA.xlsx

Acepta un script ``.sql`` o un archivo de SQLite, con las mismas tablas que
``database.py``. El original no se modifica: se calcula en una copia temporal.
"""

from contextlib import closing
from pathlib import Path
import shutil
import sqlite3
import sys
import tempfile
import time
import zipfile

from algoritmo import generar_proyeccion_global
from database import ESQUEMA
from exportar import escribir_excel
from laya import decidir_carga


def columnas_por_tabla(conexion) -> dict:
    """Devuelve {tabla: conjunto de columnas}."""
    tablas = conexion.execute(
        "SELECT name FROM sqlite_master WHERE type = 'table'"
    ).fetchall()
    return {
        tabla: {
            fila[1] for fila in conexion.execute(f'PRAGMA table_info("{tabla}")')
        }
        for (tabla,) in tablas
    }


def autorizar(accion, argumento1, argumento2, base, origen):
    """Bloquea lo que permitiría a un .sql tocar otros archivos o la configuración."""
    if accion in (sqlite3.SQLITE_ATTACH, sqlite3.SQLITE_DETACH, sqlite3.SQLITE_CREATE_VTABLE):
        return sqlite3.SQLITE_DENY
    # Los respaldos de SQLite incluyen "PRAGMA foreign_keys"; es el único permitido.
    if accion == sqlite3.SQLITE_PRAGMA and argumento1.lower() != "foreign_keys":
        return sqlite3.SQLITE_DENY
    return sqlite3.SQLITE_OK


def cargar_script_sql(ruta_sql: Path, destino: Path) -> None:
    """Crea una base temporal ejecutando un archivo .sql (dialecto de SQLite)."""
    try:
        script = ruta_sql.read_text(encoding="utf-8-sig")
    except UnicodeDecodeError:
        raise ValueError("El archivo .sql debe estar guardado en UTF-8.") from None

    with closing(sqlite3.connect(destino)) as conexion:
        # Límites de tamaño y tiempo para que un script no agote la computadora.
        conexion.execute("PRAGMA max_page_count = 50000")  # unos 200 MB
        conexion.setlimit(sqlite3.SQLITE_LIMIT_LENGTH, 1_000_000)
        limite = time.monotonic() + 60  # segundos
        conexion.set_progress_handler(lambda: time.monotonic() > limite, 10_000)
        conexion.set_authorizer(autorizar)
        try:
            conexion.executescript(script)
            conexion.commit()
        except sqlite3.Error as error:
            raise ValueError(
                f"No se pudo ejecutar el .sql (debe ser compatible con SQLite): {error}"
            ) from None


def validar(conexion) -> list:
    """Detiene el proceso si la base no sirve. Devuelve las advertencias."""
    with closing(sqlite3.connect(":memory:")) as modelo:
        modelo.executescript(ESQUEMA)
        esperadas = columnas_por_tabla(modelo)

    actuales = columnas_por_tabla(conexion)
    faltantes = []
    for tabla, columnas in esperadas.items():
        if tabla not in actuales:
            faltantes.append(f"tabla {tabla}")
        else:
            faltantes += [f"{tabla}.{c}" for c in sorted(columnas - actuales[tabla])]
    if faltantes:
        raise ValueError(f"A la base le falta: {', '.join(faltantes)}")

    if conexion.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
        raise ValueError("La base está dañada o tiene valores no permitidos.")
    rotas = conexion.execute("PRAGMA foreign_key_check").fetchall()
    if rotas:
        tablas = ", ".join(sorted({fila[0] for fila in rotas}))
        raise ValueError(f"Hay relaciones a registros que no existen en: {tablas}")

    # Sin esta revisión, el algoritmo usaría la retícula de otra especialidad.
    sin_reticula = conexion.execute(
        """
        SELECT a.matricula FROM alumnos a
        WHERE a.semestre_actual <= 14 AND NOT EXISTS (
            SELECT 1 FROM materias_reticula mr
            WHERE mr.reticula_id = (
                SELECT r.id FROM reticulas r
                WHERE r.especialidad_id = a.especialidad_actual_id LIMIT 1
            )
        )
        """
    ).fetchall()
    if sin_reticula:
        matriculas = ", ".join(fila[0] for fila in sin_reticula)
        raise ValueError(f"Alumnos sin una retícula con materias: {matriculas}")

    omitidos = conexion.execute(
        """SELECT matricula FROM alumnos
           WHERE semestre_actual IS NULL OR semestre_actual > 14"""
    ).fetchall()
    if omitidos:
        matriculas = ", ".join(fila[0] for fila in omitidos)
        return [f"Se omiten (sin semestre o mayor a 14): {matriculas}"]
    return []


def importar(ruta_bd, ruta_plantilla, ruta_salida) -> tuple[list, list]:
    """Ejecuta todo el procedimiento. Devuelve (resultados, advertencias)."""
    ruta_bd = Path(ruta_bd)
    if not ruta_bd.is_file():
        raise ValueError(f"No existe la base de datos: {ruta_bd}")
    if Path(ruta_salida).resolve() == ruta_bd.resolve():
        raise ValueError("El archivo de salida no puede ser la base de datos.")

    with tempfile.TemporaryDirectory() as carpeta:
        copia = Path(carpeta) / "importada.sqlite3"
        if ruta_bd.suffix.lower() == ".sql":
            cargar_script_sql(ruta_bd, copia)
        else:
            shutil.copyfile(ruta_bd, copia)

        with closing(sqlite3.connect(copia)) as conexion:
            advertencias = validar(conexion)

        proyecciones = generar_proyeccion_global(copia)["proyecciones"]

    if not proyecciones:
        raise ValueError("La base no tiene alumnos que procesar.")

    resultados = [
        {"alumno": p["alumno"], **decidir_carga(p["alumno"], p)} for p in proyecciones
    ]
    escribir_excel(
        ruta_plantilla, ruta_salida, [r["seleccion_laya"] for r in resultados]
    )
    return resultados, advertencias


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit("Uso: python python/importar.py DATOS.sqlite3 PLANTILLA.xlsx SALIDA.xlsx")
    try:
        resultados, advertencias = importar(*sys.argv[1:])
    except sqlite3.DatabaseError as error:
        sys.exit(f"No se pudo leer la base de datos: {error}")
    except (zipfile.BadZipFile, KeyError) as error:
        sys.exit(f"La plantilla de Excel no tiene el formato esperado: {error}")
    except (ValueError, OSError) as error:
        sys.exit(str(error))

    for aviso in advertencias:
        print(f"Aviso: {aviso}")
    for r in resultados:
        alumno = r["alumno"]
        minimo = "" if r["creditos_totales"] >= 20 else "  [menos de 20 créditos]"
        print(
            f"{alumno['matricula']} | {alumno['nombre']} | semestre "
            f"{alumno['semestre_actual']} | {r['total_materias']} materias, "
            f"{r['creditos_totales']:g} créditos{minimo}"
        )
        print(f"    {', '.join(r['seleccion_laya']) or '(sin materias pendientes)'}")
    print(f"\nMatriz de {len(resultados)} alumnos exportada a {sys.argv[3]}")
