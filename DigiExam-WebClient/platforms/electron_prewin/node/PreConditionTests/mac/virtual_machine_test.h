#ifndef VIRTUAL_MACHINE_TEST_H
#define VIRTUAL_MACHINE_TEST_H
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
#import <Foundation/Foundation.h>
#import "../base_precondition_test.h"
#import "../test_object_factory.h"
#import "virtual_machine_detector.h"

namespace precondition {
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
}
#endif
