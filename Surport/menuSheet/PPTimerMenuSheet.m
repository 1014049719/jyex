//
//  PPTimerMenuSheet.m
//  NoteBook
//
//  Created by chen wu on 09-8-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#define offset 20
#import "PPTimerMenuSheet.h"


@implementation PPTimerMenuSheet


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.barStyle = UIBarStyleBlackTranslucent;
		showed = NO;
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		//trianglePrompt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup-triangle.png"]];	
		
    }
    return self;
}

	
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.85].CGColor);
	
	CGRect rrect = rect;//self.bounds;
	
	CGFloat radius ;
	
	radius = 8.0;
	CGFloat width = CGRectGetWidth(rrect);
	CGFloat height = CGRectGetHeight(rrect);
	
	// Make sure corner radius isn't larger than half the shorter side
	if (radius > width/2.0)
		radius = width/2.0;
	if (radius > height/2.0)
		radius = height/2.0;    
	
	CGFloat minx = CGRectGetMinX(rrect);
	CGFloat midx = CGRectGetMidX(rrect);
	CGFloat maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect);
	CGFloat midy = CGRectGetMidY(rrect);
	CGFloat maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	
	
	CGContextDrawPath(context, kCGPathFill);	
	

}

- (void) showAboveView:(UIView *)view bottomCenter:(float)center
{
	if(showed == YES) return;
	
	showed = YES;
	CGRect frame = view.frame;
	UIView * superView =  [view superview];
	CGFloat y  = frame.origin.y - self.frame.size.height - offset;
	CGRect rect = CGRectMake(self.frame.origin.x, y, self.frame.size.width,self.frame.size.height);	
	self.frame = rect;
	trianglePrompt.center = CGPointMake(center,self.center.y+self.frame.size.height/2+trianglePrompt.frame.size.height/2-3);
	//self.frame = CGRectMake(10, 10, 50, 50);
	
	self.alpha = 0;
	trianglePrompt.alpha = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	
	self.alpha = 0.85;
	trianglePrompt.alpha = 0.5;
	[UIView commitAnimations];
	
	[superView addSubview:trianglePrompt];
	[superView addSubview:self];
}


- (void) dismiss
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	
	self.alpha = 0;
	trianglePrompt.alpha = 0;
	
	[UIView commitAnimations];
	[self			performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
	[trianglePrompt performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}
- (BOOL) hasShowed
{
	return showed;
}
- (void)dealloc {
	[trianglePrompt release];
    [super dealloc];
}


@end
