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
#import "UIJYEXMainPage2.h"
#import "DataSync.h"
#import "CommonAll.h"
#import "CImagePicker.h"
#import "UIPictureSender.h"
#import "UIImageEditorVC.h"
#import "jyexum_even_define.h"
#import "NetConstDefine.h"


@implementation UIJYEXMainPage2

@synthesize boughtApp;
@synthesize nominateApp;
@synthesize bussRequest;
@synthesize m_Menu1;
@synthesize m_Menu2;
@synthesize m_Menu3;
@synthesize m_Menu4;
@synthesize m_Menu5;
@synthesize m_Date1;
@synthesize m_Date2;
@synthesize m_Date3;
@synthesize m_Date4;
@synthesize m_Date5;

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
    
    m_swAppList.delegate = nil;
    m_webview1.delegate = nil;
    m_webview2.delegate = nil;
    m_webview3.delegate = nil;
    m_webview4.delegate = nil;
    m_webview5.delegate = nil;
    m_webview1.scrollView.delegate = nil;
    m_webview2.scrollView.delegate = nil;
    m_webview3.scrollView.delegate = nil;
    m_webview4.scrollView.delegate = nil;
    m_webview5.scrollView.delegate = nil;
    
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSet2);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips1);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips1);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips2);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips2);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips3);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips3);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips4);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips4);
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTips5);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwTips5);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_lbTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_swAppList);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnCamer);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnEditLog);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSend);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSetting);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnPerson);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwAnimation);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_labelComTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_twComText);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnClostCom);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwComBack);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_webview1);
    SAFEREMOVEANDFREE_OBJECT(self->m_webview2);
    SAFEREMOVEANDFREE_OBJECT(self->m_webview3);
    SAFEREMOVEANDFREE_OBJECT(self->m_webview4);
    SAFEREMOVEANDFREE_OBJECT(self->m_webview5);
    
    SAFEREMOVEANDFREE_OBJECT(self->btnMenu);
    
    SAFEREMOVEANDFREE_OBJECT(self->vwNoteType);
    SAFEREMOVEANDFREE_OBJECT(self->twNoteTypeList);
    SAFEREMOVEANDFREE_OBJECT(self->btnHideNoteTypeList);
    SAFEREMOVEANDFREE_OBJECT(self->vwBack);
    
    
    self.boughtApp = nil;
    self.nominateApp = nil;
    
    self.m_Menu1 = nil;
    self.m_Menu2 = nil;
    self.m_Menu3 = nil;
    self.m_Menu4 = nil;
    self.m_Menu5 = nil;
    
    self.m_Date1 = nil;
    self.m_Date2 = nil;
    self.m_Date3 = nil;
    self.m_Date4 = nil;
    self.m_Date5 = nil;
    
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)initMenuData
{
    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    //班级空间菜单
    if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){ //教师
        //栏目，类型（url,local),Action/url, 参数
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                @"上传班级动态",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"班级动态",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传教学日志",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"教学日志",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传宝宝作品",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"宝宝作品",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传班级圈",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"班级圈",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传照片到班级相册",@"title",@"local",@"type",ACT_SendPhoto,@"action",@"1",@"para", nil];
        [arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"使用帮助",@"title",@"url",@"type",URL_HELP,@"action",@"",@"para", nil];
        //[arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",@"ACT_Setting",@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传校园动态",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"校园动态",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传照片到学校相册",@"title",@"local",@"type",ACT_SendPhoto,@"action",@"0",@"para", nil];
        [arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"使用帮助",@"title",@"url",@"type",URL_HELP,@"action",@"",@"para", nil];
        //[arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",ACT_Setting,@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    else if ([u isInfantsSchoolParent] || [u isMiddleSchoolParent] ) { //家长
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"上传班级圈",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"班级圈",@"para", nil];
        [arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"使用帮助",@"title",@"url",@"type",URL_HELP,@"action",@"",@"para", nil];
        //[arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",ACT_Setting,@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    else {
         //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
         //      @"使用帮助",@"title",@"url",@"type",URL_HELP,@"action",@"",@"para", nil];
        //[arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",ACT_Setting,@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    self.m_Menu1 = arr;
    
    
    arr = [NSMutableArray array];
    //成长每一天
    if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){ //教师
        //栏目，类型（url,local),Action, 参数
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"设置学生状态",@"title",@"url",@"type",URL_SZXSKZT,@"action",@"",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"写留言寄语",@"title",@"url",@"type",URL_XLYJY,@"action",@"",@"para", nil];
        [arr addObject:dic];
    }
    else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
    }
    else { //家长
    }
    self.m_Menu2 = arr;
    
    
    arr = [NSMutableArray array];
    //家园直通车
    if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){ //教师
        //栏目，类型（url,local),Action, 参数
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"发通知公告",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"班级公告",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"发意见征询",@"title",@"url",@"type",URL_FYJZX_TEACHER,@"action",@"",@"para", nil];
        [arr addObject:dic];
    }
    else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
        //栏目，类型（url,local),Action, 参数
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"发通知公告",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"学校公告",@"para", nil];
        [arr addObject:dic];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"发校内公告",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"校内公告",@"para", nil];
        [arr addObject:dic];
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"发每周食谱",@"title",@"url",@"type",URL_FMZSP,@"action",@"",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"发意见征询",@"title",@"url",@"type",URL_FYJZX_MASTER,@"action",@"",@"para", nil];
        [arr addObject:dic];
    }
    else if ([u isInfantsSchoolParent] || [u isMiddleSchoolParent] )  { //家长
        //栏目，类型（url,local),Action, 参数
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"发请假",@"title",@"url",@"type",URL_FQJ,@"action",@"",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"发事件提醒",@"title",@"url",@"type",URL_FSJTX,@"action",@"",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"发园长信箱",@"title",@"url",@"type",URL_FYZXX,@"action",@"",@"para", nil];
        [arr addObject:dic];
    }
    else {
        
    }
    self.m_Menu3 = arr;
    
    arr = [NSMutableArray array];
    //育儿掌中宝菜单
    self.m_Menu4 = arr;
    
    arr = [NSMutableArray array];
    //个人空间菜单
    //栏目，类型（url,local),Action, 参数
    if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){ //教师
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"上传个人随手拍",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"个人随手拍",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传照片到个人相册",@"title",@"local",@"type",ACT_SendPhoto,@"action",@"0",@"para", nil];
        [arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",ACT_Setting,@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    else if([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
        
    }
    else { //家长
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"上传个人随手拍",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"个人随手拍",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"上传成长日志",@"title",@"local",@"type",ACT_WriteArticle,@"action",@"成长日志",@"para", nil];
        [arr addObject:dic];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"上传照片到个人相册",@"title",@"local",@"type",ACT_SendPhoto,@"action",@"0",@"para", nil];
        [arr addObject:dic];
        //dic = [NSDictionary dictionaryWithObjectsAndKeys:
        //       @"设置",@"title",@"local",@"type",ACT_Setting,@"action",@"",@"para", nil];
        //[arr addObject:dic];
    }
    
    self.m_Menu5 = arr;
 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_nCurPage = 0;
    [self initMenuData];
    
    m_swAppList.delegate = self;

    m_webview1.delegate = self;
    m_webview2.delegate = self;
    m_webview3.delegate = self;
    m_webview4.delegate = self;
    m_webview5.delegate = self;
    m_webview1.scrollView.delegate = self;
    m_webview2.scrollView.delegate = self;
    m_webview3.scrollView.delegate = self;
    m_webview4.scrollView.delegate = self;
    m_webview5.scrollView.delegate = self;
    
    twNoteTypeList.delegate = self;
    twNoteTypeList.dataSource = self;

    
    m_swAppList.pagingEnabled = YES;
    m_swAppList.showsHorizontalScrollIndicator = NO;
    m_swAppList.showsVerticalScrollIndicator = NO;
    
    NSLog(@"view frame=%@",NSStringFromCGRect(m_swAppList.frame));
    
    /*
    CGFloat red,green,blue,alpha;
    UIColor *color = m_vwTitleView.backgroundColor;
    BOOL bret = [color getRed:&red green:&green blue:&blue alpha:&alpha];
    M_lbColor.text = [NSString stringWithFormat:@"%02x%02x%02x",(int)(red*255),(int)(green*255),(int)(blue*255)];
    */
  
    //---------
    for (int i=0;i<5;i++) {
        CGRect rect = CGRectMake(0, -200, self.view.frame.size.width, 200);
        EGORefreshTableHeaderView *headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
        headView.delegate = self;
        headView.tag = i+1;
        
        if (0 == i) [m_webview1.scrollView addSubview:headView];
        else if (1 == i) [m_webview2.scrollView addSubview:headView];
        else if (2 == i) [m_webview3.scrollView addSubview:headView];
        else if (3 == i) [m_webview4.scrollView addSubview:headView];
        else [m_webview5.scrollView addSubview:headView];
        
        _refreshHeaderView[i] = headView;
        [headView refreshLastUpdatedDate];
        [headView release];
    }

    //刷新第一个
    [m_webview1.scrollView setContentOffset:CGPointMake(0, -80)];
    [_refreshHeaderView[0] egoRefreshScrollViewDidEndDragging:m_webview1.scrollView];
    
    //---------
    
    
    // Do any additional setup after loading the view from its nib.
    //[self createAppList];
    //[self drawAppList];
    
    [self loadWebContent];
    [self updataLanmuMsgNum];
    [self queryUpdateNumber];
    [self updateUploadNum];
    [self updateMasterInfo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataLanmuMsgNum) name:NOTIFICATION_UPDATE_LANMU_MSGNUM object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUploadNum) name:NOTIFICATION_UPDATE_UPLOADNUM object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:NOTIFICATION_REFRESH_CONTENT object:nil];
    

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


-(void)loadWebContent
{
     TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    
     /*
     //NSString *url1 = URL_HOMEPAGE_CLASS;
     NSString *url2 = URL_HOMEPAGE_GROWING_PARENT;
     NSString *url3 = URL_HOMEPAGE_JIAYUAN_PARENT;
     //NSString *url4 = URL_HOMEPAGE_YUER;
     //NSString *url5 = URL_HOMEPAGE_PERSON;
     
     
     if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){
     url2 = URL_HOMEPAGE_GROWING_TEACHER;
     url3 = URL_HOMEPAGE_JIAYUAN_TEACHER;
     }
     else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
     url2 = URL_HOMEPAGE_GROWING_MASTER;
     url3 = URL_HOMEPAGE_JIAYUAN_MASTER;
     }
     
     //[m_webview1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url1]]];
     [m_webview2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url2]]];
     [m_webview3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url3]]];
     //[m_webview4 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url4]]];
     //[m_webview5 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url5]]];
     */
    
    //育儿掌中宝在线
    NSString *url4 = URL_HOMEPAGE_YUER;
    [m_webview4 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url4]]];
    
    
    
    if ( [CommonFunc isFileExisted:FILE_LOCAL_CLASS] ) {
        NSURL *baseURL = [NSURL fileURLWithPath:FILE_LOCAL_CLASS isDirectory:NO];
        NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
        [m_webview1 loadRequest:request];
    }
    else {
        NSString *str=@"加载中...";
        if ([u isCommonMember]) str = @"您没有访问此栏目的权限，请用园长、老师或家长身份的帐号登录。";
        [m_webview1 loadHTMLString:str baseURL:nil];
    }
    
    
    if ( [CommonFunc isFileExisted:FILE_LOCAL_GROWING] ) {
        NSURL *baseURL = [NSURL fileURLWithPath:FILE_LOCAL_GROWING isDirectory:NO];
        NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
        [m_webview2 loadRequest:request];
    }
    else {
        NSString *str=@"加载中...";
        if ([u isCommonMember]) str = @"您没有访问此栏目的权限，请用园长、老师或家长身份的帐号登录。";
        [m_webview2 loadHTMLString:str baseURL:nil];
    }
    
    if ( [CommonFunc isFileExisted:FILE_LOCAL_JIAYUAN] ) {
        NSURL *baseURL = [NSURL fileURLWithPath:FILE_LOCAL_JIAYUAN isDirectory:NO];
        NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
        [m_webview3 loadRequest:request];
    }
    else {
        NSString *str=@"加载中...";
        if ([u isCommonMember]) str = @"您没有访问此栏目的权限，请用园长、老师或家长身份的帐号登录。";
        [m_webview3 loadHTMLString:str baseURL:nil];
    }
    
    
    //if ( [CommonFunc isFileExisted:FILE_LOCAL_YUER] ) {
    //    NSURL *baseURL = [NSURL fileURLWithPath:FILE_LOCAL_YUER isDirectory:NO];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    //    [m_webview4 loadRequest:request];
    //}
    
    
    //if( [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ){ //园长
        //NSURL *baseURL = [NSURL URLWithString:@"about:blank"];
        //NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
        //[m_webview5 loadRequest:request];
    //     m_webview5.hidden = YES;
    //}
    //else
    {
        m_webview5.hidden = NO;
        if ( [CommonFunc isFileExisted:FILE_LOCAL_PERSON] ) {
            NSURL *baseURL = [NSURL fileURLWithPath:FILE_LOCAL_PERSON isDirectory:NO];
            NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
            [m_webview5 loadRequest:request];
        }
        else {
            NSString *str=@"加载中...";
            [m_webview5 loadHTMLString:str baseURL:nil];
        }
    }
}


/*
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
*/

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


/*
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
*/
 
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
    
    NSLog(@"into onLoginSuccess");
    
    
    //取菜单数据，设置菜单
    [self initMenuData];
    [self setMenuFrame];
    [twNoteTypeList reloadData];
    
    //重新加载页面内容
    [self loadWebContent];
    
    //清加载时间
    self.m_Date1 = nil;
    self.m_Date2 = nil;
    self.m_Date3 = nil;
    self.m_Date4 = nil;
    self.m_Date5 = nil;
    
    //重新去下载内容
    [self startRefreshContent:YES];
    
    //重现取更新数
    [self updateUploadNum];
    [self updateMasterInfo];
    [self queryUpdateNumber];
    
}


-(void)queryUpdateNumberNow
{
    if ( [[Global instance] getNetworkStatus] == NotReachable ) return;
    
    m_timeinterval = [[NSDate date] timeIntervalSince1970];
    [[DataSync instance] syncRequest:BIZ_SYNC_QUERYUPDATENUMBER :nil :nil :nil];

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
    //int msgnum;
    
    NSDictionary *dic = [_GLOBAL getLanMuNewMessage];
    if ( dic ) {
        int numBJKJ = pickJsonIntValue(dic, LM_BJKJ);
        int numCZMYT = pickJsonIntValue(dic, LM_CZMYT);
        int numJYZTC = pickJsonIntValue(dic, LM_JYZTC);
        int numYEZZB = pickJsonIntValue(dic, LM_YEZZB);
        int numGRKJ = pickJsonIntValue(dic, LM_GRKJ);
        
        //对于有新消息的，启动下载页面。
    
        if ( numBJKJ <= 0)  m_vwTips1.hidden = YES;
        else {
            m_vwTips1.hidden = NO;
            m_lbTips1.text = [NSString stringWithFormat:@"%d",numBJKJ];
            [self getHtmlFile:0];
        }
        
        if ( numCZMYT <= 0) m_vwTips2.hidden = YES;
        else {
            m_vwTips2.hidden = NO;
            m_lbTips2.text = [NSString stringWithFormat:@"%d",numCZMYT];
            [self getHtmlFile:1];
        }
        if ( numJYZTC <= 0) m_vwTips3.hidden = YES;
        else {
            m_vwTips3.hidden = NO;
            m_lbTips3.text = [NSString stringWithFormat:@"%d",numJYZTC];
            [self getHtmlFile:2];
        }
        if ( numYEZZB <= 0) m_vwTips4.hidden = YES;
        else {
            m_vwTips4.hidden = NO;
            m_lbTips4.text = [NSString stringWithFormat:@"%d",numYEZZB];
            [self getHtmlFile:3];
        }
        if ( numGRKJ <= 0) m_vwTips5.hidden = YES;
        else {
            m_vwTips5.hidden = NO;
            m_lbTips5.text = [NSString stringWithFormat:@"%d",numGRKJ];
            [self getHtmlFile:4];
        }
    }

    [self updateSubLanmu:-1];
    
    
    
    
}


- (void)updateSubLanmu:(int)no
{
    NSArray * arr = [_GLOBAL getSubLanMuNewMessage];
    if ( arr ) {
        for (NSDictionary *dic in arr ) {
            NSString *elid = pickJsonStrValue(dic, @"elid");
            int num = pickJsonIntValue(dic, @"num");
            NSString *lanmutype = pickJsonStrValue(dic, @"lanmutype");
            
            UIWebView *myweb;
            
            if ( [lanmutype isEqualToString:@"class"] ) myweb = m_webview1;
            else if ( [lanmutype isEqualToString:@"czmyt"] ) myweb = m_webview2;
            else if ( [lanmutype isEqualToString:@"ztc"] ) myweb = m_webview3;
            else if ( [lanmutype isEqualToString:@"person"] ) myweb = m_webview5;
            else myweb = m_webview1;
            
            if ( no >= 0 && no != myweb.tag - 1) continue;
            
            if ( myweb.isLoading ) continue;
            
            NSString *strHTML;
            if ( num > 0 ) strHTML = [NSString stringWithFormat:@"document.getElementById(\"%@\").style.display='inline'",elid];
            else strHTML = [NSString stringWithFormat:@"document.getElementById(\"%@\").style.display='none'",elid];
            
            NSString *retHTML = [myweb stringByEvaluatingJavaScriptFromString:strHTML];
            NSLog(@"%@ return %@",strHTML,retHTML);
        }
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
        m_vwTips.hidden = YES;
    }
    else {
        m_vwTips.hidden = NO;
        m_lbTips.text = [NSString stringWithFormat:@"%d",iNeedSys];
    }
}


-(void)updateMasterInfo
{
    /*
    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
        m_vwTips5.hidden = YES;
        m_btnPerson.hidden = YES;
        [m_swAppList setContentSize:CGSizeMake(m_swAppList.frame.size.width*4, m_swAppList.frame.size.height)];
    }
    else {
         m_btnPerson.hidden = NO;
    }*/
    
    [m_swAppList setContentSize:CGSizeMake(m_swAppList.frame.size.width*5, m_swAppList.frame.size.height)];
}


//设置下拉菜单的大小
-(void)setMenuFrame
{
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;
    
    
    CGRect rNoteTypeList = self->twNoteTypeList.frame;
    float fh = 44.0;//self->twNoteTypeList.rowHeight;
    int line = (int)[arr count];
    if ( line > 9 ) line = 9;
    fh = fh * line;
    rNoteTypeList.size.height = fh;
    self->twNoteTypeList.frame = rNoteTypeList;
    
    CGRect frame = self->vwBack.frame;
    frame.size.height = rNoteTypeList.size.height + 1;
    self->vwBack.frame = frame;
}

-(IBAction)onDispOrHideNoteType:(id)sender
{
    [self DispSheetMenu];
    
    /*
    vwNoteType.hidden = !vwNoteType.hidden;
    if ( vwNoteType.hidden) return;
    
    [self setMenuFrame];
    [twNoteTypeList reloadData];
    */
    
}



//-------测试-----------------------

-(IBAction)onTest:(id)sender
{
    //[self QueryJYEXAlbumList];
    //[self CreateJYEXAlbum];
    //[self GetAlbumPics];
    //[self getHtmlFile:0];
    [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];
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

/*
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
*/

-(void)setAnimationView:(int)num
{
    //处理按钮
    if ( num == 4) m_btnSet2.hidden = NO;
    else m_btnSet2.hidden = YES;
    
    CGRect frame;
    if ( num == 0 ) frame = m_btnCamer.frame;
    else if ( num == 1 ) frame = m_btnEditLog.frame;
    else if ( num == 2 ) frame = m_btnSend.frame;
    else if ( num == 3 ) frame = m_btnSetting.frame;
    else frame = m_btnPerson.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [m_vwAnimation setFrame:frame];
    [UIView commitAnimations];
}

-(void)refreshContent
{
    [self getHtmlFile:m_nCurPage];
    [self queryUpdateNumberNow];
}


-(UIWebView *)getWebView:(int)num
{
    //结束同步界面
    UIWebView *tmpWebView;
    if ( num == 0 ) {
        tmpWebView = m_webview1;
    }
    else if ( num == 1 ) {
        tmpWebView = m_webview2;
    }else if ( num == 2 ) {
        tmpWebView = m_webview3;
    }else if ( num == 3 ) {
        tmpWebView = m_webview4;
    }
    else {
        tmpWebView = m_webview5;
    }
    
    return tmpWebView;
}

//停止刷新
-(void)StopRefesh:(NSNumber *)numNum
{
    int num = [numNum intValue];
    //结束同步界面
    UIWebView *webView = [self getWebView:num];
    [self restoreRefleshHeadView:webView index:num];
}


//获取html文件
-(void)getHtmlFile:(int)num
{
    if ( num < 0 || num >= 5 ) return;
    
    if ( num == 3 )  {
        //育儿掌中宝在线
        
        if ( m_webview4.isLoading ) return;
        
        NSString *url4 = URL_HOMEPAGE_YUER;
        [m_webview4 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url4]]];
        return;
    }
    
    
    if ( m_syncflag[num] == 1 )  return;  //正在刷新
    
    //NSString *strFilename = [[CommonFunc getTempDir] stringByAppendingPathComponent:@"test.html"];
    //[CommonFunc getTagValueFromHtml:strFilename tagname:@"input"];
    
    NSString *strUrl;
    NSString *strFilename;
    
    //NSString *strUrl = [CS_URL_BASE stringByAppendingString:@"mobile.php?mod=space&ac=person_class&classkey=title_chengzhangrizhi"];//URL_HOMEPAGE_CLASS;
    //NSString *strFilename = @"homepage1.html";
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strUrl,@"url",strFilename,@"filename", nil];
    
    
    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    
    if( !([u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ||  //老师
        [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] || //校长
        [u isInfantsSchoolParent] || [u isMiddleSchoolParent]) && num != 4) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(StopRefesh:) object:nil];
        [self performSelector:@selector(StopRefesh:) withObject:[NSNumber numberWithInt:num] afterDelay:0.5];
      
        return;
    }
    
    
    if ( num == 0 ) {
        strUrl = URL_HOMEPAGE_CLASS;
        strFilename =  @"homepage1.html";
    }
    else if (num == 1 ) {
        strUrl = URL_HOMEPAGE_GROWING_PARENT;
        if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){ //老师
            strUrl = URL_HOMEPAGE_GROWING_TEACHER;
        }
        else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
            strUrl = URL_HOMEPAGE_GROWING_MASTER;
        }
        strFilename =  @"homepage2.html";
    }
    else if ( num == 2 ) {
        strUrl = URL_HOMEPAGE_JIAYUAN_PARENT;
        if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){
            strUrl = URL_HOMEPAGE_JIAYUAN_TEACHER;
        }
        else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {//校长
            strUrl = URL_HOMEPAGE_JIAYUAN_MASTER;
        }
        strFilename =  @"homepage3.html";
    }
    else if ( num == 3 ) {
        strUrl = URL_HOMEPAGE_YUER;
        strFilename =  @"homepage4.html";
    }
    else {
        strUrl = URL_HOMEPAGE_PERSON;
        strFilename =  @"homepage5.html";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strUrl,@"url",strFilename,@"filename",[NSNumber numberWithInt:num],@"number", nil];
 
    m_syncflag[num] = 1;
    //[UIAstroAlert info:@"正在同步，请稍候" :0.0 :NO :LOC_MID :YES]; //一直等待，不允许操作
    m_syncid[num] =
    [[DataSync instance] syncRequest:BIZ_SYNC_DOWNLOAD_HTML :self :@selector(syncCallback:) :dic];
    
}


//同步的回调
- (void)syncCallback:(TBussStatus*)sts
{
    NSLog(@"------同步返回了");
    
    NSDictionary *dic = (NSDictionary *)sts.srcParam;
    int num = pickJsonIntValue(dic, @"number");
    if ( num < 0 || num >= 5) num = 0;
    
    m_syncflag[num] = 0;
    
    //结束同步界面
    UIWebView *tmpWebView = [self getWebView:num];
    NSString *strFilename;
    if ( num == 0 ) {
        strFilename = FILE_LOCAL_CLASS;
    }
    else if ( num == 1 ) {
        strFilename = FILE_LOCAL_GROWING;
    }else if ( num == 2 ) {
        strFilename = FILE_LOCAL_JIAYUAN;
    }else if ( num == 3 ) {
        strFilename = FILE_LOCAL_YUER;
    }
    else {
        strFilename = FILE_LOCAL_PERSON;
    }
    
    [self restoreRefleshHeadView:tmpWebView index:num];
    
    //更新数据
    NSURL *baseURL = [NSURL fileURLWithPath:strFilename isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    
    if ( tmpWebView.isLoading) [tmpWebView stopLoading];
    [tmpWebView loadRequest:request];
    
    
 	if ( sts.iCode == 200) { //成功
		//[UIAstroAlert info:@"同步成功" :2.0 :NO :LOC_MID :NO];
        
        NSDate *date = [NSDate date];
        if ( num == 0) self.m_Date1 = date;
        else if (num == 1) self.m_Date2 = date;
        else if ( num == 2) self.m_Date3 = date;
        else if ( num == 3) self.m_Date4 = date;
        else self.m_Date5 = date;
	}
	else {
        //失败了
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
    
    //[self reRoadTableView];==========
}

-(void)procBtnMenu
{
    NSArray *arr;
    if ( m_nCurPage == 0 ) {arr = m_Menu1;m_lbTitle.text = @"班级空间";}
    else if ( m_nCurPage == 1 ) {arr = m_Menu2;m_lbTitle.text = @"成长每一天";}
    else if ( m_nCurPage == 2 ) {arr = m_Menu3;m_lbTitle.text = @"家园直通车";}
    else if ( m_nCurPage == 3 ) {arr = m_Menu4;m_lbTitle.text = @"育儿掌中宝";}
    else {arr = m_Menu5;m_lbTitle.text = @"我的";}
    
    if ( [arr count] < 1 ) btnMenu.hidden = YES;
    else btnMenu.hidden = NO;
}


-(void)procClearTip
{
    if ( m_nCurPage == 0 ) {[_GLOBAL clearMessageNum:LM_BJKJ];m_vwTips1.hidden = YES;}
    else if ( m_nCurPage == 1 ) {[_GLOBAL clearMessageNum:LM_CZMYT];m_vwTips2.hidden = YES;}
    else if ( m_nCurPage == 2 ) {[_GLOBAL clearMessageNum:LM_JYZTC];m_vwTips3.hidden = YES;}
    else if ( m_nCurPage == 3 ) {[_GLOBAL clearMessageNum:LM_YEZZB];m_vwTips4.hidden = YES;}
    else {[_GLOBAL clearMessageNum:LM_GRKJ];m_vwTips5.hidden = YES;}
}


-(void)procClearSubLanMu:(UIWebView *)myweb path:(NSString *)url
{
    
    NSRange range = [url rangeOfString:@"lmid="];
    if ( range.length <= 0 ) return;
    
    NSString *elid = [url substringFromIndex:range.location + 5];
    range = [elid rangeOfString:@"&"];
    if ( range.length > 0) {
        elid = [elid substringToIndex:range.location];
    }
    
    NSString *strHTML = [NSString stringWithFormat:@"document.getElementById(\"%@\").style.display='none'",elid];
    
    NSString *retHTML = [myweb stringByEvaluatingJavaScriptFromString:strHTML];
    NSLog(@"%@ return %@",strHTML,retHTML );
    
    [_GLOBAL clearSubLanMuMessageNum:elid];

}



-(IBAction)onFunc:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    m_nCurPage = (int)btn.tag - 1;
    nDragFlag = 0;
    
    BOOL bHasNewMsg = FALSE;
    if ( m_nCurPage == 0 && !m_vwTips1.hidden) bHasNewMsg = YES;
    if ( m_nCurPage == 1 && !m_vwTips2.hidden) bHasNewMsg = YES;
    if ( m_nCurPage == 2 && !m_vwTips3.hidden) bHasNewMsg = YES;
    if ( m_nCurPage == 3 && !m_vwTips4.hidden) bHasNewMsg = YES;
    if ( m_nCurPage == 4 && !m_vwTips5.hidden) bHasNewMsg = YES;
    
    [self procBtnMenu];
    [self procClearTip];
    [m_swAppList setContentOffset:CGPointMake(m_nCurPage*m_swAppList.frame.size.width, 0)];
    
    [self setAnimationView:m_nCurPage];
    
    [self startRefreshContent:bHasNewMsg];
}


-(void)startRefreshContent:(BOOL)bHasNewMsg
{
    UIWebView *tmpWebView;
    NSDate *date;
    
    if ( m_nCurPage == 0 ) {tmpWebView = m_webview1;date = m_Date1;}
    else if ( m_nCurPage == 1 ) {tmpWebView = m_webview2;date = m_Date2;}
    else if ( m_nCurPage == 2 ) {tmpWebView = m_webview3;date = m_Date3;}
    else if ( m_nCurPage == 3 ) {tmpWebView = m_webview4;date = m_Date4;}
    else {tmpWebView = m_webview5;date = m_Date5;}
    
    CGFloat fHeight = -80;
    if ( date && !bHasNewMsg) {
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if ( interval < 60 ) return; //不刷新
    }
    
    [tmpWebView.scrollView setContentOffset:CGPointMake(0, fHeight)];
    [_refreshHeaderView[m_nCurPage] egoRefreshScrollViewDidEndDragging:tmpWebView.scrollView];
    
}


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        
    self->m_vwActivityBack.hidden = NO;
    if ( ![self->activityIndicator isAnimating] ) {
        [activityIndicator startAnimating];
    }
    
    NSString *sMethod = [request HTTPMethod];
    if ( sMethod && ([sMethod isEqualToString:@"POST"] || [sMethod isEqualToString:@"post"])) {
        return YES;
    }
    
    
    NSString *path = [[request URL] absoluteString];
    NSLog(@"url:%@\r\n", path );
    
    NSRange range1 = [path rangeOfString:FILENAME_HOMEPAGE_CLASS];
    NSRange range2 = [path rangeOfString:FILENAME_HOMEPAGE_GROWING];
    NSRange range3 = [path rangeOfString:FILENAME_HOMEPAGE_JIAYUAN];
    NSRange range4 = [path rangeOfString:FILENAME_HOMEPAGE_YUER];
    NSRange range5 = [path rangeOfString:FILENAME_HOMEPAGE_PERSON];
    
    if ([path hasPrefix:@"file:"] ) {
        if ( range1.length==0 && range2.length==0 &&
        range3.length==0 && range4.length==0 && range5.length==0 ) {
            //本地的url,需要替换
            NSArray *arr = [path componentsSeparatedByString:@"/"];
            if ( arr && [arr count] > 0 ) {
                [self procClearSubLanMu:webView path:path];
                [self procClearTip];//清红标数字
                NSString *url1 = [arr lastObject];
                NSString *strUrl = [CS_URL_BASE stringByAppendingString:url1];
                [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :strUrl :0]];
                return NO;
            }
        }
    }
    else if ([path hasPrefix:@"yk://"]) { //本地的
        if ([path rangeOfString:ACT_LOGIN].length > 0 ) {
            NSNumber *num = [NSNumber numberWithInt:1];
            [PubFunction SendMessageToViewCenter:NMJYEXLogin :0 :1 :num];
            return NO;
        }
        else if ([path rangeOfString:ACT_Setting].length > 0 ) {
            NSNumber *num = [NSNumber numberWithInt:1];
            [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :num];
            return NO;
        }
    }
    else if (![path isEqualToString:URL_HOMEPAGE_YUER] && ![path isEqualToString:@"about:blank"]) {
        [self procClearSubLanMu:webView path:path];
        [self procClearTip];//清红标数字
        [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :path :0]];
        return NO;
    }

    
    /*
    if ( [path rangeOfString:@"http"].location == NSNotFound ) {
        return YES;
    }
    
    if ( ([path rangeOfString:self.sWidth].location != NSNotFound)
        && ([path rangeOfString:self.sHeight].location != NSNotFound)) {
        if ( navigationType != UIWebViewNavigationTypeBackForward ) {
            if ( [self->urlArray count] ) {
                NSString *lastUrl = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
                if ( ![lastUrl isEqualToString:path] ) {
                    [self->urlArray addObject:path];
                }
            }
            else
            {
                [self->urlArray addObject:path];
            }
        }
        return YES;
    }
    else
    {
        NSString *url = nil;
        if ( [path rangeOfString:@"?"].location != NSNotFound ) {
            url = [NSString stringWithFormat:@"%@&fbl=%@%@%@", path, self.sWidth, @"X", self.sHeight];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@?fbl=%@%@%@", path, self.sWidth, @"X", self.sHeight];
        }
        NSLog(@"UIJYEXCZGS add screen size, url:%@\r\n", url );
        
        [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return NO;
    }
    */
    
    return YES;
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    /*
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        
        self->m_btnBrush.hidden = NO;
    }*/
    
    //结束同步界面
    [self restoreRefleshHeadView:webView index:(int)webView.tag-1];
    
    
    if ( [error code] == -999 || [error code] == 102 ) {
        return;
    }
    
    NSString *err;
    if ( [[Global instance] getNetworkStatus] == NotReachable ) {
        err = @"无法加载页面，请检查网络。";
    } else {
        err = @"无法加载页面，请稍后再试。";
    }
    [webView loadHTMLString:err baseURL:nil];
    
    
    NSDictionary *dic = [error userInfo];
    NSString *err1 = [[NSString alloc] initWithFormat:@"加载页面%@失败 %@ 请检查网络", ((NSString*)[dic objectForKey:@"NSErrorFailingURLStringKey"]), [error localizedDescription]];
    NSLog(@"%@\r\n", err1);
    [err1 release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    /*
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        
        self->m_btnBrush.hidden = NO;
    }*/
    
    
    NSString *titleHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"load finish: title=%@",titleHTML);
    
    //结束同步界面
    [self restoreRefleshHeadView:webView index:(int)(webView.tag-1)];
    
    NSDate *date = [NSDate date];
    //if ( webView.tag == 1) self.m_Date1 = date;
    //else if ( webView.tag == 2) self.m_Date2 = date;
    //else if ( webView.tag == 3) self.m_Date3 = date;
    //else
    if ( webView.tag == 4) self.m_Date4 = date;
    //else self.m_Date5 = date;
    
    //修改分栏目红点
    [self updateSubLanmu:webView.tag-1];
    
}


//-------------下拉同步相关-----------------------------------------------------
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll:content offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if ( scrollView == m_swAppList ) {
        if ( nDragFlag == 1) {
            CGFloat fValue = (scrollView.contentOffset.x - fPosX)*(m_vwAnimation.frame.size.width)/scrollView.frame.size.width;
            CGRect frame = m_vwAnimation.frame;
            frame.origin.x += fValue;
            m_vwAnimation.frame = frame;
            fPosX = scrollView.contentOffset.x;
        }
        return;
    }
    
    int i = 0;
    if ( scrollView == m_webview1.scrollView ) i = 0;
    else if ( scrollView == m_webview2.scrollView ) i = 1;
    else if ( scrollView == m_webview3.scrollView ) i = 2;
    else if ( scrollView == m_webview4.scrollView ) i = 3;
    else if ( scrollView == m_webview5.scrollView ) i = 4;
    else return;
    
    [_refreshHeaderView[i] egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging:content offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    int i = 0;
    if ( scrollView == m_webview1.scrollView ) i = 0;
    else if ( scrollView == m_webview2.scrollView ) i = 1;
    else if ( scrollView == m_webview3.scrollView ) i = 2;
    else if ( scrollView == m_webview4.scrollView ) i = 3;
    else if ( scrollView == m_webview5.scrollView ) i = 4;
    else return;
    
    [_refreshHeaderView[i] egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation:content offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    int i = 0;
    if ( scrollView == m_webview1.scrollView ) i = 0;
    else if ( scrollView == m_webview2.scrollView ) i = 1;
    else if ( scrollView == m_webview3.scrollView ) i = 2;
    else if ( scrollView == m_webview4.scrollView ) i = 3;
    else if ( scrollView == m_webview5.scrollView ) i = 4;
    else return;
    
    [_refreshHeaderView[i] egoRefreshScrollViewDidEndDragging:scrollView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    if ( scrollView == m_swAppList ) {
        CGFloat pageWidth=scrollView.frame.size.width;
        m_nStartPage = floor((scrollView.contentOffset.x+10)/pageWidth);
        fPosX = scrollView.contentOffset.x;
        nDragFlag = 1;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if ( scrollView == m_swAppList ) {
        //刷新
        CGFloat pageWidth=scrollView.frame.size.width;
        int pageNum=floor((scrollView.contentOffset.x+10)/pageWidth);
        
        [self setAnimationView:pageNum];
        
        if ( pageNum == m_nStartPage ) return;
        m_nCurPage = pageNum;
        [self procBtnMenu];
        [self procClearTip];
        
        UIWebView *tmpWebView;
        NSDate *date;
        
        if (pageNum == 0 ) {tmpWebView = m_webview1;date = m_Date1;}
        else if ( pageNum == 1 ) {tmpWebView = m_webview2;date = m_Date2;}
        else if ( pageNum == 2 ) {tmpWebView = m_webview3;date = m_Date3;}
        else if ( pageNum == 3 ) {tmpWebView = m_webview4;date = m_Date4;}
        else {tmpWebView = m_webview5;date = m_Date5;}
        
        
        //CGFloat fHeight = -80;
        if ( date ) {
            NSTimeInterval interval = [date timeIntervalSinceNow];
            if ( interval < 60 ) return; //不刷新
        }
        
        
        [tmpWebView.scrollView setContentOffset:CGPointMake(0, -80)];
        [_refreshHeaderView[pageNum] egoRefreshScrollViewDidEndDragging:tmpWebView.scrollView];
    }
    
    
    /*
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    CGFloat pageHeigth=self.myScrollView.frame.size.height;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",self.myScrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=imageArray.count-1;
        NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    self.pageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
    */
}


-(void)restoreRefleshHeadView:(UIWebView *)webview index:(int)index
{
    //结束同步界面
    [_refreshHeaderView[index] egoRefreshScrollViewDataSourceDidFinishedLoading:webview.scrollView];
    
}


//EGORefreshTableHeaderView的代理
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self getHtmlFile:(int)view.tag - 1];
    
    /*
    UIWebView *tmpWebView;
    
    if ( view.tag == 1 ) tmpWebView = m_webview1;
    else if ( view.tag == 2 ) tmpWebView = m_webview2;
    else if ( view.tag == 3 ) tmpWebView = m_webview3;
    else if ( view.tag == 4 ) tmpWebView = m_webview4;
    else tmpWebView = m_webview5;
	
    if ( !tmpWebView.isLoading ) {
        //[tmpWebView reload];
        //[tmpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    */
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return m_syncflag[view.tag - 1];
    /*
    if ( view.tag == 1 )return m_webview1.isLoading; // should return if data source model is reloading
    else if ( view.tag == 2 )return m_webview2.isLoading;
    else if ( view.tag == 3 )return m_webview3.isLoading;
    else if ( view.tag == 4 )return m_webview4.isLoading;
    else return m_webview5.isLoading;
    */
}


- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    return [NSDate date]; // should return date data source was last changed
}



#pragma mark -
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *noteTypeCell
        = (UITableViewCell*)[self->twNoteTypeList dequeueReusableCellWithIdentifier:@"cell"];
        
    if ( !noteTypeCell ) {
        noteTypeCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
    }
    
 
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;
    
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    noteTypeCell.textLabel.text = [dic objectForKey:@"title"];
    
    return noteTypeCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;
    
    return [arr count];
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( tableView == self->twNoteTypeList) {
        return @"栏目";
    }
    return @"";
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if ( tableView == self->twNoteTypeList && indexPath.row < [self.arrayNoteTypeList count]) {
        self->nNoteTypeIndex = indexPath.row;
        self.strCurNoteType = [self.arrayNoteTypeList objectAtIndex:indexPath.row];
        self->labelNoteType.text  = self.strCurNoteType;
        self->vwNoteType.hidden = YES;
    }
    */
    
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;
    
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    
    //栏目，类型（url,local),Action, 参数
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                     @"上传精彩瞬间",@"title",@"local",@"type",@"ACT_WriteArticle",@"action",@"精彩瞬间",@"para", nil];
    NSString *strType = [dic objectForKey:@"type"];
    NSString *strAction = [dic objectForKey:@"action"];
    NSString *strPara  = [dic objectForKey:@"para"];
    if (strPara == nil || [strPara isEqualToString:@""]) strPara = @"0";
    
    if ( [strType isEqual:@"url"] ) {
        [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :strAction :0]];
    }
    else if ( [strType isEqual:@"local"] ) {
        if ( [strAction isEqual:ACT_WriteArticle] ) {
            //设置栏目名称
            [_GLOBAL setLanMu:strPara];
            NSString *strDefaultFolderGUID = [_GLOBAL defaultCateID];
            [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:strDefaultFolderGUID noteinfo:nil];
            [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_SendPhoto] ) {
            [_GLOBAL setAlbumTypeFlag:[strPara intValue]];
            [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_Setting] ) {
            [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];
        }
    }
    
    vwNoteType.hidden = YES;
   
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void) DispSheetMenu
{
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;

    if ( !arr || [arr count] < 1 ) return;
    
    int count = (int)[arr count];
    NSMutableArray *arrTitle = [NSMutableArray array];
    for (int i=0;i<count;i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        [arrTitle addObject:[dic objectForKey:@"title"]];
    }
    
    UIActionSheet *actionsheet;
    if (1 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                    cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                    otherButtonTitles:[arrTitle objectAtIndex:0],nil];
    else if ( 2 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],nil];
    else if ( 3 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],nil];
    else if ( 4 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],nil];
    else if ( 5 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],nil];
    else if ( 6 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],[arrTitle objectAtIndex:5],nil];
    else if ( 7 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],[arrTitle objectAtIndex:5],[arrTitle objectAtIndex:6],nil];
    else if ( 8 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],[arrTitle objectAtIndex:5],[arrTitle objectAtIndex:6],[arrTitle objectAtIndex:7],nil];
    else if ( 9 == count )
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                         cancelButtonTitle:@"取消"destructiveButtonTitle:nil
                                         otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],[arrTitle objectAtIndex:5],[arrTitle objectAtIndex:6],[arrTitle objectAtIndex:7],[arrTitle objectAtIndex:8],nil];
    else
        actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
            cancelButtonTitle:@"取消"destructiveButtonTitle:nil
            otherButtonTitles:[arrTitle objectAtIndex:0],[arrTitle objectAtIndex:1],[arrTitle objectAtIndex:2],[arrTitle objectAtIndex:3],[arrTitle objectAtIndex:4],[arrTitle objectAtIndex:5],[arrTitle objectAtIndex:6],[arrTitle objectAtIndex:7],[arrTitle objectAtIndex:8],[arrTitle objectAtIndex:9],nil];
 
    
    actionsheet.actionSheetStyle = UIBarStyleBlackTranslucent;

    
    [actionsheet showInView:self.view];
    [actionsheet release];
    
}

//ACTIONSHEET的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *arr;
    if ( m_nCurPage == 0 ) arr = m_Menu1;
    else if ( m_nCurPage == 1 ) arr = m_Menu2;
    else if ( m_nCurPage == 2 ) arr = m_Menu3;
    else if ( m_nCurPage == 3 ) arr = m_Menu4;
    else arr = m_Menu5;
    
    if ( buttonIndex >= [arr count] ) return;
    
    NSDictionary *dic = [arr objectAtIndex:buttonIndex];
    
    //栏目，类型（url,local),Action, 参数
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                     @"上传精彩瞬间",@"title",@"local",@"type",@"ACT_WriteArticle",@"action",@"精彩瞬间",@"para", nil];
    NSString *strType = [dic objectForKey:@"type"];
    NSString *strAction = [dic objectForKey:@"action"];
    NSString *strPara  = [dic objectForKey:@"para"];
    if (strPara == nil || [strPara isEqualToString:@""]) strPara = @"0";
    
    if ( [strType isEqual:@"url"] ) {
        [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :strAction :0]];
    }
    else if ( [strType isEqual:@"local"] ) {
        if ( [strAction isEqual:ACT_WriteArticle] ) {
            //设置栏目名称
            [_GLOBAL setLanMu:strPara];
            NSString *strDefaultFolderGUID = [_GLOBAL defaultCateID];
            [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:strDefaultFolderGUID noteinfo:nil];
            [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_SendPhoto] ) {
            [_GLOBAL setAlbumTypeFlag:[strPara intValue]];
            [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_Setting] ) {
            [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];
        }
    }
}


@end
