//
//  pass91AppDelegate.h
//  pass91
//
//  Created by Qiliang Shen on 09-8-4.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol P91PassDelegate;
@interface pass91App : NSObject{
	UINavigationController *navigationController;
	id<P91PassDelegate> delegate;
	RootViewController *loginCtr;
}
- (void)gotoLoginPage;
- (id)initWithNavigationController:(UINavigationController*)ngController target:(id)delegate;
@property (nonatomic, retain) UINavigationController *navigationController;
@property(nonatomic,assign)id<P91PassDelegate> delegate;
@property (nonatomic,retain) RootViewController *loginCtr;
@end

