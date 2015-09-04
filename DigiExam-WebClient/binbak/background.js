chrome.app.runtime.onLaunched.addListener(function(launchData) {
	var isKiosk = launchData.isKioskSession || false;

	var kioskOptions = {
		state: "fullscreen",
		frame: "none",
		resizable: false
	};

	// Mainly used for development.
	var windowOptions = {
		// 1366 x 760 is the most common resolution used on Chromebooks and other laptops (2015/03).
		innerBounds: {
			top: 0,
			left: 0,
			width: 1366,
			height: 760,
			maxWidth: 1366,
			maxHeight: 760
		}
	};

	var options = isKiosk ? kioskOptions : windowOptions;

	chrome.app.window.create("index.html", options, function(createdWindow) {
		createdWindow.contentWindow.isKiosk = isKiosk;
	});
});
