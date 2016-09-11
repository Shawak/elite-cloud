<?php

// Project
define('PROJECT_NAME', 'elite-cloud');
define('PROJECT_SLOGAN', 'Your online management for userscripts on elitepvpers');
define('SETTINGS_MINIFY_JS', false);

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

// RateLimit - count visits are allowed in time
$config['rate_limit']['time'] = 60;
$config['rate_limit']['count'] = 20;

// overwrite $config['db']['pass'] in an external config during development
// which wont be uploaded to prevent mistakes (aka. uploading passwords)
@include 'config-update.php';

// export config to constants
define('GOOGLE_RECAPTCHA_KEY', $config['google']['reCAPTCHA']['key']);
define('GOOGLE_RECAPTCHA_SECRET', $config['google']['reCAPTCHA']['secret']);