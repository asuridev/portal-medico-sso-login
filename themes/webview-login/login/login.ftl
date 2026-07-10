<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password'); section>
    <#if section = "header">
        <p class="wl-eyebrow">${msg("loginWelcome")}</p>
        <h1 class="wl-card__title">${msg("loginCardTitle")}</h1>
    <#elseif section = "form">

    <#if realm.password>
        <form id="kc-form-login" class="wl-form" onsubmit="login.disabled = true; return true;"
              action="${url.loginAction}" method="post">

            <#if !usernameHidden??>
                <div class="wl-field">
                    <label for="username" class="wl-field__label">${msg("usernameOrEmail")}</label>
                    <input tabindex="1" id="username" name="username" class="wl-field__input"
                           value="${(login.username!'')}" type="text" autofocus autocomplete="username"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>
                </div>
            </#if>

            <div class="wl-field">
                <label for="password" class="wl-field__label">${msg("password")}</label>
                <div class="wl-field__password">
                    <input tabindex="2" id="password" name="password" class="wl-field__input"
                           type="password" autocomplete="current-password"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>
                    <button class="wl-field__toggle" type="button" tabindex="-1"
                            data-password-toggle aria-controls="password"
                            aria-label="${msg('showPassword')}"
                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                        <svg class="wl-eye" viewBox="0 0 24 24" width="22" height="22" fill="none" aria-hidden="true">
                            <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z" stroke="currentColor" stroke-width="2"/>
                            <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                        </svg>
                    </button>
                </div>
            </div>

            <#if messagesPerField.existsError('username','password')>
                <span id="input-error" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                </span>
            </#if>

            <#if realm.rememberMe && !usernameHidden??>
                <div class="wl-remember">
                    <label>
                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox"
                               <#if login.rememberMe??>checked</#if>/> ${msg("rememberMe")}
                    </label>
                </div>
            </#if>

            <#if realm.resetPasswordAllowed>
                <div class="wl-forgot">
                    <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="wl-link">${msg("doForgotPassword")}</a>
                </div>
            </#if>

            <div class="wl-form__buttons">
                <input type="hidden" id="id-hidden-input" name="credentialId"
                       <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                <button tabindex="4" name="login" id="kc-login" class="wl-btn" type="submit">
                    <svg class="wl-btn__icon" viewBox="0 0 24 24" width="18" height="18" fill="none" aria-hidden="true">
                        <rect x="4" y="11" width="16" height="10" rx="2" stroke="currentColor" stroke-width="2"/>
                        <path d="M8 11V8a4 4 0 0 1 8 0v3" stroke="currentColor" stroke-width="2"/>
                    </svg>
                    <span>${msg("doLogIn")}</span>
                </button>
            </div>
        </form>
    </#if>

    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}" class="wl-link">${msg("doRegister")}</a></span>
        </#if>
    </#if>
</@layout.registrationLayout>
