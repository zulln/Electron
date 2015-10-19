//
//  DXJsMessageDispatcher.h
//  ipad
//
//  Created by Fredrik Stockman on 04/08/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

@interface DXJsMessageDispatcher : NSObject
- (id)initWithWebView:(WKWebView*)aWebView;
@end
