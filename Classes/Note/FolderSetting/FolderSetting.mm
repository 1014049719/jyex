//
//  FolderSetting.m
//  NoteBook
//
//  Created by mwt on 12-11-2.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "FolderSetting.h"
#import "PubFunction.h"

@implementation FolderSetting
@synthesize m_lockflag ;
@synthesize m_synflag ;

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
    [self DrawView] ;
    
 // Do any additional setup after loading the view from its nib.
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
    //[m_txfTitle setText:@"返回" ] ;
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
}

-(IBAction)OnFinish:(id)sender
{
    //[m_txfTitle setText:@"完成" ] ;
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
}

-(IBAction)OnICon:(id)sender 
{
    [m_txfTitle setText:@"设置图标" ] ;
}

-(IBAction)OnColor:(id)sender
{
    [m_txfTitle setText:@"设置颜色" ] ;
}

-(IBAction)OnLock:(id)sender
{
    //[pTitle setText:@"密码锁" ] ;
    m_lockflag = !m_lockflag ;
    if( m_lockflag )
    {
       [m_btnLock setImage:[UIImage imageNamed:@"Note_Off.png" ] forState:UIControlStateNormal] ;
    }
    else
    {
       [m_btnLock setImage:[UIImage imageNamed:@"Note_On.png" ] forState:UIControlStateNormal] ; 
    }
    
}

-(IBAction)OnSynFolder:(id)sender
{
    //[pTitle setText:@"同步文件夹" ] ;
    m_synflag = !m_synflag ;
    if( m_synflag )
    {
        [m_btnSyn setImage:[UIImage imageNamed:@"Note_Off.png" ] forState:UIControlStateNormal] ;
    }
    else
    {
        [m_btnSyn setImage:[UIImage imageNamed:@"Note_On.png" ] forState:UIControlStateNormal] ;
    }
}

-(IBAction)OnShare:(id)sender
{
    [m_txfTitle setText:@"编辑共享" ] ;
}

-(void)DrawView
{
    m_synflag = NO ;
    m_lockflag = YES ;
    
    UIImage *returnBk = [UIImage imageNamed:@"btn_TouLanA-2.png"];
    assert( returnBk );
    [self->m_btnBack setBackgroundImage:[returnBk stretchableImageWithLeftCapWidth:20 topCapHeight:5] forState:UIControlStateNormal];
    
    UIImage *finishBk = [UIImage imageNamed:@"btn_TouLanB-2.png"] ;
    assert( finishBk ) ;
    [self->m_btnFinish setBackgroundImage:[finishBk stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];        
}

@end
