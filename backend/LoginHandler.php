<?php

class LoginHandler
{
    private static $instance;

    private $user;

    public function __construct()
    {

    }

    public static function getInstance()
    {
        if (!self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getUser()
    {
        if ($this->user == null) {
            $user = new User(session('userID'));
            if ($user->update()) {
                $this->user = $user;
            }
        }
        return $this->user;
    }

    public function login($username, $passwordHash, $remember = false)
    {
        $stmt = Database::getInstance()->prepare('
			select *
			from user
			where name = :username
			and password = :password
		');
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $passwordHash);
        $stmt->execute();
        $ret = $stmt->fetch();

        if ($ret) {
            $this->user = User::fromData($ret);
            session('userID', $this->user->getID());
            session('hash', $passwordHash);
            if ($remember) {
                cookie('userID', $this->user->getID());
                cookie('hash', $passwordHash);
            }
            return true;
        } else {
            return false;
        }
    }

    public function hashPassword($password)
    {
        return hash('sha256', $password);
    }

    public function isLoggedIn()
    {
        $userID = session('userID');
        $passwordHash = session('hash');
        // refresh the session variables
        session('userID', $userID);
        session('hash', $passwordHash);
        return $this->getUser() != null && $this->getUser()->getPassword() == $passwordHash;
    }

    public function logout()
    {
        session('userID', null);
        session('hash', null);
        cookie('userID', null);
        cookie('hash', null);
    }

    public function autoLogin()
    {
        if (session('userID') == null) {
            session('userID', cookie('userID'));
        }
        if (session('hash') == null) {
            session('hash', cookie('hash'));
        }
        return $this->isLoggedIn();
    }

}