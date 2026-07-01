# Tema de login Keycloak — Portal Médicos Cardif

Tema **solo de login** para Keycloak (v22 o anterior) que replica el diseño del
Portal Médicos Cardif (ver `design/full-page.jpg`). Incluye layout de dos columnas,
barra superior con reloj dinámico, banner promocional, tarjeta de login con
campo *Número de Documento* + contraseña con toggle de ojo, y diseño responsivo
para tablet y móvil.

## Estructura

```
themes/portal-medicos-cardif/
└── login/
    ├── theme.properties          # hereda de keycloak, registra CSS/JS, locales
    ├── template.ftl              # layout: barra fecha, header, fondo, banner, footer
    ├── login.ftl                # formulario de login
    ├── resources/
    │   ├── css/styles.css        # branding + layout responsivo
    │   ├── js/script.js          # reloj dinámico + toggle contraseña
    │   └── img/                   # logo-cardif.svg, icon.svg, background.jpg
    └── messages/
        ├── messages_es.properties
        └── messages_en.properties
```

## Validar con Docker

Requisitos: Docker + Docker Compose.

```bash
docker compose up -d
```

1. Abrir la consola de administración: <http://localhost:8080/> (usuario `admin`, clave `admin`).
2. Ir a **Manage realms** → seleccionar un realm (o crear uno de prueba).
3. **Realm settings → Themes → Login theme** → elegir `portal-medicos-cardif` → **Save**.
4. Probar la pantalla de login. La forma más simple:
   - En el realm, crear un usuario con contraseña, o
   - abrir el flujo de login de un cliente, por ejemplo la *Account Console*:
     `http://localhost:8080/realms/<realm>/account`
5. Comparar contra `design/full-page.jpg`.

### Iterar el diseño

La caché de temas está desactivada (`KC_SPI_THEME_CACHE_*=false`), así que basta con
**editar los archivos del tema y recargar el navegador** — no hace falta reiniciar el
contenedor (el tema está montado como volumen).

Para probar el responsivo, usar las DevTools del navegador (modo dispositivo) en:
desktop (≥1025px), tablet (768–1024px) y móvil (≤767px).

### Detener

```bash
docker compose down
```

## Notas de personalización

- **Colores:** definidos como variables CSS en `resources/css/styles.css` (`:root`):
  `--brand-green`, `--brand-lime`, etc. Ajustar ahí para afinar la paleta.
- **Fuente:** se usa *Oswald* (títulos) + *Open Sans* (cuerpo) vía Google Fonts como
  aproximación a BNPP Sans. Si se dispone de la fuente oficial, agregarla en
  `resources/` con `@font-face` y actualizar `--font-head` / `--font-body`.
- **Campo usuario:** "Número de Documento" mapea al campo `username` de Keycloak
  (relabelado en `messages/messages_es.properties`).
- **Acentos:** los archivos `messages_*.properties` usan escapes `\uXXXX` para los
  caracteres no-ASCII, porque Keycloak 22 lee los `.properties` como ISO-8859-1
  (usar UTF-8 directo produce *mojibake* tipo `NÃºmero`).
- **Idioma / selector:** para mostrar el login en español **sin** el selector de
  idioma (como en el diseño), en **Realm settings → Localization** habilita
  *Internationalization*, deja **solo** `es` en *Supported locales* y `es` como
  *Default locale*. El selector solo aparece cuando hay más de un idioma.
- **Producción:** para desplegar, copiar `themes/portal-medicos-cardif` al directorio
  `themes/` de la instancia Keycloak y seleccionar el tema en el realm. En producción
  se recomienda dejar la caché de temas activada (comportamiento por defecto).
