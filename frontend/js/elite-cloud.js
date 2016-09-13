var app = angular.module('elite-cloud', []);

function notify(data) {
    $.notify(data.message, {
        className: data.success ? 'success' : 'error',
        autoHideDelay: 2 * 1000
    });
}

// Config
app.config(['$interpolateProvider', function ($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
}]);

app.controller('LoginController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.form = {
        username: '',
        password: '',
        remember: false
    };

    $scope.login = function () {
        var response = $http.post('api/login', {
            username: $scope.form.username,
            password: $scope.form.password,
            remember: $scope.form.remember
        });
        response.success(function (data, status, headers, config) {
            notify(data);
            if (data.success) {
                setTimeout(function () {
                    window.location.href = 'userscripts';
                }, 500);
            }
            else {
                $scope.form.password = '';
            }
        });
    };
}]);

app.controller('RegisterController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.form = {
        username: '',
        password: '',
        password2: '',
        email: '',
        email2: ''
    };

    $scope.register = function () {
        var response = $http.post('api/user/register', {
            username: $scope.form.username,
            password: $scope.form.password,
            email: $scope.form.email,
            captcha: grecaptcha.getResponse()
        });
        response.success(function (data, status, headers, config) {
            notify(data);
            if (data.success) {
                setTimeout(function () {
                    window.location.href = '.';
                }, 500);
            }
            else {
                grecaptcha.reset();
                $scope.form.password = '';
                $scope.form.password2 = '';
            }
        });
    };
}]);

app.controller('LogoutController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.logout = function () {
        var response = $http.post('api/logout');
        response.success(function (data, status, headers, config) {
            notify(data);
            if (data.success) {
                setTimeout(function () {
                    window.location.href = '.';
                }, 500);
            }
        });
    };
}]);

app.controller('UserscriptsController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.userscripts = [];

    $scope.init = function () {
        var response = $http.get('api/userscript/list');
        response.success(function (e, status, headers, config) {
            $scope.userscripts = e.data;
        });
    };

    $scope.click = function (userscript) {
        window.location.href = 'userscript/' + userscript.id;
    };

    $scope.add = function (userscript) {
        var response = $http.get('api/user/addscript/' + userscript.id);
        response.success(function (data, status, headers, config) {
            notify(data);
            if (data.success) {
                userscript.selected = true;
            }
        });
    };

    $scope.remove = function (userscript) {
        var response = $http.get('api/user/removescript/' + userscript.id);
        response.success(function (data, status, headers, config) {
            notify(data);
            if (data.success) {
                userscript.selected = false;
            }
        });
    };

    $scope.toggle = function ($event, userscript) {
        $event.stopPropagation();
        if ($event.target.tagName !== 'INPUT') {
            return;
        }
        if (userscript.selected) {
            userscript.users--;
            this.remove(userscript);
        } else {
            userscript.users++;
            this.add(userscript);
        }
    };

    $scope.init();
}]);