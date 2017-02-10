//
//  UIAstroAlert.h
//  Astro
//
//  Created by liuyfmac on 12-2-15.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

enum 
{
	LOC_MID = 0,
	LOC_UP = 1,
	LOC_DOWN = 2,
};

@interface UIAstroAlert : UIViewController 
{
	IBOutlet UIImageView* ivBk;
	IBOutlet UILabel* lbInfo;
	IBOutlet UIButton* btnModel;
	
	int idx;
	BOOL _spin;
}
@property (nonatomic, assign) int idx;

+ (void) info :(NSString*)str :(float)tmo :(BOOL)spin :(int)loc :(BOOL)mask;
+ (void) info :(NSString*)str :(BOOL)spin :(BOOL)navActive;

+ (void) infoCancel;
+ (int) askWait :(NSString*)str :(NSArray*)btns;
+ (UIAstroAlert*) ask :(NSString*)str :(float)tmo :(BOOL)spin :(NSArray*)btns :(id)obsv :(SEL)callback;

//
- (void) showInfo :(NSString*)str :(float)tmo :(BOOL)spin :(int)loc;
- (void) showAskWait :(NSString*)str :(NSArray*)btns;
- (void) addBtn :(NSString*)title :(CGRect)f :(int)tag;


extern UIAstroAlert* gAlert;
@end
