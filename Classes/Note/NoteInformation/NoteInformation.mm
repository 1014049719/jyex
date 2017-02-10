//
//  NoteInformation.m
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//
#import "NoteInformation.h"
#import "PubFunction.h"
#import "UIImage+Scale.h"
#import "Global.h"
#import "GlobalVar.h"
#import "Common.h"



@implementation NoteInformation

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnTitle);
    SAFEREMOVEANDFREE_OBJECT(m_btnStart1);
    SAFEREMOVEANDFREE_OBJECT(m_btnStart2);
    SAFEREMOVEANDFREE_OBJECT(m_btnStart3);
    SAFEREMOVEANDFREE_OBJECT(m_btnStart4);
    SAFEREMOVEANDFREE_OBJECT(m_lbFolder);
    SAFEREMOVEANDFREE_OBJECT(m_lbLabel);
    SAFEREMOVEANDFREE_OBJECT(m_lbCreateTime);
    SAFEREMOVEANDFREE_OBJECT(m_lbUpdateTime);
    SAFEREMOVEANDFREE_OBJECT(m_lbLYWZ);
    //SAFEFREE_OBJECT(self->m_strNoteGuid);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NoteGuid:(TNoteInfo*)NoteInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    // Custom initialization
        if ( NoteInfo ) {
            self->m_NoteInfo = NoteInfo;
            self->m_iStar = self->m_NoteInfo.nStarLevel;
            self->m_strNoteGuid = [self->m_NoteInfo.strNoteIdGuid copy];
        }
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
    [self DrawView] ;
    [self ShowNoteInfo];
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

-(void)InitStartStatus
{
    m_StartStatus[0] = YES ;
    m_StartStatus[1] = NO ;
    m_StartStatus[2] = NO ;
    m_StartStatus[3] = NO ;
    m_StartStatus[4] = NO ;
    m_StartSelectIndex = 0 ;
    
}

-(void)ShowStart
{
    UIImage *image1 = [UIImage imageNamed:@"Star_Select@2x.png"] ;
    UIImage *image2 = [UIImage imageNamed:@"Star_Nor@2x.png"] ;
    
    if(m_StartStatus[0]==YES)
    {
        [self->m_btnStart1 setImage:image1 forState:UIControlStateNormal] ;
    }
    else
    {
        [self->m_btnStart1 setImage:image2 forState:UIControlStateNormal] ;
    }
    if(m_StartStatus[1]==YES)
    {
        [self->m_btnStart2 setImage:image1 forState:UIControlStateNormal] ;
    }
    else
    {
        [self->m_btnStart2 setImage:image2 forState:UIControlStateNormal] ;
    }
    if(m_StartStatus[2]==YES)
    {
        [self->m_btnStart3 setImage:image1 forState:UIControlStateNormal] ;
    }
    else
    {
        [self->m_btnStart3 setImage:image2 forState:UIControlStateNormal] ;
    }
    if(m_StartStatus[3]==YES)
    {
        [self->m_btnStart4 setImage:image1 forState:UIControlStateNormal] ;
    }
    else
    {
        [self->m_btnStart4 setImage:image2 forState:UIControlStateNormal] ;
    }
    if(m_StartStatus[4]==YES)
    {
        [self->m_btnStart5 setImage:image1 forState:UIControlStateNormal] ;
    }
    else
    {
        [self->m_btnStart5 setImage:image2 forState:UIControlStateNormal] ;
    }
    
}

-(IBAction)OnTitle:(id)sender
{
    //头栏Note标题
    NSDictionary *dictionary = nil;
    NSArray *keys = nil;
    NSArray *objects = nil;
    keys = [NSArray arrayWithObjects:@"note_guid", @"note_star", nil];
    objects =  [NSArray arrayWithObjects:self->m_strNoteGuid, 
					[NSNumber  numberWithInt:self->m_iStar],
					nil];
     
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE_STAR object:nil userInfo:dictionary];

    
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnStart1:(id)sender
{
    m_StartSelectIndex = 0 ;
    m_StartStatus[0] = !m_StartStatus[0];
    if( m_StartStatus[0] == NO )
    { 
        self->m_iStar = 0;
    }
    else
    {
        self->m_iStar = 1;
    }
    m_StartStatus[1] = NO ;
    m_StartStatus[2] = NO ;
    m_StartStatus[3] = NO ;
    m_StartStatus[4] = NO ;
    [self ShowStart];
    //[self ChangeStartLevel];
    
}

-(IBAction)OnStart2:(id)sender
{
    m_StartSelectIndex = 1 ;
    m_StartStatus[1] = !m_StartStatus[1];
    if( m_StartStatus[1] == NO )
    { 
        self->m_iStar = 1;
    }
    else
    {
        self->m_iStar = 2;
    }
    m_StartStatus[0] = YES ;
    m_StartStatus[2] = NO ;
    m_StartStatus[3] = NO ;
    m_StartStatus[4] = NO ;
    [self ShowStart];
    //[self ChangeStartLevel];
}

-(IBAction)OnStart3:(id)sender
{
    m_StartSelectIndex = 2 ;
    m_StartStatus[2] = !m_StartStatus[2];
    if( m_StartStatus[2] == NO )
    { 
        self->m_iStar = 2;
    }
    else
    {
        self->m_iStar = 3;
    }
    m_StartStatus[0] = YES ;
    m_StartStatus[1] = YES ;
    m_StartStatus[3] = NO ;
    m_StartStatus[4] = NO ;
    [self ShowStart];
    //[self ChangeStartLevel];
}

-(IBAction)OnStart4:(id)sender
{
    m_StartSelectIndex = 3 ;
    m_StartStatus[3] = !m_StartStatus[3];
    if( m_StartStatus[3] == NO )
    {
        self->m_iStar = 3;
    }
    else
    {
        self->m_iStar = 4;
    }
    m_StartStatus[0] = YES ;
    m_StartStatus[1] = YES ;
    m_StartStatus[2] = YES ;
    m_StartStatus[4] = NO ;
    [self ShowStart];
    //[self ChangeStartLevel];
}

-(IBAction)OnStart5:(id)sender
{
    m_StartSelectIndex = 4 ;
    m_StartStatus[4] = !m_StartStatus[4];
    if( m_StartStatus[4] == NO )
    { 
        self->m_iStar = 4;
    }
    else
    {
        self->m_iStar = 5;
    }
    m_StartStatus[0] = YES ;
    m_StartStatus[1] = YES ;
    m_StartStatus[2] = YES ;
    m_StartStatus[3] = YES ;
    [self ShowStart];
    //[self ChangeStartLevel];
}

-(IBAction)OnFolder:(id)sender
{
    
}

-(IBAction)OnLabel:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMNoteLabel :0 :1 :nil];
}


-(IBAction)OnLYWZ:(id)sender
{
    
}


-(void)DrawView
{
    UIImage *TitleBk = [UIImage imageNamed:@"btn_TouLanA-2.png"];
    assert( TitleBk );
    [self->m_btnTitle setBackgroundImage:[TitleBk stretchableImageWithLeftCapWidth:20 topCapHeight:5] forState:UIControlStateNormal];
    
    UIImage *imgFirst = [UIImage imageNamed:@"BiaoGeKuang2.png"];
    UIImage *imgEnd = [UIImage imageNamed:@"BiaoGeKuang3.png"];
    UIImage *imgInter = [UIImage imageNamed:@"BiaoGeKuang1.png"];
    
    
    [m_btnFolder setBackgroundImage:[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFolder setBackgroundImage:[[imgFirst stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    [m_btnlable setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnlable setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];

    
    [m_btnLYWZ setBackgroundImage:[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnLYWZ setBackgroundImage:[[imgEnd stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnTitle.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnTitle.frame = rect;
    [self->m_btnTitle setTitle:strNavTitle forState:UIControlStateNormal];
    

}

-(void)ShowNoteInfo
{
    if(self->m_NoteInfo == nil) return ;
    
    m_lbCreateTime.text = self->m_NoteInfo.tHead.strCreateTime;
    m_lbUpdateTime.text = self->m_NoteInfo.tHead.strModTime;
    [m_btnTitle setTitle:self->m_NoteInfo.strNoteTitle forState:UIControlStateNormal];
    m_lbLYWZ.text = self->m_NoteInfo.strNoteSrc;
    for(int i = 0; i < 5; i++ )
    {
      if( i <= (self->m_iStar - 1) )
      { m_StartStatus[i] = YES ; }
      else
      { m_StartStatus[i] = NO ; }
    }
    [self ShowStart];
}

//-(void)ChangeStartLevel
//{
//    TNoteInfo *NoteInfo = nil ;
//    NoteInfo = [Global getEditNoteInfo];
//    int count = 0 ;
//    if( NoteInfo != nil )
//    {
//        for( int i = 0; i <5; i++ )
//        {
//            if( m_StartStatus[i] == YES)
//            {
//                count++;
//            }
//        }
//        NoteInfo.nStarLevel = count ;
//    }
//    
//}

-(IBAction)OnOpenSourceURL:(id)sender
{
    //m_lbLYWZ
    NSString *strURL = nil ;
    NSString *strTemp = nil ;
    
    if( [m_lbLYWZ.text isEqualToString:@""]) return ;
    if( m_lbLYWZ.text.length < 5 ) return ;
    
    strURL = [[[NSString alloc]initWithString: m_lbLYWZ.text] autorelease] ;
    
    strTemp = [strURL substringToIndex: 4];
    
    if([strTemp isEqualToString:@"http"])
    {
       [PubFunction SendMessageToViewCenter:NMWebView :0 :1 :[MsgParam param:nil :nil :strURL :0]];
    }
    
    strURL = nil;
}

@end

