angular.module("digiexamclient.storage.localstorage")
.factory("BrowserLocalStorage", function($q, $window){
	"use strict";

	var BadLocalStorageArgumentType = function (message) {
		var defaultMessage = "This implementation of local storage's get, set and remove methods requires key arguments to be of type string";

		Error.call(this);
		Error.captureStackTrace(this, this.constructor); //super helper method to include stack trace in error object
		this.name = "BadLocalStorageArgumentType";
		this.message = (message || defaultMessage);
	};
	BadLocalStorageArgumentType.prototype = Error.prototype;

	var verifyKeyTypeIsString = function(key, deferred) {
		if (typeof key !== "string") {
			var e = new BadLocalStorageArgumentType();
			deferred.reject(e);
			throw e;
		}
	};

	var get = function(key) {
		var deferred = $q.defer();
		var ret = {};
		verifyKeyTypeIsString(key, deferred);
		if (!$window.localStorage.getItem(key) !== undefined) {
			ret[key] = $window.localStorage.getItem(key) ? JSON.parse($window.localStorage[key]) : undefined;
			deferred.resolve(ret);
		}
		return deferred.promise;
	};

	var set = function(key, value) {
		var deferred = $q.defer();
		verifyKeyTypeIsString(key, deferred);
		$window.localStorage.setItem(key, JSON.stringify(value));
		deferred.resolve();
		return deferred.promise;
	};

	var remove = function(key) {
		var deferred = $q.defer();
		verifyKeyTypeIsString(key, deferred);
		try {
			$window.localStorage.removeItem(key);
			deferred.resolve();
		} catch (e) {
			deferred.reject(e);
		}
		return deferred.promise;
	};

	var clear = function() {
		var deferred = $q.defer();
		try {
			for (var key in $window.localStorage) {
				if ($window.localStorage.hasOwnProperty(key)) {
					$window.localStorage.removeItem(key);
				}
			}
			deferred.resolve();
		}
		catch (e) {
			deferred.reject(e);
		}
		return deferred.promise;
	};

	return {
		get: get,
		set: set,
		remove: remove,
		clear: clear
	};
});
