//
//  WifiOpenNetworkVerifier.h
//  DigiExam
//
//  Created by Peter Hagvall on 2013-04-11.
//  Copyright (c) 2013 HagvallData. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerPinger;

@protocol ServerPingerDelegate <NSObject>
@required
- (void)serverPingNetworkSuccess:(ServerPinger *)serverPinger openMode:(BOOL)openMode;
- (void)serverPingNetworkRedirect:(ServerPinger *)serverPinger openMode:(BOOL)openMode;
- (void)serverPingNetworkError:(ServerPinger *)serverPinger openMode:(BOOL)openMode error:(NSError *)error;
@end

@interface ServerPinger : NSObject <NSURLConnectionDelegate> {
    id<ServerPingerDelegate> delegate;
    BOOL networkOpenMode;
    BOOL isPingResponse;
    BOOL isRedirect;


}

- (id)initWithDelegate:(id<ServerPingerDelegate>)destinationDelegate openMode:(BOOL)openMode;
- (void)start;
@end
