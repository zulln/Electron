
# DigiExam-Client

## Get started with development

### Setting up the environment

1. Install [NodeJS](http://nodejs.org/)
2. Execute `./install-dependencies.sh`

### Running the project

1. Execute `gulp` to build static assets
	* Execute `gulp watch` in a separate terminal to build when the assets change

### Setting up the app in Chrome (Development (Win/Mac/Linux))
Make sure step 1 in the previous step has been executed.

1. Open `chrome://extensions`
2. Tick the `Developer mode` box and bring up the `Load unpacked extension` dialog
3. Browse to the project in finder and select `bin/`
4. Click Select

**Note**

If you're not running Chrome Canary you might se a red warning telling you that 'kiosk_only' requires Google Chrome dev channel. You can safely disregard this warning and launch the application like you would launch any other application.
If you're running Chrome Canary the app might not launch since it expects to run in kiosk-mode, which isn't available in Chrome browsers (as of yet at least). We do not know if Googles implementation is at fault or if this is something that we can expect in the future.

Regardless, our gulp tasks will be updated in a later update to set the `kiosk_only`-flag to `false` if developing if we continue experiencing issues with Googles implementation in the browsers.

### Packaging and distribution

Our goal with packaging and distributing this app through Chrome Web Store is that it should be really quick and easy but also ensure that no issues occur with the application.

1. Run `gulp dist` in root directory.
2. Ensure that all tests have passed and pay attention to warnings if there are any.
3. Take the .zip-file in `dist/` and upload it to Chrome Web Store.
4. Fill in necessary information if asked, various image assets for the Chrome Web Store are stored in the root directory.

Happy coding!

## Tests

Before you can run any tests you have to set up the project according
to the steps in the *Get started with development* section.

* `gulp test` will run all front-end tests.
* `gulp test-watch` will run all front-end tests and then watch for changes.

## Additional resources and links

###### https://plus.google.com/+FrancoisBeaufort
Google guy, frequently posts about everything related to Chrome and Chrome OS

##### https://groups.google.com/a/chromium.org/forum/#!forum/chromium-os-discuss
Google group for discussions about Chromium OS

##### https://groups.google.com/a/chromium.org/forum/#!forum/chromium-apps
Google group for discussions about Chromium Apps

##### http://www.chromium.org/chromium-os/chromium-os-faq#TOC-What-s-the-difference-between-Chromium-OS-and-Google-Chrome-OS-
What is the difference between Chrome OS and Chromium OS?

##### https://developer.chrome.com/apps/manifest/kiosk_enabled
General information about kiosk apps

## Useful snippets of debug code

```javascript
/*
	Reads all files under exams/ and outputs it to console
*/
window.webkitRequestFileSystem(window.PERSISTENT, 100*1024*1024, function(fs)
{
	fs.root.getDirectory("exams", {create: true}, function(dirEntry)
	{
		var dirReader = dirEntry.createReader();
		dirReader.readEntries (function(results)
		{
			for(var i = 0; i < results.length; ++i)
			{
				results[i].file(function(file)
				{
					var reader = new FileReader();
					reader.onloadend = function()
					{
						console.log(JSON.parse(this.result));
					};

					reader.readAsText(file);
				});
			}
		});
	});
});
```

```javascript
/*
	Delets all files under exams/
*/
window.webkitRequestFileSystem(window.PERSISTENT, 100*1024*1024, function(fs)
{
	fs.root.getDirectory("exams", {create: true}, function(dirEntry)
	{
		var dirReader = dirEntry.createReader();
		dirReader.readEntries (function(results) {
			for(var i = 0; i < results.length; ++i)
			{
				(function(index)
				{
					results[index].remove(function()
					{
						console.log("removed file", results[index].name)
					});
				}(i));
			}
		});
	});
});
```

## Additional notes

This project has been built with the web in mind, though it's currently lacking some functionality to work as a complete web application since it's depending on a few Chrome app APIs (FileSystem and kiosk-mode mainly).
I reckon it won't be hard to actually solve these problems when needed in the future.
