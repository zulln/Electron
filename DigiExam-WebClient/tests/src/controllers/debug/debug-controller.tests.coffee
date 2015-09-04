describe "DebugController", ->
	$rootScope = null
	$scope = null
	$q = null
	DebugMessageType = null

	createController = null

	DXFileSystem = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"

	beforeEach inject ($injector)->
		$q = $injector.get "$q"
		$rootScope = $injector.get "$rootScope"
		$controller = $injector.get "$controller"
		DebugMessageType = $injector.get "DebugMessageType"
		DXFileSystem = $injector.get "DXFileSystem"
		$scope = $rootScope.$new()

		createController = ->
			return $controller "DebugController",
				$scope: $scope

	describe "initialization", ->

		it "should set $scope.messages to empty array", ->
			createController()
			expect($scope.messages).toBeArray()
			expect($scope.messages.length).toBe(0)

		it "should set $scope.showMessages to false", ->
			createController()
			expect($scope.showMessages).toBe(false)

	describe "events", ->

		describe "Debug:Critical", ->

			it "should add a message to $scope.messages with DebugMessageType.CRITICAL", ->
				createController()
				$rootScope.$broadcast "Debug:Critical", "foobarbaz"
				expect($scope.messages[0].message).toEqual("foobarbaz")
				expect($scope.messages[0].type).toBe(DebugMessageType.CRITICAL)

		describe "Debug:Warning", ->

			it "should add a message to $scope.messages with DebugMessageType.WARNING", ->
				createController()
				$rootScope.$broadcast "Debug:Warning", "foobarbaz"
				expect($scope.messages[0].message).toEqual("foobarbaz")
				expect($scope.messages[0].type).toBe(DebugMessageType.WARNING)

		describe "Debug:Message", ->

			it "should add a message to $scope.messages with DebugMessageType.NORMAL", ->
				createController()
				$rootScope.$broadcast "Debug:Message", "foobarbaz"
				expect($scope.messages[0].message).toEqual("foobarbaz")
				expect($scope.messages[0].type).toBe(DebugMessageType.NORMAL)

			it "should add a message to $scope.messages with a chosen DebugMessageType", ->
				createController()
				$rootScope.$broadcast "Debug:Message", "foobarbaz", DebugMessageType.CRITICAL
				expect($scope.messages[0].message).toEqual("foobarbaz")
				expect($scope.messages[0].type).toBe(DebugMessageType.CRITICAL)

		describe "Debug:Show", ->

			it "should set $scope.showMessages to true", ->
				createController()
				$rootScope.$broadcast "Debug:Show"
				expect($scope.showMessages).toBe(true)

	describe ".clear()", ->

		it "should set $scope.messages to an empty array", ->
			createController()
			$rootScope.$broadcast "Debug:Critical", "foobarbaz"
			$scope.clear()
			expect($scope.messages).toBeArray()
			expect($scope.messages.length).toBe(0)

	describe ".toggleDebugMessages()", ->

		it "should toggle $scope.showMessages", ->
			createController()
			$scope.toggleDebugMessages()
			expect($scope.showMessages).toBe(true)
			$scope.toggleDebugMessages()
			expect($scope.showMessages).toBe(false)

	describe "readDXRFiles", ->
		it "set the found dxr files on the scope", ->
			createController()

			requestQuotaDeferred = $q.defer()
			requestQuotaSpy = spyOn(DXFileSystem, "requestQuota").and.returnValue(requestQuotaDeferred.promise)
			listDirectoryDeferred = $q.defer()
			listDirectorySpy = spyOn(DXFileSystem, "listDirectory").and.returnValue(listDirectoryDeferred.promise)

			$scope.readDXRFiles()

			requestQuotaDeferred.resolve()

			files = ["myfile"]
			listDirectoryDeferred.resolve files
			$scope.$digest()

			expect($scope.dxrFiles).toBe files
