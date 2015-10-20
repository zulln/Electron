#ifndef VIRTUALMACHINETEST_H
#define VIRTUALMACHINETEST_H
#import "basePreConditionTest.h"
#import "virtualMachineDetector.h"
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
class VirtualMachineTest : public BasePreConditionTest
{
public:
	bool isFailFatal();
	bool isSuccess();
	void startTest(Local<Function> callback);
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "Virtual machine not allowed.";
    std::string _failMessage =  "You are running DigiExam in a virtual machine which is not allowed.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
#endif
