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

@protocol ISNavbarDelegate <NSObject>

@optional
- (void)willPush;
- (void)willPop;

- (void)shouldPop;

@end

@interface ISNavbarView : NSView
{
    NSMutableArray *titles;
    NSTextField     *currentTitleField;
    ISSeparatorLabel *currentLeftNavButton;
    CGFloat         startX;
    
    // animation
    NSMutableArray *removingView;
    
    id <ISNavbarDelegate> delegate;
}

@property (nonatomic, assign)  id <ISNavbarDelegate> delegate;

- (void)addToWindow:(INAppStoreWindow*)window;

- (void)pushTitle:(NSString*)title;
- (void)popTitle;
- (void)popToTop;
- (void)preparePopToTop;

- (IBAction)pop:(id)sender;
@end
