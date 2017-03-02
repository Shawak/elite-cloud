<?php

class User extends DBObject
{
    public $id;
    public $name;
    protected $password;
    protected $email;
    public $flag;
    protected $registered;

    public function __construct($id)
    {
        $this->id = $id;
    }

    public static function create($name, $password)
    {
        $password = LoginHandler::getInstance()->hashPassword($password);
        $stmt = Database::getInstance()->prepare('
			insert into user
			(name, password)
			values (:name, :password)
		');
        $stmt->bindValue(':name', $name);
        $stmt->bindValue(':password', $password);
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

    public function getRegisteredTimestamp()
    {
        return strtotime($this->registered);
    }

    public function isUser()
    {
        return $this->flag;
    }

    public function isModerator()
    {
        return $this->flag;
    }

    public function isAdmin()
    {
        return $this->flag;
    }

    public function isBanned()
    {
        return $this->flag;
    }

    public function getRole()
    {
      $stmt = Database::getInstance()->prepare('
        select user.*, user_roles.*
        from user, user_roles
        where user.id = :id
          and user_roles.user_id = :id
      ');
      $stmt->bindValue(':id', $this->id);
      $stmt->execute();
      $ret = $stmt->fetchAll();
      return $ret[0]['user_roles.role_id'];
    }

    public function getSelectedUserscripts()
    {
        $stmt = Database::getInstance()->prepare('
			select user.*, userscript.*, user_userscript.*
			from user, userscript, user_userscript
			where user.id = :id
			  and user_userscript.user_id = :id
			  and user_userscript.userscript_id = userscript.id
		');
        $stmt->bindValue(':id', $this->id);
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
            (user_id, userscript_id)
            values (:user_id, :userscript_id)
            on duplicate key update user_id = user_id
		');
        $stmt->bindValue(':user_id', $this->id);
        $stmt->bindValue(':userscript_id', $userscript->getID());
        $stmt->execute();
    }

    public function deselectUserscript(Userscript $userscript)
    {
        $stmt = Database::getInstance()->prepare('
            delete from user_userscript
            where user_id = :user_id
              and userscript_id = :userscript_id
		');
        $stmt->bindValue(':user_id', $this->id);
        $stmt->bindValue(':userscript_id', $userscript->getID());
        $stmt->execute();
    }

    public function update()
    {
        $stmt = Database::getInstance()->prepare('
			select *
			from user
			where id = :id
		');
        $stmt->bindValue(':id', $this->id);
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
			  email = :email
			where id = :id
		');
        $stmt->bindValue(':id', $this->id);
        $stmt->bindValue(':name', $this->name);
        $stmt->bindValue(':password', $this->password);
        $stmt->bindValue(':email', $this->email);
        return $stmt->execute();
    }

}
