"""Exporta la proyección a Excel con el formato de la matriz triangular.

Usa el Excel original como plantilla y solo reemplaza los números de la hoja
``sistemas``, así se conservan anchos, encabezados y estilos.

Uso:
    python python/exportar.py "matriz sistemas agodic26.xlsx" resultados.xlsx

* Diagonal: alumnos que cursarán la materia.
* Arriba de la diagonal: alumnos que cursarán ambas materias.
* Abajo de la diagonal: siempre 0.
"""

from itertools import combinations
from pathlib import Path
from xml.etree import ElementTree
import re
import sys
import zipfile

from algoritmo import generar_proyeccion_global
from laya import decidir_carga

# En la plantilla, la hoja "sistemas" es la primera.
HOJA = "xl/worksheets/sheet1.xml"
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"


def letra_columna(numero: int) -> str:
    """Convierte 1 en A, 27 en AA, etc."""
    letras = ""
    while numero:
        numero, resto = divmod(numero - 1, 26)
        letras = chr(65 + resto) + letras
    return letras


def leer_posiciones(plantilla: zipfile.ZipFile) -> tuple[dict, int]:
    """Devuelve {clave: posición} y el total de materias de la plantilla."""
    textos = [
        "".join(t.text or "" for t in elemento.iter(NS + "t"))
        for elemento in ElementTree.fromstring(plantilla.read("xl/sharedStrings.xml"))
    ]
    celdas = {}
    for celda in ElementTree.fromstring(plantilla.read(HOJA)).iter(NS + "c"):
        if celda.get("t") == "s":
            celdas[celda.get("r")] = textos[int(celda.find(NS + "v").text)].strip()

    posiciones = {}
    total = 0
    # Las claves de las filas (A2, A3...) van en el mismo orden que las columnas.
    while f"A{total + 2}" in celdas:
        posiciones[celdas[f"A{total + 2}"]] = total
        # El encabezado puede usar otra clave (ejemplo: fila ACA, columna ACT0000).
        encabezado = celdas.get(f"{letra_columna(total + 3)}1")
        if encabezado:
            posiciones.setdefault(encabezado, total)
        total += 1
    return posiciones, total


def construir_matriz(selecciones: list, posiciones: dict, total: int) -> tuple[list, set]:
    """Cuenta alumnos por materia y por par. También devuelve claves desconocidas."""
    matriz = [[0] * total for _ in range(total)]
    desconocidas = set()
    for claves in selecciones:
        desconocidas.update(c for c in claves if c not in posiciones)
        indices = sorted({posiciones[c] for c in claves if c in posiciones})
        for i in indices:
            matriz[i][i] += 1
        for i, j in combinations(indices, 2):
            matriz[i][j] += 1
    return matriz, desconocidas


def escribir_excel(ruta_plantilla, ruta_salida, selecciones: list) -> None:
    """Copia la plantilla y reemplaza los números de la matriz."""
    if Path(ruta_plantilla).resolve() == Path(ruta_salida).resolve():
        raise ValueError("El archivo de salida no puede ser la plantilla.")

    with zipfile.ZipFile(ruta_plantilla) as plantilla:
        posiciones, total = leer_posiciones(plantilla)
        matriz, desconocidas = construir_matriz(selecciones, posiciones, total)
        if desconocidas:
            raise ValueError(
                f"Materias que no están en la plantilla: {', '.join(sorted(desconocidas))}"
            )

        valores = {
            f"{letra_columna(j + 3)}{i + 2}": matriz[i][j]
            for i in range(total)
            for j in range(total)
        }
        escritas = set()

        def reemplazar(coincidencia):
            referencia = coincidencia["ref"]
            if referencia not in valores:
                return coincidencia[0]
            escritas.add(referencia)
            estilo = re.search(r'\ss="\d+"', coincidencia["atributos"])
            estilo = estilo[0] if estilo else ""
            return f'<c r="{referencia}"{estilo}><v>{valores[referencia]}</v></c>'

        hoja = re.sub(
            r'<c r="(?P<ref>[A-Z]+\d+)"(?P<atributos>[^>]*?)(?:/>|>.*?</c>)',
            reemplazar,
            plantilla.read(HOJA).decode("utf-8"),
        )
        # Si faltara alguna celda, el resultado quedaría incompleto.
        if len(escritas) != len(valores):
            raise ValueError("La plantilla no tiene todas las celdas de la matriz.")

        with zipfile.ZipFile(ruta_salida, "w", zipfile.ZIP_DEFLATED) as salida:
            for parte in plantilla.infolist():
                contenido = (
                    hoja.encode("utf-8")
                    if parte.filename == HOJA
                    else plantilla.read(parte.filename)
                )
                salida.writestr(parte, contenido)


def exportar_proyeccion(ruta_plantilla, ruta_salida) -> int:
    """Exporta la decisión de Laya de todos los alumnos. Devuelve cuántos son."""
    proyecciones = generar_proyeccion_global()["proyecciones"]
    if not proyecciones:
        raise ValueError("No hay alumnos en la base de datos; no hay nada que exportar.")
    selecciones = [decidir_carga(p["alumno"], p)["seleccion_laya"] for p in proyecciones]
    escribir_excel(ruta_plantilla, ruta_salida, selecciones)
    return len(proyecciones)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("Uso: python python/exportar.py PLANTILLA.xlsx SALIDA.xlsx")
    try:
        cantidad = exportar_proyeccion(sys.argv[1], sys.argv[2])
    except ValueError as error:
        sys.exit(str(error))
    print(f"Matriz de {cantidad} alumnos exportada a {sys.argv[2]}")
