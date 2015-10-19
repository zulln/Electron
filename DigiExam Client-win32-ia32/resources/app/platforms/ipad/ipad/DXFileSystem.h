//
//  DXFileSystemInterop.h
//  DigiExam-iPad
//
//  Created by Fredrik Stockman on 07/07/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXFileSystem : NSObject
// File system
- (BOOL)makeDir:(NSString *)path;
- (NSString *)readFile:(NSString *)path;
- (BOOL)writeFileToPath:(NSString *)path andFileName:(NSString *)fileName withContent:(NSString *)content;
- (NSArray *)listDirectory:(NSString *)path;
// Local storage
- (NSString *)getLocalStorageKey:(NSString *) key;
- (BOOL)setLocalStorageKey:(NSString *)key value:(NSString *)value;
- (BOOL)removeLocalStorageKey:(NSString *)key;
- (BOOL)clearLocalStorage;
@end