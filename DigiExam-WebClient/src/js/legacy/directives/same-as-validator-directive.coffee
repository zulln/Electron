angular.module("digiexamclient").directive "sameAs", ($parse)->
	require: "ngModel"
	link: (scope, element, attrs, ngModel)->
		ngModel.$parsers.unshift (viewValue)->
			match = $parse(attrs.sameAs)(scope)
			if viewValue is match
				ngModel.$setValidity "sameAs", true
				return viewValue
			else
				ngModel.$setValidity "sameAs", false
				return viewValue