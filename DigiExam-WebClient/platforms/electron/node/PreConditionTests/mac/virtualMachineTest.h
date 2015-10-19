//
//  DXVirtualMachineTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

/*#import "preConditionTest.h"
#import "basePreConditionTest.h"
#import "virtualMachineDetector.h"

/*!
 * @brief Checks that DigiExam is not running in a virtual machine.
 */
//@interface DXVirtualMachineTest : DXBasePreConditionTest

//@end


#import <Foundation/Foundation.h>
#include "basePreConditionTest.h"

class VirtualMachineTest : public basePreConditionTest
{
public:
//	VirtualMachineTest();
//	~VirtualMachineTest();
	bool isFailFatal();
	bool isSuccess();
	void startTest();
	std::string failTitle();
	std::string failMessage();
	std::string _failTitle = "Virtual machine not allowed.";
    std::string _failMessage =  "You are running DigiExam in a virtual machine which is not allowed.";
	bool _isSuccess = false;
	bool _isFailFatal = true;

};
