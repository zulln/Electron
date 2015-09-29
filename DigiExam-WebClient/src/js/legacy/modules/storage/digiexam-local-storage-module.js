angular.module("digiexamclient.storage.localstorage", [])
.service("DXLockdown", function(BrowserLockdown, ChromeAppLockdown, ElectronLockdown, IOSLockdown, DX_PLATFORM) {
	"use strict";

	var PLATFORM_LOCAL_STORAGES = {
		"ELECTRON_APP": ElectronLockdown,
		"BROWSER": BrowserLockdown,
		"CHROME_APP": ChromeAppLockdown,
		"IOS_WEBVIEW": IOSLockdown
	};

	return PLATFORM_LOCAL_STORAGES[DX_PLATFORM];
});
