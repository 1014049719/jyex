//
//  NoteMainPage.m
//  NoteBook
//
//  Created by cyl on 12-10-18.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "Global.h"
#import "GlobalVar.h"
#import "CfgMgr.h"

#import "UIAstroAlert.h"
#import "NoteMainPage.h"
#import "BizLogicAll.h"
#import "DBMngAll.h"
#import "DataSync.h"

//#import "FlurryAnalytics.h"

@implementation NoteMainPage
@synthesize statusBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->m_bChehua = NO;
        self->m_iSearchState = 0;
        self->m_strFirst = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFEREMOVEANDFREE_OBJECT(m_MainView1);
    SAFEREMOVEANDFREE_OBJECT(m_scrollMainView);
    SAFEREMOVEANDFREE_OBJECT(m_subViewMain1);
    SAFEREMOVEANDFREE_OBJECT(m_btnScrollBtn);
    SAFEREMOVEANDFREE_OBJECT(m_btnSearch);
    SAFEREMOVEANDFREE_OBJECT(m_btnSearch2);
    SAFEREMOVEANDFREE_OBJECT(m_scrollFolderList);
    SAFEREMOVEANDFREE_OBJECT(m_btnAddFolder);
    SAFEREMOVEANDFREE_OBJECT(m_btnSyc);
    SAFEREMOVEANDFREE_OBJECT(m_btnManageFolder);
    SAFEREMOVEANDFREE_OBJECT(m_textSearch);
    SAFEREMOVEANDFREE_OBJECT(m_labelNeedSys);
    SAFEREMOVEANDFREE_OBJECT(m_ivSearchBack);
    
    SAFEREMOVEANDFREE_OBJECT(m_MainView2);
    SAFEREMOVEANDFREE_OBJECT(m_ivCheHuaBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivBtnSelectBk);
    SAFEREMOVEANDFREE_OBJECT(m_btnMainPage);
    SAFEREMOVEANDFREE_OBJECT(m_lUserName);
    SAFEREMOVEANDFREE_OBJECT(m_btnUserName);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSJ);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSH);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSL);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSP);
    SAFEREMOVEANDFREE_OBJECT(m_btnZJBJ);
    SAFEREMOVEANDFREE_OBJECT(m_btnSetting);
    SAFEREMOVEANDFREE_OBJECT(m_btnShare);
    SAFEREMOVEANDFREE_OBJECT(m_ivZhongFeng);
    SAFEREMOVEANDFREE_OBJECT(m_ivSync);
    
    SAFEREMOVEANDFREE_OBJECT(m_ivSSJBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSHBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSLBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSPBk);
    SAFEREMOVEANDFREE_OBJECT(m_vwSubView1);
    SAFEREMOVEANDFREE_OBJECT(m_vwSubView2);

    [self->m_Folder release];
    self->m_Folder = nil;
    self.statusBar = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->m_textSearch.delegate = self;
    //[self->m_btnBack setBackgroundImage:[ReturnBk stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [self->m_ivBtnSelectBk setImage:[[UIImage imageNamed:@"chechuang_select.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];

    [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    
    // Do any additional setup after loading the view from its nib.
//    [self->m_srollFolderList setContentSize:CGSizeMake(298, 500)];
//    self->m_srollFolderList.delegate = self;
//    self->m_srollFolderList.directionalLockEnabled = YES;
    [m_btnSearch setImage:[UIImage imageNamed:@"btn_search2.png"] forState:UIControlStateNormal];
    [m_btnSearch setImage:[UIImage imageNamed:@"btn_search2.png"] forState:UIControlStateHighlighted];
     m_ivSearchBack.image = [[UIImage imageNamed:@"search_input.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    //自定义状态栏
    StatusBarWindow *statusBarWindow = [StatusBarWindow newStatusBarWindow];
    self.statusBar = statusBarWindow;
    [statusBarWindow release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFolderList) \
     name:NOTIFICATION_UPDATE_NOTE object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncNotification) \
     name:NOTIFICATION_UPDATE_NOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinishNotification:) \
     name:NOTIFICATION_SYNC_FINISH object:nil];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self->m_textSearch resignFirstResponder];
    [self drawMainPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( !self->m_strFirst ) {
        BOOL b = [AstroDBMng getCfg_cfgMgr:@"SoftFitstRun" name:@"" value:self->m_strFirst];
        if ( !b || self->m_strFirst.length == 0 ) {
            self->m_strFirst = [NSString stringWithFormat:@"YES"];
            [AstroDBMng setCfg_cfgMgr:@"SoftFitstRun" name:@"" value:self->m_strFirst];
            [self performSelector:@selector(onCheHua:) withObject:self afterDelay:0.15];
            [self performSelector:@selector(onCheHua:) withObject:self afterDelay:1];
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)drawMainPage
{
    [self getUserName];
    CGRect r = self->m_ivCheHuaBk.frame;
    self->m_fMainViewOffset = r.size.width;
    r = self->m_subViewMain1.frame;
    r.origin.x = self->m_fMainViewOffset;
    self->m_subViewMain1.frame = r;
    
    self->m_btnSearch.hidden = NO;
    self->m_btnSearch2.hidden = YES;
    self->m_textSearch.hidden = YES;
    self->m_ivSearchBack.hidden = YES;
    int iNeedSys = [BizLogic needSyncNotesCount];
    if ( iNeedSys ) {
        self->m_labelNeedSys.text = [NSString stringWithFormat:@"%d", iNeedSys];
    }
    else
    {
        self->m_labelNeedSys.text = [NSString stringWithFormat:@" "];
    }
    
    self->m_ScrollMainViewContentSize = CGSizeMake(self->m_scrollMainView.frame.size.width, self->m_scrollMainView.frame.size.height);
    self->m_ScrollMainViewContentSize.width += self->m_fMainViewOffset;
    [self->m_scrollMainView setContentSize:self->m_ScrollMainViewContentSize];
    [self->m_scrollMainView setContentOffset:CGPointMake(self->m_fMainViewOffset, 0)];
    self->m_scrollMainView.delegate = self;
    self->m_scrollMainView.directionalLockEnabled = YES;
    [self drawFolder];
}

-(void)drawMainPageAnimation
{
    float newX;
    CGRect rectOld = self->m_MainView1.frame;
    
    if ( self->m_bChehua ) {
        //[FlurryAnalytics logEvent:@"抽屉菜单-首页"];
        
        newX = 0;
        //self->m_ivZhongFeng.hidden = YES;
    }
    else
    {
        //[FlurryAnalytics logEvent:@"抽屉菜单-首页"];
        
        newX = self->m_fMainViewOffset;
        CGSize s = self->m_ScrollMainViewContentSize;
        s.width += self->m_fMainViewOffset;
        [self->m_scrollMainView setContentSize:s];
    }
    self->m_bChehua = !(self->m_bChehua);
    CGRect r2 = self->m_ivZhongFeng.frame;
    r2.origin.x = newX - r2.size.width / 2.0;
    CGContextRef contex = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:contex];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    [self->m_MainView1 setFrame:CGRectMake(newX
    , rectOld.origin.y, rectOld.size.width, rectOld.size.height )];
    [self->m_ivZhongFeng setFrame:r2];
    [UIView commitAnimations];
    
}

- (void) animationFinished: (id) sender
{
        if ( self->m_bChehua ) {
            //self->m_ivZhongFeng.hidden = NO;
        }
}

-(void)drawFolder
{
    if (self->m_Folder) {
        [self->m_Folder removeFromSuperview];
        [self->m_Folder release];
        self->m_Folder = nil;
    }
    self->m_Folder = [[UIFolderList alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self->m_Folder drawFolderList];
    [self->m_scrollFolderList addSubview:self->m_Folder];
    [self->m_scrollFolderList setContentSize:self->m_Folder.frame.size];
}

-(void)getUserName
{
    if ( TheCurUser==nil
        || TheCurUser==NULL
        || [PubFunction stringIsNullOrEmpty:TheCurUser.sUserName]
        || [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME]
       )
    {
        self->m_lUserName.text = @"点击这里登录";
    }
    else if ( !TheCurUser.sNickName || [TheCurUser.sNickName length] <= 0 )
    {
        self->m_lUserName.text = TheCurUser.sUserName;
    }
    else
    {
        self->m_lUserName.text = TheCurUser.sNickName;
    }
}

-(void)reloadFolderList
{
    [self drawFolder];
    int iNeedSys = [BizLogic needSyncNotesCount];
    if ( iNeedSys ) {
        self->m_labelNeedSys.text = [NSString stringWithFormat:@"%d", iNeedSys];
    }
    else
    {
        self->m_labelNeedSys.text = [NSString stringWithFormat:@" "];
    }
    
    [self getUserName];

}

#pragma mark - srcoll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( scrollView == self->m_scrollMainView )
    {
        CGPoint p = scrollView.contentOffset;
        //NSLog(@"offset1:%f\r\n", p.x);
        CGRect r = self->m_MainView1.frame;
        r.origin.x += (self->m_fMainViewOffset - p.x);
        
        p.x = self->m_fMainViewOffset;
        scrollView.contentOffset = p;
        if ( r.origin.x >= (self->m_fMainViewOffset - 2.0) || r.origin.x < 0 ) {
            r.origin.x = self->m_fMainViewOffset;
            return;
        }
        //self->m_ivZhongFeng.hidden = YES;
        [self->m_MainView1 setFrame:r];
        CGRect r2 = self->m_ivZhongFeng.frame;
        r2.origin.x = r.origin.x - r2.size.width / 2.0;
        self->m_ivZhongFeng.frame = r2;
        CGSize s = self->m_ScrollMainViewContentSize;
        s.width += r.origin.x;
        [scrollView setContentSize:s];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //CGPoint pt = scrollView.contentOffset;
    //NSLog(@"EndDragging: (%f, %f)", pntNow.x, pntNow.y);
    
    if (decelerate == NO)
        [self scrollViewDidEndDecelerating:scrollView];
    
//    if (pt.x<-50.0)
//        [self switchYunshiInfo:ETSD_RIGHT];
//    else if (pt.x>50.0)
//        [self switchYunshiInfo:ETSD_LEFT];
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CGPoint pt = scrollView.contentOffset;
//    pt.x = 0.0f;
//    scrollView.contentOffset = pt;
    CGRect rectOld = self->m_MainView1.frame;
    if ( (!self->m_bChehua) && (rectOld.origin.x < 50) )
    {
        self->m_bChehua = YES;
    }
    else if( self->m_bChehua && (rectOld.origin.x + 50 >= self->m_fMainViewOffset) )
    {
        self->m_bChehua = NO;
    }
    [self drawMainPageAnimation];
    
}

#pragma mark - 控件响应函数
- (IBAction) onCheHua :(id)sender
{
    [self drawMainPageAnimation];
}

- (IBAction) onDownBtnOnMainView2:(id)sender
{
    static UIButton *s_btn = nil;
    UIButton *btn = (UIButton*)sender;
    assert(btn);
    if ( btn != s_btn ) {
        if( btn == self->m_btnSSH )
            [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSJ )
            [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSL )
            [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSP )
            [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];

//        if( s_btn == self->m_btnSSH )
//            [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSJ )
//            [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSL )
//            [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSP )
//            [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    }
    CGRect r = btn.frame;
    if( btn == self->m_btnSSH
            || btn == self->m_btnSSJ
            || btn == self->m_btnSSL
            || btn == self->m_btnSSP)
    {
        r.origin.x += self->m_vwSubView2.frame.origin.x;
        r.origin.y += self->m_vwSubView2.frame.origin.y;
    }
    else if( btn == self->m_btnShare
            || btn == self->m_btnSetting
            || btn == self->m_btnZJBJ)
    {
        r.origin.x += self->m_vwSubView1.frame.origin.x;
        r.origin.y += self->m_vwSubView1.frame.origin.y;
    }
    self->m_ivBtnSelectBk.frame = r;
    s_btn = btn;
}

- (IBAction) onUpBtnOnMainView2:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( btn == self->m_btnMainPage ) {
        [self onCheHua:sender];
    }
    else if( btn == self->m_btnSSH )
    {
        [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        //[FlurryAnalytics logEvent:@"抽屉菜单-随手画"];
        [self selectBusinessType:NEWNOTE_DRAW];
    }
    else if( btn == self->m_btnSSJ )
    {
        [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        //[FlurryAnalytics logEvent:@"抽屉菜单-随手记"];
        [self selectBusinessType:NEWNOTE_EDIT];
    }
    else if( btn == self->m_btnSSL )
    {
        [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        //[FlurryAnalytics logEvent:@"抽屉菜单-随手录"];
        [self selectBusinessType:NEWNOTE_RECORD];
    }
    else if( btn == self->m_btnSSP )
    {
        [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        //[FlurryAnalytics logEvent:@"抽屉菜单-随手拍"];
        [self selectBusinessType:NEWNOTE_CAMERA];
    }
    else if( btn == self->m_btnShare )
    {
        //[FlurryAnalytics logEvent:@"抽屉菜单-共享查看"];
        return;
    }
    else
    {
        //if ( btn.tag == NMNoteConfig ) [FlurryAnalytics logEvent:@"抽屉菜单-设置"];
        //else if ( btn.tag == NMNoteLogin ) [FlurryAnalytics logEvent:@"抽屉菜单-用户名"];
        //else if ( btn.tag == NMNoteLast ) [FlurryAnalytics logEvent:@"抽屉菜单-最新笔记"];
        
        int tag = btn.tag;
        [PubFunction SendMessageToViewCenter:tag :0 :1 :nil];
    }
}

- (IBAction) onSearch:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( btn == self->m_btnSearch ) {
        self->m_btnSearch.hidden = YES;
        self->m_btnSearch2.hidden = NO;
        self->m_textSearch.hidden = NO;
        self->m_ivSearchBack.hidden = NO;
        [self->m_textSearch becomeFirstResponder];
    }
    else if( btn == self->m_btnSearch2 )
    {
        if ( 1 == self->m_iSearchState ) {
            [self->m_textSearch resignFirstResponder];
            NSString *strSearch = self->m_textSearch.text;
            if ( !strSearch || [strSearch length]<= 0 ) return;
            
            //[FlurryAnalytics logEvent:@"首页-搜索"];
            [_GLOBAL setSearchString:strSearch];
            [_GLOBAL setSearchCatalog:nil];
            self->m_textSearch.text = nil;
            [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
            [PubFunction SendMessageToViewCenter:NMNoteSearch :0 :1 :nil];
        }
        else
        {
            self->m_btnSearch2.hidden = YES;
            self->m_textSearch.hidden = YES;
            self->m_ivSearchBack.hidden = YES;
            self->m_btnSearch.hidden = NO;
            [self->m_textSearch resignFirstResponder];
        }
    }
}

- (IBAction) onAddFiles:(id)sender
{
    NSString *strDefaultFolderGUID = [_GLOBAL defaultCateID];
    [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT \
    catalog:strDefaultFolderGUID noteinfo:nil];
	[PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    
}

-(IBAction)OnBtnFullScreen:(id)sender
{
    [m_textSearch resignFirstResponder];
}


-(void)sendSyncCommand2
{
    //开始转动
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    m_ivSync.hidden = NO;
    m_btnSyc.hidden = YES;
    
    //[FlurryAnalytics logEvent:@"首页-刷新"];
    //同步，但不下载内容
    [[DataSync instance] syncRequest:BIZ_SYNC_DOWNCATALOG_NOTE_UPLOADNOTE :self :@selector(syncCallback:) :nil];
}

-(void)sendSyncCommand
{
    NSString *strValue=@"NO";
    [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"DlNoteContent" value:strValue];  //查看配置是否下载完成内容
    if ( [strValue isEqualToString:@"YES"] ) {
        UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"您在设置中勾选了\"同步时下载完整笔记内容\"的选项，同步过程可能较久，您确定继续同步吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertview show];
        [alertview release];
        return;
    }
    
    [self sendSyncCommand2];
}

//UIAlertView的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) { //取消
        return;
    }
    else { //同步
        [self sendSyncCommand2]; 
    }
}


- (IBAction) onSync:(id)sender
{
    //查看网络是否正常
    if ([[Global instance] getNetworkStatus] == NotReachable)  
    { //网络不正常
        NSString *strMsg = @"网络无法连接，请检查网络设置";
        //[UIAstroAlert info:strMsg :3.0 :NO :LOC_MID :NO];
        [statusBar dispStatusBar:strMsg];
        return;
    }
    
    
    if ( [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] || ( !TheCurUser.isLogined && TheCurUser.iSavePasswd != 1)  )
    {
        //发送登录消息
        //[UIAstroAlert info:@"请先登录再同步" :2.0 :NO :LOC_MID :NO];
        [statusBar dispStatusBar:@"请先登录再同步"];
        [PubFunction SendMessageToViewCenter:NMNoteLogin :0 :1 :[MsgParam param:self :@selector(loginCallback:) :nil :0]];
        return;
    }
    
    //同步，但不下载内容
    [self sendSyncCommand];
}


- (IBAction) onSelectBtn:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    [PubFunction SendMessageToViewCenter:btn.tag :0 :1 :nil];
}

- (void) selectBusinessType:(int)type
{
    NSString *defaultCateID = [_GLOBAL defaultCateID];
    [_GLOBAL setEditorAddNoteInfo:type catalog:defaultCateID noteinfo:nil];
    //[PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self onSearch:self->m_btnSearch2];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strSearch = textField.text;
    if ( (!string || string.length == 0)
        && ( !strSearch || strSearch.length <= 1 )) {
        [self->m_btnSearch2 setTitle:@"关闭" forState:nil];
        self->m_iSearchState = 0;
    }
    else
    {
        [self->m_btnSearch2 setTitle:@"搜索" forState:nil];
        self->m_iSearchState = 1;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self->m_btnSearch2 setTitle:@"关闭" forState:nil];
    self->m_iSearchState = 0;
    return  TRUE;
}


//同步完成通知
-(void)syncFinishNotification:(NSNotification *)notification
{
    NSString *strText = @"同步完成";
    if ( notification.object ) strText = (NSString *)notification.object;
    [statusBar dispStatusBar:strText];
}



//登录回调
- (void) loginCallback :(TBussStatus*)sts
{    
	if (sts && sts.iCode == 1)  //成功
	{
        [self getUserName];
        [self sendSyncCommand];
	}
}

//同步回调
- (void)syncCallback:(TBussStatus*)sts
{
    NSLog(@"------同步返回了");
    
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    m_ivSync.hidden = YES;
    m_btnSyc.hidden = NO;
}

//定时执行刷新
-(void)updateImage
{
    angle = angle + (2*3.1415926)*0.1;
    m_ivSync.transform = CGAffineTransformMakeRotation(angle);
}

-(IBAction)OnFolderManage:(id)sender
{
    [_GLOBAL setParentFolderID:@""];
    [PubFunction SendMessageToViewCenter:NMFolderManage :0 :1 :nil];
}


@end
