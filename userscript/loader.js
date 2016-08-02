(function ($) {
    var elite_cloud = {}

    elite_cloud.init = function () {
        $('#userbaritems').append('<a href="#"><li>elite-cloud</li></a>');

        var elem = $('#profileform');
        if (!elem.length) {
            return;
        }

        elem.parent().prepend('Test');
    };

    elite_cloud.init();
})(jQuery);