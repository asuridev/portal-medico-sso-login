(function () {
    "use strict";

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

    /* ----------------------------------------------------------------------
     * Casillas segmentadas de OTP
     * Las casillas visibles no se envian; su concatenacion se vuelca en el
     * input oculto que procesa Keycloak. El id de ese input oculto se toma de
     * data-otp-target (por defecto "otp"), para reutilizar el componente tanto
     * en el segundo factor (name="otp") como en el alta/QR (name="totp").
     * -------------------------------------------------------------------- */
    function bindOtpContainer(container) {
        var boxes = Array.prototype.slice.call(container.querySelectorAll(".wl-otp__box"));
        var targetId = container.getAttribute("data-otp-target") || "otp";
        var hidden = document.getElementById(targetId);
        if (!boxes.length || !hidden) return;

        function sync() {
            hidden.value = boxes.map(function (b) { return b.value; }).join("");
        }

        function focusBox(idx) {
            if (idx >= 0 && idx < boxes.length) {
                boxes[idx].focus();
                boxes[idx].select();
            }
        }

        boxes.forEach(function (box, idx) {
            box.addEventListener("input", function () {
                // Conservar solo el ultimo digito tecleado
                var digits = box.value.replace(/\D/g, "");
                box.value = digits ? digits.charAt(digits.length - 1) : "";
                if (box.value && idx < boxes.length - 1) focusBox(idx + 1);
                sync();
            });

            box.addEventListener("keydown", function (e) {
                if (e.key === "Backspace") {
                    if (box.value) {
                        box.value = "";
                        sync();
                    } else if (idx > 0) {
                        e.preventDefault();
                        boxes[idx - 1].value = "";
                        focusBox(idx - 1);
                        sync();
                    }
                } else if (e.key === "ArrowLeft" && idx > 0) {
                    e.preventDefault();
                    focusBox(idx - 1);
                } else if (e.key === "ArrowRight" && idx < boxes.length - 1) {
                    e.preventDefault();
                    focusBox(idx + 1);
                }
            });

            box.addEventListener("focus", function () { box.select(); });

            box.addEventListener("paste", function (e) {
                e.preventDefault();
                var text = (e.clipboardData || window.clipboardData).getData("text") || "";
                var digits = text.replace(/\D/g, "").split("");
                if (!digits.length) return;
                for (var i = idx; i < boxes.length && digits.length; i++) {
                    boxes[i].value = digits.shift();
                }
                var next = Math.min(idx + text.replace(/\D/g, "").length, boxes.length - 1);
                focusBox(next);
                sync();
            });
        });

        sync();
    }

    function initOtpInputs() {
        var containers = document.querySelectorAll("[data-otp-input]");
        Array.prototype.forEach.call(containers, bindOtpContainer);
    }

    function init() {
        initPasswordToggles();
        initOtpInputs();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
