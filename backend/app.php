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
    // User::create($name, $password, $flag);
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