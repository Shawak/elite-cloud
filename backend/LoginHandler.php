<?php

class LoginHandler
{
    private static $instance;

    private $user;

    private function __construct()
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
            $user = new User(session('user_id'));
            if ($user->update()) {
                $this->user = $user;
            }
        }
        return $this->user;
    }

    public function login($username, $password, $remember = false)
    {
        $user = Database::getInstance()->getUserByName($username);
        if (!$user) {
            return false;
        }
        $this->user = $user;

        if (!$this->verifyPassword($password)) {
            return false;
        }

        session('user_id', $this->getUser()->getID());
        session('hash', $this->getUser()->getPassword());
        if ($remember) {
            $this->createAuthToken();
        }
        return true;
    }

    private function deleteAuthTokens()
    {
        $stmt = Database::getInstance()->prepare('
            delete from auth_token
            where user_id = :user_id
		');
        $stmt->bindParam(':user_id', $this->getUser()->getID());
        $stmt->execute();
    }

    private function createAuthToken()
    {
        $this->deleteAuthTokens();
        $selector = KeyGenerator::generateSelector();
        $validator = bin2hex(random_bytes(32));
        $token = hash('sha256', $validator);
        AuthToken::create($selector, $token, $this->getUser()->getID());
        cookie('remember', $selector . ':' . $validator);
    }

    public function verifyPassword($password)
    {
        return password_verify(
            base64_encode(
                hash('sha384', $password, true)
            ),
            $this->getUser()->getPassword()
        );
    }

    public function hashPassword($password)
    {
        return password_hash(
            base64_encode(
                hash('sha384', $password, true)
            ), PASSWORD_BCRYPT
        );
    }

    public function isLoggedIn()
    {
        return $this->getUser() !== null && $this->getUser()->getPassword() === session('hash');
    }

    public function logout()
    {
        $this->deleteAuthTokens();
        session('user_id', null);
        session('hash', null);
        cookie('remember', null);
    }

    public function autoLogin()
    {
        if (session('user_id') == null) {
            $cookie = cookie('remember');
            if ($cookie === null || strpos($cookie, ':') === false) {
                return false;
            }

            list($selector, $validator) = explode(':', $cookie);
            $authToken = Database::getAuthToken($selector);
            if (!$authToken) {
                return false;
            }

            $validator = hash('sha256', $validator);
            if (!hash_equals($authToken->getToken(), $validator)) {
                return false;
            }

            session('user_id', $authToken->getUserID());
            session('hash', $this->getUser()->getPassword());
            $this->deleteAuthTokens();
            $this->createAuthToken();
        } else {
            session('user_id', session('user_id'));
            session('hash', session('hash'));
        }
        return $this->isLoggedIn();
    }

}