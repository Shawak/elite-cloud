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

    var key = 'elite-cloud_loader';
    var root = 'http://localhost/elite-cloud';

    init();

    function init() {
        if (checkForIFrame()) {
            return;
        }

        log('init()');
        var injected = inject();
        setTimeout(function () {
            update(root + '/api/loader', function () {
                log('Loader updated!');
                if (!injected) {
                    inject();
                }
            });
        }, 5000);
    }

    function inject() {
        var script = localStorage.getItem(key);
        if (script == null) {
            return false;
        }

        var elem = document.createElement('script');
        elem.setAttribute('type', 'text/javascript');
        elem.setAttribute('root', root);
        elem.innerHTML = script;
        document.head.appendChild(elem);
        return true;
    }

    function update(url, callback) {
        var callbackName = 'jsonp_callback_' + Math.round(100000 * Math.random());
        var elem = document.createElement('script');
        elem.innerHTML = 'function ' + callbackName + '(result) { localStorage.setItem(\'' + key + '\', result.data.loader); }';
        document.body.appendChild(elem);
        elem = document.createElement('script');
        elem.onload = callback;
        elem.src = encodeURI(url + (url.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callbackName);
        document.body.appendChild(elem);
    }

    function log(msg) {
        var date = new Date();
        console.log('[elite-cloud ' + date.toLocaleTimeString() + '.' + date.getMilliseconds() + '] %s', msg);
    }

    function checkForIFrame() {
        try {
            return window.self !== window.top;
        } catch (e) {
            return true;
        }
    }

})();