//
//  AppDelegate.h
//  OnkyoSimulator
//
//  Created by Jeff Hutchison on 7/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DiscoveryListener;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    @private
    NSDictionary *_eventAttrs;
    NSDateFormatter *_dateFormatter;
    DiscoveryListener *_discoveryListener;
}

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

- (IBAction)closeDiscoverySocket:(id)sender;

- (void)logToTextView:(NSString *)msg;

@end
