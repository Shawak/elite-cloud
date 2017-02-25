{extends file="wrapper.tpl"}
{block name="title"}
    Error - {PROJECT_NAME}
{/block}
{block name="page"}
    <div id="errorWrapper">
        {$error}
    </div>
{/block}