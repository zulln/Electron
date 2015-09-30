angular.module("digiexamclient.storage.localstorage")
.service("DXLocalStorage", function($window, BrowserLocalStorage, ChromeAppLocalStorage, ElectronLocalStorage, IOSLocalStorage, DX_PLATFORM) {
	"use strict";

	var PLATFORM_LOCAL_STORAGES = {
		"ELECTRON_APP": ElectronLocalStorage,
		"BROWSER": BrowserLocalStorage,
		"CHROME_APP": ChromeAppLocalStorage,
		"IOS_WEBVIEW": IOSLocalStorage
	};

	return PLATFORM_LOCAL_STORAGES[DX_PLATFORM];
});
