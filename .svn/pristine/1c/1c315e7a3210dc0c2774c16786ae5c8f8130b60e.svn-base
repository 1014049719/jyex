//
//  PPCustomColor.h
//  NoteBook
//
//  Created by chen wu on 09-10-21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPCustomColorDelegate;

@interface PPCustomColor : UIView {
	UIImage * image;
	UIImageView * selectionView;
	id<PPCustomColorDelegate>delegate;
}
@property (nonatomic,retain)UIImage * image;
@property (nonatomic,assign)id<PPCustomColorDelegate>delegate;

- (void)disSelected;
@end


@protocol  PPCustomColorDelegate<NSObject>
@optional
- (void)PPCustomColorDelegate:(PPCustomColor *) cus deSelectedColor:(UIColor *)color;
- (void)PPCustomColorDelegate:(PPCustomColor *) cus willSeletedColorAtPoint:(CGPoint) pt;
@end
