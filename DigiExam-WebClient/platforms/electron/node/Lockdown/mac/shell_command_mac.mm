//
//  DXShellCommand.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "shell_command_mac.h"

@implementation DXShellCommand

/**
 * @brief Executes the commandToRun and returns stdout as NSString
 */
+ (NSString *)run:(NSString *)commandToRun {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];

    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];

    [task setArguments: arguments];

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *file = [pipe fileHandleForReading];

    [task launch];

    NSData *data = [file readDataToEndOfFile];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
