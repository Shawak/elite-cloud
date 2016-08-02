<?php

class KeyGenerator
{

    public static function generateKey()
    {
        do {
            $authKey = hash('sha256', uniqid());
        } while (Database::getUserByAuthKey($authKey));
        return $authKey;
    }

}