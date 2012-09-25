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
    NSArray *colors = [NSArray arrayWithObjects:[NSColor colorWithSRGBRed:0.88 green:0.88 blue:0.88 alpha:0.1],
                                                [NSColor colorWithSRGBRed:0.62 green:0.62 blue:0.62 alpha:1],
                                                [NSColor colorWithSRGBRed:0.67 green:0.67 blue:0.67 alpha:0.1],nil];
    const CGFloat locations[3] = {0.0, 0.5, 1.0};
    NSGradient *gradient = [[[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]] autorelease];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:rect.origin];
    [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2.0)];
    [path lineToPoint:NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height)];
    NSBezierPath *strokedPath = [path strokedPath];
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
