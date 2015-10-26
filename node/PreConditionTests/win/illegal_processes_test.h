#ifndef ILLEGAL_PROCESSES_TEST_H
#define ILLEGAL_PROCESSES_TEST_H
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

class IllegalProcessesTest : public BasePreConditionTest
{

typedef std::string processString;

public:
	void startTest(Local<Function> callback);
	bool isFailFatal();
	bool isSuccess();
	std::string failTitle();
	std::string failMessage();
private:
	bool _isSuccess = false;
	bool _isFailFatal = true;
	std::string _failTitle = "Check for processes that interfers with DigiExam.";
  std::string _failMessage =  "Processes that interfer with DigiExam was found.";
  //std::string _failMessage2 = "Please close the following processes and restart DigiExam:";
  processString str1 = "vncserver";
  processString str2 = "tvnserver";

  std::string strArray[2];

  };

}
#endif
