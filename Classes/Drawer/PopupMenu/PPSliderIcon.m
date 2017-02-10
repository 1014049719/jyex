//
//  PPSliderIcon.m
//  test2
//
//  Created by chen wu on 09-10-13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPSliderIcon.h"
#import "Constant.h"


@implementation PPSliderIcon


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	startLocation = pt;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
		
	CGPoint bounds = [self convertPoint:pt toView:self.superview]; 
//	printf("point in super x= %f , y = %f \n",bounds.x,bounds.y);
	
	
	if(bounds.x > 0 && bounds.x < self.superview.frame.size.width)
	{
		CGRect frame = [self frame];
		frame.origin.x += pt.x - startLocation.x;
		[self setFrame:frame];
	}
	
	if((bounds.x == 0 && pt.x - startLocation.x>0) || (bounds.x == self.superview.frame.size.width && pt.x - startLocation.x<0))
	{
		CGRect frame = [self frame];
		frame.origin.x += pt.x - startLocation.x;
		[self setFrame:frame];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSNumber * num = [NSNumber numberWithFloat:self.center.x/self.superview.frame.size.width];
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:num,@"alpha",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kRefeshAplphaNotification object:nil userInfo:dict];
}
- (void)drawRect:(CGRect)rect {

}


- (void)dealloc {
    [super dealloc];
}


@end
