describe "ToastController", ->
	$rootScope = null
	$scope = null
	$timeout = null
	createController = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$controller = $injector.get "$controller"
		$timeout = $injector.get "$timeout"
		$scope = $rootScope.$new()

		createController = ->
			return $controller "ToastController",
				$scope: $scope

	describe "initialization", ->

		it "should initialize $scope.toasts as an empty array", ->
			createController()
			expect($scope.toasts).toBeArray()
			expect($scope.toasts.length).toBe(0)

	describe "event bindings", ->

		describe "On Toast:Notification", ->

			it "should call $scope.addToast(message)", ->
				createController()

				message = "Foo Bar Baz"
				spyOn $scope, "addToast"

				$scope.$emit "Toast:Notification", message

				expect($scope.addToast).toHaveBeenCalledWith(message)

	describe ".addToast(message)", ->

		it "should add a toast to $scope.toasts and assign it an id", ->
			createController()
			$scope.addToast "Foo Bar Baz"
			expect($scope.toasts.length).toBe(1)

		it "should set a timeout on the toast and call $scope.dismissToast(tId) after 1000*10ms", ->
			createController()
			spyOn $scope, "dismissToast"

			tId = $scope.addToast "Foo Bar Baz"

			$timeout.flush 1000 * 10
			expect($scope.dismissToast).toHaveBeenCalledWith(tId)

		it "should call $scope.dismissToast(tId) if there's more toasts than maxToasts", ->
			createController()

			spyOn $scope, "dismissToast"

			tIds = []
			for i in [0..4]
				tId = $scope.addToast "test " + (i + 1)
				tIds.push tId
			expect($scope.dismissToast).not.toHaveBeenCalled()

			$scope.addToast "test 6"

			expect($scope.dismissToast).toHaveBeenCalledWith(tIds[0])

	describe ".dismissToast(tId)", ->

		it "should find the toast and remove it from $scope.toasts", ->
			createController()
			tId = $scope.addToast "Foo Bar Baz"
			$scope.dismissToast(tId)
			expect($scope.toasts.length).toBe(0)

		it "should do nothing if no toast with matching tId is found", ->
			createController()
			$scope.addToast "Foo Bar Baz"
			$scope.dismissToast(32498)
			expect($scope.toasts.length).toBe(1)