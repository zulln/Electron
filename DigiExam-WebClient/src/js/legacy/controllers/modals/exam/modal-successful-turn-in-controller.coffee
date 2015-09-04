angular.module("digiexamclient").controller "ModalSuccessfulTurnInController", ($scope, $modalInstance, DXClient, DX_PLATFORM)->

	$scope.DX_PLATFORM = DX_PLATFORM

	$scope.close = ->
		DXClient.close($modalInstance)
