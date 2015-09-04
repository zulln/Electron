//
//  DXJsMessageDispatcher.m
//  ipad
//
//  Created by Fredrik Stockman on 04/08/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import "DXJsMessageDispatcher.h"
#import "DXFileSystem.h"
#import "DXGuidedAccess.h"
#import "WKWebViewJavascriptBridge.h"

// Apple documentation for how to inject Obj-C stuff to JS: https://developer.apple.com/library/mac/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/ObjCFromJavaScript.html#//apple_ref/doc/uid/30001215-120402


@interface DXJsMessageDispatcher ()

@property (strong) WKWebView *webview;
@property (strong) DXFileSystem *dxFileSystem;
@property WKWebViewJavascriptBridge* bridge;
@end

@implementation DXJsMessageDispatcher

- (id)initWithWebView:(WKWebView*)aWebView {
    self = [self init];
    
    if (self) {
        _webview = aWebView;
        _dxFileSystem = [[DXFileSystem alloc] init];
        
        /*_bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webview handler:];*/
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webview handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"Received message from javascript: %@ %@", (NSString *)data, responseCallback);
            [self dispatchOnJsMessage:data withResponseCallback:responseCallback];
        }];
    }
    
    return self;
}

- (void)dispatchOnJsMessage:(id)data withResponseCallback:(WVJBResponseCallback)responseCallback {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *command = [data objectForKey:@"command"];
        NSDictionary *extractedData = data[@"data"];
        
        NSString *result = nil;
        // File system
        
        // Make directory
        if ([command isEqualToString:@"make_dir"]) {
            result = [self.dxFileSystem makeDir:[extractedData[@"path"] stringByAppendingPathComponent:extractedData[@"name"]]] ? @"true" : @"false";
        }
        // Read file
        else if ([command isEqualToString:@"read_file"]) {
            result = [self.dxFileSystem readFile:[extractedData[@"path"] stringByAppendingPathComponent:extractedData[@"name"]]];
        }
        // Write file
        else if ([command isEqualToString:@"write_file"]) {
            BOOL successful = [self.dxFileSystem writeFileToPath:extractedData[@"path"] andFileName:extractedData[@"filename"] withContent:extractedData[@"data"]];
            result = successful ? @"true" : @"false";
        }
        // List directory (NOTE: Returns a string due to bridge only supports sending strings to js)
        else if ([command isEqualToString:@"list_directory"]) {
            result = [[self.dxFileSystem listDirectory:extractedData[@"path"]] description];
        }
        
        // Local Storage
        
        // Get
        else if ([command isEqualToString:@"get_local_storage_key"]) {
            result = [self.dxFileSystem getLocalStorageKey:extractedData[@"key"]];
        }
        // Set
        else if ([command isEqualToString:@"set_local_storage_key"]) {
            result = [self.dxFileSystem setLocalStorageKey:extractedData[@"key"] value:extractedData[@"value"]] ? @"true" : @"false";
        }
        // Remove
        else if ([command isEqualToString:@"remove_local_storage_key"]) {
            result = [self.dxFileSystem removeLocalStorageKey:extractedData[@"key"]] ? @"true" : @"false";
        }
        // Clear
        else if ([command isEqualToString:@"clear_local_storage"]) {
            result = [self.dxFileSystem clearLocalStorage] ? @"true" : @"false";
        }
        
        // Lock to guided access
        else if ([command isEqualToString:@"lock_to_guided_access"]) {
            [DXGuidedAccess lockWithResponseCallback:responseCallback];
        }
        
        // Unlock from guided access
        else if ([command isEqualToString:@"unlock_from_guided_access"]) {
            [DXGuidedAccess unlockWithResponseCallback:responseCallback];
        }
        
        // Unknown command
        else {
            NSLog(@"Unknown command %@", command);
        }
        
        if (result) {
            responseCallback(result);
        }
    }
}

@end
