//
//  CameraOverlayView.h
//  ARmarket
//
//  Created by Boguslaw Parol on 20.05.2012.
//  Copyright (c) 2012 mWorldApps.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CameraOverlayViewDelegate <NSObject>

- (void)didFinished;

@end

@interface CameraOverlayView : UIView<UIGestureRecognizerDelegate>{
  
    UIToolbar *othertoolbar;
}

@property (nonatomic, assign) NSObject<CameraOverlayViewDelegate> *delegate;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;

@property (nonatomic, retain) IBOutlet UISlider *zoomSlider;

@property (nonatomic, assign) UIImagePickerController *picker;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *cameraButton;

@property (nonatomic, retain) IBOutlet UIImageView *sunImageView;



- (IBAction)camera:(id)sender;

- (void)configure;

- (IBAction)zoom:(id)sender;



@end
