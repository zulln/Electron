describe "loader directive", ->
	$compile = null
	$rootScope = null
	$scope = null
	$httpBackend = null
	compileDirective = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.templates"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$compile = $injector.get "$compile"
		$httpBackend = $injector.get "$httpBackend"

		compileDirective = (transclude)->
			template = "<loader>" + transclude + "</loader>"
			$scope = $rootScope.$new()
			directive = $compile(template)($scope)
			$scope.$digest()
			return directive

	it "should be compiled to the correct DOM and take into account the ng-transclude", ->
		directive = compileDirective("<p>Laddar</p>")
		expect(directive.find("p").text()).toEqual("Laddar")
		expect(directive.find("svg").length).toBeGreaterThan(0)
