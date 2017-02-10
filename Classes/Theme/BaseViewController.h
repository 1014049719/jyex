//
//  BaseViewController.h
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface BaseViewController : UIViewController
{
	ThemeManager *themeManager;
	IBOutlet UILabel *mainTitleLabel, *subTitleLabel;
	IBOutlet UIButton *backButton, *rightButton;
    
    // 是否需要刷新主题
    BOOL _dirty;
    
    // 是否显示
    BOOL _appear;
}

- (void)updateTheme:(NSNotification*)notify;
- (void)updateTheme;

// 是否需要刷新主题
- (BOOL)isDirty;

// 是否可见
- (BOOL)isAppear;

@end
