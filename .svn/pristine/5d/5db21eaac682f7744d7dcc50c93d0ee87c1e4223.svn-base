//
//  PPDrawer.h
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerList.h"
#import "PPUndoManager.h"
@class	  DrawerLabel;
@protocol PPDrawerDelegate;
@interface PPDrawer : UIView {
	CGPoint				location;
	CGPoint				previousLocation;
	CGBlendMode			blendMode;
	CGContextRef		bitMapContext;
	CGContextRef		backgroundContext;
	bool				firstTouch;
	//DrawerLabel			*waterMarkLabel;
	id<PPDrawerDelegate> delegate;
	UIColor				*cavasColor;
	UIColor				*penColor;
	CGFloat				penSize;
	CGRect				normalRect;
	UIImageView			*selectionView;
	bool				haveBackSource;//是否有背景资源
@private	
	PPUndoManager		*undoManager;
	NSMutableArray		*drawerList;
	CALayer				*drawLayer;
}

@property(nonatomic,retain)NSMutableArray		*drawerList;
@property(nonatomic,assign)id<PPDrawerDelegate> delegate;
@property(nonatomic,retain)PPUndoManager		*undoManager;
@property(nonatomic,retain) CALayer				*drawLayer;
- (UIImage * )getImage;
- (void) renderCanvas:(BOOL)includeBackground;
- (BOOL) canRedo;
- (BOOL) canUndo;
- (BOOL) undoAction;
- (BOOL) redoAction;
- (void) resetCanvas;
- (void) setBlendMode:(CGBlendMode)mode; 
- (void) setPenColor:(UIColor *) color;
- (void) setPenSize:(CGFloat) size;
- (void) setBackImage:(UIImage *)image;
- (void) setCanvasColor:(UIColor *) color;
//- (void) setWaterMark:(NSString *) mark;
- (int)  saveDataToPath:(NSString *)filePath EncryptType:(int)encryptFlag Password:(NSString *)password;
//- (NSString *)getMarkText;
- (id) initWithFrame:(CGRect)frame andFile:(NSString *) path;
- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image;
@end


@protocol PPDrawerDelegate<NSObject>
@optional
-(void) PPDrawer:(PPDrawer *) drawer didBeginDraw:(CGPoint) point;
-(void)	PPDrawer:(PPDrawer *) drawer didMoveToPoint:(CGPoint) point;
-(void) PPDrawer:(PPDrawer *) drawer didEndDraw:(CGPoint) point;
@end
