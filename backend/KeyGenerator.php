<?php

class KeyGenerator
{

    public static function generateAuthKey()
    {
        do {
            $authKey = bin2hex(random_bytes(32));
        } while (Database::getUserByAuthKey($authKey));
        return $authKey;
    }

    public static function generateSelector()
    {
        do {
            $selector = bin2hex(random_bytes(6));
        } while (Database::getAuthToken($selector));
        return $selector;
    }

}