<?php

class Database extends PDO
{
    private static $instance;

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

    public static function initialize($host, $datb, $user, $pass)
    {
        if (self::$instance) {
            die('Database already initialized.');
        }
        self::$instance = new self($host, $datb, $user, $pass);
    }

    public static function getInstance()
    {
        if (!self::$instance) {
            die('Database not initialized.');
        }
        return self::$instance;
    }

    public function lastID() {
        return $this->lastInsertId();
    }

}