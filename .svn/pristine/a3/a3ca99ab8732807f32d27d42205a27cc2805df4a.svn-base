//
//  CImagePicker.h
//  AGImagePickerController Demo
//
//  Created by zd on 13-12-13.
//  Copyright (c) 2013年 Artur Grigor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGImagePickerController.h"

@interface CImagePicker : NSObject<AGImagePickerControllerDelegate>
{
    NSMutableArray *selectedPhotos ;
    
    id  callObject ;
    SEL callBack ;
    int maxCount ;
}
@property (nonatomic, retain) NSMutableArray *selectedPhotos ;
@property (nonatomic,assign) id callObject ;
@property (nonatomic,assign) SEL callBack ;
@property (nonatomic,assign) int maxCount ;

+ (CImagePicker*)sharedInstance ;

+ (UIImage*)fixOrientation:(UIImage *)srcImg ;

- (void)release ;

- (void)selectImage:(UIViewController*)vc ;

@end
