angular.module("digiexamclient").directive "noPaste", ->
	link: (scope, element, attrs)->
		element.on "paste", (e)->
			e.preventDefault()