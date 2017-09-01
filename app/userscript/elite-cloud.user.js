// ==UserScript==
// @name        e*pvp elite-cloud
// @namespace   Elitepvpers
// @description Used to load userscripts from elite-cloud
// @match       *//www.elitepvpers.com/*
// @author      elite-cloud
// @version     1.0.0
// @downloadURL {URL_SITE}/userscript/elite-cloud.user.js
// @updateURL   {URL_SITE}/userscript/elite-cloud.user.js
// @grant       none
// ==/UserScript==
(function () {

    var main = function () {

        var elite_cloud = {
            root: '{URL_SITE}',
            keyLoader: 'elite-cloud_loader',
            keyLoaderLastUpdate: 'elite-cloud_loader_lastUpdate'
        };

        window.elite_cloud = elite_cloud;

        elite_cloud.extend = function (obj) {
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    this[key] = obj[key];
                }
            }
        };

        elite_cloud.extend({

            $jsonp: (function () {
                var that = {};

                that.get = function (src, options) {
                    var options = options || {},
                        callback_name = options.callbackName || 'jsonp_callback_' + Math.round(100000 * Math.random()),
                        on_success = options.onSuccess || function () {
                            },
                        on_timeout = options.onTimeout || function () {
                            },
                        timeout = options.timeout || 10;

                    var timeout_trigger = window.setTimeout(function () {
                        window[callback_name] = function () {
                        };
                        on_timeout();
                    }, timeout * 1000);

                    window[callback_name] = function (data) {
                        window.clearTimeout(timeout_trigger);
                        on_success(data);
                    };

                    var elem = document.createElement('script');
                    elem.type = 'text/javascript';
                    elem.src = encodeURI(src + (src.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callback_name);
                    document.head.appendChild(elem);
                };

                return that;
            })(),

            log: function (msg) {
                var date = new Date();
                console.log('[elite-cloud ' + date.toLocaleTimeString() + '.' + date.getMilliseconds() + '] %o', msg);
            },

            loader: {

                init: function () {
                    if (that.loader.checkForIFrame()) {
                        return;
                    }

                    that.log('init()');
                    var script = that.loader.getScript();
                    if (script) {
                        that.loader.injectScript(script);
                    }

                    var now = Date.now();
                    var diff = now - that.loader.getLastUpdate();
                    if(diff <= 60 * 1000) {
                        that.log('Next loader update in ' + diff / 1000 + ' seconds.');
                        return;
                    }
                    that.loader.setLastUpdate(now);

                    that.$jsonp.get(that.root + 'api/loader', {
                        onSuccess: function (result) {
                            that.loader.setScript(result.data.loader);
                            that.log('Loader updated!');
                            if (!script) {
                                that.loader.injectScript(that.loader.getScript());
                            }
                        }
                    });
                },

                injectScript: function (script) {
                    var elem = document.createElement('script');
                    elem.type = 'text/javascript';
                    elem.innerHTML = script;
                    document.head.appendChild(elem);
                },

                getLastUpdate: function() {
                  var time = localStorage.getItem(that.keyLoaderLastUpdate);
                    return time ? time : 0;
                },

                setLastUpdate: function(time) {
                    localStorage.setItem(that.keyLoaderLastUpdate, time);
                },

                getScript: function () {
                    return localStorage.getItem(that.keyLoader);
                },

                setScript: function (script) {
                    localStorage.setItem(that.keyLoader, script);
                },

                delScript: function() {
                    localStorage.removeItem(that.keyLoader);
                },

                checkForIFrame: function () {
                    try {
                        return window.self !== window.top;
                    } catch (e) {
                        return true;
                    }
                }
            }
        });

        var that = elite_cloud;
        elite_cloud.loader.init();
    };

    var elem = document.createElement('script');
    elem.type = 'text/javascript';
    elem.innerHTML = '(' + main + ')();';
    document.head.appendChild(elem);

})();
