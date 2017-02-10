//
//  DrawerCtr.h
//  NoteBook
//
//  Created by chen wu on 09-7-20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
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

//#import "NoteSaveDelegate.h"

@interface DrawerCtr : UIViewController<UIScrollViewDelegate,PPTextViewDeletgate,
PPDrawerDelegate/*,UIImagePickerControllerDelegate*/,UINavigationControllerDelegate,UIActionSheetDelegate,
UIAlertViewDelegate,PPMenuSheetDelegate, UIImagePickerControllerDelegate>
{
	UIScrollView		* canvaView;
	PPDrawer			* drawer;
	UIToolbar			* toolbar;
	UISegmentedControl	* segment;
	PPColorMenuManager	* colorManager;
	UIColor				* penColor;
	UIBarButtonItem		* saveButton;
	UIImage				* renderImage;
	NSString			* imagePath;
	BOOL				isNewState;
	BOOL				hasSave;
	CGFloat				penSize;
	CGFloat				eraserSize;
	PPMenuSheet			* curMenu;
	PPSizeMenuManager	* sizeManager;
	PlistController		* pc;
	int					defaultSegmentIndex;
//	int					myViewState;
	PPTextView			* tv;

	BOOL				hasChanged;
	NSString	* itemId ;
	NSString	* noteId ;
	NSString	* noteTitle;
//	UP_STRUCT   * updata;
	UIImage		* contentImage;
	PPHubView	* hub;
}

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
@property(nonatomic,retain)		NSString * noteTitle;
@end
