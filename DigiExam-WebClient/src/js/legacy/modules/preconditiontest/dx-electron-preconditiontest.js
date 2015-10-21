angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http, DXFileSystem){
	"use strict";


	var ipc = $window.require("ipc");
	var nativeModule = $window.require("./platforms/electron/node/build/Release/dxpreconditiontests");

	var fatalFailArray = [];
	var warningArray = [];

	var finishedTests = 0;
	var tests;


	var testsPassed = function(){
		ipc.sendSync("testsPassed");
	};

	var testsFinished = function() {
		finishedTests++;
		if (finishedTests === tests.length) {
			$window.console.log("All tests finished");
			testsPassed();
		}
		else {
			$window.console.log("Still running");
		}
	};

	/*var startPreconditionTests = function() {
		nativeModule.run(onTestDone);

		//tests.forEach(test in tests)
		//presentFatalsAndExit();
		//$window.console.log("Done running all tests");
	};*/

	var onTestDone = function(result) {
		$window.console.log(result.failTitle);
		if (!result.isSuccess) {
			$window.console.log("Didn't pass");
			if (result.isFailFatal) {
				$window.console.log("If");
				fatalFailArray.push(result);
				$window.console.log(fatalFailArray.length);
				$window.console.log(fatalFailArray[0]);
			}
			else {
				$window.console.log("Else");
				warningArray.push(result);
				$window.console.log(warningArray.length);
				$window.console.log(warningArray[0]);
			}
			testsFinished();
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
				result.isSuccess = true;
			}
			$window.console.log(result);
			callback(result);
		});
	};

	var presentTestOutcome = function() {
		$window.console.log("No of Warnings: " + warningArray.length + " " + warningArray);
		$window.console.log("No of Fatals: " + fatalFailArray.length + " " + fatalFailArray);
	};

	/*var init = function() {
		$window.console.log("Initializing function array");
		tests = nativeModule.getAllTests();
		$window.console.log(tests);
		$window.console.log("Length: " + tests.length);
		startPreconditionTests();
		testsFinished();
	};*/

	var init2 = function() {
		$window.console.log("Obj wrap test");
		//$window.console.log(nativeModule);
		tests = nativeModule.run(onTestDone);
		$window.console.log("TestCount: " + tests);
		internetAccessTest(onTestDone);
		presentTestOutcome();
		testsFinished();
	};

	return {
		//"startPreconditionTests": startPreconditionTests,
		//"init": init,
		"init2": init2
	};

});
