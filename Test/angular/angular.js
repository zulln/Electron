var angularApp = angular.module('angularApp', []);

angularApp.controller('angularAppCtrl', function($scope){
	$scope.count = 900;

	$scope.go = function() {
		console.log(addon.hello());
	}

});

<!-- NodeJS -->

var addon = require('./angular/Node/build/Release/addonMac');

//var nodeTest = console.log(addon.hello());
