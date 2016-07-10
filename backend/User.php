<?php

class UserFlag {
	const USER = 1;
	const MODERATOR = 2;
	const ADMIN = 4;
}

class User extends DBObject {
	
	protected $id;
	protected $name;
	protected $password;
	protected $flag;
	
	public function __construct($id) {
		$this->id = $id;
	}
	
	public function getID() { return $this->id; }
	public function getName() { return $this->name; }
	public function isUser() { return $this->flag & UserFlag::USER; }
	public function isModerator() { return $this->flag & UserFlag::MODERATOR; }
	public function isAdmin() { return $this->flag & UserFlag::ADMIN; }
	
	public function update(Database $db) {
		$stmt = $db->prepare('
			select *
			from user
			where id = :id
		');
		$stmt->bindParam(':id', $this->id);
		$stmt->execute();
		$ret = $stmt->fetch();
		return $this->consume($ret);
	}
	
	public function save(Database $db) {
		$stmt = $db->prepare('
			update user
			set password = :password
			where id = :id
		');
		$stmt->bindParam(':id', $this->id);
		$stmt->bindParam(':password', $this->password);
		return $stmt->execute() == true;
	}
}