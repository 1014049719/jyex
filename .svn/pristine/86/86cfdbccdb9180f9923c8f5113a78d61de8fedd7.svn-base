//
//  UIRegisterVC.m
//  JYEX
//
//  Created by zd on 14-4-25.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import "UIRegisterVC.h"
#import "PubFunction.h"
#import "UIAstroAlert.h"
#import "CommonAll.h"
#import "PubFunction.h"


@interface UIRegisterVC ()

@end

@implementation UIRegisterVC
@synthesize callBackObject ;
@synthesize callBackSEL ;
@synthesize bussRequest;

- (void)dealloc
{
    [self.bussRequest cancelBussRequest];
    self.bussRequest = nil;
    
    SAFEREMOVEANDFREE_OBJECT( txfPhoneNumber ) ;
    SAFEREMOVEANDFREE_OBJECT( txfName ) ;
    SAFEREMOVEANDFREE_OBJECT( txfNC ) ;
    SAFEREMOVEANDFREE_OBJECT( txfPassWord1 ) ;
    SAFEREMOVEANDFREE_OBJECT( txfPassWord2 ) ;
    SAFEREMOVEANDFREE_OBJECT( txfMail ) ;
    SAFEREMOVEANDFREE_OBJECT( svMain ) ;
    
    [super dealloc] ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    /*
    [txfPhoneNumber setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
    [txfName setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
    [txfNC setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
    [txfPassWord1 setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
    [txfPassWord2 setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
    [txfMail setValue:[NSNumber numberWithInteger:5] forKey:@"paddingLeft"] ;
     */
    
    CGSize size = svMain.frame.size ;
    size.height = size.height + 100 ;
    [svMain setContentSize:size] ;
    
    //[txfPhoneNumber becomeFirstResponder] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onGoBack:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES] ;
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil] ;
}

- (void)ShowAlert:(NSString*)str
{
    UIAlertView *v = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil] ;
    
    [v show] ;
    
    [v release] ;
}

- (IBAction)onRegister:(id)sender
{
    //注册
    NSString *strUserPhone = txfPhoneNumber.text ;
    NSString *strUserName = txfName.text ;
    NSString *strNC = txfNC.text ;
    NSString *strPassWord1 = txfPassWord1.text ;
    NSString *strPassWord2 = txfPassWord2.text ;
    NSString *strMail = txfMail.text ;
    
    
    
    if( strUserPhone == nil || [strUserPhone isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入手机号码，手机号码不能为空！"] ;
        return ;
    }
    
    if( strUserName == nil || [strUserName isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入真实姓名，真实姓名不能为空！"] ;
        return ;
    }
    
    if( strNC == nil || [strNC isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入昵称，昵称不能为空！"] ;
        return ;
    }
    
    if( strPassWord1 == nil || [strPassWord1 isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入密码，密码不能为空！"] ;
        return ;
    }
    
    if( strPassWord2 == nil || [strPassWord2 isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入确认密码，确认密码不能为空！"] ;
        return ;
    }
    
    if( strMail == nil || [strMail isEqualToString:@""] )
    {
        [self ShowAlert:@"请您输入邮箱，邮箱不能为空！"] ;
        return ;
    }
    
    
    //检验手机号码是否合法
    NSString *phoneRegex = @"1[0-9]{10}" ;
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if( ![phoneTest evaluateWithObject:strUserPhone] )
    {
        [self ShowAlert:@"输入的手机号码不合法，请您重新输入！"] ;
        return ;
    }
                              
    
    //检验密码和确认密码是否一致
    if( ![strPassWord1 isEqualToString: strPassWord2] )
    {
        [self ShowAlert:@"密码和确认密码不一致，请您重新输入密码！"] ;
        return ;
    }
    
    //检查邮箱地址是否合法
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( ![emailTest evaluateWithObject:strMail] )
    {
        [self ShowAlert:@"输入的邮箱不合法，请您重新输入！"] ;
        return ;
    }
    
    
    //调用帐号组测接口注册帐号
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: strUserPhone, @"username",
                         strPassWord1, @"password", strNC, @"nickname", strUserName, @"realname",
                         strMail, @"email", nil] ;

    [self registerUser:dic];
}


//注册
-(void)registerUser:(NSDictionary *)dic
{
    [bussRequest cancelBussRequest];
    self.bussRequest = [BussMng bussWithType:BMJYEXRegister];
    
    [UIAstroAlert info:@"正在处理，请稍候" :0 :YES :0 :0];
    
    [bussRequest request:self :@selector(syncCallback_RegisterUser:) :dic];
    return;
}

//注册回调
- (void)syncCallback_RegisterUser:(TBussStatus*)sts
{
	[bussRequest cancelBussRequest];
	self.bussRequest = nil;
	
    [UIAstroAlert infoCancel];
    
	if ( sts.iCode != 200) //成功
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
        
        LOG_ERROR(@"Err:register user");
        return;
	}
    
    NSDictionary *dict =(NSDictionary *)(sts.rtnData);
    NSLog(@"%@",dict);
    
    int res = pickJsonIntValue(dict, @"result");
    NSString *msg = pickJsonStrValue(dict, @"msg");
    if (!msg) msg = @"";
    
    int uid = pickJsonIntValue(dict, @"uid");
    
    NSLog(@"res=%d msg=%@ uid=%d",res,msg,uid);
    
    if ( res ) { //成功
        MESSAGEBOX(@"注册成功");
        
        if( self.callBackObject != nil && self.callBackSEL != nil )
        {
            if( [self.callBackObject respondsToSelector:self.callBackSEL] )
            {
                NSDictionary *dic = @{@"Counter": txfPhoneNumber.text,@"PassWord": txfPassWord1.text};
                [self.callBackObject performSelector:self.callBackSEL withObject:dic] ;
            }
        }
        
        //[self.navigationController popViewControllerAnimated:YES]  ;
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil] ;
        
    }
    else {
        if (!msg || [msg isEqualToString:@""]) msg = @"注册发生错误";
        
        MESSAGEBOX(msg);
    }
}


@end
