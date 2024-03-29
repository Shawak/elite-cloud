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

    Design: LeKoArts (https://www.lekoarts.de)
    (c) Copyright 2016

    ******************
    -->

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <base href="{URL_BASE}">

    <!-- Titel -->
    <title>{block name="title"}{/block}</title>

    <!-- Beschreibung -->
    <meta name="description" content="{PROJECT_NAME} - {PROJECT_SLOGAN}">

    <!-- Allgemein -->
    <meta name="publisher" content="{PROJECT_NAME}">
    <meta name="author" content="{PROJECT_NAME}">
    <meta name="keywords" content="{PROJECT_NAME}, elitepvpers, Userscripte, Greasemonkey, Tampermonkey">
    <link rel="canonical" href="http://www.elite-cloud.de">

    <!-- Facebook -->
    <meta property="og:url" content="http://www.elite-cloud.de">
    <meta property="og:type" content="article">
    <meta property="og:title" content="{PROJECT_NAME}">
    <meta property="og:description" content="{PROJECT_SLOGAN}">
    <meta property="og:image" content="http://www.elite-cloud.de/img/facebook.jpg">

    <!-- Mobile -->
    <meta name="MobileOptimized" content="320">
    <meta name="HandheldFriendly" content="True">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="viewport" content="initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no,width=device-width">

    <!-- Icons und Favicons -->
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="icon" href="img/favicon.png" type="image/png">
    <link rel="shortcut icon" href="img/favicon.png" type="image/png">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/animate.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/default.css">
    <link rel="stylesheet" href="css/page-{$page}.css">

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
    <script src="js/elite-cloud.js"></script>
    {block name="scriptjs"}{/block}
</head>

<body>
<!--[if lt IE 8]>
<span class="browserupgrade">You are using a <strong>very old</strong> browser. Please <a
        href="http://browsehappy.com/">update your browser</a> to use this website without any limitations.</span>
<![endif]-->
<noscript>
    <div>
        <b>To use this website without any limitations you will need javascript.</b> A guide how to enable javascript
        can be found <a href="http://www.enable-javascript.com/de/"
                        target="_blank">here</a>.
    </div>
</noscript>

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
                        Development: <a
                                href="https://github.com/elitepvpers-community/elite-cloud/graphs/contributors">elitepvpers-community</a>
                    </div>
                    <div class="contact col-md-4">
                        Contact: <a href="http://www.elitepvpers.com/forum/members/2342603-shawak.html" target="_blank">Shawak@Elitepvpers</a>
                    </div>
                </div>
                <div class="row zeile">
                    <div class="col-md-12">
                        Support the project on <a href="https://github.com/elitepvpers-community/elite-cloud"
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
                    <h3 class="modal-title" id="login">Sign In</h3>
                </div>
                <div class="modal-body">
                    <form ng-controller="LoginController" ng-submit="login()">
                        <div class="form-group row">
                            <label for="username" class="col-md-3 form-control-label">Username</label>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="username" ng-model="form.username"
                                       required>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="password" class="col-md-3 form-control-label">Password</label>
                            <div class="col-md-4">
                                <input type="password" class="form-control" id="password" ng-model="form.password"
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
                                <input type="submit" class="btn btn-primary" name="submit" value="Login">
                            </div>
                        </div>
                    </form>
                    <p></p>
                    <p>Not registered? <a href="#register" target="_blank">Register!</a></p>
                </div>
            </div>
        </div>
    </div>
{/if}

<script src="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js"></script>

<!-- Skripte -->
<script src="vendor/wow.min.js"></script>
<script src="vendor/bootstrap.min.js"></script>
<script src="vendor/scripts.js"></script>

<!-- Google reCAPTCHA -->
<script src='https://www.google.com/recaptcha/api.js'></script>
<!-- NotifyJs -->
<script src="js/notify.min.js"></script>
<!-- Main -->
<script src="js/main.js"></script>

</body>
</html>
