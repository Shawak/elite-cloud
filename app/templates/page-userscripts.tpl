{extends file="wrapper.tpl"}
{block name="title"}
    Userscripts - {PROJECT_NAME}
{/block}
{block name="page"}
    <div id="userscriptsWrapper" ng-controller="UserscriptsController">
        <form>
            <input type="text" class="form-control left" placeholder="Search.." ng-model="search" ng-change="update()">
        </form>
        <a class="btn btn-info left" style="margin-left: 100px" href="elite-cloud.user.js" role="button">Install elite-cloud</a>
        <a class="btn btn-primary right" href="userscript/do/create" role="button">Create userscript</a>
        <div class="clear"></div>

        <table>
            <thead>
            <tr>
                <th class="info" ng-class="lastSort=='name' ? 'active' : ''">
                    <a href ng-click="update('name')">
                        Userscript
                    </a>
                </th>
                <th class="author" ng-class="lastSort=='author' ? 'active' : ''">
                    <a href ng-click="update('author')">
                        Author
                    </a>
                </th>
                <th class="users" ng-class="lastSort=='users' ? 'active' : ''">
                    <a href ng-click="update('users')">
                        Users
                    </a>
                </th>
                <th class="enabled" ng-class="lastSort=='selected' ? 'active' : ''">
                    <a href ng-click="update('selected')">
                        Enabled
                    </a>
                </th>
            </tr>
            </thead>
            <tbody>
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

        <div class="textcenter">
            <span class="center">
                <div class="btn btn-primary" role="button" ng-click="changePage('first')">First</div>
                <div class="btn btn-primary" role="button" ng-click="changePage(-1)">&laquo</div>
                <span style="margin: 0 15px">[[page]] / [[pages]]</span>
                <div class="btn btn-primary" role="button" ng-click="changePage(1)">&raquo;</div>
                <div class="btn btn-primary" role="button" ng-click="changePage('last')">Last</div>
            </span>
        </div>

    </div>
{/block}
