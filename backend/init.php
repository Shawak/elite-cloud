<?php

session_cache_limiter('private');
session_cache_expire(180);
session_start();

// prevent api results from being cached,
// could be moved into app.php to allow caching of frontend html
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

date_default_timezone_set("Europe/Berlin");

require DIR_VENDOR . 'autoload.php';

require DIR_APP . 'config.php';

require DIR_BACKEND . 'Helper.php';
require DIR_BACKEND . 'DBObject.php';
require DIR_BACKEND . 'User.php';
require DIR_BACKEND . 'ApiResult.php';

require DIR_BACKEND . 'Database.php';
$db = new Database($config['db']['host'], $config['db']['datb'],
    $config['db']['user'], $config['db']['pass']);

require DIR_BACKEND . 'LoginHandler.php';
$loginHandler = new LoginHandler($db);
define('LOGGED_IN', $loginHandler->AutoLogin());

require 'app.php';

//dump(LOGGED_IN)
//dump($loginHandler->Login("Shawak", $loginHandler->HashPassword("test")));