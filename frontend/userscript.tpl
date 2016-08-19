{extends file="page-wrapper.tpl"}
{block name="title"}
    {if $userscript}
        {$userscript->getName()} - {PROJECT_NAME}
    {else}
        Not found
    {/if}
{/block}
{block name="page"}
    {if $userscript}
        <h3>{$userscript->getName()}</h3>
        <textarea spellcheck="false" readonly="readonly">{$userscript->getScript()}</textarea>
    {else}
        A userscript with this id does not exists.
    {/if}
{/block}