<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section = "header">
        <h1 class="wl-card__title">${msg("loginTotpTitle")}</h1>
    <#elseif section = "form">

    <p class="wl-card__subtitle">${msg("totpConfigSubtitle")}</p>

    <#-- Pasos para vincular la app de autenticacion -->
    <ol class="wl-totp-steps">
        <li>
            <p>${msg("loginTotpStep1")}</p>
            <ul class="wl-totp__apps">
                <#-- Compatibilidad de versiones:
                     - KC 22+: claves de mensaje en totp.supportedApplications  -> ${msg(app)}
                     - RH-SSO 7.6 / KC 18: strings ya traducidos en totp.policy.supportedApplications -> ${app}
                     Los parentesis en (...)?? cubren toda la expresion (no solo el ultimo paso). -->
                <#if (totp.supportedApplications)??>
                    <#list totp.supportedApplications as app>
                        <li>${msg(app)}</li>
                    </#list>
                <#elseif (totp.policy.supportedApplications)??>
                    <#list totp.policy.supportedApplications as app>
                        <li>${app}</li>
                    </#list>
                </#if>
            </ul>
        </li>

        <#if mode?? && mode = "manual">
            <li>
                <p>${msg("loginTotpManualStep2")}</p>
                <p><span class="wl-totp__secret" id="kc-totp-secret-key">${totp.totpSecretEncoded}</span></p>
                <p><a href="${totp.qrUrl}" id="mode-barcode" class="wl-link">${msg("loginTotpScanBarcode")}</a></p>
            </li>
            <li>
                <p>${msg("loginTotpManualStep3")}</p>
                <ul class="wl-totp__meta">
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
                <div class="wl-totp__qr-wrap">
                    <img class="wl-totp__qr" id="kc-totp-secret-qr-code"
                         src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="${msg('loginTotpStep2')}"/>
                </div>
                <p><a href="${totp.manualUrl}" id="mode-manual" class="wl-link">${msg("loginTotpUnableToScan")}</a></p>
            </li>
        </#if>

        <li>
            <p>${msg("loginTotpStep3")}</p>
        </li>
    </ol>

    <form id="kc-totp-settings-form" class="wl-form" action="${url.loginAction}" method="post">

        <div class="wl-field">
            <label for="totp-0" class="wl-field__label">${msg("authenticatorCode")} <span class="wl-required">*</span></label>

            <#-- Casillas visibles (no se envian): el JS vuelca su valor en el input oculto "totp" -->
            <div class="wl-otp" data-otp-input data-otp-target="totp" data-otp-length="6"
                 aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
                <#list 0..5 as i>
                    <#-- Sin autofocus: en esta pantalla de configuracion la tarjeta debe
                         abrir arriba (titulo + pasos + QR visibles), no desplazada al input. -->
                    <input id="totp-${i}" class="wl-otp__box" type="text" inputmode="numeric"
                           pattern="[0-9]*" maxlength="1" autocomplete="off"
                           aria-label="${msg('authenticatorCode')} ${i + 1}"
                           aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"/>
                </#list>
            </div>

            <#-- Valor real que procesa Keycloak -->
            <input type="hidden" id="totp" name="totp" class="wl-otp__hidden" autocomplete="off"/>
            <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}"/>
            <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}"/></#if>

            <#if messagesPerField.existsError('totp')>
                <span id="input-error-otp-code" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="wl-form__buttons">
            <#if isAppInitiatedAction??>
                <input type="submit" id="saveTOTPBtn" class="wl-btn" value="${msg('doSubmit')}"/>
                <button type="submit" id="cancelTOTPBtn" class="wl-btn wl-btn--ghost"
                        name="cancel-aia" value="true">${msg("doCancel")}</button>
            <#else>
                <input type="submit" id="saveTOTPBtn" class="wl-btn" value="${msg('doSubmit')}"/>
            </#if>
        </div>
    </form>

    </#if>
</@layout.registrationLayout>
