angular.module("digiexamclient").controller "ModalNotSecureController", ($scope, $modalInstance, DXClient)->
	$scope.showDebug = ->
		$scope.$emit "Debug:Show"

	$scope.exit = ->
		DXClient.close()
