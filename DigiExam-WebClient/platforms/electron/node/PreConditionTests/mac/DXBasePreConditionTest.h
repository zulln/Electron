//
//  DXBasePreConditionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXPreConditionTest.h"

@interface DXBasePreConditionTest : NSObject <DXPreConditionTest> {
@protected
    id <DXPreConditionTestDelegate> _delegate;
    bool _isFinished, _isSuccess, _isFailFatal;
    NSString *_failTitle, *_failMessage;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)delegate;
- (bool)isFailFatal;
- (bool)isSuccess;
- (bool)isFinished;
- (NSString*)failTitle;
- (NSString*)failMessage;
@end
