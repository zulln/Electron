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
	bool isFailFatal();
	bool isSuccess();
	void startTest();
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "DigiExam is not installed.";
    std::string _failMessage =  "You need to copy DigiExam to Applications in order to run it.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
