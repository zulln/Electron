angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http){
	"use strict";

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

	var init = function(callback) {
		onAllTestsDoneCallback = callback;
		testCount = nativeModule.run(onTestDone);
		$window.console.log("Testcount " + testCount);
		internetAccessTest(onTestDone);
	};

	return {
		"init": init
	};
});
