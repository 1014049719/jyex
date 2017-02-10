//
//  UIScrollViewExt.h
//  Astro
//
//  Created by root on 12-3-1.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark UIScrollView Touch事件重写
@interface UIScrollView (TouchEventEnable)
@end




#pragma mark -
#pragma mark CGPOINT=》NSOBJECT
@interface NSPoint : NSObject
{
	float x;
	float y;
}

@property(nonatomic, assign) float x;
@property(nonatomic, assign) float y;

+(NSPoint*) makeNSPointFromCGPoint:(float)gx :(float)gy;

@end


//
#define makeNSPointFromCGPoint(pnt)		[NSPoint makeNSPointFromCGPoint:(pnt).x :(pnt).y]
 