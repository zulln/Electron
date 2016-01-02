var app = require('app');  // Module to control application life.
var BrowserWindow = require('browser-window');  // Module to create native browser window.
var ipc = require("ipc");
//
// Report crashes to our server.
require('crash-reporter').start();
var mainWindow = null;

// Quit when all windows are closed.
app.on('window-all-closed', function() {
    app.quit();
});

app.on('ready', function() {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600, kiosk: false});

  // and load the index.html of the app.
  mainWindow.loadUrl('file://' + __dirname + '/index.html');

  /*mainWindow.webContents.on('did-finish-load', function(){
     mainWindow.webContents.send('ping', 'I am electron');
  });*/

  ipc.on("toggleKiosk", function(event, arg) {
      mainWindow.setKiosk(arg);
      event.returnValue = mainWindow.isKiosk();
  });

  ipc.on("saveToUSB", function(event, arg) {
	  mainWindow.loadUrl('file://' + __dirname + '/detect.html');
	  //usbWindow = new BrowserWindow({width: 800, height: 600, center: true});
	  //usbWindow.loadUrl('file://' + __dirname + '/detect.html');
	  //usbWindow.openDevTools();
      //event.returnValue = mainWindow.isKiosk();
  });

  // Open the devtools.
  mainWindow.openDevTools();

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
});
