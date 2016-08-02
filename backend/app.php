<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;

$app = new \Slim\App(["settings" => $config['slim']]);

/* MAIN */

$app->get('/', function (Request $request, Response $response) {
    include DIR_FRONTEND . 'index.php';
});

/* USERSCRIPT */

$app->get('/api/include', function (Request $request, Response $response) {
    header('Content-Type: application/javascript');
    echo file_get_contents('xx.js');
});

$app->get('/api/authenticate/{authKey}', function (Request $request, Response $response) {
    $authKey = filter_var($request->getAttribute('authKey'), FILTER_SANITIZE_STRING);
    $user = Database::getUserByAuthKey($authKey);

    // TODO: list userscripts selected by the user

    echo new ApiResult($user != null, '', $user);
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) {
    $username = filter_var($request->getAttribute('username'), FILTER_SANITIZE_STRING);
    $password = filter_var($request->getAttribute('password'), FILTER_SANITIZE_STRING);
    $remember = filter_var($request->getAttribute('remember'), FILTER_VALIDATE_BOOLEAN);

    $loginHandler = LoginHandler::getInstance();
    $passwordHash = $loginHandler->HashPassword($password);
    $success = $loginHandler->Login($username, $passwordHash, $remember);

    echo new ApiResult($success, $success ? 'You have been successfully logged in' : 'Username and/or password was wrong');
});

$app->post('/api/logout', function (Request $request, Response $response) {
    LoginHandler::getInstance()->Logout();
    echo new ApiResult(true, 'You have been logged out');
});

$app->get('/api/user/list[/{offset}[/{count}]]', function (Request $request, Response $response) {
    $offset = filter_var($request->getAttribute('offset'), FILTER_VALIDATE_INT);
    $count = filter_var($request->getAttribute('count'), FILTER_VALIDATE_INT);
    echo new ApiResult(true, '', Database::getUsers($offset, $count));
});

$app->get('/api/user/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $user = new User($id);
    if ($user->update()) {
        echo new ApiResult(true, '', $user);
    } else {
        echo new ApiResult(false, 'A user with this id does not exists');
    }
});

$app->post('/api/user/create', function (Request $request, Response $response) {
    $username = filter_var($request->getAttribute('username'), FILTER_SANITIZE_STRING);
    $password = filter_var($request->getAttribute('password'), FILTER_SANITIZE_STRING);

    if (!preg_match('/^[a-z\d_]{5,20}$/i', $username)) {
        echo new ApiResult(false, 'Your username may only contain letters and numbers and has to be at least 5 and maximum 20 characters long.');
        return;
    }

    if (strlen($password) < 4) {
        echo new ApiResult(false, 'Your password has to be at least 4 characters long.');
        return;
    }

    $password = LoginHandler::getInstance()->hashPassword($password);
    $user = User::create($username, $password);
    echo new ApiResult(true, 'Your account has been created.', $user);
});

/* USERSCRIPT */

$app->get('/api/userscript/list[/{offset}[/{count}]]', function (Request $request, Response $response) {
    $offset = filter_var($request->getAttribute('offset'), FILTER_VALIDATE_INT);
    $count = filter_var($request->getAttribute('count'), FILTER_VALIDATE_INT);
    echo new ApiResult(true, '', Database::getUserscripts($offset, $count));
});

$app->get('/api/userscript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    $exists = $userscript->update();
    echo new ApiResult($exists, $exists ? '' : 'A userscript with this id does not exists.', $userscript);
});

$app->post('/api/userscript/create', function (Request $request, Response $response) {

});

$app->post('/api/userscript/edit', function (Request $request, Response $response) {

});

/* APP */
$app->run();