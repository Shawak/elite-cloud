{extends file="index.tpl"}
{block name="title"}
    {if $user}
        {$user->getName()}
    {else}
        Not found
    {/if}
{/block}
{block name="content"}
    {if $user}
        <h3>{$user->getName()}</h3>
    {else}
        A user with this id does not exists.
    {/if}
{/block}