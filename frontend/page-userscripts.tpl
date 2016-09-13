{extends file="wrapper.tpl"}
{block name="title"}
    Userscripts - {PROJECT_NAME}
{/block}
{block name="page"}
    <div id="userscriptsWrapper">
        <form>
            <input type="text" class="form-control left" placeholder="Search..">
        </form>
        <div class="clear"></div>

        <div ng-controller="UserscriptsController">
            <div class="userscript" ng-repeat="userscript in userscripts" ng-click="click(userscript)">
                <img src="https://cdn4.iconfinder.com/data/icons/icocentre-free-icons/171/f-script_256-128.png">
                <div class="info">
                    <span class="name">[[userscript.name]]</span>
                    <span class="author">(Uploaded by [[userscript.author.name]])</span>
                    <span class="users"></span>
                    <span class="description">[[userscript.description || 'no description available']]</span>
                </div>
                <div class="buttons">
                    <a class="btn btn-sm btn-success" href role="button"
                       ng-click="$event.stopPropagation(); add(userscript)"
                       ng-if="!userscript.selected">Add to
                        account</a>
                    <a class="btn btn-sm btn-danger" href role="button"
                       ng-click="$event.stopPropagation(); remove(userscript)"
                       ng-if="userscript.selected">Remove from
                        account</a>
                </div>
                <div class="clear"></div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
{/block}