//
//  DXInstalledTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

//#import "basePreConditionTest.h"
#import <Foundation/Foundation.h>
#include "basePreConditionTest.h"
/*!
 * @brief Checks that DigiExam is installed and not run from a mounted .dmg.
 *//*
@interface DXInstalledTest : DXBasePreConditionTest
@end
*/


class InstalledTest : public basePreConditionTest
{
public:
	InstalledTest();
	~InstalledTest();
	v8::Boolean isFailFatal();
	v8::Boolean isSuccess();
	v8::String::Utf8Value failTitle();
	v8::String::Utf8Value failMessage();
};
