<?php

class ApiResult {

	private $success;
	private $message;
	private $data;
	
	public function isSuccess() { return $this->success; }
	public function getMessage() { return $this->message; }
	public function getData() { return $this->data; }
	
	public function setMessage($msg) { $this->message = $msg; }
	public function setData($data) { $this->data = $data; }
	
	public function __construct($success, $message = null, $data = null) {
		$this->success = $success;
		$this->message = $message;
		$this->data = $data;
	}
	
	public function __toString() {
		return json_encode(array(
			'success' => $this->success,
			'message' => $this->message != null ? $this->message : '',
			'data' => $this->data));
	}

}