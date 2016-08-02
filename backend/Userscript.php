<?php

class Userscript extends DBObject
{

    public $id;
    public $name;
    public $author;
    protected $file;

    public function __construct($id)
    {
        $this->id = $id;
    }

    public static function create($name, $author, $file = '')
    {
        $stmt = Database::getInstance()->prepare('
			insert into user
			(name, author, file)
			values (:name, :author, :file)
		');
        $stmt->bindParam(':name', $name);
        $stmt->bindParam(':author', $author);
        $stmt->bindParam(':file', $file);
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

    public function getAuthor()
    {
        return $this->author;
    }

    public function getFile()
    {
        return $this->file;
    }

    public function update()
    {
        $stmt = Database::getInstance()->prepare('
			select *
			from userscript, user
			where userscript.id = :id
			  and user.id = userscript.id
		');
        $stmt->bindParam(':id', $this->id);
        $stmt->execute();
        $ret = $stmt->fetch();
        if (!$this->consume($ret)) {
            return false;
        }
        $this->author = User::fromData($ret);
        return true;
    }

    public function save()
    {
        $stmt = Database::getInstance()->prepare('
			update userscript
			set name = :name
			set file = :file
			where id = :id
		');
        $stmt->bindParam(':name', $this->id);
        $stmt->bindParam(':file', $this->file);
        return $stmt->execute();
    }
}