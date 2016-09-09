<?php

if (!function_exists('random_bytes')) {
    if (function_exists('mcrypt_create_iv')) {
        function random_bytes($length)
        {
            $flag = (version_compare(PHP_VERSION, '5.3.7', '<') && strncasecmp(PHP_OS, 'WIN', 3) == 0) ? MCRYPT_RAND : MCRYPT_DEV_URANDOM;
            return mcrypt_create_iv($length, $flag);
        }
    } elseif (function_exists('openssl_random_pseudo_bytes')) {
        function random_bytes($length)
        {
            return openssl_random_pseudo_bytes($length);
        }
    } else {
        die('cloud not create random_bytes function');
    }
}