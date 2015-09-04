var angularApp = angular.module('angularApp', []);

angularApp.controller('angularAppCtrl', function($scope){
	$scope.count = 900;

	$scope.go = function() {
		console.log(addon.hello());
	}

});

<!-- NodeJS -->

var addon = require('./node_modules/hello-mac/build/Release/nodeAddon');

//var nodeTest = console.log(addon.hello());

<!-- jQuery -->

$(document).ready(function(){
	alert("Document is ready and running jQuery");
});
