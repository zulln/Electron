angular.module("digiexamclient.storage.filesystem")
.factory("ElectronFileSystem", function($q, $timeout, $window) {
	"use strict";

	var appDataFolder = null;
	var fs = $window.require("fs");
	var remote = $window.require("remote");
	var dialog = remote.require("dialog");
	var path = $window.require("path");

	$window.console.log("ElectronFileSystem got fs:", fs);

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
		appDataFolder = remote.require("app").getPath("userData");
		return appDataFolder;
	};

	var makeDir = function(quota, filepath, name) {
		/*
		 * Creates a directory.
		 *     Create exam dir in rel path to Application Support for OSX, %AppData% for Win
		 * `quota`: The storage space—in bytes
		 * `filepath`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked created. It is an
		 *         error to attempt to create a file whose immediate parent does
		 *         not yet exist.
		 * `name`: Name to be appended to path
		 */
		var deferred = $q.defer();
		if(filepath === "")
		{
			filepath = requestFileSystem();
		}
		filepath = path.join(filepath, name);
		fs.mkdir(filepath, function (err) {
			if (err) {
				if(fs.statSync(filepath).isDirectory())
				{ deferred.resolve("Path " + filepath + "/" + name + " already exists"); }
				else
				{ deferred.reject("Could not create dir: " + filepath + "/" + name);	}
			}
			else {
				$window.console.log("Created dir: " + filepath);
				deferred.resolve("filepath " + filepath + "/" + name + " created");
			}
		});
		return deferred.promise;
	};

	var listDirectory = function(quota, filepath) {
		/*
		 * Looks up a directory.
		 *
		 * `quota`: The storage space—in bytes
		 * `path`: Either an absolute path or a relative path from the
		 *         DirectoryE	ntry to the directory to be looked up.
		 *         Return array with all files in selected folder.
		 */
		$window.console.log("List Dir angularJS");
		fs.readdir(filepath, function(err, files) {
			if(!err) { return files; }
			else { return []; }
		});

	};

	var readFile = function(quota, filepath, name) {
		/*
		 * Looks up an existing file.
		 *
		 * `quota`: The storage space—in bytes
		 * `filepath`: Either an absolute path or a relative path from the
		 *         DirectoryEntry to the directory to be looked up.
		 * `name`: Name of file to be appended to path
		 */
		var deferred = $q.defer();
		var fileContent = "";

		fs.readFile(filepath + name, "utf8", function(err, data) {
			if(err) {
				$window.console.log("Error reading file");
				deferred.reject(err);
			}
			else
			{
				fileContent = data;
				deferred.resolve(fileContent);
			}
		});
		return deferred.promise;
		//Lägga in reject ifall filen failar
	};


	var openFile = function(accepts) {
		/*
		 * Ask the user to choose a file or directory.
		 *
		 * `accepts`: The optional list of accept options for this file opener.
		 *            Each option will be presented as a unique group to the
		 *            end-user.
		 */

		var fileType = accepts[0].extensions[0];		//Extracting file type from accepts array
		var deferred = $q.defer();

		var fileDescriptor = dialog.showOpenDialog(
			{
				title: "Open offline exam",
				filters: [
					{name: fileType.toUpperCase(),
						extensions: [fileType],
						properties: openFile }
				]
			});
		if(fileDescriptor === undefined) {deferred.reject(); }

		else {
			fileDescriptor = fileDescriptor[0];		//Turn array into string
			var filepath = fileDescriptor.substring(0, fileDescriptor.lastIndexOf("/") + 1);
			var filename =	fileDescriptor.substring(fileDescriptor.lastIndexOf("/") + 1, fileDescriptor.length);
			var readFilePromise = readFile(null, filepath, filename);

			readFilePromise.then(function(fileData){
				deferred.resolve(fileData);
			},
				function(reason) {
					$window.console.log("Reason" + reason);
					deferred.reject(reason);
				}
			);
		}

		return deferred.promise;
	};

	var requestQuota = function(/*bytes*/) {
		/*
		 * Ask for more storage. The browser presents an info bar to prompt user to
		 * grant or deny the app the permission to have more storage.
		 *
		 * `bytes`: The amount of bytes you want in your storage quota.
		 */
		$window.console.log("Request Quota angularJS");
		return mockedPromise();
	};

	var writeFile = function(quota, filepath, filename, data, mime) {
		/*
		 * Creates up a file without prompting the user.
		 *
		 * `quota`: The storage space—in bytes
		 * `filepath`: Either an absolute path or a relative filepath from the
		 *         DirectoryEntry to the directory to be looked up.
		 * `filename`: Name of file to be appended to path
		 * `data`: The blob to write
		 * `mime`: The mime type as a string.
		 */

		var deferred = $q.defer();
		$window.console.log("Write file angularJS");
		$window.console.log("filepath: " + filepath);
		$window.console.log("filename: " + filename);
		$window.console.log("data: " + data);
		$window.console.log("mime: " + mime);

		/* relative
		"exams/"
		"../exams/"
		"./exams/"

		// absolute
		"C:/exams/"
		"/exams/"
		"~/exams/"
		*/

		if(!path.isAbsolute(filepath))
		{
			filepath = path.join(appDataFolder, filepath);
			$window.console.log("filepath changed to: " + filepath);
		}

		fs.writeFile(filepath + filename, data, function(err, written, buffer)
		{
			$window.console.log("Written " + written + " bytes");
			$window.console.log("Buffer data: " + buffer);
			if(!err) {deferred.resolve(); }
			else {deferred.reject(err); }
		});

		return deferred.promise;
	};

	var saveAs = function(data, name, mime, accepts) {
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
		 *
		 */
		var fileType = accepts[0].extensions[0];
		var deferred = $q.defer();

		$window.console.log("SaveAs angularJS");
		$window.console.log("Data: " + data);
		$window.console.log("name: " + name);
		$window.console.log("mime: " + mime);
		$window.console.log("accepts: " + fileType);

		var fileDescriptor = dialog.showSaveDialog(
			{
				title: "test",
				filters: [
					{ name: fileType.toUpperCase(), extensions: [fileType] }
				]
			});

		if(fileDescriptor === undefined) {deferred.reject(); }
		else
		{
			var filepath = fileDescriptor.substring(0, fileDescriptor.lastIndexOf("/") + 1);
			var filename =	fileDescriptor.substring(fileDescriptor.lastIndexOf("/") + 1, fileDescriptor.length);

			$window.console.log("FilePath: " + filepath);
			$window.console.log("FileName: " + filename);

			var writeFilePromise = writeFile(null, filepath, filename, data, mime);

			writeFilePromise.then(function(){
				deferred.resolve("success");
			},
				function(reason){
					$window.console.log("Reason" + reason);
					deferred.reject(reason);
				}
			);
		}

		return deferred.promise;
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
