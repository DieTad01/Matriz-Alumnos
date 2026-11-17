import json
import requests


def recomendar_con_ia(alumno: dict, proyeccion: dict, modelo: str = "mistral") -> dict:
    """Consulta a Ollama para balancear la carga académica entre opciones válidas."""
    if proyeccion["detenido"]:
        return {
            "seleccion_ia": [m["clave"] for m in proyeccion["carga_ideal"]],
            "justificacion": proyeccion["motivo"],
        }

    opciones = proyeccion["carga_ideal"] + proyeccion["margen_opciones"]
    prompt = f"""
    Eres un tutor académico universitario.
    Alumno: {alumno['nombre']}, Semestre: {alumno['semestre_actual']}, Promedio: {alumno['promedio']:.1f}.
    Materias válidas disponibles (clave, nombre, créditos, semestre):
    {json.dumps(opciones, ensure_ascii=False)}

    Elige una combinación que sume entre 24 y 32 créditos, priorizando materias atrasadas y equilibrando dificultad.
    Responde ÚNICAMENTE en JSON con esta estructura:
    {{"seleccion_ia": ["CLAVE1", "CLAVE2"], "justificacion": "Explicación breve"}}
    """

    try:
        resp = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": modelo, "prompt": prompt, "format": "json", "stream": False},
            timeout=30,
        )
        resp.raise_for_status()
        return json.loads(resp.json()["response"])
    except Exception as e:
        # Respaldo determinista si Ollama aún no está encendido
        return {
            "seleccion_ia": [m["clave"] for m in proyeccion["carga_ideal"]],
            "justificacion": f"Asignación automática por reglas (Ollama no disponible: {e})",
        }