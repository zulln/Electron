angular.module("digiexam-preconditiontest").controller("preconditiontest-controller", function ($scope, $window) {
	"use strict";

	var ipc = $window.require("ipc");

	$scope.currentTest = "Preconditiontest";
	$scope.warnings = 10;
	$scope.fatalFails = 10;

	/*$scope.runPreconditionTests = function(){
		$scope.fatalFails = 1;
	};*/

	$scope.hasWarnings = function(){
		return $scope.warnings > 0;
	};

	$scope.hasFatalFails = function(){
		return $scope.fatalFails > 0;
	};

	$scope.getWarnings = function(){
	//	get array of warnings from preconditon module
	//	present in precondition view, add continue button
	};

	$scope.getFatalFails = function(){
	//	get array of fatalFails from preconditon module
	//	present in precondition view, add close button
	};

	$scope.testsPassed = function(){
		ipc.sendSync("testsPassed");
	};

	$scope.continue = function(){

	};

	$scope.close = function(){
		$window.close();
	};

	function runPreconditionTests() {
		if (!($scope.hasFatalFails() || $scope.hasWarnings())) {
			$scope.testsPassed();
		}
	}

	runPreconditionTests();
});
