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

    public function __construct($id)
    {
        $this->id = $id;
    }

    public static function create($name, $password, $flag = 0)
    {
        $stmt = Database::getInstance()->prepare('
			insert into user
			(name, password, flag)
			values (:name, :password, :flag)
		');
        $stmt->bindParam(':name', $name);
        $stmt->bindParam(':password', $password);
        $stmt->bindParam(':flag', $flag);
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
			set password = :password
			where id = :id
		');
        $stmt->bindParam(':id', $this->id);
        $stmt->bindParam(':password', $this->password);
        return $stmt->execute();
    }
}