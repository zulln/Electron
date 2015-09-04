angular.module("digiexamclient").directive "userDetails", ->
	restrict: "E"
	template: "@@include(inlineTemplate('partials/directives/user-details.html'))",
	scope:
		user: "="
	controller: ($scope, $location, SessionService, Urls, $timeout)->
		$scope.confirmEmail = if $scope.user.email.length > 0 then $scope.user.email else ""

		$scope.$watch "user.email", (n, o)->
			if n is o
				return
			$scope.confirmEmail = ""

		$scope.save = ->
			SessionService.setUser $scope.user
			$scope.$emit "Statusbar:SetUser", $scope.user

			# Normal angular routing does not work here on iPad for some reason
			# This is a work around that uses the app startup cycle to get to the overview
			# todo(andersson): optimize, fml
			setTimeout ->
				location.href = "/"
			, 250
