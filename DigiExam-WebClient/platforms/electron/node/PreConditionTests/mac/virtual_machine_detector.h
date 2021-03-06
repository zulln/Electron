#ifndef VIRTUAL_MACHINE_DETECTOR_H
#define VIRTUAL_MACHINE_DETECTOR_H

//
//  VirtualMachineDetector.h
//  DigiExam
//
//  Created by Peter Hagvall on 2013-07-19.
//  Copyright (c) 2013 HagvallData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualMachineDetector : NSObject

- (BOOL)isRunningInVirtualMachine;

@end
#endif
