//
//  PPAnimation.mm
//  NoteBook
//
//  Created by chen wu on 09-7-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPAnimation.h"

static PPAnimation * g_cc = nil;
@implementation PPAnimation

+ (PPAnimation *) shareAnimation
{
	if(g_cc == nil)
		g_cc = [[PPAnimation alloc] init];
	return g_cc;	
}

-(void) flipAnimation:(UIView *)view duration:(float) time leftOrRight:(BOOL)oriented
{
	// Start Animation Block
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	if(oriented)
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[view superview] cache:YES];
	else
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:[view superview] cache:YES];

	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:time];
	
	// Animations
	int count = [[view superview] subviews].count;
//	[[fromView superview] insertSubview:toView atIndex:count - 2];
	[[view superview] exchangeSubviewAtIndex:count-1 withSubviewAtIndex:count-2];
	
	// Commit Animation Block
	[UIView commitAnimations];
	
}

- (void)fadeAnimation:(UIView *)view visiable:(BOOL) yesOrno
{
	[UIView	beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[view setAlpha:yesOrno];
	[UIView commitAnimations];
}

- (void)deleteAnimation:(UIView *)view aimRect:(CGRect)frame aimPosition:(CGPoint)pt 
{
#define PI 3.14159265
#if 0	
	//CGRect  headImageOrgRect = view.frame;
	//CGSize size = image.size;
	
	
	CGFloat midX = view.center.x;
	CGFloat midY = view.center.y;
	
	//[view  setFrame:CGRectMake(0, 0, size.width, size.height)];
	CALayer *TransLayer = view.layer;
	
	// Create a keyframe animation to follow a path back to the center
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	animation.removedOnCompletion = YES;
	
	CGFloat animationDuration = 0.3;
	
	
	// Create the path for the bounces
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	
	CGFloat originalOffsetX = frame.center.x - midX;
	CGFloat originalOffsetY = view.center.y - midY;
	
	BOOL stopAnimation = NO;
	
	CGPathMoveToPoint(thePath, NULL, headImageView.center.x, headImageView.center.y);
	float  xPosition ;
	float  yPosition ;
	float   angle = 0.0f;
	
	
	while (stopAnimation != YES) {
		
		xPosition = headImageView.center.x - originalOffsetX*sin(angle*(PI/180));
		yPosition = headImageView.center.y - originalOffsetY*sin(angle*(PI/180));
		CGPathAddLineToPoint(thePath, NULL, xPosition, yPosition);
		
		
		angle = angle +1.0f;	
		
		if(angle == 90.0f||angle > 90.0f)	
			stopAnimation = YES;
	}
	
	[headImageView  setCenter:CGPointMake(midX,midY)];
	
	animation.path = thePath;
	CGPathRelease(thePath);
	animation.duration = animationDuration;
	
	
	// Create a basic animation 
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	
	shrinkAnimation.removedOnCompletion = YES;
	shrinkAnimation.duration = animationDuration;
	shrinkAnimation.fromValue = [NSValue valueWithCGRect:headImageView.frame];
	shrinkAnimation.byValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	shrinkAnimation.toValue = [NSValue valueWithCGRect:headImageOrgRect];
	
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	theGroup.animations = [NSArray arrayWithObjects:animation, shrinkAnimation, nil];
	
	
	// Add the animation group to the layer
	[TransLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
	
	// Set the  view's center and transformation to the original values in preparation for the end of the animation
	
	headImageView.transform = CGAffineTransformIdentity;
	[headImageView   setFrame:headImageOrgRect];
#endif	
}

- (void)dealloc {
    [super dealloc];
}


@end
