describe "ModalNotSecureController", ->
	$rootScope = null
	$scope = null
	createController = null
	DXClient = null

	$modalInstance =
		resolve: ->

		reject: ->

	beforeEach module "digiexamclient"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$controller = $injector.get "$controller"
		DXClient = $injector.get "DXClient"

		$scope = $rootScope.$new()

		createController = ->
			controller = $controller "ModalNotSecureController",
				$scope: $scope
				$modalInstance: $modalInstance

			return controller

	describe ".showDebug()", ->

		it "should call $scope.$emit with 'Debug:Show'", ->
			createController()
			spyOn $scope, "$emit"
			$scope.showDebug()
			expect($scope.$emit).toHaveBeenCalledWith("Debug:Show")

	describe ".exit()", ->

		it "should call DXClient.close()", ->
			createController()
			spyOn DXClient, "close"

			$scope.exit()

			expect(DXClient.close).toHaveBeenCalled()
