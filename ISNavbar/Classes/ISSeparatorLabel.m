//
//  ISSeparatorLabel.m
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

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

-(void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    [self setFont:[NSFont systemFontOfSize:10]];
    [self setBordered:NO];
    self.image = [NSImage imageNamed:@"divide"];
    self.imagePosition = NSImageRight;
    [self setTextColor:[NSColor darkGrayColor]];
    [self sizeToFit];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [self.cell setShowsStateBy:NSPushInCellMask];
    [self.cell setHighlightsBy:NSContentsCellMask];
    [super drawRect:dirtyRect];
}

@end
