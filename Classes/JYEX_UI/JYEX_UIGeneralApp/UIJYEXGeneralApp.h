//
//  UIJYEXGeneralApp.h
//  NoteBook
//
//  Created by cyl on 13-4-27.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYEXUserAppInfo;
@interface UIJYEXGeneralApp : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UILabel *m_labelTitle;
    IBOutlet UIWebView *m_webAppWeb;
    IBOutlet UIButton *m_btnPaiZao;
    IBOutlet UIButton *m_btnBrush;
    IBOutlet UIButton *m_btnEditLog;
    
    IBOutlet UIButton *m_btnBanji;
    IBOutlet UIButton *m_btnGeren;
    IBOutlet UIButton *m_btnXiaoxi;
    IBOutlet UIButton *m_btnPinan;
    IBOutlet UIButton *m_btnHuike;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *m_vwActivityBack;
    IBOutlet UIImageView *m_ivBrushAnimation;
    NSArray *m_arrayNavBtn;
    int iScreenWidth, iScreenHeight;
    NSString *sWidth;
    NSString *sHeight;
    NSString *sAppUrl;
    JYEXUserAppInfo *appInfo;
    NSMutableArray *urlArray;
    int m_iCurBtnIndex;
    
    NSString *m_sAppCode;
    
    NSMutableArray *arrUrl;  //保存的URL堆栈
    NSMutableArray *arrPageLevel; //和arrUrl对应
    NSString *strCurUrl;   //当前的URL，如果新加载了URL，则把上一次带有pagelevel的URL入栈
    NSString *strCurPageLevel; //当前的PageLevel
    int nMaxPageLevel;
    
    CGFloat angle;
    NSTimer *timer;
}

@property (nonatomic, retain) NSString *sAppUrl;
@property (nonatomic, retain) NSString *sWidth;
@property (nonatomic, retain) NSString *sHeight;
@property (nonatomic, retain) JYEXUserAppInfo *appInfo;
@property (nonatomic, retain) NSString *m_sAppCode;
@property (nonatomic, retain) NSString *strCurUrl;
@property (nonatomic, retain) NSString *strCurPageLevel;
@property (nonatomic, assign) int nMaxPageLevel;

-(IBAction)OnBack:(id)sender ;
-(IBAction)OnSelect:(id)sender;
-(IBAction)OnBottomNav:(id)sender;
-(void)proLoadAppWeb:(NSString *)sTitle Code:(NSString*)sCode;
-(void)drawNavBtn;
-(int)getBtnIndexWithCode:(NSString*)sCode;
-(void)setBottomNavHidden;
-(void)setTitleWithUrl:(NSString *)url;
@end
