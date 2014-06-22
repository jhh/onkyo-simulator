//
//  DiscoveryResponse.m
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 6/22/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "DiscoveryResponse.h"

@implementation DiscoveryResponse

- (instancetype)initWithIdentifier:(NSString*)identifier
{
    self = [super init];
    if (self) {
        NSData *data = [DiscoveryResponse dataFromIdentifier:identifier];
        NSMutableData *tmpData = [NSMutableData dataWithCapacity:100];
        [tmpData appendData:[@"ISCP" dataUsingEncoding:NSASCIIStringEncoding]];
        uint32_t swapped_int = CFSwapInt32HostToBig(16);
        [tmpData appendBytes:&swapped_int length:sizeof(swapped_int)];
        swapped_int = CFSwapInt32HostToBig((uint32_t)[data length]);
        [tmpData appendBytes:&swapped_int length:sizeof(swapped_int)];
        swapped_int = CFSwapInt32HostToBig(0x01000000);
        [tmpData appendBytes:&swapped_int length:sizeof(swapped_int)];
        [tmpData appendData:data];
        _payload = [tmpData copy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithIdentifier:[[NSHost currentHost] localizedName]];
}

- (const void *)bytes
{
    return [self.payload bytes];
}

- (NSUInteger)length
{
    return [self.payload length];
}

+ (NSData *)dataFromIdentifier:(NSString *)identifier
{
    NSData *identifierData = [identifier dataUsingEncoding:NSASCIIStringEncoding
                                       allowLossyConversion:YES];
    identifierData = [identifierData  subdataWithRange:NSMakeRange(0, MIN(12, [identifierData length]))];

    NSMutableData *data = [NSMutableData dataWithCapacity:50];
    [data appendData:[@"!1ECNOnkyo Simulator/60128/DX/" dataUsingEncoding:NSASCIIStringEncoding]];
    [data appendData:identifierData];
    [data appendData:[@"\x0d\x0a" dataUsingEncoding:NSASCIIStringEncoding]];
    return data;
}

@end
