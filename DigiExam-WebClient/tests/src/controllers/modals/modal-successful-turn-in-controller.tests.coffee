describe "ModalSuccessfulTurnInController", ->
	$rootScope = null
	$scope = null
	DXClient = null
	createController = null

	$modalInstance =
		resolve: ->

		reject: ->

	beforeEach module "digiexamclient"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		DXClient = $injector.get "DXClient"
		$controller = $injector.get "$controller"

		$scope = $rootScope.$new()

		createController = ->
			controller = $controller "ModalSuccessfulTurnInController",
				$scope: $scope
				$modalInstance: $modalInstance

			return controller

	describe ".close()", ->

		it "should call DXClient.close()", ->
			spyOn DXClient, "close"
			createController()
			$scope.close()
			expect(DXClient.close).toHaveBeenCalled()
