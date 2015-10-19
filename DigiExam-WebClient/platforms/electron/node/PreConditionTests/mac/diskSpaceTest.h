//
//  DXDiskSpaceTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the enough disk space is free in order to run.
 */

//#import <Foundation/Foundation.h>
#include "basePreConditionTest.h"

class DiskSpaceTest : public basePreConditionTest
{
public:
	std::string _failTitle = "Not enough free disk space.";
    std::string _failMessage =  "You need to have at least 1GB free disk space to start DigiExam.";
	bool _isSuccess = false;
	bool _isFailFatal = true;


	bool isFailFatal();
	bool isSuccess();
	void startTest();
	std::string failTitle();
	std::string failMessage();

private:
	bool hasEnoughDiskSpace();

};
