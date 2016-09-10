{extends file="wrapper.tpl"}
{block name="title"}
    {if $user}
        {$user->getName()} - {PROJECT_NAME}
    {else}
        Not found
    {/if}
{/block}
{block name="page"}
    {if $user}
        <h3>{$user->getName()}</h3>
    {else}
        A user with this id does not exists.
    {/if}
{/block}