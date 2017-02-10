//
//  PPColorMenuManager.h
//  test2
//
//  Created by chen wu on 09-10-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPMenuSheet.h"
#import "PPScrollMenu.h"
#import "PPColorSlider.h"
#import "PPCustomColor.h"

@interface PPColorMenuManager : PPMenuSheet<PPScrollmenuDelegate,PPCustomColorDelegate> {
@private
	//PPColorSlider * slider;
	PPCustomColor * customColor;
	PPScrollmenu * menu;
	int colorNum;
	UIColor *pcolor;
}
- (id) initWithFrame:(CGRect)frame color:(UIColor *)color;
- (UIColor *) getColor;
@end
