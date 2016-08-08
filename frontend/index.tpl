<!DOCTYPE html>
<html lang="en" ng-app="elite-cloud">
<head>
    <base href="{URL_BASE}">
    <title>{block name="title"}{/block}</title>
    <link rel="icon" href="frontend/images/favicon.png">

    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
          integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

    <link rel="stylesheet" type="text/css" href="frontend/css/index.css">
    <link rel="stylesheet" type="text/css" href="frontend/css/{$css}.css">

    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <!-- AngularJS -->
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.7/angular.min.js"></script>
    <script src="frontend/js/elite-cloud.js"></script>
</head>
<body>

<!-- Navigation -->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="."">elite-cloud</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                {if !LOGGED_IN}
                    <li class="{($page=='login')?'active':''}"><a href="login" class="pointer">Login</a></li>
                {else}
                    <li class="{($page=='userscripts')?'active':''}"><a href="userscripts" class="pointer">Userscirpts</a></li>
                    <li class="{($page=='user')?'active':''}"><a href="profile/{LoginHandler::getInstance()->getUser()->getID()}" class="pointer">Profile</a></li>
                    <li ng-controller="LogoutController">
                        <a class="pointer" ng-click="logout()">Logout</a>
                    </li>
                {/if}
            </ul>
        </div>
    </div>
</nav>

<div id="content">
    {block name="content"}{/block}
</div>

<!-- Footer -->
<footer>
    <div class="center">
        <div class="left">
            {Helper::copyYear(2016)} <a href=".">elite-cloud</a><br>
            Using
            <a href="http://www.slimframework.com/" target="_blank">Slim</a>,
            <a href="http://getbootstrap.com/" target="_blank">Bootstrap</a>,
            <a href="https://angularjs.org/" target="_blank">AngularJS</a>,
            <a href="https://jquery.com/" target="_blank">jQuery</a>,
            <a href="http://notifyjs.com/" target="_blank">Notify.js</a>
        </div>
        <div class="right">
            <a href="http://elitepvpers.com" target="_blank">
                Elitepvpers
            </a>
        </div>
        <div class="clear"></div>
    </div>
</footer>

<!-- Bootstrap -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
        integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
        crossorigin="anonymous"></script>

<!-- NotifyJs -->
<script type="application/javascript" src="frontend/js/notify.min.js"></script>

<!-- Main -->
<script src="frontend/js/main.js"></script>

</body>
</html>