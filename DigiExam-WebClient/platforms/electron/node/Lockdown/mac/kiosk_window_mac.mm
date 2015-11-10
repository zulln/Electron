#import "kiosk_window_mac.h"

namespace lockdown {

	void KioskWindow::runTask(Local<Function> callback) {

		//NSWindow *mainWindow = [NSApplication mainWindow];

	//	NSString *windowsString = [NSString stringWithFormat:@"Open windows %@", windows];

		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"OK"];
		[alert addButtonWithTitle:@"Cancel"];
		//[alert setMessageText:[self mainWindow]];
	//	[alert setInformativeText:text];
		[alert setAlertStyle:NSWarningAlertStyle];
		if ([alert runModal] == NSAlertFirstButtonReturn) {

		}

		_isSuccess = true;
	}

	bool KioskWindow::isSuccess() { return _isSuccess; }
}
