beforeEach ->
	angular.module "digiexamclient.storage.filesystem", []
		.factory "DXFileSystem", ($q)->
			DXFileSystem = {}

			DXFileSystem.openFile = (accepts)->
				return $q.defer().promise

			DXFileSystem.saveAs = (data, name, mime, accepts)->
				return $q.defer().promise

			DXFileSystem.requestQuota = (bytes)->
				return $q.defer().promise

			DXFileSystem.requestFileSystem = (quota)->
				return $q.defer().promise

			DXFileSystem.makeDir = (quota, path, name)->
				return $q.defer().promise

			DXFileSystem.readFile = (quota, path, name)->
				return $q.defer().promise

			DXFileSystem.writeFile = (quota, path, filename, data, mime)->
				return $q.defer().promise

			DXFileSystem.listDirectory = (quota, path)->
				return $q.defer().promise

			return DXFileSystem
