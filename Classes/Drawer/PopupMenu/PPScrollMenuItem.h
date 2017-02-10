//
//  PPScrollmenuItem.h
//  test2
//
//  Created by chen wu on 09-10-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPScrollmenuItemDelegate;

@interface PPScrollmenuItem : UIView{
@private	
	UIImage * _icon;
	BOOL	_selected;
	UIColor	* _contentColor;
@public
	id<PPScrollmenuItemDelegate> delegate;
}
@property(nonatomic,retain) UIImage * iconImage;
@property(nonatomic) BOOL selected;
@property(nonatomic,retain) UIColor * contentColor;
@property(nonatomic,assign)id<PPScrollmenuItemDelegate> delegate;
@end

@protocol PPScrollmenuItemDelegate <NSObject>
@optional
-(void)PPScrollmenuItem:(PPScrollmenuItem *) menuItem contentColor:(UIColor *)color;

@end
