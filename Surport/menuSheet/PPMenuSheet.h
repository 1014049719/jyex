//
//  PPMenuSheet.h
//  NoteBook
//
//  Created by chen wu on 09-8-13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPMenuSheetDelegate;

@interface PPMenuSheet : UIToolbar {
	id<PPMenuSheetDelegate> delegate;
	CGRect	  normalFrame;
	BOOL	showed;
}
- (void)showAboveView:(UIView *)view;
//- (void)showInView:(UIView *)view;
- (void)dismiss;
- (BOOL)hasShowed;

@property(nonatomic,assign) id<PPMenuSheetDelegate> delegate;
@end

@protocol PPMenuSheetDelegate <NSObject>
@optional
- (void)PPMenuSheetDelegate:(PPMenuSheet *)menu willDismissFromView:(UIView *)view;
- (void)PPMenuSheetDelegate:(PPMenuSheet *)menu willShowAboveView:(UIView *)view;
@end
