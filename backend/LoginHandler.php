<?php

class LoginHandler
{

    private $db;
    private $user;

    public function __construct(Database $db)
    {
        $this->db = $db;
    }

    public function getUser()
    {
        if ($this->user == null) {
            $this->user = new User(session('userID'));
            $this->user->update();
        }
        return $this->user;
    }

    public function Login($username, $passwordHash, $remember = false)
    {
        $stmt = $this->db->prepare('
			select *
			from user
			where name = :username
		');
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        $ret = $stmt->fetch();

        if ($ret && $ret['password'] == $passwordHash) {
            $userID = $ret['id'];
            $this->user = new User($userID);
            $this->user->consume($ret);
            session('userID', $userID);
            session('hash', $passwordHash);
            return true;
        } else {
            return false;
        }
    }

    public function HashPassword($password)
    {
        return hash('sha256', $password);
    }

    public function IsLoggedIn()
    {
        $userID = session('userID');
        $passwordHash = session('hash');
        return $userID !== null;
    }

    public function Logout()
    {
        session('userID', null);
        session('hash', null);
        cookie('userID', null);
        cookie('hash', null);
    }

    public function AutoLogin()
    {
        if (session('userID') == null) {
            session('userID', cookie('userID'));
        }
        if (session('hash') == null) {
            session('hash', cookie('hash'));
        }
        return $this->IsLoggedIn();
    }

}