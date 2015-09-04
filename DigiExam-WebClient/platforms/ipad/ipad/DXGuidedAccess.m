//
//  DXKioskMode.m
//  ipad
//
//  Created by Fredrik Stockman on 04/08/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import "DXGuidedAccess.h"
#import <UIKit/UIKit.h>

@implementation DXGuidedAccess

+(void)lock {
    UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL didSucceed) {
        if (didSucceed) {
            NSLog(@"Successfully got guided access");
        } else {
            NSLog(@"Did not gain guided access. Is the app already locked or is the profile not set correctly / delivered over an MDM");
        }
    });
}

+(void)unlock {
    UIAccessibilityRequestGuidedAccessSession(NO, ^(BOOL didSucceed) {
        if (didSucceed) {
            NSLog(@"Successfully unlocked guided access");
        } else {
            NSLog(@"Did not unlock guided access. Is the app is already unlocked?");
        }
    });
}

+(void)lockWithResponseCallback:(WVJBResponseCallback)responseCallback {
    UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL didSucceed) {
        if (didSucceed) {
            responseCallback(@"true");
        } else {
            responseCallback(@"false");
        }
    });
}

+(void)unlockWithResponseCallback:(WVJBResponseCallback)responseCallback {
    UIAccessibilityRequestGuidedAccessSession(NO, ^(BOOL didSucceed) {
        if (didSucceed) {
            responseCallback(@"true");
        } else {
            responseCallback(@"false");
        }
    });
}

@end
