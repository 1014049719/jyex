//
//  PSettingController.m
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

@implementation PSystemParamController
@synthesize isPassKeeped;
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

-(void)setPassKeeped{
	if(isPassKeeped.on){
		[PFunctions setSavedState:@"YES"];
	}else {
		[PFunctions setSavedState:@"NO"];
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
			return 1;
		case 1:
			return 2;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.font=[UIFont systemFontOfSize:17];
		//是否保存密码
		NSString *keep=[PFunctions getSavedState];
		//fill text
		if(indexPath.section==0){
			switch (indexPath.row) {
				case 0:
					cell.text=NSLocalizedString(@"keepPass",nil);
					self.isPassKeeped=[[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)] autorelease];
					if([keep isEqualToString:@"YES"]){
						[isPassKeeped setOn:YES];
					}else{
						[isPassKeeped setOn:NO];
					}
					[self.isPassKeeped addTarget:self action:@selector(setPassKeeped) forControlEvents:UIControlEventValueChanged];
					[cell addSubview:self.isPassKeeped];
					break;
				default:
					break;
			}
			
		}else if(indexPath.section==1){
			switch (indexPath.row) {
				case 0:
					cell.text=NSLocalizedString(@"check_update",nil);
					break;
				case 1:
					cell.text=NSLocalizedString(@"aboutButton",nil);
					break;
				default:
					break;
			}
		}
	}
    // Configure the cell
    return cell;
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
			return 20;
		default:
			return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 1;
}

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
		UIViewController *targetViewController;
		switch (indexPath.row)
		{
			case 0:
				targetViewController=[[PUpdateController alloc] init];
				[[[PSettingViewController sharedSettingController] navigationController] pushViewController:targetViewController animated:YES];
				[targetViewController release];
				break;
			case 1:
				targetViewController=[[PAboutController alloc] init];
				[[[PSettingViewController sharedSettingController] navigationController] pushViewController:targetViewController animated:YES];
				[targetViewController release];
				break;
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

- (void)dealloc {
	[isPassKeeped release];
    [super dealloc];
}


@end

