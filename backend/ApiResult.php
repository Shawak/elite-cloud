<?php

class ApiResult
{

    public $success;
    public $message;
    public $data;

    public function isSuccess()
    {
        return $this->success;
    }

    public function getMessage()
    {
        return $this->message;
    }

    public function getData()
    {
        return $this->data;
    }

    public function setMessage($msg)
    {
        $this->message = $msg;
    }

    public function setData($data)
    {
        $this->data = $data;
    }

    public function __construct($success, $message = null, $data = null)
    {
        $this->success = $success;
        $this->message = $message;
        $this->data = $data;
    }

    public function __toString()
    {
        $json = json_encode($this);
        $callback = get('callback');
        if ($callback) {
            // JSONP
            return $callback . '(' . $json . ')';
        } else {
            return $json;
        }
    }

}