<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section = "header">
        <h1 class="wl-card__title">${msg("otpCardTitle")}</h1>
    <#elseif section = "form">

    <p class="wl-card__subtitle">${msg("otpCardSubtitle")}</p>

    <form id="kc-otp-login-form" class="wl-form" onsubmit="login.disabled = true; return true;"
          action="${url.loginAction}" method="post">

        <#-- Seleccion de credencial OTP cuando el usuario tiene mas de una -->
        <#if otpLogin.userOtpCredentials?size gt 1>
            <div class="wl-otp-cred" role="radiogroup" aria-label="${msg('loginOtpOneTime')}">
                <#list otpLogin.userOtpCredentials as otpCredential>
                    <input id="kc-otp-credential-${otpCredential?index}" class="wl-otp-cred__radio"
                           type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                           <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>/>
                    <label for="kc-otp-credential-${otpCredential?index}" class="wl-otp-cred__label">
                        ${otpCredential.userLabel}
                    </label>
                </#list>
            </div>
        </#if>

        <div class="wl-field">
            <label for="otp-0" class="wl-field__label">${msg("loginOtpOneTime")}</label>

            <#-- Casillas visibles (no se envian): el JS vuelca su valor en el input oculto "otp" -->
            <div class="wl-otp" data-otp-input data-otp-length="6"
                 aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
                <#list 0..5 as i>
                    <input id="otp-${i}" class="wl-otp__box" type="text" inputmode="numeric"
                           pattern="[0-9]*" maxlength="1" autocomplete="<#if i == 0>one-time-code<#else>off</#if>"
                           <#if i == 0>autofocus</#if>
                           aria-label="${msg('loginOtpOneTime')} ${i + 1}"
                           aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"/>
                </#list>
            </div>

            <#-- Valor real que procesa Keycloak -->
            <input type="hidden" id="otp" name="otp" class="wl-otp__hidden" autocomplete="off"/>

            <#if messagesPerField.existsError('totp')>
                <span id="input-error-otp-code" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.getFirstError('totp'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="wl-form__buttons">
            <button name="login" id="kc-login" class="wl-btn" type="submit">
                <svg class="wl-btn__icon" viewBox="0 0 24 24" width="18" height="18" fill="none" aria-hidden="true">
                    <rect x="4" y="11" width="16" height="10" rx="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 11V8a4 4 0 0 1 8 0v3" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>${msg("doLogIn")}</span>
            </button>
        </div>
    </form>

    </#if>
</@layout.registrationLayout>
