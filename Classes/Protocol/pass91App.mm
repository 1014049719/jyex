//
//  pass91AppDelegate.m
//  pass91
//
//  Created by Qiliang Shen on 09-8-4.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "pass91App.h"
#import "P91PassDelegate.h"
#import "Logger.h"

@implementation pass91App

@synthesize navigationController,delegate,loginCtr;

- (id)initWithNavigationController:(UINavigationController*)ngController target:(id)obj
{   
	if(self=[super init]){
		self.navigationController=ngController;
		self.delegate=obj;
		//init and add navigation bar
	}
	return self;
}

-(void)gotoLoginPage
{
	self.loginCtr=[[RootViewController alloc] init];
	self.loginCtr.delegate=self.delegate;
	[self.navigationController pushViewController:self.loginCtr animated:YES];
	//[loginCtr release];
}

- (void)dealloc 
{
	[loginCtr release];
	[navigationController release];
	//[delegate release];
    [super dealloc];
}


@end
