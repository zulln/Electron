#ifndef OSVERSIONTEST_H
#define OSVERSIONTEST_H
#import "basePreConditionTest.h"
//
//  osVersionTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the OS version is correct.
 */
class OSVersionTest : public BasePreConditionTest
{
public:
	bool isFailFatal();
	bool isSuccess();
	void startTest(Local<Function> callback);
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "Mac OS X version not supported.";
	std::string _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
#endif
