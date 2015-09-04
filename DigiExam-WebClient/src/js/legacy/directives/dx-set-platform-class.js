angular.module("digiexamclient")
.directive("dxSetPlatformClass", function(DX_PLATFORM) {
	"use strict";

	var link = function(scope, element) {
		// set class to be:
		// "dx-" + value of DX_PLATFORM lower cased and _ being -
		element.addClass("dx-" + DX_PLATFORM.toLowerCase().replace("_", "-"));
	};

	return {
		restrict: "A",
		link: link
	};
});
