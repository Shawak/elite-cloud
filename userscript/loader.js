(function ($) {

    var elite_cloud = window.elite_cloud || {};

    elite_cloud.extend({

        keyAuthKey: 'elite-cloud_authKey',

        hideForm: function () {
            $('#ec_form').hide();
        },

        showForm: function () {
            $('#ec_form').show();
        },

        getAuthKey: function () {
            return localStorage.getItem(that.keyAuthKey);
        },

        setAuthKey: function (authKey) {
            localStorage.setItem(that.keyAuthKey, authKey);
        },

        delAuthKey: function () {
            localStorage.removeItem(that.keyAuthKey);
        },

        init: function () {
            that.log('Loader init()');
            that.injectPlugin(function () {
                that.login();
            });
        },

        setMessage: function (str) {
            var elem = $('#ec_message');
            if (elem.length) {
                $('#ec_message').html(str);
            }
        },

        injectPlugin: function (after) {
            $('#userbaritems').append('' +
                '<style>#ec_menuitem:hover img {opacity: 1 !important}</style>' +
                '<a href="/forum/profile.php?do=editoptions">' +
                '<li>' +
                '<div id="ec_menuitem" style="display: inline-block">' +
                '<img style="opacity: 0.8; float: left; width: 13px; height: 13px; margin-right: 5px;" src="' + (that.root + "/frontend/img/favicon.png") + '">' +
                'elite-cloud' +
                '</div>' +
                '</li>' +
                '</a>');

            var elem = $('form[action="profile.php?do=updateoptions"]');
            if (!elem.length) {
                after();
                return;
            }

            $(document).on('click', '#ec_logout', function () {
                that.logout();
            });

            $.ajax({
                url: encodeURI(that.root + '/api/plugin'),
                dataType: 'jsonp',
            }).done(function (e) {
                elem.parent().prepend(e.data.plugin).append(function () {
                    $("#ec_form").submit(function (event) {
                        event.preventDefault();
                        that.hideForm();
                        var authKey = $('#ec_authKey').val();
                        $('#ec_authKey').val('');
                        that.setAuthKey(authKey);
                        that.login();
                    });
                    after();
                });
            }).fail(function (e, status, err) {
                that.log(status);
            });
        },

        login: function () {
            var authKey = that.getAuthKey();
            if (authKey == null || authKey == '') {
                that.setMessage('No authentication key found.');
                that.showForm();
                return;
            }

            $.ajax({
                url: encodeURI(that.root + '/api/authenticate/' + authKey),
                dataType: 'jsonp',
            }).done(function (e) {
                if (e.success) {
                    that.setMessage('Authenticated as ' + e.data.user.name + ', <span id="ec_logout">logout</span>.');
                    that.log('Loading userscripts..');
                    for (var i = 0; i < e.data.userscripts.length; i++) {
                        that.log('> ' + e.data.userscripts[i].name);
                        $.ajax({
                            url: encodeURI(that.root + '/api/script/' + e.data.userscripts[i].id),
                            dataType: 'jsonp'
                        }).done(function (e) {
                            that.injectScript(e.data.script);
                        }).fail(function (e, status) {
                            that.log('error,:' + status);
                        });
                    }
                } else {
                    that.setMessage(e.message);
                    that.showForm();
                }
            }).fail(function (e, status, err) {
                that.log('error: ' + status);
            });
        },

        logout: function () {
            that.delAuthKey();
            location.reload();
        },
    });

    var that = elite_cloud;
    elite_cloud.init();

})(jQuery);