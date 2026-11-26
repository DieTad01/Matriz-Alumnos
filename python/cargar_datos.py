import pandas as pd
from database import inicializar_base_datos, obtener_conexion


def poblar_desde_excel(ruta_excel: str = "matriz sistemas agodic26.xlsx"):
    """Carga el catálogo de materias del Excel y crea datos de prueba."""
    inicializar_base_datos()
    df = pd.read_excel(ruta_excel, sheet_name="sistemas")

    with obtener_conexion() as conn:
        reticula = conn.execute(
            "SELECT id, especialidad_id FROM reticulas WHERE clave = ?",
            ("ISIE-SIA-2024-03",),
        ).fetchone()
        programa = conn.execute("SELECT id FROM programas LIMIT 1").fetchone()

        # 1. Insertar materias del Excel y vincularlas a la retícula
        for nodo, fila in df.iterrows():
            clave = str(fila.iloc[0]).strip()
            nombre = str(fila.iloc[1]).strip()

            conn.execute(
                "INSERT OR IGNORE INTO materias (clave, nombre) VALUES (?, ?)",
                (clave, nombre),
            )
            mat_id = conn.execute(
                "SELECT id FROM materias WHERE clave = ?", (clave,)
            ).fetchone()["id"]

            semestre_est = min((nodo // 7) + 1, 9)
            conn.execute(
                """
                INSERT OR IGNORE INTO materias_reticula
                    (reticula_id, materia_id, numero_nodo, semestre_sugerido, creditos)
                VALUES (?, ?, ?, ?, 5)
                """,
                (reticula["id"], mat_id, nodo + 1, semestre_est),
            )

        # 2. Ejemplo de prerrequisito: Cálculo Diferencial -> Cálculo Integral
        mr_dif = conn.execute(
            """SELECT mr.id FROM materias_reticula mr JOIN materias m ON m.id = mr.materia_id
               WHERE m.clave = 'ACF2301' AND mr.reticula_id = ?""",
            (reticula["id"],),
        ).fetchone()
        mr_int = conn.execute(
            """SELECT mr.id FROM materias_reticula mr JOIN materias m ON m.id = mr.materia_id
               WHERE m.clave = 'ACF0902' AND mr.reticula_id = ?""",
            (reticula["id"],),
        ).fetchone()
        if mr_dif and mr_int:
            conn.execute(
                "INSERT OR IGNORE INTO prerrequisitos VALUES (?, ?, ?)",
                (reticula["id"], mr_int["id"], mr_dif["id"]),
            )

        # 3. Alumnos de prueba
        conn.execute(
            """INSERT OR IGNORE INTO alumnos
               (matricula, nombre, programa_id, especialidad_actual_id, semestre_actual)
               VALUES (?, ?, ?, ?, ?)""",
            ("21240001", "Ana López", programa["id"], reticula["especialidad_id"], 8),
        )
        conn.execute(
            """INSERT OR IGNORE INTO alumnos
               (matricula, nombre, programa_id, especialidad_actual_id, semestre_actual)
               VALUES (?, ?, ?, ?, ?)""",
            ("20240099", "Carlos Ruiz", programa["id"], reticula["especialidad_id"], 10),
        )

        # Simular 2 especiales para Carlos (freno del algoritmo)
        carlos_id = conn.execute(
            "SELECT id FROM alumnos WHERE matricula = '20240099'"
        ).fetchone()["id"]
        for clave_esp in ("ACF2301", "AED1285"):
            m_id = conn.execute(
                "SELECT id FROM materias WHERE clave = ?", (clave_esp,)
            ).fetchone()["id"]
            conn.execute(
                """INSERT OR IGNORE INTO intentos_academicos
                   (alumno_id, materia_id, numero_intento, periodo, tipo_intento, calificacion_numerica, resultado)
                   VALUES (?, ?, 3, '2026-1', 'especial', 60, 'reprobada')""",
                (carlos_id, m_id),
            )


if __name__ == "__main__":
    poblar_desde_excel()
    print("Base de datos poblada correctamente.")