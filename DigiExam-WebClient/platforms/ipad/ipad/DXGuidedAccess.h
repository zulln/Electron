//
//  DXKioskMode.h
//  ipad
//
//  Created by Fredrik Stockman on 04/08/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge.h"

@interface DXGuidedAccess : NSObject

+(void)lock;
+(void)unlock;
+(void)lockWithResponseCallback:(WVJBResponseCallback)responseCallback;
+(void)unlockWithResponseCallback:(WVJBResponseCallback)responseCallback;

@end
