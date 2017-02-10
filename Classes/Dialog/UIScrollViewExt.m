//
//  UIScrollViewExt.m
//  Astro
//
//  Created by root on 12-3-1.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import "UIScrollViewExt.h"


@implementation UIScrollView (TouchEventEnable)

/*
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//    if(!self.dragging)
	//    {
	[[self nextResponder] touchesBegan:touches withEvent:event];
	//    }
//    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	if(!self.dragging)
//    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	if(!self.dragging)
//	{
		[[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//    [super touchesEnded:touches withEvent:event];
}

@end


#pragma mark -
#pragma mark CGPOINT=》NSOBJECT
@implementation NSPoint

@synthesize x;
@synthesize y;

+(NSPoint*) makeNSPointFromCGPoint:(float)gx :(float)gy
{
	NSPoint* pnt = [[NSPoint alloc] init];
	pnt.x = gx;
	pnt.y = gy;
	
	return [pnt autorelease];
}

@end

