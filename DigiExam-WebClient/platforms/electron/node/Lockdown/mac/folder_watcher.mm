//
//  DXFolderWatcher.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "folder_watcher.h"


@implementation DXFolderWatcher {
    NSMetadataQuery *query;
    NSString *path;
    NSPredicate *predicate;
    id<DXFolderWatcherDelegate> delegate;
    NSMutableArray *foundFiles;
}

- (id)initWithPath:(NSString*)aPath andDelegate:(id<DXFolderWatcherDelegate>)aDelegate {
    self = [self init];

    if (self) {
        path = [aPath stringByExpandingTildeInPath];
        delegate = aDelegate;
        predicate = [NSPredicate predicateWithFormat:@"%K LIKE '*.*'", NSMetadataItemFSNameKey];
        foundFiles = [NSMutableArray array];
    }

    return self;
}

- (void)start {
    query = [[NSMetadataQuery alloc] init];
    query.searchScopes = @[path];
    query.predicate = predicate;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(found:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [nc addObserver:self selector:@selector(found:) name:NSMetadataQueryDidUpdateNotification object:query];

    [query startQuery];
}

- (void)found:(NSNotification *)notification {
    [query disableUpdates];

    for (NSUInteger i = 0; i < query.resultCount; i++) {
        NSString* filePath = [[query resultAtIndex:i] valueForAttribute:NSMetadataItemPathKey];

        // Add all files to found list first scan
        if (notification.name == NSMetadataQueryDidFinishGatheringNotification) {
            [foundFiles addObject:filePath];
        }

        BOOL isFileNew = ![foundFiles containsObject:filePath];

        if (delegate && isFileNew) {
            [delegate onFileAdded:filePath];
            [foundFiles addObject:filePath];
        }
    }

    [query enableUpdates];
}

- (void)stop {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];

    [query stopQuery];
}

@end
