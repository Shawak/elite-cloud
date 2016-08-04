// ==UserScript==
// @name         e*pvp elite-cloud loader DEV
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
            includeScript('http://localhost/elite-cloud', '/api/include');
        }
    }

    function checkForIFrame() {
        try {
            return window.self !== window.top;
        } catch (e) {
            return true;
        }
    }

    function includeScript(root, route) {
        var script = document.createElement('script');
        script.setAttribute('id', 'elite-cloud');
        script.setAttribute('type', 'text/javascript');
        script.setAttribute('root', root);
        script.setAttribute('src', encodeURI(root + route));
        document.getElementsByTagName('head')[0].appendChild(script);
    }

})();