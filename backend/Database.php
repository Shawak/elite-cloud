<?php

class Database extends PDO
{

    public function __construct($host, $datb, $user, $pass)
    {
        try {
            parent::__construct('mysql:host=' . $host . ';dbname=' . $datb . ';charset=utf8', $user, $pass, array(
                PDO::ATTR_PERSISTENT => true,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
            ));
        } catch (PDOException $ex) {
            die($ex->GetMessage());
        }
    }

}