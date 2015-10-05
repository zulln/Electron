//
//  DXDiskSpaceTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "DXDiskSpaceTest.h"

@implementation DXDiskSpaceTest

- (id)init {
    self = [super init];

    if (self) {
        _isFailFatal = YES;
        _failTitle = @"Not enough free disk space.";
        _failMessage =  @"You need to have at least 1GB free disk space to start DigiExam.";
    }

    return self;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

    if ([self hasEnoughDiskSpace]) {
        _isSuccess = YES;
    }

    _isFinished = YES;

    [_delegate testFinished:self];
}

- (bool)hasEnoughDiskSpace {

    NSError *error;
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return NO;
    }

    NSNumber *freeSize = [attributes objectForKey:NSFileSystemFreeSize];
    if ([freeSize longLongValue] < 1000000000) {  // 1Gb
        return NO;
    }

    return YES;
}

@end
