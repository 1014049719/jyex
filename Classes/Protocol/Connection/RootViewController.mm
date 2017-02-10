//
//  RootViewController.m
//  pass91
//
//  Created by Zhaolin He on 09-8-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Plist.h"
#import "Global.h"
#import "RootViewController.h"
#import "PSettingViewController.h"
#import "P91PassDelegate.h"
#import "PFunctions.h"
#import "PXMLParser.h"
#import "LbsServer.h"
//#import "UIProgressHUD.h"
#import "PPHubView.h"
@interface RootViewController()
-(void)createLoginView;
-(void)viewForFooter;
-(void)loginToSystem;
-(void)justLook;
@property(nonatomic,retain)UITextField *userName;
@property(nonatomic,retain)UITextField *password;
@property(nonatomic,retain)LbsServer *server;
@end

static RootViewController *me=nil;
@implementation RootViewController

@synthesize userName,password,server,delegate,indicator,mSetItem,bbi,mBtnLeftTitle,mBtnRightTitle;

- (id)init
{
	self.mBtnLeftTitle = nil;
	self.mBtnRightTitle = nil;
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super init]) 
	{
		//UIImage *bgImg=[UIImage imageNamed:@"/Resource/Skin/login_background.png"];
		//UIImageView *view=[[UIImageView alloc] initWithImage:bgImg];
		//view.frame = CGRectMake(0, 0, 320, 480);
		//view.userInteractionEnabled = YES;
		//self.view = view;
		
		mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
		mTableView.delegate = self;
		mTableView.dataSource = self;
		mTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"/Resource/Skin/login_background.png"]];
		self.view = mTableView;
		
        //		UIImageView *noteLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource/Skin/note_logo.png"]];
        //		noteLogo.frame = CGRectMake(0, 0, 320, 91);
        //		[self.view addSubview:noteLogo];
        //		[noteLogo release];
		
		//[self createLoginView];
		[self viewForFooter];
		
        
		//init navigation bar
		self.navigationItem.title=NSLocalizedString(@"welcome",nil);
        
		//mSetItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"system_setting",@"") style:UIBarButtonItemStyleBordered target:self action:@selector(goSettingPage)];
		//self.navigationItem.leftBarButtonItem=mSetItem;
		
		
		opQueue = [[NSOperationQueue alloc] init];
		
		me=self;
		
		bShowLoginTip = NO;
		
		mAlertViewParameter = nil;
    }
    return self;
}

- (void)loadView
{
	[super loadView];
	[self viewForFooter];
}

-(void)createLoginView
{
	// 是否保存密码
	NSString *keep=[PFunctions getSavedState];
	
	UIImageView *textImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource/Skin/text_field.png"]];
	textImg.frame = CGRectMake(40, 130, 240, 40);
	textImg.userInteractionEnabled = YES;
	[self.view addSubview:textImg];
	
	UIImageView *textImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource/Skin/text_field.png"]];
	textImg1.frame = CGRectMake(40, 180, 240, 40);
	textImg1.userInteractionEnabled = YES;
	[self.view addSubview:textImg1];
	
	UILabel *usrNameLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 170, 40)];
	usrNameLb.text = NSLocalizedString(@"username",nil);
	usrNameLb.backgroundColor = [UIColor clearColor];
	[textImg addSubview:usrNameLb];
	[usrNameLb release];
	
	self.userName=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 110, 40)] autorelease];
	self.userName.backgroundColor = [UIColor grayColor];
	self.userName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	self.userName.delegate=self;
	self.userName.returnKeyType=UIReturnKeyDone;
	self.userName.autocapitalizationType=UITextAutocapitalizationTypeNone;
	self.userName.placeholder=NSLocalizedString(@"user_placeholder",nil);
	self.userName.clearsOnBeginEditing=NO;
	self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;
	if([keep isEqualToString:@"YES"])
	{
		self.userName.text=[PFunctions getUserName];;
	}
	[textImg addSubview:userName];
	
	UILabel *passWdLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 170, 40)];
	passWdLb.text = NSLocalizedString(@"password",nil);
	passWdLb.backgroundColor = [UIColor clearColor];
	[textImg1 addSubview:passWdLb];
	[passWdLb release];
	
	self.password=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 110, 40)] autorelease];
	//self.password.backgroundColor = [UIColor grayColor];
	self.password.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
	self.password.delegate=self;
	self.password.secureTextEntry=YES;
	self.password.returnKeyType=UIReturnKeyDone;
	self.password.placeholder=NSLocalizedString(@"pass_placeholder",nil);
	self.password.clearsOnBeginEditing=NO;
	self.password.clearButtonMode=UITextFieldViewModeWhileEditing;
	if([keep isEqualToString:@"YES"])
	{
		self.password.text=[PFunctions getPassword];
	}
	[textImg1 addSubview:password];
	
	[textImg release];
	[textImg1 release];
}

- (void)viewForFooter
{	
	UIImage *btnImg=[UIImage imageNamed:@"/Resource/Skin/login.png"];
	
	UIButton *bt1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
	bt1.frame=CGRectMake(10, 200, 130, 40);
	[bt1 setBackgroundImage:btnImg forState:UIControlStateNormal];
	[bt1 addTarget:self action:@selector(loginToSystem) forControlEvents:UIControlEventTouchUpInside];
	if (mBtnLeftTitle != nil)
	{
		[bt1 setTitle:NSLocalizedString(mBtnLeftTitle,nil) forState:UIControlStateNormal];
	}
	else
	{
		[bt1 setTitle:NSLocalizedString(@"login",nil) forState:UIControlStateNormal];
	}
	
	UIButton *bt2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
	bt2.frame=CGRectMake(180, 200, 130, 40);
	[bt2 setBackgroundImage:btnImg forState:UIControlStateNormal];
	[bt2 addTarget:self action:@selector(justLook) forControlEvents:UIControlEventTouchUpInside];
	if (mBtnRightTitle != nil)
	{
		[bt2 setTitle:NSLocalizedString(mBtnRightTitle,nil) forState:UIControlStateNormal];
	}
	else
	{
		[bt2 setTitle:NSLocalizedString(@"justLook",nil) forState:UIControlStateNormal];
	}
	//UIImage
	UIImage *cpImg = [UIImage imageNamed:@"/Resource/Skin/copyRight.png"];
	[cpImg stretchableImageWithLeftCapWidth:320 topCapHeight:108];
	UIImageView *cpImgView = [[UIImageView alloc] initWithImage:cpImg];
	cpImgView.frame=CGRectMake(0, 350, 320, 308);
	
    //	UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 160)];
    //	lb.numberOfLines = 4;
    //	lb.text = NSLocalizedString(@"tishi",nil);
    //	lb.backgroundColor = [UIColor clearColor];
    //	lb.textAlignment = UITextAlignmentCenter;
    //	lb.textColor = [UIColor darkGrayColor];
	
	UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btnClear.frame = CGRectMake(160, 300, 150, 30);
	[btnClear setTitle:@"清空账户信息" forState:UIControlStateNormal];
	[btnClear setTitle:@"清空账户信息" forState:UIControlEventTouchUpInside];
	[btnClear addTarget:self action:@selector(clearUserInfo) forControlEvents:UIControlEventTouchUpInside];
	
	
	UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 340, 320, 88)];
	label.numberOfLines=2;
	label.text=NSLocalizedString(@"copyright",nil);
	label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	label.textAlignment=UITextAlignmentCenter;
	label.textColor=[UIColor darkGrayColor];
	
	[self.view addSubview:bt1];
	[self.view addSubview:bt2];
	[self.view addSubview:btnClear];
	[self.view addSubview:cpImgView];
	//[self.view addSubview:lb];
	[self.view addSubview:label];
	
	[cpImgView release];
	//[lb release];
	[label release];
}

+(id)sharedView
{
    //	if(me != nil)
    //	{
    //		MLOG(@"RootViewController is not nil>>>>>>>>>>>>>>>>>>>>>>>");
    //		[me release];
    //	}
    //	[[RootViewController alloc] init];
    //	MLOG(@"RootView is nil >>>>>>>>>>>>>>>>>>>>>>>");
	// if delete not RootViewController
	// if update
	if (me == nil)
	{
		MLOG(@"RootViewController is nil>>>>>>>>>>>>>>>>>>>>>>>");
		me = [[RootViewController alloc] init];
	}
	else
	{
		MLOG(@"RootViewController is not nil>>>>>>>>>>>>>>>>>>>>>>>");
		//MLOG(@"%@",me);
	}
	
	return me;
}

+(id)clearView
{
	if (me)
	{
		[me release];
		me = nil;
	}
}

-(void)stopWaiting
{
	if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	
	if (bLoginWithoutInterface && bShowLoginTip)
	{
		[delegate stopDisplayLoginInfo];
        bShowLoginTip = false;
		return;
	}
	
	MLOG(@"stopWaiting!");

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
	if (indicator != nil)
	{
		[self.indicator removeFromSuperview];
		self.indicator = nil;
	}
}

-(void)goSettingPage
{
	[self.userName resignFirstResponder];
	[self.password resignFirstResponder];
	
	PSettingViewController *targetController=[[PSettingViewController alloc] init];
	targetController.delegate=self.delegate;
	[self.navigationController pushViewController:targetController animated:YES];
	[targetController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
#pragma mark <UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *noteLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource/Skin/note_logo.png"]];
	return noteLogo;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 92;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	static NSString *identifier = @"identifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSString *keep=[PFunctions getSavedState];
	
	switch (row)
	{
		case 0:
		{
			cell.textLabel.text = NSLocalizedString(@"username",nil);
			
			self.userName=[[[UITextField alloc] initWithFrame:CGRectMake(160, 0, 140, 40)] autorelease];
			//self.userName.backgroundColor = [UIColor grayColor];
			self.userName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
			self.userName.delegate=self;
			self.userName.returnKeyType=UIReturnKeyDone;
			self.userName.autocapitalizationType=UITextAutocapitalizationTypeNone;
			self.userName.placeholder=NSLocalizedString(@"user_placeholder",nil);
			self.userName.clearsOnBeginEditing=NO;
			self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;
			if([keep isEqualToString:@"YES"])
			{
				self.userName.text=[PFunctions getUserName];
			}
			
			[cell addSubview:userName];
		}
			
			break;
		case 1:
		{
			cell.textLabel.text = NSLocalizedString(@"password",nil);
			
			self.password=[[[UITextField alloc] initWithFrame:CGRectMake(160, 0, 140, 40)] autorelease];
			self.password.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
			self.password.delegate=self;
			self.password.secureTextEntry=YES;
			self.password.returnKeyType=UIReturnKeyDone;
			self.password.placeholder=NSLocalizedString(@"pass_placeholder",nil);
			self.password.clearsOnBeginEditing=NO;
			self.password.clearButtonMode=UITextFieldViewModeWhileEditing;
			if([keep isEqualToString:@"YES"])
			{
				self.password.text=[PFunctions getPassword];
			}
			
			[cell addSubview:password];
		}
			
			break;
		default:
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.userName resignFirstResponder];
	[self.password resignFirstResponder];
	self.view.frame = CGRectMake(0, 0, 320, 480);
}
#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	// reset tagInEdit - no field in edit
	self.view.frame = CGRectMake(0, 0, 320, 480);
	//[textField resignFirstResponder];
	if(textField == self.userName)
	{
		[textField resignFirstResponder];
		[self.password becomeFirstResponder];
	}else
	{
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.view.frame = CGRectMake(0, -80, 320, 480);
	return YES;
}

#pragma mark login system
- (void)delayLogin:(id)sender
{
    //开始登录
    //start login 内部做了流量统计
    [self.server startLogin];
}

- (void)startLogin
{
    self.view.frame = CGRectMake(0, 0, 320, 480);
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    NSString *user=[userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pass=[password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!user||!pass||[user isEqualToString:@""]||[pass isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"system_message",nil) message:NSLocalizedString(@"name_pass_empty",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"submit",nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [PFunctions initUsername:user];
    [PFunctions initPassname:pass];
    
    //初始化登陆参数
    LbsServer *temp=[[LbsServer alloc] initWithUsername:user Password:pass AppType:@"6" delegate:self.delegate];
    self.server = temp;

    //显示等待图标
	//    NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showWaitIcon) object:nil];
	//    [opQueue addOperation:request];
	//    [request release];
	[self showWaitIcon:nil];
    
    [self performSelector:@selector(delayLogin:) withObject:nil afterDelay:0.5];
}

-(void)loginToSystem
{
	bLoginWithoutInterface = NO;
	/*
     // 登陆时将账号密码晴空
     NSString *savePath=[PFunctions getConfigFile];
     NSFileManager *filem=[NSFileManager defaultManager];
     if([filem fileExistsAtPath:savePath])
     {
     NSMutableDictionary *dic=[NSMutableDictionary dictionary];
     [dic setObject:@"" forKey:@"Username"];
     [dic setObject:@"" forKey:@"Password"];
     NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:(id)dic format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
     
     if (plistData) 
     {
     [plistData writeToFile:savePath atomically:YES];
     }
     else {
     MLOG(@"data error!");
     }
     }
     */
    if ([Global getNetworkStatus] == NotReachable)
	{
		UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"nonet") 
														 message:_(@"check_net") 
														delegate:self 
											   cancelButtonTitle:_(@"iknow") 
											   otherButtonTitles:nil];
		[alView show];
		[alView release];
		return;
	}
    
    if ([Global getNetworkStatus] != ReachableViaWiFi)
    {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"Network status") 
														 message:_(@"Using GPRS netword, continue?") 
														delegate:self 
											   cancelButtonTitle:_(@"ok") 
											   otherButtonTitles:_(@"No"),nil];
        [alView setTag:12];
		[alView show];
		[alView release];
        return;
    }

    [self startLogin];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    if ([alertView tag] == 12) 
    {
        if (buttonIndex == 0) 
        {
            [self startLogin];
        }
    }
	else if ([alertView tag] == 13) {
		NSString *user = [PFunctions getUserName];
		NSString *pass = [PFunctions getPassword];
		[PFunctions initUsername:user];
		[PFunctions initPassname:pass];
		
		//初始化登陆参数
		LbsServer *temp=[[LbsServer alloc] initWithUsername:user Password:pass AppType:@"6" delegate:self.delegate];
		self.server = temp;
		
		[self showWaitIcon:mAlertViewParameter];
		
		[self performSelector:@selector(delayLogin:) withObject:nil afterDelay:0.5];
	}
	else if ([alertView tag] == 14) {
		NSString *user = [PFunctions getUserName];
		NSString *pass = [PFunctions getPassword];
		[PFunctions initUsername:user];
		[PFunctions initPassname:pass];
		
		//初始化登陆参数
		LbsServer *temp=[[LbsServer alloc] initWithUsername:user Password:pass AppType:@"6" delegate:self.delegate];
		self.server = temp;
		
		[self showWaitIcon:mAlertViewParameter];
		
		[self performSelector:@selector(delayLogin:) withObject:nil afterDelay:0.5];
	}
	
	if (mAlertViewParameter) {
		[mAlertViewParameter release];
		mAlertViewParameter = nil;
	}
}

-(void)loginWithoutInterface:(BOOL)bShowTip
{
	bLoginWithoutInterface = YES;
	
	if ([Global getNetworkStatus] == NotReachable)
	{
		UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"nonet") 
														 message:_(@"check_net") 
														delegate:self 
											   cancelButtonTitle:_(@"iknow") 
											   otherButtonTitles:nil];
		[alView show];
		[alView release];
		return;
	}
    
    if ([Global getNetworkStatus] != ReachableViaWiFi)
    {
		if (bShowTip) {
			mAlertViewParameter = nil;
		}
		else {
			mAlertViewParameter = [[NSString alloc] initWithString:@""];
		}
		
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"Network status") 
														 message:_(@"Using GPRS netword, continue?") 
														delegate:self 
											   cancelButtonTitle:_(@"ok") 
											   otherButtonTitles:_(@"No"),nil];
        [alView setTag:13];
		[alView show];
		[alView release];
        return;
    }
	
	NSString *user = [PFunctions getUserName];
    NSString *pass = [PFunctions getPassword];
	[PFunctions initUsername:user];
	[PFunctions initPassname:pass];
    
    //初始化登陆参数
    LbsServer *temp=[[LbsServer alloc] initWithUsername:user Password:pass AppType:@"6" delegate:self.delegate];
    self.server = temp;
	
    //显示等待图标
	//    NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showWaitIcon) object:nil];
	//    [opQueue addOperation:request];
	//    [request release];
	if (bShowTip) {
		[self showWaitIcon:nil];
	}
	else {
		[self showWaitIcon:@""];
	}

    
    [self performSelector:@selector(delayLogin:) withObject:nil afterDelay:0.5];
}

-(void)showWaitIcon:(NSString *)strHit
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	if (bLoginWithoutInterface && nil == strHit)
	{
		bShowLoginTip = YES;
		[delegate startDisplayLoginInfo];
		return;
	}
	if (strHit) {
		return ;
	}
		
	PPHubView *progress=[[PPHubView alloc] initWithSmalllIndicator:CGRectMake(160-66, 480-44-12-36-60-2-10, 138, 36) text:_(@"loading") showCancel:NO];
	self.indicator=progress;
	[progress release];
	
	// 底部loading...
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;
	[self.view addSubview:indicator];
	// 导航栏loading...
	UIActivityIndicatorView * act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[act startAnimating];
	act.frame = CGRectMake(150, 0, 20, 20);
	self.bbi = [[UIBarButtonItem alloc] initWithCustomView:act];
	self.title = nil;
	self.navigationItem.rightBarButtonItem = bbi;
	[self.bbi release];
	[act release];
}

-(void)justLook
{
	//exec delegate method
	MLOG(@"随便看看!");
	if(delegate!=nil&&[delegate respondsToSelector:@selector(justTestUse)])
	{
		[delegate justTestUse];
	}
}

- (void)clearUserInfo {
	self.userName.text = @"";
	self.password.text = @"";
	
	[PFunctions setUsername:@"" Password:@""];
}

- (void)dealloc 
{
	MLOG(@">>> >>> RootViewController dealloc >>> >>>");
	[mSetItem release];
	[bbi release];
	[mTableView release];
	[userName release];
	[password release];
	[server release];
	MLOG(@"indicator release");
	[indicator release];
	MLOG(@"indicator release end");
	[opQueue release];
    [super dealloc];
	MLOG(@">>> >>> RootViewController dealloc success >>> >>>");
	
	if (mAlertViewParameter) {
		[mAlertViewParameter release];
		mAlertViewParameter = nil;
	}
}

-(BOOL)reConnect:(NSString *)strHit {
	if ([Global getNetworkStatus] == NotReachable)
	{
		UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"nonet") 
														 message:_(@"check_net") 
														delegate:self 
											   cancelButtonTitle:_(@"iknow") 
											   otherButtonTitles:nil];
		[alView show];
		[alView release];
		return NO;
	}
    
    if ([Global getNetworkStatus] != ReachableViaWiFi)
    {
		if (strHit) {
			mAlertViewParameter = [[NSString alloc] initWithString:strHit];
		}
		else {
			mAlertViewParameter = nil;
		}

        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:_(@"Network status") 
														 message:_(@"Using GPRS netword, continue?") 
														delegate:self 
											   cancelButtonTitle:_(@"ok") 
											   otherButtonTitles:_(@"No"),nil];
        [alView setTag:14];
		[alView show];
		[alView release];
        return NO;
    }
	MLOG(@"reConnect occurs ... ");
	
	
	NSString *user = [PFunctions getUserName];
    NSString *pass = [PFunctions getPassword];
	[PFunctions initUsername:user];
	[PFunctions initPassname:pass];
    
    //初始化登陆参数
    LbsServer *temp=[[LbsServer alloc] initWithUsername:user Password:pass AppType:@"6" delegate:self.delegate];
    self.server = temp;
	
    //显示等待图标
	//    NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showWaitIcon) object:nil];
	//    [opQueue addOperation:request];
	//    [request release];
	[self showWaitIcon:strHit];
    
    [self performSelector:@selector(delayLogin:) withObject:nil afterDelay:0.5];
	
	return YES;
}

@end
