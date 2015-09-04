describe "ValidationService", ->
	ValidationService = null

	beforeEach module "digiexamclient.validation"

	beforeEach inject ($injector)->
		ValidationService = $injector.get "ValidationService"

	describe ".isValidEmail(email)", ->

		it "should return false if email arg isn't a string or if length is 0", ->

			email = {}
			expect(ValidationService.isValidEmail(email)).toBe(false)

			email = ""
			expect(ValidationService.isValidEmail(email)).toBe(false)

		it "should return false if email isn't valid", ->

			email = "rasmus"
			expect(ValidationService.isValidEmail(email)).toBe(false)

			email = "rasmus@mf.23)#"
			expect(ValidationService.isValidEmail(email)).toBe(false)

		it "should return true if email is valid", ->

			email = "rasmus.milesson@arcadelia.com"
			expect(ValidationService.isValidEmail(email)).toBe(true)

			email = "rasmus+milesson@arcadelia.com"
			expect(ValidationService.isValidEmail(email)).toBe(true)