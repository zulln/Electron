var lockdown = require("./build/release/dxlockdown");

console.log("Native module init");
function print() {
	console.log(lockdown.getName());
};

function macLockdown() {
	console.log("LockDown");
	//lockdown.onLockdown();
}

exports.print = print;
exports.onLockdown = macLockdown;
