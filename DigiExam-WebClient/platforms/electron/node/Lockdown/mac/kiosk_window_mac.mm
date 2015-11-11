#import "kiosk_window_mac.h"
#import <vector>

using namespace v8;

namespace lockdown {

	NSApplicationPresentationOptions KioskWindow::presentationOptions() {
	    return NSApplicationPresentationHideDock
				+ NSApplicationPresentationHideMenuBar
				+ NSApplicationPresentationDisableForceQuit
				+ NSApplicationPresentationDisableProcessSwitching
				+ NSApplicationPresentationDisableSessionTermination;
	}

	void KioskWindow::runTask(Local<Function> callback) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		[NSApp setPresentationOptions:presentationOptions()];
		NSWindow *window = [[NSApplication sharedApplication] mainWindow];

		NSDictionary *optionsDictionary;
		NSArray *keys = [NSArray arrayWithObjects:NSFullScreenModeAllScreens, nil];
		NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES], nil];

		optionsDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];

		[window.contentView enterFullScreenMode:[NSScreen mainScreen] withOptions:optionsDictionary];

		_isSuccess = true;
	}

	bool KioskWindow::isSuccess() {	return _isSuccess; }
}
