angular.module("digiexamclient").controller "ModalGenericConfirmController", ($scope, $modalInstance)->

	$scope.yes = ->
		$modalInstance.resolve true

	$scope.no = ->
		$modalInstance.reject()