describe("DX_PLATFORM", function() {
	xit("should be CHROME_APP if window.chrome.runtime.id is not null");
	xit("should be IOS_WEBVIEW if navigator.userAgent is similar to Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/98176");
	xit("should be BROWSWER if DX_PLATFORM is not CHROME_APP or IOS_WEBVIEW");
});
