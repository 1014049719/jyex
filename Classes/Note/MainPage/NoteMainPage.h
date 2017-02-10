//
//  NoteMainPage.h
//  NoteBook
//
//  Created by cyl on 12-10-18.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderList.h"
#import "UIFilesList.h"
#import "StatusBarWindow.h"


@interface NoteMainPage : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIView* m_MainView1;
    IBOutlet UIScrollView *m_scrollMainView;
    IBOutlet UIView *m_subViewMain1;
    IBOutlet UIButton *m_btnScrollBtn;
    IBOutlet UIButton *m_btnSearch;
    IBOutlet UIButton *m_btnSearch2;
    IBOutlet UIScrollView *m_scrollFolderList;
    IBOutlet UIButton *m_btnAddFolder;
    IBOutlet UIButton *m_btnSyc;
    IBOutlet UIButton *m_btnManageFolder;
    IBOutlet UITextField *m_textSearch;
    IBOutlet UILabel *m_labelNeedSys;
    IBOutlet UIImageView *m_ivSearchBack;
    
    IBOutlet UIView* m_MainView2;
    IBOutlet UIView* m_vwSubView1;
    IBOutlet UIView* m_vwSubView2;
    IBOutlet UIImageView* m_ivCheHuaBk;
    IBOutlet UIImageView *m_ivBtnSelectBk;
    IBOutlet UIButton* m_btnMainPage;
    IBOutlet UILabel *m_lUserName;
    IBOutlet UIButton* m_btnUserName;
    IBOutlet UIImageView *m_ivSSJBk;
    IBOutlet UIImageView *m_ivSSHBk;
    IBOutlet UIImageView *m_ivSSLBk;
    IBOutlet UIImageView *m_ivSSPBk;
    IBOutlet UIButton* m_btnSSJ;
    IBOutlet UIButton* m_btnSSH;
    IBOutlet UIButton* m_btnSSL;
    IBOutlet UIButton* m_btnSSP;
    IBOutlet UIButton* m_btnZJBJ;
    IBOutlet UIButton* m_btnSetting;
    IBOutlet UIButton* m_btnShare;
    IBOutlet UIImageView* m_ivSync;
    
    IBOutlet UIImageView *m_ivZhongFeng;
    IBOutlet UIButton      *m_btnFullScreen; //全屏幕按钮
    
    UIFolderList *m_Folder;
    int m_iSearchState;
    
    BOOL m_bChehua; //标识主页当前是否已经侧滑
    float m_fMainViewOffset;
    CGSize m_ScrollMainViewContentSize;
    
    StatusBarWindow *statusBar;  //自定义状态栏
    NSString *m_strFirst;
    
    CGFloat angle;
    NSTimer *timer;
}

@property (nonatomic, retain) StatusBarWindow *statusBar;


- (IBAction) onCheHua :(id)sender;
- (IBAction) onDownBtnOnMainView2:(id)sender;
- (IBAction) onUpBtnOnMainView2:(id)sender;
- (IBAction) onSearch:(id)sender;
- (IBAction) onAddFiles:(id)sender;
- (IBAction) onSync:(id)sender;
- (IBAction) onSelectBtn:(id)sender;
-(IBAction)OnBtnFullScreen:(id)sender;
-(IBAction)OnFolderManage:(id)sender;

- (void) selectBusinessType:(int)type;
- (void) animationFinished: (id) sender;
-(void)drawMainPage;
-(void)drawFolder;
- (void)drawMainPageAnimation;
-(void)getUserName;
-(void)reloadFolderList;


@end
