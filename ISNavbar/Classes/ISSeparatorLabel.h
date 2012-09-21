//
//  ISSeparatorLabel.h
//  ISNavbar
//
//  Created by Robin Lu on 9/19/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISSeparatorLabel : NSButton

- (id) initWithTitle:(NSString*)title;

- (NSColor *)textColor;
- (void)setTextColor:(NSColor *)textColor;
@end
