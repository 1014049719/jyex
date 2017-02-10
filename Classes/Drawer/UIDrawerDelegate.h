//
//  UIDrawerDelegate.h
//  note iphone
//
//  Created by shenqiliang on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIDrawer;
@protocol UIDrawerDelegate

-(void) Drawer_ClickCancel:(UIDrawer *)drawerCtl;
-(void) Drawer_ClickFinish:(UIDrawer *)drawerCtl;

@end
