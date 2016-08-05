<!DOCTYPE html>
<html lang="en">
<head>
    <title>{block name="title"}{/block} - elite-cloud</title>
    <link rel="icon" href="frontend/images/favicon.png">

    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
</head>
<body>

{if rand(1, 2) == 1}
    <p>html here</p>
{else}
    <p>other html here</p>
{/if}

{block name="body"}{/block}

<br>
Test<br>

Copyright {Helper::copyYear(2016)}
{if LOGGED_IN}
    Logged in as {LoginHandler::getInstance()->getUser()->getName()}
{else}
    Not logged in
{/if}

</body>
</html>