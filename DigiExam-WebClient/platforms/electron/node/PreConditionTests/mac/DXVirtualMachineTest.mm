//
//  DXVirtualMachineTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "DXVirtualMachineTest.h"

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

@end
