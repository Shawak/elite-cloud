{extends file="index.tpl"}
{block name="title"}
    Login - {PROJECT_NAME}
{/block}
{block name="content"}
    <form class="centerTable form-signin" ng-controller="LoginController" ng-submit="login()">
        <h2 class="form-signin-heading">Please sign in</h2>
        <label for="inputEmail" class="sr-only">Username</label>
        <input type="text" class="form-control" placeholder="Username" ng-model="form.username" required autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" class="form-control" placeholder="Password" ng-model="form.password" required>
        <div class="checkbox">
            <label>
                <input type="checkbox" value="remember-me" ng-model="form.remember"> Remember me
            </label>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
    </form>
{/block}