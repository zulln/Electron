angular.module("digiexamclient").factory("DXClient", function($window, $route, $rootScope, $location, DXLocalStorage, JsObjcBridge, DX_PLATFORM) {
	"use strict";

	var DXClient = {};
	// $window.isKiosk is set in background.js
	DXClient.isKiosk = $window.isKiosk;

	// Shorthand for closing the application
	DXClient.close = function(modalInstance) {
		if (DX_PLATFORM === "CHROME_APP") {
			$window.chrome.app.window.current().close();
		}
		else if (DX_PLATFORM === "BROWSER") {
			$location.path("/");
			modalInstance.resolve();
		}
		else if (DX_PLATFORM === "IOS_WEBVIEW") {
			JsObjcBridge.unlockFromGuidedAcess(
			function() {
				$location.path("/");
				modalInstance.resolve();
			},
			function() {
				$location.path("/");
				$rootScope.$emit("Toast:Notification", "Could not unlock from guided access");
				modalInstance.reject();
			});
		}
		else {
			return angular.noop();
		}
	};

	return DXClient;
});
