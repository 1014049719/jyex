//
//  NoteLogin.h
//  NoteBook
//
//  Created by mwt on 12-11-6.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussMng.h"


@interface NoteLogin : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{    
    IBOutlet  UITextField  *m_txfCounter ;
    IBOutlet  UITextField  *m_txfPassWord ;
    IBOutlet  UIButton     *m_btnRemberPW ;
    IBOutlet  UIButton     *m_btnLogin ;
    IBOutlet  UIButton     *m_btnRegister ;     
    IBOutlet  UIImageView  *m_viCounter ;
    IBOutlet  UIButton     *m_btnCancel ;
    
    IBOutlet UIButton      *m_btnFullScreen;
    
    IBOutlet UIButton      *m_btnDropList;
    IBOutlet UITableView* tblUserList;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray* aryAccountList;
	enum EAccountListStyle { EShowAll, EShowFilter } iListStyle;
	int iTblRowCnt;
    
    BOOL loginOk;
    BOOL bClearPassword;
    
    BussMng* bussMng; //登录接口
	MsgParam* msgParam;
}

@property (nonatomic, retain) NSMutableArray* aryAccountList;

@property (nonatomic, retain) BussMng* bussMng;//login network
@property (nonatomic, retain) MsgParam* msgParam;


-(IBAction)OnRemberPassWord:(id)sender ;
-(IBAction)OnUnLogin:(id)sender ;
-(IBAction)OnLogin:(id)sender ;
-(IBAction)OnRegister:(id)sender ;
-(IBAction)OnBtnFullScreen:(id)sender ;

- (IBAction)onUserNameEditing: (id)sender;
- (IBAction)onUserNameEditingBegin:(id)sender;
- (IBAction)onUserNameEditingEnd:(id)sender;
- (IBAction)onUserNameChanged:(id)sender;

- (IBAction)onPasswordEditingBegin:(id)sender;
- (IBAction)onPasswordEditingEnd:(id)sender;
- (IBAction)onPasswordChanged:(id)sender;

- (IBAction)onDropUserlist:(id)sender;


-(void)initAccountList;
-(void) DrawView ;

-(void)dealloc ;

@end
