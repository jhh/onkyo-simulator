//
//  AppDelegate.m
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 7/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Darwin;
#import "AppDelegate.h"
#import "DiscoveryListener.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    _eventAttrs = @{ NSFontAttributeName : font };
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [_dateFormatter stringFromDate:[NSDate date]], @"Starting..."];
    [self logToTextView:message];
    _discoveryListener = [[DiscoveryListener alloc] initWithDelegate:self];
    [_discoveryListener start];
}

- (IBAction)closeDiscoverySocket:(id)sender
{
    [_discoveryListener close];
}

- (void)logToTextView:(NSString *)logMessage
{
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [_dateFormatter stringFromDate:[NSDate date]], logMessage];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:_eventAttrs];
    NSTextStorage *text = self.textView.textStorage;
    [text beginEditing];
    [text appendAttributedString:as];
    [text endEditing];
    [self.textView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}


@end
