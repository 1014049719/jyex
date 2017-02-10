//
//  SelectFolderColor.m
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "SelectFolderColor.h"
#import "PubFunction.h"
#import "GlobalVar.h"

@implementation SelectFolderColor
@synthesize msgParam;

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_btnFinish);
    
    self.msgParam = nil ;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.msgParam = nil ;
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
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnBack.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnBack.frame = rect;
    [self->m_btnBack setTitle:strNavTitle forState:UIControlStateNormal];
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

-(IBAction)OnFolderColor:(id)sender
{
    int tag ;
    UIButton *btn = (UIButton*)sender ;
    tag = btn.tag ;
    
    NSString *strColor;
    strColor = [NSString stringWithFormat:@"%d",tag];
    
    if (msgParam != nil)
    {
		[msgParam.obsv performSelector:msgParam.callback withObject:strColor afterDelay:0.0];
    }
    
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    
    //[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnFinish:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

@end
