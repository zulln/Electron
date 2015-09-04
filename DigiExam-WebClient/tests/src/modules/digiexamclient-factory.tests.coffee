describe "DXClient", ->
	$window = null
	$location = null
	DXClient = null

	beforeEach module "digiexamclient"

	afterEach ->
		delete $window.chrome
		delete $window.isKiosk

	describe ".isKiosk", ->

		it "should be true if $window.isKiosk is true", inject ($injector)->
			$window = $injector.get "$window"
			$window.isKiosk = true
			DXClient = $injector.get "DXClient"
			expect(DXClient.isKiosk).toBe(true)

		it "should be false if $window.isKiosk is false", inject ($injector)->
			$window = $injector.get "$window"
			$window.isKiosk = false
			DXClient = $injector.get "DXClient"
			expect(DXClient.isKiosk).toBe(false)

	describe "DX_PLATFORM is \"BROWSER\"", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "BROWSER"

		describe ".close", ->

			it "should set redirect to \"/\"", inject ($injector) ->
				DXClient = $injector.get "DXClient"
				$location = $injector.get "$location"

				spyOn($location, "path");
				DXClient.close()
				expect($location.path).toHaveBeenCalledWith "/"


	describe "DX_PLATFORM is \"CHROME_APP\"", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "CHROME_APP"

		describe ".close", ->

			it "should call $window.chrome.app.window.current().close()", inject ($injector) ->
				mockWindow =
					close: ->
				DXClient = $injector.get "DXClient"
				$window = $injector.get "$window"
				$window.chrome = { app: { window: { current: angular.noop } } }
				spyOn($window.chrome.app.window, "current").and.returnValue(mockWindow)
				spyOn mockWindow, "close"

				DXClient.close()
				expect(mockWindow.close).toHaveBeenCalled()

	describe "DX_PLATFORM is neither \"BROWSER\" nor \"CHROME_APP\"", ->

		beforeEach module ($provide) ->
			$provide.constant "DX_PLATFORM", "UNKNOWN"

		describe ".close", ->

			it "should call angular.noop()", inject ($injector) ->
				DXClient = $injector.get "DXClient"
				spyOn(angular, "noop").and.returnValue("foo")
				expect(DXClient.close()).toEqual("foo")
