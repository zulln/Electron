var addon = require('./node_modules/hello-mac/build/Release/nodeAddon');

exports.nodeTest = function() {
	return "nodeTest";
};

exports.nodeHello = function() {
	return addon.hello();
};