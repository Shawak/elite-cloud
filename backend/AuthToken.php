<?php

class AuthToken extends DBObject
{

    public $id;
    public $selector;
    public $token;
    public $user_id;

    public function getUserID()
    {
        return $this->user_id;
    }

    public function getToken()
    {
        return $this->token;
    }

    public static function create($selector, $token, $user_id)
    {
        $stmt = Database::getInstance()->prepare('
			insert into auth_token
			(selector, token, user_id)
			values (:selector, :token, :user_id)
		');
        $stmt->bindValue(':selector', $selector);
        $stmt->bindValue(':token', $token);
        $stmt->bindValue(':user_id', $user_id);
        $stmt->execute();
        return new self(Database::getInstance()->lastID());
    }

    public function save()
    {

    }

    public function update()
    {

    }

}