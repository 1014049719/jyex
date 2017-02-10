//
//  About.m
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "About.h"

@implementation About

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
    // Do any additional setup after loading the view from its nib
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];

    [self->m_btnJump setBackgroundImage:[[UIImage imageNamed:@"BiaoGeShuRuKuang.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted]; 

    CGSize contentSize = self->m_viAbout.frame.size;
    contentSize.height = self->m_viewContent.frame.size.height;
    [self->m_viAbout setContentSize:contentSize];
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
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnJump91MainPage:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMAppInfo :0 :1 :nil];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rj.91.com/"]];
}

-(void) dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_viAbout) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnBack) ;
    SAFEREMOVEANDFREE_OBJECT(m_viewContent) ;
    SAFEREMOVEANDFREE_OBJECT(m_btnJump) ;
    [super dealloc] ;
}

@end
