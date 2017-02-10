//
//  PPSizeMenuManager.h
//  NoteBook
//
//  Created by chen wu on 09-10-21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMenuSheet.h"


@interface PPArcDeamon : UIView
{
	CGFloat pensize;
	UIColor *penColor;
	CGFloat padding;
}

- (PPArcDeamon *) initWithFrame:(CGRect)frame lineSize:(CGFloat)size color:(UIColor *)color;

@end

@interface PPSizeMenuManager : PPMenuSheet
{
@private
	UISlider * slider;
	PPArcDeamon * ad;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *) penColor size:(CGFloat) penSize;
- (void)setPenColor:(UIColor *)color size:(CGFloat) newSize;
- (CGFloat) getPenSize;

@end
