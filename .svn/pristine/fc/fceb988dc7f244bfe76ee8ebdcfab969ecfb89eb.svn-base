//
//  UICameraOverlay.h
//  NoteBook
//
//  Created by susn on 12-11-27.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayView.h"


@protocol UICameraDelegate<NSObject>

-(void) Camera_ClickCancel;
-(void) Camera_ClickFinish:(UIImage *)image;

@end


@interface UICameraOverlay : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CameraOverlayViewDelegate,UIGestureRecognizerDelegate>

{
    NSObject<UICameraDelegate> *delegate;
 
    UIToolbar *_othertoolbar;
    UIImageView *_sunImageView;
    UIImage *_image;
}

@property (nonatomic,assign)  NSObject<UICameraDelegate> *delegate;

@property (nonatomic, retain)  UIToolbar *othertoolbar;
@property (nonatomic, retain)  UISlider *zoomSlider;
@property (nonatomic, retain)  UIImageView *sunImageView;
@property (nonatomic, retain)  UIImage *image;

- (void)initOtherToolbar;
- (void)configure;
- (void)takePhoto;


@end
