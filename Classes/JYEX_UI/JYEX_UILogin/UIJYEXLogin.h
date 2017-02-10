//
//  UIJYEXLogin.h
//  NoteBook
//
//  Created by cyl on 13-3-22.
//  Copyright (c) 2013年 广州洋基信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussMng.h"


@interface UIJYEXLogin : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet  UITextField  *m_txfCounter ;
    IBOutlet  UITextField  *m_txfPassWord ;
    IBOutlet UIImageView   *m_ivAvatar;
    
    IBOutlet  UIButton     *m_btnLogin ;
    IBOutlet  UIButton     *m_btnCancel ;
    
    IBOutlet UIButton      *m_btnFullScreen;
    
    IBOutlet UIButton      *m_btnDropList;
    IBOutlet UITableView* tblUserList;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray* aryAccountList;
	enum EJYEXAccountListStyle { EJYEXShowAll, EJYEXShowFilter } iListStyle;
	int iTblRowCnt;
    
    BOOL loginOk;
    BOOL bClearPassword;
    BOOL bShowBackButton;
    BOOL bAutoLogin;
    
    BussMng* bussMng; //登录接口
	MsgParam* msgParam;
}
@property (nonatomic, retain) NSMutableArray* aryAccountList;

@property (nonatomic, retain) BussMng* bussMng;//login network
@property (nonatomic, retain) MsgParam* msgParam;


-(IBAction)OnUnLogin:(id)sender ;
-(IBAction)OnLogin:(id)sender ;
//-(IBAction)OnRegister:(id)sender ;
-(IBAction)OnBtnFullScreen:(id)sender ;

- (IBAction)onUserNameEditing: (id)sender;
- (IBAction)onUserNameEditingBegin:(id)sender;
- (IBAction)onUserNameEditingEnd:(id)sender;
- (IBAction)onUserNameChanged:(id)sender;

- (IBAction)onPasswordEditingBegin:(id)sender;
- (IBAction)onPasswordEditingEnd:(id)sender;
- (IBAction)onPasswordChanged:(id)sender;

- (IBAction)onDropUserlist:(id)sender;

- (IBAction)onRegister:(id)sender ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil back:(BOOL)canBack;
-(void)initAccountList;


- (void)updateUIByRegister:(NSDictionary*)dic ;

@end
