// ==UserScript==
// @name         e*pvp elite-cloud DEV (Fast "loading"?!)
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

        log('Loader init()');
        var injected = inject();
        update(root + '/api/loader', function () {
            log('Loader updated!');
            if (!injected) {
                inject();
            }
        });
    }

    function inject() {
        var code = localStorage.getItem(key);
        if (code == null) {
            return false;
        }

        var script = document.createElement('script');
        script.setAttribute('type', 'text/javascript');
        script.setAttribute('root', root);
        script.innerHTML = code;
        document.head.appendChild(script);
        return true;
    }

    function update(url, callback) {
        var callbackName = 'jsonp_callback_' + Math.round(100000 * Math.random());
        var script = document.createElement('script');
        script.innerHTML = 'function ' + callbackName + '(result) { localStorage.setItem(\'' + key + '\', result.data.loader); }';
        document.body.appendChild(script);
        script = document.createElement('script');
        script.onload = callback;
        script.src = encodeURI(url + (url.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callbackName);
        document.body.appendChild(script);
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