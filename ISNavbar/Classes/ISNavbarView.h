//
//  ISNavbarView.h
//  ISNavbar
//
//  Created by Robin Lu on 9/20/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class INAppStoreWindow;

@interface ISNavbarView : NSView
{
    NSMutableArray *titles;
    NSTextField     *currentTitleField;
    CGFloat         startX;
}

- (void)addToWindow:(INAppStoreWindow*)window;
- (void)pushTitle:(NSString*)title;
- (void)popTitle;
@end
