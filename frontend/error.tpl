{extends file="index.tpl"}
{block name="title"}
    Error - {PROJECT_NAME}
{/block}
{block name="content"}
    <section class="content">
        <div class="container">
            {$error}
        </div>
    </section>
{/block}