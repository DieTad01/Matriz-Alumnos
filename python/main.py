from base64 import b64encode
from contextlib import asynccontextmanager
from pathlib import Path
import sqlite3
import tempfile
import zipfile

from fastapi import FastAPI, HTTPException, Request
from fastapi.concurrency import run_in_threadpool
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from algoritmo import evaluar_alumno, generar_proyeccion_global
from database import inicializar_base_datos, obtener_conexion
from importar import importar
from laya import decidir_carga

DIRECTORIO_PROYECTO = Path(__file__).resolve().parent.parent
PLANTILLA = DIRECTORIO_PROYECTO / "python" / "plantillas" / "matriz_sistemas.xlsx"
TAMANO_MAXIMO_MB = 50
TAMANO_MAXIMO = TAMANO_MAXIMO_MB * 1024 * 1024


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Crea las tablas de SQLite automáticamente al arrancar el servidor."""
    inicializar_base_datos()
    yield


app = FastAPI(
    title="API de Proyección Académica",
    description="Backend para cálculo de demanda escolar y asignación con Laya.",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class MateriaOut(BaseModel):
    clave: str
    nombre: str


class AlumnoOut(BaseModel):
    matricula: str
    nombre: str
    semestre_actual: int | None


@app.get("/", tags=["Estado"])
def verificar_estado():
    """Comprueba que el servidor esté activo."""
    return {"estado": "activo", "mensaje": "Backend académico con Laya funcionando"}


@app.get("/materias", response_model=list[MateriaOut], tags=["Catálogos"])
def listar_materias():
    """Devuelve todas las materias registradas en la base de datos."""
    with obtener_conexion() as conexion:
        filas = conexion.execute("SELECT clave, nombre FROM materias").fetchall()
    return [dict(fila) for fila in filas]


@app.get("/alumnos", response_model=list[AlumnoOut], tags=["Alumnos"])
def listar_alumnos():
    """Devuelve los alumnos ordenados por semestre."""
    with obtener_conexion() as conexion:
        filas = conexion.execute(
            """
            SELECT matricula, nombre, semestre_actual
            FROM alumnos
            ORDER BY semestre_actual DESC
            """
        ).fetchall()
    return [dict(fila) for fila in filas]


@app.get("/proyeccion/{matricula}", tags=["Proyección Laya"])
def proyectar_carga_alumno(matricula: str):
    """Calcula materias viables por reglas duras y obtiene la decisión final de Laya."""
    with obtener_conexion() as conn:
        alumno = conn.execute(
            """
            SELECT a.*, COALESCE(AVG(i.calificacion_numerica), 0) AS promedio
            FROM alumnos a
            LEFT JOIN intentos_academicos i ON i.alumno_id = a.id
            WHERE a.matricula = ?
            GROUP BY a.id
            """,
            (matricula,),
        ).fetchone()

        if not alumno:
            raise HTTPException(status_code=404, detail="Alumno no encontrado")

        al_dict = dict(alumno)
        reglas = evaluar_alumno(conn, al_dict)
        decision_laya = decidir_carga(al_dict, reglas)

    return {"alumno": al_dict, "reglas_duras": reglas, "decision_laya": decision_laya}


def procesar_archivo(contenido: bytes, extension: str) -> dict:
    """Procesa el archivo subido en una carpeta temporal que se borra al terminar."""
    with tempfile.TemporaryDirectory() as carpeta:
        entrada = Path(carpeta) / f"datos{extension}"
        salida = Path(carpeta) / "resultados.xlsx"
        entrada.write_bytes(contenido)
        resultados, advertencias = importar(entrada, PLANTILLA, salida)
        excel = b64encode(salida.read_bytes()).decode("ascii")
    return {"resultados": resultados, "advertencias": advertencias, "excel_base64": excel}


@app.post("/importar", tags=["Importación"])
async def importar_base_datos(request: Request, nombre: str):
    """Recibe el archivo como cuerpo de la petición. No guarda los datos."""
    extension = Path(nombre).suffix.lower()
    if extension not in (".sql", ".sqlite3", ".sqlite", ".db"):
        raise HTTPException(400, "Sube un archivo .sql, .sqlite3, .sqlite o .db")

    contenido = bytearray()
    async for bloque in request.stream():
        contenido += bloque
        if len(contenido) > TAMANO_MAXIMO:
            raise HTTPException(413, f"El archivo supera el límite de {TAMANO_MAXIMO_MB} MB")
    if not contenido:
        raise HTTPException(400, "El archivo está vacío")

    try:
        return await run_in_threadpool(procesar_archivo, bytes(contenido), extension)
    except ValueError as error:
        raise HTTPException(400, str(error)) from None
    except sqlite3.Error as error:
        raise HTTPException(400, f"No se pudo leer la base de datos: {error}") from None
    except (zipfile.BadZipFile, KeyError):
        raise HTTPException(500, "La plantilla de Excel del servidor está dañada") from None


# Se publican solo las carpetas de la web; nunca ``python``, donde está la base.
for carpeta in ("css", "js", "html", "resources"):
    app.mount(f"/{carpeta}", StaticFiles(directory=DIRECTORIO_PROYECTO / carpeta), name=carpeta)


@app.get("/index.html", include_in_schema=False)
def pagina_inicio():
    return FileResponse(DIRECTORIO_PROYECTO / "index.html")


@app.get("/matriz-demanda", tags=["Proyección Laya"])
def obtener_matriz_demanda():
    """Devuelve la proyección de todos los alumnos y los pares con mayor choque de horario."""
    return generar_proyeccion_global()