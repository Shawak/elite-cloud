{extends file="index.tpl"}
{block name="title"}
    {PROJECT_NAME} - {PROJECT_SLOGAN}
{/block}
{block name="content"}
    <header class="container-fluid animated fadeIn" id="header">
        <div class="logo">
            <img src="./frontend/img/elite-cloud-logo--invert.svg" alt="{PROJECT_NAME} Logo Invert">
        </div>
        <div class="navigation">
            <nav>
                <a href="#features" class="hidden-sm-down">Features</a>
                <a href="#statistics" class="hidden-sm-down">Statistics</a>
                {if !LOGGED_IN}
                    <a href="#login" data-toggle="modal" data-target="#login"
                    ">Sign In</a
                {else}
                    <a href="userscripts">Userscripts</a>
                    <a href="user/{LoginHandler::getInstance()->getUser()->getID()}">Profile</a>
                    <a href="#logout" ng-controller="LogoutController" ng-click="logout()">Logout</a>
                {/if}
            </nav>
            {if !LOGGED_IN}
                <a href="#register">
                    <button type="button" class="btn-primary btn">Register</button>
                </a>
            {/if}
        </div>
    </header>
    <section id="hero">
        <div class="container">
            <img src="./frontend/img/elite-cloud-logo.svg" alt="{PROJECT_NAME} Logo" class="fadeInDown wow">
            <h3 class="slideInUp wow">{PROJECT_SLOGAN}</h3>
        </div>
    </section>
    <section id="features">
        <div class="container">
            <h1>Features</h1>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-rocket bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Fast</span>
                    <p>You only need to install our loader to use all scripts and their settings in your browser</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-cloud bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Worldwide</span>
                    <p>You can use your scripts and settings on any device on any place on earth</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-lock bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Safe</span>
                    <p>All your scripts are transfered using the secure https protocol so they are fully compatible with
                        elitepvpers</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-magic bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Up-to-date</span>
                    <p>You don't have to care anymore about annoying updates, your userscripts are always
                        up-to-date.</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-history bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Flexible</span>
                    <p>Because of your version management you are able to swap between older and newer scripts all the
                        time</p>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <i class="fa fa-github bounceIn wow brand-hover" aria-hidden="true"></i>
                    <span class="desc">Open Source</span>
                    <p>You can help to improve {PROJECT_NAME} with your donations and contributions</p>
                </div>
            </div>
        </div>
    </section>
    <section id="statistics" class="hidden-sm-down">
        <div class="container">
            <h1>Statistics</h1>
            <div class="row">
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">100</span>
                    <span class="desc">User</span>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">50</span>
                    <span class="desc">Available userscripts</span>
                </div>
                <div class="col-md-4 fadeIn wow feature-item">
                    <span class="number bounceIn wow brand-hover">3</span>
                    <span class="desc">Developer</span>
                </div>
            </div>
        </div>
    </section>
    {if !LOGGED_IN}
        <section id="register">
            <div class="container">
                <h1>Register</h1>
                <form action="">
                    <div class="form-group row wow fadeIn">
                        <label for="username" class="col-lg-3 offset-lg-2 form-control-label">Username</label>
                        <div class="col-lg-4">
                            <input type="text" class="form-control" id="username" placeholder="atleast. 3 characters"
                                   required
                                   pattern=".{ldelim} 3,{rdelim} ">
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="passwort" class="col-lg-3 offset-lg-2 form-control-label">Password</label>
                        <div class="col-lg-4">
                            <input type="password" class="form-control" id="password" required
                                   placeholder="atleast. 8 characters"
                                   pattern=".{ldelim} 8,{rdelim} ">
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="password2" class="col-lg-3 offset-lg-2 form-control-label">Repeat Password</label>
                        <div class="col-lg-4">
                            <input type="password" class="form-control" id="password2" required
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
                        <label for="email2" class="col-lg-3 offset-lg-2 form-control-label">Repeat E-Mail</label>
                        <div class="col-lg-4">
                            <input type="email" class="form-control" id="email2" required>
                        </div>
                    </div>
                    <div class="form-group row wow fadeIn">
                        <label for="captcha" class="col-lg-3 offset-lg-2 form-control-label">Captcha</label>
                        <div class="col-lg-4">
                            <div class="g-recaptcha" data-sitekey="{GOOGLE_RECAPTCHA_KEY}"></div>
                        </div>
                    </div>
                    <div class="row wow bounceIn">
                        <div class="col-md-12">
                            <input type="submit" class="btn btn-lg btn-primary" name="submit" value="Register">
                        </div>
                    </div>
                </form>
            </div>
        </section>
    {/if}
{/block}