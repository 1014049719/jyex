//
//  PSettingViewController.h
//  pass91
//
//  Created by Zhaolin He on 09-8-5.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol P91PassDelegate;
@interface PSettingViewController : UIViewController<UITabBarControllerDelegate> {
	UITabBarController *tabBar;
	id<P91PassDelegate> delegate;
}
+(id)sharedSettingController;
-(void)createRightBarButtonWithTarget:(id)target;
-(void)removeRightBarButton;
@property (nonatomic,assign) id<P91PassDelegate> delegate;
@end
