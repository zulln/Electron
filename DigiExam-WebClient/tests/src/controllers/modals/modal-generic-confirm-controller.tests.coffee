describe "ModalGenericConfirmController", ->
	$rootScope = null
	$scope = null
	createController = null

	$modalInstance =
		resolve: ->

		reject: ->

	beforeEach module "digiexamclient"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$controller = $injector.get "$controller"

		$scope = $rootScope.$new()

		createController = ->
			controller = $controller "ModalGenericConfirmController",
				$scope: $scope
				$modalInstance: $modalInstance

			return controller

	describe ".yes()", ->

		it "should call $modalInstance.resolve(true)", ->
			createController()
			spyOn $modalInstance, "resolve"

			$scope.yes()

			expect($modalInstance.resolve).toHaveBeenCalledWith(true)

	describe ".no()", ->

		it "should call $modalInstance.reject()", ->
			createController()
			spyOn $modalInstance, "reject"

			$scope.no()

			expect($modalInstance.reject).toHaveBeenCalled()