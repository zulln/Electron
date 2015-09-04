angular.module("digiexamclient").directive "email", (ValidationService)->
	require: "ngModel"
	link: (scope, element, attrs, ngModel)->
		ngModel.$parsers.unshift (viewValue)->
			if ValidationService.isValidEmail(viewValue)
				ngModel.$setValidity "email", true
				return viewValue
			else
				ngModel.$setValidity "email", false
				return viewValue