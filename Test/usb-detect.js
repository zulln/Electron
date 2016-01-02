angular.module('usbDetectApp', []);

angular.module('usbDetectApp')
.controller('usbDetectAppCtrl', function($scope, $window){
	$scope.usbDetected = false;
	$scope.stateBool = true;
	$scope.state = "Not Running";

	var nativeUSBDetect = $window.require('./node_modules/hello-mac/build/Release/usbnotify');
	var callback = "Callback here";

	$scope.switcher = function() {
		if ($scope.stateBool === true) {
			nativeUSBDetect.run(function(result) {
				console.log(result);
			});
			$scope.stateBool = !($scope.stateBool);
			$scope.state = "Running";
		}
		else {
			nativeUSBDetect.stop(function(result) {
				console.log(result);
			});
			$scope.stateBool = !($scope.stateBool);
			$scope.state = "Not Running";
		}
	};

	var callback = function(test){
		console.log(test);
	}

});

<!-- NodeJS -->

//var nodeTest = console.log(addon.hello());

<!-- jQuery -->
