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
#import "NSObject+SBJson.h"
#import "UIJYEXSubPage.h"


@interface UIWebView (JavaScriptAlert)
-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
@end

@implementation UIWebView (JavaScriptAlert)

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"家园e线" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end



@implementation UIJYEXSubPage

@synthesize sWidth;
@synthesize sHeight;
@synthesize sAppUrl;
@synthesize msgParam;
@synthesize arrMenu;

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
    
    if ([m_webAppWeb isLoading]) {
        [m_webAppWeb stopLoading];
    }
    m_webAppWeb.delegate = nil;
    m_webAppWeb.scrollView.delegate = nil;
    
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnBrush);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnMenuOne);
    SAFEREMOVEANDFREE_OBJECT(self->m_ivBrushAnimation);
    SAFEREMOVEANDFREE_OBJECT(self->m_labelTitle);
    SAFEREMOVEANDFREE_OBJECT(self->m_webAppWeb);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnCZGS);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnYEGS);
    SAFEREMOVEANDFREE_OBJECT(self->activityIndicator);
    SAFEREMOVEANDFREE_OBJECT(self->m_vwActivityBack);
    SAFEREMOVEANDFREE_OBJECT(self->m_btnSettings);
    
    SAFEREMOVEANDFREE_OBJECT(self->vwNoteType);
    SAFEREMOVEANDFREE_OBJECT(self->twNoteTypeList);
    SAFEREMOVEANDFREE_OBJECT(self->btnHideNoteTypeList);
    SAFEREMOVEANDFREE_OBJECT(self->vwBack);
    
    self.sAppUrl = nil;
    self.sWidth = nil;
    self.sHeight = nil;
    self.msgParam = nil;
    self.arrMenu = nil;
    
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
    
    
    CGRect mainframe = [UIScreen mainScreen].bounds;
    self->iScreenWidth = mainframe.size.width;
    self->iScreenHeight = mainframe.size.height;
    self.sWidth = [NSString stringWithFormat:@"%d", self->iScreenWidth];
    self.sHeight = [NSString stringWithFormat:@"%d", self->iScreenHeight]; 
    
    m_webAppWeb.delegate = self;
    m_webAppWeb.scrollView.delegate = self;
    
    twNoteTypeList.delegate = self;
    twNoteTypeList.dataSource = self;
    
    self.sAppUrl = self.msgParam.param1;
    
    [self proAppLoadWeb];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    
    CGRect rect = CGRectMake(0, -200, self.view.frame.size.width, 200);
    EGORefreshTableHeaderView *headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
    headView.delegate = self;
    [m_webAppWeb.scrollView addSubview:headView];
    _refreshHeaderView = headView;
    [headView refreshLastUpdatedDate];
    [headView release];
    
    //接收通知刷新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:NOTIFICATION_REFRESH_CONTENT object:nil];
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

/*
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
*/


-(void)proAppLoadWeb
{
    if ( m_webAppWeb.isLoading ) [m_webAppWeb stopLoading];
    [m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sAppUrl]]];
}


-(void)updateBrushImage
{
    angle = angle + (2*3.1415926)*0.1;
    self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(angle);
}

-(IBAction)OnBack:(id)sender
{
    if ( m_webAppWeb.isLoading)
        [m_webAppWeb stopLoading];
    
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
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
    /*
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
    */
}


//设置下拉菜单的大小
-(void)setMenuFrame
{
    CGRect rNoteTypeList = self->twNoteTypeList.frame;
    float fh = 44.0;//self->twNoteTypeList.rowHeight;
    int line = (int)[arrMenu count];
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

-(IBAction)onClickMenuOne:(id)sender
{
    [self execAction:0];
}


#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    self->activityIndicator.hidden = NO;
    if ( ![self->activityIndicator isAnimating] ) {
        [activityIndicator startAnimating];
    }
    
    NSString *path = [[request URL] absoluteString];
    
    NSString *sMethod = [request HTTPMethod];
    
    NSLog(@"UIJYEXSubPage:navigationType=%ld method=%@ url:%@\r\n",(long)navigationType,sMethod,path );
    
    if ( sMethod && ([sMethod isEqualToString:@"POST"] || [sMethod isEqualToString:@"post"] ||
                     navigationType == UIWebViewNavigationTypeFormSubmitted)) {
        return YES;
    }
    
    if ([path hasPrefix:@"yk://"]) { //本地的
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
    
    //if ( navigationType != UIWebViewNavigationTypeLinkClicked) {
    //    return YES;
    //}
    
    if ( [path rangeOfString:@"http"].location == NSNotFound ) {
        return YES;
    }
    
    if ( ![sAppUrl isEqualToString:path] && ![sAppUrl isEqualToString:@"about:blank"]) {
        if ([path rangeOfString:@"_self=1"].length > 0 ) {
            self.sAppUrl = path;
            [self proAppLoadWeb]; //在本窗口打开新链接
            return YES;
        } else {
            self->activityIndicator.hidden = YES;
            [activityIndicator stopAnimating];
            
            NSRange range = [path rangeOfString:@"#PhotoSwipe"];
            NSRange range1 = [path rangeOfString:@"#&ui-state=dialog"];
            if ( range.length > 0 || range1.length > 0)  {
                //不处理
                return NO;
            }
            [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :path :0]];
            return NO;
        }
    }
    self.sAppUrl = path;
    
    return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    /*
    if ( timer ) {
        [timer invalidate];  //停止定时器
        timer = nil;
        self->m_ivBrushAnimation.transform = CGAffineTransformMakeRotation(0.0);
        self->m_ivBrushAnimation.hidden = YES;
        
        self->m_btnBrush.hidden = NO;
    }*/
    
    //结束同步界面
    [self restoreRefleshHeadView];
    

    if ( [error code] == -999 || [error code] == 102 ) {
        return;
    }
    
    [self->activityIndicator stopAnimating];
    self->activityIndicator.hidden = YES;
    
    
    NSString *err;
    if ( [[Global instance] getNetworkStatus] == NotReachable ) {
        err = @"无法加载页面，请检查网络。";
    } else {
        err = @"无法加载页面，请稍后再试。";
    }
    [self->m_webAppWeb loadHTMLString:err baseURL:nil];
    
    NSDictionary *dic = [error userInfo];
    NSString *err1 = [[NSString alloc] initWithFormat:@"加载页面%@失败 %@ 请检查网络", ((NSString*)[dic objectForKey:@"NSErrorFailingURLStringKey"]), [error localizedDescription]];
    NSLog(@"%@\r\n", err1);
    [err1 release];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self->activityIndicator stopAnimating];
    self->activityIndicator.hidden = YES;
    
    NSString *path = [[[webView request ] URL] absoluteString];
    NSString *method = [[webView request] HTTPMethod];
    NSLog(@"webViewDidFinishLoad method:%@ url:%@\r\n",method, path );
    
    
    NSString *titleHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"load finish:%p title=%@",self,titleHTML);
    m_labelTitle.text = titleHTML;

    //结束同步界面
    [self restoreRefleshHeadView];
    
    
    //提取菜单内容
    //提取rightmenu数组
    m_btnBrush.hidden = YES;
    m_btnMenuOne.hidden = YES;
    
    NSString *strMenu =
       [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"rightmenu\").value"];
    if ( !strMenu || [strMenu isEqualToString:@""]) {
        ;
    }
    else {
        if( (![strMenu hasPrefix:@"{"])  && (![strMenu hasPrefix:@"["])){
            NSRange r1 = [strMenu rangeOfString:@"{"];
            NSRange r2 = [strMenu rangeOfString:@"["];
            if ( r1.location == NSNotFound && r2.location == NSNotFound ) {
                strMenu = @"";
            }
            else {
                r1.location = ((r1.location <= r2.location) ? r1.location : r2.location);
                strMenu = [strMenu substringFromIndex:r1.location];
        
            }
        }
        if ( strMenu && [strMenu length]>0 ) {
            id retJsObj = [strMenu JSONValue];
            if ( ![retJsObj isKindOfClass:[NSArray class]] || [(NSArray *)retJsObj count]<1 ) {
                ;
            }
            else {
                self.arrMenu = retJsObj;
                if ([arrMenu count] > 1 ) {
                    m_btnBrush.hidden = NO;
                    m_btnMenuOne.hidden = YES;
                }
                else if ([arrMenu count] == 1 ) {
                    m_btnBrush.hidden = YES;
                    m_btnMenuOne.hidden = NO;
                    
                    NSDictionary *dic = [arrMenu firstObject];
                    NSString *strTitle = [dic objectForKey:@"title"];
                    
                    [m_btnMenuOne setTitle:strTitle forState:nil];
                }
            }
        }
    }

    if ( [method isEqualToString:@"POST"] ) {
        //发刷新消息页面
        m_bSndRefreshMsgFlag = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_CONTENT object:nil userInfo:nil];
        return;
    }

    //判断是否需发出刷新内容消息
    if (m_bRcvRefreshMsgFlag) {
        m_bRcvRefreshMsgFlag = NO;  //如果是收到别的消息刷新的，不再触发,清0
        return;
    }
    
    NSString *strAppRefresh =
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"app_refresh\").value"];
    if ( [strAppRefresh length] > 1) {
        //通知刷新
        if( ![strAppRefresh hasPrefix:@"{"] ){
            NSRange r1 = [strAppRefresh rangeOfString:@"{"];
            if ( r1.location == NSNotFound ) {
                strAppRefresh = @"";
            }
            else {
                strAppRefresh = [strAppRefresh substringFromIndex:r1.location];
            }
        }
        if ( strAppRefresh && [strAppRefresh length]>0 ) {
            id retJsObj = [strAppRefresh JSONValue];
            if ( [retJsObj isKindOfClass:[NSDictionary class]] ) {
                NSDictionary *dic = retJsObj;
                NSNumber *refresh_flag = [dic objectForKey:@"refresh_flag"];
                if ( refresh_flag && [refresh_flag intValue] == 1 ) {
                    m_bSndRefreshMsgFlag = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_CONTENT object:nil userInfo:nil];
                    return;
                }
            }
        }
    }
    
    
    if ( [sAppUrl rangeOfString:@"ac=jygt"].length > 0 ) {
        //进入了家园沟通页面，查看消息，发刷新消息页面
        m_bSndRefreshMsgFlag = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_CONTENT object:nil userInfo:nil];
    }
    
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

//刷新页面
-(void)refreshContent
{
    NSLog(@"JYEXSubPage:%p refreshContent---",self);
    
    //判断是不是自己发的
    if ( m_bSndRefreshMsgFlag ) {
        m_bSndRefreshMsgFlag = NO;
        return;
    }
    
    //置收到标志
    m_bRcvRefreshMsgFlag = YES;
    
    if ( !m_webAppWeb.isLoading ) {
        //[m_webAppWeb reload];
        //NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sAppUrl]]];
    }
}

-(void)notifyRefreshContent:(NSDictionary *)dic
{
    if ( !m_webAppWeb.isLoading ) {
        //[m_webAppWeb reload];
        //NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sAppUrl]]];
    }
}


//EGORefreshTableHeaderView的代理
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if ( !m_webAppWeb.isLoading ) {
        //[m_webAppWeb reload];
        //NSString *url = [self->urlArray objectAtIndex:([self->urlArray count] - 1)];
        //[self->m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [m_webAppWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sAppUrl]]];
    }
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return m_webAppWeb.isLoading; // should return if data source model is reloading
	
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
    
    
    NSDictionary *dic = [arrMenu objectAtIndex:indexPath.row];
    noteTypeCell.textLabel.text = [dic objectForKey:@"title"];
    
    return noteTypeCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMenu count];
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
    
    NSDictionary *dic = [arrMenu objectAtIndex:indexPath.row];
    
    //栏目，类型（url,local),Action, 参数
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                     @"上传精彩瞬间",@"title",@"local",@"type",@"ACT_WriteArticle",@"action",@"精彩瞬间",@"para", nil];
    NSString *strType = [dic objectForKey:@"type"];
    NSString *strAction = [dic objectForKey:@"action"];
    id para = [dic objectForKey:@"para"];
    NSString *strSelf = [dic objectForKey:@"_self"];
    int nSelf = 0;
    if ( strSelf ) nSelf = [strSelf intValue];
    
    if ( [strType isEqual:@"url"] ) {
        //处理url
        if ( ![strAction hasPrefix:@"file:"] && ![strAction hasPrefix:@"http:"] && ![strAction hasPrefix:@"HTTP"] ) {
            strAction = [CS_URL_BASE stringByAppendingString:strAction];
        }
        
        //是否本身加载
        if ( nSelf == 1 ) {
            self.sAppUrl = strAction;
            [self proAppLoadWeb];
        }
        else {
            [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :strAction :0]];
        }
    }
    else if ( [strType isEqual:@"local"] ) {
        if ( [strAction isEqual:ACT_WriteArticle] ) {
            //设置栏目名称
            if ([para isKindOfClass:[NSString class]])
                [_GLOBAL setLanMu:para];
            NSString *strDefaultFolderGUID = [_GLOBAL defaultCateID];
            [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:strDefaultFolderGUID noteinfo:nil];
            [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_SendPhoto] ) {
            NSDictionary *dicPara = nil;
            if (para && [para isKindOfClass:[NSNumber class]]) {
                dicPara = [NSDictionary dictionaryWithObjectsAndKeys:para,@"type",@"0",@"albumflag",nil];
            }
            else if (para && [para isKindOfClass:[NSDictionary class]] ) {
                dicPara = para;
            }
            else {
                dicPara = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"type",@"0",@"albumflag",nil];
                
            }
            NSNumber *type = [dicPara objectForKey:@"type"];
            NSNumber *albumflag = [dicPara objectForKey:@"albumflag"];
            NSDictionary *dicAlbum = [dicPara objectForKey:@"album"];
            
            [_GLOBAL setAlbumTypeFlag:[type intValue]];
            if ( [albumflag intValue] != 1 || !dicAlbum ) {
                [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
            }
            else {
                [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :[MsgParam param:nil :nil :dicAlbum :0]];
            }
            
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
    if ( !arrMenu || [arrMenu count] < 1 ) return;
    
    int count = (int)[arrMenu count];
    NSMutableArray *arrTitle = [NSMutableArray array];
    for (int i=0;i<count;i++) {
        NSDictionary *dic = [arrMenu objectAtIndex:i];
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
    [self execAction:buttonIndex];
}

- (void)execAction:(NSInteger)buttonIndex
{
    if ( buttonIndex >= [arrMenu count] ) return;
    
    NSDictionary *dic = [arrMenu objectAtIndex:buttonIndex];
    
    //栏目，类型（url,local),Action, 参数
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                     @"上传精彩瞬间",@"title",@"local",@"type",@"ACT_WriteArticle",@"action",@"精彩瞬间",@"para", nil];
    NSString *strType = [dic objectForKey:@"type"];
    NSString *strAction = [dic objectForKey:@"action"];
    id para = [dic objectForKey:@"para"];
    NSString *strSelf = [dic objectForKey:@"_self"];
    int nSelf = 0;
    if ( strSelf ) nSelf = [strSelf intValue];
    
    if ( [strType isEqual:@"url"] ) {
        //处理url
        if ( ![strAction hasPrefix:@"file:"] && ![strAction hasPrefix:@"http:"] && ![strAction hasPrefix:@"HTTP"] ) {
            strAction = [CS_URL_BASE stringByAppendingString:strAction];
        }
        
        //是否本身加载
        if ( nSelf == 1 ) {
            self.sAppUrl = strAction;
            [self proAppLoadWeb];
        }
        else {
            [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :strAction :0]];
        }
    }
    else if ( [strType isEqual:@"local"] ) {
        if ( [strAction isEqual:ACT_WriteArticle] ) {
            //设置栏目名称
            if ([para isKindOfClass:[NSString class]])
                [_GLOBAL setLanMu:para];
            NSString *strDefaultFolderGUID = [_GLOBAL defaultCateID];
            [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:strDefaultFolderGUID noteinfo:nil];
            [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
        }
        else if ( [strAction isEqual:ACT_SendPhoto] ) {
            NSDictionary *dicPara = nil;
            if (para && [para isKindOfClass:[NSNumber class]]) {
                dicPara = [NSDictionary dictionaryWithObjectsAndKeys:para,@"type",@"0",@"albumflag",nil];
            }
            else if (para && [para isKindOfClass:[NSDictionary class]] ) {
                dicPara = para;
            }
            else {
                dicPara = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"type",@"0",@"albumflag",nil];
                
            }
            NSNumber *type = [dicPara objectForKey:@"type"];
            NSNumber *albumflag = [dicPara objectForKey:@"albumflag"];
            NSDictionary *dicAlbum = [dicPara objectForKey:@"album"];
            
            [_GLOBAL setAlbumTypeFlag:[type intValue]];
            if ( [albumflag intValue] != 1 || !dicAlbum ) {
                [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :nil];
            }
            else {
                [PubFunction SendMessageToViewCenter:NMJYEXUploadPic :0 :1 :[MsgParam param:nil :nil :dicAlbum :0]];
            }
            
        }
        else if ( [strAction isEqual:ACT_Setting] ) {
            [PubFunction SendMessageToViewCenter:NMJYEXSetting :0 :1 :nil];
        }
        else if ([strAction isEqualToString:ACT_NewAlbum]) {
            
            NSNumber *type = para;
             
            [_GLOBAL setAlbumTypeFlag:[type intValue]];
            
            [PubFunction SendMessageToViewCenter:NMJYEXSelectAlbum :0 :1 :[MsgParam param:self :@selector(notifyRefreshContent:) :@"1" :0]];
        }
    }
}


@end
