//
//  UINoteRead.m
//  NoteBook
//
//  Created by susn on 12-11-21.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UINoteRead.h"
#import "CommonAll.h"
#import "Global.h"
#import "PubFunction.h"
#import "UINoteEdit.h"
#import "BizLogicAll.h"
#import "UIMyWebView.h"
#import "UIAstroAlert.h"
#import "DataSync.h"
#import "GlobalVar.h"
//#import "FlurryAnalytics.h"
#import "UIImage+Scale.h"
#import "UIPresentImage.h"


@implementation UINoteRead
@synthesize m_NoteInfo;
@synthesize m_arrNoteGuid;
@synthesize syncid;
@synthesize syncflag;
@synthesize arrSyncNoteGuid;
@synthesize strTapImageFile;
@synthesize strTapImageUrl;


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
  
    NSLog(@"UINoteRead viewDidLoad");
    
    self.arrSyncNoteGuid = [NSMutableArray array];
    
    [m_btnToolCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnToolCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
 
    
    //scrollview
    m_scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+m_barView.frame.size.height);
    m_scrollview.delegate = self;
    

    webviewheight = _mywebview.frame.size.height;
    _mywebview.scrollView.backgroundColor = [UIColor colorWithRed:247 green:244 blue:222 alpha:1.0];

    //----------------------------
#ifdef _USE_NOTEWEBVIEW
    _mywebview.delegate = self;
    _mywebview.scrollView.delegate = self;
    
    /*
     if ( _singleRecognizer ) {
     [_mywebview removeGestureRecognizer:_singleRecognizer];
     _singleRecognizer = nil;
     }
     
     UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hangleSingleTapFrom)];
     recognizer.numberOfTapsRequired = 1; //单击
     _singleRecognizer = RTEGestureRecognizer;
     [_mywebview.scrollView addGestureRecognizer:recognizer];
     [recognizer release];
     */
    
    // Setup image dragging/moving
    if ( _singleRecognizer ) {
        [_mywebview.scrollView removeGestureRecognizer:_singleRecognizer];
        _singleRecognizer = nil;
    }
    
    RTEGestureRecognizer *tapInterceptor = [[RTEGestureRecognizer alloc] init];
    
    tapInterceptor.touchesBeganCallback = ^(NSSet *touches, UIEvent *event) {
        // Here we just get the location of the touch
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:_mywebview];
        touchpoint = touchPoint;
        hintpoint = touchPoint;
        tapImageFlag = 0;
        tapTriggerFlag = 0;
        self.strTapImageUrl = nil;
        
        // What we do here is to get the element that is located at the touch point to see whether or not it is an image
        NSString *javascript = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).toString()", touchPoint.x, touchPoint.y];
        NSString *elementAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript];
        NSLog(@"touch start elementAtPoint=%@",elementAtPoint);
        
        if ([elementAtPoint rangeOfString:@"Image"].location != NSNotFound)
        {
            NSString *javascript1 = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *strNameAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript1];
            NSLog(@"tap image.image name=%@",strNameAtPoint);
            tapImageFlag = 1;
            self.strTapImageFile = strNameAtPoint;
        }
        
        NSLog(@"touch begin.point=%@",NSStringFromCGPoint(touchpoint));
        //}
    };
    
    tapInterceptor.touchesEndedCallback = ^(NSSet *touches, UIEvent *event) {
        // Let's get the finished touch point
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:_mywebview];
        touchpoint = touchPoint;
        
        if ( ABS(touchPoint.x - hintpoint.x )<10 && ABS(touchPoint.y - hintpoint.y )<10 )
        {
            // What we do here is to get the element that is located at the touch point to see whether or not it is an image
            NSString *javascript = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).toString()", touchPoint.x, touchPoint.y];
            NSString *elementAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript]; 
            NSLog(@"elementAtPoint=%@",elementAtPoint);
            
            if ([elementAtPoint rangeOfString:@"Image"].location != NSNotFound) 
            {
                NSString *javascript1 = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
                NSString *strNameAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript1]; 
                NSLog(@"tap image.image name=%@",strNameAtPoint);
                if ( 0 == tapTriggerFlag) {
                    tapTriggerFlag = 1;
                    [self performSelector:@selector(dispImage) withObject:nil afterDelay:0.2];
                }
                
                // We set the inital point of the image for use latter on when we actually move it
                //initialPointOfImage = touchPoint;
                // In order to make moving the image easy we must disable scrolling otherwise the view will just scroll and prevent fully detecting movement on the image.            
                //    _mywebview.scrollView.scrollEnabled = YES;
            }
            else 
            {
                if ( m_toolView.hidden ) [self displayToolView];
                else [self hideToolView];
            }
        }
        // And move that image!
        //NSString *javascript = [NSString stringWithFormat:@"moveImageAtTo(%f, %f, %f, %f)", initialPointOfImage.x, initialPointOfImage.y, touchPoint.x, touchPoint.y];
        //     [webView stringByEvaluatingJavaScriptFromString:javascript];
        
        // All done, lets re-enable scrolling
        //_mywebview.scrollView.scrollEnabled = YES;
        
        NSLog(@"touch end.point=%@",NSStringFromCGPoint(touchpoint));
    };
    
    [_mywebview.scrollView addGestureRecognizer:tapInterceptor];  
    _singleRecognizer = tapInterceptor;
    [tapInterceptor release];
    
    /*
    if ( !mywebview ) {
        //设置代理
        //m_noteContentWebView.delegate = self; //不再使用这个webview    
        m_noteContentWebView.hidden = YES;
        mywebview = [[UIMyWebView alloc] initWithFrame:m_noteContentWebView.frame];
        mywebview.delegate = self;
        mywebview.mydelegate = self;
        mywebview.scrollView.delegate = self;
        mywebview.backgroundColor = [UIColor colorWithRed:247 green:244 blue:222 alpha:1.0];
        mywebview.scrollView.backgroundColor = [UIColor colorWithRed:247 green:244 blue:222 alpha:1.0];
        mywebview.opaque = YES;
        mywebview.clearsContextBeforeDrawing = YES;
        [m_scrollview addSubview:mywebview];
    }
    [self.view bringSubviewToFront:m_toolView];
   
    //保存webview的原始大小
    webviewheight = mywebview.frame.size.height;
    */

#endif
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //Set Cache
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];
    
    [self flashContent];
    
    //监听更新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reRoadData) name:NOTIFICATION_UPDATE_NOTE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataNoteStar:) name:NOTIFICATION_UPDATE_NOTE_STAR object:nil];
    
    //三秒以后隐藏最下面的工具栏
    [self execSyncAfterThreeSeconds];
    
    //NSLog(@"NoteRead1:retaincount=%d",[self retainCount]);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    NSLog(@"---->UINoteRead dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIAstroAlert infoCancel];
       
    //m_noteContentWebView.delegate = nil;
    //[m_noteContentWebView stopLoading];
    
    if ( self.syncid > 0 )  //取消同步的回调
        [[DataSync instance] cacelSyncRequest:self.syncid];
    
    self.strTapImageFile = nil;
    self.strTapImageUrl = nil;
    [self.arrSyncNoteGuid removeAllObjects];
    self.arrSyncNoteGuid = nil;
    
    //去掉代理
    m_scrollview.delegate = nil;
    
#ifdef _USE_NOTEWEBVIEW
    [_mywebview stopLoading];
    _mywebview.delegate = nil;
    _mywebview.scrollView.delegate = nil;
    
    /*    
     #else
     _mywebview.delegate = nil;
     _mywebview.mydelegate = nil;
     _mywebview.scrollView.delegate = nil;
     [_mywebview stopLoading];
     [_mywebview removeFromSuperview];
     */
#endif    
    
    /*
    mywebview.delegate = nil;
    mywebview.mydelegate = nil;
    [mywebview loadHTMLString:@"" baseURL:nil];
    [mywebview stopLoading];
    [mywebview removeFromSuperview];
    [mywebview release];
    mywebview = nil;
    */

    self.m_NoteInfo = nil;
    self.m_arrNoteGuid = nil;
    
    //用到有代理的视图释放，要在前面释放掉。
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;   
    
    SAFEREMOVEANDFREE_OBJECT(m_btnToolCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolOpr);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolLastNote);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolNextNote);
    SAFEREMOVEANDFREE_OBJECT(m_toolView);
    SAFEREMOVEANDFREE_OBJECT(m_barView);
    SAFEREMOVEANDFREE_OBJECT(m_lbTitle);
    SAFEREMOVEANDFREE_OBJECT(m_noteContentWebView);
    SAFEREMOVEANDFREE_OBJECT(m_scrollview);
    
    [super dealloc];    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)execSyncAfterThreeSeconds
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(threeSecondsTimeout) object:nil];
    [self performSelector:@selector(threeSecondsTimeout) withObject:nil afterDelay:3.5];
}


- (void)exitProc:(BOOL)bNoteEdit
{
    NSLog(@"UINoteRead exitProc");
    
    _singleRecognizer.touchesBeganCallback = nil;
    _singleRecognizer.touchesEndedCallback = nil;
    [_mywebview.scrollView removeGestureRecognizer:_singleRecognizer];
    _singleRecognizer = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(threeSecondsTimeout) object:nil];
    
    if ( bNoteEdit ) {
        
        [self.navigationController popViewControllerAnimated:NO];
        [TheGlobal popNavTitle];
        
        [_GLOBAL setEditorAddNoteInfo:NEWNOTE_EDIT_FROM_READ catalog:nil noteinfo:m_NoteInfo];
        [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    }
    else {
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
}

-(void)editNote
{
    //[FlurryAnalytics logEvent:@"笔记-编辑"];
    
    //先退出
    [self exitProc:YES];
}

-(void)dispImage
{
    NSString *strFileName = self.strTapImageFile;
    
    NSRange range = [strFileName rangeOfString:@"/" options:NSBackwardsSearch];
    if ( range.length <= 0 ) return;
    
    NSString *str1 = [strFileName substringFromIndex:range.location + range.length];
    range = [str1 rangeOfString:@"."];
    if ( range.length <= 0 ) return;
    
    NSString *strItem = [str1 substringToIndex:range.location];
    //NSString *strExt = [str1 substringFromIndex:range.location+range.length];
    
    NSArray *arrItem = [AstroDBMng getItemListByNote:m_NoteInfo.strNoteIdGuid includeDelete:NO];
    if ( !arrItem ) return;
    
    NSMutableArray *arrPic = [NSMutableArray array];
    int iPos = -1,picnum=0;
    for (int jj=0;jj<[arrItem count];jj++)
    {
        TItemInfo *pItem = [arrItem objectAtIndex:jj];
        if ( [CommonFunc isImageFile:pItem.strItemExt] )
        {
            NSString *strFileName1 = [CommonFunc getItemPathAddSrc:pItem.strItemIdGuid fileExt:pItem.strItemExt];
            if ( ![CommonFunc isFileExisted:strFileName1])
                strFileName1 = [CommonFunc getItemPath:pItem.strItemIdGuid fileExt:pItem.strItemExt];
            
            if ( [strItem isEqualToString:pItem.strItemIdGuid] ) iPos = picnum;
            [arrPic addObject:strFileName1];
            picnum++;
        }
    }
    
    if ( [arrPic count] == 0 || iPos < 0 ) return;
    
    UIPresentImage *vc = [[UIPresentImage alloc] initWithNibName:@"UIPresentImage" bundle:nil];
    vc.m_pos = iPos;
    vc.m_arrItem = arrPic;
    if ( self.strTapImageUrl ) [vc setUrl:strTapImageUrl];
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];	
}



- (IBAction) onToolCancel:(id)sender
{
	[self exitProc:NO];
}


- (IBAction) onToolOprNote:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"编辑",nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionsheet showInView:self.view];
    [actionsheet release];
}

//ACTIONSHEET的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  
{
    if ( !m_NoteInfo ) return;
    
    if (buttonIndex == 0) {  //删除
        //if ( m_NoteInfo.nNeedDownlord == DOWNLOAD_NEED )
        //{
        //    [UIAstroAlert info:@"笔记正在上传，不能删除" :2.0 :NO :LOC_MID :NO];
        //}
        //else
        {
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除该条笔记吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
            [alertview show];
            [alertview release];
        }
    }
    else if (buttonIndex == 1) {  //编辑
        
        if ( ![TheCurUser isLogined] || [[Global instance] getNetworkStatus] == NotReachable)  //还没登录,或者网络不通
        {
            [self editNote];
            return;
        }
        
        for (id ojb in arrSyncNoteGuid )
        {
            if ( [ojb isEqualToString:m_NoteInfo.strNoteIdGuid] ) //已同步过
            {
                //if ( m_NoteInfo.nNeedDownlord == DOWNLOAD_NEED ) 
                //{
                    //[UIAstroAlert info:@"笔记正在上传，请稍候" :2.0 :NO :LOC_MID :NO];
                //}
                //else
                {
                    [self editNote];
                }
                return;
            }
        }
        
        //还没同步
        bNeedEdit = YES;
        [self syncNote];
        return;
        
    }
    else if(buttonIndex == 2) {   //取消
        //[self showAlert:@"第二项"];  
    }
    
}  

//UIAlertView的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) { //取消
        return;
    }
    else { //删除笔记
        //[FlurryAnalytics logEvent:@"笔记-删除"];
        
        [BizLogic deleteNote:m_NoteInfo.strNoteIdGuid SendUpdataMsg:YES];
        //返回上一层
        [self exitProc:NO]; 
    }
}


- (IBAction) onToolLastNote:(id)sender
{
    if ( curnotepos > 0 ) {
        curnotepos--;
        [self procChangeNote];
        //三秒以后隐藏最下面的工具栏
        [self execSyncAfterThreeSeconds];
     }
 }

- (IBAction) onToolNextNote:(id)sender
{
    if ( curnotepos+1 < [m_arrNoteGuid count] ) {
        curnotepos++;
        [self procChangeNote];
        //三秒以后隐藏最下面的工具栏
        [self execSyncAfterThreeSeconds];
    }
}

- (IBAction) onClickScreen:(id)sender
{
    [self touchEnd:nil];
}

//隐藏工具栏
- (void)hideToolView
{
    if ( m_toolView.hidden ) return;
    m_toolView.hidden = YES;
    
    //scrollview高度
    //CGRect rect = m_scrollview.frame;
    //rect.size.height += m_toolView.frame.size.height;
    //rect.origin.y -= m_toolView.frame.size.height;
    //m_scrollview.frame = rect;
    
    CGRect rect = _mywebview.frame;  //只变高度
    //rect.size.height += m_toolView.frame.size.height;
    rect.size.height += m_barView.frame.size.height;
    //mywebview.frame = rect;
    //webviewheight = mywebview.frame.size.height;
    
    //位置偏移修改
    
}

//显示工具栏
- (void)displayToolView
{
    if ( !m_toolView.hidden ) return;
    m_toolView.hidden = NO;
        
    CGRect rect = _mywebview.frame;
    //rect.size.height -= m_toolView.frame.size.height;  //只变高度
    rect.size.height -= m_barView.frame.size.height;  //只变高度
    //_mywebview.frame = rect;
    //webviewheight = _mywebview.frame.size.height;
}


- (void)threeSecondsTimeout
{
    //三秒后同步笔记
    [self syncNote];
    
    //隐藏工具栏
    //[self hideToolView];
}


- (void)flashContent
{
    self.m_NoteInfo = [_GLOBAL getEditNoteInfo];
    if ( !m_NoteInfo)
    {
        [UIAstroAlert info:@"该条笔记已被删除" :2.0 :YES :LOC_MID :NO];
        m_btnToolLastNote.enabled = NO;
        m_btnToolNextNote.enabled = NO;
        m_btnToolOpr.enabled = NO;
        //[self exitProc:NO];
        return;
    }
    
    [self reRoadData];
}


//NoteUpdate消息响应函数
- (void)reRoadData
{
    //重取队列
    //获取该目录的所有笔记的Guid，并保存
    self.m_arrNoteGuid = [AstroDBMng getNoteListGuidByCate:self.m_NoteInfo.strCatalogIdGuid];
    if ( !m_arrNoteGuid  || [m_arrNoteGuid count] < 1 )
    {
        [UIAstroAlert info:@"该条笔记已被删除" :2.0 :YES :LOC_MID :NO];
        m_btnToolLastNote.enabled = NO;
        m_btnToolNextNote.enabled = NO;
        m_btnToolOpr.enabled = NO;
        curnotepos = 0;
        //[self exitProc:NO];
        return;
    }
    
    //获得当前笔记所在的位置,如果不存在了，默认为第一个
    curnotepos = 0;
    for (int i=0;i<[m_arrNoteGuid count];i++ ) {
        NSString *guid = (NSString *)[m_arrNoteGuid objectAtIndex:i];
        if ( [m_NoteInfo.strNoteIdGuid isEqualToString:guid] ) {
            curnotepos = i;
            break;
        }
    }
   
    [self procChangeNote];
}


-(BOOL) procChangeNote
{
    if ( !m_arrNoteGuid || curnotepos >= [m_arrNoteGuid count] ) {
        [UIAstroAlert info:@"该条笔记已被删除" :2.0 :YES :LOC_MID :NO];
        //[self exitProc:NO];
        return FALSE;        
    }
    
    self.m_NoteInfo = [AstroDBMng getNote:(NSString *)[m_arrNoteGuid objectAtIndex:curnotepos]];
    if ( !m_NoteInfo ) {
        [UIAstroAlert info:@"该条笔记已被删除" :2.0 :YES :LOC_MID :NO];
        //[self exitProc:NO];
        return FALSE;
    }
 
    //设置当前笔记
    [_GLOBAL setEditorAddNoteInfo:NEWNOTE_EDIT catalog:nil noteinfo:m_NoteInfo];
    
    //设置按钮的属性
    if ( curnotepos == 0 ) m_btnToolLastNote.enabled = NO;
    else m_btnToolLastNote.enabled = YES;
    if ( curnotepos+1 == [m_arrNoteGuid count] ) m_btnToolNextNote.enabled = NO;
    else m_btnToolNextNote.enabled = YES;    
    
    if ( m_NoteInfo ) {
        //标题
        m_lbTitle.text = self.m_NoteInfo.strNoteTitle;
        
        //加载内容,如果不是HTML，//把不是HTML的笔记转换成HTML笔记
        if ( ![m_NoteInfo.strFileExt isEqualToString:@"html"] ) {
            [BizLogic changeToHtmlNote:m_NoteInfo.strNoteIdGuid];
        }
        //文件名
        NSString *strEditFileName = [CommonFunc getItemPath:self.m_NoteInfo.strFirstItemGuid fileExt:@"html"];
        
        if ( [CommonFunc isFileExisted:strEditFileName] ) {
            
            //Clear All Cookies
            //for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            //}
            //--------
            
            NSURL *baseURL = [NSURL fileURLWithPath:strEditFileName isDirectory:NO];
            NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
            //[m_noteContentWebView loadRequest:request];
            [_mywebview loadRequest:request]; 
         }
        
        if ( DOWNLOAD_NEED == m_NoteInfo.nNeedDownlord ) //需要下载
        {
            //同步当前笔记
            [self syncNote];
            return YES;
        }
    }
    return YES;
    
}


//播放语音
- (void) playFile:(NSString *)strFileName
{
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;
    
    if ( !m_PlayView ) {
        m_PlayView = [[PlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) ];
        m_PlayView.delegate = self;
        [self.view addSubview:m_PlayView];
    }
    
    [m_PlayView startPlay:strFileName];
}


//播放的代理
-(void) PlayFinish
{
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;    
}


//UIWebView的代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( request ) {
        NSURL *newUrl = [request URL];
        NSString *absoluteString = [newUrl absoluteString];
        NSLog(@"url:%@",absoluteString);
        
        NSRange wavRange = [absoluteString rangeOfString:@".wav"];
        NSRange amrRange = [absoluteString rangeOfString:@".amr"];
        NSRange fileRange = [absoluteString rangeOfString:@"file://"];
        NSRange blankRange = [absoluteString rangeOfString:@"about:blank"];
        NSString *notefile = [m_NoteInfo.strFirstItemGuid stringByAppendingString:@".html"];
        NSRange noteRange = [absoluteString rangeOfString:notefile];
        if ( (wavRange.length>0 ||amrRange.length>0) && (fileRange.length>0 ))//|| hostRange.length>0) )
        {
            NSString *path = [absoluteString stringByReplacingCharactersInRange:fileRange withString:@""];
            
            //本地的WAV文件，播放WAV文件
            [self playFile:path];
            return NO;
        }
        
        if ( blankRange.length > 0 ) { //跳到空白页面
            return NO;
        }
        
        //跳出到另外的窗口
        if ( noteRange.length <= 0 ) {
            if ( 1 == tapImageFlag ) {//点击图画不跳转
                if ( 0 == tapTriggerFlag ) {
                    tapTriggerFlag = 1;
                    self.strTapImageUrl = absoluteString;
                    [self performSelector:@selector(dispImage) withObject:nil afterDelay:0.2];
                }
            }
            else {
                [PubFunction SendMessageToViewCenter:NMWebView :0 :1 :[MsgParam param:nil :nil :absoluteString :0]];
            }
            
            return NO;
        }
    }
    return YES;
}

//
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *content = m_NoteInfo.strContent;
    if ( content ) {
        NSLog(@"content: length=%d content=%@",[content length],content);
        if ([content length] > 5 ) return;
    
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];        
    
        if ( ![content isEqualToString:@""] ) return;
    }
    
    NSString *notefile = [CommonFunc getItemPath:m_NoteInfo.strFirstItemGuid fileExt:@"html"];
    NSString *contentText = [CommonFunc getHTMLFileBodyText:notefile];
    NSLog(@"new content=%@",contentText);
    if ( [contentText length]> 200 ) 
        contentText = [contentText substringToIndex:200];    
    if ( [contentText length] > 0 ) {
        m_NoteInfo.strContent = contentText;
        [AstroDBMng updateNote:m_NoteInfo];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

//mywebview的代理
- (void)touchEnd:(NSSet *)touches
{
    if ( m_toolView.hidden ) [self displayToolView];
    else [self hideToolView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CGPoint offset1 = scrollView.contentOffset;
    //NSLog(@"scrollViewDidScroll: (%.0f, %.0f)", offset1.x, offset1.y);
    if ( scrollView == _mywebview.scrollView ) {
        if ( startPoint.y <= 0.1) startPoint = scrollView.contentOffset;
    }
}

//scrollview的代理
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( scrollView == _mywebview.scrollView ) {
        //CGPoint point1 = velocity;
        CGPoint point2 = *targetContentOffset;
    
        //同时滚动外部的scroll
        if ( point2.y > m_scrollview.contentSize.height - m_scrollview.frame.size.height )
            point2.y = m_scrollview.contentSize.height - m_scrollview.frame.size.height;
        point2.x = 0; //横向不滚动
        [m_scrollview setContentOffset:point2];
        
        //webview的frame设大一点
        //CGRect frame = _mywebview.frame;
        //if ( point2.y > m_barView.frame.size.height) point2.y = m_barView.frame.size.height;
        //frame.size.height = webviewheight + point2.y;
        //_mywebview.frame = frame;
        
        CGPoint endPoint = scrollView.contentOffset;
        if ( endPoint.y < startPoint.y ) {
            [self displayToolView];
        }
        else {
            [self hideToolView];
        }
        startPoint.y = 0;
    }
    
    NSLog(@"scrollViewWillEndDragging.velocity=[%.0f,%.0f]",velocity.x,velocity.y);
    m_velocity = velocity;
    
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    if ( m_velocity.y >= 1.0) [self hideToolView];
    else if ( m_velocity.y <= -1.0 ) [self displayToolView];
    
    startPoint.y = 0;
}



//同步当前笔记
-(void)syncNote
{
    //if (![ TheCurUser isLogined]) return;
    if ( [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] ) return;
    if ( [[Global instance] getNetworkStatus] == NotReachable ) return;

    if ( !m_NoteInfo ) return;
        
    for (id ojb in arrSyncNoteGuid )
    {
        if ( [ojb isEqualToString:m_NoteInfo.strNoteIdGuid] ) return; //已同步过
    }
    
    //if ( self.syncflag == 0 ) {
        //[UIAstroAlert info:@"正在同步，请稍候" :YES :NO]; //一直遮住
        m_btnToolOpr.enabled = NO;
        
        if ( self.syncid > 0 )  //取消同步的回调
            [[DataSync instance] cacelSyncRequest:self.syncid];
        
        self.syncflag = 1;
        self.syncid = [[DataSync instance] syncRequest:BIZ_SYNC_NOTE :self :@selector(syncCallback:) :m_NoteInfo];
    //}
}

//同步的回调
- (void)syncCallback:(TBussStatus*)sts
{
    self.syncflag = 0;
    self.syncid = 0;

    m_btnToolOpr.enabled = YES;
    
    //添加到已同步的数组
    if (arrSyncNoteGuid && m_NoteInfo)
        [self.arrSyncNoteGuid addObject:m_NoteInfo.strNoteIdGuid];
    
	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"同步成功" :2.0 :NO :LOC_MID :NO];
        BOOL bRet = [self procChangeNote];
        if ( bRet && bNeedEdit )  //笔记还存在
        {
            [self editNote];
        }
        bNeedEdit = NO;
	}
	else
	{
        //失败了
		//[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
    
}

-(void)updataNoteStar:(NSNotification *)note
{
    if ( note ) {
        NSString *guid = (NSString*)[[note userInfo] objectForKey:@"note_guid"];
        NSInteger star = [[[note userInfo] objectForKey:@"note_star"]integerValue];
        if ( [guid isEqualToString:m_NoteInfo.strNoteIdGuid]
            && m_NoteInfo.nStarLevel != star ) {
            m_NoteInfo.nStarLevel = star;
            [BizLogic updataNoteInfo:m_NoteInfo];
        }
    }
}

- (IBAction) onNoteInfo:(id)sender
{
    //[FlurryAnalytics logEvent:@"笔记信息"];
    
    //笔记信息
    [PubFunction SendMessageToViewCenter: NMNoteInfor:0 :1 :self.m_NoteInfo];
}


@end


/*
@interface StatusBarDemoViewController : UIViewController {
    StatusBarWindow *statusBar;
    UIButton *switchButton;
    BOOL showStatusBar;
}

@property (nonatomic, retain) StatusBarWindow *statusBar;
@property (nonatomic, retain) UIButton *switchButton;
@property (nonatomic) BOOL showStatusBar;

- (IBAction)click;

@end


@implementation StatusBarDemoViewController

@synthesize statusBar, switchButton, showStatusBar;

- (IBAction)click {
    showStatusBar = !showStatusBar;
    if (showStatusBar) {
        statusBar.hidden = NO;
        [switchButton setTitle: @"隐藏自定义状态栏" forState:UIControlStateNormal];
    } else {
        statusBar.hidden = YES;
        [switchButton setTitle: @"显示自定义状态栏" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StatusBarWindow *statusBarWindow = [StatusBarWindow newStatusBarWindow];
    self.statusBar = statusBarWindow;
    [statusBarWindow release];
    
    CGRect frame = {{80, 200}, {160, 30}};
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"显示自定义状态栏" forState:UIControlStateNormal];
    self.switchButton = button;
    [self.view addSubview:button];
}

- (void)viewDidUnload {
    self.statusBar = nil;
    self.switchButton = nil;
}

- (void)dealloc {
    [super dealloc];
    [statusBar release];
    [switchButton release];
}

@end

*/


