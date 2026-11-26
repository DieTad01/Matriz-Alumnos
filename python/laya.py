def decidir_carga(alumno: dict, reglas: dict) -> dict:
    """Evalúa las opciones válidas y selecciona hasta 8 materias (mínimo 20 créditos)."""
    if reglas["detenido"]:
        return {
            "seleccion_laya": [m["clave"] for m in reglas["carga_ideal"]],
            "total_materias": len(reglas["carga_ideal"]),
            "creditos_totales": reglas["creditos_ideales"],
            "cumple_minimo": False,
            "justificacion": reglas["motivo"],
        }

    opciones = reglas["carga_ideal"] + reglas["margen_opciones"]

    seleccion = []
    creditos_acumulados = 0

    # Se respeta el orden de las reglas: primero especiales, luego rezago.
    for materia in opciones:
        if len(seleccion) < 8:
            seleccion.append(materia["clave"])
            creditos_acumulados += materia["creditos"]

    cumple_minimo = creditos_acumulados >= 20
    nota = (
        "Carga optimizada por rezago (entre 20 créditos y 8 materias)."
        if cumple_minimo
        else "Advertencia: el alumno tiene menos de 20 créditos disponibles por cursar."
    )

    return {
        "seleccion_laya": seleccion,
        "total_materias": len(seleccion),
        "creditos_totales": creditos_acumulados,
        "cumple_minimo": cumple_minimo,
        "justificacion": nota,
    }