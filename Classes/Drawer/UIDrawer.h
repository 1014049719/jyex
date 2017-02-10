//
//  UIDrawer.h
//  NoteBook
//
//  Created by susn on 12-11-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "PPCameraImagePickerCtr.h"
//#import "PPPhotoPickerCtr.h"
#import <Foundation/Foundation.h>
#import "PPDrawer.h"
#import "PPColorMenuManager.h"
//#import "PPSingleSelector.h"
#import "PPSizeMenuManager.h"
#import "Plist.h"
#import "PPTextView.h"
#import "PPMenuSheet.h"
#import "PPTimerMenuSheet.h"
#import "PPHubView.h"
#import "UIDrawerDelegate.h"


@interface UIDrawer : UIViewController<UIScrollViewDelegate,PPTextViewDeletgate,
PPDrawerDelegate/*,UIImagePickerControllerDelegate*/,UINavigationControllerDelegate,UIActionSheetDelegate,
UIAlertViewDelegate,PPMenuSheetDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIButton *m_btnNavCancel;
    IBOutlet UIButton *m_btnNavFinish;
    IBOutlet UISegmentedControl *m_segment;
    IBOutlet UIView   *m_NavView;
    
    IBOutlet UIButton *m_btnMove;
    IBOutlet UIButton *m_btnDelete;
    IBOutlet UIButton *m_btnPhoto;
    IBOutlet UIView *m_viewColorAndSize;
    IBOutlet UIView *m_viewToolbar;
    IBOutlet UIButton *m_btnColorAndSize;
    IBOutlet UIButton *m_btnEraser;
    IBOutlet UIButton *m_btnUndo;
    IBOutlet UIButton *m_btnRedo;
    IBOutlet UIView *m_viewEraserSize;
    
    IBOutlet UIButton *m_btnColor0;
    IBOutlet UIButton *m_btnColor1;
    IBOutlet UIButton *m_btnColor2;
    IBOutlet UIButton *m_btnColor3;
    IBOutlet UIButton *m_btnColor4;
    IBOutlet UIButton *m_btnColor5;
    IBOutlet UIButton *m_btnColor6;
    IBOutlet UIButton *m_btnColor7;
    IBOutlet UIButton *m_btnColor8;
    IBOutlet UIButton *m_btnColor9;
    IBOutlet UIButton *m_btnColor10;
    IBOutlet UIButton *m_btnColor11;
    
    IBOutlet UIButton *m_btnPenSize0;
    IBOutlet UIButton *m_btnPenSize1;
    IBOutlet UIButton *m_btnPenSize2;
    IBOutlet UIButton *m_btnPenSize3;
    IBOutlet UIButton *m_btnPenSize4;
    
    IBOutlet UIButton *m_btnEraserSize0;
    IBOutlet UIButton *m_btnEraserSize1;
    IBOutlet UIButton *m_btnEraserSize2;
    IBOutlet UIButton *m_btnEraserSize3;
    IBOutlet UIButton *m_btnEraserSize4;
    
    UIButton *m_btnColorArray[12];
    UIButton *m_btnPenSizeArray[5];
    UIButton *m_btnEraserSizeArray[5];
    int m_uColorIndex;
    int m_uPenSizeIndex;
    int m_uEraserSizeIndex;
    
	UIScrollView		* canvaView;
	PPDrawer			* drawer;
	//UIToolbar			* toolbar;
	//UISegmentedControl	* segment;
	//PPColorMenuManager	* colorManager;
	//UIColor				* penColor;
	//UIBarButtonItem		* saveButton;
	UIImage				* renderImage;
	NSString			* imagePath;
	BOOL				isNewState;
	BOOL				hasSave;
	CGFloat				penSize;
	CGFloat				eraserSize;
	//PPMenuSheet			* curMenu;
	//PPSizeMenuManager	* sizeManager;
	//PlistController		* pc;
	int					defaultSegmentIndex;
    //	int					myViewState;
	//PPTextView			* tv;
    
	BOOL				hasChanged;
	//NSString	* itemId ;
	//NSString	* noteId ;
	//NSString	* noteTitle;
    //	UP_STRUCT   * updata;
	UIImage		* contentImage;
	PPHubView	* hub;
    
    id<UIDrawerDelegate> delegate;
}

- (IBAction) onNavCancel :(id)sender;
- (IBAction) onNavFinish:(id)sender;
- (IBAction) segmentAction:(id)sender;
- (IBAction) onColor:(id)sender;
- (IBAction) onPenSize:(id)sender;
- (IBAction) onToolBar:(id)sender;
- (IBAction) onEraserSize:(id)sender;


- (void)initToolbarItems;
- (void)dismissViewControllerDelay:(NSNotification *)notification;
- (void)dismissViewController;
- (void) createdSegment;
- (UIImage * )getImage;
- (id) initWithImagePath:(NSString * )path title:(NSString *)aTitle state:(BOOL) isNew;
- (id) initWithImage:(UIImage *) image title:(NSString *)aTitle state:(BOOL) isNew;
- (void) saveAction;
- (void)showUploadView;

//@property(nonatomic,assign)		id<DrawerCtrDelegate> delegate;
@property(nonatomic,retain) 	UIColor	 * penColor;
@property(nonatomic,retain)		UIImage  * renderImage;
@property(nonatomic,retain)		NSString *imagePath;
@property(nonatomic)			int	     defaultSegmentIndex;
//@property(nonatomic,retain)		NSString * noteTitle;
@property(nonatomic,retain)     id<UIDrawerDelegate> delegate;

@end

