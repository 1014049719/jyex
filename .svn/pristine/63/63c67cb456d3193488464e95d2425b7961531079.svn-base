//
//  PPSizeMenuManager.m
//  NoteBook
//
//  Created by chen wu on 09-10-21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPSizeMenuManager.h"



@implementation PPArcDeamon

- (PPArcDeamon *) initWithFrame:(CGRect)frame lineSize:(CGFloat)size color:(UIColor *)color
{
	if(self = [super initWithFrame:frame])
	{
		penColor = [color retain];
		pensize = size;
		padding = 20;
	}
	return self;
}

- (void)setSize:(CGFloat)size
{
	pensize = size;
	[self setNeedsDisplay];
}

- (void)setPenColor:(UIColor *)color size:(CGFloat)size
{
	[color retain];
	[penColor release];
	penColor = color;
	[self setSize:size];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, pensize);
	CGContextSetStrokeColorWithColor(context, penColor.CGColor);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinBevel);
	CGFloat min = CGRectGetMidY(rect);
	// Draw a bezier curve with end points s,e and control points cp1,cp2
	CGPoint start = CGPointMake(0+padding,min);
	CGPoint end = CGPointMake(self.bounds.size.width-padding,min);
	CGPoint cp1 = CGPointMake(90+padding, min-90);
	CGPoint cp2 = CGPointMake(self.bounds.size.width-90-padding, min+90);
	CGContextMoveToPoint(context, start.x, start.y);
	CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, end.x, end.y);
	CGContextStrokePath(context);
	
}
- (void)dealloc
{
	NSLog(@"<PPSizeMenumanager dealloc>");
	[penColor release];
	[super dealloc];
}
@end


#define deamonRect CGRectMake(20, 60, 280, 120)
#define sliderRect CGRectMake(20, 170, 280, 80)
@implementation PPSizeMenuManager

- (id)initWithFrame:(CGRect)frame color:(UIColor *) penColor size:(CGFloat) penSize{
    if (self = [super initWithFrame:frame]) {
		ad = [[PPArcDeamon alloc] initWithFrame:deamonRect lineSize:3 color:penColor];
		[self addSubview:ad];
		ad.backgroundColor = [UIColor clearColor];
		
		
		slider = [[UISlider alloc] initWithFrame:sliderRect];
		slider.backgroundColor = [UIColor clearColor];
		slider.minimumValue = 1;
		slider.maximumValue = 40;
		slider.value = penSize;
		slider.continuous = YES;
		[slider setMinimumTrackImage:[[UIImage imageNamed:@"Resource/Image/slider_min.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
		[slider setMaximumTrackImage:[[UIImage imageNamed:@"Resource/Image/slider_max.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
		[slider setThumbImage:[[UIImage imageNamed:@"Resource/Image/slider_item.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
		[slider setThumbImage:[[UIImage imageNamed:@"Resource/Image/slider_item.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
		[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:slider];
		
		
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
		label.backgroundColor = [UIColor clearColor];
		label.text = [NSString stringWithFormat:@"%@%0.2f",@"画笔粗细:",slider.value];
		label.textColor = [UIColor whiteColor];
		label.highlighted = YES;
		label.tag = 11;
		[self addSubview:label];
		[label release];
	}
    return self;
}

- (void)setPenColor:(UIColor *)color size:(CGFloat)newSize
{
	[ad setPenColor:color size:newSize];
	slider.value = newSize;
	UILabel *label = (UILabel *)[self viewWithTag:11];
	label.text = [NSString stringWithFormat:@"%@ %0.2f 像素",@"画笔粗细:",slider.value];
}

- (void)sliderAction:(UISlider *)aslider
{
	[ad setSize:slider.value];
	UILabel *label = (UILabel *)[self viewWithTag:11];
	label.text = [NSString stringWithFormat:@"%@ %0.2f 像素",@"画笔粗细:",slider.value];
}

- (CGFloat) getPenSize
{
	return slider.value;
}

- (void)dealloc {
//	MLOG(@"<PPArcDeamon dealloc>");
	[ad		release];
	[slider release];
    [super	dealloc];
}


@end
