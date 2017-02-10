//
//  UIFolderSetting.h
//  NoteBook
//
//  Created by zd on 13-2-21.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubFunction.h"

@interface UIFolderSetting : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *m_btnBack ;
    IBOutlet UIButton *m_btnFinish ;
    IBOutlet UIButton *m_btnFolderIcon ;
    IBOutlet UIButton *m_btnFolderColor;
    IBOutlet UIButton *m_btnLock ;
    IBOutlet UIButton *m_btnTBWJJ ;
    IBOutlet UIButton *m_btnShareManage;
    IBOutlet UITextField *m_txfFolderTitle;
    
    IBOutlet UIImageView *m_viFolderIcon ;
    IBOutlet UIImageView *m_viFolderColor;
    
    NSString  *m_FolderTitle ;
    int m_IconIndex ;
    int m_ColorIndex ;
    BOOL m_Lock ;
    BOOL m_TBWJJ ;
    
@public
    NSString *m_FolderID ;
}

-(void)dealloc ;

-(IBAction)OnBack:(id)sender ;
-(IBAction)OnFinish:(id)sender ;
-(IBAction)OnFolderIcon:(id)sender ;
-(IBAction)OnFolderColor:(id)sender ;
-(IBAction)OnLock:(id)sender ;//密码锁
-(IBAction)OnTBWJJ:(id)sender ;//同步此文件夹
-(IBAction)OnShareManage:(id)sender;//共享管理
-(IBAction)OnBtnFullScreen:(id)sender ;
-(void)setFolderID:(NSString *)FolderID ;
-(void)setFolderIcon:(NSString *)strIndex ;
-(void)setFolderColor:(NSString *)strIndex ;

@end
