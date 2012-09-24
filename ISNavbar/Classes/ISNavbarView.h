//
//  ISNavbarView.h
//  ISNavbar
//
//  Created by Robin Lu on 9/20/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class INAppStoreWindow;
@class ISSeparatorLabel;

@interface ISNavbarView : NSView
{
    NSMutableArray *titles;
    NSTextField     *currentTitleField;
    ISSeparatorLabel *currentLeftNavButton;
    CGFloat         startX;
    
    // animation
    NSMutableArray *removingView;
}

- (void)addToWindow:(INAppStoreWindow*)window;
- (void)pushTitle:(NSString*)title;
- (void)popTitle;
- (IBAction)pop:(id)sender;
@end
