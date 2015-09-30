angular.module("digiexamclient.lockdown")
.service("DXLockdown", function($window, ElectronLockdown, DX_PLATFORM) {
//.service("DXLockdown", function($window, BrowserLockdown, ChromeAppLockdown, IOSLockdown, ElectronLockdown, DX_PLATFORM) {
	"use strict";

	$window.console.log("DXLockdown");

	var PLATFORM_LOCKDOWN = {
		"ELECTRON_APP": ElectronLockdown/*,
		"BROWSER": BrowserLockdown,
		"CHROME_APP": ChromeAppLockdown,
		"IOS_WEBVIEW": IOSLockdown*/
	};

	return PLATFORM_LOCKDOWN[DX_PLATFORM];
});
