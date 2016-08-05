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