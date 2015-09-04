describe "User", ->
	User = null
	user = null
	userData =
		firstname: "Åke"
		lastname: "Hök"
		email: "ake.hok.123@sko.la"
		code: "ake.hok.123"

	gravatarBaseUrl = "https://www.gravatar.com/avatar/%h?s=64&d=mm"
	blobStoreBaseUrl = "blob/get/%h"

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.user"

	beforeEach inject ($injector)->
		User = $injector.get "User"
		user = new User userData

	describe ".name()", ->

		it "should return firstname and lastname separated by a ' '", ->
			expect(user.name()).toEqual userData.firstname + " " + userData.lastname

	describe ".isValidFirstname()", ->

		it "should return true if firstname.length > 0, else false", ->
			expect(user.isValidFirstname()).toBe(true)
			user.firstname = ""
			expect(user.isValidFirstname()).toBe(false)

	describe ".isValidLastname()", ->

		it "should return true if lastname.length > 0, else false", ->
			expect(user.isValidLastname()).toBe(true)
			user.lastname = ""
			expect(user.isValidLastname()).toBe(false)

	describe ".isValidCode()", ->

		it "should return ture if code.length > 0, else false", ->
			expect(user.isValidCode()).toBe(true)
			user.code = ""
			expect(user.isValidCode()).toBe(false)

	describe ".isValidEmail()", ->

		it "should return true if email is valid, else false", ->
			expect(user.isValidEmail()).toBe(true)
			user.email = "foo@bar"
			expect(user.isValidEmail()).toBe(false)
			user.email = ""
			expect(user.isValidEmail()).toBe(false)
			user.email = "foo+baz@bar.com"
			expect(user.isValidEmail()).toBe(true)

	describe ".getProfileImage()", ->

		it "should return blobstore path if user.image is set", ->
			image = "wfhow82f82"
			user.image = image
			expect(user.getProfileImage()).toEqual(blobStoreBaseUrl.replace("%h", image))

		it "should return gravatar path if user.image is not set", ->
			expect(user.getProfileImage()).toEqual(gravatarBaseUrl.replace("%h", md5(user.email.toLowerCase())))

		it "should return null if neither email-address or .image is set", ->
			user.image = ""
			user.email = ""
			expect(user.getProfileImage()).toBe(null)
