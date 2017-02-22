(function ($) {

    var elite_cloud = window.elite_cloud || {};

    elite_cloud.extend({

        keyAuthKey: 'elite-cloud_authKey',

        hideForm: function () {
            $('#ec_form').hide();
        },

        showForm: function () {
            $('#ec_form').show();
        },

        getAuthKey: function () {
            return localStorage.getItem(that.keyAuthKey);
        },

        setAuthKey: function (authKey) {
            localStorage.setItem(that.keyAuthKey, authKey);
        },

        delAuthKey: function () {
            localStorage.removeItem(that.keyAuthKey);
        },

        init: function () {
            that.log('Loader init()');
            that.injectPlugin(function () {
                that.login();
            });
        },

        setMessage: function (str) {
            var elem = $('#ec_message');
            if (elem.length) {
                $('#ec_message').html(str);
            }
        },

        injectPlugin: function (after) {
            $('#userbaritems').append('' +
                '<style>#ec_menuitem:hover img {opacity: 1 !important}</style>' +
                '<a href="/forum/profile.php?do=editoptions">' +
                '<li>' +
                '<div id="ec_menuitem" style="display: inline-block">' +
                '<img style="opacity: 0.8; float: left; width: 13px; height: 13px; margin-right: 5px;" src="' + that.root + '/frontend/img/favicon.png">' +
                'elite-cloud' +
                '</div>' +
                '</li>' +
                '</a>');

            var elem = $('form[action="profile.php?do=updateoptions"]');
            if (!elem.length) {
                after();
                return;
            }

            $(document).on('click', '#ec_logout', function () {
                that.logout();
            });

            $.ajax({
                url: encodeURI(that.root + 'api/plugin'),
                dataType: 'jsonp',
            }).done(function (e) {
                elem.parent().prepend(e.data.plugin).append(function () {
                    $("#ec_form").submit(function (event) {
                        event.preventDefault();
                        that.hideForm();
                        var authKey = $('#ec_authKey').val();
                        $('#ec_authKey').val('');
                        that.setAuthKey(authKey);
                        that.login();
                    });
                    after();
                });
            }).fail(function (e, status, err) {
                that.log(status);
            });
        },

        login: function () {
            var authKey = that.getAuthKey();
            if (authKey == null || authKey == '') {
                that.setMessage('No authentication key found.');
                that.showForm();
                return;
            }

            $.ajax({
                url: encodeURI(that.root + 'api/authenticate/' + authKey),
                dataType: 'jsonp',
            }).done(function (e) {
                if (e.success) {
                    that.setMessage('Authenticated as ' + e.data.user.name + ', <span id="ec_logout">logout</span>.');
                    that.log('Loading userscripts..');
                    for (var i = 0; i < e.data.userscripts.length; i++) {
                        // Check if Userscript is in LocalStorage or not
                        if ( localStorage.getItem('script_id_'+e.data.userscripts[i].key_name) ) {
                          that.log('> [' + e.data.userscripts[i].key_name + '](localStorage)');
                          that.injectScript( localStorage.getItem('script_id_'+e.data.userscripts[i].key_name), e.data.userscripts[i].key_name );
                        } else {
                          // Get the script and inject it then + LocalStorage
                          $.ajax({
                              url: encodeURI(that.root + 'api/script/' + e.data.userscripts[i].id),
                              dataType: 'jsonp'
                          }).done(function (r) {
                              that.log('> [' + r.data.key_name + '](Script) => localStorage');
                              localStorage.setItem('script_id_'+r.data.key_name, r.data.script);
                              that.injectScript(r.data.script, r.data.key_name);
                          }).fail(function (r, status) {
                              that.log('error,:' + status);
                          });
                        }
                    }
                } else {
                    that.setMessage(e.message);
                    that.showForm();
                }
            }).fail(function (e, status, err) {
                that.log('error: ' + status);
            });
        },

        logout: function () {
            that.delAuthKey();
            location.reload();
        },

        setSettings: function (settings, key_name) {
          $.ajax({
            type: "GET",
            url: encodeURI(that.root + 'api/database/setsettings/' + key_name),
            data: {
              settings: JSON.stringify(settings),
              authKey: that.getAuthKey()
            },
            dataType: 'jsonp'
          }).done(function (e) {
            if (e.success) {
              // localStorage.removeItem('settings_' + key_name); // force-delete the old whole-script
              localStorage.setItem('settings_' + key_name, JSON.stringify(settings) );
              that.log('['+key_name+']Successfully saved settings to Database');
            } else {
              that.log('['+key_name+'][Error] =>' + e.message);
            }
          }).fail(function (e, status, err) {
            that.log('error: ' + status);
          });

          return true;
        },

        // Load on every start for every script
        loadSettings: function(settings, key_name) {
          if(localStorage.getItem('settings_' + key_name)) {
            // if in localStorage
            settings = JSON.parse( localStorage.getItem('settings_' + key_name) );
            return settings;
          } else {
            // if not in localStorage check Database first
            $.ajax({
              type: "GET",
              url: encodeURI(that.root + 'api/database/getsettings/' + key_name),
              data: {
                authKey: that.getAuthKey()
              },
              dataType: 'jsonp'
            }).done(function (e) {
              if (e.success) {
                localStorage.setItem('settings_' + key_name, JSON.stringify(e.data.userSettings) );
                that.log('['+key_name+']Successfully loaded settings from Database');
                return JSON.parse(e.data.userSettings);
              } else {
                that.log('['+key_name+']Successfully loaded settings from default');
                localStorage.setItem('settings_' + key_name, JSON.stringify(settings) );
                return settings; // returning default settings
              }
            }).fail(function (e, status, err) {
              that.log('['+key_name+'][Error] =>' + status);
            });
          }
        },


    });

    var that = elite_cloud;
    elite_cloud.init();

})(jQuery);
