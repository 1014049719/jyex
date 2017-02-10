//
//  UIJYEXUpdatePassword.m
//  JYEX
//
//  Created by lzd on 14-6-11.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import "UIJYEXUpdatePassword.h"
#import "PubFunction.h"
#import "UIAstroAlert.h"
#import "CommonAll.h"
#import "Global.h"
#import "GlobalVar.h"

@interface UIJYEXUpdatePassword ()

@end

@implementation UIJYEXUpdatePassword
@synthesize bussRequest;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{
    [self.bussRequest cancelBussRequest];
    self.bussRequest = nil;
    
    SAFEREMOVEANDFREE_OBJECT(m_btnDo);
    SAFEREMOVEANDFREE_OBJECT(m_tfOld);
    SAFEREMOVEANDFREE_OBJECT(m_tf1);
    SAFEREMOVEANDFREE_OBJECT(m_tf2);
    SAFEREMOVEANDFREE_OBJECT(m_scrollview);
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    m_tf2.delegate = self;
    m_scrollview.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    CGSize size = m_scrollview.frame.size;
    size.height += 20;
    m_scrollview.contentSize = size;
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onFinish:(id)sender
{

    if ( [m_tf1.text isEqualToString:@""] ){
        MESSAGEBOX(@"请您输入新密码，新密码不能为空！");
        return;
    }
    
    if ( [m_tf2.text isEqualToString:@""] ){
        MESSAGEBOX(@"请您输入确认密码，确认密码不能为空！");
        return;
    }
    
    if ( [m_tfOld.text isEqualToString:@""] ){
        MESSAGEBOX(@"请您输入旧密码，旧密码不能为空！");
        return;
    }
    
    
    if ( ![m_tf1.text isEqualToString:m_tf2.text] ) {
        MESSAGEBOX(@"新密码和确认密码不一致，请重新输入！");
        return;
    }
    
    //调用修改用户资料接口
    NSDictionary *dic = @{@"uid": TheCurUser.sUserID,@"username": TheCurUser.sUserName,
                           @"oldpassword":m_tfOld.text,@"newpassword":m_tf1.text,
                           @"nickname":@"",@"realname":@"",@"email":@"",@"mobile":@""};
    
    
    [self UpdateUserInfo:dic];
    
}



-(IBAction)OnBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ( !m_btnDo.enabled )
        m_btnDo.enabled = YES;
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    m_btnDo.enabled = NO;
    return YES;
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}



#pragma mark -
#pragma mark 网络接口


//注册
-(void)UpdateUserInfo:(NSDictionary *)dic
{
    [UIAstroAlert info:@"正在处理，请稍候" :0 :YES :0 :0];
    
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXUpdateUserInfo];
    
    [bussRequest request:self :@selector(syncCallback_UpdateUserInfo:) :dic];
    return;
}

//注册回调
- (void)syncCallback_UpdateUserInfo:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
    
    [UIAstroAlert infoCancel];
	
	if ( sts.iCode != 200) //成功
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:update user info");
        return;
	}
    
    NSDictionary *dict =(NSDictionary *)(sts.rtnData);
    NSLog(@"%@",dict);
    
    int res = pickJsonIntValue(dict, @"result");
    NSString *msg = pickJsonStrValue(dict, @"message");
    if ( !msg ) msg = @"";
    int uid = pickJsonIntValue(dict, @"uid");
    
    NSLog(@"res=%d msg=%@ uid=%d",res,msg,uid);
    
    if ( res ) { //成功
        //[UIAstroAlert info:@"修改密码成功!" :2.0 :NO :LOC_MID :NO];
        
        //[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
        
        MESSAGEBOX(@"修改密码成功!");
        [self.navigationController popViewControllerAnimated:YES]  ;
        
        
        
        
    }
    else {
        if (!msg || [msg isEqualToString:@""]) msg = @"修改密码失败";
        MESSAGEBOX(msg);
    }
}


@end
