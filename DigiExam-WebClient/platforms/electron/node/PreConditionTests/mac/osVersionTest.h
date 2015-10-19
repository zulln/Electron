//
//  DXOsVersionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

//#import "basePreConditionTest.h
#import <Foundation/Foundation.h>
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
//	OSVersionTest();
//	~OSVersionTest();
	bool isFailFatal();
	bool isSuccess();
	void startTest();
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "Mac OS X version not supported.";
    std::string _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
