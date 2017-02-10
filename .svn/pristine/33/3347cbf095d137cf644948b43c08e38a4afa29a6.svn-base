//
//  UIJYEXCZGS.m
//  NoteBook
//
//  Created by cyl on 13-4-29.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "CommonAll.h"
#import "NetConstDefine.h"
#import "Global.h"

#import "UIJYEXCZGS.h"

@implementation UIJYEXCZGS

@synthesize sWidth;
@synthesize sHeight;
@synthesize sAppUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->m_iSelectState = 0;
        self->urlArray = [[NSMutableArray array] retain];
        self.sAppUrl = nil;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBrush);
    SAFEREMOVEANDFREE_OBJECT(self->m_ivBrushAnimation);
    SAFEREMOVEANDFREE_OBJECT(self->m_labelTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_webAppWeb);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnCZGS);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnYEGS);
    SAFEREMOVEANDFREE_OBJECT(self->activityIndicator);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwActivityBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSettings);
    
    self.sAppUrl = nil;
    self.sWidth = nil;
    self.sHeight = nil;
    SAFEFREE_OBJECT(self->urlArray);
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
    // Do any additional setup after loading the view from its nib.
    
    m_vwActivityBack.layer.cornerRadius = 10;
    
#ifdef VER_YEZZB
    m_btnSettings.hidden = NO;
    m_btnBack.hidden = YES;
    CGRect frame = m_btnSettings.frame;
    m_btnSettings.frame = m_btnBrush.frame;
    m_btnBrush.frame = frame;
    m_ivBrushAnimation.center = m_btnBrush.center;
#endif
    
    
    CGRect mainframe = [UIScreen mainScreen].bounds;
    self->iScreenWidth = mainframe.size.width;
    self->iScreenHeight = mainframe.size.height;
    self.sWidth = [NSString stringWithFormat:@"%d", self->iScreenWidth];
    self.sHeight = [NSString stringWithFormat:@"%d", self->iScreenHeight]; 
    self->m_webAppWeb.delegate = self;
    [self proAppLoadWeb];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    
    CGRect rect = CGRectMake(0, -200, self.view.frame.size.width, 200);
    EGORefreshTableHeaderView *headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
    headView.delegate = self;
    [m_webAppWeb.scrollView addSubview:headView];
    _refreshHeaderView = headView;
    [headView refreshLastUpdatedDate];
    [headView release];
    
    _refreshHeaderView.hidden = YES;
#ifdef VER_YEZZB
    _refreshHeaderView.hidden = NO;
    m_webAppWeb.scrollView.delegate = self;
#endif
    
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


-(void)onLoginSuccess
{
    self->m_btnBrush.hidden = YES;
    self->m_ivBrushAnimation.hidden = NO;
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateBrushImage) userInfo:nil repeats:YES];
    
    
    [self->urlArray removeAllObjects];
    
    m_iSelectState = 0;
    self->m_btnCZGS.selected = NO;
    [self proAppLoadWeb];
    
}


-(void)proAppLoadWeb
{
    [_GLOBAL clearMessageNum:LM_YEZZB];
    [_GLOBAL clearMessageNum:LM_CZGS];
    [_GLOBAL clearMessageNum:LM_FMXT];
    
    self.sAppUrl = nil;
    NSString *s = nil;
    if ( 0 == m_iSelectState && !self->m_btnCZGS.selected ) { //
        self->m_btnCZGS.selected = YES;
        self->m_btnYEGS.selected = NO;
        s = [CommonFunc getAppAddressWithAppCode:LM_CZGS];
        [self->urlArray removeAllObjects];
    }
    else if( 1 == self->m_iSelectState && !self->m_btnYEGS.selected )
    {
        self->m_btnCZGS.selected = NO;
        self->m_btnYEGS.selected = YES;
        s = [CommonFunc getAppAddressWithAppCode:LM_FMXT];
        [self->urlArray removeAllObjects];
    }
    
    if ( s ) {
        self.sAppUrl = [NSString stringWithFormat:@"%@%@&fbl=%@%@%@",CS_URL_BASE,s, self.sWidth, @"X",self.sHeight];
        [self->m_webAppWeb stopLoading];
         [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.sAppUrl]]];
    }
}

-(void)updateBrushImage
{
    angle = angle + (2*3.1415926)*0.1;
    self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(angle);
}

-(IBAction)OnBack:(id)sender
{
    [self->m_webAppWeb stopLoading];
    if ( [self->urlArray count] > 1 ) {
        [self->urlArray removeLastObject];
        [self->m_webAppWeb stopLoading];
        
        NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        //[self->m_webAppWeb goBack];
    }
    else
    {
#ifdef VER_YEZZB
        m_btnBack.hidden = YES;
#else
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
#endif
    }
}


-(IBAction)OnSetting:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];    
}


-(void)setAppType:(int)appType
{
    self->m_iSelectState = ((appType < 2) ? appType : 0) ;
}

-(IBAction)OnSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( btn == self->m_btnYEGS ) {
        self->m_iSelectState = 1;
        [self proAppLoadWeb];
    }
    else if( btn == self->m_btnCZGS )
    {
        self->m_iSelectState = 0;
        [self proAppLoadWeb];
    }
    else if( btn == self->m_btnBrush )
    {
        self->m_btnBrush.hidden = YES;
        self->m_ivBrushAnimation.hidden = NO;
        if ( timer ) {
            [timer invalidate];
            timer = nil;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateBrushImage) userInfo:nil repeats:YES];

        [self->m_webAppWeb stopLoading];
        //[self->m_webAppWeb reload];
        NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
#ifdef VER_YEZZB
    if ([self->urlArray count] > 1 )
        m_btnBack.hidden = NO;
    else
        m_btnBack.hidden = YES;
#endif
    
    
    self->m_vwActivityBack.hidden = NO;
    if ( ![self->activityIndicator isAnimating] ) {
        [activityIndicator startAnimating];
    }
    
    
    NSString *sMethod = [request HTTPMethod];
    if ( sMethod && ([sMethod isEqualToString:@"POST"] || [sMethod isEqualToString:@"post"])) {
        return YES;
    }
    

    NSString *path = [[request URL] absoluteString];
    NSLog(@"UIJYEXCZGS url:%@\r\n", path );
    
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
    
    return YES;
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
#ifdef VER_YEZZB
    if ([self->urlArray count] > 1 )
        m_btnBack.hidden = NO;
    else
        m_btnBack.hidden = YES;
#endif
    
    
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        
        self->m_btnBrush.hidden = NO;
    }
    
    //结束同步界面
    [self restoreRefleshHeadView];
    

    if ( [error code] == -999 || [error code] == 102 ) {
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
#ifdef VER_YEZZB
    if ([self->urlArray count] > 1 )
        m_btnBack.hidden = NO;
    else
        m_btnBack.hidden = YES;
#endif
    
    [self->activityIndicator stopAnimating];
    self->m_vwActivityBack.hidden = YES;
    
    
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        
        self->m_btnBrush.hidden = NO;

    }
    
    
    NSString *titleHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"load finish: title=%@",titleHTML);

    //结束同步界面
    [self restoreRefleshHeadView];

}


//-------------下拉同步相关-----------------------------------------------------
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


-(void)restoreRefleshHeadView
{
    //结束同步界面
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_webAppWeb.scrollView];
    
}


//EGORefreshTableHeaderView的代理
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if ( !m_webAppWeb.isLoading ) {
        //[m_webAppWeb reload];
        NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        [self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return m_webAppWeb.isLoading; // should return if data source model is reloading
	
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    return [NSDate date]; // should return date data source was last changed
}


@end
