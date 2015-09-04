angular.module("digiexamclient.user").factory "User", (ValidationService)->
	gravatarBaseUrl = "https://www.gravatar.com/avatar/%h?s=64&d=mm"
	blobStoreBaseUrl = "blob/get/%h"

	User = (data) ->
		angular.extend @, {
			# User properties
			email: ""
			firstname: ""
			lastname: ""
			code: ""
			image: ""

			# Helper methods
			name: ->
				return @.firstname + " " + @.lastname

			isValidFirstname: ->
				return @.firstname.length > 0

			isValidLastname: ->
				return @.lastname.length > 0

			isValidCode: ->
				return @.code.length > 0

			isValidEmail: ->
				return ValidationService.isValidEmail @.email

			isValid: ->
				return @.isValidEmail() and @.isValidFirstname() and @.isValidLastname() and @.isValidCode()

			getProfileImage: ->
				base = gravatarBaseUrl
				if @.image? and @.image.length > 0
					base = blobStoreBaseUrl
					h = @.image
				else if @.email.length > 0 and @.email[0].length > 0
					h = md5 @.email.toLowerCase()
				else
					return null
				return base.replace "%h", h
		}

		if data?
			angular.extend @, data
		return

	return User