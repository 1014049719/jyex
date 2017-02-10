//
//  UIMyWebView.m
//  NoteBook
//
//  Created by susn on 12-11-22.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UIMyWebView.h"


#define SWIPE_DRAG_MIN 16
#define DRAGLIMIT_MAX 8
#define POINT_TOLERANCE 16
#define MIN_PINCH	8

#define DX(p1, p2)	(p2.x - p1.x)
#define DY(p1, p2)	(p2.y - p1.y)

typedef enum {
	UITouchUnknown=0,
	UITouchTap,
	UITouchDoubleTap,
	UITouchDrag,
	UITouchMultitouchTap,
	UITouchMultitouchDoubleTap,
	UITouchSwipeLeft,
	UITouchSwipeRight,
	UITouchSwipeUp,
	UITouchSwipeDown,
	UITouchPinchIn,
	UITouchPinchOut,
} UIDevicePlatform;


float distance (CGPoint p1, CGPoint p2)
{
	float dx = p2.x - p1.x;
	float dy = p2.y - p1.y;
	
	return sqrt(dx*dx + dy*dy);
}

@implementation UIMyWebView
@synthesize mydelegate;



- (id) initWithFrame:(CGRect)frame 
{
    NSLog(@"---->UIMyWebView initWithFrame");
    
    if (self = [super initWithFrame:frame]) {
        // Initialization code
     }
    return self;
}

- (void) dealloc
{
    NSLog(@"---->UIMyWebView dealloc");
    [super dealloc];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( mydelegate && [mydelegate respondsToSelector:@selector(touchEnd:)] ) {
        [mydelegate touchEnd:touches];
    }
}



@end
