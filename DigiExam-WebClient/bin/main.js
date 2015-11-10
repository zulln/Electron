var app = require('app');
var browserWindow = require('browser-window');
var dialog = require("dialog");
var globalShortcut = require('global-shortcut');
var ipc = require('ipc');

preconditionWindow = null;
mainWindow = null;
//webFrame.setZoomLevelLimits(1,1);

var disablePinchZoom = function(currWindow) {
	currWindow.addEventListener('mouseWheel', function(e)
	{	if(e.ctrlKey){
			e.preventDefault();
		}
	});
};

var disableShortKeys = function() {
	//Define all global shortkeys that should be prohibited in the application here
	globalShortcut.register('Super+r', function(){});				//1

};

var showPreconditionWindow = function() {
	preconditionWindow = new browserWindow({width: 400, height: 320, resizable: true, center: true, "always-on-top": true, icon: "/images/arrow-right.png"});
	preconditionWindow.webContents.on('did-finish-load', function(){
		preconditionWindow.webContents.executeJavaScript("window.isElectron = true;");
	});
	preconditionWindow.loadUrl('file://' + __dirname + '/preconditiontest.html');

	preconditionWindow.openDevTools();

	preconditionWindow.on('close', function(){
		preconditionWindow = null;
	});
};

var showMainWindow = function() {
	mainWindow = new browserWindow({width: 1200, height: 1600, resizable: false, center: true, "always-on-top": true, icon: "/images/arrow-right.png"});
	//webFrame.setZoomLevelLimits(1,1);
	mainWindow.webContents.on('did-finish-load', function(){
		mainWindow.webContents.executeJavaScript("window.isElectron = true;");
	});

	mainWindow.loadUrl('file://' + __dirname + '/index.html');
	disableShortKeys();
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

		if(dialogResult === undefined) { dialogResult = null; }		//2
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

		if(dialogResult === undefined) { dialogResult = null; }		//2
		event.returnValue = dialogResult;
	});

	mainWindow.on('close', function(){
		mainWindow = null;
	});
};

/*		Entry point of application 		*/

app.on('ready', function(){
	showPreconditionWindow();
	ipc.on("testsPassed", function(event) {
		preconditionWindow.close();
		showMainWindow();
	});
});

/*		Exit point of applciation		*/

app.on('window-all-closed', function(){
	app.quit();
})

/*		Comment explanations:

 1. Register in order to disable cmd button on Mac and Ctrl on Windows
 2. Due to electron not beeing able to return undefined as returnValue
 3. Arg should set kiosk-mode */
