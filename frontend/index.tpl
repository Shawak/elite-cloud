<!doctype html>
<!--[if lt IE 7]>
<html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>
<html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>
<html class="no-js lt-ie9" lang="en"> <![endif]-->
<html class="no-js" lang="en" ng-app="elite-cloud">

<head>

    <!--
    *******************

    {PROJECT_NAME}

    Autor: LeKoArts (https://www.lekoarts.de), Shawak
    (c) Copyright 2016

    ******************
    -->

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <base href="{URL_BASE}">

    <!-- Titel -->
    <title>{PROJECT_NAME}</title>

    <!-- Beschreibung -->
    <meta name="description" content="{PROJECT_NAME} - Deine Online-Verwaltung für Userskripte auf elitepvpers">

    <!-- Allgemein -->
    <meta name="publisher" content="{PROJECT_NAME}">
    <meta name="author" content="{PROJECT_NAME}">
    <meta name="keywords" content="{PROJECT_NAME}, elitepvpers, Userscripte, Greasemonkey, Tampermonkey">
    <link rel="canonical" href="http://www.elite-cloud.de">

    <!-- Facebook -->
    <meta property="og:url" content="http://www.elite-cloud.de">
    <meta property="og:type" content="article">
    <meta property="og:title" content="{PROJECT_NAME}">
    <meta property="og:description" content="Deine Online-Verwaltung für Userskripte auf elitepvpers">
    <meta property="og:image" content="http://www.elite-cloud.de/frontend/img/facebook.jpg">

    <!-- Mobile -->
    <meta name="MobileOptimized" content="320">
    <meta name="HandheldFriendly" content="True">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="viewport" content="initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no,width=device-width">

    <!-- Icons und Favicons -->
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="icon" href="./frontend/img/favicon.png" type="image/png">
    <link rel="shortcut icon" href="./frontend/img/favicon.png" type="image/png">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="./frontend/css/bootstrap.min.css">
    <link rel="stylesheet" href="./frontend/css/style.css">
    <link rel="stylesheet" href="./frontend/css/animate.min.css">
    <link rel="stylesheet" href="./frontend/css/font-awesome.min.css">
    <link rel="stylesheet" href="./frontend/css/default.css">
    <link rel="stylesheet" href="./frontend/css/page-{$page}.css">

    <!-- Schriftarten -->
    <link href="https://fonts.googleapis.com/css?family=Libre+Baskerville:700" rel="stylesheet" type="text/css">
    <!-- Überschriften -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

    <!-- AngularJS -->
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
    <script src="frontend/js/elite-cloud.js"></script>
</head>

<body>
<!--[if lt IE 8]>
<span class="browserupgrade">Du nutzt einen sehr <strong>alten</strong> Browser. Bitte <a
        href="http://browsehappy.com/">update deinen Browser</a> um diese Website in vollem Umfang genießen zu können.</span>
<![endif]-->
<noscript>
    <div>
        <b>Um den vollen Funktionsumfang dieser Webseite zu erfahren, benötigen Sie JavaScript.</b> Eine Anleitung wie
        Sie JavaScript in Ihrem Browser einschalten, befindet sich <a href="http://www.enable-javascript.com/de/"
                                                                      target="_blank">hier</a>.
    </div>
</noscript>
</body>

{block name="content"}{/block}

<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-12 footer-content">
                <div class="row zeile">
                    <div class="copyright col-md-4">
                        {Helper::copyYear(2016)} <a href=".">elite-cloud</a>. <a
                                href="https://www.elitepvpers.com" target="_blank">Elitepvpers</a>.
                    </div>
                    <div class="people col-md-4">
                        Design: <a href="https://www.lekoarts.de" target="_blank">LeKoArts</a>. Entwicklung: Shawak
                    </div>
                    <div class="contact col-md-4">
                        Kontakt: <a href="#discord" target="_blank">Discord</a> | <a
                                href="mailto: contact@elite-cloud.de" target="_blank">E-Mail</a>
                    </div>
                </div>
                <div class="row zeile">
                    <div class="col-md-12">
                        Unterstütze das Projekt auf <a href="https://github.com/elitepvpers-community/elite-cloud"
                                                       target="_blank"><i class="fa fa-github" aria-hidden="true"></i>
                            Github
                        </a></div>
                </div>
            </div>
        </div>
    </div>
</footer>

{if !LOGGED_IN}
    <!-- Modal Fenster -->
    <!-- Anmelden -->
    <div class="modal fade" id="login" tabindex="-1" role="dialog" aria-labelledby="login" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h3 class="modal-title" id="login">Anmelden</h3>
                </div>
                <div class="modal-body">
                    <form ng-controller="LoginController" ng-submit="login()">
                        <div class="form-group row">
                            <label for="benutzername" class="col-md-3 form-control-label">Benutzername</label>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="benutzername" ng-model="form.username"
                                       required>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="passwort" class="col-md-3 form-control-label">Passwort</label>
                            <div class="col-md-4">
                                <input type="password" class="form-control" id="passwort" ng-model="form.password"
                                       required>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="remember" class="col-md-3 form-control-label">Remember</label>
                            <div class="col-md-4">
                                <label>
                                    <input type="checkbox" value="remember-me" ng-model="form.remember"> Stay logged in
                                </label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="submit" class="btn btn-primary" name="submit" value="Anmelden">
                            </div>
                        </div>
                    </form>
                    <p></p>
                    <p>Noch keinen Account? <a href="#register" target="_blank">Hier registrieren!</a></p>
                </div>
            </div>
        </div>
    </div>
{/if}

<!-- Skripte -->
<script src="./frontend/vendor/wow.min.js"></script>
<script src="./frontend/vendor/bootstrap.min.js"></script>
<script src="./frontend/vendor/scripts.js"></script>

<!-- Google reCAPTCHA -->
<script src='https://www.google.com/recaptcha/api.js'></script>

<!-- NotifyJs -->
<script type="application/javascript" src="frontend/js/notify.min.js"></script>
<!-- Main -->
<script src="frontend/js/main.js"></script>

</html>
