describe "StatusbarController on platform", ->
	$modal = null
	$controller = null
	$scope = null
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
			DXClient = $injector.get "DXClient"
			createController = ->
					return $controller "StatusbarController",
						$scope: $scope

		describe "initialization", ->
			it "should show not-secure modal if DXClient.isKiosk is false", inject ($injector) ->
				DXClient.isKiosk = false
				spyOn $modal, "show"

				createController()

				modalArgs =
					templateUrl: "partials/modals/not-secure/not-secure.html"
					controller: "ModalNotSecureController"
				expect($modal.show).toHaveBeenCalledWith(modalArgs)

			it "should not show not-secure modal if DXClient.isKiosk is true", inject ($injector) ->
				DXClient.isKiosk = true
				spyOn $modal, "show"
				createController()
				expect($modal.show).not.toHaveBeenCalled()

	describe "IOS_WEBVIEW", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "IOS_WEBVIEW"

		beforeEach inject ($injector) ->
			$controller = $injector.get "$controller"
			$modal = $injector.get "$modal"
			$rootScope = $injector.get "$rootScope"
			$scope = $rootScope.$new()
			DXClient = $injector.get "DXClient"
			createController = ->
					return $controller "StatusbarController",
						$scope: $scope

		describe "initialization", ->
			it "should show not-secure modal when DXClient is true", inject ($injector) ->
				DXClient.isKiosk = true
				spyOn $modal, "show"
				createController()
				expect($modal.show).not.toHaveBeenCalled()

			it "should show not-secure modal when DXClient is false", inject ($injector) ->
				DXClient.isKiosk = false
				spyOn $modal, "show"
				createController()
				expect($modal.show).not.toHaveBeenCalled()

describe "StatusbarController", ->
	$rootScope = null
	$window = null
	$location = null
	$scope = null
	$interval = null
	$modal = null
	$q = null
	$httpBackend = null
	DXClient = null
	Urls = null
	SessionService = null
	User = null
	createController = null

	version = "0.1.0"

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$window = $injector.get "$window"
		$location = $injector.get "$location"
		$controller = $injector.get "$controller"
		$interval = $injector.get "$interval"
		$modal = $injector.get "$modal"
		$q = $injector.get "$q"
		$httpBackend = $injector.get "$httpBackend"
		DXClient = $injector.get "DXClient"
		Urls = $injector.get "Urls"
		SessionService = $injector.get "SessionService"
		User = $injector.get "User"
		$scope = $rootScope.$new()

		$window.version = version

		createController = ->
			return $controller "StatusbarController",
				$scope: $scope

	beforeEach ->
		DXClient.isKiosk = true

	describe "initialization", ->
		it "should set $window.version to $scope.version", ->
			createController()
			expect($scope.version).toEqual($window.version)

	describe "event bindings", ->
		it "should call $scope.updateClockTime() on a 1000ms interval", ->
			createController()

			spyOn $scope, "updateClockTime"

			$interval.flush(1000)

			$interval.flush(1000)

			expect($scope.updateClockTime).toHaveBeenCalled()
			expect($scope.updateClockTime.calls.count()).toEqual(2)

	describe ".updateClockTime()", ->

		it "should set a new instance of Date on $scope.time", ->
			createController()

			$scope.time = null

			$scope.updateClockTime()

			time = new Date()
			expect($scope.time).toEqual(time)

	describe ".hasUser()", ->

		it "should return SessionService.isAuthenticated()", ->
			controller = createController()
			# We can assume no user has been added to the session at this stage
			expect($scope.hasUser()).toBe(false)

			user = new User { firstname: "Åke", lastname: "Hök", email: "ake.hok.123@sko.la", code: "ake.hok.123" }

			SessionService.setUser user

			expect($scope.hasUser()).toBe(true)

	describe ".confirmClose()", ->

		it "should return undefined without calling $modal.show when $scope.hasActiveExam is true", ->
			controller = createController()

			spyOn $modal, "show"
			$scope.hasActiveExam = true

			expect($scope.confirmClose()).toBe(undefined)
			expect($modal.show).not.toHaveBeenCalled()

		it "should call $modal.show", ->
			createController()
			spyOn($modal, "show").and.returnValue({ result: then: -> })

			$scope.confirmClose()

			modalArgs =
				templateUrl: "partials/modals/system/confirm-close.html"
				controller: "ModalGenericConfirmController"

			expect($modal.show).toHaveBeenCalledWith(modalArgs)

		it "should call DXClient.close when modalInstance.result is resolved", ->
			createController()
			deferred = $q.defer()
			spyOn($modal, "show").and.returnValue({ result: deferred.promise })
			spyOn DXClient, "close"

			$scope.confirmClose()
			deferred.resolve()
			$rootScope.$apply()

			expect(DXClient.close).toHaveBeenCalled()

	describe "event bindings", ->

		describe "On Statusbar:SetUser", ->

			it "should set the statusbar user", ->
				controller = createController()
				user = new User { firstname: "Pål", lastname: "Päron", email: "pal.paron.456@sko.la", code: "pal.paron.456" }
				$scope.$emit "Statusbar:SetUser", user
				expect($scope.user).toBeJsonEqual(user)

		describe "On Statusbar:OnExamStart", ->

			it "should set $scope.hasActiveExam to true", ->
				controller = createController()
				expect($scope.hasActiveExam).toBe(false)
				$scope.$emit "Statusbar:OnExamStart"
				expect($scope.hasActiveExam).toBe(true)

		describe "On Statusbar:OnExamEnd", ->

			it "should set $scope.hasActiveExam to false", ->
				controller = createController()
				$scope.hasActiveExam = true
				$scope.$emit "Statusbar:OnExamEnd"
				expect($scope.hasActiveExam).toBe(false)
