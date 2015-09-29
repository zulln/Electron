var angularApp = angular.module('angularApp', []);
var ipc = require("ipc");

angularApp.controller('angularAppCtrl', function($scope, $window){
	$scope.count = 900;
	$scope.isKiosk = false;

	$scope.go = function() {
		console.log(addon.hello());
	};

	$scope.go2 = function() {
		console.log(nodeAddon.nodeTest());
		console.log(nodeAddon.nodeHello());
	};

	$scope.close = function() {
		$window.close();
	};

	$scope.toggleKiosk = function() {
		ipc.send("toggleKiosk", !$scope.isKiosk);
		$scope.isKiosk = !($scope.isKiosk);
	};
});

<!-- NodeJS -->

var nodeAddon = require("./node.js");
//var nodeTest = console.log(addon.hello());

<!-- jQuery -->