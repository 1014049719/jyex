//
//  JUEX_UISetting.h
//  JYEX
//
//  Created by cyl on 13-6-2.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BussMng.h"


@interface JUEX_UISetting : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    IBOutlet UIButton *m_btnBack;
    IBOutlet UILabel *m_lUserName;
    IBOutlet UILabel *m_lNickName;
    IBOutlet UIImageView *m_ivAvatar;
    IBOutlet UILabel *m_lVersion;
    IBOutlet UILabel *m_lNetType;
    IBOutlet UIButton *m_btnLogin;
    IBOutlet UILabel *m_lbCacheSize ;
    IBOutlet UIScrollView *m_scrollview;
    
    IBOutlet UIView *m_viCenter;
    IBOutlet UIView *m_viUpdateMM;
    
    BussMng* bussUpdataSoft;
}

@property (nonatomic,retain) BussMng* bussUpdataSoft;

-(IBAction)onLogin:(id)sender;
-(IBAction)OnBack:(id)sender;
-(IBAction)OnCheckVer:(id)sender;
-(IBAction)onClearCache:(id)sender ;
-(IBAction)onWebInfo:(id)sender;
-(IBAction)onUpdatePassword:(id)sender;

- ( long long )getCacheSize ;

- (void)setCacheSizeTitle ;

@end
