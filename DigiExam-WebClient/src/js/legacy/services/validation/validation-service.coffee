angular.module("digiexamclient.validation", []).service "ValidationService", ->
	isValidEmail: (email)->
		if typeof email isnt "string" or email.length is 0
			return false
		emailExpression = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
		return emailExpression.test email