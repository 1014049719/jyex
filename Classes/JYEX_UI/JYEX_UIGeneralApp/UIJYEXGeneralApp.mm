//
//  UIJYEXGeneralApp.m
//  NoteBook
//
//  Created by cyl on 13-4-27.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "CommonAll.h"
#import "BizLogicAll.h"
#import "Global.h"
#import "GlobalVar.h"
#import "NetConstDefine.h"
#import "UIJYEXGeneralApp.h"
#import "BussDataDef.h"

@implementation UIJYEXGeneralApp

@synthesize appInfo;
@synthesize sAppUrl;
@synthesize sWidth;
@synthesize sHeight;
@synthesize m_sAppCode;
@synthesize strCurUrl;
@synthesize strCurPageLevel;
@synthesize nMaxPageLevel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->urlArray = [[NSMutableArray array] retain];
        self->arrUrl = [[NSMutableArray array] retain];
        self->arrPageLevel = [[NSMutableArray array] retain];
        self->m_iCurBtnIndex = -1;
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
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBrush);
    SAFEREMOVEANDFREE_OBJECT(self->m_ivBrushAnimation);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnEditLog);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnPaiZao);
    SAFEREMOVEANDFREE_OBJECT(self->m_labelTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_webAppWeb);
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBanji);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnGeren);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnXiaoxi);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnPinan);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnHuike);
    SAFEREMOVEANDFREE_OBJECT(self->activityIndicator);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwActivityBack);
    
    self.m_sAppCode = nil;
    self.sAppUrl = nil;
    self.appInfo = nil;
    self.sWidth = nil;
    self.sHeight = nil;
    self.strCurUrl = nil;
    self.strCurPageLevel = nil;
    
    SAFEFREE_OBJECT(self->urlArray);
    SAFEFREE_OBJECT(self->arrUrl);
    SAFEFREE_OBJECT(self->arrPageLevel);
    
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
    }
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_vwActivityBack.layer.cornerRadius = 10;
    
    // Do any additional setup after loading the view from its nib.
    //[self->m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    //[self->m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    CGRect rect;
    rect.size.width = 50;
    rect.size.height = 50;
    rect.origin.x = self.view.center.x;
    rect.origin.y = self.view.center.y;
    //self->m_vwActivityBack.hidden = YES;

    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    if ( [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {
        [m_btnGeren setTitle:@"学校" forState:nil];
    }
    
    [self setBottomNavHidden];
    
    CGRect mainframe = [UIScreen mainScreen].bounds;
    self->iScreenWidth = mainframe.size.width;
    self->iScreenHeight = mainframe.size.height;
    self.sWidth = [NSString stringWithFormat:@"%d", self->iScreenWidth];
    self.sHeight = [NSString stringWithFormat:@"%d", self->iScreenHeight]; 
    self->m_webAppWeb.delegate = self;
   
    self->m_iCurBtnIndex = [CommonFunc getBtnTagWithCode:self.appInfo.sAppCode];
    if ( self->m_iCurBtnIndex != -1 ) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:self->m_iCurBtnIndex];
        btn.selected = YES;
    }
    [self proLoadAppWeb:self.appInfo.sAppName Code:self.appInfo.sAppCode];
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

-(void)drawNavBtn
{
    /*
    if ( self->m_arrayNavBtn && [self->m_arrayNavBtn count]) {
        UIButton *btn = [self->m_arrayNavBtn objectAtIndex:0];
        float f_X = btn.frame.origin.x;
        CGRect r;
        for ( int i = 0; i < [self->m_arrayNavBtn count]; ++i ) {
            btn = [self->m_arrayNavBtn objectAtIndex:i];
            if ( btn.hidden ) {
                r = btn.frame;
                r.origin.x = f_X;
                btn.frame = r;
                f_X += r.size.width;
            }
        }
    }
    */
}

-(void)proLoadAppWeb:(NSString *)sTitle Code:(NSString*)sCode
{
    if ( !sCode ) {
        return;
    }
    NSString *s = [CommonFunc getAppAddressWithAppCode:sCode];
    if ( !s ) {
        return;
    }
    self.m_sAppCode = sCode;
    
    [self->m_labelTitle setText:sTitle];
    
    if ( [sCode isEqualToString:LM_PAJS] ) { //平安接送
        self->m_webAppWeb.scalesPageToFit = YES;
    }
    else
    {
        self->m_webAppWeb.scalesPageToFit = NO;
    }
    
    [_GLOBAL clearMessageNum:sCode];
    
    //self.sAppUrl = [NSString stringWithFormat:@"%@%@&fbl=%@%@%@",CS_URL_BASE,s, self.sWidth, @"X",self.sHeight];
    self.sAppUrl = [NSString stringWithFormat:@"%@%@",CS_URL_BASE,s];
    [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.sAppUrl]]];
    //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://61.144.88.98:6805/test/"]]];
}

-(void)updateBrushImage
{
    angle = angle + (2*3.1415926)*0.1;
    self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(angle);
}

-(IBAction)OnBack:(id)sender
{
    //头栏完成按钮
    [self->m_webAppWeb stopLoading];
    
    //----------
    if ([self->arrUrl count] == 0 ) {
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
        return;
    }
    NSString *strLastUrl = [[self->arrUrl lastObject] copy];
    [self->arrUrl removeLastObject];
    [self->arrPageLevel removeLastObject];
    self.strCurUrl = nil;
    self.strCurPageLevel = nil;
    self.nMaxPageLevel = 0;
    for (int i=0;i<[arrPageLevel count];i++) {
        NSString *strPageLevel = [arrPageLevel objectAtIndex:i];
        if ( [strPageLevel intValue] > self.nMaxPageLevel) self.nMaxPageLevel = [strPageLevel intValue];
    }
    
    //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLastUrl]]];
    [m_webAppWeb goBack];
    
    [strLastUrl release];
    return;
    //----------
    
    /*
    if ( [self->urlArray count] > 1 ) {
        [self->urlArray removeLastObject];
        [self->m_webAppWeb stopLoading];
        //进入班级空间时,会自动跳转一次,如果按照正常回退,点击
        //两次回退才能退到主界面
        if (  [self.m_sAppCode isEqualToString:@"BJKJ"]
            && [self->urlArray count] == 1) {
            [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
            return;
        }
        NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        [self setTitleWithUrl: url];
        //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self->m_webAppWeb goBack];
    }
    else
    {
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
    */
}

-(IBAction)OnSelect:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if ( btn ) {
        if ( btn == self->m_btnBrush) { //刷新
            self->m_btnBrush.hidden = YES;
            self->m_ivBrushAnimation.hidden = NO;
            if ( timer ) {
                [timer invalidate];
                timer = nil;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateBrushImage) userInfo:nil repeats:YES];
            
            self.strCurUrl = nil;  //需要清掉
            self.strCurPageLevel = nil;
            
            [self->m_webAppWeb stopLoading];
            NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
            [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
        else if ( btn == self->m_btnPaiZao ) {
            [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
        }
        else if( btn == self-> m_btnEditLog )
        {
            int n;
            //if ( btn == self->m_btnPaiZao ) {
            //    n = NEWNOTE_CAMERA;
            //}
            //else
            //{
            n = NEWNOTE_TEXT;
            //}
            
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
                [_GLOBAL setEditorAddNoteInfo:n catalog:cateInfor.strCatalogIdGuid noteinfo:nil];
                [cateInfor release];
                [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
            }
        }
    }
}

-(IBAction)OnBottomNav:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if ( btn ) {
        int i = (int)btn.tag;
        if ( self->m_iCurBtnIndex != i ) {
            if ( self->m_iCurBtnIndex != -1 ) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:self->m_iCurBtnIndex];
                btn.selected = NO;
            }
            
            self->m_iCurBtnIndex = i;
            btn.selected = YES;
            [self->urlArray removeAllObjects];
            NSString *sTitle = nil;
            NSString *sCode = nil;
            self->m_webAppWeb.scalesPageToFit = NO;
            
            //需清掉相关数据
            [self->arrUrl removeAllObjects];
            [self->arrPageLevel removeAllObjects];
            self.strCurUrl = nil;  //需要清掉
            self.strCurPageLevel = nil;
            self.nMaxPageLevel = 0;
            
            sCode = [CommonFunc getAppCodeWithBtnTag:(int)btn.tag];
            JYEXUserAppInfo *t_appInfo = [BizLogic getAppListByUserName:TheCurUser.sUserName AppCode:sCode];
            if ( !t_appInfo ) {
                sTitle = btn.titleLabel.text;
            }
            else {
                sTitle = t_appInfo.sAppName;
            }
                
            
            [self proLoadAppWeb:sTitle Code:sCode];
        }
    }
}

-(void)setBottomNavHidden
{
        TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
        if ( [u isInfantsSchoolParent] ) {
            m_btnHuike.hidden = YES;
        }
        else if( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher] ){
            m_btnPinan.hidden = YES;
            m_btnHuike.hidden = YES;
        }
        else if ( [u isMiddleSchoolParent] ) {
            m_btnPinan.hidden = YES;
            m_btnHuike.hidden = YES;
        }
        else if ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) //校长
        {
            m_btnPinan.hidden = YES;
            m_btnHuike.hidden = YES;
        }
        else { //普通用户
            m_btnPinan.hidden = YES;
            m_btnHuike.hidden = YES;
            m_btnBanji.hidden = YES;
            m_btnXiaoxi.frame = m_btnGeren.frame;
            m_btnGeren.frame = m_btnBanji.frame;
            
        }
    
    
        [self drawNavBtn];
}

-(int)getBtnIndexWithCode:(NSString*)sCode
{
    if ( sCode ) {
        if ( [sCode isEqualToString:@"QQHK"] )  //亲情会客
        {
            return 1004;
        }
        else if( [sCode isEqualToString:@"PAJS"] ) //平安接送
        {
            return 1003;
        }
        else if( [sCode isEqualToString:@"GRKJ"] ) //个人空间
        {
            return 1001;
        }
        else if( [sCode isEqualToString:@"BJKJ"] ) //班级空间
        {
            return 1000;
        }
        else if( [sCode isEqualToString:@"PM"] )
        {
            return 1002;
        }
    }
    return -1;
}

-(void)setTitleWithUrl:(NSString *)url
{
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self->m_vwActivityBack.hidden = NO;
    if ( ![self->activityIndicator isAnimating] ) {
        [activityIndicator startAnimating];
    }
    
    //保存旧的URL到数组中
    if ( self.strCurUrl && self.strCurPageLevel && ![strCurPageLevel isEqualToString:@""] ) { //上次的入栈
        if ( [self->arrUrl count] == 0 ) {
            [self->arrUrl addObject:self.strCurUrl];
            [self->arrPageLevel addObject:self.strCurPageLevel];
            nMaxPageLevel = [strCurPageLevel intValue];
        }
        else {
            NSString *strLastUrl = [self->arrUrl lastObject];
        
            if ( [strLastUrl isEqualToString:self.strCurUrl]) { //URL相同，不处理
            }
            else if ([self.strCurPageLevel isEqualToString:@"0"] ) { //没有层级号
                [self->arrUrl addObject:self.strCurUrl];
                [self->arrPageLevel addObject:self.strCurPageLevel];
            }
            else { //有等级号
                if ( [strCurPageLevel intValue] > self.nMaxPageLevel ) { //等级号更大
                    [self->arrUrl addObject:self.strCurUrl];
                    [self->arrPageLevel addObject:self.strCurPageLevel];
                    self.nMaxPageLevel = [strCurPageLevel intValue];
                }
            }
        }
        self.strCurUrl = nil;
        self.strCurPageLevel = nil;
    }
    
    
    //NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]; 
    //NSLog(@"http:post:body:%@\r\n", body);
    NSString *sMethod = [request HTTPMethod];
    //    NSLog(@"http:post:Method:%@\r\n", sMethod);
    if ( sMethod && ([sMethod isEqualToString:@"POST"] || [sMethod isEqualToString:@"post"])) {
        return YES;
    }

    NSString *path = [[request URL] absoluteString];
    NSLog(@"UIJYEXGeneralApp url:%@\r\n", path );
    if ( [path rangeOfString:@"http"].location == NSNotFound ) {
        return YES;
    }
    if ( ([path rangeOfString:self.sWidth].location != NSNotFound)
        && ([path rangeOfString:self.sHeight].location != NSNotFound)) { //比较是否已经加了屏幕参数
        [self setTitleWithUrl: path];
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
            NSLog(@"urlArray count:%lu\r\n", (unsigned long)[self->urlArray count] );
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
        NSLog(@"jump to UIJYEXGeneralApp url:%@\r\n", url );
        [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        self->m_btnBrush.hidden = NO;
    }
    
    if ( [error code] == -999 || [error code] == 102) {
        return;
    }
    NSDictionary *dic = [error userInfo];
    NSString *err = [[NSString alloc] initWithFormat:@"加载页面%@失败 %@ 请检查网络", ((NSString*)[dic objectForKey:@"NSErrorFailingURLStringKey"]), [error localizedDescription]];
    NSLog(@"%@\r\n", err);
    [self->m_webAppWeb loadHTMLString:err baseURL:nil];
    [err release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    NSString *titleHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title=%@",titleHTML);
    if ( titleHTML && [titleHTML length]>0 ) {
        self->m_labelTitle.text = titleHTML;
        [_GLOBAL setLanMu:titleHTML];
    }
    
    NSString *pagelevelHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"pagelevel\").value"];
    NSLog(@"pagelevel:%@",pagelevelHTML);
    if ( !pagelevelHTML || [pagelevelHTML isEqualToString:@""]) pagelevelHTML = @"0";
    NSString *urlHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"URL:%@",urlHTML);
    
    self.strCurUrl = urlHTML;   //先保存
    self.strCurPageLevel = pagelevelHTML;
    
    if ( [self->arrPageLevel count] > 0 && ![pagelevelHTML isEqualToString:@"0"]) {
        int nCurPageLevel = [pagelevelHTML intValue];
        if ( nCurPageLevel <= self.nMaxPageLevel) {//加载的比原来的等级号要小的网页，需弹出大于等于它的。
            //需弹出
            self.nMaxPageLevel = 0;
            int count = (int)[self->arrPageLevel count];
            for (int i=count-1;i>=0;i--) {
                NSString *strPageLevel = [self->arrPageLevel objectAtIndex:i];
                int nPageLevel = [strPageLevel intValue];
                if ( nPageLevel ==0 || nPageLevel >= nCurPageLevel) {
                    [self->arrPageLevel removeLastObject];
                    [self->arrUrl removeLastObject];
                }
                else {
                    self.nMaxPageLevel = nPageLevel;
                    break;
                }
            }
        }
     }
    

    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        self->m_btnBrush.hidden = NO;
    }
}
@end
