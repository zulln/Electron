angular.module("digiexamclient.lockdown")
.factory("ElectronLockdown", function($q, $window){
	"use strict";

	var executeLockdown = function(/*quota*/) {
		/*
		 * Requests a sandboxed file system where data should be stored.
		 *
		 * `quota`: The storage space—in bytes
		 */
		$window.console.log("Mac Init Lockdown");
	};
});
