//
//  UITest.m
//  NoteBook
//
//  Created by susn on 12-11-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UITest.h"

@implementation UITest
@synthesize delegate;

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

- (void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
    
}

//控件响应函数
- (IBAction) onNavCancel :(id)sender
{
    //[[self parentViewController] dismissViewControllerAnimated completion:nil];  //add 2012.4.15
    //return;
    
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickCancel:)] )
    {
        [self.delegate Drawer_ClickCancel:self];
    }
}

- (IBAction) onNavFinish:(id)sender
{
    /*
    if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickFinish:)] )
    {
        [self.delegate Drawer_ClickFinish:self];
    }*/
    
}

- (IBAction) segmentAction:(id)sender
{
    /*
     if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickFinish:)] )
     {
     [self.delegate Drawer_ClickFinish:self];
     }*/
    
}


@end
