# Usuario de prueba

El contenedor de Keycloak trae **sembrado automáticamente** un realm de prueba (`test`) con un
usuario listo para validar el flujo de login. No hay que crear nada a mano: el realm y el usuario se
importan al arrancar desde `keycloak/import/realm-test.json` (opción `--import-realm` del
`docker-compose.yml`).

## Requisitos

- Podman + podman-compose (o Docker + Docker Compose).

## Levantar el entorno

```bash
podman-compose -f docker-compose.yml up -d
# equivalente con Docker:
# docker compose up -d
```

Espera unos segundos a que Keycloak termine de arrancar (`http://localhost:8080/` responde).

## Acceso

**URL:** <http://localhost:8080/realms/test/account/> → pulsa **"Iniciar sesión"**.

| Campo | Valor |
|-------|-------|
| Número de Documento | `test` |
| Contraseña | `test123` |

## Flujo esperado

1. **Inicio de sesión** — Número de Documento + contraseña (con toggle de ojo).
2. **Configura tu aplicación de autenticación** — pantalla del **código QR**. Escanéalo con una app
   TOTP del móvil (Google Authenticator, Microsoft Authenticator o FreeOTP). Si no puedes escanear,
   usa **"¿No puedes escanear el código?"** para ver la clave manual. Ingresa el código de 6 dígitos,
   asigna un nombre de dispositivo y pulsa **Enviar**.
3. **Verificación en dos pasos** — en los siguientes inicios de sesión pedirá el código OTP en las 6
   casillas.
4. Entra al portal (Account Console).

> Para pasar del paso 2 necesitas una app de autenticación TOTP en el móvil.

## Consola de administración

<http://localhost:8080/> → usuario `admin`, contraseña `admin`.

## Reiniciar el usuario a estado limpio

El usuario se siembra pidiendo configurar OTP. Para volver a ese estado inicial (por ejemplo, para
repetir el flujo del QR desde cero):

```bash
podman-compose -f docker-compose.yml down
podman-compose -f docker-compose.yml up -d
```

Alternativamente, en la consola admin: realm `test` → **Users** → `test` → **Credentials** → eliminar
la credencial OTP.

## Detener el entorno

```bash
podman-compose -f docker-compose.yml down
```

## Notas

- Las credenciales del usuario de prueba y la configuración del realm viven en
  `keycloak/import/realm-test.json` (versionado). Editar ahí si se quiere cambiar el usuario.
- El realm está fijado en **español** (locale por defecto `es`).
- Keycloak 18.0.2 se usa por ser el equivalente de **Red Hat SSO 7.6**, la versión objetivo de
  producción (ver `CLAUDE.md`).
