//
//  UIVCSettingBlogBind.m
//  Weather
//
//  Created by nd on 11-11-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "UIImage+WebCache.h"
#import "UIVCSettingBlogBind.h"
#import "PubFunction.h"
#import "NetConstDefine.h"
#import "BlogIntf.h"
#import "UIAstroAlert.h"


@implementation BlogBindParam
@synthesize bbpType;
@synthesize snsType;
@synthesize snsName;

+ (BlogBindParam*) param :(NSString*)name :(int)type :(int)bbpType
{
	BlogBindParam* p = [[BlogBindParam new] autorelease];
	p.snsName = name;
    p.snsType = type;
    p.bbpType = bbpType;
    
	return p;
}

- (void) dealloc
{
    self.snsName = nil;
    [super dealloc];
}

@end


@implementation UIVCSettingBlogBind
@synthesize urlBind;
@synthesize web, lbTips;
@synthesize lbNickname, imgViewAvatar;
@synthesize indicateView;
@synthesize msgParam;

/*
- (void) showLeaveMsg:(NSString*)msg
{
    [self returnBtnPress:nil];
    [UIAstroAlert info:msg :2.0 :NO :LOC_MID :YES];
}
*/

- (IBAction)returnBtnPress:(id)sender 
{ 
    /*
    [self.indicateView stopAnimating];
    self.indicateView.hidden = YES;
    
    [self retain];
    [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
    */
    
    isBack = YES;
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_FT)
    {
        lbTSGZ.text = LOC_STR("bg_tsgz");
        lbYLSM.text = LOC_STR("ylsm");
        lbK.text = LOC_STR("bg_k");
        lbG.text = LOC_STR("bg_g");
        lbCap.text = LOC_STR("bg_wbgl");
        lbTips.text = LOC_STR("bg_zzlj");
    }
	
	UIActivityIndicatorView *uiIndicateView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
	CGRect rect = CGRectMake(150, 215, 20, 20); // 140 220
	[uiIndicateView setFrame: rect];
	[self.view addSubview:uiIndicateView];
	[uiIndicateView startAnimating];
	self.indicateView = uiIndicateView;
	[uiIndicateView release];
    
    [self.view setOpaque:YES]; // force view to be loaded!
    indicateView.hidden = NO;
    [self.indicateView startAnimating];
	
    
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    if (param.bbpType==BBP_BindtoSNS)
        [self bindToSNS];
    else if (param.bbpType==BBP_QueryStatus)
        [self queryBindStatus];
    else if (param.bbpType==BBP_Unbind)
        [self unbindStatus];
    else
    {
        isBack = YES;
        [PubFunction SendMessageToViewCenter:NMBack :0 :0 :nil];
    }
}

- (void) bindToSNS
{ 
    sessionChecked = NO;
    self.web.hidden = YES;
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    self.lbTips.text = [NSString stringWithFormat:LOC_STR("bg_fmt_lj"), param.snsName];
    
	NSString *url = [[BlogIntf instance] getBindUrl: param.snsType];
    if (url == nil) 
    {
        [self showOperationResultMessage:LOC_STR("bg_wlgz")];
        return;
    }
    self.urlBind = url;
    
	[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlBind] 
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy  
                                  timeoutInterval:30.0]];
    
	NSLog(@"bindToSNS: %@", self.urlBind);
}

- (void) queryBindStatusInBackground
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    NSDictionary *dict = [[BlogIntf instance] QueryBind:param.snsType];
    if (dict) 
    {
        
        //[self performSelectorOnMainThread:@selector(showOperationResultMessage:) withObject:LOC_STR("bg_cxd") waitUntilDone:NO]; 
        
        [self performSelectorOnMainThread:@selector(showBindUrlAndAvatar:) withObject:dict waitUntilDone:NO];   
    } 
    else
    {
        
        [self performSelectorOnMainThread:@selector(showOperationResultMessage:) withObject:LOC_STR("bg_cxsb") waitUntilDone:NO]; 
        
       // [self performSelectorOnMainThread:@selector(showLeaveMsg:) withObject:LOC_STR("bg_cxsb") waitUntilDone:NO];
    }
    
   
    
    [pool release];
}

- (void) queryBindStatus 
{
    self.web.hidden = YES;
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    self.lbTips.text = [NSString stringWithFormat:LOC_STR("bg_fmt_lj"), param.snsName];
    [self performSelectorInBackground:@selector(queryBindStatusInBackground) withObject:nil];
}


- (void)showOperationResultMessage:(NSString *)msg 
{
    if (isBack)
    {
        [self retain];
        [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
        return;
    }
    
    self.lbTips.text = msg;
    [self.indicateView stopAnimating];
    self.indicateView.hidden = YES;
    
}


- (void)showBindUrlAndAvatar:(NSDictionary*)dict
{
    if (isBack)
    {
        [self retain];
        [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
        return;
    }
    
    if (dict)
    {
        NSLog(@"%@", [dict objectForKey:kBlogUrl]);
        NSLog(@"%@", [dict objectForKey:kBlogNickname]);
        NSLog(@"%@", [dict objectForKey:kBlogAvatar]);
        
        self.lbTips.text = LOC_STR("bg_cxd");
        [self.indicateView stopAnimating];
        self.indicateView.hidden = YES;

        self.lbNickname.hidden = NO;
        self.imgViewAvatar.hidden = NO;
        self.lbNickname.text = [dict objectForKey:kBlogNickname];
        self.imgViewAvatar.image = [UIImage imageWithWebCache:[dict objectForKey:kBlogAvatar]];
    }
    
}


- (void) unbindStatusInBackground
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    if ([[BlogIntf instance] UnBind:param.snsType])
    {
        [self performSelectorOnMainThread:@selector(returnBtnPress:) withObject:nil waitUntilDone:NO];
    }
    else
        [self performSelectorOnMainThread:@selector(showOperationResultMessage:) withObject:LOC_STR("bg_qxsb") waitUntilDone:NO];
    
    [pool release];
}
    /*
    if ([[BlogIntf instance] UnBind:param.snsType])
    {
        msg = [NSString stringWithFormat:LOC_STR("bg_qxcg")];
        
    }
    else
    {
        msg = [NSString stringWithFormat:LOC_STR("bg_qxsb")];
        [self performSelectorOnMainThread:@selector(showOperationResultMessage:) withObject:msg waitUntilDone:NO]; 
    }
     */

- (void) unbindStatus 
{
    self.web.hidden = YES;
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    self.lbTips.text = [NSString stringWithFormat:LOC_STR("bg_fmt_lj"), param.snsName];
    [self performSelectorInBackground:@selector(unbindStatusInBackground) withObject:nil];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
	NSLog(@"shouldStartLoadWithRequest: %@", url);
    // 如果是绑定成功的页面，则直接返回上级页面
    BlogBindParam *param = (BlogBindParam *)(msgParam.param1);
    if ([[url relativePath] isEqualToString: CS_BLOG_BIND_SUCCESS_PATH])
    { 
        [[BlogIntf instance] SetBindOK: param.snsType];
        
        [self performSelectorOnMainThread:@selector(returnBtnPress:) withObject:nil waitUntilDone:NO];
    }

    // 先检查页面是否正常，如果已经检查过，则用webview打开
    if (sessionChecked)
    {
        return YES;
    }
 
    // 确保sid不会失效
    [[BlogIntf instance] Login];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn == nil) 
    {
        NSLog(@"cannot create connection");
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	[self.indicateView stopAnimating];
	self.indicateView.hidden = YES;
    webView.hidden = NO;

    NSLog(@"webViewDidFinishLoad");
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}
*/


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	self.lbNickname.hidden = YES;
    self.imgViewAvatar.hidden = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.lbTips = nil;
    self.web = nil;
	self.indicateView = nil;
	self.lbNickname = nil;
	self.imgViewAvatar = nil;
}

- (void)dealloc 
{
    self.lbTips = nil;
    self.web = nil;
	self.indicateView = nil;
	self.lbNickname = nil;
	self.imgViewAvatar = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection:didReceiveResponse");
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        sessionChecked = YES;
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int status = [httpResponse statusCode];
        
        if (status != 200)
        {
            NSLog(@"failed, http status code: %d", status);
            //self.lbTips.text = LOC_STR("bg_wlgz");
            
            [self performSelectorOnMainThread : @selector(showOperationResultMessage:) 
                                   withObject : LOC_STR("bg_wlgz") 
                                waitUntilDone : NO];
            
            return;
        }
        
        // cancel the connection. we got what we want from the response,
        // no need to download the response data.
        [connection cancel];
        
        // start loading the new request in webView
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlBind]]];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection:didReceiveData");
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection:didFailWithError - %@", error);
    //[self showOperationResultMessage: [error localizedDescription]];
    
    [self performSelectorOnMainThread : @selector(showOperationResultMessage:) 
                           withObject : [error localizedDescription] 
                        waitUntilDone : NO];
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
}


@end
