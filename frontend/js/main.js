function dump(object) {
    console.log('dump: %o', object);
}

(function () {

    $('a[href=#login]').click(function () {
        setTimeout(function () {
            $('form[ng-controller="LoginController"] #username').focus();
        }, 500);
    });

    $('#header .logo a').click(function () {
        $(window).scrollTop(0);
    });

})();