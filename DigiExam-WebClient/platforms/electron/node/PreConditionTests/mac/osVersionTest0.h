//
//  DXOsVersionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

/*#import "basePreConditionTest.h"

/*!
 * @brief Checks that the version of Mac OS X is supported
 */
/*@interface DXOSVersionTest : DXBasePreConditionTest

@end
*/

#include "basePreConditionTest.h"

class OSVersionTest : public basePreConditionTest
{
public:
	virtual v8::Boolean isFailFatal();
	virtual v8::Boolean isSuccess();
	virtual v8::String failTitle();
	virtual v8::String failMessage();
};
