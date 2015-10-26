#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

void SetKiosk(bool kiosk) {
	NSString *text = [NSString stringWithFormat:@"Main window: %@", [[NSApplication sharedApplication] mainWindow]];

	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"Delete the record?"];
	[alert setInformativeText:text];
	[alert setAlertStyle:NSWarningAlertStyle];
	if ([alert runModal] == NSAlertFirstButtonReturn) {

	}

	if (kiosk) {
		NSApplicationPresentationOptions options =
			NSApplicationPresentationHideDock +
			NSApplicationPresentationHideMenuBar +
			NSApplicationPresentationDisableAppleMenu +
			NSApplicationPresentationDisableProcessSwitching +
			NSApplicationPresentationDisableForceQuit +
			NSApplicationPresentationDisableSessionTermination +
			NSApplicationPresentationDisableHideApplication;

		[NSApp setPresentationOptions:options];
	} else {
		[NSApp setPresentationOptions:[NSApp currentSystemPresentationOptions]];
	}
}
