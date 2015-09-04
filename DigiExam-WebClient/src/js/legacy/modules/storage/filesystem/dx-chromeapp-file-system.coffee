# TODO: Make new file system factory which dispatches the right file system depending on browser (Chrome or iPad)
# TODO: Make this factory a Chrome file system specific factory which is only accessed from a wrapping factory

angular.module("digiexamclient.storage.filesystem").factory "ChromeAppFileSystem", ($rootScope, $q, $window, DX_PLATFORM)->
	requestFileSystem = if $window.requestFileSystem then $window.requestFileSystem else $window.webkitRequestFileSystem

	ChromeAppFileSystem = {}

	ChromeAppFileSystem.openFile = (accepts)->
		deferred = $q.defer()
		$window.chrome.fileSystem.chooseEntry { type: "openFile", accepts: accepts }, (readOnlyEntry)->
			readOnlyEntry.file (file)->

				reader = new FileReader()
				reader.onerror = ->
					deferred.reject "Could not open file."
					$rootScope.$apply()

				reader.onloadend = (e)->
					deferred.resolve e.target.result
					$rootScope.$apply()

				reader.readAsText file

		return deferred.promise

	ChromeAppFileSystem.saveAs = (data, name, mime, accepts)->
		deferred = $q.defer()
		$window.chrome.fileSystem.chooseEntry { type: "saveFile", suggestedName: name, accepts: accepts }, (writableFileEntry)->
			writableFileEntry.createWriter (writer)->

				###
				#
				#	Seems to be a bug when overwriting files. It seems to prepend the data to the file, this fixes it.
				#	http://stackoverflow.com/a/21909322/384868
				#
				###
				writer.onwrite = ->
					writer.onwrite = null
					writer.truncate writer.position

				writer.onerror = ->
					deferred.reject "Could not write to file."

				writer.onwriteend = (e)->
					deferred.resolve e

				writer.write new Blob([data]), { type: mime }

		return deferred.promise

	ChromeAppFileSystem.requestQuota = (bytes)->
		deferred = $q.defer()
		storageInfo = if $window.storageInfo? then $window.storageInfo else $window.webkitStorageInfo
		storageInfo.requestQuota $window.PERSISTENT, bytes, (quotaGranted)->
			deferred.resolve quotaGranted
		, ->
			deferred.reject()
		return deferred.promise

	ChromeAppFileSystem.requestFileSystem = (quota)->
		deferred = $q.defer()
		requestFileSystem $window.PERSISTENT, quota, (fs)->
			deferred.resolve fs
		, (ex)->
			deferred.reject ex
		return deferred.promise

	getPath = (path)->
		path = if path[0] is "/" then path.substr(1, path.length) else path
		path = if path[path.length] isnt "/" then path += "/" else path

	ChromeAppFileSystem.makeDir = (quota, path, name)->
		deferred = $q.defer()
		path = getPath path
		fsPromise = ChromeAppFileSystem.requestFileSystem()
		fsPromise.then (fs)->
			fs.root.getDirectory "#{path}#{name}", { create: true }, ->
				deferred.resolve()
			, (ex)->
				deferred.reject ex
		, (ex)->
		return deferred.promise

	ChromeAppFileSystem.readFile = (quota, path, name)->
		deferred = $q.defer()
		path = getPath path
		fsPromise = ChromeAppFileSystem.requestFileSystem()
		fsPromise.then (fs)->
			fs.root.getFile "#{path}#{name}", (fileEntry)->
				fileEntry.file (file)->
					reader = new FileReader()

					reader.onloadend = (e)->
						deferred.resolve @result

					reader.onerror = (ex)->
						deferred.reject ex

					reader.readAsText file
				, (ex)->
					deferred.reject ex
			, (ex)->
				deferred.reject ex
		, (ex)->
			deferred.reject ex
		return deferred.promise

	ChromeAppFileSystem.writeFile = (quota, path, filename, data, mime)->
		deferred = $q.defer()
		path = getPath path
		fsPromise = ChromeAppFileSystem.requestFileSystem()
		fsPromise.then (fs)->
			fs.root.getFile "#{path}#{filename}.dxr", { create: true, exclusive: true }, (fileEntry)->
				fileEntry.createWriter (writer)->

					writer.onwriteend = ->
						deferred.resolve()

					writer.onerror = (ex)->
						deferred.reject ex

					writer.write new Blob([data], { type: mime })
				, (ex)->
					deferred.reject ex
			, (ex)->
				deferred.reject ex
		, (ex)->
			deferred.reject ex
		return deferred.promise

	ChromeAppFileSystem.listDirectory = (quota, path) ->
		deferred = $q.defer()

		onError = (ex) ->
			deferred.reject ex

		onRequestFileSystemSuccess = (fs) ->
			fs.root.getDirectory path, {create: false}, onGetDirectorySuccess, onError

		onGetDirectorySuccess = (examDir) ->
			reader = examDir.createReader()
			files = []

			onFinishedReading = ->
				deferred.resolve files

			readEntries = ->
				reader.readEntries (results) ->
					if !results.length
						onFinishedReading()
					else
						files = files.concat results
						readEntries()

			readEntries()

		ChromeAppFileSystem.requestFileSystem(quota).then onRequestFileSystemSuccess, onError

		return deferred.promise

	return ChromeAppFileSystem
