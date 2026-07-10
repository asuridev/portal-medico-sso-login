<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','email','firstName','lastName'); section>
    <#if section = "header">
        <h1 class="wl-card__title">${msg("loginProfileTitle")}</h1>
    <#elseif section = "form">

    <p class="wl-card__subtitle">${msg("updateProfileSubtitle")}</p>

    <form id="kc-update-profile-form" class="wl-form" action="${url.loginAction}" method="post">

        <#-- El campo de usuario solo se muestra si el realm permite editarlo (Edit username).
             En KC18/KC22 el modelo es de campos explicitos sobre el objeto user. -->
        <#if user.editUsernameAllowed>
            <div class="wl-field">
                <label for="username" class="wl-field__label">${msg("username")}</label>
                <input type="text" id="username" name="username" class="wl-field__input"
                       value="${(user.username!'')}" autofocus autocomplete="off"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"/>
                <#if messagesPerField.existsError('username')>
                    <span id="input-error-username" class="wl-field__error" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                </#if>
            </div>
        </#if>

        <div class="wl-field">
            <label for="email" class="wl-field__label">${msg("email")}</label>
            <input type="text" id="email" name="email" class="wl-field__input"
                   value="${(user.email!'')}" autocomplete="off"
                   aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"/>
            <#if messagesPerField.existsError('email')>
                <span id="input-error-email" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('email'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="wl-field">
            <label for="firstName" class="wl-field__label">${msg("firstName")}</label>
            <input type="text" id="firstName" name="firstName" class="wl-field__input"
                   value="${(user.firstName!'')}" autocomplete="off"
                   aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"/>
            <#if messagesPerField.existsError('firstName')>
                <span id="input-error-firstname" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                </span>
            </#if>
        </div>

        <div class="wl-field">
            <label for="lastName" class="wl-field__label">${msg("lastName")}</label>
            <input type="text" id="lastName" name="lastName" class="wl-field__input"
                   value="${(user.lastName!'')}" autocomplete="off"
                   aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"/>
            <#if messagesPerField.existsError('lastName')>
                <span id="input-error-lastname" class="wl-field__error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                </span>
            </#if>
        </div>

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
