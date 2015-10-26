angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http, DXFileSystem){
	"use strict";

	var fs = $window.require("fs");
	var modulePath = "./platforms/electron/node/build/Release/dxpreconditiontests";

	var nativeModule = $window.require(modulePath);

	var fatalFailArray = [];
	var warningArray = [];

	var finishedTests = 0;
	var testCount;

	var onAllTestsDoneCallback = null;

	var onTestDone = function(result) {
		$window.console.log(result);
		$window.console.log("OATCB: " + onAllTestsDoneCallback);
		if (!result.isSuccess) {
			if (result.isFailFatal) {
				$window.console.log("Adding to fatal");
				fatalFailArray.push(result);
			}
			else {
				$window.console.log("Adding to warning");
				warningArray.push(result);
			}
		}
		$window.console.log(finishedTests);
		if (finishedTests++ === testCount) // && onAllTestsDoneCallback != null) {
		{
			$window.console.log("All tests done");
			onAllTestsDoneCallback(warningArray, fatalFailArray);
		}
	};

	var internetAccessTest = function(callback) {
		$http.get(_apiBaseUrl).then(function(response) {
			var result = {
				failTitle: "Internet access test",
				failMessage: "No internet connection.",
				isFailFatal: false,
				isSuccess: false
			};

			if (response.status === 200) {
				//result.isSuccess = true;
				result.isSuccess = false;
			}
			callback(result);
		});
	};

	var writePermissionTest = function(callback) {
		$window.console.log("Write permission test");
		if(DXFileSystem.getExamDir() === null) {
			DXFileSystem.makeDir();
		}
		if(DXFileSystem.getLogDir() === null) {
			DXFileSystem.makeLogDir();
		}
		var result = {
			failTitle: "Write permission error.",
			failMessage: "DigiExam does not have write permission in the cache directory on the file system.\n\
							If you are running as administrator and still get this error message, \n\
							please contact DigiExam for further troubleshooting",
			isFailFatal: true,
			isSuccess: false
		};
		fs.stat(DXFileSystem.getAppDataDir(), function(error, stats){
			$window.console.log("Test AppDataDir RW permission. TODO!");
			$window.console.log(stats.mode);
		});
		fs.stat(DXFileSystem.getExamDir(), function(error, stats){
			$window.console.log("Test ExamDir RW permission. TODO!");
			$window.console.log(stats.mode);
		});
		fs.stat(DXFileSystem.getLogDir(), function(error, stats){
			$window.console.log("Test LogDir RW permission. TODO!");
			$window.console.log(stats.mode);
		});

		callback(result);
		//Tre steg, kolla om Application Support DigiExam Client folder har RW
		//Kolla om examDir har RW samt om logDir har RW

	};

	var init = function(callback) {
		onAllTestsDoneCallback = callback;
		testCount = nativeModule.run(onTestDone);
		$window.console.log("Testcount " + testCount);
		internetAccessTest(onTestDone);
		writePermissionTest(onTestDone);
	};

	return {
		"init": init
	};
});
