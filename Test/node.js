var addon = require('./node_modules/hello-mac/build/Release/dxlockdown');

exports.nodeTest = function() {
	return "nodeTest";
};

exports.nodeHello = function() {
	return addon.hello();
};
