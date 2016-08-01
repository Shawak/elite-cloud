<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;

$app = new \Slim\App(["settings" => $config['slim']]);

/* MAIN */

$app->get('/', function (Request $request, Response $response) {
    include DIR_FRONTEND . 'index.php';
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) {
    $username = post('username');
    $password = post('password');
    $remember = post('remember', 'bool');

    $loginHandler = LoginHandler::getInstance();
    $passwordHash = $loginHandler->HashPassword($password);
    $success = $loginHandler->Login($username, $passwordHash, $remember);

    echo new ApiResult($success, $success ? 'You have been successfully logged in' : 'Username and/or password was wrong');
});

$app->post('/api/logout', function (Request $request, Response $response) {
    LoginHandler::getInstance()->Logout();
    echo new ApiResult(true, 'You have been logged out');
});

$app->get('/api/user/{id}', function (Request $request, Response $response, $args) {
    $id = $args['id'];
    $user = new User($id);
    if ($user->update()) {
        echo new ApiResult(true, null, array(
            'id' => $user->getId(),
            'name' => $user->getName()
        ));
    } else {
        echo new ApiResult(false, 'A user with this id does not exists');
    }
});

$app->post('/api/user/create', function (Request $request, Response $response) {
    $username = post('username');
    $password = post('password');

    if (!preg_match('/^[a-z\d_]{5,20}$/i', $username)) {
        echo new ApiResult(false, 'Your username may only contain letters and numbers and has to be at least 5 and maximum 20 characters long.');
        return;
    }

    if (strlen($password) < 6) {
        echo new ApiResult(false, 'Your password has to be at least 6 characters long.');
        return;
    }

    $password = LoginHandler::getInstance()->hashPassword($password);
    $user = User::create($username, $password);
    echo new ApiResult(true, 'Your account has been created.', array(
        'id' => $user->getId(),
        'name' => $user->getName()
    ));
});

/* USERSCRIPT */

$app->get('/api/userscript/list', function (Request $request, Response $response) {

});

$app->get('/api/userscript/{id}', function (Request $request, Response $response, $args) {
    $id = $request->getAttribute('id');
    $userscript = new Userscript($id);
    $exists = $userscript->update();
    echo new ApiResult($exists, $exists ? '' : 'A userscript with this id does not exists.', $userscript);
});

$app->post('/api/userscript/create', function (Request $request, Response $response, $args) {

});

$app->post('/api/userscript/edit', function (Request $request, Response $response, $args) {

});

/* APP */
$app->run();