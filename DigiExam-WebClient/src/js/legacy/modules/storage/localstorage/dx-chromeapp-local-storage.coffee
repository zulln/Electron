angular.module("digiexamclient.storage.localstorage").factory "ChromeAppLocalStorage", ($rootScope, $window, $q)->
	ChromeAppLocalStorage =
		get: (data)->
			deferred = $q.defer()
			$window.chrome.storage.local.get data, (data)->
				if $window.chrome.runtime.lastError?
					deferred.reject $window.chrome.runtime.lastError
				else
					deferred.resolve data
			return deferred.promise
		set: (key, value)->
			deferred = $q.defer()
			obj = {}
			if typeof key is "string"
				obj[key] = value
			if isObject(key)
				obj = key

			# Chrome's localstorage serializes functions to objects
			# which is a pain in the ass as nothing then works as expected
			# this JSON serialize solution below both copies the object and
			# removes functions
			copy = JSON.parse JSON.stringify(obj)
			$window.chrome.storage.local.set copy, ->
				if $window.chrome.runtime.lastError?
					deferred.reject $window.chrome.runtime.lastError
				else
					deferred.resolve()
			return deferred.promise
		remove: (data)->
			deferred = $q.defer()
			$window.chrome.storage.local.remove data
			if $window.chrome.runtime.lastError?
				deferred.reject $window.chrome.runtime.lastError
			else
				deferred.resolve()
			return deferred.promise
		clear: ->
			deferred = $q.defer()
			$window.chrome.storage.local.clear()
			if $window.chrome.runtime.lastError?
				deferred.reject $window.chrome.runtime.lastError
			else
				deferred.resolve()
			return deferred.promise
	return ChromeAppLocalStorage
