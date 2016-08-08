{extends file="index.tpl"}
{block name="title"}
    Userscripts - {PROJECT_NAME}
{/block}
{block name="content"}
    <form>
        <input type="text" class="form-control right" placeholder="Search..">
    </form>
    <div class="clear"></div>

    <div class="table-responsive">
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
    </div>

{/block}