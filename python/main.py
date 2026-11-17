from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from database import inicializar_base_datos, obtener_conexion


# 1. Ciclo de vida: crea las tablas al iniciar el servidor
@asynccontextmanager
async def lifespan(app: FastAPI):
    inicializar_base_datos()
    yield


app = FastAPI(
    title="API de Proyección Académica",
    description="Backend para cálculo de demanda escolar y asignación asistida por IA.",
    version="1.0.0",
    lifespan=lifespan,
)

# 2. Permisos CORS para conectar con tu interfaz visual (Frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, cambia "*" por la URL de tu frontend
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# 3. Modelos de datos (Documentación automática en /docs)
class MateriaOut(BaseModel):
    clave: str
    nombre: str


class AlumnoOut(BaseModel):
    matricula: str
    nombre: str
    semestre_actual: int | None


# 4. Rutas (Endpoints)
@app.get("/", tags=["Estado"])
def verificar_estado():
    """Comprueba que el servidor esté activo."""
    return {"estado": "activo", "mensaje": "Backend académico funcionando"}


@app.get("/materias", response_model=list[MateriaOut], tags=["Catálogos"])
def listar_materias():
    """Devuelve todas las materias registradas en la base de datos."""
    with obtener_conexion() as conexion:
        filas = conexion.execute("SELECT clave, nombre FROM materias").fetchall()
    return [dict(fila) for fila in filas]


@app.get("/alumnos", response_model=list[AlumnoOut], tags=["Alumnos"])
def listar_alumnos():
    """Devuelve los alumnos ordenados por semestre y matrícula."""
    with obtener_conexion() as conexion:
        filas = conexion.execute(
            """
            SELECT matricula, nombre, semestre_actual
            FROM alumnos
            ORDER BY semestre_actual DESC
            """
        ).fetchall()
    return [dict(fila) for fila in filas]


@app.get("/proyeccion/{matricula}", tags=["Proyección IA"])
def proyectar_carga_alumno(matricula: str):
    """Endpoint base donde conectaremos el algoritmo de reglas duras y Ollama."""
    with obtener_conexion() as conexion:
        alumno = conexion.execute(
            "SELECT * FROM alumnos WHERE matricula = ?", (matricula,)
        ).fetchone()

    if not alumno:
        raise HTTPException(status_code=404, detail="Alumno no encontrado")

    return {
        "alumno": dict(alumno),
        "materias_sugeridas": [],
        "mensaje": "Pendiente conectar motor de reglas e IA",
    }