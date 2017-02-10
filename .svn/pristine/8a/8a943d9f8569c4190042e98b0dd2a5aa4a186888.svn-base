//
//  PUpdateController.m
//  pass91
//
//  Created by Zhaolin He on 09-8-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PUpdateController.h"
//#import "UIProgressHUD.h"

@implementation PUpdateController
//@synthesize indicator;
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init
{
    if (self = [super init]) 
    {
        // Custom initialization
		NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://reg.91.com/NDUser_Login.aspx?siteflag=84&controller=member&action=login&from=my.reg.91.com&backurl=aHR0cDovL215LnJlZy45MS5jb20v"]];
		UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44)];
		web.delegate=self;
		web.scalesPageToFit=YES;
		[web loadRequest:request];
		
		self.view=web;
		[web release];
		
		//UIProgressHUD *progress=[[UIProgressHUD alloc] initWithFrame:CGRectMake(60, 100, 200, 150)];
		//[progress setText:NSLocalizedString(@"loading",nil)];
		//self.indicator=progress;
		//[progress release];
	}
    return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view.
 - (void)viewDidLoad {
 [super viewDidLoad];
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
