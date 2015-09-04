describe "Urls", ->
	Urls = null

	beforeEach ->
		module "digiexamclient"
		inject (_Urls_) -> Urls = _Urls_

	describe ".get()", ->
		it "returns the URL for the requested route with its parameters filled from data provided", ->
			Urls.routes.testRoute = "/test/:foo/route/:bar"
			result = Urls.get "testRoute", {foo: 1, bar: 2}
			expect(result).toBe("/test/1/route/2")

		it "should throw error if the route isn't found", ->
			expect( -> Urls.get("239084028")).toThrow(jasmine.any(Error))

		it "joins Array parameter values with the string ','", ->
			Urls.routes.testRoute = "/test/:foo/route"
			result = Urls.get "testRoute", {foo: [1,2]}
			expect(result).toBe("/test/1,2/route")

		it "returns the straight route if no params are provided", ->
			Urls.routes.testRoute = "/test/:foo/route"
			result = Urls.get "testRoute"
			expect(result).toBe("/test/:foo/route")

	describe ".routes", ->
		it "has only string values on its properties", ->
			for own key, value of Urls.routes
				expect(value).toBeString()

		it "all routes begin with '/'", ->
			for own key, value of Urls.routes
				expect(value[0]).toBe("/")
