// ==UserScript==
// @name         e*pvp elite-cloud loader DEV (Fast "loading"?!)
// @namespace    http://elitepvpers.com/
// @version      1.0
// @description  Used to load userscripts from elite-cloud
// @author       elite-cloud
// @match        http://www.elitepvpers.com/*
// @grant        none
// ==/UserScript==

(function () {

    main();

    function main() {
        console.log(new Date().getTime());
        if (!checkForIFrame()) {
            var script = document.createElement('script');
            script.setAttribute('id', 'elite-cloud');
            script.setAttribute('type', 'text/javascript');
            script.setAttribute('root', 'http://localhost/elite-cloud');
            script.innerHTML = localStorage.getItem('test');
            document.head.appendChild(script);
            jsonp('http://localhost/elite-cloud/api/include', function (data) {
                localStorage.setItem('test', data);
            });
        }
    }

    function jsonp(url, callback) {
        var callbackName = 'jsonp_callback_' + Math.round(100000 * Math.random());
        window[callbackName] = function (data) {
            delete window[callbackName];
            document.body.removeChild(script);
            callback(data);
        };
        var script = document.createElement('script');
        script.src = url + (url.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callbackName;
        document.body.appendChild(script);
    }

    function checkForIFrame() {
        try {
            return window.self !== window.top;
        } catch (e) {
            return true;
        }
    }

})();