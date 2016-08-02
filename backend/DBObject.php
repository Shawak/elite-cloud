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

        $dbData = self::filterData($dbData);
        foreach ($dbData as $key => $value) {
            $this->$key = $value;
        }
        return true;
    }

    public static function fromData($dbData)
    {
        if (!$dbData) {
            return null;
        }

        $dbData = self::filterData($dbData);
        if (!$dbData['id']) {
            return null;
        }

        $ret = new static($dbData['id']);
        $ret->consume($dbData);
        return $ret;
    }

    private static function filterData($dbData)
    {
        $ret = [];
        foreach ($dbData as $key => $value) {
            if (strpos($key, '.') !== false) {
                $t = explode('.', $key);
                if (strtolower($t[0]) != strtolower(static::class)) {
                    continue;
                }
                $key = $t[1];
            }
            $ret[$key] = $value;
        }
        return $ret;
    }

}