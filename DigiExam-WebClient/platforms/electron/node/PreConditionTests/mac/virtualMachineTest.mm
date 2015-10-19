//
//  DXVirtualMachineTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//
/*
#import "virtualMachineTest.h"

@implementation DXVirtualMachineTest

- (id)init {
    self = [super init];

    if (self) {
        _isFailFatal = YES;
        _failTitle = @"Virtual machine not allowed.";
        _failMessage =  @"You are running DigiExam in a virtual machine which is not allowed.";
    }

    return self;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

    VirtualMachineDetector *virtualMachineDetector = [[VirtualMachineDetector alloc] init];

    if (![virtualMachineDetector isRunningInVirtualMachine]) {
        _isSuccess = YES;
    }

    _isFinished = YES;

    [_delegate testFinished:self];
}

@end*/


#include "virtualMachineTest.h"
    /*std::string _failTitle = "Mac OS X version not supported.";
    std::string _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
*/
	//bool VirtualMachineTest::_isSuccess;

bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}
void VirtualMachineTest::startTest(){


    //if (NSAppKitVersionNumber10_8 <= NSAppKitVersionNumber) {
    /*if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ver]){
	    _isSuccess = true;
    }
	else
		_isSuccess = false;*/
}
//std::string VirtualMachineTest::failTitle(){ return "Mac OS X version not supported.";}
//std::string VirtualMachineTest::failMessage(){ return "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";}
std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}
