//
//  DiscoveryResponse.h
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 6/22/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryResponse : NSObject

@property(readonly, copy, nonatomic) NSData *payload;

- (instancetype)initWithIdentifier:(NSString*)identifier;
- (const void *)bytes;
- (NSUInteger)length;
+ (NSData *)dataFromIdentifier:(NSString *)identifier;

@end
