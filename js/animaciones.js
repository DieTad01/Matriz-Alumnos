// Espera a que la página esté lista.
document.addEventListener('DOMContentLoaded', () => {
    // Elementos que aparecerán suavemente al entrar.
    const elementos = document.querySelectorAll(
        '.dashboard-preview, .floating-card, .metric-card, .notice-card'
    );

    elementos.forEach((elemento, posicion) => {
        // Agrega la clase que contiene la animación en CSS.
        elemento.classList.add('animated-card');

        // Hace que cada elemento aparezca un poco después del anterior.
        elemento.style.transitionDelay = `${posicion * 70}ms`;

        // La clase visible activa el movimiento y la opacidad final.
        requestAnimationFrame(() => {
            elemento.classList.add('visible');
        });
    });
});
