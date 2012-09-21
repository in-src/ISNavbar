//
//  AppDelegate.m
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import "InAppStoreWindow.h"
#import "ISNavbarView.h"
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
    navbarView = [[ISNavbarView alloc] initWithFrame:NSZeroRect];
    [navbarView addToWindow:aWindow];
}

- (IBAction)pushTitle:(id)sender
{
    NSString *title = [NSString stringWithFormat:@"Title %ld", counter];
    counter += 1;
    [navbarView pushTitle:title];
}

- (IBAction)popTitle:(id)sender {
    [navbarView popTitle];
}
@end
