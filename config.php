<?php

// Slim
$config['slim']['displayErrorDetails'] = true;
$config['slim']['addContentLengthHeader'] = false;

// Database
$config['db']['host'] = 'localhost';
$config['db']['user'] = 'root';
$config['db']['pass'] = '';
$config['db']['datb'] = 'elite-cloud';

// overwrite $config['db']['pass'] in an external config during development
// which wont be uploaded to prevent mistakes
@include '../config.php';
