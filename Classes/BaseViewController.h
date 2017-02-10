//
//  BaseViewController.h
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kThemeDidChangeNotification;

@interface BaseViewController : UIViewController

- (void)updateTheme:(NSNotification*)notify;

@end
