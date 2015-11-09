//var lockdown = require("./build/release/dxlockdown");
var addon = require("./build/Release/dxpreconditiontests");

console.log("Native module init");
console.log(__dirname);
console.log("Run ");
console.log(addon.run());
//console.log(addon.getAllTests());
//console.log(addon.getObject());
//lockdown.mute();
