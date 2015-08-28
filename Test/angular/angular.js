var angularApp = angular.module('angularApp', []);

angularApp.controller('angularAppCtrl', function($scope){
	$scope.count = 900;

	$scope.go = function() { alert("Alert!"); }
//	$scope.go = nodeTest;
});

<!-- NodeJS -->

var addon = require('./Node/build/Release/addonMac');

var nodeTest = console.log(addon.hello());
