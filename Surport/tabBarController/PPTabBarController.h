//
//  PPTabBarController.h
//  PPCatalog
//
//  Created by chen wu on 09-7-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol PPTabBarControllerDelegate;
@interface PPTabBarController : UITabBarController<UITabBarControllerDelegate> {
	NSArray * _itemArr;
	NSArray * _imageArr;
	NSArray * _titleArr;
	BOOL	 _customizeFlag;
	//id<PPTabBarControllerDelegate> delegate;
}

- (id) initWithItem:(NSArray *) items title:(NSArray*)titles image:(NSArray *) images customizeAble:(BOOL) flag;
- (void) setBarStyle:(UIBarStyle) style atIndex:(int) index;// 如果Index 设置为-1 就为设置全部controller的Style
- (UIViewController *)getNavAtIndex:(int) index;
@property (nonatomic,retain)NSArray * itemArr;
@property (nonatomic,retain)NSArray * imageArr;
@property (nonatomic,retain)NSArray * titleArr;
//@property (nonatomic,assign)id<PPTabBarControllerDelegate> delegate;
@end

@protocol PPTabBarControllerDelegate <NSObject>
@optional
- (void)PPTabBar:(PPTabBarController *)tabBar didSelectItem:(UITabBarItem *)item;

- (void)PPTabBar:(PPTabBarController *)tabBar willBeginCustomizingItems:(NSArray *)items;
- (void)PPTabBar:(PPTabBarController *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;

- (void)PPTabBar:(PPTabBarController *)tabBar didBeginCustomizingItems:(NSArray *)items;
- (void)PPTabBar:(PPTabBarController *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;
@end
