//
//  UIBusinessList.h
//  Astro
//
//  Created by cyl on 12-7-10.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBusinessList : UIViewController
{
    IBOutlet UIButton* btn_RGTZ;    //人格特质
    IBOutlet UIButton* btn_YunShi; //运势
    IBOutlet UIButton* btn_TestName; //姓名测试
    IBOutlet UIButton* btn_MathName; //姓名匹配
    IBOutlet UIButton* btn_LoveTaoHua; //爱情桃花
    IBOutlet UIButton* btn_Money; //财富趋势
    IBOutlet UIButton* btn_Career; //事业成长
    
    IBOutlet UIView *anmView;
    
    IBOutlet UIImageView *ivTopBG;
    IBOutlet UIImageView *ivBtmBG;
    NSUInteger businessType;
    
    UIViewController* vcParent;
    SEL	closeListCallback;
    
    NSNumber *newBusinessType;
}

- (id)initWithBusinessType:(NSUInteger)type ParentView:(UIViewController*)parentView CloseCallBack:(SEL)closeCallBack;
- (IBAction)onSelectBtn:(id)sender;
- (IBAction)onPress:(id)sender;
@end
