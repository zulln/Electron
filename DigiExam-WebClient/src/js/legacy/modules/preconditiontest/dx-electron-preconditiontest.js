angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, DXFileSystem){
	"use strict";

	var remote = $window.require("remote");
	var dialog = remote.require("dialog");
	var nativeModule = $window.require("./platforms/electron/node/build/Release/dxpreconditiontests");
	var fatalFails;
	var finishedTests;
	var warningFails;
	var tests;
	//var remote = $window.require("remote");

	var presentFatalsAndExit = function() {
		dialog.showErrorBox("Fatal error", "DigiExam will exit");
		$window.close();
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

	var internetAccessTest = function(callback) {
		$http.get(_apiBaseUrl).then(function(response) {
			var result = {
				title: "Internet access test",
				description: "No internet connection.",
				outcome: "warning"
			};

			if (response.status === 200) {
				result.outcome = "success";
			}

			callback(result);
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
		tests = nativeModule.getAllTests();
	};
	var startTests = function() {
		init();
		startPreconditionTests();
		fatalFails = 1;
		//warningFails = 1;
		if (fatalFails > 0) {
			presentFatalsAndExit();
		}
		if (warningFails > 0) {
			presentWarningsAndProceed();
		}
	};
	/*(function() {
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
	})();*/

	return {
		"startPreconditionTests": startPreconditionTests
	};

});

/*angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http, DXFileSystem){
	"use strict";



	var modulePath = "./platforms/electron/node/build/Release/dxpreconditiontests";
	var nativeModule = $window.require(modulePath);
	var remote = $window.require("remote");
	var dialog = remote.require("dialog");

	var fatalFails;
	var finishedTests;
	var tests;
	var warningFails;
	//var remote = $window.require("remote");

	var virtualMachineDetect = function() {
		$window.console.log("VM Check - TODO");
	};

	var internetAccessTest = function() {
		$window.console.log("internetAccessTest Check");
		$http.get(_apiBaseUrl).then(function(response) {
			if(response.status !== 200 || (response.data !== null) || !!response.data.error || !!response.data.code) {
				return false;
			}
			return true;
		});
	};

	var diskSpaceTest = function() {
		$window.console.log("diskSpaceTest");
		DXFileSystem.printModuleName();				//Add error checking if file path is not set to /Users/Username/Library/Application Suppurt/DigiExam Client/exams0
		$window.console.log("Should not be null: " + DXFileSystem.getExamDir());
		//$window.console.log(DXFileSystem.getExamDir());
	};

	var autoUpdateTest = function() {
		$window.console.log("autoUpdateTest Check - TODO");

	};

	var installedTest = function() {
		$window.console.log("installedTest Check");
		$window.console.log("IsInstalled: " + nativeModule.isInstalled());
	};

	var osVersionTest = function() {
		$window.console.log("osVersioNTest Check");
		$window.console.log("OSVersion module boolean: " + nativeModule.isCorrectOSVersion());
	};

	var startPreconditionTests = function() {
		finishedTests = 0;
		$window.console.log("Running all precondition tests");
		tests.forEach(function(currTest){
			$window.console.log("Test result: " + currTest());
			finishedTests++;
		});
	};

	var init = function() {
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
	})();

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

/*
	var testsStarted = 0;
	var testsFinished = 0;

	var internetAccessTest2 = function(callback) {
		$http.get(_apiBaseUrl).then(function(response) {
			var result = {
				title: "Internet access",
				description: "You have no internetz",
				outcome: "warning"
			};

			if (response.status === 200) {
				result.outcome = "success";
			}

			callback(result);
		});
	}

	var onTestFinished = function(result) {
		// Är alla test klara?


		testsFinished++;

		console.log("Got result", result, "tests finished", testsFinished);

		if (testsStarted == testsFinished) {
			console.log("All tests are finished!");
		}
	}

	var startTests = function() {
		testsStarted = 6;
		internetAccessTest2(onTestFinished);
		internetAccessTest2(onTestFinished);
		internetAccessTest2(onTestFinished);
		internetAccessTest2(onTestFinished);
		internetAccessTest2(onTestFinished);
		internetAccessTest2(onTestFinished);
	}*/

	/*return {
		"startPreconditionTests": startPreconditionTests,
		"startTests": startTests
	};*/

//});
