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

//#import <Foundation/Foundation.h>
#include <string>

#ifndef BASE_PREC
#define BASE_PREC
class basePreConditionTest
{
public:
	virtual bool isFailFatal() = 0;
	virtual bool isSuccess() = 0;
	virtual void startTest() = 0;
	virtual std::string failTitle() = 0;
	virtual std::string failMessage() = 0;
protected:
	//virtual ~BasePreConditionTest();
	std::string _failTitle, _failMessage;
	bool _isSuccess, _isFailFatal;
};
#endif
