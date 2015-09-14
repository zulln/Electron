angular.module("digiexamclient.platform")
.config(function($provide) {
	"use strict";

	var SYSTEMS = [
		{
			"name": "ELECTRON_APP",
			"isCurrentSystem": function() {
				return window.isElectron;
			}
		},
		{
			"name": "CHROME_APP",
			"isCurrentSystem": function() {
				return !!(window.chrome && window.chrome.runtime && window.chrome.runtime.id);
			}
		},
		{
			"name": "IOS_WEBVIEW",
			"isCurrentSystem": function() {
				// http://stackoverflow.com/a/10170885/327706
				return /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(window.navigator.userAgent);
			}
		},
		{
			"name": "BROWSER",
			"isCurrentSystem": function() {
				return true;
			}
		}
	];

	var getCurrentSystemName = function() {
		var systemName = "UNKNOWN";

		for (var i = 0; i < SYSTEMS.length; i++) {
			var system = SYSTEMS[i];
			if (system.isCurrentSystem.call()) {
				systemName = system.name;
				break;
			}
		}

		return systemName;
	};

	var systemName = getCurrentSystemName();
	$provide.constant("DX_PLATFORM", systemName);
});
