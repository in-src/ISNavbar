//
//  AppDelegate.h
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ISNavbarView *navbarView;
    NSInteger counter;
}
@property (assign) IBOutlet NSWindow *window;

- (IBAction)doAction:(id)sender;
@end
