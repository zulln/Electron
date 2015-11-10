#ifndef FOLDER_WATCHER_H
#define FOLDER_WATCHER_H//
//  Folder.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DXFolderWatcherDelegate <NSObject>
- (void)onFileAdded:(NSString*)filePath;
@end

@interface DXFolderWatcher : NSObject

- (id)initWithPath:(NSString*)aPath andDelegate:(id<DXFolderWatcherDelegate>)aDelegate;
- (void)start;
- (void)stop;

@end
#endif
