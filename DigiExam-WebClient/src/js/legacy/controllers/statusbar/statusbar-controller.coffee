angular.module("digiexamclient").controller "StatusbarController", ($window, $rootScope, $scope, $interval, $location, $modal, DXClient, Urls, User, SessionService, DX_PLATFORM)->

	$scope.DX_PLATFORM = DX_PLATFORM
	$scope.user = new User()

	$scope.showUser = true
	$scope.hasActiveExam = false

	$scope.time = new Date()
	$interval ->
		$scope.updateClockTime()
	, 1000

	$scope.Urls = Urls

	$rootScope.$on "Statusbar:SetUser", (event, user)->
		$scope.user = user

	$rootScope.$on "Statusbar:OnExamStart", (event, examId)->
		$scope.showUser = false
		$scope.hasActiveExam = true

	$rootScope.$on "Statusbar:OnExamEnd", (event, examId)->
		$scope.showUser = true
		$scope.hasActiveExam = false

	$scope.version = $window.version

	$scope.updateClockTime = ->
		$scope.time = new Date()

	$scope.hasUser = ->
		return SessionService.isAuthenticated()

	$scope.confirmClose = ->
		if $scope.hasActiveExam
			return
		instance = $modal.show
			templateUrl: "partials/modals/system/confirm-close.html"
			controller: "ModalGenericConfirmController"
		instance.result.then ->
			DXClient.close()

	if DX_PLATFORM is "CHROME_APP" and not DXClient.isKiosk
		$scope.showUser = false
		$modal.show
			templateUrl: "partials/modals/not-secure/not-secure.html"
			controller: "ModalNotSecureController"
