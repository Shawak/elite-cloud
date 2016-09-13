{extends file="wrapper.tpl"}
{block name="title"}
    Userscripts - {PROJECT_NAME}
{/block}
{block name="page"}
    <div id="userscriptsWrapper">
        <form>
            <input type="text" class="form-control left" placeholder="Search..">
        </form>
        <a class="btn btn-primary right" href="create" role="button">Create userscript</a>

        <div class="clear"></div>

        <table style="width: 100%">
            <thead>
            <tr>
                <th class="info">Userscript</th>
                <th class="author">Author</th>
                <th class="users">Users</th>
                <th class="enabled">Enabled</th>
            </tr>
            </thead>
            <tbody ng-controller="UserscriptsController">
            <tr class="userscript" ng-repeat="userscript in userscripts" ng-click="click(userscript)">
                <td class="info">
                    <img src="https://cdn4.iconfinder.com/data/icons/icocentre-free-icons/171/f-script_256-128.png">
                    <span class="name">[[userscript.name]]</span>
                    <span class="description">[[userscript.description || 'no description available']]</span>
                </td>
                <td class="author">[[userscript.author.name]]</td>
                <td class="users">[[userscript.users]]</td>
                <td class="enabled">
                    <label class="switch" ng-click="toggle($event, userscript)">
                        <input type="checkbox" ng-checked="userscript.selected">
                        <div class="slider round"></div>
                    </label>
                </td>
            </tr>
            </tbody>
        </table>
        <div class="clear"></div>
    </div>
{/block}