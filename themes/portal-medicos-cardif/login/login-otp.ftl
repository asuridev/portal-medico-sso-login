<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section = "header">
        ${msg("otpCardTitle")}
    <#elseif section = "form">

    <p class="pmc-card__subtitle">${msg("otpCardSubtitle")}</p>

    <form id="kc-otp-login-form" class="pmc-form" onsubmit="login.disabled = true; return true;"
          action="${url.loginAction}" method="post">

        <#-- Selección de credencial OTP cuando el usuario tiene más de una -->
        <#if otpLogin.userOtpCredentials?size gt 1>
            <div class="pmc-otp-cred" role="radiogroup" aria-label="${msg('loginOtpOneTime')}">
                <#list otpLogin.userOtpCredentials as otpCredential>
                    <input id="kc-otp-credential-${otpCredential?index}" class="pmc-otp-cred__radio"
                           type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                           <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>/>
                    <label for="kc-otp-credential-${otpCredential?index}" class="pmc-otp-cred__label">
                        ${otpCredential.userLabel}
                    </label>
                </#list>
            </div>
        </#if>

        <div class="pmc-field">
            <label for="otp-0" class="pmc-field__label">${msg("loginOtpOneTime")}</label>

            <#-- Casillas visibles (no se envían): el JS vuelca su valor en el input oculto "otp" -->
            <div class="pmc-otp" data-otp-input data-otp-length="6"
                 aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
                <#list 0..5 as i>
                    <input id="otp-${i}" class="pmc-otp__box" type="text" inputmode="numeric"
                           pattern="[0-9]*" maxlength="1" autocomplete="<#if i == 0>one-time-code<#else>off</#if>"
                           <#if i == 0>autofocus</#if>
                           aria-label="${msg('loginOtpOneTime')} ${i + 1}"
                           aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"/>
                </#list>
            </div>

            <#-- Valor real que procesa Keycloak -->
            <input type="hidden" id="otp" name="otp" class="pmc-otp__hidden" autocomplete="off"/>

            <#if messagesPerField.existsError('totp')>
                <span id="input-error-otp-code" class="pmc-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.getFirstError('totp'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="pmc-form__buttons">
            <input name="login" id="kc-login" class="pmc-btn" type="submit" value="${msg("doLogIn")}"/>
        </div>
    </form>

    </#if>
</@layout.registrationLayout>
