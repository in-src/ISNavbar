//
//  ISNavbarView.m
//  ISNavbar
//
//  Created by Robin Lu on 9/20/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import "InAppStoreWindow.h"

#import "ISNavbarView.h"

#define MARGIN 16

@implementation ISNavbarView
-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        titles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushTitle:(NSString*)title
{
    [titles addObject:title];
}

- (void)popTitle
{
    [titles removeLastObject];
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
    frame.origin.x = zoom.frame.origin.x + zoom.frame.size.width + MARGIN;
    frame.size.width -= 2 * MARGIN;
    [self setFrame:frame];
    [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [aWindow.titleBarView addSubview:self];
}
@end
