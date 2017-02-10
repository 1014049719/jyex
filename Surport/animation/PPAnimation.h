//
//  PPAnimation.h
//  NoteBook
//
//  Created by chen wu on 09-7-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPAnimation : NSObject {
	
}
+ (PPAnimation *) shareAnimation;
- (void) flipAnimation:(UIView *)view duration:(float) time leftOrRight:(BOOL)oriented;
- (void) fadeAnimation:(UIView *)view visiable:(BOOL) yesOrno;
//- (void) deleteAnimation:(UIView *)view;

@end
