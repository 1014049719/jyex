//
//  UIWeb.m
//  NoteBook
//
//  Created by susn on 13-1-24.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "UIWeb.h"

#import "PubFunction.h"
#import "UIAstroAlert.h"
#import "NetConstDefine.h"

@implementation UIWeb
@synthesize msgParam;
@synthesize sHeight;
@synthesize sWidth;

//@synthesize strCurUrl;
//@synthesize strCurPageLevel;
//@synthesize nMaxPageLevel;

- (void)dealloc
{
    NSLog(@"UIWeb dealloc");
    
    self.msgParam = nil;
    self.sHeight = nil;
    self.sWidth = nil;
    
    //self.strCurUrl = nil;
    //self.strCurPageLevel = nil;
    
    //SAFEFREE_OBJECT(self->arrUrl);
    //SAFEFREE_OBJECT(self->arrPageLevel);
    
    
    [activityIndicator stopAnimating];
    
    SAFEREMOVEANDFREE_OBJECT(m_btnClose);
    SAFEREMOVEANDFREE_OBJECT(m_lbTitle);
    SAFEREMOVEANDFREE_OBJECT(m_webView);
    SAFEREMOVEANDFREE_OBJECT(activityIndicator);
    SAFEREMOVEANDFREE_OBJECT(m_vwActivityBack);
 
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self->arrUrl = [[NSMutableArray array] retain];
        //self->arrPageLevel = [[NSMutableArray array] retain];
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
    
    
    m_vwActivityBack.layer.cornerRadius = 10;
    
    self->m_webView.delegate = self;
	//self->m_webView.scalesPageToFit = YES;
    self->m_webView.scrollView.delegate = self;
    
    CGRect mainframe = [UIScreen mainScreen].bounds;
    self.sWidth = [NSString stringWithFormat:@"%.0f", mainframe.size.width];
    self.sHeight = [NSString stringWithFormat:@"%.0f", mainframe.size.height];
    
    m_vwActivityBack.hidden = YES;
    
    NSString *url=@"file://127.0.0.1/";
    if ( msgParam )
        url = msgParam.param1;
	[self->m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    CGRect rect = CGRectMake(0, -200, self.view.frame.size.width, 200);
    EGORefreshTableHeaderView *headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
    headView.delegate = self;
    [m_webView.scrollView addSubview:headView];
    _refreshHeaderView = headView;
    [headView refreshLastUpdatedDate];
    [headView release];
    
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

-(IBAction)OnClose:(id)sender
{
    [self->m_webView stopLoading];
    self->m_webView.delegate = nil;
    
    //头栏完成按钮
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}


-(IBAction)OnBack:(id)sender
{
    /*
    //头栏返回按钮
    [self->m_webView stopLoading];
    
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
    
    [self->m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLastUrl]]];
    [strLastUrl release];
    return;
    //----------
    */

    
    [self->m_webView stopLoading];
    if ( [self->m_webView  canGoBack]) {
        [self->m_webView goBack];
    }
    else
    {
        self->m_webView.delegate = nil;
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
    
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *sMethod = [request HTTPMethod];
    NSString *path = [[request URL] absoluteString];
    
    
    //保存旧的URL到数组中
    /*
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
            else if ([self.strCurPageLevel isEqualToString:@"0"] ) { //没有层级号,保存
                [self->arrUrl addObject:self.strCurUrl];
                [self->arrPageLevel addObject:self.strCurPageLevel];
            }
            else { //有等级号
                if ( [strCurPageLevel intValue] > self.nMaxPageLevel ) { //等级号更大，保存
                    [self->arrUrl addObject:self.strCurUrl];
                    [self->arrPageLevel addObject:self.strCurPageLevel];
                    self.nMaxPageLevel = [strCurPageLevel intValue];
                }
            }
        }
        self.strCurUrl = nil;
        self.strCurPageLevel = nil;
    }
    */
    //-----

    
    if ( sMethod && ([sMethod isEqualToString:@"POST"] || [sMethod isEqualToString:@"post"])) {
        NSLog(@"load POST url:%@\r\n", path );
        return YES;
    }
    
   
    NSLog(@"load url:%@\r\n", path );
    if ( [path rangeOfString:@"http"].location == NSNotFound ) {
        return YES;
    }
    
    if ( ([path rangeOfString:self.sWidth].location != NSNotFound)
        && ([path rangeOfString:self.sHeight].location != NSNotFound)) {
        if ( navigationType != UIWebViewNavigationTypeBackForward ) {
        }
        return YES;
    }
    else if ( [path rangeOfString:CS_URL_BASE].location == NSNotFound ) {
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
        NSLog(@"add fbl, url:%@\r\n", url );
        [self->m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return NO;
    }
    return YES;
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    m_vwActivityBack.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    m_vwActivityBack.hidden = YES;
    
    NSString *titleHTML = [m_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    m_lbTitle.text = titleHTML;
    
    
    //处理页面层级号
    NSString *pagelevelHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"pagelevel\").value"];
    NSLog(@"pagelevel:%@",pagelevelHTML);
    if ( !pagelevelHTML || [pagelevelHTML isEqualToString:@""]) pagelevelHTML = @"0";
    NSString *urlHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"load finish,URL:%@",urlHTML);
    
    /*
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
    */
    //-------
    
    
    if ( m_btnClose.hidden ) {
        if ( [self->m_webView  canGoBack]) {
            m_btnClose.hidden = NO;
        }
    }
    
    //结束同步界面
    [self restoreRefleshHeadView];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    m_vwActivityBack.hidden = YES;
    
    //结束同步界面
    [self restoreRefleshHeadView];
    
    if ( [error code] == -999 || [error code] == 102 ) {
        return;
    }
    NSDictionary *dic = [error userInfo];
    NSString *err = [[NSString alloc] initWithFormat:@"加载页面%@失败 %@ 请检查网络", ((NSString*)[dic objectForKey:@"NSErrorFailingURLStringKey"]), [error localizedDescription]];
    NSLog(@"%@\r\n", err);
    [self->m_webView loadHTMLString:err baseURL:nil];
    [err release];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_webView.scrollView];
    
}


//EGORefreshTableHeaderView的代理
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if ( !m_webView.isLoading )
        [m_webView reload];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return m_webView.isLoading; // should return if data source model is reloading
	
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    return [NSDate date]; // should return date data source was last changed
}



@end
