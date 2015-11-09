#ifndef OS_VERSION_TEST_H
#define OS_VERSION_TEST_H
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
#import <Foundation/Foundation.h>
#import "../base_precondition_test.h"
#import "../test_object_factory.h"

namespace precondition {
	class OSVersionTest : public BasePreConditionTest
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
		std::string _failTitle = "Mac OS X version not supported.";
		std::string _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
	};
}
#endif
