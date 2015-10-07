//
//  VirtualMachineDetector.m
//  DigiExam
//
//  Created by Peter Hagvall on 2013-07-19.
//  Copyright (c) 2013 HagvallData. All rights reserved.
//

#import "virtualMachineDetector.h"
//#import "Logger.h"

@implementation VirtualMachineDetector

- (BOOL)isRunningInVirtualMachine {
    BOOL checkVMM = YES;
    BOOL virtualMachineDetected = NO;
    NSString *logText;
    NSString *taskResponse = [self taskResponse:checkVMM];
    if (taskResponse && [taskResponse length] > 0 ) {
        virtualMachineDetected = YES;
        checkVMM = NO;
        taskResponse = [self taskResponse:checkVMM];
        taskResponse = [taskResponse lowercaseString];
        NSRange range = [taskResponse rangeOfString:@"vmware"];
        if (range.location != NSNotFound) {
            logText = @"VMWare virtual machine IS probably detected!";
        } else {
            range = [taskResponse rangeOfString:@"prlufs."];
            if (range.location != NSNotFound) {
                logText = @"Parallells virtual machine IS probably detected!";
            } else {
                logText = @"Other virtual machine IS probably detected!";
            }
        }
        logText = [NSString stringWithFormat:@"%@\n%@", logText, taskResponse];
    } else {
        logText = @"No virtual machine is detected.";
    }

    //[[Logger sharedInstance] logInfo:logText];

    return virtualMachineDetected;
}

- (NSString *)taskResponse:(BOOL)checkVMM {
    NSTask *task = [[NSTask alloc] init];
    [task waitUntilExit];

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *file = [pipe fileHandleForReading];

    if (checkVMM) {
        [task setLaunchPath: @"/bin/sh"];
        [task setArguments: [NSArray arrayWithObjects:@"-c", @"/usr/sbin/sysctl -A | grep machdep.cpu.features | grep VMM", nil]];
    } else {
        [task setLaunchPath: @"/usr/sbin/sysctl"];
        [task setArguments: [NSArray arrayWithObject:@"-A"]];
    }

    [task launch];

    NSData *data = [file readDataToEndOfFile];
    NSString *taskResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return taskResponse;
}

@end
