//
//  PPTimerMenuSheet.h
//  NoteBook
//
//  Created by chen wu on 09-8-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPTimerMenuSheet : UIToolbar {
	UIImageView * trianglePrompt;
	BOOL	showed;
}
- (void) showAboveView:(UIView *)view bottomCenter:(float)center;
- (void) dismiss;
- (BOOL) hasShowed;
@end
