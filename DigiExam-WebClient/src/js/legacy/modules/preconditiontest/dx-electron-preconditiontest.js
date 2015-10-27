angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http, DXFileSystem){
	"use strict";

	var fs = $window.require("fs");
	var modulePath = "./platforms/electron/node/build/Release/dxpreconditiontests";

	var nativeModule = $window.require(modulePath);

	var appDataFolderPermissionRequired = (function() {
		if($window.navigator.platform === "Win32") { return "16822"; }
		else {return "16832"; }
	})();

	var subFolderPermissionRequired = (function() {
		if($window.navigator.platform === "Win32") { return "16822"; }
		else {return "16877"; }
	})();

	var dirs = [];
	var fatalFailArray = [];
	var folderPermissions = [
		appDataFolderPermissionRequired,
		subFolderPermissionRequired,
		subFolderPermissionRequired
	];
	var statsReceived = [];
	var warningArray = [];

	var finishedTests = 0;
	var testCount;
	var onAllTestsDoneCallback = null;

	/*
		When AppDataFolder is created, all permissions are set to 16822 on Windows
		including all subfolders (exams & logs)
		Permissions on Mac are set to 16832 for appDataFolder and 16877 on subfolders
	*/

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

	var printAccess = function(stats) {
		$window.console.log(stats);
		$window.console.log(stats.mode);

		$window.console.log("    size: " + stats.size);
		$window.console.log("    mode: " + stats.mode);
		$window.console.log("    others eXecute: " + (stats.mode & "1" ? "x" : "-"));
		$window.console.log("    others Write:   " + (stats.mode & "2" ? "w" : "-"));
		$window.console.log("    others Read:    " + (stats.mode & "4" ? "r" : "-"));

		$window.console.log("    group eXecute:  " + (stats.mode & "10" ? "x" : "-"));
		$window.console.log("    group Write:    " + (stats.mode & "20" ? "w" : "-"));
		$window.console.log("    group Read:     " + (stats.mode & "40" ? "r" : "-"));

		$window.console.log("    owner eXecute:  " + (stats.mode & "100" ? "x" : "-"));
		$window.console.log("    owner Write:    " + (stats.mode & "200" ? "w" : "-"));
		$window.console.log("    owner Read:     " + (stats.mode & "400" ? "r" : "-"));

		$window.console.log("    file:           " + (stats.mode & "0100000" ? "f" : "-"));
		$window.console.log("    directory:      " + (stats.mode & "0040000" ? "d" : "-"));
	};

	var createOnStatDoneCallback = function(dir, callback) {

		var result = {
			failTitle: "Write permission error.",
			failMessage: "DigiExam does not have write permission in the cache directory on the file system.\n\
							If you are running as administrator and still get this error message, \n\
							please contact DigiExam for further troubleshooting",
			isFailFatal: true,
			isSuccess: false
		};

		return function(error, stats) {
			statsReceived.push(stats);
			$window.console.log("onStatDone for dir", dir);
			$window.console.log("DIrsLength " + dirs.length);
			$window.console.log("Ststslength " + statsReceived.length);

			if (statsReceived.length === dirs.length) {
				for (var i = 0; i < statsReceived.length; i++) {
					//var stat = statsReceived[i];
					$window.console.log("StatsRec: " + i + " " + statsReceived[i].mode);
					$window.console.log("folderPermission: " + i + " " + folderPermissions[i]);
					if (statsReceived[i].mode != folderPermissions[i]){
						$window.console.log("If is true");
						result.isSuccess = false;
						break;
					}
					else {
						result.isSuccess = true;
					}
				}

				callback(result);
				$window.console.log("All stat checks are done, report back.");
			}
		};
	};

	var writePermissionTest = function() {
		$window.console.log("Write permission test");



		if(DXFileSystem.getExamDir() === null) {
			DXFileSystem.makeDir();
		}
		if(DXFileSystem.getLogDir() === null) {
			DXFileSystem.makeLogDir();
		}

		dirs = [
			DXFileSystem.getAppDataDir(),
			DXFileSystem.getExamDir(),
			DXFileSystem.getLogDir()
		];

		for (var i = 0; i < dirs.length; i++) {
			var onStatDoneCallback = createOnStatDoneCallback(dirs[i], onTestDone);
			fs.stat(dirs[i], onStatDoneCallback);
		}

		//Tre steg, kolla om Application Support DigiExam Client folder har RW
		//Kolla om examDir har RW samt om logDir har RW

	};

	var init = function(callback) {
		onAllTestsDoneCallback = callback;
		testCount = nativeModule.run(onTestDone) + 1;
		$window.console.log("Testcount " + testCount);
		internetAccessTest(onTestDone);
		writePermissionTest();
	};

	return {
		"init": init
	};
});
