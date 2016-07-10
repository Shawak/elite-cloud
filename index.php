<?php

define('DIR_APP', getcwd() . '/');
define('DIR_BACKEND', DIR_APP . 'backend/');
define('DIR_FRONTEND', DIR_APP . 'frontend/');
define('DIR_VENDOR', DIR_APP . 'vendor/');

ob_start();
require DIR_BACKEND . 'init.php';
echo ob_get_clean();