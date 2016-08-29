<?php

class UserFlag
{
    const USER = 0;
    const MODERATOR = 1;
    const ADMIN = 2;
    const BANNED = 4;
}

class User extends DBObject
{
    public $id;
    public $name;
    protected $password;
    public $flag;
    protected $authKey;
    protected $registered;

    public function __construct($id)
    {
        $this->id = $id;
    }

    public static function create($name, $password, $email, $flag = 0)
    {
        $stmt = Database::getInstance()->prepare('
			insert into user
			(name, password, email, flag, authKey)
			values (:name, :password, :email, :flag, :authKey)
		');
        $stmt->bindParam(':name', $name);
        $stmt->bindParam(':password', $password);
        $stmt->bindParam(':email', $email);
        $stmt->bindParam(':flag', $flag);
        $stmt->bindParam(':authKey', KeyGenerator::generateKey());
        $stmt->execute();
        return new self(Database::getInstance()->lastID());
    }

    public function getID()
    {
        return $this->id;
    }

    public function getName()
    {
        return $this->name;
    }

    public function getPassword()
    {
        return $this->password;
    }

    public function getAuthKey()
    {
        return $this->authKey;
    }

    public function getRegisteredTimestamp()
    {
        return strtotime($this->registered);
    }

    public function renewAuthKey()
    {
        $this->authKey = KeyGenerator::generateKey();
    }

    public function isUser()
    {
        return $this->flag & UserFlag::USER;
    }

    public function isModerator()
    {
        return $this->flag & UserFlag::MODERATOR;
    }

    public function isAdmin()
    {
        return $this->flag & UserFlag::ADMIN;
    }

    public function isBanned()
    {
        return $this->flag & UserFlag::BANNED;
    }

    public function getSelectedUserscripts()
    {
        $stmt = Database::getInstance()->prepare('
			select user.*, userscript.*, user_userscript.*
			from user, userscript, user_userscript
			where user.id = :id
			  and user_userscript.userID = :id
			  and user_userscript.userscriptID = userscript.id
		');
        $stmt->bindParam(':id', $this->id);
        $stmt->execute();
        $ret = $stmt->fetchAll();
        array_walk($ret, function (&$e) {
            $v = Userscript::fromData($e);
            $v->author = User::fromData($e);
            $e = $v;
        });
        return $ret;
    }

    public function selectUserscript(Userscript $userscript)
    {
        $stmt = Database::getInstance()->prepare('
            insert into user_userscript
            (userID, userscriptID)
            values (:userID, :userscriptID)
            on duplicate key update userID = userID
		');
        $stmt->bindParam(':userID', $this->id);
        $stmt->bindParam(':userscriptID', $userscript->getID());
        $stmt->execute();
    }

    public function deselectUserscript(Userscript $userscript)
    {
        $stmt = Database::getInstance()->prepare('
            delete from user_userscript
            where userID = :userID
              and userscriptID = :userscriptID
		');
        $stmt->bindParam(':userID', $this->id);
        $stmt->bindParam(':userscriptID', $userscript->getID());
        $stmt->execute();
    }

    public function update()
    {
        $stmt = Database::getInstance()->prepare('
			select *
			from user
			where id = :id
		');
        $stmt->bindParam(':id', $this->id);
        $stmt->execute();
        $ret = $stmt->fetch();
        return $this->consume($ret);
    }

    public function save()
    {
        $stmt = Database::getInstance()->prepare('
			update user
			set name = :name,
			  password = :password,
			  flag = :flag,
			  authKey = :authKey
			where id = :id
		');
        $stmt->bindParam(':id', $this->id);
        $stmt->bindParam(':name', $this->name);
        $stmt->bindParam(':password', $this->password);
        $stmt->bindParam(':flag', $this->flag);
        $stmt->bindParam(':authKey', $this->authKey);
        return $stmt->execute();
    }
}