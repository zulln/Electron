//
//  DXScreenCaptureDisabler.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "disable_screen_capture_mac.h"

@implementation ScreenCaptureDisabler

@synthesize queryResults;

- (void)runTask
{
	NSLog(@"Application Finished Loading");
	NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60];

    // Insert code here to initialize your application
    query = [[NSMetadataQuery alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidStartGatheringNotification object:query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidUpdateNotification object:query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidFinishGatheringNotification object:query];

    [query setDelegate:self];
    [query setPredicate:[NSPredicate predicateWithFormat:@"(kMDItemContentCreationDate >= %@ && kMDItemContentCreationDate < %@ && (kMDItemIsScreenCapture = 1))", startDate, endDate]];
    [query startQuery];
}

- (void)stopTask
{
    [query stopQuery];
    [query setDelegate:nil];
    [query release], query = nil;
    [self setQueryResults:nil];
}

- (void)queryUpdated:(NSNotification *)note {
    [self setQueryResults:[query results]];
    [queryResults count];

    for(NSUInteger i=0; i<[[query results] count]; i++){
        NSMetadataItem *item = [[query results] objectAtIndex:i];
        [[NSFileManager defaultManager] removeItemAtPath:[item valueForAttribute:NSMetadataItemPathKey] error:nil];
    }
}

@end
