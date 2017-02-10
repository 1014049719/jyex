//
//  UIWeb.h
//  NoteBook
//
//  Created by susn on 13-1-24.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PubFunction.h"

#import "EGORefreshTableHeaderView.h"

@interface UIWeb : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    IBOutlet UIWebView *m_webView;
    IBOutlet UILabel *m_lbTitle;
    IBOutlet UIButton *m_btnClose;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *m_vwActivityBack;
    

    MsgParam* msgParam;
    
    NSString *sWidth;
    NSString *sHeight;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //NSMutableArray *arrUrl;  //保存的URL堆栈
    //NSMutableArray *arrPageLevel; //和arrUrl对应
    //NSString *strCurUrl;   //当前的URL，如果新加载了URL，则把上一次带有pagelevel的URL入栈
    //NSString *strCurPageLevel; //当前的PageLevel
    //int nMaxPageLevel;
}

@property (nonatomic, retain) MsgParam* msgParam;
@property (nonatomic, retain) NSString *sWidth;
@property (nonatomic, retain) NSString *sHeight;

//@property (nonatomic, retain) NSString *strCurUrl;
//@property (nonatomic, retain) NSString *strCurPageLevel;
//@property (nonatomic, assign) int nMaxPageLevel;


-(IBAction)OnBack:(id)sender ;
-(IBAction)OnClose:(id)sender;


@end
