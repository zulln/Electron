angular.module("digiexamclient.session").factory "Session", ($rootScope, User, DXLocalStorage)->
	Session = (data) ->

		angular.extend @, {
			# Session properties
			user: null

			setUser: (user)->
				if user?
					@user = user
					DXLocalStorage.set "user", user
				else
					@user = null
					DXLocalStorage.remove "user"
				$rootScope.$broadcast "Session:User", @user

			isAuthenticated: ->
				return @.user != null

			restore: ->
				_self = @
				promise = DXLocalStorage.get "user"
				promise.then (data)->
					user = new User data.user
					if !user.isValid()
						return null
					_self.user = user
					return user
		}

	return Session
