//
//  DiscoveryListener.m
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 7/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//
@import Darwin;
#import "DiscoveryListener.h"
#import "AppDelegate.h"

#define BUFLEN 100

@implementation DiscoveryListener

- (instancetype)initWithDelegate:(AppDelegate *)delegate
{
    self = [super init];
    if (self == nil) return nil;
    _delegate = delegate;
    _sock = [self setup_sock];
    _closed = NO;
    _response = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"eiscp" withExtension:@"dat"]];
    return self;
}

- (void)start
{
    [self performSelectorInBackground:@selector(respond) withObject:nil];
}

- (void)close
{
    if (close(_sock) == -1) {
        NSLog(@"%s close: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
    _closed = YES;
}


- (int)setup_sock
{
    int sock;
    struct sockaddr_in my_addr;
    // UDP socket
    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
        NSLog(@"%s socket: %s", __PRETTY_FUNCTION__, strerror(errno));
    }

    bzero(&my_addr, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_addr.s_addr = INADDR_ANY;
    my_addr.sin_port = htons(60128);

    if (bind(sock, (struct sockaddr *)&my_addr, sizeof my_addr) == -1) {
        NSLog(@"%s bind: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
    return sock;
}

- (void) respond
{
    struct sockaddr_in their_addr;
    socklen_t their_addr_len = sizeof their_addr;
    ssize_t numbytes;
    char recv_buf[BUFLEN];

    bzero(&recv_buf, BUFLEN);
    if ((numbytes = recvfrom(_sock, recv_buf, BUFLEN, 0, (struct sockaddr *)&their_addr, &their_addr_len)) == -1) {
        NSLog(@"%s recvfrom: %s", __PRETTY_FUNCTION__, strerror(errno));
        return;
    }

    [self log:[NSString stringWithFormat:@"received %li bytes from %s", numbytes, inet_ntoa(their_addr.sin_addr)]];

    if ((numbytes = sendto(_sock, [_response bytes], [_response length], 0, (struct sockaddr *)&their_addr, their_addr_len)) == -1) {
        NSLog(@"%s sendto: %s", __PRETTY_FUNCTION__, strerror(errno));
        return;
    }

    [self log:[NSString stringWithFormat:@"sent %li bytes to %s", numbytes, inet_ntoa(their_addr.sin_addr)]];
    if (!self.isClosed) {
        [self performSelectorInBackground:@selector(respond) withObject:nil];
    }
}

- (void)log:(NSString *)msg
{
    [_delegate performSelectorOnMainThread:@selector(logToTextView:) withObject:msg waitUntilDone:NO];
}

@end