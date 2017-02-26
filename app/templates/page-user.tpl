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
    <div class="container-fluid">
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
                <div id="usindScripts"></div>
              </div>
            </div>
          </div>
        </div>

        {if LoginHandler::getInstance()->getUser()}
          {if LoginHandler::getInstance()->getUser()->getID() == $user->getID()}
        <div class="panel panel-default">
          <div class="panel-body">
            <h3>Settings</h3>
            <div class="row">
              <label for="inputType" class="col-sm-4 col-md-3 control-label">Authkey</label>
              <div class="col-sm-6 col-md-7">
                  <input type="text" class="form-control authkey" id="key" value="{$user->getAuthKey()}" autocomplete="off" readonly>
              </div>
            </div>
          </div>
        </div>
          {/if}
        {/if}

        <div class="panel panel-default">
          <div class="panel-body">
            <h3>Scripts User is using</h3>
            <div class="panel panel-default panel-table">
              <div class="panel-body">
                <table class="table table-list">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Author</th>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach key=id item=data from=$scripts}
                    <tr>
                        <td>{$id}</td>
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
    $( document ).ready(function() {
      $( "#key" )
        .mouseover(function() {
          $( this ).css( "color", "black" );
          $( this ).css( "text-shadow", "0 0 0px rgba(0, 0, 0, 0.5)" );
      })
        .mouseout(function() {
          $( this ).css( "color", "transparent" );
          $( this ).css( "text-shadow", "0 0 6px rgba(0, 0, 0, 0.5)" );
      });
    });
    </script>
    <script>
      var g = new JustGage({
        id: "usindScripts",
        value: {Database::getUserUserscriptCount($user->getId())},
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
