angular.module("digiexamclient.storage.localstorage")
.factory("IOSLocalStorage", function($q, $timeout, $rootScope, JsObjcBridge) {
	"use strict";

	var COMMAND = {
		"GET": "get_local_storage_key",
		"SET": "set_local_storage_key",
		"REMOVE": "remove_local_storage_key",
		"CLEAR": "clear_local_storage"
	};

	var sendToObjc = function(data, dataTranformer) {
		var deferred = $q.defer();
		var callback = function(responseData) {
			try {
				responseData = JSON.parse(responseData);
			} catch(e) {
				angular.noop();
			}
			if (typeof dataTranformer !== "undefined") {
				responseData = dataTranformer.call(this, responseData);
			}
			deferred.resolve(responseData);
			$rootScope.$apply();
		};
		JsObjcBridge.sendToObjc(data, callback);
		return deferred.promise;
	};

	var get = function(key) {
		var data = {
			"command": COMMAND.GET,
			"data": {
				"key": key
			}
		};
		var dataTranformer = function(inData) {
			var retData = {};
			retData[key] = inData || null;
			return retData;
		};
		var promise = sendToObjc(data, dataTranformer);
		return promise;
	};

	var set = function(key, value) {
		var data = {
			"command": COMMAND.SET,
			"data": {
				"key": key,
				"value": JSON.stringify(value)
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	var remove = function(key) {
		var data = {
			"command": COMMAND.REMOVE,
			"data": {
				"key": key
			}
		};
		var promise = sendToObjc(data);
		return promise;
	};

	var clear = function() {
		var data = {
			"command": COMMAND.CLEAR
		};
		var promise = sendToObjc(data);
		return promise;
	};

	return {
		"get": get,
		"set": set,
		"remove": remove,
		"clear": clear
	};
});
