angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, DXFileSystem){
	"use strict";


	var ipc = $window.require("ipc");
	var nativeModule = $window.require("./platforms/electron/node/build/Release/dxpreconditiontests");

	var fatalFails;
	var finishedTests;
	var warningFails;
	var tests;
	//var remote = $window.require("remote");

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

	var testsFinished = function() {
		if (finishedTests === tests.length) {
			$window.console.log("All tests finished");
		}
		else {
			$window.console.log("Still running");
		}
	};

	var finished = function() {
		finishedTests++;
	};

	var startPreconditionTests = function() {
		fatalFails = 0;
		warningFails = 0;
		finishedTests = 0;
		$window.console.log("Running all precondition tests");
		/*console.log(tests[0].run());
		console.log(tests[1].run());
		console.log(tests[2].run());
		console.log(tests[3].run());
		tests.forEach(function(currTest){
			currTest().run();
			finishedTests++;
		});*/
		for (var i = 0; i < tests.length; i++){
			$window.console.log("Running test for " + tests[i].failTitle);
			$window.console.log(tests[i].run());
			//nativeModule.run(test[i]);
		}

		var nativeTestsStartedCount = nativeModule.run(onNativeTestDone);

		//tests.forEach(test in tests)
		//presentFatalsAndExit();
		//$window.console.log("Done running all tests");
	};

	var onNativeTestDone = function(result) {
		console.log(result);
	}

	var init = function() {
		$window.console.log("Initializing function array");
		tests = nativeModule.getAllTests();
		$window.console.log(tests);
		$window.console.log("Length: " + tests.length);




		startPreconditionTests();
		testsFinished();
	};

	var init2 = function() {
		$window.console.log("Obj wrap test");
		$window.console.log(nativeModule);
		//var osTest = nativeModule.getOsTest(10);
		nativeModule.run(onNativeTestDone);
		//tests = nativeModule.getOsTest();
	};

	var testsPassed = function(){
		ipc.sendSync("testsPassed");
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
		"startPreconditionTests": startPreconditionTests,
		"init": init,
		"init2": init2
	};

});
