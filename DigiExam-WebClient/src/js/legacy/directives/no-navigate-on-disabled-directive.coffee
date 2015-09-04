angular.module("digiexamclient").directive "noNavigateOnDisabled", ->
	restrict: "A"
	link: (scope, element, attr)->
		element.on "click", (event)->
			if element.attr("disabled") and element.attr("disabled") isnt "false" and element.attr("disabled") isnt false
				event.preventDefault()