<?php

abstract class DBObject {

	public abstract function update(Database $db);
	public abstract function save(Database $db);
	
	public function consume($dbData) {
		if(!$dbData) {
			return false;
		}
		
		foreach($dbData as $key => $value) {
			$this->$key = $value;
		}
		return true;
	}
	
}