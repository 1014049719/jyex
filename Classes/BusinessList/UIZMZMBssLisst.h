//
//  UIZMZMBssLisst.h
//  Astro
//
//  Created by cyl on 12-7-13.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIZMZMBssLisst : UIViewController
{
    IBOutlet UIButton* btn_Ballot;    //抽签算命
    IBOutlet UIButton* btn_Number; //号码测试
    IBOutlet UIButton* btn_Heart; //爱情速配
    IBOutlet UIButton* btn_Dream; //周公解梦
    IBOutlet UIButton* btn_TodayAlmanac; //黄历
    IBOutlet UIButton* btn_Lottery; //淘宝彩票
    IBOutlet UIButton* btn_ChengGu; //称骨算命
    
    IBOutlet UIView *anmView;
    NSUInteger businessType;
    
    UIViewController* vcParent;
    SEL	closeListCallback;
    
    IBOutlet UIImageView *ivTopBG;
    IBOutlet UIImageView *ivBtmBG;
    NSNumber *newBusinessType;
}

- (id)initWithBusinessType:(NSUInteger)type ParentView:(UIViewController*)parentView CloseCallBack:(SEL)closeCallBack;
- (IBAction)onSelectBtn:(id)sender;
- (IBAction)onPress:(id)sender;
@end
