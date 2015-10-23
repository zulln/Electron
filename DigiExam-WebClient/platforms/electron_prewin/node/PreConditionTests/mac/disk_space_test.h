#ifndef DISK_SPACE_TEST_H
#define DISK_SPACE_TEST_H
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
	class DiskSpaceTest : public BasePreConditionTest
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
		std::string _failTitle = "Not enough free disk space.";
	    std::string _failMessage =  "You need to have at least 1GB free disk space to start DigiExam.";
	};
}
#endif
