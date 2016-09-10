{extends file="wrapper.tpl"}
{block name="title"}
    Userscripts - {PROJECT_NAME}
{/block}
{block name="page"}
    <div id="userscriptsWrapper">
        <form>
            <input type="text" class="form-control right" placeholder="Search..">
        </form>
        <div class="clear"></div>

        <!--<div class="table-responsive">
            <table class="table table-striped" ng-controller="UserscriptsController">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Author</th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="userscript in userscripts" ng-click="click(userscript)">
                        <td>[[userscript.name]]</td>
                        <td>[[userscript.author.name]]</td>
                    </tr>
                </tbody>
            </table>
        </div>-->

        <div ng-controller="UserscriptsController">
            <div class="userscript" ng-repeat="userscript in userscripts" ng-click="click(userscript)">
                <img src="https://cdn4.iconfinder.com/data/icons/icocentre-free-icons/171/f-script_256-128.png">
                <div class="info">
                    <div>[[userscript.name]]</div>
                    <div>Author: [[userscript.author.name]]</div>
                    <div>Users</div>
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