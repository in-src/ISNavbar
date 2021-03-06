//
//  ISNavbarView.m
//  ISNavbar
//
//  Created by Robin Lu on 9/20/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import <QuartzCore/CATransaction.h>

#import "InAppStoreWindow.h"
#import "ISSeparatorLabel.h"

#import "ISNavbarView.h"

#define MARGIN 16

#define REMOVE_TO_LEFT  0
#define REMOVE_TO_RIGHT 1
#define REMOVE_TO_MID   2

#define ADD_FROM_LEFT   0
#define ADD_FROM_RIGHT  1
#define ADD_FROM_MID    2

@implementation ISNavbarView
@synthesize delegate;

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        titles = [[NSMutableArray alloc] init];
        removingView = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [titles release];
    [removingView release];
    [super dealloc];
}

- (void)setTitleFieldFrame:(NSView*)titleField
{
    NSRect frame = [titleField frame];
    frame.origin.x = (self.bounds.size.width - frame.size.width)/2.0;
    frame.origin.y = (self.bounds.size.height - frame.size.height)/2.0;
    [titleField setFrame:frame];
}

- (NSTextField *)buildTitleField:(NSString *)title
{
    NSTextField *titleField = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
    titleField.stringValue = title;
    [titleField setBordered:NO];
    [titleField setEditable:NO];
    [titleField setDrawsBackground:NO];
    [titleField setAlignment:NSCenterTextAlignment];
    [titleField setTextColor:[NSColor darkGrayColor]];
    [titleField setFont:[NSFont systemFontOfSize:13]];
    [titleField setAutoresizingMask:NSViewMaxXMargin|NSViewMinXMargin];
    [titleField sizeToFit];
    [self setTitleFieldFrame:titleField];
    return titleField;
}

- (void)setNavButtonFrame:(NSView*)navButton
{
    NSRect frame = navButton.frame;
    frame.origin.x = startX;
    frame.origin.y = 1;
    frame.size.height = self.bounds.size.height - 1;
    navButton.frame = frame;
}

- (ISSeparatorLabel *)buildNavButtonWithTitle:(NSString *)currentTitle
{
    ISSeparatorLabel * navButton = [[[ISSeparatorLabel alloc] initWithTitle:currentTitle] autorelease];
    [self setNavButtonFrame:navButton];
    navButton.target = self;
    navButton.action = @selector(pop:);
    return navButton;
}

- (void)pushTitle:(NSString*)title
{
    if ([delegate respondsToSelector:@selector(willPush)]) {
        [delegate willPush];
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self afterAnimation];
    }];
    [[NSAnimationContext currentContext] setDuration:0.2];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

    if (currentTitleField) {
        [self removeView:currentTitleField direction:REMOVE_TO_LEFT];
        
        if (currentLeftNavButton) {
            [self removeView:currentLeftNavButton direction:REMOVE_TO_LEFT];
        }
        
        NSString *currentTitle = [titles lastObject];
        ISSeparatorLabel *navButton;
        navButton = [self buildNavButtonWithTitle:currentTitle];
        [self addView:navButton direction:ADD_FROM_MID];
        currentLeftNavButton = navButton;
    }
    [titles addObject:title];

    NSTextField *titleField;
    titleField = [self buildTitleField:title];
    [self addView:titleField direction:ADD_FROM_RIGHT];
    currentTitleField = titleField;
    [NSAnimationContext endGrouping];
}

- (void)popTitle
{
    GTMLoggerDebug(@"titles %@", titles);
    if ([titles count] == 0) {
        return;
    }

    if ([delegate respondsToSelector:@selector(willPop)]) {
        [delegate willPop];
    }
    
    [titles removeLastObject];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self afterAnimation];
        if ([titles count] >= 1) {
            currentTitleField = [self buildTitleField:[titles lastObject]];
            [self addSubview:currentTitleField];
        }
    }];
    [[NSAnimationContext currentContext] setDuration:0.2];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    if (currentTitleField) {
        [self removeView:currentTitleField direction:REMOVE_TO_RIGHT];
        currentTitleField = nil;
    }
    if (currentLeftNavButton) {
        [self removeView:currentLeftNavButton direction:REMOVE_TO_MID];
        currentLeftNavButton = nil;
    }
    if ([titles count] >= 2) {
        currentLeftNavButton = [self buildNavButtonWithTitle:[titles objectAtIndex:([titles count] - 2)]];
        [self addView:currentLeftNavButton direction:ADD_FROM_LEFT];
    }
    [NSAnimationContext endGrouping];
}

- (void)preparePopToTop
{
    while ([titles count] > 2) {
        [titles removeLastObject];
    }
}

- (void)popToTop
{
    [self preparePopToTop];
    [self popTitle];
}

- (IBAction)pop:(id)sender
{
    if ([delegate respondsToSelector:@selector(shouldPop)]) {
        [delegate shouldPop];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
}

- (void)addToWindow:(INAppStoreWindow*)aWindow
{
    NSButton *zoom = [aWindow standardWindowButton:NSWindowZoomButton];
    NSRect frame = [aWindow.titleBarView frame];
    startX = zoom.frame.origin.x + zoom.frame.size.width + MARGIN;
    [self setFrame:frame];
    [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [aWindow.titleBarView addSubview:self];
    [self setNavButtonFrame:currentLeftNavButton];
    [self setTitleFieldFrame:currentTitleField];
}

#pragma mark -
#pragma mark animation
- (void)removeView:(NSView*)view direction:(NSInteger)direction
{
    [removingView addObject:view];
    NSRect frame = view.frame;
    if (direction == REMOVE_TO_RIGHT) {
        frame.origin.x = self.bounds.size.width;
    }
    else if (direction == REMOVE_TO_MID) {
        frame.origin.x = (self.bounds.size.width - frame.size.width)/2.0;
    }
    else {
        frame.origin.x = 0 - frame.size.width;
    }
    [[view animator] setFrame:frame];
}

- (void)addView:(NSView*)view direction:(NSInteger)direction
{
    NSRect origFrame = view.frame;
    NSRect startFrame;
    if (direction == ADD_FROM_LEFT) {
        startFrame = NSMakeRect(0, origFrame.origin.y, origFrame.size.width, origFrame.size.height);
    }
    else if (direction == ADD_FROM_MID) {
        startFrame = NSMakeRect((self.bounds.size.width - origFrame.size.width)/2.0, origFrame.origin.y, origFrame.size.width, origFrame.size.height);        
    }
    else {
        startFrame = NSMakeRect(self.bounds.size.width,  origFrame.origin.y, origFrame.size.width, origFrame.size.height);
    }
    
    view.frame = startFrame;
    [self addSubview:view];
    [[view animator] setFrame:origFrame];
}

- (void)afterAnimation
{
    for (NSView* view in removingView) {
        [view removeFromSuperview];
    }
    [removingView removeAllObjects];
}
@end
