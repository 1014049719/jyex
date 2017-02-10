//
//  UIVCSettingBlogBind.h
//  Weather
//
//  Created by nd on 11-11-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "PubFunction.h"

enum 
{
    BBP_BindtoSNS = 1,
    BBP_Unbind = 2,
    BBP_QueryStatus = 3,
};

@interface BlogBindParam : NSObject
{
	int bbpType, snsType;
	NSString *snsName;
}

@property(nonatomic) int bbpType, snsType;
@property(nonatomic, copy) NSString *snsName;

+ (BlogBindParam*) param :(NSString*)name :(int)type :(int)bbpType;

@end



@interface UIVCSettingBlogBind : UIViewController<UIWebViewDelegate> {
	
    IBOutlet UILabel *lbTSGZ, *lbYLSM, *lbK, *lbG, *lbCap;
    IBOutlet UIWebView *web;
    IBOutlet UILabel *lbTips;
    IBOutlet UILabel *lbNickname;
    IBOutlet UIImageView *imgViewAvatar;

    BOOL sessionChecked;
    BOOL isBack;
    NSString *urlBind;
    IBOutlet UILabel *titleLabel;
	UIActivityIndicatorView *indicateView;
    
    MsgParam*   msgParam;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicateView;
//@property (nonatomic, assign) NSInteger snsType;
//@property (nonatomic, copy) NSString *snsName;
@property (nonatomic, copy) NSString *urlBind;       
@property (nonatomic, retain) UIWebView *web;
@property (nonatomic, retain) UILabel *lbTips;
@property (nonatomic, retain) IBOutlet UILabel *lbNickname;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewAvatar;
@property (nonatomic, retain) MsgParam*   msgParam;

//- (void) showLeaveMsg:(NSString*)msg;

- (IBAction)returnBtnPress:(id)sender;

// 打开绑定窗口
- (void) bindToSNS;

// 查询绑定情况
- (void) queryBindStatus;

// 取消授权，并显示状态
- (void) unbindStatus;

- (void) showOperationResultMessage:(NSString *)msg;




@end
