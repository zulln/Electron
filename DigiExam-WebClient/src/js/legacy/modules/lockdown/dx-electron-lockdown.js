angular.module("digiexamclient.lockdown", [])
.factory("ElectronLockdown", function($q, $window){
	"use strict";

	//var path = $window.require("path");
	var modulePath = "./platforms/electron/node/build/Release/dxlockdown";

	if($window.navigator.platform === "Win32") {
		modulePath = modulePath.replace("/", "\\");
	}

	var nativeModules = $window.require(modulePath);

	$window.console.log("Imported DX Lockdowdn");

	var prepareLockdown = function() {
		$window.console.log("prepareLockdown");
	};

	var executeLockdown = function() {
		$window.console.log("Lockdown message: " + nativeModules.getName());
		nativeModules.executeLockdown();
	};

	var onLockdown = function () {
		$window.console.log("Lockdown onLockdown");
		nativeModules.onLockdown();
	};

	var tearDown = function() {
		//TO DO
		$window.console.log("Lockdown teardown");
		nativeModules.teardownLockdown();
	};

	return {
		prepareLockdown: prepareLockdown,
		executeLockdown: executeLockdown,
		onLockdown: onLockdown,
		tearDown: tearDown
	};
});
