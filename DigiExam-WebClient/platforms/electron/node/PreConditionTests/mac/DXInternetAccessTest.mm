//
//  DXInternetConnectionTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "DXInternetAccessTest.h"

@implementation DXInternetAccessTest

- (id)init {
    self = [super init];

    if (self) {
        _isFailFatal = NO;
        _failTitle = @"Internet connection not available.";
        _failMessage =  @"You don't have a connection to the Internet, fix your connection or ask the supervisor to start the exam offline.";
    }

    return self;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

    ServerPinger *serverPinger = [[ServerPinger alloc] initWithDelegate:self openMode:NO];
    [serverPinger start];
}

#pragma mark - ServerPingerDelegate

- (void)serverPingNetworkSuccess:(ServerPinger *)serverPinger openMode:(BOOL)openMode {
    _isFinished = YES;
    _isSuccess = YES;

    [_delegate testFinished:self];
}

- (void)serverPingNetworkRedirect:(ServerPinger *)serverPinger openMode:(BOOL)openMode {
    _isFinished = YES;
    _isSuccess = YES;

    [_delegate testFinished:self];
}

- (void)serverPingNetworkError:(ServerPinger *)serverPinger openMode:(BOOL)openMode error:(NSError *)error {
    _isFinished = YES;
    _isSuccess = NO;

    [_delegate testFinished:self];
}

@end
