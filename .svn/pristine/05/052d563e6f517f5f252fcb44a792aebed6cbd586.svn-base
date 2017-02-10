//
//  PRegisterViewController.h
//  pass91
//
//  Created by Zhaolin He on 09-8-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UIProgressHUD;
@protocol P91PassDelegate;
@interface PRegisterViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate> {
	UITextField *username;
	UITextField *password;
	UITextField *submit_pass;
	
	UITextField *realName;
	UITextField *id_number;
	UITextField *phone_number;
	
	id<P91PassDelegate> delegate;
	
	//UIProgressHUD *indicator;
	BOOL isTick;
}
+(id)sharedRegister;
-(void)send_regist;
-(void)hideKeyBoard;
@property (nonatomic,retain) UITextField *username;
@property (nonatomic,retain) UITextField *password;
@property (nonatomic,retain) UITextField *submit_pass;

@property (nonatomic,retain) UITextField *realName;
@property (nonatomic,retain) UITextField *id_number;
@property (nonatomic,retain) UITextField *phone_number;

//@property (nonatomic,retain) UIProgressHUD *indicator;

@property (nonatomic,assign) id<P91PassDelegate> delegate;
@end
