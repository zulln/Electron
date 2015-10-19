//
//  DXOsVersionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

//#import "basePreConditionTest.h
#include "basePreConditionTest.h"

/*!
 * @brief Checks that the version of Mac OS X is supported
 */
/*@interface DXOSVersionTest : DXBasePreConditionTest

@end
*/

//#include "basePreConditionTest.h"

class OSVersionTest : public basePreConditionTest
{
public:
	OSVersionTest();
	~OSVersionTest();
	v8::Boolean isFailFatal();
	v8::Boolean isSuccess();
	v8::String::Utf8Value failTitle();
	v8::String::Utf8Value failMessage();
};
