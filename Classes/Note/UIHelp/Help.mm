//
//  Help.m
//  NoteBook
//
//  Created by mwt on 13-1-23.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "Help.h"

@implementation Help

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnBack) ;
    SAFEREMOVEANDFREE_OBJECT(m_WebView);
    
    [super dealloc];
}

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
    // Do any additional setup after loading the view from its nib.

    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    //NSString *strPath = [[NSBundle mainBundle] bundlePath];
    NSString *strResourcePath  = [[NSBundle mainBundle] resourcePath];
    NSString *strHelpHtmlPath = [NSString stringWithFormat:@"%@/html/help/readme.htm", strResourcePath];
    NSURL *url = [NSURL fileURLWithPath:strHelpHtmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //self->m_WebView.scalesPageToFit = YES;
    
    [self->m_WebView loadRequest:request];
     
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
    [self->m_WebView stopLoading];
    
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

@end
