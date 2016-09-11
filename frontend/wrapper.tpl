{extends file="index.tpl"}
{block name="title"}
    {PROJECT_NAME}
{/block}
{block name="content"}
    <div class="navigation-main">
        <div class="container">
            <a href=".">
                <img src="./frontend/img/elite-cloud-logo--invert.svg" alt="elite*cloud Logo" class="navbar-brand-img">
            </a>
            <nav class="navbar" role="navigation">
                <ul class="nav navbar-nav">
                    <li class="nav-item">
                        <a href="userscripts" class="nav-link">Userscripts</a>
                    </li>
                    {if LOGGED_IN}
                        <li class="nav-item">
                            <a href="user/{LoginHandler::getInstance()->getUser()->getID()}"
                               class="nav-link">Profile</a>
                        </li>
                    {/if}
                    <li class="nav-item">
                        <a href="#" class="nav-link" ng-controller="LogoutController" ng-click="logout()">Logout</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
    <section class="content">
        <div class="container">
            {block name="page"}{/block}
        </div>
    </section>
{/block}