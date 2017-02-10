//
//  UIFolderManage.m
//  NoteBook
//
//  Created by zd on 13-2-20.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "UIFolderManage.h"
#import "PubFunction.h"
#import "MessageConst.h"
#import  "DBMngAll.h"
#import "BizLogicAll.h"
#import "BizLogic.h"
#import "Global.h"

@implementation UIFolderManage


-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_FolderList);
    SAFEREMOVEANDFREE_OBJECT(m_viFolderScrollView);
    SAFEFREE_OBJECT(m_ParentFolderID);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         [[NSNotificationCenter defaultCenter] \
         addObserver:self selector:@selector(reRoadFolderList) \
         name:NOTIFICATION_UPDATE_NOTE object:nil];
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
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    [self drawFolderList];
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
  [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnNewFolder:(id)sender
{
    [_GLOBAL setParentFolderID:self->m_ParentFolderID];
    [PubFunction SendMessageToViewCenter:NMNewFolder :0 :1 :nil];
}

-(IBAction)OnPXFolder:(id)sender
{
   [PubFunction SendMessageToViewCenter:NMFolderPaiXu :0 :1 :nil];
}

-(void)drawFolderList
{
    if (self->m_FolderList) {
        [self->m_FolderList removeFromSuperview];
        [self->m_FolderList release];
        self->m_FolderList = nil;
    }
    self->m_FolderList = [[UIFolderList2 alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //[self->m_FolderList drawFolderList];
    [self->m_FolderList drawFolderListWithGUID:m_ParentFolderID];
    [self->m_viFolderScrollView addSubview:self->m_FolderList];
    [self->m_viFolderScrollView setContentSize:self->m_FolderList.frame.size];
}

-(void)setParentFolderID:(NSString*)FolderID
{
    self->m_ParentFolderID = [[NSString alloc]initWithString:FolderID];
}

- (void) reRoadFolderList
{
    [self drawFolderList];
}

@end
