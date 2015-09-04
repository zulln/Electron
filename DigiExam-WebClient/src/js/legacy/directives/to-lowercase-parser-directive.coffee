angular.module("digiexamclient").directive "toLowercase", ->
	require: "ngModel"
	link: (scope, element, attrs, ngModel)->
		ngModel.$parsers.unshift (viewValue)->
			return (viewValue || "").toLowerCase()