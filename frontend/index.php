<!DOCTYPE html>
<html>
<head>
    <title>elite-cloud</title>
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