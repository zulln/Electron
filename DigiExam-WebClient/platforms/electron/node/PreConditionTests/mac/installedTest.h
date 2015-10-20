#ifndef INSTALLEDTEST_H
#define INSTALLEDTEST_H
//
//  installedTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the dmg is installed in the Applications folder and isn't
 		  mounted.
 */
#import "basePreConditionTest.h"

using namespace v8;

class InstalledTest : public BasePreConditionTest
{
public:
	bool isFailFatal();
	bool isSuccess();
	//void startTest();
	void startTest(Local<Function> callback);
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "DigiExam is not installed.";
    std::string _failMessage =  "You need to copy DigiExam to Applications in order to run it.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
#endif
