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
define('SMARTY_DEBUGGING', $config['smarty']['debugMode']);

require DIR_BACKEND . 'Helper.php';
require DIR_BACKEND . 'DBObject.php';
require DIR_BACKEND . 'User.php';
require DIR_BACKEND . 'Userscript.php';
require DIR_BACKEND . 'ApiResult.php';
require DIR_BACKEND . 'KeyGenerator.php';
require DIR_BACKEND . 'SmartyHandler.php';

require DIR_BACKEND . 'Database.php';
Database::initialize($config['db']['host'], $config['db']['datb'], $config['db']['user'], $config['db']['pass']);

require DIR_BACKEND . 'LoginHandler.php';
define('LOGGED_IN', LoginHandler::getInstance()->AutoLogin());


SmartyHandler::getInstance()->assign('test', 'str');

require 'app.php';