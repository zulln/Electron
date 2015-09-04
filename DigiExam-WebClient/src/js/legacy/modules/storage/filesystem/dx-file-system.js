angular.module("digiexamclient.storage.filesystem")
.service("DXFileSystem", function($window, BrowserFileSystem, ChromeAppFileSystem, IOSFileSystem, DX_PLATFORM) {
	"use strict";

	var PLATFORM_FILE_SYSTEMS = {
		"ELECTRON_APP": BrowserFileSystem,
		"BROWSER": BrowserFileSystem,
		"CHROME_APP": ChromeAppFileSystem,
		"IOS_WEBVIEW": IOSFileSystem
	};

	return PLATFORM_FILE_SYSTEMS[DX_PLATFORM];
});
