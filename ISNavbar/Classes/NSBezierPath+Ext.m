//
//  NSBezierPath+Ext.m
//  ISNavbar
//
//  Created by Robin Lu on 9/24/12.
//  Copyright (c) 2012 IN-SRC Limit. All rights reserved.
//

#import "NSBezierPath+Ext.h"

static void				ConvertPathApplierFunction ( void *info, const CGPathElement *element );

@implementation NSBezierPath (Ext)

+ (NSBezierPath*)		bezierPathWithCGPath:(CGPathRef) path
{
	// given a CGPath, this converts it to the equivalent NSBezierPath by using a custom apply function
	
	NSAssert( path != nil, @"CG path was nil in bezierPathWithCGPath");
	
	NSBezierPath* newPath = [self bezierPath];
	CGPathApply( path, newPath, ConvertPathApplierFunction );
	return newPath;
}

+ (NSBezierPath*)		bezierPathWithPathFromContext:(CGContextRef) context
{
	// given a context, this converts its current path to an NSBezierPath. It is the inverse to the -setQuartzPath method.
	
	NSAssert( context != nil, @"no context for bezierPathWithPathFromContext");
	
	// WARNING: this uses an undocumented function in CG (CGContextCopyPath)
	// UPDATE 12/09: This function was made public from 10.6, so this is safe. Not yet documented though.
	
	CGPathRef cp = CGContextCopyPath( context );
	NSBezierPath* bp = [self bezierPathWithCGPath:cp];
	CGPathRelease( cp );
	
	return bp;
}

- (CGMutablePathRef)	newMutableQuartzPath
{
    NSInteger i, numElements;
    
    // If there are elements to draw, create a CGMutablePathRef and draw.
    
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
					
				default:
					break;
            }
        }
		
		// the caller is responsible for releasing this ref when done
		
		return path;
    }
    
    return nil;
}

- (CGPathRef)			newQuartzPath
{
	CGMutablePathRef mpath = [self newMutableQuartzPath];
	CGPathRef		 path = CGPathCreateCopy(mpath);
    CGPathRelease(mpath);
	
	// the caller is responsible for releasing the returned value when done
	
	return path;
}

- (void)				setQuartzPathInContext:(CGContextRef) context isNewPath:(BOOL) np
{
	NSAssert( context != nil, @"no context for [NSBezierPath setQuartzPathInContext:isNewPath:]");
	
	CGPathRef		cp = [self newQuartzPath];
	
	if ( np )
		CGContextBeginPath( context );
    
	CGContextAddPath( context, cp );
	CGPathRelease( cp );
	
	CGContextSetLineWidth( context, [self lineWidth]);
	CGContextSetLineCap( context, (CGLineCap)[self lineCapStyle]);
	CGContextSetLineJoin( context, (CGLineJoin)[self lineJoinStyle]);
	CGContextSetMiterLimit( context, [self miterLimit]);
	
	CGFloat	lengths[16];
	CGFloat	phase;
	NSInteger		count;
	
	[self getLineDash:lengths count:&count phase:&phase];
	CGContextSetLineDash( context, phase, lengths, count );
}

- (CGContextRef)		setQuartzPath
{
	// converts the path to a CGPath and adds it as the current context's path. It also copies the current line width
	// and join and cap styles, etc. to the context.
	
	CGContextRef	context = [[NSGraphicsContext currentContext] graphicsPort];
	
	NSAssert( context != nil, @"no context for setQuartzPath");
	
	if ( context )
		[self setQuartzPathInContext:context isNewPath:YES];
	
	return context;
}

#pragma mark -
#pragma mark - getting the outline of a stroked path
- (NSBezierPath*)		strokedPath
{
	// returns a path representing the stroked edge of the receiver, taking into account its current width and other
	// stroke settings. This works by converting to a quartz path and using the similar system function there.
	
	// this creates an offscreen graphics context to support the CG function used, but the context itself does not
	// need to actually draw anything, therefore a simple 1x1 bitmap is used and reused for this context.
	
	NSBezierPath*				path = nil;
	NSGraphicsContext*			ctx = nil;
	static NSBitmapImageRep*	rep = nil;
	
	if( rep == nil )
	{
		rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                      pixelsWide:1
                                                      pixelsHigh:1
                                                   bitsPerSample:8
                                                 samplesPerPixel:3
                                                        hasAlpha:NO
                                                        isPlanar:NO
                                                  colorSpaceName:NSCalibratedRGBColorSpace
                                                     bytesPerRow:4
                                                    bitsPerPixel:32];
	}
	
	ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    
	NSAssert( ctx != nil, @"no context for -strokedPath");
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:ctx];
	
	CGContextRef context = [self setQuartzPath];
	
	path = self;
	
	if ( context )
	{
		CGContextReplacePathWithStrokedPath( context );
		path = [NSBezierPath bezierPathWithPathFromContext:context];
	}
	
	[NSGraphicsContext restoreGraphicsState];
    
	return path;
}

#pragma mark -

static void ConvertPathApplierFunction ( void* info, const CGPathElement* element )
{
	NSBezierPath* np = (NSBezierPath*) info;
	
	switch( element->type )
	{
		case kCGPathElementMoveToPoint:
			[np moveToPoint:*(NSPoint*) element->points];
			break;
            
		case kCGPathElementAddLineToPoint:
			[np lineToPoint:*(NSPoint*) element->points];
			break;
            
		case kCGPathElementAddQuadCurveToPoint:
			[np curveToPoint:*(NSPoint*) &element->points[1] controlPoint1:*(NSPoint*) &element->points[0] controlPoint2:*(NSPoint*) &element->points[0]];
			break;
            
		case kCGPathElementAddCurveToPoint:
			[np curveToPoint:*(NSPoint*) &element->points[2] controlPoint1:*(NSPoint*) &element->points[0] controlPoint2:*(NSPoint*) &element->points[1]];
			break;
			
		case kCGPathElementCloseSubpath:
			[np closePath];
			break;
			
		default:
			break;
	}
}

@end
