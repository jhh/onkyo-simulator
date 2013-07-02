//
//  DiscoveryListener.h
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 7/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;

@interface DiscoveryListener : NSObject {
    __weak AppDelegate *_delegate;
    int _sock;
    NSData *_response;
}

@property (readonly, getter = isClosed) BOOL closed;

- (instancetype)initWithDelegate:(id)delagate;
- (void)start;
- (void)close;

@end
