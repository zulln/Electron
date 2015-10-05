angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, DXFileSystem){
	"use strict";

	var os = $window.require("os");
	//var modulePath = "./platforms/electron/node/build/Release/dxpreconditiontests";
	//var remote = $window.require("remote");

	var virtualMachineDetect = function() {
		$window.console.log("VM Check - TODO");
	};

	var internetAccessTest = function() {
		$window.console.log("internetAccessTest Check - TODO");
	};

	var diskSpaceTest = function() {
		$window.console.log("diskSpaceTest");
		DXFileSystem.printModuleName();				//Add error checking if file path is not set to /Users/Username/Library/Application Suppurt/DigiExam Client/exams0




		$window.console.log(DXFileSystem.getExamDir());
		//$window.console.log(DXFileSystem.getExamDir());
	};

	var autoUpdateTest = function() {
		$window.console.log("autoUpdateTest Check - TODO");
	};

	var installedTest = function() {
		$window.console.log("installedTest Check - TODO");

	};

	var osVersionTest = function() {
		$window.console.log("OSVersion: " + os.release());
	};

	var runAll = function() {
		$window.console.log("Running all pre-condition tests");
		virtualMachineDetect();
		internetAccessTest();
		diskSpaceTest();
		autoUpdateTest();
		installedTest();
		osVersionTest();
		//$window.console.log("Done running all tests");
	};

	(function() {
		runAll();
	})();

	return {
		"runAll": runAll
	};

	//var path = $window.require("path");
	/*var modulePath = "./platforms/electron/node/build/Release/dxlockdown";
	var remote = $window.require("remote");
	var BrowserWindow = remote.require("browser-window");

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
	};*/
});
