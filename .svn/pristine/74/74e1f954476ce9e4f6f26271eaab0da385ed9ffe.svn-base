//
//  UIJYEXCZGS.h
//  NoteBook
//
//  Created by cyl on 13-4-29.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYEXUserAppInfo;

#import "EGORefreshTableHeaderView.h"

@interface UIJYEXCZGS : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UILabel *m_labelTitle;
    IBOutlet UIWebView *m_webAppWeb;
    IBOutlet UIButton *m_btnBrush;
    IBOutlet UIButton *m_btnCZGS;
    IBOutlet UIButton *m_btnYEGS;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *m_vwActivityBack;
    IBOutlet UIImageView *m_ivBrushAnimation;
    IBOutlet UIButton *m_btnSettings;
    
    int m_iSelectState;
    int iScreenWidth, iScreenHeight;
    NSString *sWidth;
    NSString *sHeight;
    NSMutableArray *urlArray;
    NSString *sAppUrl;
    
    CGFloat angle;
    NSTimer *timer;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, retain) NSString *sWidth;
@property (nonatomic, retain) NSString *sHeight;
@property (nonatomic, retain)NSString* sAppUrl;
-(IBAction)OnBack:(id)sender;
-(IBAction)OnSelect:(id)sender;
-(IBAction)OnSetting:(id)sender;

-(void)proAppLoadWeb;
-(void)setAppType:(int)appType;
@end
