var nodeAddon = require(nodeAddon);

var allTests = nodeAddon.retArray();

allTests.forEach(function(entry) {
	console.log(entry.run());
});
