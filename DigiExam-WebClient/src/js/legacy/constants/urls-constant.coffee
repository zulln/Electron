angular.module("digiexamclient").constant "Urls",
	# .get
	#
	# Returns the URL for a route with its parameters filled in.
	#
	# route = String with name of route to use
	# parameters = {id: 123, course: 456}
	#
	# If a parameter value is an Array it will be joined using .join(",")
	#
	# Example: Urls.get "classView", {id: classId}
	get: (route, parameters = {}) ->
		url = @.routes[route]
		if typeof url != "string"
			throw Error "[Urls] Route does not exist: " + route
		for key, value of parameters
			if value instanceof Array
				value = value.join ","
			url = url.replace ":" + key, value
		return url

	routes:
		# Main stuff
		login: "/"

		# Overview
		overview: "/overview"

		# User
		userEdit: "/user/edit"

		# Exam
		exam: "/exam/:id/:startOffline"