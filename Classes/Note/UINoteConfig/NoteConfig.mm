//
//  NoteConfig.m
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "Global.h"
#import "GlobalVar.h"
#import "NoteConfig.h"
#import "GlobalVar.h"
#import "CommonDef.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"
#import "CfgMgr.h"
#import "CommonAll.h"
//#import "FlurryAnalytics.h"
#import "UIImage+Scale.h"
#import "UIAstroAlert.h"




@implementation NoteConfig

@synthesize m_bTBWifiOnly ;
@synthesize m_bTBSXZWZBJ ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.    
    [self->m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [self->m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    if ( !strNavTitle || [strNavTitle isEqualToString:@""] ) strNavTitle = @"首页";
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnFinish.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnFinish.frame = rect;
    [self->m_btnFinish setTitle:strNavTitle forState:UIControlStateNormal];

    
    UIImage *imgFirst = [UIImage imageNamed:@"BiaoGeKuang2.png"];
    UIImage *imgEnd = [UIImage imageNamed:@"BiaoGeKuang3.png"];
    UIImage *imgInter = [UIImage imageNamed:@"BiaoGeKuang1.png"];
    
    //去掉软件密码功能，第一项的背景变为4个圆角
    //[m_btnFirst1 setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    UIImage *imgAll = [UIImage imageNamed:@"BiaoGeKuang.png"];
    [m_btnFirst1 setBackgroundImage:[imgAll stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    
    
    [m_btnFirst1 setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnEnd1 setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnEnd1 setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnFirst2 setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFirst2 setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnEnd2 setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnEnd2 setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnFirst3 setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFirst3 setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnEnd3 setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnEnd3 setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnFirst4 setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFirst4 setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnEnd4 setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnEnd4 setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnFirst5 setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFirst5 setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnEnd5 setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnEnd5 setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];

    [m_btnInter1 setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnInter1 setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnInter2 setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnInter2 setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnInter3 setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnInter3 setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnInter4 setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnInter4 setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    [m_btnInter5 setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnInter5 setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    
    CGSize contentSize = self->m_ScrollView.frame.size;
    contentSize.height
    = self->m_viLast.frame.origin.y +self->m_viLast.frame.size.height + 10 ;
    [self->m_ScrollView setContentSize:contentSize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self DrawView] ;
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

-(void)checkUserName
{
    if ( TheCurUser==nil
        || TheCurUser==NULL
        || [PubFunction stringIsNullOrEmpty:TheCurUser.sUserName]
        || [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME])
    {
        self->m_lbUserName.text = @"未登录";
        self->m_lbUserName.font = m_lbPassWordSet.font;
    }
    else if ( !TheCurUser.sNickName || [TheCurUser.sNickName length] <= 0 )
    {
        self->m_lbUserName.text = TheCurUser.sUserName;
    }
    else
    {
        self->m_lbUserName.text = TheCurUser.sNickName;
    }
}

-(void)getConfigFromSystem
{
    [self checkUserName];
    
    NSString *strValue = nil;
    BOOL b;
    //软件密码保护
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"SoftPwd" value:strValue];
    if ( !b || !(strValue) || strValue.length == 0 )
    {
        m_lbPassWordSet.text = @"未设置";
    }
    else
    {
        m_lbPassWordSet.text = @"已设置";
    }
    
    //仅在wifi打开时同步
    self->m_bTBWifiOnly = YES;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"DINoteWifioNoly" value:strValue];
    if ( b && strValue ) {
        if ( [strValue isEqualToString:@"NO"]) {
            self->m_bTBWifiOnly = NO;
        }
    }
    //同步时下载完整笔记
    strValue = nil;
    m_bTBSXZWZBJ = NO ;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"DlNoteContent" value:strValue];
    if ( b && strValue )  //查看配置是否下载完成内容
    {
        if ( [strValue isEqualToString:@"YES"]) {
            self->m_bTBSXZWZBJ = YES;
        }
    }
    
    //图像质量
    strValue = nil;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"NotePhotoQuality" value:strValue];
    if ( !b || !strValue || strValue.length == 0 ) {
        strValue = @"M";
    }
    
    if ( [strValue isEqualToString:@"L"] ) {
        self->m_lbTXZL.text = @"低质量";
    }
    else if( [strValue isEqualToString:@"H"] ) {
        self->m_lbTXZL.text = @"高质量";
    }
    else{
        self->m_lbTXZL.text = @" 中质量";
    }
    
    //字体
    strValue = nil;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"NoteFontSizeIndex" value:strValue];
    int iNoteFontSize = 3;
    if ( !b || !strValue || strValue.length == 0 ) {
        iNoteFontSize = 3;
    }
    else
    {
        iNoteFontSize = [strValue integerValue];
        if (iNoteFontSize >= NoteFontMaxIndex ) {
           iNoteFontSize = 3;
        }
    }
    iNoteFontSize = [_GLOBAL getFontWithIndex:iNoteFontSize];
    self->m_lbZTDX.text = [NSString stringWithFormat:@"%d", iNoteFontSize];
    
    //版本号
    m_lbVersion.text =[@"V" stringByAppendingString:[CommonFunc getAppVersion]];

}

-(IBAction)OnFinish:(id)sender
{
   //头栏完成按钮
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnChangeUser:(id)sender
{
    //切换用户
    [PubFunction SendMessageToViewCenter:NMNoteLogin :0 :1 :nil];
}

-(IBAction)OnPassWordSet:(id)sender
{
    //启动密码设置
    [PubFunction SendMessageToViewCenter:NMNoteSoftPwd :0 :1 :nil];
}

-(IBAction)OnTBSSCGX:(id)sender
{
    //[FlurryAnalytics logEvent:@"设置-自动同步"];
    
    self->m_bTBWifiOnly = !self->m_bTBWifiOnly;
    //同步时上传更新内容
    UIImage *pCheckImage = nil ; 
    
    if( self->m_bTBWifiOnly )
    {
       pCheckImage = [UIImage imageNamed:@"GouXuan-2.png"] ;
    }
    else
    {
       pCheckImage = [UIImage imageNamed:@"GouXuan-1.png"] ; 
    }
    [self->m_ivTBSSCGX setImage:pCheckImage] ;
    
    NSString *strValue=@"NO";
    if ( self->m_bTBWifiOnly ) strValue = @"YES";
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"DINoteWifioNoly" value:strValue]; 
}

-(IBAction)OnTBSXZWZBJ:(id)sender
{
    //[FlurryAnalytics logEvent:@"设置-下载完整笔记内容"];
    
    //同步时下载完整笔记内容
    m_bTBSXZWZBJ = !m_bTBSXZWZBJ ;
    
    UIImage *pCheckImage = nil ;
    if( m_bTBSXZWZBJ )
    {
       pCheckImage = [UIImage imageNamed:@"GouXuan-2.png"] ;
    }
    else
    {
       pCheckImage = [UIImage imageNamed:@"GouXuan-1.png"];
    }
    [self->m_ivTBSXZWZBJ setImage:pCheckImage] ;
    
    NSString *strValue=@"NO";
    if ( m_bTBSXZWZBJ ) strValue = @"YES";
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"DlNoteContent" value:strValue];  //查看配置是否下载完成内容
    
}

-(IBAction)OnTXZL:(id)sender
{
    //图片质量
    [PubFunction SendMessageToViewCenter:NMNotePhotoQuality :0 :1 :nil];
}

-(IBAction)OnZTDX:(id)sender 
{
    //字体大小
    [PubFunction SendMessageToViewCenter:NMNoteFont :0 :1 :nil];
}

-(IBAction)OnBJBCGS:(id)sender
{
    //[FlurryAnalytics logEvent:@"设置-笔记保存格式"];
    //笔记保存格式
}

-(IBAction)OnFolderManage:(id)sender
{
    //[FlurryAnalytics logEvent:@"设置-文件夹管理"];
    //文件夹管理
}

-(IBAction)OnFolderPassWordSet:(id)sender 
{
    //[FlurryAnalytics logEvent:@"设置-文件夹密码设置"];
    //文件夹密码设置
}

-(IBAction)OnYHFK:(id)sender
{
    //用户反馈
    
    //[PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    //NSInteger msg = ((UIButton*)sender).tag;
	//[PubFunction SendMessageToViewCenter:msg :0 :1 :nil];
 
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    // Attempt to find a name for this application
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    
    NSString *appVersion = [CommonFunc getAppVersion];
    
    
}


-(IBAction)OnCheckUpdate:(id)sender
{
    
    [UIAstroAlert info:@"正在检查，请稍候" :YES :NO];//一直遮住;
    
    
    [NSThread detachNewThreadSelector:@selector(_threadCheckUpdate:) toTarget:self withObject:self];
    /*
    //检查更新换
    TACheckUpdateParameter *param = [[TACheckUpdateParameter alloc]init];
    param.appID = [XUANSHANG_ID intValue];
    param.appIDApple = @"20001203";
    param.appLocalVersion = [CommonFunc getAppVersion];
    MARK_AUTORELEASE_OBJ(param);
    [TACheckUpdate netRequestLatestVersionCheck:param
                                       delegate:self
                                           sync:YES
                                 timeoutSeconds:15];
    */
}


#pragma mark -
#pragma mark 后台自动登录线程
-(void) _threadCheckUpdate:(id)argument {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    //检查更新换

		
	[pool release];
}



//------------------------------------------------


-(IBAction)OnAbout:(id)sender
{
   //关于本软件
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    NSInteger msg = ((UIButton*)sender).tag;
	[PubFunction SendMessageToViewCenter:msg :0 :1 :nil];
}

-(IBAction)OnVersionHistory:(id)sender
{
    
    //版本履历
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    NSInteger msg = ((UIButton*)sender).tag;
	[PubFunction SendMessageToViewCenter:msg :0 :1 :nil];
}

-(IBAction)OnHelp:(id)sender
{
    //帮助
    [PubFunction SendMessageToViewCenter:NMAppHelp :0 :1 :nil];
}

-(IBAction)OnMore91Soft:(id)sender
{
    
    //更多91软件
    [PubFunction SendMessageToViewCenter:NMAppInfo :0 :1 :nil];
    /*
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rj.91.com/"]];*/
}


-(IBAction)OnPingFen:(id)sender  //评分
{
    
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPLE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
}

-(void) DrawView
{
    [self getConfigFromSystem];
    //
    m_bTBWifiOnly = !m_bTBWifiOnly;
    [self OnTBSSCGX:nil];
    m_bTBSXZWZBJ = !m_bTBSXZWZBJ;
    [self OnTBSXZWZBJ:nil];
}

-(void) dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnFinish);
    SAFEREMOVEANDFREE_OBJECT(m_ScrollView);
    SAFEREMOVEANDFREE_OBJECT(m_lbUserName);
    SAFEREMOVEANDFREE_OBJECT(m_lbPassWordSet);
    SAFEREMOVEANDFREE_OBJECT(m_ivTBSSCGX);
    SAFEREMOVEANDFREE_OBJECT(m_ivTBSXZWZBJ);
    SAFEREMOVEANDFREE_OBJECT(m_lbTXZL);
    SAFEREMOVEANDFREE_OBJECT(m_lbZTDX);
    SAFEREMOVEANDFREE_OBJECT(m_lbWBGS);
    SAFEREMOVEANDFREE_OBJECT(m_lbFolderPassWordSet);
    SAFEREMOVEANDFREE_OBJECT(m_lbVersion);
    SAFEREMOVEANDFREE_OBJECT(m_viLast);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnFirst1) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnFirst2) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnFirst3) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnFirst4) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnFirst5) ;

    SAFEREMOVEANDFREE_OBJECT(m_btnInter1) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnInter2) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnInter3) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnInter4) ;
    
    SAFEREMOVEANDFREE_OBJECT(m_btnEnd1) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnEnd2) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnEnd3) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnEnd4) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnEnd5) ;
    
    [super dealloc] ;
}


@end
