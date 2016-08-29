var app = angular.module('elite-cloud', []);

// Config
app.config(['$interpolateProvider', function ($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
}]);

// UserController (Example for now)
app.controller('Controller', ['$scope', '$http', function ($scope, $http) {
    $scope.user = {};

    $scope.ban = function () {
        $http.get('api/user/' + id)
            .success(function (data, status, headers, config) {
                $scope.user = data.user;
            });
    };
}])

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
            if (data.success) {
                $.notify(data.message, 'success');
                setTimeout(function () {
                    window.location.href = 'userscripts';
                }, 500);
            }
            else {
                $.notify(data.message, 'error');
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
            console.log(data);
            if (data.success) {
                $.notify(data.message, 'success');
                setTimeout(function () {
                    window.location.href = '.';
                }, 500);
            }
            else {
                $.notify(data.message, 'error');
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
            if (data.success) {
                $.notify(data.message, 'success');
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
            //self.userscripts = e.data;
            dump(e);
        });
        self.userscripts = [
            {name: "test", author: 1},
            {name: "test", author: 1},
        ];
    };

    $scope.click = function (userscript) {
        window.location.href = 'userscript/' + userscript.id;
    };

    $scope.init();
}]);