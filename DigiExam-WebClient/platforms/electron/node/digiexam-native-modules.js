var lockdown = require("./build/release/dxlockdown");
var addon = require("./build/Release/dxpreconditiontests");


console.log("Native module init");
console.log(addon.getAllTests());
//console.log(addon.getObject());
lockdown.mute();
