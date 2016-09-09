<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;
use MatthiasMullie\Minify;

$app = new \Slim\App(["settings" => $config['slim']]);

/* MAIN */

foreach (['', 'login', 'userscripts', 'test'] as $page) {
    $app->get('/' . $page, function (Request $request, Response $response) use ($page) {
        $page = $page != '' ? $page : 'home';
        SmartyHandler::getInstance()->assign('page', $page);
        SmartyHandler::getInstance()->display($page . '.tpl');
    });
}

$app->get('/user/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $user = new User($id);
    SmartyHandler::getInstance()->assign('user', $user->update() ? $user : null);
    SmartyHandler::getInstance()->assign('page', 'user');
    SmartyHandler::getInstance()->display('user.tpl');
});

$app->get('/userscript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    SmartyHandler::getInstance()->assign('userscript', $userscript->update() ? $userscript : null);
    SmartyHandler::getInstance()->assign('page', 'userscript');
    SmartyHandler::getInstance()->display('userscript.tpl');
});

/*  JS */

$app->get('/api/loader', function (Request $request, Response $response) {
    if (SETTINGS_MINIFY_JS) {
        $loader = (new Minify\JS(DIR_USERSCRIPT . 'loader.js'))->minify();
    } else {
        $loader = file_get_contents(DIR_USERSCRIPT . 'loader.js');
    }
    echo new ApiResult(true, '', (object)['loader' => $loader]);
});

$app->get('/api/plugin', function (Request $request, Response $response) {
    $plugin = (new Minify\CSS(DIR_USERSCRIPT . 'plugin.html'))->minify();
    echo new ApiResult(true, '', (object)['plugin' => $plugin]);
});

$app->get('/api/authenticate/{authKey}', function (Request $request, Response $response) {
    $authKey = filter_var($request->getAttribute('authKey'), FILTER_SANITIZE_STRING);
    $user = Database::getUserByAuthKey($authKey);
    if ($user == null) {
        echo new ApiResult(false, 'AuthKey does not belong to a user.');
        return;
    }
    echo new ApiResult(true, '', (object)[
        'user' => $user,
        'userscripts' => $user->getSelectedUserscripts()
    ]);
});

$app->get('/api/script/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    if (!$userscript->update()) {
        echo new ApiResult(false, 'A script with this id was not found.');
        return;
    }
    $script = $userscript->getScript();
    if (SETTINGS_MINIFY_JS) {
        $script = (new Minify\JS($script))->minify();
    }
    echo new ApiResult(true, '', (object)['script' => $script]);
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $username = filter_var($data['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'], FILTER_SANITIZE_STRING);
    $remember = filter_var($data['remember'], FILTER_VALIDATE_BOOLEAN);
    $loginHandler = LoginHandler::getInstance();
    $success = $loginHandler->login($username, $password, $remember);
    echo new ApiResult($success, $success ? 'You have been successfully logged in' : 'Username and/or password was wrong');
});

$app->post('/api/logout', function (Request $request, Response $response) {
    LoginHandler::getInstance()->logout();
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

$app->get('/api/user/addscript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);

    $user = LoginHandler::getInstance()->getUser();
    if ($user == null) {
        echo new ApiResult(false, 'You have to be logged in to perform this action.');
        return;
    }

    $userscript = new Userscript($id);
    if (!$userscript->update()) {
        echo new ApiResult(false, 'A userscript with this id was not found.');
        return;
    }

    $user->selectUserscript($userscript);
    echo new ApiResult(true, 'Successfully added userscript "' . $userscript->getName() . '" to your profile!"');
});

$app->get('/api/user/removescript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);

    $user = LoginHandler::getInstance()->getUser();
    if ($user == null) {
        echo new ApiResult(false, 'You have to be logged in to perform this action.');
        return;
    }

    $userscript = new Userscript($id);
    if (!$userscript->update()) {
        echo new ApiResult(false, 'A userscript with this id was not found.');
        return;
    }

    $user->selectUserscript($userscript);
    echo new ApiResult(true, 'Successfully removed userscript "' . $userscript->getName() . '" from your profile!"');
});

$app->post('/api/user/register', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $username = filter_var($data['username'], FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'], FILTER_SANITIZE_STRING);
    $email = filter_var($data['email'], FILTER_VALIDATE_EMAIL);

    $captcha = filter_var($data['captcha'], FILTER_SANITIZE_STRING);
    $reCaptcha = new \ReCaptcha\ReCaptcha(GOOGLE_RECAPTCHA_SECRET);
    $reCaptchaResponse = $reCaptcha->verify($captcha, filter_input(INPUT_SERVER, 'REMOTE_ADDR', FILTER_SANITIZE_STRING));
    if (!$reCaptchaResponse->isSuccess()) {
        echo new ApiResult(false, 'The captcha was not correct, please try again.');
        return;
    }

    if (!preg_match('/^[a-z\d_]{3,20}$/i', $username)) {
        echo new ApiResult(false, 'Your username may only contain letters and numbers and has to be at least 3 and maximum 20 characters long.');
        return;
    }

    if (strlen($password) < 4) {
        echo new ApiResult(false, 'Your password has to be at least 4 characters long.');
        return;
    }

    if (!$email) {
        echo new ApiResult(false, 'You have entered an invalid email address.');
        return;
    }

    $tmpUser = Database::getUserByName($username);
    if ($tmpUser) {
        echo new ApiResult(false, 'A user with this username already exists.');
        return;
    }

    $tmpUser = Database::getUserByEmail($email);
    if ($tmpUser) {
        echo new ApiResult(false, 'A user with this email already exists.');
        return;
    }

    $password = LoginHandler::getInstance()->hashPassword($password);
    $user = User::create($username, $password, $email);
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

    if (!LOGGED_IN) {
        echo new ApiResult(false, 'You have to be logged in to perform this action.');
        return;
    }

    $files = $request->getUploadedFiles();
    $file = isset($files['file']) ? $files['file'] : null;
    if ($file == null) {
        echo new ApiResult(false, 'Could not get the uploaded file.');
        return;
    }

    $script = file_get_contents($file);
    $userscript = Userscript::create($name, LoginHandler::getInstance()->getUser()->getID(), $script);
    echo new ApiResult(true, 'The userscript has been created.', $userscript);
});

$app->post('/api/userscript/edit', function (Request $request, Response $response) {

});

/* APP */
$app->run();