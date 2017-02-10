//
//  SoftPassWord.m
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "BizLogic_Login.h"
#import "CfgMgr.h"
#import "UIAstroAlert.h"
#import "SoftPassWord.h"

@implementation SoftPassWord

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    BOOL b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"SoftPwd" value:self->m_strSoftPwd];
    if ( !b || !(self->m_strSoftPwd) || self->m_strSoftPwd.length == 0 ) {
        self->m_bIsPassWord = NO;
        self->m_viewClosePwd.hidden = YES;
        self->m_viewSetPwd.hidden = NO;
        self->m_txfPassWord2.delegate = self;
        self->m_txfCheckPwd.delegate = self;
        [self->m_txfPassWord2 becomeFirstResponder];
    }
    else
    {
        self->m_bIsPassWord = YES;
        self->m_viewClosePwd.hidden = NO;
        self->m_viewSetPwd.hidden = YES;
        [self->m_txfPassWord becomeFirstResponder];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)note {
    if ( !self->m_bIsPassWord ) {
        //键盘的高度不同，工具栏也要调整位置
        NSDictionary *info = [note userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        //CGSize keyboardSize = [value CGRectValue].size;
        CGRect keyboardframe = [value CGRectValue];
        NSLog(@"keyboard frame:[%f,%f][%f,%f]",keyboardframe.origin.x
              ,keyboardframe.origin.y
              ,keyboardframe.size.width
              ,keyboardframe.size.height);
        CGSize s = CGSizeMake(self->m_viewSetPwd.frame.size.width
                              , self->m_viewSetPwd.frame.size.height + keyboardframe.size.height);
        [self->m_scroll setContentSize:s];
    }
}

#pragma mark - 按钮响应函数
-(IBAction)onBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
    if ( self->m_bIsPassWord ) {
        [self->m_txfPassWord resignFirstResponder];
    }
    else
    {
        [self->m_txfPassWord2 resignFirstResponder];
        [self->m_txfCheckPwd resignFirstResponder];
        [self->m_txfPwdPrompt resignFirstResponder];
    }
}

-(IBAction)onOK:(id)sender
{
    if ( self->m_bIsPassWord ) {
        [self->m_txfPassWord resignFirstResponder];
        NSString *psw = self->m_txfPassWord.text;
        NSString *save = [NSString stringWithFormat:@""];
        [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"SoftPwd" value:self->m_strSoftPwd];
        //int ii = [self->m_strSoftPwd retainCount];
        //NSLog(@"self->m_strSoftPwd:%d\r\n", ii);
        if ( [psw isEqualToString:self->m_strSoftPwd] ) {
            [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"SoftPwd" value:save];
            [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
        }
        else
        {
            [UIAstroAlert info:@"密码错误!" :2.0 :NO :LOC_MID :NO];
            return;
        }
    }
    else
    {
        [self->m_txfPassWord2 resignFirstResponder];
        [self->m_txfCheckPwd resignFirstResponder];
        [self->m_txfPwdPrompt resignFirstResponder];
        NSString *strPsw = self->m_txfPassWord2.text;
        if ( !strPsw || strPsw.length == 0 ) {
            [UIAstroAlert info:@"请输入密码!" :2.0 :NO :LOC_MID :NO];
            return;
        }
        else if( strPsw.length != 4 )
        {
            [UIAstroAlert info:@"密码的长度是四位，请确认!" :2.0 :NO :LOC_MID :NO];
            return;
        }
        NSString *strCheck = self->m_txfCheckPwd.text;
        if ( !strCheck || ![strPsw isEqualToString:strCheck] ) {
            [UIAstroAlert info:@"两次输入的密码不同，请重输!" :2.0 :NO :LOC_MID :NO];
            return;
        }
        NSString *strPrompt = self->m_txfPwdPrompt.text;
        if( !strPrompt || strPrompt.length == 0 )
        {
            [UIAstroAlert info:@"密码提示不能为空!" :2.0 :NO :LOC_MID :NO];
            return;
        }
        [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"SoftPwd" value:strPsw];
        [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"SoftPwdPrompt" value:strPrompt];
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self onOK:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( textField == self->m_txfPassWord2
       || textField == self->m_txfCheckPwd )
    {
        NSString *strPwd = textField.text;
        if ( string && string.length > 0
            && range.length == 0
            && (range.location >= 4 || ( strPwd && strPwd.length >= 4 )))
            return NO; // return NO to not change text
    }
    return YES;
}

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_txfPassWord) ;
    SAFEREMOVEANDFREE_OBJECT(m_txfPassWord2) ;
    SAFEREMOVEANDFREE_OBJECT(m_txfCheckPwd) ;
    SAFEREMOVEANDFREE_OBJECT(m_txfPwdPrompt) ;
    
    SAFEREMOVEANDFREE_OBJECT(m_viewClosePwd) ;
    SAFEREMOVEANDFREE_OBJECT(m_viewSetPwd) ;
    SAFEREMOVEANDFREE_OBJECT(m_scroll) ;
    
    [super dealloc];
}

@end
