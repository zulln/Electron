//
//  DXBasePreConditionTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "DXBasePreConditionTest.h"

@implementation DXBasePreConditionTest

/*
    startTest must be overriden in subclasses of DXBasePreConditionTest
*/
- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    [self doesNotRecognizeSelector:_cmd];
}

- (bool)isFinished {
    return _isFinished;
}

- (bool)isSuccess {
    return _isSuccess;
}

- (bool)isFailFatal {
    return _isFailFatal;
}

- (NSString*)failTitle {
    return _failTitle;
}

- (NSString*)failMessage {
    return _failMessage;
}

@end
