#ifndef VIRTUALMACHINETEST_H
#define VIRTUALMACHINETEST_H
//
//  VirtualMachineTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that no VM instance is running
 */
 #import "basePreConditionTest.h"
 #import "virtualMachineDetector.h"
 #import "objectFactory.h"

class VirtualMachineTest : public BasePreConditionTest
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
	std::string _failTitle = "Virtual machine not allowed.";
	std::string _failMessage =  "You are running DigiExam in a virtual machine which is not allowed.";
};
#endif
