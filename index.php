<?php

define('DIR_APP', getcwd() . '/');
define('DIR_VENDOR', DIR_APP . 'vendor/');
define('DIR_SMARTY', DIR_APP . 'smarty/');
define('DIR_BACKEND', DIR_APP . 'backend/');
define('DIR_FRONTEND', DIR_APP . 'frontend/');
define('DIR_USERSCRIPT', DIR_APP . 'userscript/');

define('URL_BASE', substr($_SERVER['SCRIPT_NAME'], 0, strripos($_SERVER['SCRIPT_NAME'], '/')) . '/');

ob_start();
require DIR_BACKEND . 'init.php';
echo ob_get_clean();