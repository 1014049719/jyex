//
//  AstroAppDelegate.h
//  Weather
//
//  Created by nd on 11-5-24.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "BussInterImpl.h"
#import "BussMng.h"

#import "Reachability.h"

//#import "UMTableViewDemo.h"



//#import "UIAd.h"

//友盟统计SDK
#import "MobClick.h"

@interface AstroAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate,MobClickDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet UIImageView *imgView;
	
	UINavigationController   *nav;
	BussCheckVersion* bussCheckVer;
	BussMng* bussMng; //自动登录接口
    BussMng* bussUpdataSoft; //自动登录接口
    NSTimer *autoUpdataNoteTimer;
    
    Reachability* reach;
    
    
	int curPage;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *nav;
@property (retain) BussCheckVersion* bussCheckVer;
@property (nonatomic, retain) BussMng* bussMng;
@property (nonatomic, retain) BussMng* bussUpdataSoft;
//- (BOOL) isNavHidden;
//- (void) doNavPage: (id) sender;

#pragma mark -
#pragma mark 有关版本检测
-(void) checkUpgradeTip;
-(void) checkNewVerThread;
//-(void) onCheckVersionCallBack:(id)arg;
//-(void) showNewVerPrompt:(id)param;
//-(void) proAutoUpdataNote:(id)appDelegate;
-(void) AutoUpdataNote;
-(void) jyexSoftUpdata:(TBussStatus*)sts;
-(void) showSoftUpdata;
@end

