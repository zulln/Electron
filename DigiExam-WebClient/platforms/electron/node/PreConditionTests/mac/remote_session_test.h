#ifndef REMOTE_SESSION_TEST_H
#define REMOTE_SESSION_TEST_H
//
//  diskSpaceTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the enough disk space is free in order to run.
 */
#import <Foundation/Foundation.h>
#import "../base_precondition_test.h"
#import "../test_object_factory.h"

namespace precondition {
	class RemoteSessionTest : public BasePreConditionTest
	{
	public:
		void startTest(Local<Function> callback);
		bool isFailFatal();
		bool isSuccess();
		std::string failTitle();
		std::string failMessage();
	private:
		bool _isSuccess = false;
		bool _isFailFatal = true;
		std::string _failTitle = "Remote session detected.";
	    std::string _failMessage =  "You are not allowed to run DigiExam with one or more remote sessions running";
	};
}
#endif
