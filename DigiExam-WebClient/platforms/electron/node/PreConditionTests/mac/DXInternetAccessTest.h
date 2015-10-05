//
//  DXInternetConnectionTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXPreConditionTest.h"
#import "DXBasePreConditionTest.h"
//#import "DXServerPinger.h"

/*!
 * @brief Checks that access to the Internet is available.
 */
@interface DXInternetAccessTest : DXBasePreConditionTest <ServerPingerDelegate>

@end
