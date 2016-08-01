<?php

class Userscript extends DBObject
{

    protected $id;
    protected $name;
    protected $author;
    protected $file;

    public function __construct($id)
    {
        $this->id = $id;
        $this->update();
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

        $userscript = new self(Database::getInstance()->lastID());
        $userscript->update();
        return $userscript;
    }

    public function getID()
    {
        return $this->id;
    }

    public function getName()
    {
        return $this->name;
    }

    public function getAuthor() {
        return $this->author;
    }

    public function getFile() {
        return $this->file;
    }

    public function update()
    {
        $stmt = Database::getInstance()->prepare('
			select *
			from userscript
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
			update userscript
			set name = :name
			set file = :file
			where id = :id
		');
        $stmt->bindParam(':name', $this->id);
        $stmt->bindParam(':file', $this->file);
        return $stmt->execute() == true;
    }
}