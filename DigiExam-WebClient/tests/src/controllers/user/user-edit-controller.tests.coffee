describe "UserEditController", ->
	$rootScope = null
	$window = null
	$location = null
	$scope = null
	$interval = null
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
		Urls = $injector.get "Urls"
		SessionService = $injector.get "SessionService"
		User = $injector.get "User"
		$scope = $rootScope.$new()

		SessionService.user = new User { firstname: "Åke", lastname: "Hök", email: "ake.hok.123@sko.la", code: "ake.hok.123" }

		createController = ->
			return $controller "UserEditController",
				$scope: $scope

	describe "initialization", ->

		it "create a copy of SessionService.user and assign it to $scope.user", ->
			spyOn(angular, "copy").and.callThrough()

			createController()
			expect(angular.copy).toHaveBeenCalledWith(SessionService.user)
			expect($scope.user).toBeJsonEqual(SessionService.user)

	describe "events", ->

		it "should emit 'Statusbar:SetUser' and redirect if event is passed a user as argument", ->
			createController()

			spyOn $scope, "$emit"
			spyOn $location, "path"

			$rootScope.$broadcast "Session:User", SessionService.user

			expect($scope.$emit).toHaveBeenCalledWith("Statusbar:SetUser", SessionService.user)
			expect($location.path).toHaveBeenCalledWith(Urls.get("overview"))

		it "should do nothing if no user is provided", ->
			createController()

			spyOn $scope, "$emit"
			spyOn $location, "path"

			$rootScope.$broadcast "Session:User", null

			expect($scope.$emit).not.toHaveBeenCalledWith("Statusbar:SetUser", SessionService.user)
			expect($location.path).not.toHaveBeenCalledWith(Urls.get("overview"))
