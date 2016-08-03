(function ($) {

    var elite_cloud = {
        loggedIn: false,
        user: null,
        userscripts: null,

        getAuthKey: function () {
            return localStorage.getItem('elite-cloud_authKey');
        },

        setAuthKey: function (authKey) {
            localStorage.setItem('elite-cloud_authKey', authKey);
        },

        init: function () {
            $('#userbaritems').append('<a href="/forum/profile.php?do=editoptions"><li>elite-cloud</li></a>');

            var that = this;
            var elem = $('form[action="profile.php?do=updateoptions"]');
            if (!elem.length) {
                return;
            }

            $.ajax({
                url: 'http://localhost/elite-cloud/api/plugin',
                dataType: 'jsonp',
            }).done(function (e) {
                elem.parent().prepend(e.data.script);
            }).fail(function (e, status, err) {
                console.log(status);
            });

            var authKey = this.getAuthKey();
            this.login(authKey);
        },

        setMessage: function (str) {
            $('#ec_message').text(str);
        },

        login: function (authKey) {
            var that = this;
            $.ajax({
                url: 'http://localhost/elite-cloud/api/authenticate/' + authKey,
                dataType: 'jsonp',
            }).done(function (e) {
                that.loggedIn = e.success;
                if (that.loggedIn) {
                    that.user = e.data.user;
                    that.userscripts = e.data.userscripts;
                    that.setMessage('Logged in as ' + that.user.name);
                } else {
                    that.setMessage(e.message);
                }
                // TODO: Load Userscripts
            }).fail(function (e, status, err) {
                console.log('error, '.status);
            });
        }

    }

    elite_cloud.init();
    // elite_cloud.setAuthKey('a0deb698e6e3827938b45a5159bd04d238d39d10c7e77c1844ead82274bddb89');
    // elite_cloud.setAuthKey(null);

})(jQuery);