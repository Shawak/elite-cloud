{extends file="index.tpl"}
{block name="title"}
    {PROJECT_NAME}
{/block}
{block name="content"}
    <header class="container-fluid animated fadeIn" id="header">
        <div class="logo">
            <img src="./frontend/img/elite-cloud-logo--invert.svg" alt="{PROJECT_NAME} Logo Invert">
        </div>
        <div class="navigation">
            <nav>
                <a href="#features" class="hidden-sm-down">Features</a>
                <a href="#statistics" class="hidden-sm-down">Statistiken</a>
                {if !LOGGED_IN}
                    <a href="#login" data-toggle="modal" data-target="#login"">Anmelden</a
                {else}
                    <a href="userscripts">Userscripts</a>
                    <a href="user/{LoginHandler::getInstance()->getUser()->getID()}">Profile</a>
                    <a href="#logout" ng-controller="LogoutController" ng-click="logout()">Logout</a>
                {/if}
            </nav>
            {if !LOGGED_IN}
                <a href="#register">
                    <button type="button" class="btn-primary btn">Registrieren</button>
                </a>
            {/if}
        </div>
    </header>
    <section id="hero">
        <div class="container">
            <img src="./frontend/img/elite-cloud-logo.svg" alt="{PROJECT_NAME} Logo" class="fadeInDown wow">
            <h3 class="slideInUp wow">Deine Online-Verwaltung für Userskripte auf elitepvpers</h3>
        </div>
    </section>
    <section id="features">
        <div class="container">
            <h1>Features</h1>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-rocket bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Schnell</span>
                    <p>Du brauchst nur unseren Loader installieren und hast sofort all deine Skripte inklusive
                        Einstellungen parat</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-cloud bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Weltweit</span>
                    <p>Du hast deine Skripte und Einstellungen weltweit verfügbar, egal an welchem Gerät</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-lock bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Sicher</span>
                    <p>All deine Skripte werden über das sichere HTTPS-Protokoll versendet und sind somit vollständig
                        mit elitepvpers kompatibel</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-magic bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Aktuell</span>
                    <p>Du musst dich nicht mehr um lästige Updates kümmern, da deine Skripte immer auf dem aktuellen
                        Stand sind</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-history bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Flexibel</span>
                    <p>Dank unserer Versionsverwaltung kannst du jederzeit zu älteren Skripten wechseln</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-github bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Open Source</span>
                    <p>Deine Spenden fließen direkt in das Projekt und du kannst mithelfen {PROJECT_NAME} zu
                        verbessern</p>
                </div>
            </div>
        </div>
    </section>
    <section id="statistics" class="hidden-sm-down">
        <div class="container">
            <h1>Statistiken</h1>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">100</span>
                    <span class="desc">Nutzer</span>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">50</span>
                    <span class="desc">verfügbare Skripte</span>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">3</span>
                    <span class="desc">Entwickler</span>
                </div>
            </div>
        </div>
    </section>
    {if !LOGGED_IN}
        <section id="register">
            <div class="container">
                <h1>Registrieren</h1>
                <form action="">
                    <div class="form-group row wow fadeIn">
                        <label for="benutzername" class="col-lg-3 offset-lg-2 form-control-label">Benutzername</label>
                        <div class="col-lg-4">
                            <input type="text" class="form-control" id="benutzername" placeholder="mind. 3 Zeichen"
                                   required
                                   pattern=".{ldelim} 3,{rdelim} ">
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="passwort" class="col-lg-3 offset-lg-2 form-control-label">Passwort</label>
                        <div class="col-lg-4">
                            <input type="password" class="form-control" id="passwort" required
                                   placeholder="mind. 8 Zeichen"
                                   pattern=".{ldelim} 8,{rdelim} ">
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="passwort2" class="col-lg-3 offset-lg-2 form-control-label">Passwort
                            wiederholen</label>
                        <div class="col-lg-4">
                            <input type="password" class="form-control" id="passwort2" required
                                   pattern=".{ldelim} 8,{rdelim} ">
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="email" class="col-lg-3 offset-lg-2 form-control-label">E-Mail</label>
                        <div class="col-lg-4">
                            <input type="email" class="form-control" id="email" required>
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="email2" class="col-lg-3 offset-lg-2 form-control-label">E-Mail wiederholen</label>
                        <div class="col-lg-4">
                            <input type="email" class="form-control" id="email2" required>
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="captcha" class="col-lg-3 offset-lg-2 form-control-label">Captcha</label>
                        <div class="col-lg-4">
                            // CAPTCHA
                        </div>
                    </div>
                    <div class="row wow bounceIn">
                        <div class="col-md-12">
                            <input type="submit" class="btn btn-lg btn-primary" name="submit" value="Registrieren">
                        </div>
                    </div>
                </form>
            </div>
        </section>
    {/if}
{/block}