<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;

$app = new \Slim\App(["settings" => $config['slim']]);

/* MAIN */

$app->get('/', function (Request $request, Response $response) {
    include DIR_FRONTEND . 'index.php';
});

/*  JS */

$app->get('/api/include', function (Request $request, Response $response) {
    header('Content-Type: application/javascript');
    echo file_get_contents(DIR_USERSCRIPT . 'loader.js');
});

$app->get('/api/plugin', function (Request $request, Response $response) {
    // JSONP Response
    // <callback>(json)
    $script = file_get_contents(DIR_USERSCRIPT . 'plugin.html');
    echo get('callback') . '(' . new ApiResult(true, '', (object)['script' => $script]) . ')';
});

$app->get('/api/authenticate/{authKey}', function (Request $request, Response $response) {
    $authKey = filter_var($request->getAttribute('authKey'), FILTER_SANITIZE_STRING);
    $user = Database::getUserByAuthKey($authKey);
    echo new ApiResult($user != null, '', $user ? $user->getSelectedUserscripts() : null);
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $username = filter_var($data['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'], FILTER_SANITIZE_STRING);
    $remember = filter_var($data['remember'], FILTER_VALIDATE_BOOLEAN);

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
    $data = $request->getParsedBody();
    $username = filter_var($data['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'], FILTER_SANITIZE_STRING);

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

$app->post('/api/user/edit', function (Request $request, Response $response) {

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
    $data = $request->getParsedBody();
    $name = filter_var($data['name'], FILTER_SANITIZE_STRING);
    $file = filter_var($data['file'], FILTER_SANITIZE_STRING);

    // TODO: upload file

    $userscript = Userscript::create($name, LoginHandler::getInstance()->getUser()->getID(), $file);
    echo new ApiResult(true, 'The userscript has been created.', $userscript);
});

$app->post('/api/userscript/edit', function (Request $request, Response $response) {

});

/* APP */
$app->run();