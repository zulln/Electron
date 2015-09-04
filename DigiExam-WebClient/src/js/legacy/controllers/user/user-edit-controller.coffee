angular.module("digiexamclient").controller "UserEditController", ($scope, $location, Urls, SessionService, User)->
	$scope.user = angular.copy SessionService.user
