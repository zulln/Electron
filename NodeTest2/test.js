//var createObject = require('./build/Release/addon');
var addon = require('./build/Release/addon');

var array = addon.getArray();

console.log(array);
console.log(array[0].run());
