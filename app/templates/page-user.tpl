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
    <div class="container-fluid" ng-controller="UserController" ng-init="init({$user->getID()})">
      <div class="col-xs-12">

        <div class="panel panel-default">
          <div class="panel-body">
            <h3>Account Information</h3>
            <div class="row">
              <div class="col-sm-4 col-md-3">
                <img src="http://placehold.it/150x150" alt="Userpicture" class="img-rounded img-responsive" />
              </div>
              <div class="col-sm-4 col-md-4">
                <table class="table table-user-information">
                  <tbody>
                    <tr>
                      <td>Username:</td>
                      <td>{$user->getName()}</td>
                    </tr>
                    <tr>
                      <td>Joined at:</td>
                      <td>{$user->getRegisteredTimestamp()|date_format:"%d-%m-%Y"}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-sm-4 col-md-5">
                <div id="usingScripts"></div>
              </div>
            </div>
          </div>
        </div>

        <div class="panel panel-default">
          <div class="panel-body">
            <h3>Scripts User is using</h3>
            <div class="panel panel-default panel-table">
              <div class="panel-body">
                <table class="table table-list">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Author</th>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach key=id item=data from=$user->getSelectedUserscripts()}
                    <tr>
                        <td>{$data->name}</td>
                        <td><a href="user/{$wert->author->id}">{$data->author->name}</a></td>
                    </tr>
                    {/foreach}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <script>
      var g = new JustGage({
        id: "usingScripts",
        value: {$user->getSelectedUserscriptCount()},
        min: 0,
        max: {Database::getUserscriptCount()},
        gaugeWidthScale: 0.2,
        levelColors: ['#7CFC00', '#7CFC00', '#7CFC00', '#7CFC00'],
        hideInnerShadow: true,
        title: "Using Scripts"
      });
    </script>

    {else}
        A user with this id does not exists.
    {/if}
{/block}

{block name="scriptjs"}
  <!-- JustGage -->
  <script src="js/raphael-2.1.4.min.js"></script>
  <script src="js/justgage.js"></script>
{/block}
