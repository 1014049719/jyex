//
//  UIVCUserList.h
//  Astro
//
//  Created by nd on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussMng.h"



@interface UIVCUserList : UIViewController<UIScrollViewDelegate>
{
	UIViewController* vcParent;
	SEL	closeCallback;
	
    IBOutlet UIImageView *ivSel1, *ivSel2;
	IBOutlet UIImageView* imgView;
	IBOutlet UIScrollView* sclView;
	IBOutlet UIButton* btnDemon;
	IBOutlet UIButton* btnAddNew;
	IBOutlet UIButton* btnLogin;
    IBOutlet UIButton* btnMng;
	IBOutlet UILabel *lbHor, *lbVer, *lbPage;
	IBOutlet UIView* anmView;
	
	NSMutableArray* peopleList;
	BussMng* bussMngUiLogin;
	//UIViewController* vcMakePeople;
	CGRect btnRect;
	NSString* callbackInfo;
	//float yOffset;
	int curTag;
    int curPage;
    UIImageView* curDot;
}

@property (nonatomic, assign) UIViewController* vcParent;
@property (nonatomic, assign) SEL closeCallback;

@property (nonatomic, retain) NSMutableArray* peopleList;
@property (nonatomic, retain) BussMng* bussMngUiLogin;
//@property (nonatomic, retain) UIViewController* vcMakePeople;


+ (UIViewController*) addToWnd :(UIViewController*)vcParent :(SEL)closeCallback;

- (IBAction) onMakePeople:(id)sender;
- (IBAction) onUserLogin:(id)sender;
- (IBAction) onChangePeople:(id)sender;
- (IBAction) onTouchDown:(id)sender;
- (IBAction) onTouchCancel:(id)sender;
- (IBAction) onPeopleMng:(id)sender;


- (void) addItem :(NSString*)name :(BOOL)isSelected :(int)tag :(int)idx;
- (void) beginEndAnimation;
- (void) addHorLine:(float)y;
- (void) addVerLine:(float)x;

- (void) setPageDot:(int)idx;
- (void) initPageDot:(int)pages;
- (CGRect) caculBtnRect:(int)idx;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
