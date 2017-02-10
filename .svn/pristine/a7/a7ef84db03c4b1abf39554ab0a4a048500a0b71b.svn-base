//
//  UIPictureZLVC.m
//  JYEX
//
//  Created by zd on 14-4-14.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import "UIPictureZLVC.h"

@interface UIPictureZLVC ()

@end

@implementation UIPictureZLVC
@synthesize callbackObject ;
@synthesize callbackSEL ;
@synthesize curPictureZL ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->callbackObject = nil ;
        self->callbackSEL = nil ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch( self.curPictureZL )
    {
        case 0:
            viL.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
            break ;
        case 1:
            viM.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
            break ;
        case 2:
            viH.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
            break ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)onPictureZLL:(id)sender
{
    if( self.callbackObject != nil && self.callbackSEL != nil )
    {
        if( [self.callbackObject respondsToSelector:self.callbackSEL] )
        {
            [callbackObject performSelector:self.callbackSEL withObject:[NSNumber numberWithInt:0]] ;
            viL.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
            viM.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
            viH.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)onPictureZLM:(id)sender
{
    if( self.callbackObject != nil && self.callbackSEL != nil )
    {
        if( [self.callbackObject respondsToSelector:self.callbackSEL] )
        {
            [callbackObject performSelector:self.callbackSEL withObject:[NSNumber numberWithInt:1]] ;
            viL.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
            viM.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
            viH.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)onPictureZLH:(id)sender
{
    if( self.callbackObject != nil && self.callbackSEL != nil )
    {
        if( [self.callbackObject respondsToSelector:self.callbackSEL] )
        {
            [callbackObject performSelector:self.callbackSEL withObject:[NSNumber numberWithInt:2]] ;
            viL.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
            viM.image = [UIImage imageNamed:@"GouXuan-1.png"] ;
            viH.image = [UIImage imageNamed:@"GouXuan-2.png"] ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES] ;
}


@end
