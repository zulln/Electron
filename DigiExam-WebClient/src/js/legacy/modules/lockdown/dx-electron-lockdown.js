angular.module("digiexamclient.lockdown", [])
.factory("ElectronLockdown", function($q, $window){
	"use strict";

	var fs = require("fs");
	var dir = __dirname;
	//var fs = $window.require("../../platforms/electron/node/build/Release/dxlockdown");

	console.log("Imported DX Lockdowdn");

	var executeLockdown = function() {
		$window.console.log(dir);
		$window.console.log("Mac Init Lockdown");
	};

	var setKiosk = function () {
		//TO DO
	};

	var tearDown = function() {
		//TO DO
	};

	return {
		executeLockdown: executeLockdown
	};
});
