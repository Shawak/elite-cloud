(function ($) {

    var elite_cloud = window.elite_cloud || {};

    elite_cloud.extend({

        keyAuthKey: 'elite-cloud_authKey',
        keyLookupTable: 'elite-cloud_lookup',
        keyScriptPrefix: 'elite-cloud_script',
        keySettingPrefix: 'elite-cloud_setting',

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
            that.loadLocalScripts();

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

        strToKey: function (str) {
            return str.toLowerCase().replace(/ /g, '_').replace(/[^A-Za-z0-9_?!]/g, '').substr(0, 50);
        },

        getLookupTable: function () {
            var table = localStorage.getItem(that.keyLookupTable);
            return table !== null ? JSON.parse(table) : {};
        },

        setLookupTable: function (table) {
            localStorage.setItem(that.keyLookupTable, JSON.stringify(table));
        },

        getScript: function (id, key) {
            return localStorage.getItem(that.keyScriptPrefix + '_' + id + '_' + key);
        },
        
        delScript: function (id, key) {
            localStorage.removeItem(that.keyScriptPrefix + '_' + id + '_' + key);
        },

        setScript: function (id, key, script) {
            localStorage.setItem(that.keyScriptPrefix + '_' + id + '_' + key, script);
        },

        getSetting: function (id, key) {
            return JSON.parse(localStorage.getItem(that.keySettingPrefix + '_' + id + '_' + key));
        },

        setSetting: function (id, key, setting, save) {
            save = (typeof save !== 'undefined') ?  save : true;
            localStorage.setItem(that.keySettingPrefix + '_' + id + '_' + key, JSON.stringify(setting));
            if (!save) {
                return;
            }
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');
            $.ajax({
                type: 'post',
                url: encodeURI(that.root + 'api/settings/' + id),
                data: {
                    settings: JSON.stringify(settings),
                    authKey: that.getAuthKey()
                },
                dataType: 'jsonp'
            }).done(function (e) {
                if (e.success) {
                    that.log(key + ' saved settings to Database');
                } else {
                    that.log(e.message);
                }
            }).fail(function (e, status) {
                that.log('error: ' + status);
            });
        },

        loadLocalScripts: function () {
            that.log('Loading scripts from LocalStorage');
            var lookup = that.getLookupTable();
            for (var prop in lookup) {
                if (that.getScript(lookup[prop].id, lookup[prop].key)) {
                    that.injectScript(that.getScript(lookup[prop].id, lookup[prop].key), lookup[prop].id, lookup[prop].key);
                } else {
                    that.log('We found a script in LocalStorage Lookup but this is not stored');
                }
            }
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

                    that.log('Updating userscripts (' + e.data.data.length +') ..');

                    var table = that.getLookupTable();
                    for (var i = 0; i < e.data.data.length; i++) {
                        var info = e.data.data[i];
                        that.log('Updating script "' + info.name + '"');
                        // check if the script is in the lookup table
                        if (!table.hasOwnProperty(info.id)) {
                            var entry = {
                                id: info.id,
                                name: info.name,
                                key: that.strToKey(info.name)
                            };
                            table[info.id] = entry;
                        } else {
                            var entry = table[info.id];
                            // update the key name if the script name has changed
                            if (entry.name != info.name) {
                                var tmp = that.getScript(entry.id, entry.key);
                                that.delScript(entry.id, entry.key);
                                entry.key = that.strToKey(info.name);
                                that.setScript(entry.id, entry.key, tmp);
                            }
                        }

                        that.setScript(entry.id, entry.key, info.script);
                        that.setSetting(entry.id, entry.key, info.data, false);
                    }

                    that.setLookupTable(table);
                } else {
                    that.setMessage(e.message);
                    that.showForm();
                }
            }).fail(function (e, status) {
                that.log('error: ' + status);
            });
        },

        logout: function () {
            that.delAuthKey();
            location.reload();
        },

        /*setSettings: function (settings) {
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');
            $.ajax({
                type: 'post',
                url: encodeURI(that.root + 'api/settings/' + id),
                data: {
                    settings: JSON.stringify(settings),
                    authKey: that.getAuthKey()
                },
                dataType: 'jsonp'
            }).done(function (e) {
                if (e.success) {
                    // localStorage.removeItem('settings_' + key_name); // force-delete the old whole-script
                    localStorage.setItem('settings_' + key, JSON.stringify(settings));
                    that.log('[' + key + ']Successfully saved settings to Database');
                } else {
                    that.log('[' + key + '][Error] =>' + e.message);
                }
            }).fail(function (e, status, err) {
                that.log('error: ' + status);
            });

            return true;
        },*/

        // Load on every start for every script
        /*loadSettings: function (settings) {
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');

            var ssetting = that.getSetting(id, key);

            if (ssetting) {
                that.log(key + ' loaded setting from local storage');
                that.setSetting(id, key, ssetting);
                console.log(ssetting);
                return ssetting;
            } else {
                // if not in localStorage check Database first
                $.ajax({
                    type: 'get',
                    url: encodeURI(that.root + 'api/settings/' + id),
                    data: {
                        authKey: that.getAuthKey()
                    },
                    dataType: 'jsonp'
                }).done(function (e) {
                    if (e.success) {
                        that.setSetting(id, key, e.data.userSettings);
                        that.log('[' + key + ']Successfully loaded setting from Database');
                        return e.data.userSettings;
                    } else {
                        that.setSetting(id, key, settings);
                        that.log('[' + key + ']Successfully loaded setting from default');
                        return settings; // returning default settings
                    }
                }).fail(function (e, status, err) {
                    that.log('[' + key + '][Error] =>' + status);
                });
            }
        },*/


    });

    var that = elite_cloud;
    elite_cloud.init();

})(jQuery);