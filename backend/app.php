<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;

$app = new \Slim\App(["settings" => $config['slim']]);

/* MAIN */

$app->get('/', function (Request $request, Response $response) use ($loginHandler) {
    include DIR_FRONTEND . 'index.php';
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) use ($loginHandler) {
    $username = post('username');
    $password = post('password');
    $remember = post('remember', 'bool');

    $passwordHash = $loginHandler->HashPassword($password);
    $success = $loginHandler->Login($username, $passwordHash, $remember);

    echo new ApiResult($success, $success ? 'You have been successfully logged in' : 'Username and/or password was wrong');
});

$app->get('/api/user/{id}', function (Request $request, Response $response, $args) use ($db) {
    $id = $args['id'];
    $user = new User($id);
    if ($user->update($db)) {
        echo new ApiResult(true, null, array(
            'id' => $user->getId(),
            'name' => $user->getName()
        ));
    } else {
        echo new ApiResult(false, 'A user with this id does not exists');
    }
});

$app->post('/api/user/create', function (Request $request, Response $response) {

});

/* USERSCRIPT */

$app->get('/api/userscript/list', function (Request $request, Response $response) {

});

$app->get('/api/userscript/{id}', function (Request $request, Response $response, $args) {
    //echo $args['id'];
    echo $request->getAttribute('id');
    //echo get('id', 'int');
});

$app->post('/api/userscript/create', function (Request $request, Response $response, $args) {

});

$app->post('/api/userscript/edit', function (Request $request, Response $response, $args) {

});

/* APP */
$app->run();