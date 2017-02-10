//
//  BaseViewController.m
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
//#import "UIViewController+Background.h"
//#import "Business.h"

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateTheme:) 
                                                 name:kThemeDidChangeNotification 
                                               object:nil];
    [super loadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTheme:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [super dealloc];
}

- (UIImage *)backgroundImage{
	return nil;
//    NSString *imgName = [[Bussiness getInstance]getSkinImage];
//    if ([imgName isEqual:@"userbk.jpg"])
//	{
//		NSString* userDir = [NSString stringWithFormat:@"%@/%@", [BusinessPubFunction getBaseDir], imgName];
//		if ([PubFunction isFileExisted:userDir]){
//            return [UIImage imageWithContentsOfFile: userDir];
//        }
//		else {
//            return [UIImage imageNamed: @"001.jpg"];
//		}
//        
//	}
//	else
//        return [UIImage imageNamed:imgName];
}

- (UIImage *)overImage{
    return [UIImage imageNamed:@"over.png"];
}

- (UIImage *)splitImage{
    return [UIImage imageNamed:@"linesplit2.png"];
}

- (void)updateTheme:(NSNotification*)notify
{
   // [self setBackgroundImage:[self backgroundImage]
//                   imageOver:[self overImage]
//                  imageSplit:[self splitImage]];
}

@end
