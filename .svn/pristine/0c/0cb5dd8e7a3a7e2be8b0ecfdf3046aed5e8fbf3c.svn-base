//
//  CameraOverlayView.h
//  ARmarket
//
//  Created by Boguslaw Parol on 20.05.2012.
//  Copyright (c) 2012 mWorldApps.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CameraOverlayViewDelegate <NSObject>

- (void)didCancel;

@end


@interface CameraOverlayView : UIView<UIGestureRecognizerDelegate>{

    NSObject<CameraOverlayViewDelegate> *_delegate;
    
    UIToolbar *_toolbar;
    //UIToolbar *_othertoolbar;
    
    UISlider *_zoomSlider;
    UIImagePickerController *_picker;
 
    //UIImageView *_sunImageView;
    //UIImage *_image;
    
}

@property (nonatomic, assign) NSObject<CameraOverlayViewDelegate> *delegate;
@property (nonatomic, assign) UIImagePickerController *picker;

@property (nonatomic, retain)  UIToolbar *toolbar;
//@property (nonatomic, retain)  UIToolbar *othertoolbar;


@property (nonatomic, retain)  UISlider *zoomSlider;
//@property (nonatomic, retain)  UIImageView *sunImageView;
//@property (nonatomic, retain)  UIImage *image;


//- (void)camera:(id)sender;
//- (void)configure;
- (void)zoom:(id)sender;

@end
