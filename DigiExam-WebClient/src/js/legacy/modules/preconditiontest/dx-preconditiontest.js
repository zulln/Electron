angular.module("digiexamclient.preconditiontest")
.service("DXPreConditionTest", function($window, ElectronPreconditionTest, DX_PLATFORM) {
//.service("DXLockdown", function($window, BrowserLockdown, ChromeAppLockdown, IOSLockdown, ElectronLockdown, DX_PLATFORM) {
	"use strict";

	$window.console.log("DXPreConditionTest");

	var PLATFORM_PRECONDITIONTEST = {
		"ELECTRON_APP": ElectronPreconditionTest/*,
		"BROWSER": BrowserLockdown,
		"CHROME_APP": ChromeAppLockdown,
		"IOS_WEBVIEW": IOSLockdown*/
	};

	return PLATFORM_PRECONDITIONTEST[DX_PLATFORM];
});
