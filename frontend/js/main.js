function dump(object) {
    console.log('dump: %o', object);
}

(function () {

    $('a[href=#login]').click(function () {
        setTimeout(function () {
            $('form[ng-controller="LoginController"] #benutzername').focus();
        }, 500);
    });

})();