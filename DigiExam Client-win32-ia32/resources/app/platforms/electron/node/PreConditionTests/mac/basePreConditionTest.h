//
//  DXBasePreConditionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//
/*
#import <Foundation/Foundation.h>
#import "preConditionTest.h"

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
*/
#ifndef BASE_PREC
#define BASE_PREC
class basePreConditionTest
{
public:
	virtual v8::Boolean isFailFatal() = 0;
	virtual v8::Boolean isSuccess() = 0;
	virtual v8::String::Utf8Value failTitle() = 0;
	virtual v8::String::Utf8Value failMessage() = 0;
private:
	v8::String::Utf8Value _failTitle, _failMessage;
	v8::Boolean _isSuccess, _isFailFatal;
};
#endif
