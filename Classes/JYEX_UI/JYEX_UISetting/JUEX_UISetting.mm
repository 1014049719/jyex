//
//  JUEX_UISetting.m
//  JYEX
//
//  Created by cyl on 13-6-2.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "CommonDef.h"
#import "Global.h"
#import "GlobalVar.h"
#import "PubFunction.h"
#import "JUEX_UISetting.h"
#import "UIAstroAlert.h"
#import "CommonAll.h"
#import "UIJYEXUpdatePassword.h"

@implementation JUEX_UISetting
@synthesize bussUpdataSoft;

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

-(void) dealloc
{
    [bussUpdataSoft cancelBussRequest];
    self.bussUpdataSoft = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SAFEREMOVEANDFREE_OBJECT(self->m_lVersion);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_lUserName);
    SAFEREMOVEANDFREE_OBJECT(self->m_lNickName);
    SAFEREMOVEANDFREE_OBJECT(self->m_lNetType);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnLogin);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbCacheSize) ;
    SAFEREMOVEANDFREE_OBJECT(self->m_scrollview);
    SAFEREMOVEANDFREE_OBJECT(self->m_viCenter);
    SAFEREMOVEANDFREE_OBJECT(self->m_viUpdateMM);
    SAFEREMOVEANDFREE_OBJECT(self->m_ivAvatar);
    
    
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef VER_YEZZB
#else
    m_viUpdateMM.frame = m_viCenter.frame;
    m_viCenter.hidden = YES;
#endif
    
    self->m_scrollview.delegate = self;
    
    self->m_lUserName.text = TheCurUser.sUserName;
    self->m_lNickName.text = TheCurUser.sNickName;

    
    NSString *s = self->m_lNetType.text;
    NetworkStatus netType = [[Global instance] getNetworkStatus];
    switch ( netType ) {
        case kNotReachable:
            s = [s stringByAppendingString:@" 不可用"];
            break;
        case kReachableViaWWAN:
            s = [s stringByAppendingString:@" 2G/3G/4G"];
            break;
        case kReachableViaWiFi:
            s = [s stringByAppendingString:@" WIFI"];
            break;
        default:
            break;
    }
    self->m_lNetType.text = s;

    self->m_lVersion.text = [CommonFunc getAppVersion];
    
    //[self setCacheSizeTitle] ;
    [self updateAvatar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatar) \
                                                 name:NOTIFICATION_UPDATE_AVATAR object:nil];  //更新头像

    //2015.1.29
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:NOTIFICATION_LOGIN_SUCCESS object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    CGSize size = m_scrollview.frame.size;
    size.height += 20;
    m_scrollview.contentSize = size;
    
    [super viewDidAppear:animated];
    
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



//更新头像
-(void)updateAvatar
{
    if ( [CommonFunc isFileExisted:[CommonFunc getAvatarPath]] ) { //头像存在
        UIImage *img = [UIImage imageWithContentsOfFile:[CommonFunc getAvatarPath]];
        //CGSize size = img.size;
        m_ivAvatar.image = img;
    }
    else {
        NSString *strDefault = [[NSBundle mainBundle] pathForResource:@"default_avatar@2x" ofType:@"png"];
        m_ivAvatar.image = [UIImage imageWithContentsOfFile:strDefault];
    }
}


-(IBAction)onLogin:(id)sender
{
    NSNumber *num = [NSNumber numberWithInt:1];
    [PubFunction SendMessageToViewCenter:NMJYEXLogin :0 :1 :num];
}

-(IBAction)OnBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}


-(IBAction)OnCheckVer:(id)sender
{
    NSLog(@"%@", TheGlobal.sUpdataSoftUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TheGlobal.sUpdataSoftUrl]];
    
    //[UIAstroAlert info:@"正在检测，请稍候" :0 :YES :0 :0];
    
    //[bussUpdataSoft cancelBussRequest];
	//self.bussUpdataSoft = [BussMng bussWithType:BMJYEXUpdataSoft];
    //[bussUpdataSoft request:self :@selector(checkVerCallback:) :nil];
}

- (void)checkVerCallback:(TBussStatus*)sts
{
	[bussUpdataSoft cancelBussRequest];
	self.bussUpdataSoft = nil;
	
    [UIAstroAlert infoCancel];
    if ( sts.iCode == 200) {
        if ( [TheGlobal getUpdataSoftFlag] ) {
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"现已检测到有新的版本,需要立即升级吗?" delegate:self cancelButtonTitle:@"下次" otherButtonTitles:@"升级",nil];
            [alertview show];
            [alertview release];
        }
        else {
            MESSAGEBOX(@"当前已是最新版本。");
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [TheGlobal resetUpdataSoftFlag];
    if ( buttonIndex == 0 ) { //取消
    }
    else { //
        //@"itms://itunes.apple.com/app/sandman/id388887746?mt=8&uo=4"
        //@"http://itunes.apple.com/app/id672633361?mt=8"
        //https://itunes.apple.com/us/app/jia-yuane-xian/id672633361?mt=8&uo=4";
        //@"itms://itunes.apple.com/us/app/jia-yuane-xian/id672633361?mt=8&uo=4";
        
        NSLog(@"%@", TheGlobal.sUpdataSoftUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TheGlobal.sUpdataSoftUrl]];
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        NSString *strPath = [CommonFunc getTempDir] ;
        NSLog( @"缓存目录为:[%@]", strPath ) ;
        NSFileManager *fm = [NSFileManager defaultManager] ;
        NSArray *flist = [fm contentsOfDirectoryAtPath:strPath error:nil];
        NSLog( @"%@", flist ) ;
        [fm changeCurrentDirectoryPath:strPath] ;
        for( NSString *obj in flist )
        {
            [fm removeItemAtPath:obj error:nil] ;
        }
        
        self->m_lbCacheSize.text = @"当前缓存：0 M" ;
    }
}

-(IBAction)onClearCache:(id)sender
{
    UIActionSheet *av = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除缓存" otherButtonTitles:nil, nil] ;
    [av showInView:[UIApplication sharedApplication].keyWindow] ;
    [av release] ;
}

- (long long)getCacheSize
{
    float result = 0.0f ;
    
    NSString *strPath = [CommonFunc getTempDir] ;
    NSLog( @"缓存目录为:[%@]", strPath ) ;
    NSFileManager *fm = [NSFileManager defaultManager] ;
    NSArray *flist = [fm contentsOfDirectoryAtPath:strPath error:nil];
    NSLog( @"%@", flist ) ;
    [fm changeCurrentDirectoryPath:strPath] ;
    for( NSString *obj in flist )
    {
        result = result + [[fm attributesOfItemAtPath:obj error:nil] fileSize] ;
    }
    
    return result ;
}

- (void)setCacheSizeTitle
{
    NSString *str = @"Bytes" ;
    long long size = [self getCacheSize] ;
    
    if( size > 1024 )
    {
        size = size / 1024.0 ;
        str = @"K" ;
    }
    if( size > 1024 )
    {
        size = size / 1024.0 ;
        str = @"M" ;
    }
    if( size > 1024 )
    {
        size = size / 1024.0 ;
        str = @"G" ;
    }
    
    float s = size ;
    
    self->m_lbCacheSize.text = [NSString stringWithFormat:@"当前缓存：%.3f %@", s, str ] ;
}


-(IBAction)onWebInfo:(id)sender
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    NSString *strURL;
    NSString *s = @"mobile.php?mod=space&ac=personal_center_index";
    strURL = [NSString stringWithFormat:@"%@%@&fbl=%.0f%@%.0f",CS_URL_BASE,s, rect.size.width, @"X",rect.size.height];
    
    
    [PubFunction SendMessageToViewCenter:NMWebView :0 :1 :[MsgParam param:nil :nil :strURL :0]];
    
}


-(IBAction)onUpdatePassword:(id)sender
{
    //[PubFunction SendMessageToViewCenter:NMJYEXUpdatePassword :0 :1 :nil];
    
    UIJYEXUpdatePassword *vc = [[UIJYEXUpdatePassword alloc] initWithNibName:@"UIJYEXUpdatePassword" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


- (void)onLoginSuccess
{
    self->m_lUserName.text = TheCurUser.sUserName;
    [self setCacheSizeTitle] ;
    
    //退出
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
  
}



- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}



@end
