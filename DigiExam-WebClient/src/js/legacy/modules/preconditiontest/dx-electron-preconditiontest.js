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
		if (!result.isSuccess) {
			if (result.isFailFatal) {
				fatalFailArray.push(result);
			}
			else {
				warningArray.push(result);
			}
		}
		if (finishedTests === testCount && onAllTestsDoneCallback != null) {
			onAllTestsDoneCallback(warningArray, fatalFailArray);
		}
		else {
			finishedTests++;
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
		testCount = nativeModule.run(onTestDone) + 1;
		internetAccessTest(onTestDone);
	};

	return {
		"init": init
	};
});
