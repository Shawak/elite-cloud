<?php

/* Directories */
define('DIR_APP', getcwd() . '/');
define('DIR_VENDOR', DIR_APP . 'vendor/');
define('DIR_SMARTY', DIR_APP . 'smarty/');
define('DIR_BACKEND', DIR_APP . 'backend/');
define('DIR_FRONTEND', DIR_APP . 'frontend/');
define('DIR_USERSCRIPT', DIR_APP . 'userscript/');
define('DIR_TEMPLATES', DIR_BACKEND . 'templates/');

/* URLs */
define('HTTPS', isset($_SERVER['HTTPS']) && filter_var($_SERVER['HTTPS'], FILTER_VALIDATE_BOOLEAN));
define('URL_BASE', substr($_SERVER['SCRIPT_NAME'], 0, strripos($_SERVER['SCRIPT_NAME'], '/')) . '/');
define('URL_SITE', (HTTPS ? "https://" : "http://") . $_SERVER['HTTP_HOST'] . URL_BASE);

/* Session */
session_cache_limiter('private');
session_cache_expire(3 * 60);
session_start();

/* Cache */
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

/* Time */
date_default_timezone_set('Europe/Berlin');

/* Require */
ob_start();
require DIR_APP . 'config.php';
ob_clean();

require DIR_VENDOR . 'autoload.php';

require DIR_BACKEND . 'Helper.php';
require DIR_BACKEND . 'DBObject.php';
require DIR_BACKEND . 'User.php';
require DIR_BACKEND . 'Userscript.php';
require DIR_BACKEND . 'ApiResult.php';
require DIR_BACKEND . 'KeyGenerator.php';
require DIR_BACKEND . 'SmartyHandler.php';
require DIR_BACKEND . 'AuthToken.php';
require DIR_BACKEND . 'Database.php';
require DIR_BACKEND . 'LoginHandler.php';
require DIR_BACKEND . 'RateLimit.php';

/* Initialize */
RateLimit::initialize($config['rate_limit']['time'], $config['rate_limit']['count']);
if (RateLimit::getInstance()->isAboveLimit()) {
    echo new ApiResult(false, 'Rate limit reached.');
    return;
}

Database::initialize($config['db']['host'], $config['db']['datb'], $config['db']['user'], $config['db']['pass']);
define('LOGGED_IN', LoginHandler::getInstance()->autoLogin());

/* Install */
if (intval(Database::getInstance()->getUserCount()) === 0) {
    $password = bin2hex(random_bytes(5));
    $user = User::create('Admin', $password, '');
    echo 'You are running this page the first time, an administrative user has been created.<br><br>' .
        'Username: Admin <br>' .
        'Password: ' . $password;
    return;
}

/* App */
ob_start();
require DIR_BACKEND . 'app.php';
echo ob_get_clean();
