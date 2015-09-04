angular.module("digiexamclient").controller "ToastController", ($rootScope, $scope, $timeout)->

	uniqueId = ->
		return Math.floor Math.random() * 10000

	maxToasts = 5
	$scope.toasts = []

	$rootScope.$on "Toast:Notification", (event, message)->
		$scope.addToast message

	$scope.addToast = (message)->
		t =
			id: uniqueId()
			message: message

		$timeout ->
			$scope.dismissToast t.id
		, 1000 * 10

		$scope.toasts.push t

		if $scope.toasts.length > maxToasts
			$scope.dismissToast $scope.toasts[0].id

		return t.id

	$scope.dismissToast = (tId)->
		for t, i in $scope.toasts
			if t.id is tId
				$scope.toasts.splice i, 1
				break