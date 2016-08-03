(function ($) {

    var elite_cloud = {
        keyName: 'elite-cloud_authKey',
        /*loggedIn: false,
        user: null,
        userscripts: null,*/
        message: 'Loading..',

        getAuthKey: function () {
            return localStorage.getItem(this.keyName);
        },

        setAuthKey: function (authKey) {
            localStorage.setItem(this.keyName, authKey);
        },

        delAuthKey: function () {
            localStorage.removeItem(this.keyName);
        },

        init: function () {
            $('#userbaritems').append('<a href="/forum/profile.php?do=editoptions"><li>elite-cloud</li></a>');

            var that = this;
            var elem = $('form[action="profile.php?do=updateoptions"]');
            if (elem.length) {
                $.ajax({
                    url: 'http://localhost/elite-cloud/api/plugin',
                    dataType: 'jsonp',
                }).done(function (e) {
                    elem.parent().prepend(e.data.script).append(function () {
                        that.setMessage(that.message)
                    });
                }).fail(function (e, status, err) {
                    console.log(status);
                });
            }

            var authKey = this.getAuthKey();
            if (authKey != null) {
                this.login(authKey);
            } else {
                that.setMessage('No authKey found.');
            }
        },

        includeScript: function (src) {
            var script = document.createElement('script');
            script.setAttribute('type', 'text/javascript');
            script.setAttribute('src', encodeURI(src));
            document.getElementsByTagName('head')[0].appendChild(script);
        },

        setMessage: function (str) {
            this.message = str;
            var elem = $('#ec_message');
            if (elem.length) {
                $('#ec_message').text(str);
            }
        },

        login: function (authKey) {
            var that = this;
            $.ajax({
                url: 'http://localhost/elite-cloud/api/authenticate/' + authKey,
                dataType: 'jsonp',
            }).done(function (e) {
                //that.loggedIn = e.success;
                if (that.loggedIn) {
                    /*that.user = e.data.user;
                    that.userscripts = e.data.userscripts;*/
                    that.setMessage('Logged in as ' + e.data.user.name);
                    for (var i = 0; i < e.data.userscripts.length; i++) {
                        that.includeScript(e.data.userscripts[i].file)
                    }
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
    elite_cloud.delAuthKey();

})(jQuery);