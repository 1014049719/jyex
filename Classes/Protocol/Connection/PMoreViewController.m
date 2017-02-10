//
//  PMoreViewController.m
//  pass91
//
//  Created by Zhaolin He on 09-9-2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PMoreViewController.h"
//#import "UIProgressHUD.h"

static PMoreViewController *me=nil;
static BOOL page_loaded=NO;

@implementation PMoreViewController
//@synthesize indicator;
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init{
    if (self = [super init]) {
		// Custom initialization
		page_loaded=NO;
		self.title=NSLocalizedString(@"more_tab_msg",nil);
		self.tabBarItem.image=[UIImage imageNamed:@"Resource/Skin/more.png"];
        
		UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44)];
		web.delegate=self;
		web.scalesPageToFit=YES;
		self.view=web;
		[web release];
		
		me=self;
    }
    return self;
}

+(id)sharedMoreController{
	return me;
}

-(void)loadPage{
	if(!page_loaded){
		page_loaded=YES;
		
		NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://91.com"]];
		UIWebView *web=(UIWebView *)self.view;
		[web loadRequest:request];
		
		//UIProgressHUD *progress=[[UIProgressHUD alloc] initWithFrame:CGRectMake(60, 100, 200, 150)];
		//[progress setText:NSLocalizedString(@"loading",nil)];
		//self.indicator=progress;
		//[progress release];
	}
}

/*
 // Implement loadView to create a view hierarchy programmatically.
 - (void)loadView {
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self retain];
	//[self.indicator showInView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	//[self.indicator hide];
	[webView stringByEvaluatingJavaScriptFromString:@"{\
	 var a = document.getElementsByTagName(\"a\"); \
	 for (var i=0; i<a.length; i++) \
	 a[i].target = \"_self\";\
	 }"];
	
	[self release];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	MLOG([error localizedDescription]);
	[self release];
}

- (void)dealloc {
	//[indicator release];
    [super dealloc];
}


@end
