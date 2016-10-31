var app = angular.module('elite-cloud', []);

function notify(result) {
    $.notify(result.message, {
        className: result.success ? 'success' : 'error',
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
        response.success(function (result, status, headers, config) {
            notify(result);
            if (result.success) {
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
        response.success(function (result, status, headers, config) {
            notify(result);
            if (result.success) {
                setTimeout(function () {
                    window.location.href = '.';
                }, 500);
            }
        });
    };
}]);

app.controller('UserscriptsController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.userscripts = [];
    $scope.search = '';

    $scope.lastUpdate = null;
    $scope.updating = false;
    $scope.event = null;
    $scope.timeout = 250; // ms

    $scope.order = 'asc';
    $scope.lastSort = null;

    $scope.update = function (sort) {
        if ($scope.updating || ($scope.lastUpdate != null && (Date.now() - $scope.lastUpdate <= $scope.timeout))) {
            if ($scope.event != null) {
                clearTimeout($scope.event);
            }
            $scope.event = setTimeout(function () {
                $scope.update(sort);
                $scope.event = null
            }, $scope.timeout);
            return;
        }

        sort = sort || ($scope.lastSort != null ? $scope.lastSort : 'selected');
        if ($scope.lastSort != null && $scope.lastSort == sort) {
            $scope.order = $scope.order == 'asc' ? 'desc' : 'asc';
        } else {
            $scope.order = (sort == 'selected' || sort == 'users') ? 'desc' : 'asc';
        }
        $scope.lastSort = sort;

        $scope.updating = true;
        var response = $http.get('api/userscript/list/' + sort + '/' + $scope.order + ($scope.search != '' ? '/' + btoa($scope.search) : ''));
        response.success(function (result, status, headers, config) {
            $scope.userscripts = result.data;
            $scope.lastUpdate = Date.now();
            $scope.updating = false;
        });
    };

    $scope.click = function (userscript) {
        window.location.href = 'userscript/' + userscript.id;
    };

    $scope.add = function (userscript) {
        var response = $http.get('api/user/addscript/' + userscript.id);
        response.success(function (result, status, headers, config) {
            notify(result);
            if (result.success) {
                userscript.users++;
                userscript.selected = true;
            }
        });
    };

    $scope.remove = function (userscript) {
        var response = $http.get('api/user/removescript/' + userscript.id);
        response.success(function (result, status, headers, config) {
            notify(result);
            if (result.success) {
                userscript.users--;
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
            this.remove(userscript);
        } else {
            this.add(userscript);
        }
    };

    $scope.update();
}]);

app.controller('UserscriptController', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    $scope.userscript = null;

    $scope.id = -1;

    $scope.elements = {
        'button': null,
        'name': $('.info .name input'),
        'descrption': $('.box .description'),
        'simplemde': null,
        'descriptionTextarea': null,
        'scriptTextarea' : $('#textarea_script')
    };

    $scope.init = function (id) {
        $scope.id = id
        if($scope.id == -1) {
            return;
        }

        var response = $http.get('api/userscript/' +  $scope.id);
        response.success(function (result, status, headers, config) {
            $scope.userscript = result.data;
        });
    };

    $scope.edit = function ($event) {
        if ($scope.elements.button != null) {
            $scope.save($scope.id);
            return;
        }

        $scope.elements.name.removeAttr('readonly');
        $scope.elements.scriptTextarea.removeAttr('readonly');
        $scope.elements.button = $($event.currentTarget);
        $scope.elements.button.removeClass('btn-success');
        $scope.elements.button.addClass('btn-primary');
        $scope.elements.button.text('Save Changes');

        var response = $http.get('api/userscript/' + $scope.id);
        response.success(function (result) {
            if (result.success || $scope.id == -1) {
                $scope.userscript = result.data;
                $scope.elements.descrption.html('');
                $scope.elements.descriptionTextarea = $('<textarea></textarea>').appendTo($scope.elements.descrption);
                $scope.elements.descriptionTextarea.text($scope.userscript.description);
                $scope.elements.simplemde = new SimpleMDE({
                    element: $($scope.elements.descriptionTextarea)[0],
                    previewRender: function (plainText, preview) {
                        var response = $http.post('api/markdown', {
                            text: plainText
                        });
                        response.success(function (result, status, headers, config) {
                            if (result.success) {
                                preview.innerHTML = result.data.html;
                            }
                        });
                        return "Loading...";
                    }
                });
            } else {
                notify(result);
            }
        });
    };

    $scope.saving = false;
    $scope.save = function () {
        $scope.saving = true;
        var response = $http.post($scope.id == -1 ? 'api/userscript/create' : 'api/userscript/' + $scope.id + '/edit', {
            name: $scope.elements.name.val(),
            description: btoa($scope.elements.simplemde.value()),
            script: btoa($scope.elements.scriptTextarea.val())
        });
        response.success(function (result) {
            notify(result);
            if($scope.id == -1 && result.success) {
                $scope.id = result.data.id;
            }
            $scope.saving = false;
        });
    };

    $scope.toggle = function ($event) {
        $event.stopPropagation();
        if ($event.target.tagName !== 'INPUT') {
            return;
        }
        var response = $http.get('api/user/' + ($scope.userscript.selected ? 'remove' : 'add') + 'script/' + $scope.userscript.id);
        response.success(function (result, status, headers, config) {
            notify(result);
            if (result.success) {
                $scope.userscript.selected = !$scope.userscript.selected;
            }
        });
    };

}]);