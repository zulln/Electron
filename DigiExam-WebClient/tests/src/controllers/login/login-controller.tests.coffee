describe "LoginController on platform", ->
	DXFileSystem = null
	DXClient = null
	createController = null

	beforeEach module "digiexamclient"

	describe "CHROME_APP", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "CHROME_APP"

		beforeEach inject ($injector) ->
			$controller = $injector.get "$controller"
			$modal = $injector.get "$modal"
			$rootScope = $injector.get "$rootScope"
			$scope = $rootScope.$new()
			DXFileSystem = $injector.get "DXFileSystem"
			DXClient = $injector.get "DXClient"
			createController = ->
					return $controller "LoginController",
						$scope: $scope

		describe "initialization", ->

			it "should not initialize if DXClient.isKiosk is false", ->
				spyOn DXFileSystem, "requestQuota"
				DXClient.isKiosk = false

				createController()

				expect(DXFileSystem.requestQuota).not.toHaveBeenCalled()

	describe "BROWSER", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "BROWSER"

		beforeEach inject ($injector) ->
			$controller = $injector.get "$controller"
			$modal = $injector.get "$modal"
			$rootScope = $injector.get "$rootScope"
			$scope = $rootScope.$new()
			DXFileSystem = $injector.get "DXFileSystem"
			DXClient = $injector.get "DXClient"
			createController = ->
					return $controller "LoginController",
						$scope: $scope

		describe "initialization", ->

			it "should initialize if DXClient.isKiosk is false", ->
				spyOn(DXFileSystem, "requestQuota").and.callThrough()
				DXClient.isKiosk = false

				createController()

				expect(DXFileSystem.requestQuota).toHaveBeenCalled()

describe "LoginController", ->
	$rootScope = null
	$window = null
	$location = null
	$scope = null
	$interval = null
	$q = null
	$modal = null
	DXFileSystem = null
	DXClient = null
	Urls = null
	SessionService = null
	User = null
	createController = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$window = $injector.get "$window"
		$location = $injector.get "$location"
		$controller = $injector.get "$controller"
		$interval = $injector.get "$interval"
		$q = $injector.get "$q"
		$modal = $injector.get "$modal"
		DXFileSystem = $injector.get "DXFileSystem"
		DXClient = $injector.get "DXClient"
		Urls = $injector.get "Urls"
		SessionService = $injector.get "SessionService"
		User = $injector.get "User"
		$scope = $rootScope.$new()

		DXClient.isKiosk = true

		createController = ->
			return $controller "LoginController",
				$scope: $scope

	describe "initialization", ->

		it "should call DXFileSystem.requestQuota and request 100mb storage space", ->
			spyOn(DXFileSystem, "requestQuota").and.callThrough()
			createController()
			expect(DXFileSystem.requestQuota).toHaveBeenCalledWith(100*1024*1024)

		it "should call $scope.handleStorageError with exception if failing in requesting a quota", ->
			deferred = $q.defer()
			error = new Error("foo")

			spyOn(DXFileSystem, "requestQuota").and.returnValue(deferred.promise)
			createController()
			spyOn $scope, "handleStorageError"

			$rootScope.$apply ->
				deferred.reject(error)
			expect($scope.handleStorageError).toHaveBeenCalledWith(error)

		it "should call DXFileSystem.makeDir to create a folder called 'exam/'", ->
			quotaDeferred = $q.defer()
			bytes = 100*1024*1024

			spyOn(DXFileSystem, "requestQuota").and.returnValue(quotaDeferred.promise)
			spyOn(DXFileSystem, "makeDir").and.callThrough()
			createController()

			$rootScope.$apply ->
				quotaDeferred.resolve(bytes)
			expect(DXFileSystem.makeDir).toHaveBeenCalledWith(bytes, "", "exams")

		it "should call $scope.handleStorageError with exception if failing to create a directory", ->
			quotaDeferred = $q.defer()
			dirDeferred = $q.defer()
			error = new Error("foo")

			spyOn(DXFileSystem, "requestQuota").and.returnValue(quotaDeferred.promise)
			spyOn(DXFileSystem, "makeDir").and.returnValue(dirDeferred.promise)

			createController()

			spyOn $scope, "handleStorageError"

			$rootScope.$apply ->
				quotaDeferred.resolve()
				dirDeferred.reject error

			expect($scope.handleStorageError).toHaveBeenCalledWith(error)

		it "should call $scope.initializeUser()", ->
			quotaDeferred = $q.defer()
			dirDeferred = $q.defer()
			error = new Error("foo")

			spyOn(DXFileSystem, "requestQuota").and.returnValue(quotaDeferred.promise)
			spyOn(DXFileSystem, "makeDir").and.returnValue(dirDeferred.promise)

			createController()

			spyOn $scope, "initializeUser"

			$rootScope.$apply ->
				quotaDeferred.resolve()
				dirDeferred.resolve()

			expect($scope.initializeUser).toHaveBeenCalled()

	describe "events", ->

		describe "Session:User", ->

			it "should return and not do anything if no user is supplied", ->
				createController()

				spyOn $scope, "$emit"
				spyOn $location, "path"

				$rootScope.$broadcast "Session:User", null

				expect($scope.$emit).not.toHaveBeenCalled()
				expect($location.path).not.toHaveBeenCalled()

			it "should call $scope.handleUserRestoreSuccess(user)", ->
				createController()

				user = new User()

				spyOn $scope, "handleUserRestoreSuccess"

				$rootScope.$broadcast "Session:User", user

				expect($scope.handleUserRestoreSuccess).toHaveBeenCalledWith(user)

	describe ".handleStorageError(error)", ->

		it "should show a modal", ->
			spyOn $modal, "show"
			modalArgs =
				templateUrl: "partials/modals/error/storage-exception.html"
				controller: "ModalErrorStorageExceptionController"
			error = new Error("foo")

			createController()

			$scope.handleStorageError(error)

			expect($modal.show).toHaveBeenCalledWith(modalArgs)

	describe ".initializeUser()", ->

		it "should call SessionService.restore()", ->
			spyOn(SessionService, "restore").and.returnValue($q.defer().promise)

			createController()

			$scope.initializeUser()

			expect(SessionService.restore).toHaveBeenCalled()

		it "should call $scope.handleUserRestoreSuccess() if restore returns a user", ->
			deferred = $q.defer()
			user = new User()
			spyOn(SessionService, "restore").and.returnValue(deferred.promise)

			createController()

			spyOn $scope, "handleUserRestoreSuccess"

			$scope.initializeUser()

			$rootScope.$apply ->
				deferred.resolve user

			expect($scope.handleUserRestoreSuccess).toHaveBeenCalledWith(user)

		it "should call $scope.handleUserRestoreFail() if restore is rejected", ->
			deferred = $q.defer()
			spyOn(SessionService, "restore").and.returnValue(deferred.promise)

			createController()

			spyOn $scope, "handleUserRestoreFail"

			$scope.initializeUser()

			$rootScope.$apply ->
				deferred.reject()

			expect($scope.handleUserRestoreFail).toHaveBeenCalled()

		it "should call $scope.handleUserRestoreFail() if restore is resolved without a user", ->
			deferred = $q.defer()
			spyOn(SessionService, "restore").and.returnValue(deferred.promise)

			createController()

			spyOn $scope, "handleUserRestoreFail"

			$scope.initializeUser()

			$rootScope.$apply ->
				deferred.resolve(false)

			expect($scope.handleUserRestoreFail).toHaveBeenCalled()

	describe ".handleUserRestoreSuccess(user)", ->

		it "should emit Statusbar:SetUser and redirect to overview", ->
			createController()

			user = new User()

			spyOn $scope, "$emit"
			spyOn $location, "path"

			$scope.handleUserRestoreSuccess user

			expect($scope.$emit).toHaveBeenCalledWith("Statusbar:SetUser", user)
			expect($location.path).toHaveBeenCalledWith(Urls.get("overview"))

	describe ".handleUserRestoreFail()", ->

		it "should set $scope.isLoading to false and $scope.showAuth to true", ->
			createController()

			$scope.handleUserRestoreFail()

			expect($scope.isLoading).toBe(false)
			expect($scope.showAuth).toBe(true)
