//
//  PRegisterViewController.m
//  pass91
//
//  Created by Zhaolin He on 09-8-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PRegisterViewController.h"
#import "PSettingViewController.h"
#import "P91PassDelegate.h"
#import "PFunctions.h"
#import "PXMLParser.h"
//#import "UIProgressHUD.h"
#import "DES3.h"
#import "EncryptPwd.h"
#import "ProtocolViewController.h"

@interface PRegisterViewController (hidden)

- (void)showAgree;

@end

static PRegisterViewController *me=nil;
@implementation PRegisterViewController
@synthesize username,password,submit_pass,realName,id_number,phone_number,delegate/*,indicator*/;



- (id)init
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super init]) 
	{
		self.title=NSLocalizedString(@"register",nil);
		self.tabBarItem.image=[UIImage imageNamed:@"Resource/Skin/register.png"];
		
		UITableView *myTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
		myTable.dataSource=self;
		myTable.delegate=self;
		myTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"/Resource/Image/ar-brushed_background.png"]];
		self.view=myTable;
		[myTable release];
		
		//UIProgressHUD *progress=[[UIProgressHUD alloc] initWithFrame:CGRectMake(60, 100, 200, 150)];
		//[progress setText:NSLocalizedString(@"loading",nil)];
		//self.indicator=progress;
		//[progress release];
		
		[self showAgree];
		
		me=self;
    }
    return self;
}

+(id)sharedRegister{
	return me;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view.
 - (void)viewDidLoad 
 {
 [super viewDidLoad];
 }
 */
- (void)showAgree
{
	const unsigned int move_y = 130;
	
	UIButton *btn_agree = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_agree.frame = CGRectMake(70, 150+move_y, 206, 18);
	//[btn_agree setTitle:NSLocalizedString(@"agree_register",nil) forState:UIControlStateNormal];
	[btn_agree setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	btn_agree.titleLabel.font = [UIFont systemFontOfSize:18];
	[btn_agree setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/protocol91.png"] forState:UIControlStateNormal];
	[btn_agree addTarget:self action:@selector(gotoAgreeRegister) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn_agree];
	
	UIButton *btn_tick = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_tick.frame = CGRectMake(20, 145+move_y, 30, 30);
	btn_tick.tag = 333;
	[btn_tick setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/NotSelected.png"] forState:UIControlStateNormal];
	[btn_tick addTarget:self action:@selector(tick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn_tick];
	isTick = NO;
	
	UIButton *btn_click = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_click.frame = CGRectMake(10, 180+move_y, 300, 38);
	[btn_click setTitle:NSLocalizedString(@"reg_submit",nil) forState:UIControlStateNormal];
	[btn_click setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn_click setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/access.png"] forState:UIControlStateNormal];
	[btn_click addTarget:self action:@selector(sureToRegister) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn_click];
}
-(void)tick
{
	UIButton *btn_tick = (UIButton *)[self.view viewWithTag:333];
	if (isTick == YES)
	{
		[btn_tick setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/NotSelected.png"] forState:UIControlStateNormal];
		isTick = NO;
	}
	else
	{
		[btn_tick setBackgroundImage:[UIImage imageNamed:@"Resource/PPImage/IsSelected.png"] forState:UIControlStateNormal];
		isTick = YES;
	}
}

- (void)gotoAgreeRegister
{
	ProtocolViewController *pCtr = [[ProtocolViewController alloc] init];
	//[self.navigationController initWithRootViewController:pCtr];
	//UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:pCtr];
	//pCtr.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:_(@"Cancel") 
	//																			  style:UIBarButtonItemStyleBordered 
	//																			 target:self action:@selector(cancelAction)] autorelease];
	//[self presentModalViewController:pCtr animated:YES];
	
	//[nav release];
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:_(@"Cancel") 
  	//																		   style:UIBarButtonItemStyleBordered 
	//																		  target:self action:@selector(cancelAction)] autorelease];
	[[[PSettingViewController sharedSettingController] navigationController] pushViewController:pCtr animated:YES];
	[pCtr release];
}
-(void)cancelAction
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)sureToRegister
{
	[self hideKeyBoard];
	
	//[self.indicator showInView:self.view];
	[self performSelectorInBackground:@selector(send_regist) withObject:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return 3;
		case 1:
			return 3;
		case 2:
			return 1;
		default:
			return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *headerView=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *headerView=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	switch (section) {
		case 0:
		case 1:
		case 2:
			return 13;
		default:
			return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier =[NSString stringWithFormat: @"Cell%d%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font=[UIFont systemFontOfSize:17.0];
		if(indexPath.section==0)
		{
			switch (indexPath.row) 
			{
				case 0:
					cell.textLabel.text=NSLocalizedString(@"username",nil);
					self.username=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.username.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.username.placeholder=NSLocalizedString(@"request_field",nil);
					self.username.returnKeyType=UIReturnKeyDone;
					self.username.delegate=self;
					self.username.clearsOnBeginEditing=NO;
					self.username.autocapitalizationType=UITextAutocapitalizationTypeNone;
					self.username.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.username];
					break;
				case 1:
					cell.textLabel.text=NSLocalizedString(@"password",nil);
					self.password=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.password.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.password.placeholder=NSLocalizedString(@"request_field",nil);
					self.password.returnKeyType=UIReturnKeyDone;
					self.password.secureTextEntry=YES;
					self.password.delegate=self;
					self.password.clearsOnBeginEditing=NO;
					self.password.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.password];
					break;
				case 2:
					cell.textLabel.text=NSLocalizedString(@"submit_password",nil);
					self.submit_pass=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.submit_pass.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.submit_pass.placeholder=NSLocalizedString(@"request_field",nil);
					self.submit_pass.returnKeyType=UIReturnKeyDone;
					self.submit_pass.secureTextEntry=YES;
					self.submit_pass.delegate=self;
					self.submit_pass.clearsOnBeginEditing=NO;
					self.submit_pass.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.submit_pass];
					break;
				default:
					break;
			}
		}
		else if(indexPath.section==1)
		{
			switch (indexPath.row)
			{
				case 0:
					cell.textLabel.text=NSLocalizedString(@"real_name",nil);
					self.realName=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.realName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.realName.placeholder=NSLocalizedString(@"request_field",nil);
					self.realName.returnKeyType=UIReturnKeyDone;
					self.realName.delegate=self;
					self.realName.clearsOnBeginEditing=NO;
					self.realName.autocapitalizationType=UITextAutocapitalizationTypeNone;
					self.realName.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.realName];
					break;
				case 1:
					cell.textLabel.text=NSLocalizedString(@"id_card",nil);
					self.id_number=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.id_number.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.id_number.placeholder=NSLocalizedString(@"request_field",nil);
					self.id_number.keyboardType=UIKeyboardTypeNumberPad;
					self.id_number.delegate=self;
					self.id_number.clearsOnBeginEditing=NO;
					self.id_number.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.id_number];
					break;
				case 2:
					cell.textLabel.text=NSLocalizedString(@"cellphone",nil);
					self.phone_number=[[[UITextField alloc] initWithFrame:CGRectMake(135, 0, 170, 40)] autorelease];
					self.phone_number.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.phone_number.placeholder=NSLocalizedString(@"optional_field",nil);
					self.phone_number.keyboardType=UIKeyboardTypePhonePad;
					self.phone_number.delegate=self;
					self.phone_number.clearsOnBeginEditing=NO;
					self.phone_number.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.phone_number];
					break;
				default:
					break;
			}
		}else if(indexPath.section==2){
			switch (indexPath.row) {
				case 0:
					cell.textLabel.textAlignment=UITextAlignmentCenter;
					cell.textLabel.text=NSLocalizedString(@"reg_submit",nil);
					break;
				default:
					break;
			}
		}
		//是否可以点机
		if(indexPath.section!=2){
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
		}
    }
    // Configure the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.section==2)
	{
		[self hideKeyBoard];
		
		//[self.indicator showInView:self.view];
		[self performSelectorInBackground:@selector(send_regist) withObject:nil];
	}
}

/*
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 }
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 }
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 }
 */
/*
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 }
 */

#pragma mark <UITextFieldDelegate>
//static BOOL isEditing=NO;
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	UITableView *myTable=(UITableView *)self.view;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	myTable.frame = CGRectMake(0, 0, 320, 200);
	[UIView commitAnimations];
	
	if([textField isEqual:self.id_number]||[textField isEqual:self.phone_number]){
		[myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController createRightBarButtonWithTarget:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//isEditing=NO;
	[textField resignFirstResponder];
	UITableView *myTable=(UITableView *)self.view;
	myTable.frame=CGRectMake(0, 0, 320, 400);
	
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController removeRightBarButton];
	
	return YES;
}

-(void)hideKeyBoard{
	[self.username resignFirstResponder];
	[self.password resignFirstResponder];
	[self.submit_pass resignFirstResponder];
	[self.realName resignFirstResponder];
	[self.id_number resignFirstResponder];
	[self.phone_number resignFirstResponder];	
	UITableView *myTable=(UITableView *)self.view;
	myTable.frame=CGRectMake(0, 0, 320, 400);
	
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController removeRightBarButton];
}

#pragma mark register
-(void)send_regist{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	[self retain];
	
	NSString *errMsg=nil;
	NSDictionary *info=nil;
	BOOL isSuccessful=NO;
	
	NSString *user=[self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *pass=[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *pass2=[self.submit_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	NSString *real_name=[self.realName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *id_card=[self.id_number.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *phone_num=[self.phone_number.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *ts=[NSString stringWithFormat:@"%d",rand()%8+1];
	NSString *sign=[PFunctions md5Digest:[NSString stringWithFormat:@"%@!!)@)^@$",ts]];
	//验证输入是否合法
	//身份证合法
	
	if([id_card length]!=15&&[id_card length]!=18){
		errMsg=NSLocalizedString(@"idcard_char",nil);
	}
    
	//实名注册,姓名长度必须为2-4位
	
	if([real_name length]<2||[real_name length]>4){
		errMsg=NSLocalizedString(@"realname_length",nil);
	}
    
	if(![pass isEqualToString:pass2]){
		errMsg=NSLocalizedString(@"password_isMached",nil);
	}
	NSString *trimed_pass=[pass stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
	if([pass length]<7||[pass length]>12||[[trimed_pass stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]] length]!=0){
		errMsg=NSLocalizedString(@"password_char",nil);
	}
	if([user length]<4||[user length]>70){
		errMsg=NSLocalizedString(@"username_length",nil);
	}
	//验证是否同意条款
	if(isTick == NO){
		errMsg=NSLocalizedString(@"tick_agreement",nil);
	}
	//注册操作
	if(errMsg==nil){
		char* pstr = EncryptPwd((char *)[pass UTF8String]);
		char contentbuf[2048] = {0};
		
		printf("pstr[%s]", pstr);
		
		NSString *enc_user=[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)user, NULL, NULL, kCFStringEncodingUTF8) autorelease];
		NSString *enc_trueName=[(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)real_name, NULL, NULL, kCFStringEncodingUTF8) autorelease];
		
		if([phone_num length]!=0)
		{
			sprintf(contentbuf, "http://panda.sj.91.com/Service/GetResourceData.aspx?mt=1&qt=604&username=%s&password=%s&idcard=%s&name=%s&mobile=%s&ts=%s&sign=%s",[enc_user UTF8String],pstr,[id_card UTF8String],[enc_trueName UTF8String],[phone_num UTF8String],[ts UTF8String],[sign UTF8String]);
		}else
		{
			sprintf(contentbuf, "http://panda.sj.91.com/Service/GetResourceData.aspx?mt=1&qt=604&username=%s&password=%s&idcard=%s&name=%s&ts=%s&sign=%s",[enc_user UTF8String],pstr,[id_card UTF8String],[enc_trueName UTF8String],[ts UTF8String],[sign UTF8String]);
		}
		
		CFStringRef s=CFStringCreateWithCString (
												 NULL,
												 contentbuf,
												 kCFStringEncodingNonLossyASCII
                                                 );
		CFShow(s);
		NSURL *url=[NSURL URLWithString:(NSString *)s];
		
		if(NULL!=s)CFRelease(s);
		if(NULL!=pstr)free(pstr);
		isSuccessful=[PXMLParser parseXMLWithURL:url returnValue:&info];
	}
	//[self.indicator hide];
	//whether regist success
	if(isSuccessful){
		UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"register_success",nil) message:[NSString stringWithFormat:@"%@:%@\n%@:%@",NSLocalizedString(@"register_name",nil),[info objectForKey:@"username"],NSLocalizedString(@"register_truename",nil),[info objectForKey:@"truename"]] delegate:self cancelButtonTitle:NSLocalizedString(@"submit",nil) otherButtonTitles:nil];
		successAlert.delegate = self;
		[successAlert show];
		[successAlert release];
		//exec delegate method
		if(delegate!=nil&&[delegate respondsToSelector:@selector(registerDidSuccessWithInfo:)]){
			[delegate registerDidSuccessWithInfo:info];
		}
	}else{
		if(info!=nil){
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[info objectForKey:@"description"] message:[info objectForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"submit",nil) otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else if(errMsg!=nil){
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"system_message",nil) message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"submit",nil) otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"system_message",nil) message:NSLocalizedString(@"unknow_error",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"submit",nil) otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		MLOG(@"\n register faild");
		//exec delegate method
		if(delegate!=nil&&[delegate respondsToSelector:@selector(registerDidFailedWithError)]){
			[delegate registerDidFailedWithError:[NSError errorWithDomain:NSLocalizedString(@"unknow_error",nil) code:10 userInfo:nil]];
		}
	}	
	
	[self release];
	[pool release];
}

#pragma mark <UIAlertViewDelegate>
// 无效???
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	switch (buttonIndex) 
	{
		case 0:
			[self.navigationController popViewControllerAnimated:YES];
			break;
		default:
			break;
	}
}

- (void)dealloc {
	MLOG(@" >>> >>> PRegister dealloc >>> >>>");
	[username release];
	[password release];
	[realName release];
	[id_number release];
	[phone_number release];
	[submit_pass release];
	//[indicator release];
    [super dealloc];
	MLOG(@" >>> >>> PRegister dealloc success >>> >>>");
}

@end

