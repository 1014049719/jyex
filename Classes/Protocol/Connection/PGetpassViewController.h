//
//  PGetpassViewController.h
//  pass91
//
//  Created by Zhaolin He on 09-8-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol P91PassDelegate;
@interface PGetpassViewController : UITableViewController<UITextFieldDelegate> {
	UITextField *realName;
	UITextField *idCard;
	id<P91PassDelegate> delegate;
}
-(void)hideKeyBoard;
@property (nonatomic,retain) UITextField *realName;
@property (nonatomic,retain) UITextField *idCard;
@property (nonatomic,assign) id<P91PassDelegate> delegate;
@end
