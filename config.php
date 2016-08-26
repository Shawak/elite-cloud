<?php

// Project
define('PROJECT_NAME', 'elite-cloud');

// Slim
$config['slim']['displayErrorDetails'] = true;
$config['slim']['addContentLengthHeader'] = false;

// Smarty
define('SMARTY_DEBUGGING', false);

// Database
$config['db']['host'] = 'localhost';
$config['db']['user'] = 'root';
$config['db']['pass'] = '';
$config['db']['datb'] = 'elitecloud';

// Google reCAPTCHA
$config['google']['reCAPTCHA']['key'] = '';
$config['google']['reCAPTCHA']['secret'] = '';

// overwrite $config['db']['pass'] in an external config during development
// which wont be uploaded to prevent mistakes (aka. uploading passwords)
@include 'config-update.php';

// export config to constants
define('GOOGLE_RECAPTCHA_KEY', $config['google']['reCAPTCHA']['key']);
define('GOOGLE_RECAPTCHA_SECRET', $config['google']['reCAPTCHA']['secret']);