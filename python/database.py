"""Crea y prepara la base de datos 

* las tablas son los cuartos;
* las columnas son los espacios donde guardamos datos;
* las llaves foráneas son los pasillos que conectan las tablas.

También agrega algunos datos iniciales para que la base no empiece vacía.
"""

from contextlib import contextmanager  # Permite usar una conexión con ``with``.
from pathlib import Path  # Ayuda a construir rutas de archivos.
import sqlite3  # Permite trabajar con bases de datos SQLite.


# ``__file__`` es este archivo. ``parent`` obtiene la carpeta ``python``.
DIRECTORIO_PYTHON = Path(__file__).resolve().parent

# La base se guardará dentro de ``python/data/alumnos.sqlite3``.
# El operador ``/`` une carpetas y nombres de archivo.
RUTA_BASE_DATOS = DIRECTORIO_PYTHON / "data" / "alumnos.sqlite3"

ESQUEMA = """
-- Hace que SQLite revise que las relaciones entre tablas sean correctas.
PRAGMA foreign_keys = ON;

-- Un programa es una carrera, por ejemplo Ingeniería en Sistemas.
CREATE TABLE IF NOT EXISTS programas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);

-- Una especialidad pertenece a un programa y tiene una versión de retícula.
CREATE TABLE IF NOT EXISTS especialidades (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    version_reticula TEXT NOT NULL,
    creditos_totales REAL CHECK (creditos_totales IS NULL OR creditos_totales > 0)
);

-- Una retícula es el mapa de materias de un programa o especialidad.
CREATE TABLE IF NOT EXISTS reticulas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    programa_id INTEGER NOT NULL REFERENCES programas(id),
    especialidad_id INTEGER REFERENCES especialidades(id),
    version TEXT NOT NULL,
    fecha_actualizacion TEXT,
    CHECK (especialidad_id IS NULL OR especialidad_id > 0)
);

-- Catálogo general de materias.
CREATE TABLE IF NOT EXISTS materias (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);

-- Une una materia con una retícula.
-- Es una tabla intermedia porque una retícula tiene muchas materias.
CREATE TABLE IF NOT EXISTS materias_reticula (
    id INTEGER PRIMARY KEY,
    reticula_id INTEGER NOT NULL REFERENCES reticulas(id) ON DELETE CASCADE,
    materia_id INTEGER NOT NULL REFERENCES materias(id),
    numero_nodo INTEGER,
    semestre_sugerido INTEGER CHECK (
        semestre_sugerido IS NULL OR semestre_sugerido > 0
    ),
    creditos REAL NOT NULL CHECK (creditos > 0),
    categoria TEXT NOT NULL DEFAULT 'generica'
        CHECK (categoria IN (
            'generica', 'especialidad', 'actividad_complementaria',
            'servicio_social', 'residencia'
        )),
    UNIQUE (reticula_id, materia_id),
    UNIQUE (reticula_id, numero_nodo),
    UNIQUE (id, reticula_id)
);

-- Indica qué materia debe aprobarse antes de cursar otra.
CREATE TABLE IF NOT EXISTS prerrequisitos (
    reticula_id INTEGER NOT NULL REFERENCES reticulas(id) ON DELETE CASCADE,
    materia_reticula_id INTEGER NOT NULL,
    requisito_reticula_id INTEGER NOT NULL,
    PRIMARY KEY (reticula_id, materia_reticula_id, requisito_reticula_id),
    FOREIGN KEY (materia_reticula_id, reticula_id)
        REFERENCES materias_reticula(id, reticula_id) ON DELETE CASCADE,
    FOREIGN KEY (requisito_reticula_id, reticula_id)
        REFERENCES materias_reticula(id, reticula_id) ON DELETE CASCADE,
    CHECK (materia_reticula_id <> requisito_reticula_id)
);

-- Información básica de los alumnos.
CREATE TABLE IF NOT EXISTS alumnos (
    id INTEGER PRIMARY KEY,
    matricula TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    programa_id INTEGER NOT NULL REFERENCES programas(id),
    especialidad_actual_id INTEGER REFERENCES especialidades(id),
    semestre_actual INTEGER CHECK (
        semestre_actual IS NULL OR semestre_actual > 0
    ),
    grupo TEXT,
    turno TEXT,
    campus TEXT,
    fecha_corte TEXT
);

-- Guarda cada vez que un alumno cursa una materia.
-- Permite tener varios intentos de la misma materia.
CREATE TABLE IF NOT EXISTS intentos_academicos (
    id INTEGER PRIMARY KEY,
    alumno_id INTEGER NOT NULL REFERENCES alumnos(id) ON DELETE CASCADE,
    materia_id INTEGER NOT NULL REFERENCES materias(id),
    numero_intento INTEGER NOT NULL CHECK (numero_intento > 0),
    periodo TEXT NOT NULL,
    semestre_cursado INTEGER CHECK (
        semestre_cursado IS NULL OR semestre_cursado > 0
    ),
    tipo_intento TEXT NOT NULL
        CHECK (tipo_intento IN ('ordinario', 'repeticion', 'especial')),
    calificacion_numerica REAL,
    calificacion_textual TEXT,
    resultado TEXT NOT NULL
        CHECK (resultado IN ('aprobada', 'reprobada', 'en_curso')),
    observaciones TEXT,
    UNIQUE (alumno_id, materia_id, numero_intento)
);

-- Los índices son como índices de un libro: ayudan a encontrar datos más rápido.
CREATE INDEX IF NOT EXISTS idx_intentos_alumno
    ON intentos_academicos(alumno_id);
CREATE INDEX IF NOT EXISTS idx_intentos_materia
    ON intentos_academicos(materia_id);
CREATE INDEX IF NOT EXISTS idx_materias_reticula
    ON materias_reticula(reticula_id);
"""


def conectar(ruta=RUTA_BASE_DATOS):
    """Abre SQLite y activa la revisión de las llaves foráneas."""

    # Convertimos la ruta en un objeto Path, aunque nos la entreguen como texto.
    ruta = Path(ruta)

    # Creamos la carpeta ``data`` si todavía no existe.
    ruta.parent.mkdir(parents=True, exist_ok=True)

    # Abrimos la base. Si el archivo no existe, SQLite lo crea.
    conexion = sqlite3.connect(ruta)

    # Permite leer una fila usando fila["id"] en lugar de fila[0].
    conexion.row_factory = sqlite3.Row

    # La revisión de llaves foráneas se activa por conexión.
    conexion.execute("PRAGMA foreign_keys = ON")
    return conexion


@contextmanager
def obtener_conexion(ruta=RUTA_BASE_DATOS):
    """Entrega una conexión y confirma o revierte la transacción al cerrarla."""

    # Abrimos una conexión.
    conexion = conectar(ruta)
    try:
        # ``yield`` entrega temporalmente la conexión al bloque ``with``.
        yield conexion

        # Si todo salió bien, guardamos los cambios.
        conexion.commit()
    except Exception:
        # Si ocurrió cualquier error, deshacemos los cambios incompletos.
        conexion.rollback()
        raise
    finally:
        # Pase lo que pase, cerramos la conexión.
        conexion.close()


def inicializar_base_datos(ruta=RUTA_BASE_DATOS):
    """Crea las tablas si todavía no existen y devuelve la ruta del archivo."""

    # ``with`` se encarga de confirmar, deshacer y cerrar la conexión.
    with obtener_conexion(ruta) as conexion:
        # Ejecutamos todas las instrucciones SQL guardadas en ESQUEMA.
        conexion.executescript(ESQUEMA)

        conexion.execute(
            "INSERT OR IGNORE INTO programas (clave, nombre) VALUES (?, ?)",
            ("ISIC-2010-224", "Ingeniería en Sistemas Computacionales"),
        )
        programa_id = conexion.execute(
            "SELECT id FROM programas WHERE clave = ?", ("ISIC-2010-224",)
        ).fetchone()["id"]

        # Estas son las especialidades que se cargarán al iniciar la base.
        # Cada elemento guarda: clave, nombre y versión.

        especialidades_base = (
            (
                "ISIE-COE-2024-02",
                "Cómputo Empresarial",
                "2024-02",
            ),
            (
                "ISIE-SIA-2024-03",
                "Sistemas basados en Inteligencia Artificial",
                "2024-03",
            ),
        )
        for clave, nombre, version in especialidades_base:
            # Recorremos una especialidad cada vez.
            conexion.execute(
                """
                INSERT OR IGNORE INTO especialidades
                    (clave, nombre, version_reticula, creditos_totales)
                VALUES (?, ?, ?, 25)
                """,
                (clave, nombre, version),
            )
            especialidad_id = conexion.execute(
                "SELECT id FROM especialidades WHERE clave = ?", (clave,)
            ).fetchone()["id"]

            # Creamos la retícula correspondiente a esa especialidad.
            conexion.execute(
                """
                INSERT OR IGNORE INTO reticulas
                    (clave, programa_id, especialidad_id, version, fecha_actualizacion)
                VALUES (?, ?, ?, ?, '2023-12-14')
                """,
                (clave, programa_id, especialidad_id, version),
            )
    # Entregamos la ubicación de la base para que otro programa pueda usarla.
    return Path(ruta)


if __name__ == "__main__":
    # Esta parte solo se ejecuta cuando abrimos este archivo directamente:
    #     python python/database.py
    print(inicializar_base_datos())
