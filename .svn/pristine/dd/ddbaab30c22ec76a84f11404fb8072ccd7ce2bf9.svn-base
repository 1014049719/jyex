//
//  DrawerLabel.m
//  NoteBook
//
//  Created by chen wu on 09-8-19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DrawerLabel.h"
#import "logging.h"


@implementation DrawerLabel


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		[self setUserInteractionEnabled:YES];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	LOG_ERROR(@"DRAWER Label...beging");
    //	NSArray * views = [[self superview] subviews];
    //	index = 0;
    //	for (UIView * view in views) {
    //		
    //		if([[view name] isEqualToString:[self name]])
    //			break;
    //		index ++;
    //	}
    //	printf("view index = %d",index);
	CGPoint pt = [[touches anyObject] locationInView:self];
	startLocation = pt;
	[[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	CGRect frame = [self frame];
	frame.origin.x += pt.x - startLocation.x;
	frame.origin.y += pt.y - startLocation.y;
	[self setFrame:frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
- (void)dealloc {
    [super dealloc];
}


@end
