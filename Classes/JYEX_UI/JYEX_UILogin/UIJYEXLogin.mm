//
//  UIJYEXLogin.m
//  NoteBook
//
//  Created by cyl on 13-3-22.
//  Copyright (c) 2013年 广州洋基信息科技有限公司. All rights reserved.
//


#import "PubFunction.h"
#import "UIJYEXLogin.h"
#import "UIAstroAlert.h"
#import "GlobalVar.h"
#import "BussMng.h"
#import "DataSync.h"
#import "BizLogicAll.h"
#import "UIImage+Scale.h"
#import "CommonDefine.h"
#import "CfgMgr.h"
#import "CommonAll.h"
#import "UIRegisterVC.h"
#import "ActivityCell.h"


#import "JUEX_UISetting.h"

@implementation UIJYEXLogin

@synthesize aryAccountList;
@synthesize bussMng;
@synthesize msgParam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil back:(BOOL)canBack
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bShowBackButton = canBack;
//        NSString *strValue = nil;
//        BOOL b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"AutoLogin" value:strValue];
//        if ( !b || !strValue || strValue.length == 0 || [strValue isEqualToString:@"YES"] ) {
//            self->bAutoLogin = YES;
//        }
//        else
//        {
//            self->bAutoLogin = NO;
//        }
    }
    return self;
}

- (void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[bussMng cancelBussRequest];
	self.bussMng = nil;	
	self.msgParam = nil;
    
    [activityIndicator release];
    
    [self.aryAccountList removeAllObjects];
    self.aryAccountList = nil;
    
    SAFEREMOVEANDFREE_OBJECT(m_ivAvatar);
    SAFEREMOVEANDFREE_OBJECT(m_txfCounter);
    SAFEREMOVEANDFREE_OBJECT(m_txfPassWord);
    SAFEREMOVEANDFREE_OBJECT(m_btnLogin);
    SAFEREMOVEANDFREE_OBJECT(m_btnCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnFullScreen);
    SAFEREMOVEANDFREE_OBJECT(m_btnDropList);
    SAFEREMOVEANDFREE_OBJECT(tblUserList);
    
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    
    NSString *CellIdentifier = @"ActivityCellIdentifier";
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ActivityCell class]) bundle:nil];
    [tblUserList registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    
    m_txfCounter.delegate = self;
    m_txfPassWord.delegate = self;
    
    tblUserList.delegate = self;
	tblUserList.dataSource = self;
    //tblUserList.layer.borderWidth = 1;
    //tblUserList.layer.borderColor = [UIColor grayColor].CGColor;
    
    
	[self initAccountList];
	iListStyle = EJYEXShowAll;
    
    
    //load current user;    
	if (TheCurUser && ![TheCurUser isDefaultUser]) {
		m_txfCounter.text = TheCurUser.sUserName;
        m_txfPassWord.text = TheCurUser.sPassword;
	}
	else {
		m_txfCounter.text = @"";
		m_txfPassWord.text = @"";
	}
    
    [self updateAvatar];
    
    if ( bShowBackButton ) m_btnCancel.hidden = NO;
  
    
    CGRect rect;
    rect.size.width = 25;
    rect.size.height = 25;
    rect.origin.x =  m_btnLogin.frame.size.width - 30;
    rect.origin.y = m_btnLogin.frame.size.height/2 - rect.size.height/2;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    
    [m_btnLogin addSubview:activityIndicator];
    activityIndicator.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//更新头像
-(void)updateAvatar
{
    if ( [m_txfCounter.text length] > 0 ) {
        if ( [CommonFunc isFileExisted:[CommonFunc getAvatarPath:m_txfCounter.text]] ) { //头像存在
            UIImage *img = [UIImage imageWithContentsOfFile:[CommonFunc getAvatarPath:m_txfCounter.text]];
            //CGSize size = img.size;
            m_ivAvatar.image = img;
            return;
        }
    }

    NSString *strDefault = [[NSBundle mainBundle] pathForResource:@"default_login_back@2x" ofType:@"png"];
    m_ivAvatar.image = [UIImage imageWithContentsOfFile:strDefault];
}



//用户处理
-(void)initAccountList
{
    SAFEFREE_OBJECT(aryAccountList);
	self.aryAccountList = [AstroDBMng getLoginUserList];
    if ( [aryAccountList count] < 1 ) m_btnDropList.hidden = YES;
    else m_btnDropList.hidden = NO;
}

#pragma mark -  按钮响应函数
-(IBAction)OnLogin:(id)sender
{
    
    if ( m_btnLogin.selected ) return;
	
	TParamLogin* param = [[TParamLogin new] autorelease];
	
	//check 
	if ([PubFunction stringIsNullOrEmpty:m_txfCounter.text]) {
		[UIAstroAlert info:@"用户名不能为空" :2.0 :NO :LOC_MID :NO];
		return;
	}
	else 
		param.user = m_txfCounter.text;
	
	if ([PubFunction stringIsNullOrEmpty:m_txfPassWord.text]) {
        [UIAstroAlert info:@"密码不能为空" :2.0 :NO :LOC_MID :NO];
		return;
	}
	else 
		param.pswd = m_txfPassWord.text;
    
    
	[self OnBtnFullScreen:nil];
    
	
    [activityIndicator startAnimating];
    activityIndicator.hidden = NO;
    
    m_btnCancel.enabled = NO;
    m_btnLogin.selected = YES;
    
	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMLogin];
	[bussMng request:self :@selector(loginCallback:) :param];    
    
}


-(IBAction)OnUnLogin:(id)sender
{
    [UIAstroAlert infoCancel];
    
    //取消 
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    
    if ( loginOk ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:@"登录成功" userInfo:nil];
    }
    
	TBussStatus* sts = [[TBussStatus new] autorelease];
	sts.iCode = loginOk ? 1 : 0;
	if (msgParam!=nil)
		[msgParam.obsv performSelector:msgParam.callback withObject:sts afterDelay:1.0];
}


-(IBAction)OnBtnFullScreen:(id)sender
{
    if ([m_txfCounter isFirstResponder]) {
        [m_txfCounter resignFirstResponder];
    }
    else if ([m_txfPassWord isFirstResponder]) {
        [m_txfPassWord resignFirstResponder];
    }
    
    tblUserList.hidden = YES;
}


- (void)loginCallback:(TBussStatus*)sts
{
    int succflag = 0;
    
	[bussMng cancelBussRequest];
	self.bussMng = nil;
	
    [UIAstroAlert infoCancel];
    
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    m_btnLogin.selected = NO;
    m_btnCancel.enabled = YES;

    if ( sts && sts.sInfo) {
        if ( [sts.sInfo isEqualToString:@"login_false"] ) {
            [UIAstroAlert info:@"请检查您的用户名密码是否正确" :2.0 :NO :LOC_MID :NO];
        }
        else if( [sts.sInfo isEqualToString:@"no_user"] )
        {
            [UIAstroAlert info:@"用户名不存在,请检查您的用户名!" :2.0 :NO :LOC_MID :NO];
        }
        else if( [sts.sInfo isEqualToString:@"login_success"] )
        {
            succflag = 1; //成功
        }
        else
        {
            NSString *sErrHttp = LOC_STR("wlqqsb");
            if ( [sts.sInfo rangeOfString:sErrHttp].location != NSNotFound ) {
                [UIAstroAlert info:@"登录失败,当前网络不可用" :3.0 :NO :LOC_MID :NO];
            }
        }
    }
    else if(sts==nil || sts.iCode == 200)
    {
        succflag = 1; //成功
    }
    
    JYEXUserAppInfo *ylzzb = nil;
    if ( 1 == succflag ) {
        
        /*
#ifdef VER_YEZZB
        NSArray *arr = [BizLogic getAppListByUserName:TheCurUser.sUserName AppType:USER_APP_TYPE_BOUGHT];
        for (JYEXUserAppInfo *app in arr ) {
            if( [app.sAppCode isEqualToString:LM_YEZZB] ) {
                ylzzb = app;
                break;
            }
        }
        if ( ! ylzzb ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没开通育儿掌中宝，请登录网站www.jyex.cn或电话400-900-3011开通，或使用别的帐号登录。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
 #endif
        */
        
        
        //保存
        NSString *strValue = @"YES";
        [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"AutoLogin" value:strValue];
       
        
        //取消
        NSArray *arr = [self.navigationController viewControllers];
        NSUInteger count = [arr count];
        if ( count> 2 && [[arr objectAtIndex:count-2] isKindOfClass:[JUEX_UISetting class]]) {
            [PubFunction SendMessageToViewCenter:NMBack :2 :0 :nil];
        }
        else {
            [PubFunction SendMessageToViewCenter:NMBack :0 :0 :nil];
        }
        
        [UIAstroAlert info:@"登录成功" :2.0 :NO :LOC_MID :NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:@"登录成功" userInfo:nil];
        
        loginOk = YES;
        [PubFunction SendMessageToViewCenter:NMHome :0 :1 :ylzzb];
    }
    
}




-(void)updatePasswordByName
{
    if ( ![PubFunction stringIsNullOrEmpty:m_txfCounter.text])
    {
        for (int i=0; i<[aryAccountList count]; i++)
        {
            TLoginUserInfo* user = [aryAccountList objectAtIndex:i];
            if ([m_txfCounter.text isEqualToString:user.sUserName])
            {
                m_txfPassWord.text = user.sPassword;
                return;
            }
        }
    }
    
}


-(void)changeUserTableHeight
{
	int maxH = 160;
	int rowCnt = (int)[tblUserList numberOfRowsInSection:0];
	if (rowCnt <= 0)
	{
		tblUserList.hidden = YES;
        return;
	}
	
	CGRect rctTbl = tblUserList.frame;
    
	int rowH = 60;//[tblUserList rowHeight];
	if (rowCnt*rowH > maxH )
	{
		rctTbl.size.height = maxH;
	}
	else
	{
		rctTbl.size.height = rowCnt*rowH;
	}
    
	tblUserList.frame = rctTbl;
}

//textfield的代理
-(BOOL) textFieldShouldReturn :(UITextField*)textField
{
    
    [textField resignFirstResponder];
    
	tblUserList.hidden = YES;
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ( textField == m_txfCounter ) {
        m_txfPassWord.text = @"";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == m_txfCounter ) {
        m_txfPassWord.text = @"";
    }
    return YES;
}

- (IBAction)onDropUserlist:(id)sender
{
    m_btnDropList.selected = ! m_btnDropList.selected;
    if ( !m_btnDropList.selected ) {
        tblUserList.hidden = YES;
        return;
    }
    
    if ([aryAccountList count] < 1 ) {
        [UIAstroAlert info :@"登录用户记录为空" :2.0 :NO :LOC_MID :NO];
        return;
    }
    
	[self OnBtnFullScreen:nil];
	iListStyle = EJYEXShowAll;
	tblUserList.hidden = NO;
	[tblUserList reloadData];
	[self changeUserTableHeight];
}


- (IBAction) onUserNameEditing: (id)sender
{
	//NSLog(@"onUserNameEditing: %@", tfUser.text);
	iListStyle = EJYEXShowFilter;
	tblUserList.hidden = NO;
	
	[tblUserList reloadData];
	[self changeUserTableHeight];
	[self updatePasswordByName];
}

- (IBAction)onUserNameEditingBegin:(id)sender
{
	iListStyle = EJYEXShowFilter;
	tblUserList.hidden = NO;
	[tblUserList reloadData];
	[self changeUserTableHeight];
}

- (IBAction)onUserNameEditingEnd:(id)sender
{
    tblUserList.hidden = YES;
}

- (IBAction)onUserNameChanged:(id)sender
{
	[self updatePasswordByName];
}

- (IBAction)onPasswordEditingBegin:(id)sender
{
}

- (IBAction)onPasswordEditingEnd:(id)sender
{
    /*
     if ([PubFunction stringIsNullOrEmpty:tfPswd.text] )
     {
     tfPswd.text = sDefUsrPswdTxt;
     }
     [self setNamePswdTxtColor];
     [self changePasswordTextfieldStyle];
     */
}

- (IBAction)onPasswordChanged:(id)sender
{
    /*
     if ([PubFunction stringIsNullOrEmpty:tfPswd.text] )
     {
     tfPswd.text = sDefUsrPswdTxt;
     }
     [self setNamePswdTxtColor];
     [self changePasswordTextfieldStyle];
     */
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	
	iTblRowCnt = 0;
	int nAllCnt = (int)[self.aryAccountList count];
	if (iListStyle == EJYEXShowAll)
	{
		iTblRowCnt = nAllCnt;
	}
	else if (iListStyle == EJYEXShowFilter)
	{
		if ([PubFunction stringIsNullOrEmpty:m_txfCounter.text])
		{
			iTblRowCnt = nAllCnt;
		}
		else
		{
			int n = 0;
			for (int i = 0; aryAccountList && i<[aryAccountList count]; i++)
			{
				TLoginUserInfo* user = [aryAccountList objectAtIndex:i];
				NSRange pos = [user.sUserName rangeOfString:m_txfCounter.text options:NSLiteralSearch];
				if (pos.location == 0)
				{
					n ++;
				}
			}
			
			iTblRowCnt = n;
		}
	}
	else
	{
		iTblRowCnt = 0;
	}
	
	return iTblRowCnt;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger index = indexPath.row;
	NSString* username = @"";
    NSInteger nPos = 0;
    
	if (iListStyle == EJYEXShowAll)
	{
		if (index < [aryAccountList count])
		{
			TLoginUserInfo* user = [aryAccountList objectAtIndex:index];
			username = user.sUserName;
            nPos = index;
		}
	}
	else if (iListStyle == EJYEXShowFilter)
	{
		if ([PubFunction stringIsNullOrEmpty:m_txfCounter.text])
		{
			if (index < [aryAccountList count])
			{
				TLoginUserInfo* user = [aryAccountList objectAtIndex:index];
				username = user.sUserName;
                nPos = index;
			}
		}
		else
		{
			int n = 0;
			for (int i = 0; aryAccountList && i<[aryAccountList count]; i++)
			{
				TLoginUserInfo* user = [aryAccountList objectAtIndex:i];
                nPos = i;
                
				NSRange pos = [user.sUserName rangeOfString:m_txfCounter.text options:NSLiteralSearch];
				if (pos.location == 0)
				{
					if (n == index)
					{
						username = user.sUserName;
						break;
					}
					else
					{
						n ++;
					}
				}
			}
		}
	}
	
    
    
    ActivityCell *cell = [ActivityCell activityCellWithTableView:tableView];
    
    NSString *strAvatar = [CommonFunc getAvatarPath:username];
    
    if ( [CommonFunc isFileExisted:strAvatar] ) { //头像存在
    }
    else {
        strAvatar = [[NSBundle mainBundle] pathForResource:@"default_login_back@2x" ofType:@"png"];
    }
    
    
    [cell setData:strAvatar title:username pos:nPos];
    [cell.btnDel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{  
	tblUserList.hidden = YES;
	ActivityCell* cell = (ActivityCell *)[tableView cellForRowAtIndexPath:indexPath];
	NSString* username = cell.lbTitle.text;
	m_txfCounter.text = username;
	[self updatePasswordByName];

    [self updateAvatar];
    
    m_btnDropList.selected = ! m_btnDropList.selected;
    [m_txfCounter resignFirstResponder];
    [m_txfPassWord resignFirstResponder];
}

- (void)btnClick:(id)sender
{
    //删除
    UIButton *btn = (UIButton *)sender;
    NSInteger npos = btn.tag - 1000;
    
    TLoginUserInfo* user = [aryAccountList objectAtIndex:npos];
    NSString *username = user.sUserName;
    [AstroDBMng deleteLoginUserByUserName:username];
    
    
    [self initAccountList];
    [tblUserList reloadData];
    [self changeUserTableHeight];
    
    if ( [username isEqualToString:m_txfCounter.text] ) {
        m_txfCounter.text = @"";
        m_txfPassWord.text = @"";
    }
}


- (IBAction)onRegister:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMJYEXRegister :0 :1 :[MsgParam param:self :@selector(updateUIByRegister:) :nil :0]];
}

- (void)updateUIByRegister:(NSDictionary*)dic
{
    NSString *strUser ;
    NSString *strPassWord ;
    
    if( !dic ) return  ;
    
    strUser = [dic objectForKey:@"Counter"] ;
    strPassWord = [dic objectForKey:@"PassWord"] ;
    
    if( strUser != nil && strPassWord != nil )
    {
        m_txfCounter.text = strUser ;
        m_txfPassWord.text = strPassWord ;
    }
}


@end
