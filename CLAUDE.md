# CLAUDE.md

Guía para trabajar en este repositorio. Léela antes de modificar el tema.

## En qué consiste el proyecto

Tema **solo de login** para **Keycloak / Red Hat SSO** que replica la identidad del
**Portal de Médicos Cardif (BNP Paribas Cardif)**. No es una app web (no hay `package.json`,
bundler ni build): es un tema FreeMarker que se monta sobre el servidor de identidad y hereda del
tema base `keycloak` (PatternFly). Toda la autenticación la gestiona Keycloak; aquí solo vive la
capa de presentación.

Pantallas implementadas (todas comparten `template.ftl`: barra superior con reloj, header con logo,
banner promocional, tarjeta central y footer):

- `login/login.ftl` — inicio de sesión (Número de Documento + contraseña con toggle de ojo).
- `login/login-otp.ftl` — segundo factor (2FA) por código OTP, con **6 casillas segmentadas**
  (auto-avance, pegar-y-repartir) que vuelcan en un input oculto `name="otp"`.
- `login/login-config-totp.ftl` — configuración del autenticador: **escaneo del QR** + modo manual,
  reutilizando las casillas segmentadas sobre un input oculto `name="totp"`.

## ⛔ Versiones que se deben soportar de manera INVIOLABLE

> **Objetivo de producción: Red Hat SSO 7.6 (equivale a Keycloak 18.0.2).**
> Cualquier cambio en el tema DEBE renderizar y funcionar en esta versión. Es un requisito
> no negociable.

- **Mínimo soportado (obligatorio): RH-SSO 7.6 / Keycloak 18.0.2.**
- Debe seguir funcionando además hasta **Keycloak 22** (usado en el entorno local).
- **Nunca** introducir variables, métodos o macros de FreeMarker que existan solo en versiones
  posteriores a KC18 sin una guarda de compatibilidad. Ante una variable que pueda faltar, usar
  guarda con paréntesis que cubre toda la expresión:
  `<#if (obj.maybeMissing)??> ... <#else> ... </#if>`.

### Diferencias de versión ya resueltas (no reintroducir regresiones)

- **Lista de apps en `login-config-totp.ftl`**:
  - KC 22+: `totp.supportedApplications` → items son **claves de mensaje** → `${msg(app)}`.
  - RH-SSO 7.6 / KC 18: `totp.policy.supportedApplications` → items **ya traducidos** → `${app}`.
  - Se soportan ambas con `<#if (totp.supportedApplications)??> … <#elseif (totp.policy.supportedApplications)??> …`.
    Usar `totp.supportedApplications` sin guarda provoca un **error 500** en RH-SSO 7.6.
- **Checkbox `logout-sessions`** ("Cerrar sesión en otros dispositivos"): NO existe en KC18; se
  omite a propósito (en KC18 sería un control no funcional). No re-agregar sin guarda de versión.

## Convenciones del código

- **CSS**: `login/resources/css/styles.css`. CSS plano con BEM y prefijo `pmc-`. Paleta y tipografías
  como variables en `:root` (`--brand-green`, `--font-head` = Oswald, `--font-body` = Open Sans).
  Responsive en breakpoints 1024 / 820 / 767 px. Reutilizar clases/variables existentes; no añadir
  frameworks CSS.
- **JS**: `login/resources/js/script.js`. Vanilla, IIFE, degradación elegante. El componente de
  casillas OTP (`initOtpInputs`) soporta varios contenedores `[data-otp-input]` y vuelca en el hidden
  indicado por `data-otp-target` (fallback `otp`). Reutilizarlo, no duplicarlo.
- **Mensajes**: `login/messages/messages_{es,en}.properties`. ⚠️ Keycloak lee los `.properties` como
  **ISO-8859-1**: todo carácter no-ASCII debe ir como escape **`\uXXXX`** (UTF-8 directo produce
  mojibake tipo `NÃºmero`). Verificar con: `grep -nP '[^\x00-\x7F]' messages_es.properties` (no debe
  devolver nada).
- **Registro de recursos**: `login/theme.properties` (CSS/JS/locales). Las plantillas se descubren
  por nombre; no hace falta registrarlas.

## Validación local (podman-compose + Playwright)

`docker-compose.yml` levanta Keycloak 22 con el tema montado como volumen y la caché de temas
desactivada (basta recargar el navegador al iterar; no reiniciar el contenedor).

```bash
podman-compose -f docker-compose.yml up -d      # admin/admin en http://localhost:8080
# ... configurar realm/tema/usuario con kcadm.sh y validar con playwright-cli ...
podman-compose -f docker-compose.yml down
```

Notas de entorno (Windows / Git Bash):

- Para ejecutar rutas absolutas dentro del contenedor con `podman exec`, anteponer
  `export MSYS_NO_PATHCONV=1` (si no, Git Bash convierte `/opt/...` en `C:\Program Files\Git\opt\...`).
- Para llegar a la pantalla del QR: crear usuario con `requiredActions=["CONFIGURE_TOTP"]` y hacer
  login. Para llegar al 2FA (`login-otp.ftl`): el usuario debe tener ya una credencial OTP.
- Los códigos TOTP para las pruebas se generan con Python stdlib (`hmac`/`hashlib`/`base64`/`struct`)
  a partir del secreto que muestra el modo manual.
- **Validar SIEMPRE los cambios también en Keycloak 18.0.2** (RH-SSO 7.6), no solo en 22, arrancando
  un contenedor `quay.io/keycloak/keycloak:18.0.2` con el mismo tema montado y revisando los logs
  (`podman logs`) ante cualquier pantalla en blanco o error 500.

## Assets

`login/resources/img/`: `logo-cardif.svg` (header/footer/favicon), `icon.svg` (avatar de la tarjeta),
`background.jpg` (fondo). Copias de referencia del diseño en `design/`.
