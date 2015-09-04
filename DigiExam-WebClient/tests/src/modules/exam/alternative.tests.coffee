describe "Alternative", ->
	Alternative = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.exam"

	beforeEach inject ($injector)->
		Alternative = $injector.get "Alternative"

	describe "initialization", ->

		# Crappy crap test just because Istanbul says I need to do this to get 100% coverage
		it "should not do anything but pass along an empty alternative if initialized with no data", ->
			alt = new Alternative()
			expect(alt.title).toEqual("")

		it "should correctly shim .corrent-property", ->
			alt = new Alternative { id: 0, title: "Foo", correct: true }
			expect(alt.right).toBe(true)