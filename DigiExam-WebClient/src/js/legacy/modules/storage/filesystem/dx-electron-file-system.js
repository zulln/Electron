angular.module("digiexamclient.storage.filesystem")
.factory("ElectronFileSystem", function($q, $timeout) {
	"use strict";

	var mockedPromise = function(resolveData) {
		var deferred = $q.defer();
		$timeout(function(){
			deferred.resolve(resolveData);
		}, 0);
		return deferred.promise;
	};

	var requestFileSystem = function(/*quota*/) {
		/*
		 * Requests a sandboxed file system where data should be stored.
		 *
		 * `quota`: The storage space—in bytes
		 */
		return mockedPromise();
	};

	var listDirectory = function(/*quota, path*/) {
		/*
		 * Looks up a directory.
		 *
		 * `quota`: The storage space—in bytes
		 * `path`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked up.
		 */
		return mockedPromise();
	};

	var makeDir = function(/*quota, path, name*/) {
		/*
		 * Creates a directory.
		 *
		 * `quota`: The storage space—in bytes
		 * `path`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked created. It is an
		 *         error to attempt to create a file whose immediate parent does
		 *         not yet exist.
		 * `name`: Name to be appended to path
		 */
		return mockedPromise();
	};

	var openFile = function(/*accepts*/) {
		/*
		 * Ask the user to choose a file or directory.
		 *
		 * `accepts`: The optional list of accept options for this file opener.
		 *            Each option will be presented as a unique group to the
		 *            end-user.
		 */
		return mockedPromise();
	};

	var readFile = function(/*quota, path, name*/) {
		/*
		 * Looks up an existing file.
		 *
		 * `quota`: The storage space—in bytes
		 * `path`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked up.
		 * `name`: Name of file to be appended to path
		 */
		return mockedPromise();
	};

	var requestQuota = function(/*bytes*/) {
		/*
		 * Ask for more storage. The browser presents an info bar to prompt user to
		 * grant or deny the app the permission to have more storage.
		 *
		 * `bytes`: The amount of bytes you want in your storage quota.
		 */
		return mockedPromise();
	};

	var saveAs = function(/*data, name, mime, accepts*/) {
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

	var writeFile = function(/*quota, path, filename, data, mime*/) {
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
		return mockedPromise();
	};

	return {
		"requestFileSystem": requestFileSystem,
		"listDirectory": listDirectory,
		"makeDir": makeDir,
		"openFile": openFile,
		"readFile": readFile,
		"requestQuota": requestQuota,
		"saveAs": saveAs,
		"writeFile": writeFile
	};
});
