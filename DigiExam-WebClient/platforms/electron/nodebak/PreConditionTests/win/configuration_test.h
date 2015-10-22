#ifndef CONFIGURATION_TEST_H
#define CONFIGURATION_TEST_H
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
 #import "../base_precondition_test.h"
 #import "../test_object_factory.h"

namespace precondition {

class ConfigurationTest : public BasePreConditionTest
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
	std::string _failTitle = "The Config.json is invalid.";
    std::string _failMessage =  "The Configuration file seems to be invalid, probably apiEndpoint that is malformatted.";
};

}
#endif
