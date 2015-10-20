#ifndef INSTALLEDTEST_H
#define INSTALLEDTEST_H
//
//  DXInstalledTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

//#import "basePreConditionTest.h"
//#import <Foundation/Foundation.h>
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
