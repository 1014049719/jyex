//
//  PPColorSlider.m
//  test2
//
//  Created by chen wu on 09-10-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "PPColorSlider.h"
#import "Constant.h"


@implementation PPColorSlider

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		_sliderItem = [[PPSliderIcon alloc] initWithFrame:CGRectZero];
		_sliderItem.image = [UIImage imageNamed:@"popup-triangle.png"];
		[self addSubview:_sliderItem];
		_sliderItem.frame = CGRectMake(self.bounds.size.width * self.alpha-5,0,10,self.bounds.size.height);
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(freshAlpha:) name:kRefeshAplphaNotification object:nil];

	}
	return self;
}

-(void)setColor:(float)r green:(float)g  blue:(float)b alpha:(float)a
{
	self->red = r;
	self->blue = b;
	self->green = g;
	self->alpha = a;
	self.backgroundColor = [UIColor clearColor];
	
	[self setNeedsDisplay];
}

- (UIColor *) getColor
{
	printf("Color red = %f , green = %f ,blue = %f , alpha = %f\n",red,green,blue,alpha);
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat) getAlpha
{
	return alpha;
}

- (void)freshAlpha:(NSNotification *)notify
{
	NSNumber * alphaValue = [[notify userInfo] objectForKey:@"alpha"];
	alpha = [alphaValue floatValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	[_sliderItem setCenter:CGPointMake(pt.x,_sliderItem.center.y)];
	self->alpha = pt.x/self.frame.size.width;
}

void ColoredPatternCallback(void *info, CGContextRef context)
{
	// Dark Gray
	CGContextSetRGBFillColor(context, 0.667, 0.667, 0.667, 1.00);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 8.0, 8.0));
	CGContextFillRect(context, CGRectMake(8.0, 8.0, 8.0, 8.0));
	
	// Light White
	CGContextSetRGBFillColor(context, 1, 1,1, 1.00);
	CGContextFillRect(context, CGRectMake(8.0, 0.0, 8.0, 8.0));
	CGContextFillRect(context, CGRectMake(0.0, 8.0, 8.0, 8.0));
}

- (void)loadBackgroundContext:(CGContextRef) context
{
	// Colored Pattern setup
	CGPatternCallbacks coloredPatternCallbacks = {0, ColoredPatternCallback, NULL};
	
	CGPatternRef coloredPattern = CGPatternCreate(
												  NULL, // 'info' pointer for our callback
												  CGRectMake(0.0, 0.0, 16.0, 16.0), // the pattern coordinate space, drawing is clipped to this rectangle
												  CGAffineTransformIdentity, // a transform on the pattern coordinate space used before it is drawn.
												  16.0, 16.0, // the spacing (horizontal, vertical) of the pattern - how far to move after drawing each cell
												  kCGPatternTilingNoDistortion,
												  true, // this is a colored pattern, which means that you only specify an alpha value when drawing it
												  &coloredPatternCallbacks); // the callbacks for this pattern.
	

	CGColorSpaceRef coloredPatternColorSpace = CGColorSpaceCreatePattern(NULL);
	CGFloat alpha1 = 1.0;
	CGColorRef coloredPatternColor = CGColorCreateWithPattern(coloredPatternColorSpace, coloredPattern, &alpha1);
	CGColorSpaceRelease(coloredPatternColorSpace);
	CGPatternRelease(coloredPattern);
	
	CGContextSetFillColorWithColor(context, coloredPatternColor);
	CGContextFillRect(context, self.bounds);
	
}


-(void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// draw transculent background
	[self loadBackgroundContext:context];
	
	CGRect bounds = self.bounds;
	
	//	draw gradientRect
	
	CGRect gradientRect = bounds;
	
	CGFloat colors[] = {red,green,blue,0,red,green,blue,1};
	CGFloat locations[] = {0.0,1.0};

	CGPoint start = CGPointMake(gradientRect.origin.x, CGRectGetMidY(gradientRect));
	CGPoint end = CGPointMake(gradientRect.origin.x + gradientRect.size.width, CGRectGetMidY(gradientRect));
	CGGradientRef gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, locations, 2);
	
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGGradientRelease(gradient);

	//  draw bounds
	CGRect penRect = bounds;
    CGContextSetLineWidth(context,2);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor);
	
	CGFloat minx = CGRectGetMinX(penRect);
	CGFloat miny = CGRectGetMinY(penRect);
	CGFloat maxx = CGRectGetMaxX(penRect);
	CGFloat maxy = CGRectGetMaxY(penRect);
	
	const CGPoint pts[4] ={
		CGPointMake(minx,miny),
		CGPointMake(maxx,miny),
		CGPointMake(maxx,maxy),
		CGPointMake(minx,maxy)
	};
	
	CGContextAddLines(context, pts, 4);	
	
	CGContextClosePath(context);
	CGContextSetShadow(context, CGSizeMake(50,50), 10.0);
	CGContextStrokePath(context);

}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_sliderItem release];
	[super dealloc];
}
@end
