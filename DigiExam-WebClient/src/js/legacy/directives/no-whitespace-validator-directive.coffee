angular.module("digiexamclient").directive "noWhitespace", ->
	require: "ngModel"
	link: (scope, element, attrs, ngModel)->
		ngModel.$parsers.unshift (viewValue)->
			if /\s+/.test(viewValue) is false
				ngModel.$setValidity "noWhitespace", true
				return viewValue
			else
				ngModel.$setValidity "noWhitespace", false
				return viewValue