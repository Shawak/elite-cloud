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
            <div ng-controller="UserscriptController" ng-init="init({$userscript->getID()})">
                <div class="header">
                    <div class="info left">
                        <img class="left"
                             src="https://cdn4.iconfinder.com/data/icons/icocentre-free-icons/171/f-script_256-128.png">
                        <div class="name"><input type="text" ng-model="userscript.name" readonly="readonly"></div>
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
                        {if $userscript->getAuthor()->getID() eq LoginHandler::getInstance()->getUser()->getID()}
                          <a class="btn btn-sm btn-success" href role="button" ng-click="edit($event)">Edit userscript</a>
                          <a class="btn btn-sm btn-danger" href role="button" ng-click="delete($event)">Delete userscript</a>
                        {/if}
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
                            Include
                        </span>
                    </div>
                    <div class="box-text settings">
                        <div style="margin: 1px 0px" ng-repeat="inc in userscript.include track by $index">
                            <button class="btn btn-sm btn-danger" style="display: none" href role="button" ng-click="userscript.include.splice($index, 1)">-</button>
                            <input type="text" ng-model="inc" readonly="readonly">
                        </div>
                        <input class="addNew" style="margin-top: 4px; display: none" type="text" ng-keyup="$event.keyCode == 13 ? addToInclude() : null">
                    </div>
                </div>
                <div class="box">
                    <div class="box-title-wrapper">
                        <span class="box-title">
                            Script
                        </span>
                    </div>
                    <div class="box-text">
                        <textarea id="textarea_script" spellcheck="false"
                                  readonly="readonly">{$userscript->getScript()}</textarea>
                    </div>
                </div>
            </div>
        {else}
            A userscript with this id does not exists.
        {/if}
    </div>
{/block}
