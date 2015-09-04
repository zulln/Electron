describe "dxImageList", ->
	$compile = null
	$rootScope = null
	$scope = null
	Question = null
	Answer = null
	compileDirective = null

	base64Images = ["iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAABGdBTUEAALGOfPtRkwAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAdTAAAOpgAAA6mAAAF2+SX8VGAAABLElEQVR42qSTQStFURSFP7f3XygyoAwoYSYMPCIpk2egMFSmUvwCRpSRDIwYGbwyVuYykB9y914m951z7nHe6J26dc9u77XXWmdvJLF7/audqx9JYuvyW92LL0li8K2df2r17CPEVk7ftXTclyQqAMmRCwC5I3fS42a4W7y74VYDNAAuJA8AaXIsSACsDgAdAJeFrnnyoMBygKZJJ3b1It0AmsTMDPdEgrujJqHEwCxqznMaD2KgyCDRnEuo8qJhHvx/hcQDbzGoix5Yi4G1TcwZWNEDKwJU+WDkhg2ToDaD+M65YcVB8jg3Y5IY5VQAyyf9gLJw+CqAuYNnAczsPQpgevtBU937kDexcdssj8Ti0ZskMd97CRs3u//U2sjJzbtwH1+/Cf8jS/gbAMmWc42HzdIjAAAAAElFTkSuQmCC", "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAABGdBTUEAALGOfPtRkwAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAdTAAAOpgAAA6mAAAF2+SX8VGAAABLElEQVR42qSTQStFURSFP7f3XygyoAwoYSYMPCIpk2egMFSmUvwCRpSRDIwYGbwyVuYykB9y914m951z7nHe6J26dc9u77XXWmdvJLF7/audqx9JYuvyW92LL0li8K2df2r17CPEVk7ftXTclyQqAMmRCwC5I3fS42a4W7y74VYDNAAuJA8AaXIsSACsDgAdAJeFrnnyoMBygKZJJ3b1It0AmsTMDPdEgrujJqHEwCxqznMaD2KgyCDRnEuo8qJhHvx/hcQDbzGoix5Yi4G1TcwZWNEDKwJU+WDkhg2ToDaD+M65YcVB8jg3Y5IY5VQAyyf9gLJw+CqAuYNnAczsPQpgevtBU937kDexcdssj8Ti0ZskMd97CRs3u//U2sjJzbtwH1+/Cf8jS/gbAMmWc42HzdIjAAAAAElFTkSuQmCC"]

	beforeEach module "digiexamclient"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$compile = $injector.get "$compile"

		compileDirective = (images)->
			template = "<dx-image-list images=\"images\" track=\"track\"></dx-image-list>"
			$scope = $rootScope.$new()
			# Two images
			$scope.images = images
			$scope.track = 1
			directive = $compile(template)($scope)
			$scope.$digest()
			return directive

	it "should compile supplied data to images", ->
		directive = compileDirective(base64Images)
		expect(directive.find("img").length).toBe(2)

	it "should set data-lightbox to 'image-{{track}}", ->
		directive = compileDirective(base64Images)
		links = directive.find("a")
		for link in links
			expect(link.getAttribute("data-lightbox")).toEqual("image-" + $scope.track)

	it "should do nothing if $scope.images is undefined or null", ->
		directive = compileDirective()
		expect(directive.find("img").length).toBe(0)

	it "should do nothing if no images are supplied", ->
		directive = compileDirective([])
		expect(directive.find("img").length).toBe(0)

