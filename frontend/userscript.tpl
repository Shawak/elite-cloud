{extends file="index.tpl"}
{block name="title"}
    {if $userscript}
        {$userscript->getName()}
    {else}
        Not found
    {/if}
{/block}
{block name="content"}
    {if $userscript}
        <h3>{$userscript->getName()}</h3>
        <textarea spellcheck="false" readonly="readonly">{$userscript->getScript()}</textarea>
    {else}
        A userscript with this id does not exists.
    {/if}
{/block}