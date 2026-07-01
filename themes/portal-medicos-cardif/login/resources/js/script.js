(function () {
    "use strict";

    /* ----------------------------------------------------------------------
     * Reloj dinamico de la barra superior
     * Formato similar al diseno: "VIERNES 24/07/2026 05:00 a.m."
     * -------------------------------------------------------------------- */
    function initClock() {
        var el = document.getElementById("pmc-clock");
        if (!el) return;

        var locale = el.getAttribute("data-locale") || "es";

        function pad(n) { return n < 10 ? "0" + n : String(n); }

        function render() {
            var now = new Date();
            var weekday;
            try {
                weekday = now.toLocaleDateString(locale, { weekday: "long" });
            } catch (e) {
                weekday = now.toLocaleDateString("es", { weekday: "long" });
            }
            weekday = weekday.toUpperCase();

            var date = pad(now.getDate()) + "/" + pad(now.getMonth() + 1) + "/" + now.getFullYear();

            var hours = now.getHours();
            var meridiem = hours < 12 ? "a.m." : "p.m.";
            var h12 = hours % 12;
            if (h12 === 0) h12 = 12;
            var time = pad(h12) + ":" + pad(now.getMinutes()) + " " + meridiem;

            el.textContent = weekday + " " + date + " " + time;
        }

        render();
        setInterval(render, 1000 * 30);
    }

    /* ----------------------------------------------------------------------
     * Toggle de visibilidad de contrasena (icono de ojo)
     * -------------------------------------------------------------------- */
    function initPasswordToggles() {
        var toggles = document.querySelectorAll("[data-password-toggle]");
        Array.prototype.forEach.call(toggles, function (btn) {
            var targetId = btn.getAttribute("aria-controls");
            var input = targetId ? document.getElementById(targetId) : null;
            if (!input) return;

            btn.addEventListener("click", function () {
                var showing = input.getAttribute("type") === "text";
                input.setAttribute("type", showing ? "password" : "text");
                var label = showing
                    ? (btn.getAttribute("data-label-show") || "Mostrar")
                    : (btn.getAttribute("data-label-hide") || "Ocultar");
                btn.setAttribute("aria-label", label);
                btn.classList.toggle("is-visible", !showing);
            });
        });
    }

    function init() {
        initClock();
        initPasswordToggles();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
