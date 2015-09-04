angular.module("digiexamclient").directive "ngEnter", ($parse)->
	restrict: "A"
	link: (scope, element, attrs)->
		fn = $parse attrs.ngEnter
		element.on "keydown keypress", (event)->
			if event.which is 13
				scope.$apply ->
					(fn || angular.noop)(scope, { $event: event })
				event.preventDefault()