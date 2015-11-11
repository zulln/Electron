//
//  DXScreenCaptureDisabler.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "disable_screen_capture_mac.h"
#import "shell_command_mac.h"

NSString *ORIGINAL_SCREEN_CAPTURE_PATH_KEY = @"DEOrignalScreenCapturePath";

@implementation DXScreenCaptureDisabler {
    DXFolderWatcher *watcher;
    BOOL started;
}

/**
 * @brief Start preventing screen captures
 */
- (void)start {
    if (started) {
        [NSException raise:@"Not allowed to start DXScreenCaptureDisabler" format:@"DXScreenCaptureDisabler must be stopped to be started."];
    }

    // Only set original path if it empty, if it still has value indicates a non-clean exit.
    if (![self getOriginalPath]) {
        NSString *originalPath = [self getScreenCaptureLocation];
        [self setOriginalPath:originalPath];
    }

    NSString* tempDirPath = [self getTempDirPath];

    [self createDir:tempDirPath];
    [self setScreenCaptureLocation:tempDirPath];
    [self applyLocationChange];

    watcher = [[DXFolderWatcher alloc] initWithPath:tempDirPath andDelegate:self];
    [watcher start];
    started = YES;
}

/**
 * @brief Stop preventing screen captures
 */
- (void)stop {
    if (!started) {
        [NSException raise:@"Not allowed to stop DXScreenCaptureDisabler" format:@"DXScreenCaptureDisabler must be started to be stopped."];
    }

    [watcher stop];

    [self deleteDirIfEmpty:[self getScreenCaptureLocation]];
    [self restoreUserSettings];
    started = NO;
}

/**
 * @brief Restore the original screen capture location from user prefs if it exists.
 */
- (void)restoreUserSettings {
    NSString *originalPath = [self getOriginalPath];

    if (originalPath) {
        [self setScreenCaptureLocation:originalPath];
        [self applyLocationChange];
        [self setOriginalPath:nil];
    }
}

/**
 * @brief Callback from the DXFolderWatcher when it finds a new file
 */
- (void)onFileAdded:(NSString*)filePath {
    NSString *captureType = [self getScreencaptureType];

    // Restrict to files of com.apple.screencapture type.
    if ([[filePath pathExtension] isEqualTo:captureType]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

/**
 * @brief Returns the path to the temporary directory where screen captures are stored during the exam.
 */
- (NSString*)getTempDirPath {
    return @"~/Desktop/Screencapture/";
}

/**
 * @brief Returns current screen capture location
 */
- (NSString*)getScreenCaptureLocation {
    NSString* ret = [DXShellCommand run:@"defaults read com.apple.screencapture location"];

    if ([ret isEqualTo:@""]) {
        return @"~/Desktop/";
    } else {
        return [ret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
}

/**
 * @brief Set current screen capture location
 */
- (void)setScreenCaptureLocation:(NSString*)location {
    NSString *cmd = [NSString stringWithFormat:@"defaults write com.apple.screencapture location %@", location];
    [DXShellCommand run:cmd];
}


/**
 * @brief Returns current screen capture type
 * Valid values can be found at: http://secrets.blacktree.com/edit?id=2233
 */
- (NSString*)getScreencaptureType {
    NSString* ret = [DXShellCommand run:@"defaults read com.apple.screencapture type"];
	//http://stackoverflow.com/questions/4516852/detect-when-a-user-takes-a-screenshot
    if ([ret isEqualTo:@""]) {
        return @"png";
    } else {
        return [ret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
}

/**
 * @brief Applies the screen capture location change
 */
- (void)applyLocationChange {
    [DXShellCommand run:@"killall SystemUIServer"];
}

/**
 * @brief Persist the original path in the user preferences
 */
- (void)setOriginalPath:(NSString*)path {
    [[NSUserDefaults standardUserDefaults] setObject:path forKey:ORIGINAL_SCREEN_CAPTURE_PATH_KEY];
}

/**
 * @brief Load the original path from the user preferences
 */
- (NSString*)getOriginalPath {
    return [[NSUserDefaults standardUserDefaults] objectForKey:ORIGINAL_SCREEN_CAPTURE_PATH_KEY];
}

/**
 * @brief Create directory at path
 */
- (void)createDir:(NSString*)dirPath {
    [[NSFileManager defaultManager] createDirectoryAtPath:[dirPath stringByExpandingTildeInPath]
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
}

/**
 * @brief Delete directory if it is empty or only contains .DS_Store as the only file.
 */
- (void)deleteDirIfEmpty:(NSString*)dirPath {
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];

    BOOL onlyFileIsDSStore = [files count] == 1 && [[files objectAtIndex:0] isEqualTo:@".DS_Store"];

    if ([files count] == 0 || onlyFileIsDSStore) {
        [[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil];
    }
}

@end
