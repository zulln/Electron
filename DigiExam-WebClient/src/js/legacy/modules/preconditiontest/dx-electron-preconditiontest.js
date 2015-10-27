angular.module("digiexamclient.preconditiontest", [])
.factory("ElectronPreconditionTest", function($q, $window, $http, DXFileSystem){
	"use strict";

	var fs = $window.require("fs");
	var modulePath = "./platforms/electron/node/build/Release/dxpreconditiontests";
	var nativeModule = $window.require(modulePath);

	/*
		When AppDataFolder is created, all permissions are set to 16822 on Windows
		including all subfolders (exams & logs)
		Permissions on Mac are set to 16832 for appDataFolder and 16877 on subfolders
	*/

	var appDataFolderPermissionRequired = (function() {
		if($window.navigator.platform === "Win32") { return 16822; }
		else {return 16832; }
	})();

	var subFolderPermissionRequired = (function() {
		if($window.navigator.platform === "Win32") { return 16822; }
		else {return 16877; }
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

	var onTestDone = function(result) {
		if (!result.isSuccess) {
			if (result.isFailFatal) {
				fatalFailArray.push(result);
			}
			else {
				warningArray.push(result);
			}
		}
		if (finishedTests++ === testCount) // && onAllTestsDoneCallback != null) {
		{
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
				result.isSuccess = true;
			}
			callback(result);
		});
	};

	var createOnStatDoneCallback = function(dir, callback) {

		var result = {
			failTitle: "Write permission error.",
			failMessage: "DigiExam does not have write permission in the cache directory on the file system.\
							Make sure that you have sufficient privileges to the DigiExam cache directory, \
							otherwise please contact DigiExam for further troubleshooting",
			isFailFatal: true,
			isSuccess: false
		};

		return function(error, stats) {
			statsReceived.push(stats);

			if (statsReceived.length === dirs.length) {
				for (var i = 0; i < statsReceived.length; i++) {
					if (statsReceived[i].mode !== folderPermissions[i]){
						result.isSuccess = false;
						break;
					}
					else {
						result.isSuccess = true;
					}
				}
				callback(result);
			}
		};
	};

	var writePermissionTest = function() {
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
	};

	var init = function(callback) {
		onAllTestsDoneCallback = callback;
		testCount = nativeModule.run(onTestDone) + 1;
		internetAccessTest(onTestDone);
		writePermissionTest();
	};

	return {
		"init": init
	};
});
