//
//  ViewController.m
//  ipad
//
//  Created by Fredrik Stockman on 16/07/15.
//  Copyright (c) 2015 DigiExam. All rights reserved.
//

#import "ViewController.h"
#import "DXJsMessageDispatcher.h"
#import "DXGuidedAccess.h"
#import <WebKit/WKWebView.h>
#import "GCDWebServer.h"

@interface ViewController ()
@property DXJsMessageDispatcher *jsMessageDispatcher;
@property WKWebView *webView;

@end

@implementation ViewController {
    GCDWebServer *_webServer;
}

- (void)viewDidLoad {
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-20-[_webView]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    
    [super viewDidLoad];
    [self openDigiExamWebApp];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DXGuidedAccess unlock];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDigiExamWebApp {
    _jsMessageDispatcher = [[DXJsMessageDispatcher alloc] initWithWebView:_webView];
    _webView.scrollView.scrollEnabled = NO;
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"index"
                                                         ofType:@"html"
                                                    inDirectory:@"bin"];
    
    
    
    _webServer = [[GCDWebServer alloc] init];
    [_webServer addGETHandlerForBasePath:@"/" directoryPath:[filePath stringByDeletingLastPathComponent] indexFilename:@"index.html" cacheAge:3600 allowRangeRequests:YES];
    [_webServer startWithPort:9090 bonjourName:nil];
    
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:9090/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:urlRequest];
}


- (NSString*)pathForWKWebView:(NSString*)filePath {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *tempDirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
    
    if ([fileManager fileExistsAtPath:tempDirPath]) {
        if (![fileManager removeItemAtPath:tempDirPath error:&error]) {
            NSLog(@"Failed to delete tmp directory: %@", error);
        }
    }
    
    NSString *srcDirPath = [filePath stringByDeletingLastPathComponent];
    
    if (![fileManager copyItemAtPath:srcDirPath toPath:tempDirPath error:&error]) {
        NSLog(@"Failed to copy: %@", error);
    }
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:tempDirPath error:&error];
    
    for (NSString* file in files) {
        NSLog(@"File: %@", file);
    }
    
    
    
    return [tempDirPath stringByAppendingPathComponent:@"/index.html"];
}

@end
