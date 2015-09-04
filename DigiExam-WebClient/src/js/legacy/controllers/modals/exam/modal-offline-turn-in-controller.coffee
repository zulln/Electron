angular.module("digiexamclient").controller "ModalOfflineTurnInController", ($scope, $modalInstance, DXFileSystem, AnswerQueue, AnswerState, SessionService)->

	$scope.error = ""

	queue = new AnswerQueue $scope.exam.id, $scope.exam.userId, SessionService.user.code, SessionService.user.firstname, SessionService.user.lastname, SessionService.user.email
	$scope.getQueue = ->
		return queue

	$scope.saveFile = ->
		queue.setState AnswerState.FINAL
		for a in $scope.answers
			queue.add a

		data = JSON.stringify queue.getDXR()
		accepts = [ { extensions: ["dxr"] } ]
		promise = DXFileSystem.saveAs data, $scope.exam.id + "-" + SessionService.user.code, "text/plain", accepts
		promise.then ->
			$modalInstance.resolve()
		, (error)->
			$scope.error = error
