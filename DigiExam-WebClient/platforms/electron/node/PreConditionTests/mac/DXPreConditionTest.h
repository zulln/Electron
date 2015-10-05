//
//  DXPreConditionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DXPreConditionTestDelegate
@required
- (void)testFinished:(id)test;
@end

@protocol DXPreConditionTest <NSObject>
- (void)startTest:(id <DXPreConditionTestDelegate>)delegate;
- (bool)isFailFatal;
- (bool)isSuccess;
- (bool)isFinished;
- (NSString*)failTitle;
- (NSString*)failMessage;
@end
