<?php

abstract class DBObject
{

    public abstract function update();

    public abstract function save();

    public function consume($dbData)
    {
        if (!$dbData) {
            return false;
        }

        foreach ($dbData as $key => $value) {
            $this->$key = $value;
        }
        return true;
    }

}