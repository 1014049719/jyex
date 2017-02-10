//
//  BaseViewController.m
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "BaseViewController.h"
#import "UIViewController+Background.h"
#import "BussInterImpl.h"
#import "PubFunction.h"
#import "CommonDirectory.h"

#import "DBMng.h"

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        themeManager                    = [ThemeManager sharedThemeManager];
        _dirty = YES;
    }
    return self;
}

- (void)loadView
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateTheme) 
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
	//根据91算命UI样式,修改UI样式：注释掉如下代码 {
	/*

		if (mainTitleLabel) {
		mainTitleLabel.shadowOffset = CGSizeMake(1, 1);
		mainTitleLabel.shadowColor  = [UIColor blackColor];
		mainTitleLabel.textColor    = [themeManager colorWithStyle:@"t_subpage_title"];
		mainTitleLabel.center       = CGPointMake(160, 22);
	}
	if (backButton) {
		UIImage     *image                 = [UIImage imageNamed: @"btn_comm_01_normal.png"];
		image                              = [image stretchableImageWithLeftCapWidth:11 topCapHeight:11];
		backButton.frame                   = CGRectMake(6, 7, 60, 30);
		backButton.titleLabel.shadowOffset = CGSizeMake(1, 1);	

		[backButton  setImage:nil forState:UIControlStateNormal];
		[backButton  setImage:nil forState:UIControlStateHighlighted];
		[backButton setBackgroundImage: image forState:UIControlStateNormal];
		[backButton  setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		[backButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[backButton setTitle:@"     返回" forState:UIControlStateNormal];
		[backButton setTitle:@"     返回" forState:UIControlStateHighlighted];
		backButton.imageView.image = nil;
		
		UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_return_01.png"]];
		backImageView.frame = CGRectMake(11, 13, 17, 17);
		[self.view addSubview: backImageView];
		[backImageView release];		
	}
	if (rightButton) {
		UIImage      *image                 = [UIImage imageNamed: @"btn_comm_01_normal.png"];
		image                               = [image stretchableImageWithLeftCapWidth:11 topCapHeight:11];
		rightButton.frame                   = CGRectMake(254, 7, 60, 30);
		rightButton.titleLabel.shadowOffset = CGSizeMake(1, 1);	
		[rightButton setBackgroundImage: image forState:UIControlStateNormal];
		[rightButton  setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		[rightButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}

	 */
	//}
	
    [self updateTheme];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _appear = YES;
    if ([self isDirty] == YES)
    {
        [self updateTheme];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _appear = NO;
}

- (UIImage *)backgroundImage{
	UIImage *img = [themeManager imageWithStyle:@"backgroundImage"];
	if (!img) {
		NSString *imgName = [AstroDBMng getSkinImage];
		if ([imgName isEqualToString:@"userbk.jpg"])
		{
			NSString* userDir = [NSString stringWithFormat:@"%@/%@", [BussInterImplBase getQueryBaseURL], imgName];
			if ([CommonFunc isFileExisted:userDir]){
				return [UIImage imageWithContentsOfFile: userDir];
			}
			else {
				//根据91算命UI样式,修改UI样式. {
				//old:
//				return [UIImage imageNamed: @"001.jpg"];
				
				//new:
				return [UIImage imageNamed: @"main_bk.jpg"];
				//}
			}
			
		}
		return [UIImage imageNamed:imgName];
	}
    return img;
	
}

- (UIImage *)overImage{
	UIImage *img = [themeManager imageWithStyle:@"overImage"];
    return img;
}

- (UIImage *)splitImage{
	UIImage *img = [themeManager imageWithStyle:@"splitImage"];
    return img;
}

-(UIImage*)mainImage {
	return nil;
}

-(UIImage*)imageTop {
	return [UIImage imageNamed: @"linesplit1.png"];
}

- (void)updateTheme {
    _dirty = NO;
    [self setBackgroundImage:[self backgroundImage]
                   imageOver:[self overImage]
				  imageSplit:[self splitImage]
				   imageMain:[self mainImage]
					imageTop:[self imageTop]];
}

- (void)updateTheme:(NSNotification *)notify
{
    if ([self isAppear] == NO)
    {
        _dirty = YES;
        return;
    }
    [self updateTheme];
}

- (BOOL)isDirty {
    return _dirty == YES;
}

- (BOOL)isAppear {
    return _appear == YES;
}

@end
