var app = require('app');
bar browserWindow = require('browser-window');

//Disable crash-reporter
//require('crash-reporter').start();

var mainWindow = null;

app.on("window-all-closed", function() {

  if(process.platform != 'darwin'){
    app.quit();
  }
});

app.on('ready', function() {
  mainWindow = new BrowserWindow({width: 800, height: 600});

  mainWindow.loadUrl('file://index.html');
  mainWindow.openDevTools();

  mainWindows.on('closed', function(){
    mainWindow = null;
  });
});
