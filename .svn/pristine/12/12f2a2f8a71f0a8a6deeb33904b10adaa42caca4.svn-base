//
//  UISetting.h
//  Weather
//
//  Created by nd on 11-6-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StatusBarWindow : UIWindow {
	UIImageView *iconImage;
	UILabel *textLabel;
	NSUInteger clickCount;
}

@property (nonatomic, assign) UIImageView *iconImage;
@property (nonatomic, assign) UILabel *textLabel;
@property (nonatomic) NSUInteger clickCount;

+ (StatusBarWindow *)newStatusBarWindow;

-(void)dispStatusBar;
-(void)hideStatusBar;

-(void)dispStatusBar:(NSString *)strText;
-(void)dispStatusBar:(NSString *)strText timeout:(NSInteger)timeout;

@end

