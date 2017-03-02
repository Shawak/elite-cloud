<?php

class KeyGenerator
{

    public static function generateSelector()
    {
        do {
            $selector = bin2hex(random_bytes(6));
        } while (Database::getAuthToken($selector));
        return $selector;
    }

}