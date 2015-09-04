describe "ModalErrorStorageExceptionController", ->
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
			controller = $controller "ModalErrorStorageExceptionController",
				$scope: $scope
				$modalInstance: $modalInstance

			return controller

	describe ".close()", ->

		it "should call DXClient.close()", ->
			spyOn DXClient, "close"
			createController()
			$scope.close()
			expect(DXClient.close).toHaveBeenCalled()
