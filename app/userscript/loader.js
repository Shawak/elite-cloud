(function ($) {

    var elite_cloud = window.elite_cloud || {};

    elite_cloud.extend({

        keyLookupTable: 'elite-cloud_lookup',
        keyScriptPrefix: 'elite-cloud_script',
        keySettingPrefix: 'elite-cloud_setting',
        keyLastUpdate: 'elite-cloud_lastUpdate',

        gui: {

            updateActiveCount: function() {
                var lookup = that.storage.getLookupTable();
                var count = 0;
                for(var id in lookup) {
                    if(lookup[id].enabled) {
                        count++;
                    }
                }
                $('#elite-cloud_menu .activeScripts').text(count);
            },

            injectHeader: function() {
                var plugin = atob('{PLUGIN}');
                plugin = plugin.replace(new RegExp('{URL_SITE}', 'g'), that.root);
                $('#userbaritems').append(plugin);
                that.gui.updateActiveCount();
            }

        },

        storage: {

            loadLocalScripts: function () {
                that.log('Loading scripts from LocalStorage');
                var lookup = that.storage.getLookupTable();
                for(var id in lookup) {
                    var entry = lookup[id];
                    if (entry.enabled) {
                        that.log('> ' + entry.key);
                        var script = that.storage.getScript(entry);
                        if(script) {
                            that.injectScript(script, entry.id, entry.key);
                        } else {
                            that.log('We found a script in LocalStorage Lookup but this is not stored');
                        }
                    }
                }
            },

            /* Lookup Table */
            getLookupTable: function () {
                var table = localStorage.getItem(that.keyLookupTable);
                return table !== null ? JSON.parse(table) : {};
            },

            setLookupTable: function (table) {
                localStorage.setItem(that.keyLookupTable, JSON.stringify(table));
            },

            /* Script */
            getScript: function (entry) {
                return localStorage.getItem(that.keyScriptPrefix + '_' + entry.id + '_' + entry.key);
            },

            setScript: function (entry, script) {
                localStorage.setItem(that.keyScriptPrefix + '_' + entry.id + '_' + entry.key, script);
            },

            delScript: function (entry) {
                localStorage.removeItem(that.keyScriptPrefix + '_' + entry.id + '_' + entry.key);
            },

            /* Settings */
            getSettings: function(entry) {
                var settings = localStorage.getItem(that.keySettingPrefix + '_' + entry.id + '_' + entry.key);
                return settings? JSON.parse(settings) : null;
            },

            setSettings: function(entry, settings) {
                localStorage.setItem(that.keySettingPrefix + '_' + entry.id + '_' + entry.key, JSON.stringify(settings));
            },

            delSettings: function(entry) {
                localStorage.removeItem(that.keySettingPrefix + '_' + entry.id + '_' + entry.key);
            },

            /* Last Update */
            getLastUpdate: function() {
                var value = localStorage.getItem(that.keyLastUpdate);
                return value ? value : 0;
            },

            setLastUpdate: function(time) {
                localStorage.setItem(that.keyLastUpdate, time);
            }

        },

        init: function () {
            that.storage.loadLocalScripts();
            that.gui.injectHeader();

            var now = Date.now();
            var diff = now - that.storage.getLastUpdate();
            if(diff <= 30 * 1000) {
                that.log('Next update in ' + diff / 1000 + ' seconds.');
                return;
            }
            that.storage.setLastUpdate(now);

            that.log('Loader init()');
            that.update();
        },

        reload: function() {
            var table = that.storage.getLookupTable();
            for(var id in table) {
                var entry = table[id];
                that.storage.delScript(entry);
                that.storage.delSettings(entry);
                delete table[id];
            }
            that.loader.delScript();
            that.storage.setLastUpdate(Date.now());
            that.storage.setLookupTable(table);
        },

        nameToKey: function (str) {
            return str.toLowerCase().replace(/ /g, '_').replace(/[^A-Za-z0-9_?!]/g, '').substr(0, 50);
        },

        update: function () {
            $.ajax({
                url: encodeURI(that.root + 'api/authenticate'),
                dataType: 'jsonp'
            }).done(function (e) {
                if (e.success) {
                    that.log('Updating userscripts (' + e.data.data.length +') ..');

                    var lookup = that.storage.getLookupTable();
                    for(var id in lookup) {
                        lookup[id].enabled = false;
                    }

                    for (var i = 0; i < e.data.data.length; i++) {
                        var info = e.data.data[i];
                        that.log('> ' + info.name);

                        var isNew = false;
                        // add the script to the lookup table
                        if (!lookup.hasOwnProperty(info.id)) {
                            lookup[info.id] = {
                                id: info.id,
                                name: info.name,
                                key: that.nameToKey(info.name),
                                enabled: false
                            };
                            isNew = true;
                        }

                        var entry = lookup[info.id];
                        entry.enabled = true;
                        entry.keep = true;

                        // update the key name if
                        // the script name has changed
                        if (entry.name != info.name) {
                            // move script
                            var tmp = that.storage.getScript(entry);
                            that.storage.delScript(entry);
                            entry.key = that.nameToKey(info.name);
                            that.storage.setScript(entry, tmp);
                            // move settings
                            var settings = that.storage.getSettings(entry);
                            if (settings) that.storage.setSettings(entry, settings);
                        }

                        // update script
                        var script = atob(info.script);
                        that.storage.setScript(entry, script);

                        // update settings
                        if(typeof info.settings === 'string') {
                            if(JSON.stringify(that.storage.getSettings(entry)) != info.settings) {
                                that.storage.setSettings(entry, JSON.parse(info.settings));
                                that.log('Settings from ' + entry.key + ' has been updated.');
                            }
                        }

                        // inject script if not loaded yet
                        if(isNew) {
                            that.injectScript(script, entry.id, entry.key);
                        }
                    }

                    // delete disabled scripts
                    for(var id in lookup) {
                        if(!lookup[id].keep) {
                            that.storage.delScript(lookup[id]);
                            that.storage.delSettings(lookup[id]);
                            delete lookup[id];
                        } else {
                            delete lookup[id].keep;
                        }
                    }

                    that.storage.setLookupTable(lookup);
                    that.gui.updateActiveCount();
                }
            }).fail(function (e, status) {
                that.log(status);
            });
        },

        // Load on every start for every script
        // called by any user script
        getSettings: function (defaultSettings) {
            var id = document.currentScript.getAttribute('userscript_id');
            var key = document.currentScript.getAttribute('userscript_key');
            var settings = that.storage.getSettings({id: id, key: key});
            if(!settings) {
                that.log('Settings not found for userscript ' + key + ', using defaultSettings.');
                settings = defaultSettings;
            }
            settings.__id = id;
            return settings;
        },

        // Save settings to the cloud
        // called by any user script
        setSettings: function (settings) {
            var lookup = that.storage.getLookupTable();
            var entry = lookup[settings.__id];

            // doing a shallow copy here to remove the __id
            // without preventing further function calls
            // where the __id would be gone because of delete
            // tl;dr: do not remove
            var data = $.extend({}, settings);
            delete data.__id;

            that.storage.setSettings(entry, data);
            $.ajax({
                url: encodeURI(that.root + 'api/settings/set/' + entry.id),
                data: { settings: btoa(JSON.stringify(data)) },
                dataType: 'jsonp'
            }).done(function (e) {
                if (e.success) {
                    that.log(entry.key + ' saved settings to the database.');
                } else {
                    that.log(e.message);
                }
            }).fail(function (e, status) {
                that.log(status);
            });
        }
    });

    var that = elite_cloud;
    elite_cloud.init();

})(jQuery);
