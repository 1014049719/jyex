//
//  UIVCSettingBlogSet.h
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThemeManager.h"
#import "PubFunction.h"


@interface UIVCSettingBlogSet : UIViewController{
    IBOutlet UILabel *lbSZJJ, *lbCap;
    IBOutlet UIButton *btnBack, *btnSwitchUnbind;
    IBOutlet UITableView *tableViewBind;
    
//    IBOutlet UILabel *label1, *label2;
    
	NSArray    *dbData;
    
    BOOL unbind_state;
    BOOL isBack;
    
    MsgParam*   msgParam;
}

@property(retain, nonatomic) NSArray *dbData;
@property(retain, nonatomic) IBOutlet UITableView *tableViewBind;
@property(retain, nonatomic) UIButton *btnSwitchUnbind;
@property(retain, nonatomic) MsgParam* msgParam;

- (IBAction)returnBtnPress:(id)sender;
- (IBAction)btnSwitchUnbindClick:(id)sender;
- (IBAction)btnBindClick: (id)sender;
- (IBAction)btnQueryBindClick: (id)sender;
- (IBAction)btnUnbindClick: (id)sender;

/*
// 关闭等待提示窗口
- (void) closeWaitView;
// 显示等待窗口
-(void) showWaitView:(NSString *)title;
*/

@end
