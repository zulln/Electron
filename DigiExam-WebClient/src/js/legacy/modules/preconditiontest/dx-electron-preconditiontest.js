angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, DXFileSystem, DXClient){
	"use strict";

	var remote = $window.require("remote");
	var dialog = remote.require("dialog");
	var fatalFails;
	var finishedTests;
	var warningFails;
	var tests;
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
		$window.console.log("osVersioNTest Check - TODO ");
	};

	var presentFatalsAndExit = function() {
		dialog.showErrorBox("Fatal error", "DigiExam will exit");
		DXClient.close();
	};

	var presentWarningsAndProceed = function() {
		dialog.showMessageBox({
			type: "warning",
			buttons: ["OK"],
			title: "Precondition Warning",
			message: "Warning dialog",
			detail: "Precondition Warning"
		});
	};

	var startPreconditionTests = function() {
		fatalFails = 0;
		warningFails = 0;
		finishedTests = 0;
		$window.console.log("Running all precondition tests");
		tests.forEach(function(currTest){
			currTest();
			finishedTests++;
		});
		//tests.forEach(test in tests)
		//presentFatalsAndExit();
		//$window.console.log("Done running all tests");
	};

	var init = function() {
		$window.console.log("Initializing function array");
		tests = [
			virtualMachineDetect,
			internetAccessTest,
			diskSpaceTest,
			autoUpdateTest,
			installedTest,
			osVersionTest
		];
	};

	(function() {
		init();
		startPreconditionTests();
		//fatalFails = 1;
		//warningFails = 1;
		if (fatalFails > 0) {
			presentFatalsAndExit();
		}
		if (warningFails > 0) {
			presentWarningsAndProceed();
		}
	})();

	return {
		"startPreconditionTests": startPreconditionTests
	};

});
