//
//  PSettingController.h
//  pass91
//
//  Created by Zhaolin He on 09-8-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVersionViewController.h"

@interface PSystemParamController : UITableViewController {
	UISwitch *isPassKeeped;
	UISwitch *isLoginKeeped;
}
@property (nonatomic,retain) UISwitch *isPassKeeped;
@property (nonatomic,retain) UISwitch *isLoginKeeped;
@end
