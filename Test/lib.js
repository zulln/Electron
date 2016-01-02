var angularApp = angular.module('angularApp', []);
var ipc = require("ipc");

angularApp.controller('angularAppCtrl', function($scope, $window){

	var nodeAddon = $window.require("./node.js");
	var remote = $window.require("remote");
	var dialog = remote.require("dialog");
	//var addon = $window.require('./node_modules/hello-mac/build/Release/nodeAddon');
	//var addon = $window.require('./node_modules/hello-mac/build/Release/dxlockdown');

	$scope.count = 900;
	$scope.isKiosk = false;
	$scope.usbDetected = false;

	//var objArray = addon();			//Should return array with all objects that we want to run objectName.run();

	$scope.go = function() {
		console.log("Current window");
		var currentWindow = remote.getCurrentWindow();
		dialog.showOpenDialog(currentWindow);
		/*var objArray = new addon.MyObject(10);
		console.log(objArray.plusOne());
		console.log(objArray.plusOne());*/
		//$window.alert(addon.onLockdown());
	};

	$scope.go2 = function() {
		//console.log("Not implemented yet");

	};

	$scope.usbDetect = function() {
		ipc.send("saveToUSB");
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
