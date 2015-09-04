angular.module("digiexamclient").controller "ModalErrorStorageExceptionController", ($scope, $modalInstance, DXClient)->

	$scope.close = ->
		DXClient.close()
