//
//  SetFolderPassWord.m
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 网龙网络有限公司. All rights reserved.
//

#import "SetFolderPassWord.h"

@implementation SetFolderPassWord

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
    [self DrawView] ;
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

-(void) DrawView
{
    
    UIImage *finishBk = [UIImage imageNamed:@"btn_TouLanB-1.png"] ;
    assert( finishBk ) ;
    [self->m_btnFinish setBackgroundImage:[finishBk stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal]; 
}

-(IBAction)OnFinish:(id)sender
{
    //完成按钮
}

@end
