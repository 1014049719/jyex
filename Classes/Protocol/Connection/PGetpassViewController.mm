//
//  PGetpassViewController.m
//  pass91
//
//  Created by Zhaolin He on 09-8-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PGetpassViewController.h"
#import "PSettingViewController.h"
#import "P91PassDelegate.h"

@implementation PGetpassViewController
@synthesize realName,idCard,delegate;

- (id)init{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super init]) {
		self.title=NSLocalizedString(@"forgetPass",nil);
		self.tabBarItem.image=[UIImage imageNamed:@"getbackPass.png"];
		
		UITableView *myTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
		myTable.dataSource=self;
		myTable.delegate=self;
		self.view=myTable;
		[myTable release];
    }
    return self;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return 2;
		case 1:
			return 1;
		default:
			return 0;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
	return [[[UIView alloc] init] autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if(section==0)return 20;
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font=[UIFont systemFontOfSize:17.0];
		if(indexPath.section==0){
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text=NSLocalizedString(@"real_name",nil);
					self.realName=[[[UITextField alloc] initWithFrame:CGRectMake(120, 0, 170, 40)] autorelease];
					self.realName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.realName.placeholder=NSLocalizedString(@"realname_placeholder",nil);
					self.realName.returnKeyType=UIReturnKeyDone;
					self.realName.delegate=self;
					self.realName.clearsOnBeginEditing=NO;
					self.realName.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.realName];
					break;
				case 1:
					cell.textLabel.text=NSLocalizedString(@"id_card",nil);
					self.idCard=[[[UITextField alloc] initWithFrame:CGRectMake(120, 0, 170, 40)] autorelease];
					self.idCard.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
					self.idCard.placeholder=NSLocalizedString(@"id_placeholder",nil);
					self.idCard.keyboardType=UIKeyboardTypeNumberPad;
					self.idCard.delegate=self;
					self.idCard.clearsOnBeginEditing=NO;
					self.idCard.clearButtonMode=UITextFieldViewModeWhileEditing;
					[cell addSubview:self.idCard];
					break;
				default:
					break;
			}
		}else if(indexPath.section==1){
			cell.textLabel.textAlignment=UITextAlignmentCenter;
			cell.textLabel.text=NSLocalizedString(@"send_request",nil);
		}
		//设置是否可以点
		if(indexPath.section!=1){
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
		}
    }
    // Configure the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.section==1)
	{
		[self hideKeyBoard];
		
		int flag=rand();
		if(flag%2==0){
			MLOG(@"getpass success!");
			//exec delegate method
			if(delegate!=nil&&[delegate respondsToSelector:@selector(getBackPassDidSuccess)]){
				[delegate getBackPassDidSuccess];
			}
		}else{
			MLOG(@"getpass failed!");
			//exec delegate method
			if(delegate!=nil&&[delegate respondsToSelector:@selector(getBackPassDidFailed)]){
				[delegate getBackPassDidFailedWithError:[NSError errorWithDomain:@"failed" code:10 userInfo:nil]];
			}
		}
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController createRightBarButtonWithTarget:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController removeRightBarButton];
	return YES;
}

-(void)hideKeyBoard{
	[self.realName resignFirstResponder];
	[self.idCard resignFirstResponder];	
    
	PSettingViewController *setController=[PSettingViewController sharedSettingController];
	[setController removeRightBarButton];
}

- (void)dealloc {
	[realName release];
	[idCard release];
    [super dealloc];
}


@end

