"""
Esquema y creación de la base de datos académica en SQLite.
librerias utilizadas
contextmanager: crear funciones utilizables con la estructura
pathlib: rutas de archivos y carpetas
sqlite3: base de datos SQLite 
"""

from contextlib import contextmanager
from pathlib import Path
import sqlite3


DIRECTORIO_PYTHON = Path(__file__).resolve().parent
RUTA_BASE_DATOS = DIRECTORIO_PYTHON / "data" / "alumnos.sqlite3"

ESQUEMA = """
PRAGMA foreign_keys = ON;
    
CREATE TABLE IF NOT EXISTS programas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS especialidades (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    version_reticula TEXT NOT NULL,
    creditos_totales REAL CHECK (creditos_totales IS NULL OR creditos_totales > 0)
    
);

CREATE TABLE IF NOT EXISTS reticulas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    programa_id INTEGER NOT NULL REFERENCES programas(id),
    especialidad_id INTEGER REFERENCES especialidades(id),
    version TEXT NOT NULL,
    fecha_actualizacion TEXT,
    CHECK (especialidad_id IS NULL OR especialidad_id > 0)
);

CREATE TABLE IF NOT EXISTS materias (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);

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

CREATE INDEX IF NOT EXISTS idx_intentos_alumno
    ON intentos_academicos(alumno_id);
CREATE INDEX IF NOT EXISTS idx_intentos_materia
    ON intentos_academicos(materia_id);
CREATE INDEX IF NOT EXISTS idx_materias_reticula
    ON materias_reticula(reticula_id);
"""

"""Abre una conexión SQLite y activa la validación de llaves foráneas."""
def conectar(ruta=RUTA_BASE_DATOS):
    ruta = Path(ruta)
    ruta.parent.mkdir(parents=True, exist_ok=True)
    conexion = sqlite3.connect(ruta)
    conexion.row_factory = sqlite3.Row
    conexion.execute("PRAGMA foreign_keys = ON")
    return conexion


@contextmanager
def obtener_conexion(ruta=RUTA_BASE_DATOS):
    """Entrega una conexión y confirma o revierte la transacción al cerrarla."""
    conexion = conectar(ruta)
    try:
        yield conexion
        conexion.commit()
    except Exception:
        conexion.rollback()
        raise
    finally:
        conexion.close()


def inicializar_base_datos(ruta=RUTA_BASE_DATOS):
    """Crea las tablas si todavía no existen y devuelve la ruta del archivo."""
    with obtener_conexion(ruta) as conexion:
        conexion.executescript(ESQUEMA)
        conexion.execute(
            "INSERT OR IGNORE INTO programas (clave, nombre) VALUES (?, ?)",
            ("ISIC-2010-224", "Ingeniería en Sistemas Computacionales"),
        )
        programa_id = conexion.execute(
            "SELECT id FROM programas WHERE clave = ?", ("ISIC-2010-224",)
        ).fetchone()["id"]

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
            conexion.execute(
                """
                INSERT OR IGNORE INTO reticulas
                    (clave, programa_id, especialidad_id, version, fecha_actualizacion)
                VALUES (?, ?, ?, ?, '2023-12-14')
                """,
                (clave, programa_id, especialidad_id, version),
            )
    return Path(ruta)


if __name__ == "__main__":
    print(inicializar_base_datos())
