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

- (NSTextField *)buildTitleField:(NSString *)title
{
    NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    titleField.stringValue = title;
    [titleField setBordered:NO];
    [titleField setEditable:NO];
    [titleField setDrawsBackground:NO];
    [titleField setAlignment:NSCenterTextAlignment];
    [titleField setTextColor:[NSColor darkGrayColor]];
    [titleField setFont:[NSFont systemFontOfSize:13]];
    [titleField setAutoresizingMask:NSViewMaxXMargin|NSViewMinXMargin];
    [titleField sizeToFit];
    NSRect frame = [titleField frame];
    frame.origin.x = (self.bounds.size.width - frame.size.width)/2.0;
    frame.origin.y = (self.bounds.size.height - frame.size.height)/2.0;
    [titleField setFrame:frame];
    return titleField;
}

- (void)pushTitle:(NSString*)title
{
    [titles addObject:title];
    NSTextField *titleField;
    titleField = [self buildTitleField:title];
    if (currentTitleField) {
        [currentTitleField removeFromSuperview];
    }
    [self addSubview:titleField];
    currentTitleField = titleField;
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
    startX = zoom.frame.origin.x + zoom.frame.size.width + MARGIN;
    [self setFrame:frame];
    [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [aWindow.titleBarView addSubview:self];
}
@end
