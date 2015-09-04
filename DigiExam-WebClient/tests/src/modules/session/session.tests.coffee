describe "Session", ->
	Session = null
	User = null
	DXLocalStorage = null
	$rootScope = null
	session = null
	user = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.user"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.storage"

	beforeEach inject ($injector)->
		Session = $injector.get "Session"
		User = $injector.get "User"
		DXLocalStorage = $injector.get "DXLocalStorage"
		$rootScope = $injector.get "$rootScope"
		session = new Session()
		user = new User { firstname: "Åke", lastname: "Hök", email: "ake.hok.123@sko.la", code: "ake.hok.123" }

	describe ".setUser([user])", ->

		it "should set an active user if passed one and set it on DXLocalStorage with key 'user'", ->
			spyOn DXLocalStorage, "set"
			session.setUser user
			expect(DXLocalStorage.set).toHaveBeenCalledWith("user", user)
			expect(session.user).toEqual(user)

		it "should unset an active user if passed null or undefined", ->
			spyOn DXLocalStorage, "remove"
			session.setUser()
			expect(DXLocalStorage.remove).toHaveBeenCalledWith("user")
			expect(session.user).toBe(null)

	describe ".isAuthenticated()", ->

		it "should return true if user is set", ->
			session.setUser user
			expect(session.isAuthenticated()).toBe(true)

		it "should return false if no user is set", ->
			expect(session.isAuthenticated()).toBe(false)

	describe ".restore()", ->

		beforeEach ->
			# call setUser to add it to storage
			session.setUser user
			# remove manually to unset it from session but keep it in storage
			session.user = null

		it "should fetch a user from storage and set it as active user if found", ->
			promise = session.restore()
			promise.then ->
				expect(session.user).toBeJsonEqual(user)
			$rootScope.$apply()

		it "should return null if no user is found in storage", ->
			session.setUser()
			promise = session.restore()
			promise.then (user)->
				expect(user).toBe(null)
			$rootScope.$apply()
