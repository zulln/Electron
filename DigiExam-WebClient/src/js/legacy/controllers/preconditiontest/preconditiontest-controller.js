angular.module("digiexam-preconditiontest").controller("preconditiontest-controller", function ($scope, $window, DX_PLATFORM, ElectronFileSystem, DXPreConditionTest) {
	"use strict";

	var ipc = $window.require("ipc");
	$window.console.log(DX_PLATFORM);
	$window.console.log(DXPreConditionTest);
	$scope.currentTest = "Preconditiontest";
	$scope.warnings = 1;
	$scope.fatalFails = 1;

	$scope.results = [
		{
			outcome: "warning",
			description: "I always fail, dont mind me"
		},
		{
			outcome: "fatal",
			description: "I always fatal fail, dont mind me"
		}
	];

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
	//	and present in precondition view
	};

	$scope.getFatalFails = function(){
	//	get array of fatalFails from preconditon module
	//	and present in precondition view
	};

	$scope.testsPassed = function(){
		ipc.sendSync("testsPassed");
	};

	$scope.continue = function(){
		$scope.testsPassed();
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
