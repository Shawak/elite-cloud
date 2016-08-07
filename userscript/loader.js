(function ($) {

    var elite_cloud = {
        keyName: 'elite-cloud_authKey',
        root: $(document.currentScript).attr('root'),

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
            this.log('Loader init()');
            var that = this;
            this.injectPlugin(function () {
                that.login();
            });
        },

        log: function (msg) {
            var date = new Date();
            console.log('[elite-cloud ' + date.toLocaleTimeString() + '.' + date.getMilliseconds() + '] %s', msg);
        },

        insertScript: function (script) {
            var elem = document.createElement('script');
            elem.setAttribute('type', 'text/javascript');
            elem.setAttribute('root', this.root);
            elem.innerHTML = script;
            document.head.appendChild(elem);
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
                '<img style="opacity: 0.8; float: left; width: 13px; height: 13px; margin-right: 5px;" src="' + (this.root + "/frontend/images/favicon.png") + '">' +
                'elite-cloud' +
                '</div>' +
                '</li>' +
                '</a>');

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
                url: encodeURI(this.root + '/api/plugin'),
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
            var authKey = this.getAuthKey();
            if (authKey == null || authKey == '') {
                this.setMessage('No authentication key found.');
                this.showForm();
                return;
            }

            var that = this;
            $.ajax({
                url: encodeURI(this.root + '/api/authenticate/' + authKey),
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
                            that.insertScript(e.data.script);
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
            this.delAuthKey();
            location.reload();
        },
    }

    elite_cloud.init();

})(jQuery);