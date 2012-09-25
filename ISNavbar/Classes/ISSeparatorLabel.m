//
//  ISSeparatorLabel.m
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import "NSBezierPath+Ext.h"

#import "ISSeparatorLabel.h"

@implementation ISSeparatorLabel

- (id) initWithTitle:(NSString*)title
{
    self = [super initWithFrame:NSZeroRect];
    if (self) {
        [self setTitle:title];
    }
    return self;
}

- (NSColor *)textColor
{
    NSAttributedString *attrTitle = [self attributedTitle];
    NSRange range = NSMakeRange(0, MIN([attrTitle length], 1)); // take color from first char
    NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
    NSColor *textColor = [NSColor controlTextColor];
    if (attrs) {
        textColor = [attrs objectForKey:NSForegroundColorAttributeName];
    }
    return textColor;
}

- (void)setTextColor:(NSColor *)textColor
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                            initWithAttributedString:[self attributedTitle]];
    NSRange range = NSMakeRange(0, [attrTitle length]);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:textColor
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    [attrTitle release];
}

#define dividorWidth 8
#define dividorMargin 4

-(void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    [self setFont:[NSFont systemFontOfSize:10]];
    [self setBordered:NO];
    [self setTextColor:[NSColor darkGrayColor]];

    NSSize size = [self.attributedTitle size];
    NSRect frame = NSMakeRect(0, 0, size.width + dividorWidth + dividorMargin, size.height);

    self.frame = frame;
}

- (NSRect)dividorRect
{
    NSRect rect = self.bounds;
    rect.origin.x += (rect.size.width - dividorWidth);
    rect.size.width = dividorWidth;
    rect.origin.y += 2;
    rect.size.height -= 4;
    return rect;
}

- (void)drawDividorInRect:(NSRect)rect
{
    NSWindow *window = [self window];
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);

    NSArray *colors;
    if (drawsAsMainWindow) {
        colors    = [NSArray arrayWithObjects:[NSColor colorWithSRGBRed:0.65 green:0.65 blue:0.65 alpha:0],
                     [NSColor colorWithSRGBRed:0.55 green:0.55 blue:0.55 alpha:1],
                     [NSColor colorWithSRGBRed:0.5 green:0.5 blue:0.5 alpha:0.3],nil];
    }
    else {
        colors    = [NSArray arrayWithObjects:[NSColor colorWithSRGBRed:0.9 green:0.9 blue:0.9 alpha:0],
                     [NSColor colorWithSRGBRed:0.8 green:0.8 blue:0.8 alpha:1],
                     [NSColor colorWithSRGBRed:0.8 green:0.8 blue:0.8 alpha:0.3],nil];
    }
    const CGFloat locations[3] = {0.0, 0.5, 1.0};
    NSGradient *gradient = [[[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]] autorelease];
    NSGradient *borderGradient = [[[NSGradient alloc] initWithColorsAndLocations:
                                    [NSColor colorWithSRGBRed:0.94 green:0.94 blue:0.94 alpha:0.2], 0.0,
                                    [NSColor colorWithSRGBRed:0.94 green:0.94 blue:0.94 alpha:0.9], 0.5,
                                    [NSColor colorWithSRGBRed:0.94 green:0.94 blue:0.94 alpha:0], 1.0, nil] autorelease];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:rect.origin];
    [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2.0)];
    [path lineToPoint:NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height)];
    NSBezierPath *strokedPath = [path strokedPath];
    NSBezierPath *borderPath = [strokedPath strokedPath];
    [borderGradient drawInBezierPath:borderPath angle:90];
    [gradient drawInBezierPath:strokedPath angle:90];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSSize size = [self.attributedTitle size];
    [self.attributedTitle drawAtPoint:NSMakePoint(0, (self.bounds.size.height - size.height)/2.0)];
    [self drawDividorInRect:[self dividorRect]];
}

@end
