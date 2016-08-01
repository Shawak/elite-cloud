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

    public function lastID()
    {
        return $this->lastInsertId();
    }

    public static function getUsers($offset = null, $count = null)
    {
        if ($offset == null) $offset = 0;
        if ($count == null) $count = 100;

        $db = Database::getInstance();
        $stmt = $db->prepare('
			select *
			from user
			limit :offset, :count
		');
        $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindParam(':count', $count, PDO::PARAM_INT);
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $e = new User($e['id']);
            $e->consume($e);
        });
        return $ret;
    }

}