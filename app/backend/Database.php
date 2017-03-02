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
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindValue(':count', $count, PDO::PARAM_INT);
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $e = User::fromData($e);
        });
        return $ret;
    }

    public static function getUserSettings($user_id, $userscript_id)
    {
        $stmt = Database::getInstance()->prepare('
            select data
            from settings
            where user_id = :user_id
              and userscript_id = :userscript_id
        ');
        $stmt->bindValue(':user_id', $user_id);
        $stmt->bindValue(':userscript_id', $userscript_id);
        $stmt->execute();
        $ret = $stmt->fetch();
        return $ret ?: null;
    }

    public static function setUserSettings($user_id, $userscript_id, $data)
    {
        $stmt = Database::getInstance()->prepare('
            select *
            from settings
            where user_id = :user_id
              and userscript_id = :userscript_id
        ');
        $stmt->bindValue(':user_id', $user_id);
        $stmt->bindValue(':userscript_id', $userscript_id);
        $stmt->execute();
        if(!$stmt->fetch()) {
            $stmt = Database::getInstance()->prepare('
                insert into settings
                (user_id, userscript_id, data)
                values (:user_id, :userscript_id, :data)
            ');
            $stmt->bindValue(':user_id', $user_id);
            $stmt->bindValue(':userscript_id', $userscript_id);
            $stmt->bindValue(':data', $data);
            return $stmt->execute();
        } else {
            $stmt = Database::getInstance()->prepare('
                update settings
                set data = :data
                where user_id = :user_id
                and userscript_id = :userscript_id
            ');
            $stmt->bindValue(':user_id', $user_id);
            $stmt->bindValue(':userscript_id', $userscript_id);
            $stmt->bindValue(':data', $data);
            return $stmt->execute();
        }
    }

    public static function getUserscripts($sort = 'selected', $order = 'asc', $count = null, $offset = null, $search = null)
    {
        if ($offset == null) $offset = 0;
        if ($count == null || $count <= 0) $count = 20;
        if ($count > 50 || $count <= 0) $count = 50;
        if (!empty($search)) $search = '%' . $search . '%';
        if ($order !== 'asc' && $order !== 'desc') $order = 'asc';

        $query = '
            select userscript.*, user.*, (select count(*) from user_userscript where userscript_id = userscript.id) as users [selected]
			from userscript, user
			where user.id = userscript.author
			[search]
			[sort]
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

        $sorts = array(
            'name' => 'order by userscript.name ' . $order . ', users desc',
            'author' => 'order by user.name ' . $order . ', users desc',
            'users' => 'order by users ' . $order . ', userscript.name asc',
            'selected' => 'order by selected ' . $order . ', users desc, userscript.name asc'
        );
        if (!array_key_exists($sort, $sorts)) {
            $sort = 'selected';
        }
        $query = str_replace('[sort]',
            $sorts[$sort],
            $query
        );

        $stmt = Database::getInstance()->prepare($query);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindValue(':count', $count, PDO::PARAM_INT);
        if (!empty($search)) {
            $stmt->bindValue(':search', $search);
        }
        if (LOGGED_IN) {
            $stmt->bindValue(':login_id', LoginHandler::getInstance()->getUser()->getID());
        }
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $v = Userscript::fromData($e);
            $v->users = $e['.users'];
            $v->selected = ($e['.selected'] ?? 0) === '1';
            $v->author = User::fromData($e);
            $v->description = base64_decode($v->description);
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

    public static function getUserUserscriptCount($id)
    {
      $stmt = Database::getInstance()->prepare('
          select count(*) as count
          from user_userscript
          where user_id = :id
      ');
      $stmt->bindValue(':id', $id);
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
        $stmt->bindValue(':authKey', $authKey);
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
        $stmt->bindValue(':selector', $selector);
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
        $stmt->bindValue(':name', $name);
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
        $stmt->bindValue(':email', $email);
        $stmt->execute();
        $ret = $stmt->fetch();
        return User::fromData($ret);
    }

    public static function getScriptsAndSettings($user) {
        $stmt = Database::getInstance()->prepare('
            select
              userscript.id,
              userscript.name,
              userscript.script,
              settings.data
            from user_userscript
              left join user on user_userscript.user_id = user.id
              left join userscript on userscript.id = user_userscript.userscript_id
              left join settings on settings.user_id = user.id and userscript.id = settings.userscript_id
            where user.id = :user_id
        ');
        $stmt->bindValue(':user_id', $user->getID());
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $v = (object)[];
            $v->id = $e['userscript.id'];
            $v->name = $e['userscript.name'];
            $v->script = $e['userscript.script'];
            $v->settings = $e['settings.data'];
            $e = $v;
        });
        return $ret;
    }

}
