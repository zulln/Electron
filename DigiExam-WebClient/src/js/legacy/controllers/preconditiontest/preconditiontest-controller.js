angular.module("digiexam-preconditiontest").controller("preconditiontest-controller", function ($scope, $window, DX_PLATFORM, ElectronFileSystem, DXPreConditionTest) {
	"use strict";

	var self = $scope;
	self.warningArray = 0;
	self.fatalFailArray = 0;
	self.state = "running";
	var ipc = $window.require("ipc");

	self.continue = function() {
		ipc.sendSync("testsPassed");
	};

	self.close = function() {
		$window.close();
	};

	self.hasWarnings = function() {
		return self.warningArray.length > 0;
	};

	self.hasFatalFails = function() {
		return self.fatalFailArray.length > 0;
	};

	function onAllTestsFinished(warnings, fatals) {
		self.warningArray = warnings;
		self.fatalFailArray = fatals;

		if (!(self.hasWarnings() || self.hasFatalFails())) {
			self.state = "passed";
			self.continue();
		}
		else if (self.hasFatalFails()) {
			self.state = "fatal";
		}
		else {
			self.state = "warning";
		}
	}

	DXPreConditionTest.init(onAllTestsFinished);
});
