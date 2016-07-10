<?php

use Slim\Http\Request as Request;
use Slim\Http\Response as Response;

$app = new \Slim\App(["settings" => $config['slim']]);

$app->get('/', function(Request $request, Response $response) {
	include DIR_FRONTEND . 'index.php';
});

/* USER */

$app->post('/api/login', function(Request $request, Response $response) {
	
});

$app->get('/api/user/{id}', function(Request $request, Response $response, $args) use ($db) {
	$id = $args['id'];
	$user = new User($id);
	if($user->update($db)) {
		echo new ApiResult(true, null, array(
			'id' => $user->getId(),
			'name' => $user->getName()
		));	
	} else {
		echo new ApiResult(false, 'A user with this id does not exists');
	}
});

$app->post('/api/user/create', function(Request $request, Response $response) {

});

/* USERSCRIPT */

$app->get('/api/userscript/list', function(Request $request, Response $response) {

});

$app->get('/api/userscript/{id}', function(Request $request, Response $response, $args) {
	echo $args['id'];
});

$app->post('/api/userscript/create', function(Request $request, Response $response, $args) {

});

$app->post('/api/userscript/edit', function(Request $request, Response $response, $args) {

});

/* APP */
$app->run();