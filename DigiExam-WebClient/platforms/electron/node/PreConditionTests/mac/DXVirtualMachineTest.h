//
//  DXVirtualMachineTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXPreConditionTest.h"
#import "DXBasePreConditionTest.h"
#import "DXVirtualMachineDetector.h"

/*!
 * @brief Checks that DigiExam is not running in a virtual machine.
 */
@interface DXVirtualMachineTest : DXBasePreConditionTest

@end
