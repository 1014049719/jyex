//
//  UISelectFont.m
//  NoteBook
//
//  Created by cyl on 12-12-13.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "Global.h"
#import "BizLogic_Login.h"
#import "CfgMgr.h"
#import "UISelectFont.h"

@implementation UISelectFont

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
    self->m_ivArray[ 0 ] = self->m_ivSelect0;
    self->m_ivArray[ 1 ] = self->m_ivSelect1;
    self->m_ivArray[ 2 ] = self->m_ivSelect2;
    self->m_ivArray[ 3 ] = self->m_ivSelect3;
    self->m_ivArray[ 4 ] = self->m_ivSelect4;
    self->m_ivArray[ 5 ] = self->m_ivSelect5;
    self->m_ivArray[ 6 ] = self->m_ivSelect6;
    self->m_ivArray[ 7 ] = self->m_ivSelect7;
    self->m_ivArray[ 8 ] = self->m_ivSelect8;
    self->m_ivArray[ 9 ] = self->m_ivSelect9;
    self->m_ivArray[ 10 ] = self->m_ivSelect10;
    self->m_ivArray[ 11 ] = self->m_ivSelect11;
    self->m_ivArray[ 12 ] = self->m_ivSelect12;
    self->m_ivArray[ 13 ] = self->m_ivSelect13;
    self->m_ivArray[ 14 ] = self->m_ivSelect14;
    self->m_ivArray[ 15 ] = self->m_ivSelect15;
    self->m_ivArray[ 16 ] = self->m_ivSelect16;
    self->m_ivArray[ 17 ] = self->m_ivSelect17;
    self->m_ivArray[ 18 ] = self->m_ivSelect18;
    self->m_ivArray[ 19 ] = self->m_ivSelect19;
    self->m_ivArray[ 20 ] = self->m_ivSelect20;
    // Do any additional setup after loading the view from its nib.
//    pc = [[PlistController alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:CONFIGURE_FILE_PATH]];
//	NSMutableDictionary *dic = [pc readDicPlist];
//    NSNumber *noteFont = [dic objectForKey:@"noteFont"];
//    if ( !noteFont ) {
//        self->m_iFontIndex = 3;
//    }
//    else
//    {
//        self->m_iFontIndex = [noteFont intValue];
//    }
    NSString *strFontIndex = nil;
    BOOL b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"NoteFontSizeIndex" value:strFontIndex];
    if ( !b || !strFontIndex || strFontIndex.length == 0 ) {
        self->m_iFontIndex = 3;
    }
    else
    {
        self->m_iFontIndex = [strFontIndex integerValue];
        if (self->m_iFontIndex >= NoteFontMaxIndex ) {
            self->m_iFontIndex = 3;
        }
    }
    CGRect r = self->m_ivArray[ self->m_iFontIndex ].frame;
    self->m_ivCurSelect.frame = r;

    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];

    self->m_scrollFont.contentSize
    = CGSizeMake(self->m_viewFontList.frame.size.width
                 , self->m_viewFontList.frame.size.height);
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
-(IBAction)onSelectFont:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    CGRect r = self->m_ivArray[ tag ].frame;
    self->m_ivCurSelect.frame = r;
    self->m_iFontIndex = tag;
}

-(IBAction)onBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
}

-(IBAction)onOk:(id)sender
{
    NSString *strFontIndex = [NSString stringWithFormat:@"%d", self->m_iFontIndex];
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"NoteFontSizeIndex" value:strFontIndex];
    [self onBack:nil];
}

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnNavCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavFinish);
    SAFEREMOVEANDFREE_OBJECT(m_scrollFont);
    SAFEREMOVEANDFREE_OBJECT(m_viewFontList);
    
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect0);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect1);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect2);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect3);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect4);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect5);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect6);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect7);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect8);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect9);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect10);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect11);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect12);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect13);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect14);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect15);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect16);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect17);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect18);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect19);
    SAFEREMOVEANDFREE_OBJECT(m_ivSelect20);
    
    [super dealloc];
}

@end
