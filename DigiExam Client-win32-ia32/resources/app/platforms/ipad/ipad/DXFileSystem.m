//
//  DXFileSystemInterop.m
//  DigiExam-iPad
//
//  Created by Fredrik Stockman on 07/07/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

//
//  DXRichTextInterop.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-20.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "DXFileSystem.h"

// Apple documentation for how to inject Obj-C stuff to JS: https://developer.apple.com/library/mac/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/ObjCFromJavaScript.html#//apple_ref/doc/uid/30001215-120402


@interface DXFileSystem ()

@property NSFileManager *fileManager;
@end

static NSString *fileSystemFolderName = @"/FileSystem";
static NSString *localStorageFolderName = @"/LocalStorage";

@implementation DXFileSystem

- (id)init {
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return self;
}

- (NSString *)getAbsoluteFileSystemPath:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileSystemPath = [documentsDirectory stringByAppendingPathComponent:fileSystemFolderName];
    NSString *finalPath = [fileSystemPath stringByAppendingPathComponent:path];
    return finalPath;
}

- (NSString *)getAbsoluteLocalStoragePath:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileSystemPath = [documentsDirectory stringByAppendingPathComponent:localStorageFolderName];
    NSString *finalPath = [fileSystemPath stringByAppendingPathComponent:path];
    return finalPath;
}

/* File system methods */

- (BOOL)makeDir:(NSString *)path {
    NSString *absolutePath = [self getAbsoluteFileSystemPath:path];
    NSError *error = nil;
    [self.fileManager createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"Path: %@", path);
    if (error) {
        NSLog(@"Error %@",error.localizedDescription);
    }
    return error == nil;
}

- (NSString *)readFile:(NSString *)path {
    NSString *absolutePath = [self getAbsoluteFileSystemPath:path];
    NSData *fileData = [self.fileManager contentsAtPath:absolutePath];
    NSString *stringData = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    return stringData;
}

- (BOOL)writeFileToPath:(NSString *)path andFileName:(NSString *)fileName withContent:(NSString *)content {
    NSString *absolutePath = [self getAbsoluteFileSystemPath:[path stringByAppendingPathComponent:fileName]];
    NSData *fileData = [content dataUsingEncoding:NSUTF8StringEncoding];
    return [self.fileManager createFileAtPath:absolutePath contents:fileData attributes:nil];
}

- (NSArray *)listDirectory:(NSString *)path {
    NSString *absolutePath = [self getAbsoluteFileSystemPath:path];
    NSError *err = nil;
    NSArray *dirContents = [self.fileManager contentsOfDirectoryAtPath:absolutePath error:&err];
    return dirContents;
}

/* END File system methods */

/* Local storage methods */

- (BOOL)ensureLocalStorageDirExists {
    NSLog(@"Ensuring local storage directory exists");
    NSString *localStoragePath = [self getAbsoluteLocalStoragePath:@""];
    // If local storage folder does not exist, create it.
    BOOL isDir;
    if (!([self.fileManager fileExistsAtPath:localStoragePath isDirectory:&isDir] && isDir)) {
        NSLog(@"Local storage directory does not exists, will try to create it");
        NSError *error = nil;
        [self.fileManager createDirectoryAtPath:localStoragePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"Failed to create local storage directory with path %@. Error: %@", localStoragePath, error);
        } else {
            NSLog(@"Created local storage directory at path: %@", localStoragePath);
        }
        return error == nil;
    } else {
        NSLog(@"Local storage directory already exists with path %@", localStoragePath);
    }
    NSLog(@"%@", [self listDirectory:localStoragePath]);
    return YES;
}
- (NSString *)getLocalStorageKey:(NSString *) key {
    NSString *absolutePath = [self getAbsoluteLocalStoragePath:key];
    NSLog(@"Get from local storage (path: %@): %@", absolutePath, key);
    NSData *fileData = [self.fileManager contentsAtPath:absolutePath];
    NSString *stringData = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSLog(@"Got local storage value: %@", stringData);
    return stringData;
}
- (BOOL)setLocalStorageKey:(NSString *)key value:(NSString *)value {
    NSString *absolutePath = [self getAbsoluteLocalStoragePath:key];
    NSLog(@"Set local storage (path: %@): %@ -> %@", absolutePath, key, value);
    NSData *fileData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [self ensureLocalStorageDirExists];
    BOOL successful = [self.fileManager createFileAtPath:absolutePath contents:fileData attributes:nil];
    if (!successful) {
        NSLog(@"Failed to set local storage key: %@ with value: %@ at path %@", key, value, absolutePath);
    } else {
        NSLog(@"Successfully set local storage key: %@ with value: %@", key, value);
    }
    return successful;
}
- (BOOL)removeLocalStorageKey:(NSString *)key {
    NSString *absolutePath = [self getAbsoluteLocalStoragePath:key];
    NSLog(@"Remove key from local storage (path: %@): %@", absolutePath, key);
    NSError *err = nil;
    [self.fileManager removeItemAtPath:absolutePath error:&err];
    return err == nil;
}
- (BOOL)clearLocalStorage{
    NSString *absolutePath = [self getAbsoluteLocalStoragePath:@""];
    NSLog(@"Clear local storage at path: %@", absolutePath);
    NSError *err = nil;
    [self.fileManager removeItemAtPath:absolutePath error:&err];
    return err == nil;

}
/* END Local storage methods */

@end
