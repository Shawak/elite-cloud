var app = angular.module('elite-cloud', []);

// Config
app.config(['$interpolateProvider', function ($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
}]);

app.config(['$locationProvider', function ($locationProvider) {
    $locationProvider.html5Mode(true);
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
                    index($location);
                }, 500);
            }
            else {
                $.notify(data.message, 'error');
                $scope.form.password = '';
                $('[placeholder="Password"]').focus();
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
                    index($location);
                }, 500);
            }
        });
    };
}]);