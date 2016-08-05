<!DOCTYPE html>
<html lang="en">
<head>
    <title>elite-cloud</title>
    <link rel="icon" href="frontend/images/favicon.png">

    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
</head>
<body>
<?php
// $db and all classes can be used here also if wanted
?>
<?php if (rand(1, 2) == 1): ?>
    <p>html here</p>
<?php else: ?>
    <p>other html here</p>
<?php endif; ?>

<br>
Test<br>
Copyright <?= Helper::copyYear(2016); ?> <?= LOGGED_IN ? "Logged in as " . LoginHandler::getInstance()->getUser()->getName() : "Not logged in" ?>
</body>
</html>