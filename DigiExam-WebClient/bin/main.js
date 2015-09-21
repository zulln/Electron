var app = require('app');
var browserWindow = require('browser-window');
var dialog = require("dialog");
var globalShortcut = require('global-shortcut');
var ipc = require("ipc");

mainWindow = null;

app.on('ready', function(){
	mainWindow = new browserWindow({width: 1200, height: 1600});

	mainWindow.webContents.on('did-finish-load', function(){
		mainWindow.webContents.executeJavaScript("window.isElectron = true;");
	});

	mainWindow.loadUrl('file://' + __dirname + '/index.html');

	globalShortcut.register('Super+r', function(){
		//Register in order to disable cmd button on Mac and Ctrl on Windows
	})
	mainWindow.openDevTools();

	ipc.on("openFile", function(event, fileType) {
		var dialogResult = dialog.showOpenDialog(mainWindow, {
			title: "Open offline exam",
			filters: [
				{name: fileType.toUpperCase(),
					extensions: [fileType],
					properties: "openFile" }
			]
		});

		if(dialogResult === undefined) { dialogResult = null; }

		event.returnValue = dialogResult;
	});

	ipc.on("saveFile", function(event, fileType) {
		var dialogResult = dialog.showSaveDialog(mainWindow, {
			title: "Save offline exam",
			filters: [
				{name: fileType.toUpperCase(),
					extensions: [fileType]
				}
			]
		});

		if(dialogResult === undefined) { dialogResult = null; }

		event.returnValue = dialogResult;
	});

	mainWindow.on('close', function(){
		mainWindow = null;
	});
});

app.on('window-all-closed', function(){
	app.quit();
})
