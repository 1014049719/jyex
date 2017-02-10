//
//  UIJYEXMainPage.m
//  NoteBook
//
//  Created by cyl on 13-4-24.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "BizLogicAll.h"
#import "Global.h"
#import "GlobalVar.h"
#import "UIAppList.h"
#import "UIAstroAlert.h"
#import "UIJYEXMainPage.h"
#import "DataSync.h"
#import "CommonAll.h"
#import "CImagePicker.h"
#import "UIPictureSender.h"
#import "UIImageEditorVC.h"
#import "jyexum_even_define.h"

@implementation UIJYEXMainPage

@synthesize boughtApp;
@synthesize nominateApp;
@synthesize bussRequest;

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

-(void)dealloc
{
    //退出前做清除工作
    if ( timer ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryUpdateNumber) object:nil];
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.bussRequest cancelBussRequest];
    self.bussRequest = nil;
    
    
    SAFEREMOVEANDFREE_OBJECT(self->m_imTips);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_lableSection1);
    SAFEREMOVEANDFREE_OBJECT(self->m_lableSection2);
    SAFEREMOVEANDFREE_OBJECT(self->m_swAppList);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnCamer);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnEditLog);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSend);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSetting);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_labelComTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_twComText);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnClostCom);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwComBack);
    
    self.boughtApp = nil;
    self.nominateApp = nil;
    
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self createAppList];
    [self drawAppList];
    [self updataLanmuMsgNum];
    [self queryUpdateNumber];
    
    [self updateUploadNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataLanmuMsgNum) name:NOTIFICATION_UPDATE_LANMU_MSGNUM object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUploadNum) name:NOTIFICATION_UPDATE_UPLOADNUM object:nil];

    //定时器
    if ( timer ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryUpdateNumber) object:nil];
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(queryUpdateNumber) userInfo:nil repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self updateUploadNum];
    
    if ( [[Global instance] getNetworkStatus] == NotReachable ) {
        return;
    }
    
    if ( m_timeinterval <= 0.1 || [[NSDate date] timeIntervalSince1970] - m_timeinterval >= 120.0  )
        [self queryUpdateNumber];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)createAppList
{
    CGRect rect = self->m_lableSection1.frame;
    rect.origin.y = rect.origin.y + rect.size.height;
    UIAppList * v =  [[UIAppList alloc] initWithFrame:rect];
    v.sHaveNoAppString = @"没有开通应用.";
    [v setAppDelegate:self Select:@selector(onSelectApp:)];
    v.tag = 2001;
    [m_swAppList addSubview:v];
    [v release];
    
    v = [[UIAppList alloc] initWithFrame:rect];
    v.sHaveNoAppString = @"没有推荐的应用.";
    [v setAppDelegate:self Select:@selector(onSelectApp:)];
    v.tag = 2002;
    [m_swAppList addSubview:v];
    [v release];
}

-(void)releaseAppListSubViews
{
    UIAppList *vBoungth =(UIAppList *)[m_swAppList viewWithTag:2001];
    NSArray *arrSubView = [vBoungth subviews];
    for ( UIView *subview in arrSubView) {
        [subview removeFromSuperview];
    }
    
    UIAppList *vNominate =(UIAppList *)[m_swAppList viewWithTag:2002];
    arrSubView = [vNominate subviews];
    for ( UIView *subview in arrSubView) {
        [subview removeFromSuperview];
    }
}



-(void)drawAppList
{
    self.boughtApp = [BizLogic getAppListByUserName:TheCurUser.sUserName AppType:USER_APP_TYPE_BOUGHT];
    self.nominateApp = [BizLogic getAppListByUserName:TheCurUser.sUserName AppType:USER_APP_TYPE_NOMINATE];
    
    UIAppList *vBoungth =(UIAppList *)[m_swAppList viewWithTag:2001];
    UIAppList *vNominate =(UIAppList *)[m_swAppList viewWithTag:2002];
    
    //处理已开通应用
    CGRect rect = self->m_lableSection1.frame;
    rect.origin.y = rect.origin.y + rect.size.height;
    vBoungth.frame = rect;
    vBoungth.appList = self.boughtApp;
    [vBoungth proDrawAppList];
    rect = vBoungth.frame;  //frame的值已改变
 
    rect.origin.y += rect.size.height;
    CGRect r2 = self->m_lableSection2.frame; //调整推荐应用提示栏
    r2.origin.y = rect.origin.y;
    self->m_lableSection2.frame = r2;
    rect.origin.y += r2.size.height;
   
    //处理未开通应用
    vNominate.frame = rect;
    vNominate.appList = self.nominateApp;
    [vNominate proDrawAppList];
    rect = vNominate.frame;  //frame的值已改变
    
    rect.origin.y += rect.size.height;
    [self->m_swAppList setContentSize:CGSizeMake(rect.size.width, rect.origin.y)];
}



-(void)onSelectApp:(id)appInfo
{
    JYEXUserAppInfo * app = (JYEXUserAppInfo*)appInfo;
    if ( app ) {
        NSLog(@"点击了%@应用\r\n", app.sAppName);
        NSString *s = [app.sAppCode uppercaseString];
        if ( app.iAppType == USER_APP_TYPE_BOUGHT ) {
            if( [s isEqualToString:LM_YEZZB] )
            {
                [PubFunction SendMessageToViewCenter:NMJYEXCZGS :0 :1 :appInfo];
            }
            else 
            {
                [PubFunction SendMessageToViewCenter:NMJYEXGeneralApp :0 :1 :appInfo];
            }
            //else
            //{
            //    NSString *text = [NSString stringWithFormat:@"%@正在建设...", app.sAppName];
            //    [UIAstroAlert info:text :2.0 :NO :LOC_MID :NO];
            //}
        }
        else
        {
            self->m_labelComTitle.text = app.sAppName;
            self->m_twComText.hidden = YES;
            if ( [s isEqualToString:LM_YEZZB] ) {
                self->m_twComText.text = @"       什么样的故事孩子爱听？早期教育该如何开发孩子的潜能？孩子成长中出现的诸多问题该如何纠正？西方发达国家教养孩子有哪些卓有成效的经验呢？……\r\n       “育儿掌中宝”每日向您手机推送2~12岁科学育儿方案和优质儿童故事，让您利用零碎时间，轻松“悦读”，在不知不觉中成为自己孩子的育儿专家。";
                self->m_twComText.hidden = NO;
            }
            self->m_vwComBack.hidden = NO;
        }
    }
}

-(IBAction)onBlog:(id)sender
{
    NSString *defaultCateID = [_GLOBAL defaultCateID];
    [_GLOBAL setEditorAddNoteInfo:NEWNOTE_EDIT catalog:defaultCateID noteinfo:nil];
    [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
}

-(IBAction)onSend:(id)sender
{
    NSArray *cateList = [BizLogic getCateList:@""];
    TCateInfo *cateInfor = nil;
    int i = 0;
    for ( ; i < [cateList count]; ++i ) {
        cateInfor = [[cateList objectAtIndex:i] retain];
        if ( cateInfor && cateInfor.nMobileFlag == MOBILEFLAG_1) {
            break;
        }
        [cateInfor release];
    }
    if ( i < [cateList count] ) {
        [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:cateInfor.strCatalogIdGuid noteinfo:nil];
        [cateInfor release];
        [PubFunction SendMessageToViewCenter:NMNoteFolder :0 :1 :nil];
    }
}

-(IBAction)onCamera:(id)sender
{
    /*
    NSArray *cateList = [BizLogic getCateList:@""];
    TCateInfo *cateInfor = nil;
    int i = 0;
    for ( ; i < [cateList count]; ++i ) {
        cateInfor = [[cateList objectAtIndex:i] retain];
        if ( cateInfor && cateInfor.nMobileFlag == MOBILEFLAG_1) {
            break;
        }
        [cateInfor release];
    }
    if ( i < [cateList count] ) {
        [_GLOBAL setEditorAddNoteInfo:NEWNOTE_CAMERA catalog:cateInfor.strCatalogIdGuid noteinfo:nil];
        [cateInfor release];
        [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    }
    */
    
    
    [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
}

//-(IBAction)onSendMessage:(id)sender
//{
//    if ( !m_SendMessage ) {
//        m_SendMessage = [JYEXUserAppInfo alloc];
//        m_SendMessage.sAppCode = @"XX";
//        m_SendMessage.sAppName = @"消息";
//        m_SendMessage.sUserName = TheCurUser.sUserName;
//    }
//    [PubFunction SendMessageToViewCenter:NMJYEXGeneralApp :0 :1 :m_SendMessage];
//}

-(IBAction)onSetting:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];
}

-(IBAction)onCloseCom:(id)sender
{
    self->m_vwComBack.hidden = YES;
}


-(void)onLoginSuccess
{
    [self releaseAppListSubViews];
    [self drawAppList];
    
    [self updateUploadNum];
}


-(void)queryUpdateNumber
{
    if ( [[Global instance] getNetworkStatus] == NotReachable ) return;
    if ( [[DataSync instance] isExecuting] ) return;
    
    //判断是不是在当前页面
    NSArray *arrControllers = self.navigationController.viewControllers;
    NSInteger count = [arrControllers count];
    if ( count > 0 ) {
        if ( arrControllers[count-1] != self) {
            return;
        }
    }
    
    m_timeinterval = [[NSDate date] timeIntervalSince1970];
    
    [[DataSync instance] syncRequest:BIZ_SYNC_QUERYUPDATENUMBER :nil :nil :nil];
}


-(void)updataLanmuMsgNum
{
    int msgnum;
    
    NSDictionary *dic = [_GLOBAL getLanMuNewMessage];
    if ( !dic ) return;
    
    UIAppList *vBoungth =(UIAppList *)[m_swAppList viewWithTag:2001];
 
    for (int jj=0;jj<[boughtApp count];jj++) {
        JYEXUserAppInfo *t_appInfo = [boughtApp objectAtIndex:jj];
        msgnum = pickJsonIntValue(dic, t_appInfo.sAppCode);
                
        [vBoungth setTips:jj msgnum:msgnum];
    }
    
}


-(IBAction)onPictureSend:(id)sender
{
    NSLog( @"相片上传。。。" ) ;
    
    UIPictureSender *vc = [[UIPictureSender alloc]initWithNibName:@"UIPictureSender" bundle:nil] ;
    [self.navigationController pushViewController:vc animated:NO] ;
    [vc release] ;
}


-(void)updateUploadNum
{
    int iNeedSys = [BizLogic needSyncNotesCount];
    if ( iNeedSys == 0 ) {
        m_imTips.hidden = YES;
        m_lbTips.hidden = YES;
    }
    else {
        m_imTips.hidden = NO;
        m_lbTips.hidden = NO;
        m_lbTips.text = [NSString stringWithFormat:@"%d",iNeedSys];
    }
    
}



//-------测试-----------------------

-(IBAction)onTest:(id)sender
{
    //[self QueryJYEXAlbumList];
    //[self CreateJYEXAlbum];
    [self GetAlbumPics];
}



/*
//查询相册列表
-(void)QueryJYEXAlbumList
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXQueryAlbumList];
    
    [bussRequest request:self :@selector(syncCallback_QueryJYEXAlbumList:) :nil];
    return;
}

//查询相册列表回调
- (void)syncCallback_QueryJYEXAlbumList:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode != 200) //成功
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:query album");
        return;
	}
    
    NSDictionary *dict =(NSDictionary *)(sts.rtnData);
    NSLog(@"%@",dict);
    
    //成功处理(最多包括三部分:学校
    NSArray *arrSchool = [dict objectForKey:@"school"];
    NSArray *arrMyself = [dict objectForKey:@"myself"];
    NSArray *arrAllClass = [dict objectForKey:@"class"];
    if ( arrSchool) {
        for (NSDictionary *dic in arrSchool) {
            NSString *strAlbumid = [dic objectForKey:@"albumid"];
            NSString *strAlbumname = [dic objectForKey:@"albumname"];
            NSLog(@"school:%@ %@",strAlbumid,strAlbumname);
        }
    }
    if ( arrMyself) {
        for (NSDictionary *dic in arrMyself) {
            NSString *strAlbumid = [dic objectForKey:@"albumid"];
            NSString *strAlbumname = [dic objectForKey:@"albumname"];
            NSLog(@"myself:%@ %@",strAlbumid,strAlbumname);
        }
    }
    if ( arrAllClass) {
        for (NSDictionary *dic in arrAllClass) {
            NSString *strName = [dic objectForKey:@"nickname"];
            NSLog(@"class %@:",strName);
            
            NSArray *arrClass = [dic objectForKey:@"album"];
            if ( arrClass) {
                for (NSDictionary *dic1 in arrClass) {
                    NSString *strAlbumid = [dic1 objectForKey:@"albumid"];
                    NSString *strAlbumname = [dic1 objectForKey:@"albumname"];
                    NSLog(@"class %@:%@ %@",strName,strAlbumid,strAlbumname);
                }
            }
        }
    }
    
}


//--------------

//创建相册
-(void)CreateJYEXAlbum
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXCreateAlbum];
   
    NSString *albumname = [CommonFunc getCurrentTime];
    NSNumber *spaceid = [NSNumber numberWithInt:0]; //0:个人空间 1:班级空间 2:学校空间
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:albumname,@"albumname",spaceid,@"spaceid", nil];
    
    [bussRequest request:self :@selector(syncCallback_CreateJYEXAlbum:) :dic];
    return;
}

//创建相册列表回调
- (void)syncCallback_CreateJYEXAlbum:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode != 200) //成功
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:query album");
        return;
	}
    
    NSDictionary *dict =(NSDictionary *)(sts.rtnData);
    NSLog(@"%@",dict);
    
    int res = pickJsonIntValue(dict, @"res");
    NSString *msg = pickJsonStrValue(dict, @"msg");
    NSString *albumid = pickJsonStrValue(dict, @"albumid");
    NSLog(@"res=%d msg=%@ albumid=%@",res,msg,albumid);
    
    
}
*/

//查询相册照片
-(void)GetAlbumPics
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXGetAlbumPics];
 
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1621",@"albumid", nil];
    
    [bussRequest request:self :@selector(syncCallback_GetAlbumPics:) :dic];
    return;
}

//查询相册照片
- (void)syncCallback_GetAlbumPics:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
	if ( sts.iCode != 200) //成功
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:query album pics");
        return;
	}
    
    NSDictionary *dict =(NSDictionary *)(sts.rtnData);
    NSLog(@"%@",dict);
    
    
}




@end
