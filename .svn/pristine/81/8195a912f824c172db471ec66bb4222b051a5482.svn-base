/*
 *  ProtocolViewController.mm
 
 *  NoteBook
 *
 *  Created by Huang Yan on 9/23/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#import "ProtocolViewController.h"

@implementation ProtocolViewController

- (id)init
{
	if ([super init])
	{
		self.title = _(@"Protocol");
	}
	
	return self;
} 

- (void)dealloc
{
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 420);
	UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
	[webView setBackgroundColor:[UIColor whiteColor]];
	webView.delegate = self;
#if !TARGET_IPHONE_SIMULATOR
	NSString *urlAddress = @"/Applications/91Note.app/Resource/protocol/index.html";
#else
	NSString *urlAddress = @"/Users/Shared/protocol/index.html";
#endif
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	[self.view addSubview:webView]; 
	
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	
    [webView release];
}
#pragma mark <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	hub = [[PPHubView alloc] initWithLargeIndicator:CGRectMake(160-66, 480-44-12-36-60-2-10, 158, 36) text:_(@"loading...") showCancel:YES];
	[self.view addSubview: hub];
	[hub release];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[hub  removeFromSuperview];
}
@end
