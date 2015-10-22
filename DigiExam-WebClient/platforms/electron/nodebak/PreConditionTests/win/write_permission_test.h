#ifndef WRITE_PERMISSION_TEST_H
#define WRITE_PERMISSION_TEST_H
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

	class WritePermissionTest : public BasePreConditionTest
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
		std::string _failTitle = "DigiExam does not have write permission in the cache directory on the file system.";
	    std::string _failMessage =  "If you are running as administrator and still get this error message, please contact DigiExam for further troubleshooting.";
	};

}
#endif
