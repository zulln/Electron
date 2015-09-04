angular.module("digiexamclient").controller "DebugController", ($rootScope, $scope, DebugMessageType, DXFileSystem)->

	$scope.messages = []
	$scope.dxrFiles = []
	$scope.showMessages = false

	$rootScope.$on "Debug:Critical", (event, message)->
		$scope.messages.push { type: DebugMessageType.CRITICAL, message: message }

	$rootScope.$on "Debug:Warning", (event, message)->
		$scope.messages.push { type: DebugMessageType.WARNING, message: message }

	$rootScope.$on "Debug:Message", (event, message, type = DebugMessageType.NORMAL)->
		$scope.messages.push { type: type, message: message }

	$rootScope.$on "Debug:Show", ->
		$scope.showMessages = true

	$scope.clear = ->
		$scope.messages = []

	$scope.toggleDebugMessages = ->
		$scope.showMessages = !$scope.showMessages

	$scope.saveDXR = (fileEntry) ->
		fileEntry.file (file)->
			reader = new FileReader()

			reader.onloadend = (e)->
				accepts = [ { extensions: ["dxr"] } ]
				DXFileSystem.saveAs reader.result, fileEntry.name, "text/plain", accepts

			reader.onerror = (ex)->
				console.log ex

			reader.readAsText file

	$scope.readDXRFiles = ->
		fsQuotaPromise = DXFileSystem.requestQuota(100 * 1024 * 1024) # 100MB
		fsQuotaPromise.then (quota) ->
			DXFileSystem.listDirectory(quota, "exams").then (files) ->
				$scope.dxrFiles = files
