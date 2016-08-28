// ==UserScript==
// @name         e*pvp elite-cloud DEV
// @namespace    http://elitepvpers.com/
// @version      1.0
// @description  Used to load userscripts from elite-cloud
// @author       elite-cloud
// @match        http://www.elitepvpers.com/*
// @grant        none
// ==/UserScript==

(function () {

    var main = function () {
        var elite_cloud = {};
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
                    elem.async = true;
                    elem.src = encodeURI(src + (src.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callback_name);

                    document.head.appendChild(elem);
                };

                return that;
            })(),

            log: function (msg) {
                var date = new Date();
                console.log('[elite-cloud ' + date.toLocaleTimeString() + '.' + date.getMilliseconds() + '] %o', msg);
            },

            injectScript: function (script) {
                var elem = document.createElement('script');
                elem.setAttribute('type', 'text/javascript');
                elem.innerHTML = script;
                document.head.appendChild(elem);
            },

            loader: {
                key: 'elite-cloud_loader',
                root: 'http://localhost/elite-cloud',

                init: function () {
                    if (that.loader.checkForIFrame()) {
                        return;
                    }

                    that.log('init()');
                    var script = that.loader.getScript();
                    var injected = false;

                    if (script) {
                        that.injectScript(script);
                        injected = true;
                    }

                    setTimeout(function () {
                        that.$jsonp.get(that.loader.root + '/api/loader', {
                            onSuccess: function (result) {
                                that.loader.setScript(result.data.loader);
                                that.log('Loader updated!');
                                if (!injected) {
                                    that.injectScript(that.loader.getScript());
                                }
                            }
                        });
                    }, 2.5 * 1000);
                },

                getScript: function () {
                    return localStorage.getItem(that.loader.key);
                },

                setScript: function (script) {
                    localStorage.setItem(that.loader.key, script);
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
    elem.appendChild(document.createTextNode('(' + main + ')();'));
    (document.head || document.body || document.documentElement).appendChild(elem);

})();