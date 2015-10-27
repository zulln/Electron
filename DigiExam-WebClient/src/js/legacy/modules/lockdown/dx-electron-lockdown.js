angular.module("digiexamclient.lockdown", [])
.factory("ElectronLockdown", function($q, $window){
	"use strict";

	var modulePath = "./platforms/electron/node/build/Release/dxlockdown";
	var nativeModule = $window.require(modulePath);

	var prepareLockdown = function() {
		$window.console.log("prepareLockdown");
	};

	var executeLockdown = function() {
		$window.console.log("Lockdown message: " + nativeModule.getName());
		nativeModule.executeLockdown();
	};

	var onLockdown = function () {
		$window.console.log("Lockdown onLockdown");
		nativeModule.onLockdown();
	};

	var tearDown = function() {
		//TO DO
		$window.console.log("Lockdown teardown");
		nativeModule.teardownLockdown();
	};

	return {
		prepareLockdown: prepareLockdown,
		executeLockdown: executeLockdown,
		onLockdown: onLockdown,
		tearDown: tearDown
	};
});
