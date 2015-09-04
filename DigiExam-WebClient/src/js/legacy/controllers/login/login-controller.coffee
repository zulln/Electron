angular.module("digiexamclient").controller "LoginController", ($scope, $location, $modal, DXClient, DXFileSystem, Urls, SessionService, User, DX_PLATFORM)->

	$scope.user = new User()

	$scope.showAuth = false
	$scope.isLoading = true

	if DX_PLATFORM is "CHROME_APP" and not DXClient.isKiosk
		return

	$scope.handleStorageError = (error)->
		$modal.show
			templateUrl: "partials/modals/error/storage-exception.html"
			controller: "ModalErrorStorageExceptionController"

	$scope.handleUserRestoreSuccess = (user)->
		$scope.$emit "Statusbar:SetUser", user
		$location.path Urls.get("overview")

	$scope.handleUserRestoreFail = ->
		$scope.isLoading = false
		$scope.showAuth = true

	$scope.initializeUser = ->
		promise = SessionService.restore()
		promise.then (user)->
			if !!user
				$scope.handleUserRestoreSuccess user
			else
				$scope.handleUserRestoreFail()
		, ->
			$scope.handleUserRestoreFail()

	fsQuotaPromise = DXFileSystem.requestQuota 100*1024*1024
	fsQuotaPromise.then (grantedBytes)->
		createDirPromise = DXFileSystem.makeDir grantedBytes, "", "exams"
		createDirPromise.then ->
			$scope.initializeUser()
		, (ex)->
			$scope.handleStorageError ex
	, (ex)->
		$scope.handleStorageError ex
