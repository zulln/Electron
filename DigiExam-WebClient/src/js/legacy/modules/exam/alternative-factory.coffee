angular.module("digiexamclient.exam").factory "Alternative", ->
	Alternative = (data) ->
		angular.extend @,
			id: 0
			title: ""

		if data?
			if data.correct? and not data.right # SHIM TO MAKE OLD DRAFTS WORK
				data.right = data.correct
			angular.extend @, data

	return Alternative