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
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_FETCH_TABLE_NAMES => true
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

        $stmt = Database::getInstance()->prepare('
			select *
			from user
			limit :offset, :count
		');
        $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindParam(':count', $count, PDO::PARAM_INT);
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $e = User::fromData($e);
        });
        return $ret;
    }

    public static function getUserscripts($search = null, $offset = null, $count = null)
    {
        if ($offset == null) $offset = 0;
        if ($count == null) $count = 100;
        if (!empty($search)) $search = '%' . $search . '%';

        $query = '
            select userscript.*, user.*, (select count(*) from user_userscript where userscript_id = userscript.id) as users [selected]
			from userscript, user
			where user.id = userscript.author
			[search]
			order by selected desc, users asc, userscript.name asc
			limit :offset, :count
		';

        $query = str_replace('[search]',
            !empty($search)
                ? ' and(
                        userscript.name like :search
                        or userscript.description like :search
                        or user.name like :search
                    ) '
                : '',
            $query
        );

        $query = str_replace('[selected]',
            LOGGED_IN
                ? ', (select count(*) from user_userscript where userscript_id = userscript.id and user_id = :login_id) > 0 as selected'
                : '',
            $query
        );

        $stmt = Database::getInstance()->prepare($query);
        $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindParam(':count', $count, PDO::PARAM_INT);
        if (!empty($search)) {
            $stmt->bindParam(':search', $search, PDO::PARAM_STR);
        }
        if (LOGGED_IN) {
            $stmt->bindParam(':login_id', LoginHandler::getInstance()->getUser()->getID(), PDO::PARAM_INT);
        }
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $v = Userscript::fromData($e);
            $v->users = $e['.users'];
            $v->selected = $e['.selected'] === '1';
            $v->author = User::fromData($e);
            $e = $v;
        });
        return $ret;
    }

    public static function getUserCount()
    {
        $stmt = Database::getInstance()->prepare('
            select count(*) as count
            from user
        ');
        $stmt->execute();
        $ret = $stmt->fetch()['.count'];
        return $ret;
    }

    public static function getUserscriptCount()
    {
        $stmt = Database::getInstance()->prepare('
            select count(*) as count
            from userscript
        ');
        $stmt->execute();
        $ret = $stmt->fetch()['.count'];
        return $ret;
    }

    public static function getUserByAuthKey($authKey)
    {
        $stmt = Database::getInstance()->prepare('
            select *
            from user
            where authKey = :authKey
        ');
        $stmt->bindParam(':authKey', $authKey, PDO::PARAM_STR);
        $stmt->execute();
        $ret = $stmt->fetch();
        return User::fromData($ret);
    }

    public static function getAuthToken($selector)
    {
        $stmt = Database::getInstance()->prepare('
            select *
            from auth_token as AuthToken
            where selector = :selector
        ');
        $stmt->bindParam(':selector', $selector, PDO::PARAM_STR);
        $stmt->execute();
        $ret = $stmt->fetch();
        return AuthToken::fromData($ret);
    }

    public static function getUserByName($name)
    {
        $stmt = Database::getInstance()->prepare('
            select *
            from user
            where name = :name
        ');
        $stmt->bindParam(':name', $name, PDO::PARAM_STR);
        $stmt->execute();
        $ret = $stmt->fetch();
        return User::fromData($ret);
    }

    public static function getUserByEmail($email)
    {
        $stmt = Database::getInstance()->prepare('
            select *
            from user
            where email = :email
        ');
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();
        $ret = $stmt->fetch();
        return User::fromData($ret);
    }

}