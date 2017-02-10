/*
 *  ProtocolViewController.h
 *  NoteBook
 *
 *  Created by Huang Yan on 9/23/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPHubView.h"

@interface ProtocolViewController : UIViewController <UIWebViewDelegate>
{
	PPHubView *hub;
}

@end