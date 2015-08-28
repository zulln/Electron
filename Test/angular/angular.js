var angularApp = angular.module('angularApp', []);

angularApp.controller('angularAppCtrl', function($scope){
	$scope.count = 900;

	$scope.go = function() { alert("Alert!"); }
});

<!-- NodeJS -->
