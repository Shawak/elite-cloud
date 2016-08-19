{extends file="index.tpl"}
{block name="title"}
    {PROJECT_NAME}
{/block}
{block name="content"}
    <div class="navigation-main">
        <div class="container">
            <img src="./frontend/img/elite-cloud-logo--invert.svg" alt="elite*cloud Logo" class="navbar-brand-img">
            <nav class="navbar" role="navigation">
                <ul class="nav navbar-nav">
                    <li class="nav-item">
                        <a href="#" class="nav-link">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Profil</a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">Userscripts</a>
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