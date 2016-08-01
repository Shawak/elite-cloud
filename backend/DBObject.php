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
            if (strpos($key, '.') !== false) {
                $t = explode('.', $key);
                if (strtolower($t[0]) != strtolower(static::class)) {
                    continue;
                }
                $key = $t[1];
            }
            $this->$key = $value;
        }
        return true;
    }

}