//
//  PMoreViewController.h
//  pass91
//
//  Created by Zhaolin He on 09-9-2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UIProgressHUD;
@interface PMoreViewController : UIViewController<UIWebViewDelegate> {
	//UIProgressHUD *indicator;
}
+(id)sharedMoreController;
-(void)loadPage;
//@property (nonatomic,retain) UIProgressHUD *indicator;
@end
