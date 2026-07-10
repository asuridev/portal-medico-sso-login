<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        <h1 class="wl-card__title">${msg("updatePasswordTitle")}</h1>
    <#elseif section = "form">

    <p class="wl-card__subtitle">${msg("updatePasswordSubtitle")}</p>

    <form id="kc-passwd-update-form" class="wl-form" action="${url.loginAction}" method="post">

        <#-- Campos ocultos que espera Keycloak: usuario + contrasena actual (para gestores) -->
        <input type="text" id="username" name="username" value="${(username!'')}"
               autocomplete="username" readonly="readonly" style="display:none;"/>
        <input type="password" id="password" name="password" autocomplete="current-password"
               style="display:none;"/>

        <div class="wl-field">
            <label for="password-new" class="wl-field__label">${msg("passwordNew")}</label>
            <div class="wl-field__password">
                <input tabindex="1" id="password-new" name="password-new" class="wl-field__input"
                       type="password" autocomplete="new-password" autofocus
                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"/>
                <button class="wl-field__toggle" type="button" tabindex="-1"
                        data-password-toggle aria-controls="password-new"
                        aria-label="${msg('showPassword')}"
                        data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                    <svg class="wl-eye" viewBox="0 0 24 24" width="22" height="22" fill="none" aria-hidden="true">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z" stroke="currentColor" stroke-width="2"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                    </svg>
                </button>
            </div>
            <#if messagesPerField.existsError('password')>
                <span id="input-error-password" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('password'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="wl-field">
            <label for="password-confirm" class="wl-field__label">${msg("passwordConfirm")}</label>
            <div class="wl-field__password">
                <input tabindex="2" id="password-confirm" name="password-confirm" class="wl-field__input"
                       type="password" autocomplete="new-password"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"/>
                <button class="wl-field__toggle" type="button" tabindex="-1"
                        data-password-toggle aria-controls="password-confirm"
                        aria-label="${msg('showPassword')}"
                        data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                    <svg class="wl-eye" viewBox="0 0 24 24" width="22" height="22" fill="none" aria-hidden="true">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z" stroke="currentColor" stroke-width="2"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                    </svg>
                </button>
            </div>
            <#if messagesPerField.existsError('password-confirm')>
                <span id="input-error-password-confirm" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                </span>
            </#if>
        </div>

        <#-- El checkbox de cerrar otras sesiones solo existe en acciones iniciadas por la app.
             En KC18/KC22 se renderiza explicitamente (no via macro passwordCommons). -->
        <#if isAppInitiatedAction??>
            <div class="wl-remember">
                <label>
                    <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked/>
                    ${msg("logoutOtherSessions")}
                </label>
            </div>
        </#if>

        <div class="wl-form__buttons">
            <#if isAppInitiatedAction??>
                <input type="submit" class="wl-btn" value="${msg('doSubmit')}"/>
                <button type="submit" class="wl-btn wl-btn--ghost"
                        name="cancel-aia" value="true">${msg("doCancel")}</button>
            <#else>
                <input type="submit" class="wl-btn" value="${msg('doSubmit')}"/>
            </#if>
        </div>
    </form>

    </#if>
</@layout.registrationLayout>
