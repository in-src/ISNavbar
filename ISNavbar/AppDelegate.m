//
//  AppDelegate.m
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import "InAppStoreWindow.h"
#import "ISSeparatorLabel.h"
#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    INAppStoreWindow *aWindow = (INAppStoreWindow*)self.window;
    aWindow.titleBarHeight = 35;
    ISSeparatorLabel *button = [[ISSeparatorLabel alloc] init];
    button.title = @"Timeline";
    button.target = self;
    button.action = @selector(doAction:);
    NSButton *zoom = [aWindow standardWindowButton:NSWindowZoomButton];
    NSRect frame = button.frame;
    frame.origin.x = zoom.frame.origin.x + zoom.frame.size.width + 16;
    [button setFrame:frame];
    [aWindow.titleBarView addSubview:button];
}

- (IBAction)doAction:(id)sender
{
    NSLog(@"Done");
}
@end
