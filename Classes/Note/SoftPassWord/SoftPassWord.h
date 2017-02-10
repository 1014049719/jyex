//
//  SoftPassWord.h
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoftPassWord : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *m_txfPassWord ;
    IBOutlet UITextField *m_txfPassWord2;
    IBOutlet UITextField *m_txfCheckPwd;
    IBOutlet UITextField *m_txfPwdPrompt;
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavFinish;
    
    IBOutlet UIView *m_viewClosePwd;
    IBOutlet UIView *m_viewSetPwd;
    IBOutlet UIScrollView *m_scroll;
    BOOL m_bIsPassWord;
    NSString *m_strSoftPwd;
}

- (void)keyboardWillShow:(NSNotification *)note;
-(IBAction)onBack:(id)sender;
-(IBAction)onOK:(id)sender;

-(void)dealloc ;

@end
