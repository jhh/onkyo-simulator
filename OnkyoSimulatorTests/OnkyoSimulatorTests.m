//
//  OnkyoSimulatorTests.m
//  OnkyoSimulatorTests
//
#//  Created by Jeff Hutchison on 7/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DiscoveryResponse.h"

@interface OnkyoSimulatorTests : XCTestCase

@property(nonatomic) NSString *magic;
@property(nonatomic) NSUInteger headerLength;
@property(nonatomic) NSUInteger dataLength;
@property(nonatomic) NSUInteger version;
@property(nonatomic) NSString *model;
@property(nonatomic) NSString *uniqueIdentifier;

@end

@implementation OnkyoSimulatorTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testDiscoveryResponse
{
    DiscoveryResponse *resp = [[DiscoveryResponse alloc] init];
    XCTAssertNotNil(resp);
    [self parseResponse:resp];
    XCTAssertEqualObjects(self.model, @"Onkyo Simulator");
}

- (void)testASCIIConversion
{
    NSData *responseData = [DiscoveryResponse dataFromIdentifier:@"José's Cömpüter"];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(response, @"!1ECNOnkyo Simulator/60128/DX/Jose's Compu\x0d\x0a");

    responseData = [DiscoveryResponse dataFromIdentifier:@"François"];
    response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(response, @"!1ECNOnkyo Simulator/60128/DX/Francois\x0d\x0a");

    // from http://www.columbia.edu/~kermit/utf8.html
    responseData = [DiscoveryResponse dataFromIdentifier:@"मैं काँच खा सकता हूँ और मुझे उससे कोई चोट नहीं पहुंचती"];
    response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(response, @"!1ECNOnkyo Simulator/60128/DX/??? ???? ?? \x0d\x0a");

}

- (void)parseResponse:(DiscoveryResponse *)response
{
    NSData *packet = [NSData dataWithBytes:response.bytes length:response.length];
    self.magic = [[NSString alloc] initWithData:[packet subdataWithRange:NSMakeRange(0, 4)] encoding:NSASCIIStringEncoding];

    uint32_t buffer = 0;
    [packet getBytes:&buffer range:NSMakeRange(4, 4)];
    self.headerLength = CFSwapInt32BigToHost(buffer);

    [packet getBytes:&buffer range:NSMakeRange(8, 4)];
    self.dataLength = CFSwapInt32BigToHost(buffer);

    [packet getBytes:&buffer range:NSMakeRange(12, 1)];
    self.version = buffer;

    // strip off message delimiters "!1"
    NSString *payload = [[NSString alloc] initWithData:[packet subdataWithRange:NSMakeRange(self.headerLength, self.dataLength)]
                                              encoding:NSASCIIStringEncoding];

    NSArray *components = [payload componentsSeparatedByString:@"/"];
    self.model = [components[0] substringFromIndex:5]; // trim leading '!1ECN'
    self.uniqueIdentifier = components[3]; // MAC address, max length 12 per onkyo docs
}

@end
