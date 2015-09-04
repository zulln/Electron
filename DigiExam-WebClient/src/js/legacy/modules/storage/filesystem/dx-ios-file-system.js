angular.module("digiexamclient.storage.filesystem")
.factory("IOSFileSystem", function($q, $timeout, JsObjcBridge) {
	"use strict";

	var COMMAND = {
		"MAKE_DIR": "make_dir",
		"READ_FILE": "read_file",
		"WRITE_FILE": "write_file",
		"LIST_DIRECTORY": "list_directory"
	};

	var mockedPromise = function(resolveData) {
		var deferred = $q.defer();
		$timeout(function(){
			deferred.resolve(resolveData);
		}, 0);
		return deferred.promise;
	};

	var makePromiseAndCallback = function() {
		var deferred = $q.defer();
		var callback = function(data) {
			deferred.resolve(data);
		};
		return {"promise": deferred.promise, "callback": callback};
	};

	var sendToObjc = function(data) {
		var promiseAndCallback = makePromiseAndCallback();
		var promise = promiseAndCallback.promise;
		var callback = promiseAndCallback.callback;
		JsObjcBridge.sendToObjc(data, callback);
		return promise;
	};

	var requestFileSystem = function() {
		/*
		 * Mocked since this is not necessary on iOS
		 */
		return mockedPromise();
	};

	var listDirectory = function(quota, path) {
		/*
		 * Get directory content as a string(NSFileManager
		 * contentsOfDirectoryAtPath description).
		 */
		var data = {
			"command": COMMAND.LIST_DIRECTORY,
			"data": {
				"path": path
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	var makeDir = function(quota, path, name) {
		/*
		 * Creates a directory.
		 */
		var data = {
			"command": COMMAND.MAKE_DIR,
			"data": {
				"path": path,
				"name": name
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	var openFile = function() {
		/*
		 * Mocked until offline support exists
		 */
		return mockedPromise();
	};

	var readFile = function(quota, path, name) {
		/*
		 * Get contents of an existing file as a string.
		 */
		var data = {
			"command": COMMAND.READ_FILE,
			"data": {
				"path": path,
				"name": name
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	var requestQuota = function() {
		/*
		 * Mocked since this is not necessary on iOS
		 */
		return mockedPromise();
	};

	var saveAs = function() {
		/*
		 * Prompts the user to open an existing file or a new file and returns a
		 * writable FileEntry on success.
		 *
		 * `data`: The blob to write
		 * `name`: The suggested file name that will be presented to the user as
		 *         the default name to read or write. This is optional.
		 * `mime`: The mime type as a string.
		 * `accepts`: The optional list of accept options for this file opener.
		 *            Each option will be presented as a unique group to the
		 *            end-user.
		 */
		return mockedPromise();
	};

	var writeFile = function(quota, path, filename, fileData, mime) {
		/*
		 * Creates up a file without prompting the user.
		 *
		 * `quota`: The storage space—in bytes
		 * `path`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked up.
		 * `filename`: Name of file to be appended to path
		 * `data`: The blob to write
		 * `mime`: The mime type as a string.
		 */
		var data = {
			"command": COMMAND.WRITE_FILE,
			"data": {
				"path": path,
				"filename": filename,
				"data": fileData,
				"mime": mime
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	return {
		"requestFileSystem": requestFileSystem, // Mocked, not necessary on iOS
		"listDirectory": listDirectory,         // Implemented
		"makeDir": makeDir,                     // Implemented
		"openFile": openFile,                   // Mocked, will not implement until offline support exists
		"readFile": readFile,                   // Implemented
		"requestQuota": requestQuota,           // Mocked, not necessary on iOS
		"saveAs": saveAs,                       // Mocked, will not implement until offline support exists
		"writeFile": writeFile                  // Implemented
	};
});
