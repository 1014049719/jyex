//
//  NoteLogin.m
//  NoteBook
//
//  Created by mwt on 12-11-6.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//


#import "PubFunction.h"
#import "NoteLogin.h"
#import "UIAstroAlert.h"
#import "GlobalVar.h"
#import "BussMng.h"
#import "DataSync.h"
#import "BizLogicAll.h"
#import "UIImage+Scale.h"
#import "CommonDefine.h"


@implementation NoteLogin

@synthesize aryAccountList;
@synthesize bussMng;
@synthesize msgParam;


- (void) dealloc 
{
    [UIAstroAlert infoCancel];
	
	[bussMng cancelBussRequest];
	self.bussMng = nil;	
	self.msgParam = nil;
    
    [activityIndicator release];
    
    [self.aryAccountList removeAllObjects];
    self.aryAccountList = nil;
        
    SAFEREMOVEANDFREE_OBJECT(m_txfCounter);
    SAFEREMOVEANDFREE_OBJECT(m_txfPassWord);
    SAFEREMOVEANDFREE_OBJECT(m_btnRemberPW);
    SAFEREMOVEANDFREE_OBJECT(m_btnLogin);
    SAFEREMOVEANDFREE_OBJECT(m_btnRegister);     
    SAFEREMOVEANDFREE_OBJECT(m_viCounter);
    SAFEREMOVEANDFREE_OBJECT(m_btnCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnFullScreen);
    SAFEREMOVEANDFREE_OBJECT(m_btnDropList);
    SAFEREMOVEANDFREE_OBJECT(tblUserList);

    [super dealloc];
}

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
    // Do any additional setup after loading the view from its nib.
    m_txfCounter.delegate = self;
    m_txfPassWord.delegate = self;
    
    tblUserList.delegate = self;
	tblUserList.dataSource = self;
	[self initAccountList];
	iListStyle = EShowAll;
    
    [self DrawView];
    
    //load current user;    
	if (TheCurUser && ![TheCurUser isDefaultUser])
	{
		m_txfCounter.text = TheCurUser.sUserName;
		
		if (!TheCurUser.iSavePasswd)
		{
			m_txfPassWord.text = @"";
            m_btnRemberPW.selected = NO;
        }
		else
		{
			m_txfPassWord.text = TheCurUser.sPassword;
            m_btnRemberPW.selected = YES;
            bClearPassword = YES;
		}
	}
	else
	{
		m_btnRemberPW.selected = YES;
		m_txfCounter.text = @"";
		m_txfPassWord.text = @"";
	}

    CGRect rect;
    rect.size.width = 25;
    rect.size.height = 25;
    rect.origin.x = m_btnLogin.frame.origin.x + m_btnLogin.frame.size.width /2 + 20;
    rect.origin.y = m_btnLogin.frame.origin.y + m_btnLogin.frame.size.height/2 - rect.size.height/2;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    //[activityIndicator setCenter:opaqueview.center];
    //[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activityIndicator];
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

-(IBAction)OnRemberPassWord:(id)sender
{
    //记住密码
    m_btnRemberPW.selected = !m_btnRemberPW.selected;
}


-(IBAction)OnUnLogin:(id)sender
{
   //取消 
   [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    
    if ( loginOk ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:@"登录成功" userInfo:nil];
    }

	TBussStatus* sts = [[TBussStatus new] autorelease];
	sts.iCode = loginOk ? 1 : 0;
	if (msgParam!=nil)
		[msgParam.obsv performSelector:msgParam.callback withObject:sts afterDelay:1.0];
    
}



-(IBAction)OnLogin:(id)sender
{
  
   //登录
  /*  
   TAUapNormalLoginParam *user = [self checkManualNormalLogin];
    if(NULL == user){
        return;
    }
    [TAUapLogin loginWithNormal:user sync:YES  delegate:self];
    [self OnBtnFullScreen:nil];
    */
    
    if ( m_btnLogin.selected ) return;
	
	TParamLogin* param = [[TParamLogin new] autorelease];
	
	//check 
	if ([PubFunction stringIsNullOrEmpty:m_txfCounter.text])
	{
		[UIAstroAlert info:@"用户名不能为空" :2.0 :NO :LOC_MID :NO];
		return;
	}
	else 
		param.user = m_txfCounter.text;
	
	if ([PubFunction stringIsNullOrEmpty:m_txfPassWord.text])
	{
        [UIAstroAlert info:@"密码不能为空" :2.0 :NO :LOC_MID :NO];
		return;
	}
	else 
		param.pswd = m_txfPassWord.text;
    
    param.remPswd = m_btnRemberPW.selected;
	
	[self OnBtnFullScreen:nil];

	
    //[UIAstroAlert info:@"正在登录，请稍候" :YES :NO];//一直遮住
    [activityIndicator startAnimating];
    activityIndicator.hidden = NO;
 
    m_btnCancel.enabled = NO;
    m_btnLogin.selected = YES;
    
	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMLogin];
	[bussMng request:self :@selector(loginCallback:) :param];    
    
}


-(IBAction)OnRegister:(id)sender
{
    [self OnBtnFullScreen:nil];
    
}


- (void) registerClose:(TParamRegister*)param
{
    if (param!=nil)
    {
        m_txfCounter.text = param.user;
        m_txfPassWord.text = param.pswd;
    }
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
	[bussMng cancelBussRequest];
	self.bussMng = nil;
	
    [UIAstroAlert infoCancel];
    
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    m_btnLogin.selected = NO;
    m_btnCancel.enabled = YES;
    
	if (sts==nil || sts.iCode == 200)
	{
        //[UIAstroAlert info:@"登录成功" :2.0 :NO :LOC_MID :NO];
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:@"登录成功" userInfo:nil];
        
        loginOk = YES;
        
        //[self OnUnLogin:nil];
        [self performSelector:@selector(OnUnLogin:) withObject:nil afterDelay:1.0];
	}
	else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
}



- (void)login91Note
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMLogin91Note];
	[bussMng request:self :@selector(login91NoteCallback:) :nil];    
    
}

- (void)login91NoteCallback:(TBussStatus*)sts
{
	[bussMng cancelBussRequest];
	self.bussMng = nil;
	
    [UIAstroAlert infoCancel];
    
	if (sts==nil || sts.iCode == 200)
	{
		[UIAstroAlert info:@"登录成功" :2.0 :NO :LOC_MID :NO];
        
        TLoginUserInfo *loginUserInfo = [[TLoginUserInfo new] autorelease];
        [BizLogic procLoginSuccess:loginUserInfo];
	}
	else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
}



/*
- (void)logout91Note
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMLogout91Note];
	[bussMng request:self :@selector(logout91NoteCallback:) :nil];    
    
}

- (void)getUserInfo
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMGetUserInfo];
	[bussMng request:self :@selector(noteCallback:) :nil];    
}

- (void)downdir
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMDownDir];
	[bussMng request:self :@selector(noteCallback:) :nil];
}

- (void)getlatestnote
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMGetLatestNote];
	[bussMng request:self :@selector(noteCallback:) :nil];
}


- (void)downnotelist
{
   	[bussMng cancelBussRequest];
	self.bussMng = [BussMng bussWithType:BMDownNoteList];
	[bussMng request:self :@selector(noteCallback:) :nil];
}


- (void)noteCallback:(TBussStatus*)sts
{
	[bussMng cancelBussRequest];
	self.bussMng = nil;
	
    [UIAstroAlert infoCancel];
    
	if (sts==nil || sts.iCode == 200)
	{
		[UIAstroAlert info:LOC_STR("lg_drcg") :2.0 :NO :LOC_MID :NO];
	}
	else
	{
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
}
*/


/*
-(void)saveLoginResult4Logout:(NSDictionary*)dictLoginResult{
    NSString *uid = [dictLoginResult objectForKey:@"uid"];
    if(NULL != uid){
        //tfOutUID.text = uid;
    }
    NSString *sid = [dictLoginResult objectForKey:@"sid"];
    if(NULL != sid){
        //tfOutSID.text = sid;
    }
}

//共通模块登录的回调
#pragma mark -
#pragma mark TACUapLogin delegate
-(void) UapLoginDidLoginWithResult : (NSDictionary*)dictLoginResult{
    
    [self performSelectorOnMainThread:@selector(saveLoginResult4Logout:)
                           withObject:dictLoginResult
                        waitUntilDone:YES];
    
    //
    [UIAstroAlert info:[dictLoginResult description] :5.0 :NO :LOC_MID :NO];
    
    
    //NSMutableString *loginRet = [[NSMutableString alloc]init];
    //MARK_AUTORELEASE_OBJ(loginRet);
    //[loginRet setString:[dictLoginResult description]];
    
    //[self openUserConfirmAlertWithTitle:@"login!" 
                                message:loginRet 
                     confirmButtonTitle:@"ok"
                           replaceExist:NO];
    
}

-(void) UapLoginDidFailToLoginWithError : (NSDictionary*)dictLoginResult{
    
    //[self openSimpleAlertWithString:[dictLoginResult objectForKey:@"reason"]];
    [UIAstroAlert info:[dictLoginResult objectForKey:@"reason"] :5.0 :NO :LOC_MID :NO];
}

#pragma mark -
#pragma mark TACUapLogout delegate
-(void) UapLogoutDidLogout{
    //[self openSimpleAlertWithString:@"登出成功"];
    [UIAstroAlert info:@"登出成功" :5.0 :NO :LOC_MID :NO];
}
-(void) UapLogoutDidFailToLogoutWithError : (NSString*)failReason{
    //[self openSimpleAlertWithString:failReason];
    [UIAstroAlert info:failReason :5.0 :NO :LOC_MID :NO];
}
*/




-(void) DrawView
{   
    UIImage *ViewCounterBk = [UIImage imageNamed:@"DengLuYeShuRuKuang.png"];
    [self->m_viCounter setImage:[ViewCounterBk stretchableImageWithLeftCapWidth:10 topCapHeight:5] ];
    
    UIImage *LoginBk = [UIImage imageNamed:@"note_btn_login_nor.png"];
    UIImage *LoginSel = [UIImage imageNamed:@"note_btn_login_sel.png"];
    [self->m_btnLogin setBackgroundImage:[LoginBk stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
    [self->m_btnLogin setBackgroundImage:[LoginSel stretchableImageWithLeftCapWidth:10 topCapHeight:5]  forState:UIControlStateHighlighted];
    [self->m_btnLogin setBackgroundImage:[LoginSel stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateSelected];
    
    
    UIImage *RegisterBk = [UIImage imageNamed:@"note_btn_reg_nor.png"];
    UIImage *RegisterSel = [UIImage imageNamed:@"note_btn_reg_nor.png"];
    [self->m_btnRegister setBackgroundImage:[RegisterBk stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
    [self->m_btnRegister setBackgroundImage:[RegisterSel stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
}


//用户处理
-(void)initAccountList
{
	[aryAccountList removeAllObjects];
	self.aryAccountList = [AstroDBMng getLoginUserList];
    if ( [aryAccountList count] < 1 ) m_btnDropList.hidden = YES;
    else m_btnDropList.hidden = NO;
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
                if ( user.iSavePasswd ) {
                    m_btnRemberPW.selected = YES;
                    m_txfPassWord.text = user.sPassword;
                    bClearPassword = YES;
                }
                else {
                    m_btnRemberPW.selected = NO;
                    m_txfPassWord.text = @"";
                }
                return;
            }
        }
    }
    
    if ( bClearPassword  ) {
        bClearPassword = NO;
        m_txfPassWord.text = @"";
        m_btnRemberPW.selected = YES;
    }
}


-(void)changeUserTableHeight
{
	int maxH = 120;
	int rowCnt = [tblUserList numberOfRowsInSection:0];
	if (rowCnt <= 0)
	{
		tblUserList.hidden = YES;
        return;
	}
	
	CGRect rctTbl = tblUserList.frame;
    
	int rowH = [tblUserList rowHeight];
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
	iListStyle = EShowAll;
	tblUserList.hidden = NO;
	[tblUserList reloadData];
	[self changeUserTableHeight];
}


- (IBAction) onUserNameEditing: (id)sender
{
	//NSLog(@"onUserNameEditing: %@", tfUser.text);
	iListStyle = EShowFilter;
	tblUserList.hidden = NO;
	
	[tblUserList reloadData];
	[self changeUserTableHeight];
	[self updatePasswordByName];
}

- (IBAction)onUserNameEditingBegin:(id)sender
{
	iListStyle = EShowFilter;
	tblUserList.hidden = NO;
	[tblUserList reloadData];
	[self changeUserTableHeight];
}

- (IBAction)onUserNameEditingEnd:(id)sender
{
    tblUserList.hidden = YES;
    /*
     if ([PubFunction stringIsNullOrEmpty:tfUser.text] )
     {
     tfUser.text = sDefUsrNameTxt;
     }
     */
    
	//[self updatePasswordByName];
    
}

- (IBAction)onUserNameChanged:(id)sender
{
    /*
     if ([PubFunction stringIsNullOrEmpty:tfUser.text] )
     {
     tfUser.text = sDefUsrNameTxt;
     }
     */
	
	[self updatePasswordByName];
}

- (IBAction)onPasswordEditingBegin:(id)sender
{
    /*
     if ([tfPswd.text isEqualToString:sDefUsrPswdTxt])
     {
     tfPswd.text = @"";
     tfPswd.secureTextEntry = YES;
     }
     
     [self setNamePswdTxtColor];
     [self changePasswordTextfieldStyle];
     */
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
	int nAllCnt = [self.aryAccountList count];
	if (iListStyle == EShowAll)
	{
		iTblRowCnt = nAllCnt;
	}
	else if (iListStyle == EShowFilter)
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
    static NSString *CellTableIdentifier = @"CellTableIdentifier_AccntList ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
	
	NSInteger index = indexPath.row;
	NSString* username = @"";
    
	if (iListStyle == EShowAll)
	{
		if (index < [aryAccountList count])
		{
			TLoginUserInfo* user = [aryAccountList objectAtIndex:index];
			username = user.sUserName;
		}
	}
	else if (iListStyle == EShowFilter)
	{
		if ([PubFunction stringIsNullOrEmpty:m_txfCounter.text])
		{
			if (index < [aryAccountList count])
			{
				TLoginUserInfo* user = [aryAccountList objectAtIndex:index];
				username = user.sUserName;
			}
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
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease]; 
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        CGRect rect = CGRectMake(0,0,44,260);
        CGSize size = CGSizeMake(44,260);
        UIImageView *backView = [[UIImageView alloc] initWithFrame:rect];
        backView.image = [[UIImage imageNamed:@"cell.png"] scaleToRect:size];
        cell.backgroundView = backView; 
        [backView release];
        
        UIView *selectBkView = [[UIView alloc] initWithFrame:rect];
        selectBkView.backgroundColor = [UIColor blackColor];
        cell.selectedBackgroundView = selectBkView;
        [selectBkView release];
        
        UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 44, 44);
        btnDel.frame = frame;
        [btnDel setImage:[UIImage imageNamed:@"btn_Delete.png"] forState:nil];
        btnDel.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
        btnDel.adjustsImageWhenHighlighted = YES;
        [btnDel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnDel.tag = index;
        cell.accessoryView= btnDel;
	}
	else  //重新设置tag
    {
        cell.accessoryView.tag = index;
    }
    
	cell.textLabel.text = username; 
    cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{  
	tblUserList.hidden = YES;
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString* username = cell.textLabel.text;
	m_txfCounter.text = username;
	[self updatePasswordByName];
    if (m_btnRemberPW.selected ) {
        [m_txfCounter resignFirstResponder];
        [m_txfPassWord resignFirstResponder];
        bClearPassword = YES;
    }
    else
    {
        [m_txfPassWord becomeFirstResponder];
    }
}

- (void)btnClick:(id)sender
{
    //删除
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSString *username = cell.textLabel.text;
    [AstroDBMng deleteLoginUserByUserName:username];

    [self initAccountList];
    [tblUserList reloadData];
    [self changeUserTableHeight];
    
    if ( [username isEqualToString:m_txfCounter.text] ) {
        m_txfCounter.text = @"";
        m_txfPassWord.text = @"";
        m_btnRemberPW.selected = YES;
    }
}


@end
