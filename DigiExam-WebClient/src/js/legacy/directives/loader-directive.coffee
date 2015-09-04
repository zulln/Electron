angular.module("digiexamclient").directive "loader", ->
	return {
		restrict: "E"
		template: "@@include(inlineTemplate('partials/directives/loader.html'))"
		transclude: true
		replace: true
	}
