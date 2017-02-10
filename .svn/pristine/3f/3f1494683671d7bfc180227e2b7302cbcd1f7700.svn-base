//
//  PPScrollmenuItem.m
//  test2
//
//  Created by chen wu on 09-10-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPScrollmenuItem.h"
#import "Constant.h"

@implementation PPScrollmenuItem
@synthesize  iconImage = _icon,contentColor = _contentColor,selected = _selected;
@synthesize  delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		_icon = nil;
		_selected = NO;
		delegate = nil;
		
		//  test	
		srand(CFAbsoluteTimeGetCurrent());
		
		CGFloat r = random()%256;
		CGFloat g = random()%256;
		CGFloat b = random()%256;
		
		self.contentColor = [UIColor colorWithRed:r/256 green:g/256 blue:b/256 alpha:1];
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color
{
	if (self = [super initWithFrame:frame]) {
		
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		_icon = nil;
		_selected = NO;
		delegate = nil;
		
		
		self.contentColor = [color retain];
	}
    return self;
}

- (void)setIconImage:(UIImage *)img
{
	[img retain];
	[_icon release];
	_icon = img;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat radian = self.bounds.size.height>self.bounds.size.width ? self.bounds.size.width : self.bounds.size.height;
	CGRect bounds =CGRectMake(2.5f, 2.5f, radian-5, radian-5);
	
    CGContextRef  context = UIGraphicsGetCurrentContext();
	
	
	CGContextSetFillColorWithColor(context,_contentColor.CGColor);
	
	if(_selected == NO)
	{
		CGContextSetStrokeColorWithColor(context, RGBACOLOR(255, 206 ,101  ,20).CGColor);
		CGContextSetLineWidth(context,2);
	}else
	{
		CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextSetLineWidth(context,5);
	}
	
	CGContextFillEllipseInRect(context, bounds);
	
	if(_icon!=nil)
	{
		CGMutablePathRef path = CGPathCreateMutable();
		
		// Add circle to path
		CGPathAddEllipseInRect(path, NULL, bounds);
		CGContextAddPath(context, path);
		
		// Clip to the circle and draw the image
		CGContextClip(context);
		
		[_icon drawInRect:bounds];
		
		CFRelease(path);
		
	}
	CGContextStrokeEllipseInRect(context, bounds);
}

// Detect whether the touch "hits" the view
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
	
	CGPoint pt;
	float HALFSIDE = self.bounds.size.height>self.bounds.size.width ? self.bounds.size.width : self.bounds.size.height;
	HALFSIDE -= 2.5;
	// normalize with centered origin
	pt.x = (point.x - HALFSIDE) / HALFSIDE;
	pt.y = (point.y - HALFSIDE) / HALFSIDE;
	
	// x^2 + y^2 = radius
	float xsquared = pt.x * pt.x;
	float ysquared = pt.y * pt.y;
	
	// If the radius < 1, the point is within the clipped circle
	if ((xsquared + ysquared) < 1.0) return YES;
	return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([delegate respondsToSelector:@selector(PPScrollmenuItem:contentColor:)])
	{
		[delegate PPScrollmenuItem:self contentColor:_contentColor];
	}
}

- (void)dealloc {
	[_icon release];
    [super dealloc];
}


@end
