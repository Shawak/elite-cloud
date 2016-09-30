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
            <div class="header" ng-controller="UserscriptController" ng-init="init({$userscript->getID()})">
                <div class="info left">
                    <img class="left"
                         src="https://cdn4.iconfinder.com/data/icons/icocentre-free-icons/171/f-script_256-128.png">
                    <div class="name"><input type="text" value="{$userscript->getName()}" readonly="readonly"></div>
                    <div class="author">Author: {$userscript->getAuthor()->getName()}</div>
                    <div class="users">Users: {$userscript->users}</div>
                </div>
                <div class="buttons right">
                    <div class="enabled">
                        <span> Enabled:</span>
                        <label class="switch" ng-click="toggle($event)">
                            <input type="checkbox" {if $userscript->selected}checked{/if}>
                            <div class="slider round"></div>
                        </label>
                    </div>
                    <a class="btn btn-sm btn-success" href role="button"
                       ng-click="edit($event, {$userscript->getID()})">Edit userscript</a>
                    <a class="btn btn-sm btn-danger" href role="button">Delete userscript</a>
                </div>
                <div class="clear"></div>
            </div>
            <div class="box">
                <div class="box-title-wrapper">
                    <span class="box-title">
                        Description
                    </span>
                </div>
                <div class="box-text description">
                    {$userscript->getMarkdownDescription() nofilter}
                </div>
            </div>
            <div class="box">
                <div class="box-title-wrapper">
                    <span class="box-title">
                        Script
                    </span>
                </div>
                <div class="box-text">
                    <textarea spellcheck="false" readonly="readonly">{$userscript->getScript()}</textarea>
                </div>
            </div>
        {else}
            A userscript with this id does not exists.
        {/if}
    </div>
{/block}