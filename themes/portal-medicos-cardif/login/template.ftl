<#macro registrationLayout displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
    <meta name="robots" content="noindex, nofollow">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/logo-cardif.svg"/>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@500;600;700&family=Open+Sans:wght@400;600;700&display=swap" rel="stylesheet">

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

<body class="pmc-body">
<div class="pmc-page">

    <#-- Barra superior verde con reloj dinamico -->
    <div class="pmc-topbar">
        <span id="pmc-clock" class="pmc-clock" data-locale="${(locale.currentLanguageTag)!'es'}"></span>
    </div>

    <#-- Header -->
    <header class="pmc-header">
        <div class="pmc-header__brand">
            <img class="pmc-header__logo" src="${url.resourcesPath}/img/logo-cardif.svg" alt="BNP Paribas Cardif"/>
            <span class="pmc-header__divider"></span>
            <span class="pmc-header__portal">${msg("brandHeaderPortal")}</span>
        </div>
        <div class="pmc-header__tagline">${msg("brandTagline")}</div>

        <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
            <div class="pmc-locale">
                <select id="pmc-locale-select" onchange="if(this.value)window.location.href=this.value;" aria-label="language">
                    <#list locale.supported as l>
                        <option value="${l.url}" <#if l.languageTag == locale.currentLanguageTag>selected</#if>>${l.label}</option>
                    </#list>
                </select>
            </div>
        </#if>
    </header>

    <#-- Cuerpo: fondo + banner + tarjeta de login -->
    <main class="pmc-main">
        <section class="pmc-banner">
            <h2 class="pmc-banner__title">${msg("bannerTitle")}</h2>
            <p class="pmc-banner__text">${msg("bannerText")}</p>
        </section>

        <section class="pmc-card">
            <div class="pmc-card__avatar">
                <img src="${url.resourcesPath}/img/icon.svg" alt=""/>
            </div>

            <#-- Titulo de la pagina (por-pagina via nested "header") -->
            <h1 class="pmc-card__title"><#nested "header"></h1>

            <#-- Mensajes / alertas de Keycloak -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="pmc-alert pmc-alert--${message.type}">
                    <span class="pmc-alert__text">${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <#nested "form">

            <#if auth?has_content && auth.showTryAnotherWayLink()>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                    <input type="hidden" name="tryAnotherWay" value="on"/>
                    <a href="#" class="pmc-link" id="try-another-way"
                       onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                </form>
            </#if>

            <#if displayInfo>
                <div class="pmc-card__info">
                    <#nested "info">
                </div>
            </#if>
        </section>
    </main>

    <#-- Footer -->
    <footer class="pmc-footer">
        <div class="pmc-footer__brand">
            <img class="pmc-footer__logo" src="${url.resourcesPath}/img/logo-cardif.svg" alt="BNP Paribas Cardif"/>
            <span class="pmc-footer__tagline">${msg("brandTagline")}</span>
        </div>
        <div class="pmc-footer__copyright">${msg("brandCopyright")}</div>
    </footer>

</div>
</body>
</html>
</#macro>
