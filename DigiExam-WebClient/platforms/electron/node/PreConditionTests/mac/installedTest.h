//
//  DXInstalledTest.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

//#import "basePreConditionTest.h"
#import <Foundation/Foundation.h>

/*!
 * @brief Checks that DigiExam is installed and not run from a mounted .dmg.
 */
@interface DXInstalledTest : NSObject //: DXBasePreConditionTest
	bool IsInstalled();
@end
