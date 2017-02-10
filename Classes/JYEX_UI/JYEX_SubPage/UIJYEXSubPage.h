//
//  UIJYEXCZGS.h
//  NoteBook
//
//  Created by cyl on 13-4-29.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetConstDefine.h"


@class JYEXUserAppInfo;

#import "EGORefreshTableHeaderView.h"

@interface UIJYEXSubPage : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UILabel *m_labelTitle;
    IBOutlet UIWebView *m_webAppWeb;
    IBOutlet UIButton *m_btnBrush;
    IBOutlet UIButton *m_btnMenuOne;
    IBOutlet UIButton *m_btnCZGS;
    IBOutlet UIButton *m_btnYEGS;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *m_vwActivityBack;
    IBOutlet UIImageView *m_ivBrushAnimation;
    IBOutlet UIButton *m_btnSettings;
    
    IBOutlet UIView *vwNoteType;
    IBOutlet UITableView *twNoteTypeList;
    IBOutlet UIButton *btnHideNoteTypeList;
    IBOutlet UIView *vwBack;
    
    int m_iSelectState;
    int iScreenWidth, iScreenHeight;
    NSString *sWidth;
    NSString *sHeight;
    NSMutableArray *urlArray;
    NSString *sAppUrl;
    
    CGFloat angle;
    NSTimer *timer;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //参数
    MsgParam* msgParam;
    
    //菜单数组
    NSArray *arrMenu;
    
    //发刷新内容消息标志
    BOOL m_bSndRefreshMsgFlag;
    //收到刷新内容消息标志
    BOOL m_bRcvRefreshMsgFlag;
    
    //当前页面加载是否已经完成
}

@property (nonatomic, retain) NSString *sWidth;
@property (nonatomic, retain) NSString *sHeight;
@property (nonatomic, retain) NSString* sAppUrl;
@property (nonatomic, retain) MsgParam  *msgParam;
@property (nonatomic, retain) NSArray *arrMenu;


-(IBAction)OnBack:(id)sender;
-(IBAction)OnSelect:(id)sender;
-(IBAction)OnSetting:(id)sender;

-(IBAction)onDispOrHideNoteType:(id)sender;
-(IBAction)onClickMenuOne:(id)sender;


-(void)proAppLoadWeb;
-(void)setAppType:(int)appType;
@end
