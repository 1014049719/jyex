//
//  PPTabBarController.mm
//  PPCatalog
//
//  Created by chen wu on 09-7-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPTabBarController.h"

#import "RecentNoteListCtr.h"
#import "CateViewCtr.h"

@implementation PPTabBarController
@synthesize itemArr = _itemArr, imageArr = _imageArr,titleArr = _titleArr;

- (id) initWithItem:(NSArray *) items title:(NSArray*)titles image:(NSArray *) images customizeAble:(BOOL) flag
{
	if(self = [super init]){
		if([items count] != [titles count])
			MLOG(@"PPTabBarControllor param err!!");
		_itemArr = [items copy];
		_titleArr= [titles copy];
		_imageArr= [images copy];
		_customizeFlag = flag;
		self.delegate = self;
		
		NSMutableArray * arr = [[NSMutableArray alloc] init];
		for(int i = 0 ; i < [_itemArr count] ; i++)
		{
			
			UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[_itemArr objectAtIndex:i]];
			UITabBarItem * tabItem = [[UITabBarItem alloc] initWithTitle:[_titleArr objectAtIndex:i] image:[_imageArr objectAtIndex:i] tag:i+1];
			
			nav.tabBarItem = tabItem;
			
			//[nav.tabBarItem initWithTitle:[_titleArr objectAtIndex:i] image:[_imageArr objectAtIndex:i] tag:0];
			[arr addObject:nav];
			[tabItem release];
			[nav release];
		}
		//[self setViewControllers:arr animated:NO];
		self.viewControllers = arr;
		[arr release];
		if(_customizeFlag)
			self.customizableViewControllers = arr;
		else
			self.customizableViewControllers = nil;
	}
	return self;
}
- (UIViewController *)getNavAtIndex:(int) index
{
	NSAssert(index < [self.viewControllers count],@"invalid index");
	return [self.viewControllers objectAtIndex:index];
}
- (void) setBarStyle:(UIBarStyle) style atIndex:(int) index
{
	if(index == -1)
	{
		for(UIViewController * ctr in _itemArr)
		{
			ctr.navigationController.navigationBar.barStyle = style;
		}
		self.moreNavigationController.navigationBar.barStyle = style;
	}else{
		NSAssert(index>0 && index < [_itemArr count],@"Invalid  index");
		[((UIViewController *)[_itemArr objectAtIndex:index]).navigationController.navigationBar setBarStyle:style];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	NSUInteger index = [self.viewControllers indexOfObject:viewController];
	if (index == 1)
	{
		RecentNoteListCtr *rnlc = (RecentNoteListCtr *)viewController;
		[rnlc refreshData];
	}
	else if (index == 2)
	{
		CateViewCtr *cvc = (CateViewCtr *)viewController;
		[cvc refreshData];
	}
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	//if(delegate!= nil && [delegate respondsToSelector:@selector(PPTabBar: didSelectItem:)])
		//[delegate PPTabBar:self didSelectItem:item];
	NSUInteger index = [self.tabBar.items indexOfObject:item];
	
	if (index == 1)
	{
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:nRefreshNoteNew object:nil];
	}
	else if (index == 2)
	{
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:nRefreshNoteCate object:nil];
	}
}
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items{
	//if(delegate !=nil&&[delegate respondsToSelector:@selector(PPTabBar: willBeginCustomizingItems:)])
		//[delegate PPTabBar:self willBeginCustomizingItems:items];
}

- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items{
	//if(delegate != nil&&[delegate respondsToSelector:@selector(PPTabBar: didBeginCustomizingItems:)])
		//[delegate PPTabBar:self didBeginCustomizingItems:items];
}

- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
	//if(delegate!= nil&&[delegate respondsToSelector:@selector( PPTabBar: willEndCustomizingItems: changed:)])
		//[delegate PPTabBar:self willEndCustomizingItems:items changed:changed];
}

- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
	//if(delegate!=nil && [delegate respondsToSelector:@selector(PPTabBar: didEndCustomizingItems :changed:)])
		//[delegate PPTabBar:self didEndCustomizingItems:items changed:changed];
}
@end

