angular.module("digiexamclient.jsobjcbridge").factory("JsObjcBridge", function(DX_PLATFORM) {
	"use strict";

	var connectWebViewJavascriptBridge = function(callback) {
		if (window.WebViewJavascriptBridge) {
			callback(WebViewJavascriptBridge);
		} else {
			document.addEventListener("WebViewJavascriptBridgeReady", function() {
				callback(WebViewJavascriptBridge);
			}, false);
		}
	};

	var sendToObjc = function(message, callback) {
		// Don't try to send js to obj-c messages if we're not in on iOS
		if (DX_PLATFORM !== "IOS_WEBVIEW") {
			return;
		}

		connectWebViewJavascriptBridge(function(bridge) {
			if (typeof callback === "undefined") {
				bridge.send(message);
			} else {
				bridge.send(message, callback);
			}
		});
	};

	var sendCommand = function(command, data, callback) {
		var message = {
			"command": command
		};
		if (data) {
			message.data = data;
		}
		sendToObjc(message, callback);
	};

	var setGuidedAccessLock = function(lock, successCallback, failCallback) {
		var command = lock ? "lock_to_guided_access" : "unlock_from_guided_access";
		sendCommand(command, null, function(didSucceed) {
			if (didSucceed === "true") {
				if (typeof successCallback === "function") {
					successCallback.call();
				}
			} else {
				if (typeof failCallback === "function") {
					failCallback.call();
				}
			}
		});
	};

	var lockToGuidedAccess = function(successCallback, failCallback) {
		setGuidedAccessLock(true, successCallback, failCallback);
	};

	var unlockFromGuidedAcess = function(successCallback, failCallback) {
		setGuidedAccessLock(false, successCallback, failCallback);
	};

	var init = function() {
		// Init bridge to be listen on messages / callbacks from obj-c
		connectWebViewJavascriptBridge(function(bridge) {
			bridge.init();
		});
	};

	init();

	return {
		sendToObjc: sendToObjc,
		sendCommand: sendCommand,
		lockToGuidedAccess: lockToGuidedAccess,
		unlockFromGuidedAcess: unlockFromGuidedAcess
	};
});
