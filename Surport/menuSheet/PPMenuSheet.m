//
//  PPMenuSheet.m
//  NoteBook
//
//  Created by chen wu on 09-8-13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PPMenuSheet.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTiming.h>
@implementation PPMenuSheet
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		normalFrame = frame;
		delegate = nil;
		self.barStyle = UIBarStyleBlackTranslucent;
		showed = NO;
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}
- (BOOL)hasShowed
{
	return showed;
}
//- (void)showInView:(UIView *)view
//{
//	if(showed == NO)
//	{
//		[view addSubview:self];
//		showed = YES;
//	}
//}
- (void)showAboveView:(UIView *)view
{
	if(showed == YES) return;
	showed = YES;
	CGRect frame = view.frame;
	UIView * superView =  [view superview];
	CGFloat y  = frame.origin.y - normalFrame.size.height;
	CGRect beginFrame = CGRectMake(self.frame.origin.x, frame.origin.y, 320, 0);
	CGRect endFrame = CGRectMake(self.frame.origin.x, y, 
								 self.frame.size.width,
								 normalFrame.size.height);
	self.frame = beginFrame;
	

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.2];

	self.frame = endFrame;
	
	[UIView commitAnimations];
	
	if([delegate respondsToSelector:@selector(PPMenuSheetDelegate:willShowAboveView:)])
	{
		[delegate PPMenuSheetDelegate:self willShowAboveView:self.superview];
	}
	[superView addSubview:self];
}

- (void)dismiss
{
	if(showed == NO) return;
	showed = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.2];
	
	self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y+self.frame.size.height,self.frame.size.width,0);
	[UIView commitAnimations];
	
	if([delegate respondsToSelector:@selector(PPMenuSheetDelegate:willDismissFromView:)])
	{
		[delegate PPMenuSheetDelegate:self willDismissFromView:self.superview];
	}
	
	[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}



@end
