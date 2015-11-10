//
//  DXShellCommand.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief Simple way to execute shell commands.
 */
@interface DXShellCommand : NSObject
+ (NSString *)run:(NSString *)commandToRun;
@end
