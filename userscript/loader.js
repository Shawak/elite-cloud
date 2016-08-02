(function ($) {
    var elite_cloud = {}

    elite_cloud.init = function () {
        $('#userbaritems').append('<a href="#"><li>elite-cloud</li></a>');

        console.log('elite-cloud: loading..');
        var elem = $('form[action="profile.php?do=updateoptions"]');
        if (!elem.length) {
            console.log('elite-cloud: could not find settings page.');
            return;
        }
        console.log('elite-cloud: detected settings page.');

        console.log('elite-cloud: injecting script..');
        $.ajax({
            url: "http://localhost/elite-cloud/api/plugin",
            dataType: 'jsonp',
        }).done(function (e) {
            console.log('elite-cloud: success');
            elem.parent().prepend(e.data.script);
        }).fail(function (e, status, err) {
            console.log('elite-cloud: error, ' . status);
        });
    };

    elite_cloud.init();
})(jQuery);