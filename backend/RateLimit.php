<?php

class RateLimit
{
    private static $instance;

    private $time;
    private $count;

    private function __construct($time, $count)
    {
        $this->time = $time;
        $this->count = $count;
    }

    public static function getInstance()
    {
        if (!isset(self::$instance)) {
            die('RateLimit not initialized.');
        }
        return self::$instance;
    }

    public static function initialize($time, $count)
    {
        if (isset(self::$instance)) {
            die('RateLimit already initialized.');
        }
        self::$instance = new self($time, $count);
    }

    public function isAboveLimit()
    {
        $visits = session('rate_limit_visits');
        if ($visits === null && !is_array($visits)) {
            $visits = array();
        }

        $now = time();
        foreach ($visits as $index => $visit) {
            if ($now - $visit >= $this->time) {
                unset($visits[$index]);
            }
        }

        if (count($visits) >= $this->count) {
            return true;
        }

        array_push($visits, time());
        session('rate_limit_visits', $visits);
        return false;
    }

}