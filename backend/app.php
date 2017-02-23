<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;
use MatthiasMullie\Minify;

$app = new \Slim\App(["settings" => $config['slim']]);

/* PAGES */

$app->get('/', function (Request $request, Response $response) {
    SmartyHandler::getInstance()->assign('page', 'home');
    SmartyHandler::getInstance()->display('page-home.tpl');
});

$app->get('/userscripts', function (Request $request, Response $response) {
    if (!LOGGED_IN) {
        SmartyHandler::getInstance()->assign('error', 'You have to be logged in to view this page.');
        SmartyHandler::getInstance()->assign('page', 'error');
        SmartyHandler::getInstance()->display('page-error.tpl');
        return;
    }

    SmartyHandler::getInstance()->assign('page', 'userscripts');
    SmartyHandler::getInstance()->display('page-userscripts.tpl');
});

$app->get('/user/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $user = new User($id);
    SmartyHandler::getInstance()->assign('user', $user->update() ? $user : null);
    SmartyHandler::getInstance()->assign('page', 'user');
    SmartyHandler::getInstance()->display('page-user.tpl');
});

$app->get('/userscript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    SmartyHandler::getInstance()->assign('userscript', $userscript->update() ? $userscript : null);
    SmartyHandler::getInstance()->assign('page', 'userscript');
    SmartyHandler::getInstance()->display('page-userscript.tpl');
});

$app->get('/userscript/do/create', function (Request $request, Response $response) {
    $userscript = new Userscript(-1);
    $userscript->setName('New userscript');
    $userscript->setAuthor(LoginHandler::getInstance()->getUser());
    $userscript->users = 0;
    SmartyHandler::getInstance()->assign('userscript', $userscript);
    SmartyHandler::getInstance()->assign('page', 'userscript');
    SmartyHandler::getInstance()->display('page-userscript.tpl');
});

/* LINKS */

$app->get('/elite-cloud.user.js', function (Request $request, Response $response) {
    /* Force Download
    header('Content-type: text/plain');
    header("Content-Disposition: attachment; filename=elite-cloud.user.js");
    */
    SmartyHandler::getInstance()->setTemplateDir(DIR_USERSCRIPT);
    SmartyHandler::getInstance()->display('elite-cloud.user.js');
});

/* OTHER */

$app->post('/api/markdown', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $text = filter_var($data['text'] ?? '', FILTER_SANITIZE_STRING);
    $parser = new Parsedown();
    $purifier = new HTMLPurifier(HTMLPurifier_Config::createDefault());
    $output = $parser->text($text);
    $output = $purifier->purify($output);
    echo new ApiResult(true, '', (object)['html' => $output]);
});

/* JS */

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

$app->get('/api/settings/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    if (!$userscript->update()) {
      echo new ApiResult(false, 'A script with this id was not found.');
      return;
    }

    $user = Database::getUserByAuthKey($_GET['authKey']);
    if ($user == null) {
      echo new ApiResult(false, 'AuthKey does not belong to a user.');
      return;
    }

    $userSettings = Database::getUserSettings($userscript->getID(), $user->getID());
    if($userSettings) {
        echo new ApiResult(true, '', (object)['userSettings' => $userSettings['user_userscripts_settings.settings']]);
    } else {
        echo new ApiResult(false, '');
    }
});

$app->post('/api/settings/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscrip($id);
    if (!$userscript->update()) {
      echo new ApiResult(false, 'A script with this id was not found.');
      return;
    }

    $data = $request->getParsedBody();
    $settings = filter_var($data['settings'] ?? null, FILTER_SANITIZE_STRING);
    $success = Database::setUserSettings(LoginHandler::getInstance()->getUser()->getID(), $id, $settings);
    echo new ApiResult($success, '');
});

/* USER */

$app->post('/api/login', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $username = filter_var($data['username'] ?? null, FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'] ?? null, FILTER_SANITIZE_STRING);
    $remember = filter_var($data['remember'] ?? null, FILTER_VALIDATE_BOOLEAN);
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
    echo new ApiResult(true, 'Added "' . $userscript->getName() . '" to your profile!');
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

    $user->deselectUserscript($userscript);
    echo new ApiResult(true, 'Removed "' . $userscript->getName() . '" from your profile!');
});

$app->post('/api/user/register', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $username = filter_var($data['username'] ?? null, FILTER_SANITIZE_STRING);
    $password = filter_var($data['password'] ?? null, FILTER_SANITIZE_STRING);
    $email = filter_var($data['email'] ?? null, FILTER_VALIDATE_EMAIL);

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

    $user = User::create($username, $password, $email);
    $user->update();
    $user->renewAuthKey();
    $user->save();
    echo new ApiResult(true, 'Your account has been created.', $user);
});

$app->post('/api/user/edit', function (Request $request, Response $response) {

});

/* USERSCRIPT */

$app->get('/api/userscript/list[/{sort}[/{order}[/{search}[/{offset}[/{count}]]]]]', function (Request $request, Response $response) {
    $sort = filter_var($request->getAttribute('sort'), FILTER_SANITIZE_STRING);
    $order = filter_var($request->getAttribute('order'), FILTER_SANITIZE_STRING);
    $search = filter_var($request->getAttribute('search'), FILTER_SANITIZE_STRING);
    $offset = filter_var($request->getAttribute('offset'), FILTER_VALIDATE_INT);
    $count = filter_var($request->getAttribute('count'), FILTER_VALIDATE_INT);
    $search = base64_decode($search);
    $userscipts = Database::getUserscripts($sort, $order, $search, $offset, $count);
    echo new ApiResult(true, '', $userscipts);
});

$app->get('/api/userscript/{id}', function (Request $request, Response $response) {
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $userscript = new Userscript($id);
    $exists = $userscript->update();
    echo new ApiResult($exists, $exists ? '' : 'A userscript with this id does not exists.', $userscript);
});

$app->post('/api/userscript/{id}/edit', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);
    $name = filter_var($data['name'] ?? null, FILTER_SANITIZE_STRING);
    $description = filter_var($data['description'] ?? null, FILTER_SANITIZE_STRING);
    $script = filter_var($data['script'] ?? null, FILTER_SANITIZE_STRING);

    if (!LOGGED_IN) {
        echo new ApiResult(false, 'You need to be logged in to edit a userscript.');
        return;
    }

    $userscript = new Userscript($id);
    if (!$userscript->update()) {
        echo new ApiResult(false, 'A userscript with this id does not exists.');
        return;
    }

    if (LoginHandler::getInstance()->getUser()->getID() != $userscript->getAuthor()->getID()) {
        echo new ApiResult(false, 'You need to be the owner of the userscript to edit it.');
        return;
    }

    $userscript->setName($name);
    $userscript->setDescription(base64_decode($description));
    $userscript->setScript(base64_decode($script));
    $success = $userscript->save();
    echo new ApiResult($success, $success ? 'Successfully saved changes.' : 'An unknown error occurred, please try again later.');
});

$app->post('/api/userscript/{id}/delete', function (Request $request, Response $response) {
    if (!LOGGED_IN) {
        echo new ApiResult(false, 'You need to be logged in to edit a userscript.');
        return;
    }
    $id = filter_var($request->getAttribute('id'), FILTER_VALIDATE_INT);

    $userscript = new Userscript($id);
    if (!$userscript->update()) {
        echo new ApiResult(false, 'A userscript with this id does not exists.');
        return;
    }

    if (LoginHandler::getInstance()->getUser()->getID() != $userscript->getAuthor()->getID()) {
        echo new ApiResult(false, 'You need to be the owner of the userscript to edit it.');
        return;
    }
    $success = $userscript->delete();
    echo new ApiResult($success, $success ? 'Successfully deleted.' : 'An unknown error occurred, please try again later.');
});

$app->post('/api/userscript/create', function (Request $request, Response $response) {
    $data = $request->getParsedBody();
    $name = filter_var($data['name'], FILTER_SANITIZE_STRING);
    $description = filter_var($data['description'] ?? null, FILTER_SANITIZE_STRING);
    $script = filter_var($data['script'] ?? null, FILTER_SANITIZE_STRING);

    if (!LOGGED_IN) {
        echo new ApiResult(false, 'You have to be logged in to perform this action.');
        return;
    }

    $userscript = Userscript::create($name,
        LoginHandler::getInstance()->getUser()->getID(),
        base64_decode($description),
        base64_decode($script)
    );
    echo new ApiResult(true, 'The userscript has been created.', $userscript);
});

/* APP */
$app->run();
