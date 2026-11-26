// Sube la base de datos a la API y muestra los resultados.
document.addEventListener('DOMContentLoaded', () => {
    // Si la página no viene del servidor de la API, se usa su dirección local.
    const API = location.port === '8000' ? '' : 'http://127.0.0.1:8000';

    const formulario = document.getElementById('form-importar');
    const entrada = document.getElementById('archivo');
    const boton = document.getElementById('boton-importar');
    const estado = document.getElementById('estado');
    const resultados = document.getElementById('resultados');
    const descargar = document.getElementById('descargar');
    const total = document.getElementById('total-alumnos');

    // textContent evita que el contenido de la base se interprete como HTML.
    const crear = (etiqueta, texto) => {
        const elemento = document.createElement(etiqueta);
        elemento.textContent = texto;
        return elemento;
    };

    const limpiar = () => {
        resultados.hidden = true;
        total.textContent = '0';
        if (descargar.href) URL.revokeObjectURL(descargar.href);
        descargar.removeAttribute('href');
    };

    const mostrar = (datos) => {
        total.textContent = datos.resultados.length;

        document.getElementById('advertencias').replaceChildren(
            ...datos.advertencias.map((aviso) => crear('li', aviso))
        );

        document.getElementById('filas').replaceChildren(
            ...datos.resultados.map((r) => {
                const fila = document.createElement('tr');
                const pocos = r.creditos_totales < 20 ? ' (menos de 20)' : '';
                fila.append(
                    crear('td', r.alumno.matricula),
                    crear('td', r.alumno.nombre),
                    crear('td', r.alumno.semestre_actual),
                    crear('td', `${r.creditos_totales}${pocos}`),
                    crear('td', r.seleccion_laya.join(', ') || 'Sin materias pendientes')
                );
                return fila;
            })
        );

        // El Excel llega como texto base64; se convierte en un archivo descargable.
        const bytes = Uint8Array.from(atob(datos.excel_base64), (c) => c.charCodeAt(0));
        const excel = new Blob([bytes], {
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        });
        descargar.href = URL.createObjectURL(excel);
        resultados.hidden = false;
    };

    formulario.addEventListener('submit', async (evento) => {
        evento.preventDefault();
        const archivo = entrada.files[0];
        if (!archivo) return;

        limpiar();
        boton.disabled = true;
        estado.textContent = 'Procesando...';

        try {
            const respuesta = await fetch(
                `${API}/importar?nombre=${encodeURIComponent(archivo.name)}`,
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/octet-stream' },
                    body: archivo
                }
            );
            const datos = await respuesta.json().catch(() => ({}));
            if (!respuesta.ok) {
                const detalle = typeof datos.detail === 'string' ? datos.detail : '';
                estado.textContent = `Error: ${detalle || `el servidor respondió ${respuesta.status}`}`;
                return;
            }
            mostrar(datos);
            estado.textContent = 'Matriz generada.';
        } catch (error) {
            estado.textContent = error instanceof TypeError
                ? 'No se pudo conectar con el servidor. Revisa que la API esté encendida.'
                : `Error: ${error.message}`;
        } finally {
            boton.disabled = false;
        }
    });
});
