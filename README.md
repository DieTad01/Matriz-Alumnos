# Matriz-Alumnos
Proyecto de Fundamentos de Ingenieria de Software

# Tecnologias
html
js
css
python

<<<<<<< HEAD
1. Base de datos
=======
# Instalaciones del entorno virtual
## Entorno virtual
'''bash
python -m venv venv
'''

### Ejecutar actualizacion de pip
'''bash
python.exe -m pip install --upgrade pip
'''

## Instalacion de dependecias
'''bash
python -m venv venv
'''


1. Primer etapa
>>>>>>> f542aa4a9e499efa9af76f5c47a7fe38b31b327b
La base SQLite se creó en [alumnos.sqlite3]. Su esquema contempla alumnos, intentos académicos, materias, retículas, especialidades y relaciones de prerrequisito. El historial permite registrar varios intentos por materia y separar calificación numérica de textual, como el código `ACA` de la boleta. 

También quedaron cargados el programa y las dos opciones de especialidad con sus versiones de retícula. 

Aún no cargué al alumno ni el catálogo completo de materias y flechas; así evitamos asumir equivalencias, como las claves distintas de Cálculo Diferencial. El archivo SQLite se excluye de Git para que los datos académicos que agreguemos después no se suban por accidente.
