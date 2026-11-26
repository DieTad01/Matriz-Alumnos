from itertools import combinations
from database import RUTA_BASE_DATOS, obtener_conexion


def evaluar_alumno(conn, alumno: dict) -> dict:
    """Aplica las reglas duras de retícula, especiales y límite de 4 a 8 materias."""
    alumno_id = alumno["id"]

    ret = conn.execute(
        "SELECT id FROM reticulas WHERE especialidad_id = ? LIMIT 1",
        (alumno["especialidad_actual_id"],),
    ).fetchone() or conn.execute("SELECT id FROM reticulas LIMIT 1").fetchone()
    reticula_id = ret["id"]

    aprobadas = {
        r["materia_id"]
        for r in conn.execute(
            "SELECT DISTINCT materia_id FROM intentos_academicos WHERE alumno_id = ? AND resultado = 'aprobada'",
            (alumno_id,),
        ).fetchall()
    }

    # Regla 2: Verificar especiales pendientes
    especiales_rows = conn.execute(
        """
        SELECT DISTINCT m.id, m.clave, m.nombre,
               COALESCE(mr.creditos, 5) AS creditos,
               COALESCE(mr.semestre_sugerido, 1) AS semestre_sugerido
        FROM intentos_academicos i
        JOIN materias m ON m.id = i.materia_id
        LEFT JOIN materias_reticula mr ON mr.materia_id = m.id AND mr.reticula_id = ?
        WHERE i.alumno_id = ? AND i.tipo_intento = 'especial'
        """,
        (reticula_id, alumno_id),
    ).fetchall()
    especiales = [dict(r) for r in especiales_rows if r["id"] not in aprobadas]

    if len(especiales) >= 2:
        creditos_esp = sum(m["creditos"] for m in especiales[:2])
        return {
            "detenido": True,
            "motivo": "Tiene 2 o más materias en especial; solo puede cursar esas.",
            "carga_ideal": especiales[:2],
            "margen_opciones": [],
            "creditos_ideales": creditos_esp,
            "cumple_minimo": creditos_esp >= 20,
        }

    # Regla 3: Filtrar materias no aprobadas con prerrequisitos cumplidos
    catalogo = conn.execute(
        """
        SELECT mr.id AS mr_id, m.id, m.clave, m.nombre,
               COALESCE(mr.semestre_sugerido, 99) AS semestre_sugerido,
               mr.creditos
        FROM materias_reticula mr
        JOIN materias m ON m.id = mr.materia_id
        WHERE mr.reticula_id = ?
        """,
        (reticula_id,),
    ).fetchall()

    prereqs_rows = conn.execute(
        """
        SELECT p.materia_reticula_id, req_mr.materia_id AS req_id
        FROM prerrequisitos p
        JOIN materias_reticula req_mr ON req_mr.id = p.requisito_reticula_id
        WHERE p.reticula_id = ?
        """,
        (reticula_id,),
    ).fetchall()

    mapa_prereqs = {}
    for r in prereqs_rows:
        mapa_prereqs.setdefault(r["materia_reticula_id"], set()).add(r["req_id"])

    ids_especiales = {m["id"] for m in especiales}
    desbloqueadas = []
    for mat in catalogo:
        if mat["id"] in aprobadas or mat["id"] in ids_especiales:
            continue
        reqs = mapa_prereqs.get(mat["mr_id"], set())
        if reqs.issubset(aprobadas):
            desbloqueadas.append(dict(mat))

    # Regla 4: Priorizar rezago
    desbloqueadas.sort(key=lambda x: x["semestre_sugerido"])

    # Regla 5 y 6: Hasta 8 materias ideales + 4 de margen para que Laya elija
    carga_ideal = list(especiales)
    margen_opciones = []

    for mat in desbloqueadas:
        if len(carga_ideal) < 8:
            carga_ideal.append(mat)
        elif len(margen_opciones) < 4:
            margen_opciones.append(mat)

    creditos_ideales = sum(m["creditos"] for m in carga_ideal)
    return {
        "detenido": False,
        "motivo": "Carga calculada respetando prerrequisitos (mínimo 20 créditos, máximo 8 materias).",
        "carga_ideal": carga_ideal,
        "margen_opciones": margen_opciones,
        "creditos_ideales": creditos_ideales,
        "cumple_minimo": creditos_ideales >= 20,
    }


def generar_proyeccion_global(ruta=RUTA_BASE_DATOS) -> dict:
    """Procesa todos los alumnos ordenados y construye la matriz triangular."""
    with obtener_conexion(ruta) as conn:
        alumnos = conn.execute(
            """
            SELECT a.id, a.matricula, a.nombre, a.semestre_actual, a.especialidad_actual_id,
                   COALESCE(AVG(i.calificacion_numerica), 0) AS promedio
            FROM alumnos a
            LEFT JOIN intentos_academicos i ON i.alumno_id = a.id
            WHERE a.semestre_actual <= 14
            GROUP BY a.id
            ORDER BY a.semestre_actual DESC, promedio DESC
            """
        ).fetchall()

        resultados = []
        matriz_coocurrencia = {}

        for al in alumnos:
            al_dict = dict(al)
            eval_al = evaluar_alumno(conn, al_dict)
            resultados.append({"alumno": al_dict, **eval_al})

            claves = sorted(m["clave"] for m in eval_al["carga_ideal"])
            for c1, c2 in combinations(claves, 2):
                par = f"{c1} <-> {c2}"
                matriz_coocurrencia[par] = matriz_coocurrencia.get(par, 0) + 1

    choques_ordenados = sorted(
        matriz_coocurrencia.items(), key=lambda x: x[1], reverse=True
    )
    return {"proyecciones": resultados, "choques_potenciales": choques_ordenados}