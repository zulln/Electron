//
//  ServerPinger.m
//  DigiExam
//
//  Intended to use to ping the DigiExam server to make sure we have a network connection.
//  When the student hand in the examination it is critical to know whether we have a connection or not.
//
//  Created by Peter Hagvall on 2013-04-11.
//  Copyright (c) 2013 HagvallData. All rights reserved.
//

#import "ServerPinger.h"
#import "Environment.h"
#import "Logger.h"

@interface ServerPinger ()
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation ServerPinger

- (id)initWithDelegate:(id<ServerPingerDelegate>)destinationDelegate openMode:(BOOL)openMode {
    delegate = destinationDelegate;
    networkOpenMode = openMode;
    isPingResponse = NO;
    isRedirect = NO;
    self.responseData = [NSMutableData data];
    return [super init];
}

- (void)start {
    NSString *serviceHost = [[Environment sharedInstance] valueForKey:@"server"];
    NSString *url = [NSString stringWithFormat:@"%@/ping", serviceHost];

    NSNumber *timeInterval = [[Environment sharedInstance] valueForKey:@"pingServerTimeout"];
    NSTimeInterval timeout = [timeInterval doubleValue];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:timeout];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:[@"" dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection connectionWithRequest:request delegate:self];
}

// NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    isPingResponse = statusCode == 200;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    [self.responseData setLength:0]; // clear buffer
    [[Logger sharedInstance] logInfo:[NSString stringWithFormat:@"Server ping connection did fail with error: %@\nResponse: %@", [error description], responseString]];
    [delegate serverPingNetworkError:self openMode:networkOpenMode error:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	[self.responseData setLength:0]; // clear buffer
    NSString *validResponse = @"PONG";

    if (isPingResponse && [[responseString uppercaseString] isEqualToString:validResponse]) {
        [delegate serverPingNetworkSuccess:self openMode:networkOpenMode];
    } else if (isRedirect) {
        [delegate serverPingNetworkRedirect:self openMode:networkOpenMode];
    } else {
        [delegate serverPingNetworkError:self openMode:networkOpenMode error:nil];
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSURLProtectionSpace * protectionSpace = [challenge protectionSpace];
    NSURLCredential* credential = [NSURLCredential credentialForTrust:[protectionSpace serverTrust]];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    [[Logger sharedInstance] logInfo:[NSString stringWithFormat:@"connectionShouldUseCredentialStorage"]];
    return YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    [[Logger sharedInstance] logInfo:[NSString stringWithFormat:@"willCacheResponse"]];
    return cachedResponse;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[Logger sharedInstance] logInfo:[NSString stringWithFormat:@"didReceiveAuthenticationChallenge: %@", challenge]];

    NSURLProtectionSpace * protectionSpace = [challenge protectionSpace];
    NSURLCredential *credential = [NSURLCredential credentialForTrust:[protectionSpace serverTrust]];

    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];

}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[Logger sharedInstance] logInfo:[NSString stringWithFormat:@"didCancelAuthenticationChallenge"]];
}

// Redirect
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    isRedirect = NO;
    if (redirectResponse) {
        isRedirect = YES;
    }
    return request;


}


@end
