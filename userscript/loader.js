(function ($) {

    var elite_cloud = window.elite_cloud || {};

    elite_cloud.extend({

        keyAuthKey: 'elite-cloud_authKey',
        keyLookupTable: 'elite-cloud_lookup',
        keyScriptPrefix: 'elite-cloud_script',

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
            }).fail(function (e, status) {
                that.log(status);
            });
        },

        strToKey: function (str) {
            return str.toLowerCase().replace(/ /g, '_').replace(/[^A-Za-z0-9_?!]/g, '').substr(0, 50);
        },

        getLookupTable: function () {
            var table = localStorage.getItem(that.keyLookupTable);
            return table ? JSON.parse(table) : {};
        },

        setLookupTable: function (table) {
            localStorage.setItem(that.keyLookupTable, JSON.stringify(table));
        },

        getScript: function (id, key) {
            return localStorage.getItem(that.keyScriptPrefix + '_' + id + '_' + key)
        },

        setScript: function (id, key, script) {
            localStorage.setItem(that.keyScriptPrefix + '_' + id + '_' + key, script);
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
                        var script = e.data.userscripts[i];
                        var table = that.getLookupTable();

                        // we don't store information about the script yet
                        if (!table.hasOwnProperty(script.id)) {
                            that.log('adding script info to lookup table');
                            var entry = {
                                id: script.id,
                                name: script.name,
                                key: that.strToKey(script.name)
                            };
                            table[script.id] = entry;
                            that.setLookupTable(table);
                        } else {
                            var entry = table[script.id];
                            if (entry.name != script.name) {
                                entry.key = that.strToKey(script.name);
                                that.setLookupTable(table);
                            }
                        }

                        var sscript = that.getScript(script.id, entry.key);
                        // script is inside the local storage
                        if (sscript) {
                            that.log(entry.key + ' loaded from local storage');
                            that.injectScript(sscript, script.id, entry.key)
                        } else {
                            $.ajax({
                                url: encodeURI(that.root + 'api/script/' + script.id),
                                dataType: 'jsonp'
                            }).done(function (e) {
                                that.log(entry.key + ' saved to local storage');
                                that.setScript(script.id, entry.key, e.data.script);
                                that.injectScript(e.data.script, script.id, entry.key);
                            }).fail(function (e, status) {
                                that.log(status);
                            })
                        }
                    }
                } else {
                    that.setMessage(e.message);
                    that.showForm();
                }
            }).fail(function (e, status) {
                that.log(status);
            });
        },

        logout: function () {
            that.delAuthKey();
            location.reload();
        },

        setSettings: function (settings) {
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');
            $.ajax({
                type: 'get',
                url: encodeURI(that.root + 'api/settings/' + id),
                data: {
                    settings: JSON.stringify(settings),
                    authKey: that.getAuthKey()
                },
                dataType: 'jsonp'
            }).done(function (e) {
                if (e.success) {
                    // localStorage.removeItem('settings_' + id); // force-delete the old whole-script
                    localStorage.setItem('settings_' + id, JSON.stringify(settings));
                    that.log('[' + key + ']Successfully saved settings to Database');
                } else {
                    that.log('[' + key + '][Error] =>' + e.message);
                }
            }).fail(function (e, status) {
                that.log(status);
            });

            return true;
        },

        // Load on every start for every script
        loadSettings: function (settings) {
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');
            if (localStorage.getItem('settings_' + id)) {
                // if in localStorage
                settings = JSON.parse(localStorage.getItem('settings_' + id));
                return settings;
            } else {
                // if not in localStorage check Database first
                $.ajax({
                    type: "GET",
                    url: encodeURI(that.root + 'api/database/getsettings/' + id),
                    data: {
                        authKey: that.getAuthKey()
                    },
                    dataType: 'jsonp'
                }).done(function (e) {
                    if (e.success) {
                        localStorage.setItem('settings_' + id, JSON.stringify(e.data.userSettings));
                        that.log('[' + key + ']Successfully loaded settings from Database');
                        return JSON.parse(e.data.userSettings);
                    } else {
                        that.log('[' + key + ']Successfully loaded settings from default');
                        localStorage.setItem('settings_' + id, JSON.stringify(settings));
                        return settings; // returning default settings
                    }
                }).fail(function (e, status) {
                    that.log('[' + key + '][Error] =>' + status);
                });
            }
        },


    });

    var that = elite_cloud;
    elite_cloud.init();

})(jQuery);
