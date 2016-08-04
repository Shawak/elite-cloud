(function ($) {

    var elite_cloud = {
        keyName: 'elite-cloud_authKey',

        hideForm: function () {
            $('#ec_form').hide();
        },

        showForm: function () {
            $('#ec_form').show();
        },

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
            var that = this;
            this.injectPlugin(function () {
                that.login();
            });
        },

        includeScript: function (src) {
            var script = document.createElement('script');
            script.setAttribute('type', 'text/javascript');
            script.setAttribute('src', encodeURI(src));
            document.getElementsByTagName('head')[0].appendChild(script);
        },

        setMessage: function (str) {
            var elem = $('#ec_message');
            if (elem.length) {
                $('#ec_message').html(str);
            }
        },

        injectPlugin: function (after) {
            $('#userbaritems').append('<a href="/forum/profile.php?do=editoptions"><li>elite-cloud</li></a>');

            var elem = $('form[action="profile.php?do=updateoptions"]');
            if (!elem.length) {
                after();
                return;
            }

            var that = this;
            $(document).on('click', '#ec_logout', function () {
                that.logout();
            });

            $.ajax({
                url: 'http://localhost/elite-cloud/api/plugin',
                dataType: 'jsonp',
            }).done(function (e) {
                elem.parent().prepend(e.data.script).append(function () {
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
                console.log(status);
            });
        },

        login: function () {
            var authKey = this.getAuthKey();
            if (authKey == null || authKey == '') {
                this.setMessage('No authentication key found.');
                this.showForm();
                return;
            }

            var that = this;
            $.ajax({
                url: 'http://localhost/elite-cloud/api/authenticate/' + authKey,
                dataType: 'jsonp',
            }).done(function (e) {
                if (e.success) {
                    that.setMessage('Logged in as ' + e.data.user.name + ', <span id="ec_logout">logout</span>.');
                    for (var i = 0; i < e.data.userscripts.length; i++) {
                        that.includeScript(e.data.userscripts[i].file)
                    }
                } else {
                    that.setMessage(e.message);
                    that.showForm();
                }
            }).fail(function (e, status, err) {
                console.log('error, ' + status);
            });
        },

        logout: function () {
            this.delAuthKey();
            location.reload();
        },
    }

    elite_cloud.init();

})(jQuery);