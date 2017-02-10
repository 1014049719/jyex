//
//  RootViewController.h
//  pass91
//
//  Created by Zhaolin He on 09-8-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPHubView;
//@class UIProgressHUD;
@class LbsServer;
@protocol P91PassDelegate;
@interface RootViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
@private
	UITextField *userName;
	UITextField *password;
	
	LbsServer *server;
	NSOperationQueue *opQueue;
	UITableView *mTableView;

	
	UIBarButtonItem *mSetItem;

	BOOL bLoginWithoutInterface;
	BOOL bShowLoginTip;
@public
	PPHubView *indicator;
	UIBarButtonItem *bbi;
	id<P91PassDelegate> delegate;

	NSString *mBtnLeftTitle;
	NSString *mBtnRightTitle;
	
	NSString *mAlertViewParameter;
}
+(id)sharedView;
+(id)clearView;
-(void)stopWaiting;

-(void)showWaitIcon:(NSString *)strHit;

-(BOOL)reConnect:(NSString *)strHit;

@property(nonatomic,assign)id<P91PassDelegate> delegate;

@property(nonatomic,retain) UIBarButtonItem *mSetItem;

@property (nonatomic,retain) PPHubView *indicator;
@property (nonatomic,retain) UIBarButtonItem * bbi;

@property (nonatomic,retain) NSString *mBtnLeftTitle;
@property (nonatomic,retain) NSString *mBtnRightTitle;

@end
