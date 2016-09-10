{extends file="wrapper.tpl"}
{block name="title"}
    {if $userscript}
        {$userscript->getName()} - {PROJECT_NAME}
    {else}
        Not found
    {/if}
{/block}
{block name="page"}
    <div id="userscriptWrapper">
        {if $userscript}
            <h3>{$userscript->getName()}</h3>
            Author: {$userscript->getAuthor()->getName()}<br><br>
            <textarea spellcheck="false" readonly="readonly">{$userscript->getScript()}</textarea>
        {else}
            A userscript with this id does not exists.
        {/if}
    </div>
{/block}