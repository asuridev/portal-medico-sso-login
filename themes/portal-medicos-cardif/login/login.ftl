<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password'); section>
    <#if section = "header">
        ${msg("loginCardTitle")}
    <#elseif section = "form">

    <p class="pmc-card__subtitle">${msg("loginCardSubtitle")}</p>

    <#if realm.password>
        <form id="kc-form-login" class="pmc-form" onsubmit="login.disabled = true; return true;"
              action="${url.loginAction}" method="post">

            <#if !usernameHidden??>
                <div class="pmc-field">
                    <label for="username" class="pmc-field__label">${msg("usernameOrEmail")}</label>
                    <input tabindex="1" id="username" name="username" class="pmc-field__input"
                           value="${(login.username!'')}" type="text" autofocus autocomplete="off"
                           placeholder="${msg('usernamePlaceholder')}"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>
                </div>
            </#if>

            <div class="pmc-field">
                <label for="password" class="pmc-field__label">${msg("password")}</label>
                <div class="pmc-field__password">
                    <input tabindex="2" id="password" name="password" class="pmc-field__input"
                           type="password" autocomplete="off"
                           placeholder="${msg('passwordPlaceholder')}"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>
                    <button class="pmc-field__toggle" type="button" tabindex="-1"
                            data-password-toggle aria-controls="password"
                            aria-label="${msg('showPassword')}"
                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                        <svg class="pmc-eye" viewBox="0 0 24 24" width="22" height="22" fill="none" aria-hidden="true">
                            <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z" stroke="currentColor" stroke-width="2"/>
                            <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                        </svg>
                    </button>
                </div>
            </div>

            <#if messagesPerField.existsError('username','password')>
                <span id="input-error" class="pmc-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                </span>
            </#if>

            <#if realm.rememberMe && !usernameHidden??>
                <div class="pmc-remember">
                    <label>
                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox"
                               <#if login.rememberMe??>checked</#if>/> ${msg("rememberMe")}
                    </label>
                </div>
            </#if>

            <#if realm.resetPasswordAllowed>
                <div class="pmc-forgot">
                    <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="pmc-link">${msg("doForgotPassword")}</a>
                </div>
            </#if>

            <div class="pmc-form__buttons">
                <input type="hidden" id="id-hidden-input" name="credentialId"
                       <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                <input tabindex="4" name="login" id="kc-login" class="pmc-btn" type="submit" value="${msg("doLogIn")}"/>
            </div>
        </form>
    </#if>

    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}" class="pmc-link">${msg("doRegister")}</a></span>
        </#if>
    </#if>
</@layout.registrationLayout>
