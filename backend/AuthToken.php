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
        $stmt->bindParam(':selector', $selector, PDO::PARAM_STR);
        $stmt->bindParam(':token', $token, PDO::PARAM_STR);
        $stmt->bindParam(':user_id', $user_id, PDO::PARAM_INT);
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