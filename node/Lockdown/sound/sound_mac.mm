#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

void MuteVolume() {
	NSAppleScript* as = [[NSAppleScript alloc] initWithSource:@"set volume 0"];
	[as executeAndReturnError:nil];
}