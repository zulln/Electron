#ifndef REMOTE_DESKTOP_TEST_H
#define REMOTE_DESKTOP_TEST_H
//
//  adminPermissionTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-21.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the application is started as Administrator.
 */
#include "../base_precondition_test.h"
#include "../test_object_factory.h"

namespace precondition {

	class RemoteDesktopTest : public BasePreConditionTest
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
		std::string _failTitle = "DigiExam is running in a remote session.";
	    std::string _failMessage =  "You are not allowed to run DigiExam in a remote session.";
	};

}
#endif
