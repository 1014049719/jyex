//
//  UINoteMoreSoft.m
//  NoteBook
//
//  Created by cyl on 12-12-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "UINoteMoreSoft.h"

@implementation UINoteMoreSoft

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
    [activityIndicator stopAnimating];
    SAFEREMOVEANDFREE_OBJECT(activityIndicator);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_webView);
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    self->m_webView.delegate = self;
	self->m_webView.scalesPageToFit = YES;
    
    CGRect rect;
    rect.size.width = 50;
    rect.size.height = 50;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    [activityIndicator setCenter:self.view.center];
    activityIndicator.hidden = YES;
	
	[self->m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://rj.91.com"]]];

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

-(IBAction)OnBack:(id)sender
{
    //头栏完成按钮
    [self->m_webView stopLoading];
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    activityIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;    
}


@end
