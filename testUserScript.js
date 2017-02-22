// From elite-Cloud

/**
 * @var elite_cloud_script_id
 * @return Gives you the current script ID
 **/

/**
 * @var settings
 * @return Load cached settings , if not use default
 **/
var myKey = document.currentScript.getAttribute('id');
var settings = elite_cloud.loadSettings({
  "reason": "This post is wrong."
}, myKey );

// Main script starts here
function instantDeleteChangeSettings(reason) {
  settings['reason'] = reason;
  elite_cloud.setSettings(settings, myKey );
}
function getReason() {
  console.log(settings['reason']);
}

function with_jquery(f) {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.textContent = "(" + f.toString() + ")(jQuery)";
  document.body.appendChild(script);
};

with_jquery(function ($) {
  var FLAG_DELETED = 0x02;

  var checkDeleted = typeof $("#collapseobj_quickreply").html() == typeof undefined;
  if(checkDeleted){ return; }

  $('input[id^="plist_"]').each(function () {
    var postId = $(this).attr('id').split('_')[1],
    isDeleted = parseInt($(this).attr('value')) & FLAG_DELETED;

    if (!isDeleted) {
      $(this).before(
        $(document.createElement('input'))
        .attr({
          type: 'button',
          id: 'delete_' + postId,
          value: 'Delete Post',
          style: 'border: none;padding: 0;background: none;color: white;text-decoration: underline;font-weight: bold;font-size: 12px;'
        })
        .click(function () {
          // Make sure the user cannot fire another request
          $(this).prop("disabled", true);
          $("input[id='delete_" + postId + "']")
          .closest('tr')
          .next()
          .hide('fast');
          $.ajax({
            url: "inlinemod.php",
            type: 'POST',
            data: {
              'deletereason': settings['reason'] ? settings['reason'] : "",
              'deletetype': "1",
              'do': "dodeleteposts",
              'securitytoken': window.SECURITYTOKEN,
              'postids': postId,
              't': window.threadid
            },
            success: function (data) {
              $('#post' + postId).after('<table width="100%" cellspacing="0" cellpadding="6" border="0" align="center" class="tborder"><tbody><tr><td style="font-weight:normal; border: 1px solid #EDEDED; border-right: 0px" class="thead">Successfully</td></tr><tr valign="top"><td width="175" style="border: 1px solid #EDEDED; border-top: 0px; border-bottom: 0px" class="alt2"><div class="smallfont">&nbsp;<br><b>Post got deleted</b><br>&nbsp;</div>  </td></tr></tbody></table>');
              $('#post' + postId).remove();
            }
          });
      }));
    } else {
    if (window.location.protocol != "https:") {
      var urlGet = "http://www.elitepvpers.com/forum/postings.php?do=managepost&p=";
    } else {
      var urlGet = "https://www.elitepvpers.com/forum/postings.php?do=managepost&p=";
    }
    var jqxhr = $.get( urlGet + postId, function() {
      // none
    })
    .fail(function() {
      console.log( "[Error][" + elite_cloud_script_id + "] => " + window.location.href);
    });

    jqxhr.always(function() {
      var buffer = jqxhr.responseText;
      $( '#post' + postId ).closest("div").find('.alt1').html( '<div class="spoiler-uncoll"><div><span class="spoiler-title rounded-top"><a class="spoiler-button" href="'+window.location.href+'"#post'+ postId +'" rel="nofollow" onclick="return toggleSpoiler.call(this);"><span class="spoiler-icon">&nbsp;</span><span class="spoiler-text">Show text</span></a></span></div><div class="spoiler-content rounded-bottom alt1" style="display: none;">' + $(buffer).find(".alt2").html() + '</div></div>' );
      $( "#post" + postId ).find('.alt2:first').append( '<br/><small>Delete Reason:</small>' + $(buffer).find( "input[name='reason']" ).val() );
    });

    $( this ).closest( "table" ).css( "opacity", ".7" );
    $( this ).closest( "div").find('.alt1').text( 'Loading text...' );

    $(this).before(
      $(document.createElement('input'))
      .attr({
        type: 'button',
        id: 'redelete_' + postId,
        value: 'Restore Post',
        style: 'border: none;padding: 0;background: none;color: white;text-decoration: underline;font-weight: bold;font-size: 12px;'
      })
      .click(function () {
        // Make sure the user cannot fire another request
        $(this).prop("disabled", true);
        $("input[id='redelete_" + postId + "']")
        .closest('tr')
        .next()
        .hide('fast');
        document.cookie = "vbulletin_inlinepost="+postId + ";path=/";
        $.ajax({
          url: "inlinemod.php",
          type: 'POST',
          data: {
            'do': "undeleteposts",
            'securitytoken': window.SECURITYTOKEN,
            'postids': postId,
            't': window.threadid
          },
          success: function (data) {
            $('#post' + postId).after('<table width="100%" cellspacing="0" cellpadding="6" border="0" align="center" class="tborder"><tbody><tr><td style="font-weight:normal; border: 1px solid #EDEDED; border-right: 0px" class="thead">Successfully</td></tr><tr valign="top"><td width="175" style="border: 1px solid #EDEDED; border-top: 0px; border-bottom: 0px" class="alt2"><div class="smallfont">&nbsp;<br><b>Restored successfully</b><br>&nbsp;</div>  </td></tr></tbody></table>');
            $('#post' + postId).remove();
          }
        });
      })
    );
  } // end else
  }); // end each
});
