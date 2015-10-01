var angularApp = angular.module('angularApp', []);
var ipc = require("ipc");

angularApp.controller('angularAppCtrl', function($scope, $window){

	var nodeAddon = $window.require("./node.js");
	var addon = $window.require('./node_modules/hello-mac/build/Release/nodeAddon');

	$scope.count = 900;
	$scope.isKiosk = false;

	$scope.go = function() {
		//console.log(nodeAddon.nodeHello());
		console.log("Native call " + addon.hello());
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

//var nodeTest = console.log(addon.hello());

<!-- jQuery -->
