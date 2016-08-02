// ==UserScript==
// @name         e*pvp elite-cloud loader
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
        if (!checkForIFrame()) {
            includeScript('https://userscripts.elitepvpers.de/api/include');
            includeScript('http://localhost/elite-cloud/api/include');
        }
    }

    function checkForIFrame() {
        try {
            return window.self !== window.top;
        } catch (e) {
            return true;
        }
    }

    function includeScript(src) {
        var script = document.createElement('script');
        script.setAttribute('type', 'text/javascript');
        script.setAttribute('src', encodeURI(src));
        document.getElementsByTagName('head')[0].appendChild(script);
    }

})();