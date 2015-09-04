var app = require('app');
var browserWindow = require('browser-window');

mainWindow = null;

app.on('ready', function(){
	mainWindow = new browserWindow({width: 600, height: 800});

	mainWindow.loadUrl('file://' + __dirname + '/index.html');

	mainWindow.openDevTools();

	mainWindow.on('close', function(){
		mainWindow = null;
	});
});
