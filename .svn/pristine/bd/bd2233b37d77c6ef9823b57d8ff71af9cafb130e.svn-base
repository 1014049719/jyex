//
//  PPScrollmenu.h
//  test2
//
//  Created by chen wu on 09-10-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPScrollmenuItem.h"


@protocol PPScrollmenuDelegate;

@interface PPScrollmenu : UIView <UIScrollViewDelegate,PPScrollmenuItemDelegate>{
@private	
	UIScrollView * _backgroundView;
	NSMutableArray *_items;
	PPScrollmenuItem *_selectedItem;
@public 
	id<PPScrollmenuDelegate> delegate;
}
- (void)disSelected;
@property(nonatomic,retain) NSMutableArray * items;
@property(nonatomic,assign) id<PPScrollmenuDelegate> delegate;
@end


@protocol PPScrollmenuDelegate<NSObject>

-(void)PPScrollmenu:(PPScrollmenu *)menu didSelectdItem:(PPScrollmenuItem *)menuItem atIndex:(NSInteger) index;

@end