//
//  FolderSetting.h
//  NoteBook
//
//  Created by mwt on 12-11-2.
//  Copyright (c) 2012年 网龙网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderSetting : UIViewController{
    IBOutlet UITextField *m_txfTitle ;
    IBOutlet UIButton *m_btnLock ;
    IBOutlet UIButton *m_btnSyn ;
    IBOutlet UIButton *m_btnBack;
    IBOutlet UIButton *m_btnFinish ;
    IBOutlet UIImageView *m_viColor ;
    
    BOOL m_lockflag ;//密码锁，默认锁定
    BOOL m_synflag ; //同步文件夹，默认不同步
}
@property BOOL m_lockflag ;
@property BOOL m_synflag ;

-(IBAction)OnBack:(id)sender ;
-(IBAction)OnFinish:(id)sender ;
-(IBAction)OnICon:(id)sender ;
-(IBAction)OnColor:(id)sender ;
-(IBAction)OnLock:(id)sender ;
-(IBAction)OnSynFolder:(id)sender ;
-(IBAction)OnShare:(id)sender ;
@end
