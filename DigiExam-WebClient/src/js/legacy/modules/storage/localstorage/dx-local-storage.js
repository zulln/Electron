angular.module("digiexamclient.storage.localstorage")
.service("DXLocalStorage", function(BrowserLocalStorage, ChromeAppLocalStorage, IOSLocalStorage, DX_PLATFORM) {
	"use strict";

	var PLATFORM_LOCAL_STORAGES = {
		"BROWSER": BrowserLocalStorage,
		"CHROME_APP": ChromeAppLocalStorage,
		"IOS_WEBVIEW": IOSLocalStorage
	};

	return PLATFORM_LOCAL_STORAGES[DX_PLATFORM];
});
