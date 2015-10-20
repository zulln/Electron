angular.module("digiexam-preconditiontest").controller("preconditiontest-controller", function ($scope, $window, DX_PLATFORM, ElectronFileSystem, DXPreConditionTest) {
	"use strict";

	var self = $scope;

	$window.console.log(DXPreConditionTest);

	self.state = "running";

	//self.watch

	/*self.runPreconditionTests = function(){
		self.fatalFails = 1;
	};*/

	self.hasWarnings = function(){
		return self.warnings > 0;
	};

	self.hasFatalFails = function(){
		return self.fatalFails > 0;
	};

	self.getWarnings = function() {
		//Return array with all warnings
	};

	self.setWarnings = function(warningTitle, warningDescription) {
		self.warningArray.push({
			type: warningTitle,
			description: warningDescription
		});
		self.warnings++;
	};

	self.getFatalFails = function() {
		//Return array with all warnings
	};

	self.setFatalFails = function(failTitle, failDescription){
		self.fatalFailArray.push({
			type: failTitle,
			description: failDescription
		});
		self.fatalFails++;
	};

	self.continue = function(){
		self.testsPassed();
	};

	self.close = function(){
		$window.close();
	};

	function runPreconditionTests(callback) {
		//DXPreConditionTest.startPreconditionTests();

		self.setWarnings("testWarning", "testWarningDescription");
		self.setWarnings("testWarning2", "testWarningDescription2");
		self.setFatalFails("testFail", "testFailDescription");
		self.setFatalFails("testFail2", "testFailDescription2");

		if (!(self.hasFatalFails() || self.hasWarnings())) {
			self.state = "passed";
			self.testsPassed();
		}
		else if (self.hasWarnings()) {
			self.state = "warning";
		}
		else {
			self.state = "fatal";
		}
		callback();
	}

	//runPreconditionTests(resultCallback);

	/*function runTests() {
		DXPreConditionTest.startTests(onAllTestsFinished);
	}*/

	function initTests() {
		$window.console.log("Init tests");
		//DXPreConditionTest.init();
		DXPreConditionTest.init2();
	}

	//runTests();
	initTests();		//Get platform specific tests
});
