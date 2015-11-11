#import <Foundation/Foundation.h>
#import "../base_lockdown_task.h"
#import "folder_watcher.h"

@interface DXScreenCaptureDisabler : NSObject <DXFolderWatcherDelegate>

- (void)start;
- (void)stop;
- (void)restoreUserSettings;

@end
