//
//  UINotePhotoQuality.m
//  NoteBook
//
//  Created by cyl on 12-12-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "CfgMgr.h"
#import "UINotePhotoQuality.h"

@implementation UINotePhotoQuality

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
    
    NSString *strValue = nil;
    BOOL b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"NotePhotoQuality" value:strValue];
    if ( !b || !strValue || strValue.length == 0 ) {
        strValue = @"M";
    }
    self->m_strPQ = [strValue copy];
    
    CGRect r;
    self->m_ivCurSelect.frame = r;
    if ( [self->m_strPQ isEqualToString:@"L"] ) {
        r = self->m_ivSelect0.frame;
    }
    else if( [self->m_strPQ isEqualToString:@"H"] ) {
        r = self->m_ivSelect2.frame;
    }
    else{
        r = self->m_ivSelect1.frame;
        self->m_strPQ = @"M";
    }
    self->m_ivCurSelect.frame = r;
    

    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
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

#pragma mark - 按钮响应函数
-(IBAction)onSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    CGRect  r;
    if ( 0 == tag ) {
        r = self->m_ivSelect0.frame;
        self->m_strPQ = @"L";
    }
    else if( 1 == tag )
    {
        r = self->m_ivSelect1.frame;
        self->m_strPQ = @"M";
    }
    else
    {
        r = self->m_ivSelect2.frame;
        self->m_strPQ = @"H";
    }
    self->m_ivCurSelect.frame = r;
}

-(IBAction)onBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
}

-(IBAction)onOk:(id)sender
{
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"NotePhotoQuality" value:self->m_strPQ];
    [self onBack:nil];
}

-(void) dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnNavCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavFinish);
    
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect0);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect1);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect2);
    SAFEREMOVEANDFREE_OBJECT(m_ivCurSelect);
    
    [super dealloc] ;
}

@end
