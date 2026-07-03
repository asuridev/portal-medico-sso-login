<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp','userLabel'); section>
    <#if section = "header">
        ${msg("loginTotpTitle")}
    <#elseif section = "form">

    <p class="pmc-card__subtitle">${msg("totpConfigSubtitle")}</p>

    <#-- Pasos para vincular la app de autenticacion -->
    <ol class="pmc-totp-steps">
        <li>
            <p>${msg("loginTotpStep1")}</p>
            <ul class="pmc-totp__apps">
                <#list totp.supportedApplications as app>
                    <li>${msg(app)}</li>
                </#list>
            </ul>
        </li>

        <#if mode?? && mode = "manual">
            <li>
                <p>${msg("loginTotpManualStep2")}</p>
                <p><span class="pmc-totp__secret" id="kc-totp-secret-key">${totp.totpSecretEncoded}</span></p>
                <p><a href="${totp.qrUrl}" id="mode-barcode" class="pmc-link">${msg("loginTotpScanBarcode")}</a></p>
            </li>
            <li>
                <p>${msg("loginTotpManualStep3")}</p>
                <ul class="pmc-totp__meta">
                    <li id="kc-totp-type">${msg("loginTotpType")}: ${msg("loginTotp." + totp.policy.type)}</li>
                    <li id="kc-totp-algorithm">${msg("loginTotpAlgorithm")}: ${totp.policy.getAlgorithmKey()}</li>
                    <li id="kc-totp-digits">${msg("loginTotpDigits")}: ${totp.policy.digits}</li>
                    <#if totp.policy.type = "totp">
                        <li id="kc-totp-period">${msg("loginTotpInterval")}: ${totp.policy.period}</li>
                    <#elseif totp.policy.type = "hotp">
                        <li id="kc-totp-counter">${msg("loginTotpCounter")}: ${totp.policy.initialCounter}</li>
                    </#if>
                </ul>
            </li>
        <#else>
            <li>
                <p>${msg("loginTotpStep2")}</p>
                <div class="pmc-totp__qr-wrap">
                    <img class="pmc-totp__qr" id="kc-totp-secret-qr-code"
                         src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="${msg('loginTotpStep2')}"/>
                </div>
                <p><a href="${totp.manualUrl}" id="mode-manual" class="pmc-link">${msg("loginTotpUnableToScan")}</a></p>
            </li>
        </#if>

        <li>
            <p>${msg("loginTotpStep3")}</p>
            <p>${msg("loginTotpStep3DeviceName")}</p>
        </li>
    </ol>

    <form id="kc-totp-settings-form" class="pmc-form" action="${url.loginAction}" method="post">

        <div class="pmc-field">
            <label for="totp-0" class="pmc-field__label">${msg("authenticatorCode")} <span class="pmc-required">*</span></label>

            <#-- Casillas visibles (no se envian): el JS vuelca su valor en el input oculto "totp" -->
            <div class="pmc-otp" data-otp-input data-otp-target="totp" data-otp-length="6"
                 aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
                <#list 0..5 as i>
                    <input id="totp-${i}" class="pmc-otp__box" type="text" inputmode="numeric"
                           pattern="[0-9]*" maxlength="1" autocomplete="off"
                           <#if i == 0>autofocus</#if>
                           aria-label="${msg('authenticatorCode')} ${i + 1}"
                           aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"/>
                </#list>
            </div>

            <#-- Valor real que procesa Keycloak -->
            <input type="hidden" id="totp" name="totp" class="pmc-otp__hidden" autocomplete="off"/>
            <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}"/>
            <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}"/></#if>

            <#if messagesPerField.existsError('totp')>
                <span id="input-error-otp-code" class="pmc-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="pmc-field">
            <label for="userLabel" class="pmc-field__label">${msg("loginTotpDeviceName")} <#if totp.otpCredentials?size gte 1><span class="pmc-required">*</span></#if></label>
            <input type="text" id="userLabel" name="userLabel" class="pmc-field__input" autocomplete="off"
                   aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>"/>
            <#if messagesPerField.existsError('userLabel')>
                <span id="input-error-otp-label" class="pmc-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('userLabel'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="pmc-remember">
            <label>
                <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked/>
                ${msg("logoutOtherSessions")}
            </label>
        </div>

        <div class="pmc-form__buttons">
            <#if isAppInitiatedAction??>
                <input type="submit" id="saveTOTPBtn" class="pmc-btn" value="${msg('doSubmit')}"/>
                <button type="submit" id="cancelTOTPBtn" class="pmc-btn pmc-btn--ghost"
                        name="cancel-aia" value="true">${msg("doCancel")}</button>
            <#else>
                <input type="submit" id="saveTOTPBtn" class="pmc-btn" value="${msg('doSubmit')}"/>
            </#if>
        </div>
    </form>

    </#if>
</@layout.registrationLayout>
