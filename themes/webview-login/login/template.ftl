<#macro registrationLayout displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
    <meta name="robots" content="noindex, nofollow">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript" defer></script>
        </#list>
    </#if>
</head>

<body class="wl-body">
<#-- Layout minimal (webview): solo la tarjeta centrada sobre fondo gris neutro. -->
<main class="wl-page">
    <section class="wl-card">

        <#-- Titulo de la pagina (por-pagina via nested "header") -->
        <div class="wl-card__titles"><#nested "header"></div>

        <#-- Mensajes / alertas de Keycloak -->
        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
            <div class="wl-alert wl-alert--${message.type}">
                <span class="wl-alert__text">${kcSanitize(message.summary)?no_esc}</span>
            </div>
        </#if>

        <#nested "form">

        <#if auth?has_content && auth.showTryAnotherWayLink()>
            <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                <input type="hidden" name="tryAnotherWay" value="on"/>
                <a href="#" class="wl-link" id="try-another-way"
                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
            </form>
        </#if>

        <#if displayInfo>
            <div class="wl-card__info">
                <#nested "info">
            </div>
        </#if>
    </section>

    <#-- Selector de idioma discreto (solo si el realm tiene i18n con mas de un idioma) -->
    <#if realm.internationalizationEnabled && locale.supported?size gt 1>
        <div class="wl-locale">
            <select id="wl-locale-select" onchange="if(this.value)window.location.href=this.value;" aria-label="${msg('languages')!'idioma'}">
                <#list locale.supported as l>
                    <option value="${l.url}" <#if l.languageTag == locale.currentLanguageTag>selected</#if>>${l.label}</option>
                </#list>
            </select>
        </div>
    </#if>
</main>
</body>
</html>
</#macro>
