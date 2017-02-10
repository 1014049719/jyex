//
//  PSettingViewController.m
//  pass91
//
//  Created by Zhaolin He on 09-8-5.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PSettingViewController.h"
#import "PRegisterViewController.h"
//#import "PGetpassViewController.h"
#import "PSystemParamController.h"
#import "PMoreViewController.h"

static PSettingViewController *me=nil;
@implementation PSettingViewController
@synthesize delegate;
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init
{
    if (self = [super init]) 
	{
		self.navigationItem.title=[NSLocalizedString(@"system_setting",nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // Custom initialization
		tabBar=[[UITabBarController alloc] init];
		tabBar.delegate=self;
		
		PRegisterViewController *regController=[[PRegisterViewController alloc] init];
		regController.delegate=self.delegate;
		//PMoreViewController *moreViewController=[[PMoreViewController alloc] init];
		PSystemParamController *sysParamController=[[PSystemParamController alloc] init];
		
		tabBar.viewControllers=[NSArray arrayWithObjects:sysParamController,regController,nil];//,moreViewController,nil];
		[regController release];
		[sysParamController release];//[moreViewController release];
        [tabBar view].frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
		[self.view addSubview:[tabBar view]];
		
		me=self;
    }
    return self;
}

+(id)sharedSettingController
{
	return me;
}

-(void)createRightBarButtonWithTarget:(id)target
{
	UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"hide_keyboard",nil) style:UIBarButtonItemStyleDone target:target action:@selector(hideKeyBoard)];
	self.navigationItem.rightBarButtonItem=right;
	[right release];
}

-(void)removeRightBarButton
{
	self.navigationItem.rightBarButtonItem=nil;
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

#pragma mark <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	switch ([tabBarController selectedIndex]) 
	{
		case 0:
			self.navigationItem.title=[NSLocalizedString(@"system_setting",nil) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			break;
		case 1:
			self.navigationItem.title=NSLocalizedString(@"regist_title",nil);
			break;
		case 2:
			self.navigationItem.title=NSLocalizedString(@"more_tab_title",nil);
			[[PMoreViewController sharedMoreController] loadPage];
			break;
		default:
			break;
	}
}

- (void)dealloc 
{
	MLOG(@" >>> >>> dealloc setting >>> >>> ");
	[tabBar release];
    [super dealloc];
	MLOG(@" >>> >>> dealloc setting success >>> >>> ");
}

@end
