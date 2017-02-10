//
//  PSettingController.mm
//  pass91
//
//  Created by Zhaolin He on 09-8-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PSystemParamController.h"
#import "PAboutController.h"
#import "PUpdateController.h"
#import "PSettingViewController.h"
#import "PFunctions.h"
#import "AboutViewCtr.h"

@implementation PSystemParamController
@synthesize isPassKeeped,isLoginKeeped;
- (id)init
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super init]) {
		UITableView *myTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
		myTable.dataSource=self;
		myTable.delegate=self;
		myTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"/Resource/Image/ar-brushed_background.png"]];
		self.view=myTable;
		[myTable release];
		//init navigation bar
		NSString *title=NSLocalizedString(@"set_label",nil);
		self.title=title; 
		
		self.tabBarItem.image=[UIImage imageNamed:@"Resource/Skin/en_tools_settings.png"];
    }
    return self;
}

// 密码保存关闭，则自动登录无法操作。开启无影响。
-(void)setPassKeeped{
	if(isPassKeeped.on){
		isLoginKeeped.enabled = YES;
		[PFunctions setSavedState:@"YES"];
	}else {
		[PFunctions setSavedState:@"NO"];
		
		//isLoginKeeped.on = NO;
		isLoginKeeped.enabled = NO;
		//[PFunctions setLoginKeepState:@"NO"];
	}
}

// 自动登录开启，密码保持开启、关闭无影响。
-(void)setLoginKeeped{
	if(isLoginKeeped.on){
		[PFunctions setLoginKeepState:@"YES"];
		
		//isLoginKeeped.enabled = YES
		//isPassKeeped.on = YES;
		//[PFunctions setSavedState:@"YES"];
	}else {
		[PFunctions setLoginKeepState:@"NO"];
	}
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
			//return 2;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font=[UIFont systemFontOfSize:17];
		//是否保存密码
		NSString *keep=[PFunctions getSavedState];
		NSString *login=[PFunctions getLoginKeepState];
		//fill text
		if(indexPath.section==0){
			switch (indexPath.row) {
				case 0:
				{
					cell.textLabel.text=NSLocalizedString(@"keepPass",nil);
					self.isPassKeeped=[[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)] autorelease];
					if([keep isEqualToString:@"YES"]){
						[isPassKeeped setOn:YES];
					}else{
						[isPassKeeped setOn:NO];
					}
					[self.isPassKeeped addTarget:self action:@selector(setPassKeeped) forControlEvents:UIControlEventValueChanged];
					[cell addSubview:self.isPassKeeped];
				}
					break;
				case 1:
				{
					cell.textLabel.text=NSLocalizedString(@"keepLogin",nil);
					self.isLoginKeeped=[[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)] autorelease];
					if([login isEqualToString:@"YES"]){
						[isLoginKeeped setOn:YES];
					}else{
						[isLoginKeeped setOn:NO];
					}
					// when keep pass is no ,关联login can not push button
					if ([keep isEqualToString:@"NO"])
					{
						isLoginKeeped.enabled = NO;
					}
					
					[self.isLoginKeeped addTarget:self action:@selector(setLoginKeeped) forControlEvents:UIControlEventValueChanged];
					[cell addSubview:self.isLoginKeeped];
				}
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
					cell.textLabel.text=NSLocalizedString(@"aboutButton",nil);
//				case 0:
//					cell.text=NSLocalizedString(@"check_update",nil);
//					break;
//				case 1:
//					cell.text=NSLocalizedString(@"aboutButton",nil);
					break;
				default:
					break;
			}
		}
	}
    // Configure the cell
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *str = nil;
	
	switch (section) {
		case 0:
		{
			str = NSLocalizedString(@"you must keep pass",nil);
			break;
		}
		default:
			break;
	}
	
	return str;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//	UIView *headerView=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//	return headerView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//	UIView *headerView=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//	return headerView;
//}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	switch (section) {
		case 0:
			return 10;
		case 1:
			return 20;
		default:
			return 0;
	}
}*/
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 25;
}
*/
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:
			return UITableViewCellAccessoryNone;
		case 1:
			return UITableViewCellAccessoryDisclosureIndicator;
		default:
			return UITableViewCellAccessoryNone;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section==0)
	{
		[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:NO];
	}
	else if(indexPath.section==1)
	{
		[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
		//UIViewController *targetViewController;
		switch (indexPath.row)
		{
			case 0:
			{
				AboutViewCtr *aboutCtr = [[AboutViewCtr alloc] init];
				[[[PSettingViewController sharedSettingController] navigationController] pushViewController:aboutCtr animated:YES];
				[aboutCtr release];
				break;
				
			}	
//			case 0:
//			{
//				PVersionViewController *versionCtr = [[PVersionViewController alloc] init]; 
//				[[[PSettingViewController sharedSettingController] navigationController] pushViewController:versionCtr animated:YES];
//				[versionCtr release];
//				break;
//			}
//			case 1:
//			{
//				AboutViewCtr *aboutCtr = [[AboutViewCtr alloc] init];
//				[[[PSettingViewController sharedSettingController] navigationController] pushViewController:aboutCtr animated:YES];
//				[aboutCtr release];
//				break;
//				
//			}
			default:
				break;
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

- (void)dealloc 
{
	MLOG(@" >>> >>> dealloc PSystem >>> >>> ");
	[isPassKeeped release];
	[isLoginKeeped release];
    [super dealloc];
	MLOG(@" >>> >>> dealloc PSystem success >>> >>> ");
}


@end

