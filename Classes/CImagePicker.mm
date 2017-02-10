//
//  CImagePicker.m
//  AGImagePickerController Demo
//
//  Created by zd on 13-12-13.
//  Copyright (c) 2013年 Artur Grigor. All rights reserved.
//

#import "CImagePicker.h"
#import "AGIPCToolbarItem.h"
#import "CPictureSelected.h"
#import "UIAstroAlert.h"


@implementation CImagePicker
@synthesize selectedPhotos;
@synthesize callObject ;
@synthesize callBack ;
@synthesize maxCount ;

static CImagePicker *ImagePicker = nil ;

+ (CImagePicker*)sharedInstance
{
    if( ImagePicker == nil )
    {
        ImagePicker = [[super allocWithZone:NULL] init] ;
        ImagePicker.selectedPhotos = [NSMutableArray array] ;
        ImagePicker.maxCount = 20 ;
    }
    
    return ImagePicker ;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain] ;
}

- (id)retain
{
    return self ;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax ;
}

- (id) autorelease
{
    return self ;
}

- (void)release
{
    //NSLog( @"释放对象" ) ;
}


#pragma mark - AGImagePickerControllerDelegate methods
- (NSUInteger)agImagePickerController:(AGImagePickerController *)picker
         numberOfItemsPerRowForDevice:(AGDeviceType)deviceType
              andInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (deviceType == AGDeviceTypeiPad)
    {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
            return 7;
        else
            return 6;
    } else {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
            return 5;
        else
            return 4;
    }
}

- (BOOL)agImagePickerController:(AGImagePickerController *)picker shouldDisplaySelectionInformationInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode
{
    return (selectionMode == AGImagePickerControllerSelectionModeSingle ? NO : YES);
}

- (BOOL)agImagePickerController:(AGImagePickerController *)picker shouldShowToolbarForManagingTheSelectionInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode
{
    return (selectionMode == AGImagePickerControllerSelectionModeSingle ? NO : YES);
}

- (AGImagePickerControllerSelectionBehaviorType)selectionBehaviorInSingleSelectionModeForAGImagePickerController:(AGImagePickerController *)picker
{
    return AGImagePickerControllerSelectionBehaviorTypeRadio;
}

- (void)selectImage:(UIViewController*)vc
{
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithDelegate:[CImagePicker sharedInstance]] ;
    
    //if( imagePickerController == nil )
    //{
     //   imagePickerController = [[AGImagePickerController alloc] initWithDelegate:[CImagePicker sharedInstance]] ;
    //}
    
    imagePickerController.didFailBlock = ^(NSError *error) {
        NSLog( @"Fail. Error: %@", error ) ;
        if( error == nil )
        {
            [self.selectedPhotos removeAllObjects] ;
            NSLog( @"User has cancelled. retain count=%d",[vc retainCount]) ;
            
            [vc dismissViewControllerAnimated:YES completion:nil];
            
            // We need to wait for the view controller to appear first.
            //double delayInSeconds = 0.5;
            //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //    [vc dismissViewControllerAnimated:YES completion:nil];
            //});
        }
        else {
            
            // We need to wait for the view controller to appear first.
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [vc dismissViewControllerAnimated:YES completion:nil];
            });
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        if ([ImagePicker.callObject respondsToSelector:@selector(pictureIsCancel)] ) {
            [ImagePicker.callObject performSelector:@selector(pictureIsCancel) withObject:nil];
        }
        
    };
    
    imagePickerController.didFinishBlock = ^(NSArray *info) {
        
        /*
        if( ImagePicker.callObject != nil )
        {
            int selectcount = 0 ;
            
            if( [ImagePicker.callObject respondsToSelector:@selector(GetSelectedPictureList:)] )
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init] ;
                NSArray *array = nil ;
                [ImagePicker.callObject performSelector:@selector(GetSelectedPictureList:) withObject:dic];
                array = [dic objectForKey:@"SELECTLIST"];
                selectcount = [array count] ;
                BOOL flag ;
                for( id obj in info )
                {
                    flag = NO ;
                    for( CPictureSelected *pic in array )
                    {
                        if( pic.picAlasset == obj )
                        {
                            flag = YES ;
                        }
                    }
                    if( !flag )
                    {
                        selectcount++ ;
                    }
                }
                [dic release] ;
            }
            //控制一次上传相片的最大数量
            if( selectcount > self.maxCount )
            {
                UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"一次最多只能选%i张相片",self.maxCount] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                [alv show];
                [alv release] ;
                return ;
            }
        }
        */
        
        
        [self.selectedPhotos setArray:info];
        NSLog(@"Info: %@", info);
        
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        
        //----------------
        [UIAstroAlert info:@"正在处理，请稍候！" :YES :NO];
        NSLog(@"正在处理，请稍候！....");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running task
            if( ImagePicker.callObject != nil && ImagePicker.callBack != nil )
            {
                if( [ImagePicker.callObject respondsToSelector:ImagePicker.callBack] )
                {
                    [ImagePicker.callObject performSelector:ImagePicker.callBack
                                                 withObject:self.selectedPhotos] ;
                }
                ImagePicker.callObject = nil ;
                ImagePicker.callBack = nil ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update UI
                [UIAstroAlert infoCancel];
            });  
        });
        
        //---------------
        
        
        //[vc dismissViewControllerAnimated:YES completion:nil];
        
        // We need to wait for the view controller to appear first.
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [vc dismissViewControllerAnimated:YES completion:nil];
        });
        

    };
    
    
    
    
    // Show saved photos on top
    imagePickerController.shouldShowSavedPhotosOnTop = YES;
    //imagePickerController.shouldShowSavedPhotosOnTop = NO;
    
    NSLog(@"--selectedPhotos = %d,retaincount=%d",[selectedPhotos count],[selectedPhotos retainCount]);
    
    imagePickerController.selection = self.selectedPhotos;
    
    // Custom toolbar items
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease] andSelectionBlock:nil];
    /*
    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"选奇数" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return !(index % 2);
    }];
     */
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"全取消" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    //imagePickerController.toolbarItemsForSelection = [NSArray arrayWithObjects:selectAll, flexible, selectOdd, flexible, deselectAll, nil];
    
    //imagePickerController.toolbarItemsForManagingTheSelection = [NSArray arrayWithObjects:selectAll, flexible, selectOdd, flexible, deselectAll, nil];
    
    imagePickerController.toolbarItemsForManagingTheSelection = [NSArray arrayWithObjects:selectAll, flexible, flexible, deselectAll, nil];
    //    imagePickerController.toolbarItemsForSelection = [NSArray array];
    //[selectOdd release];
    [flexible release];
    [selectAll release];
    [deselectAll release];
    
    //    imagePickerController.maximumNumberOfPhotos = 3;
    [vc presentViewController:imagePickerController animated:NO completion:nil];
    [imagePickerController release];
    
}

/*
- (void)selectImage:(UIViewController*)vc
{
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
        NSLog(@"Fail. Error: %@", error);
        
        if (error == nil) {
            [self.selectedPhotos removeAllObjects];
            NSLog(@"User has cancelled.");
            [vc dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            // We need to wait for the view controller to appear first.
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [vc dismissViewControllerAnimated:YES completion:nil];
            });
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    } andSuccessBlock:^(NSArray *info) {
        [self.selectedPhotos setArray:info];
        id obj = [info objectAtIndex:0];
        NSLog( @"%@", [obj class] ) ;
        
        NSLog(@"Info: %@", info);
        [vc dismissViewControllerAnimated:YES completion:nil];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        //////////////
        if( ImagePicker.callObject != nil && ImagePicker.callBack != nil )
        {
            if( [ImagePicker.callObject respondsToSelector:ImagePicker.callBack] )
            {
                [ImagePicker.callObject performSelector:ImagePicker.callBack
                                             withObject:self.selectedPhotos] ;
            }
        }
    }];
    
    // Show saved photos on top
    imagePickerController.shouldShowSavedPhotosOnTop = YES;
    imagePickerController.selection = self.selectedPhotos;
    
    // Custom toolbar items
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease] andSelectionBlock:nil];
    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"选奇数" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return !(index % 2);
    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"取消全部选择" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    //imagePickerController.toolbarItemsForSelection = [NSArray arrayWithObjects:selectAll, flexible, selectOdd, flexible, deselectAll, nil];
    
    imagePickerController.toolbarItemsForManagingTheSelection = [NSArray arrayWithObjects:selectAll, flexible, selectOdd, flexible, deselectAll, nil];    
    //    imagePickerController.toolbarItemsForSelection = [NSArray array];
    [selectOdd release];
    [flexible release];
    [selectAll release];
    [deselectAll release];
    
    //    imagePickerController.maximumNumberOfPhotos = 3;
    [vc presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
    ///////////////////////////////////////////
    if( ImagePicker.callObject != nil && ImagePicker.callBack != nil )
    {
        if( [ImagePicker.callObject respondsToSelector:ImagePicker.callBack] )
        {
            [ImagePicker.callObject performSelector:ImagePicker.callBack
                                         withObject:self.selectedPhotos] ;
        }
    }
    ///////////////////////////////////////////////
}
*/

+ (UIImage*)fixOrientation:(UIImage *)srcImg
{
    if( srcImg.imageOrientation == UIImageOrientationUp )
    {
        return srcImg ;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity ;
    switch( srcImg.imageOrientation  )
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
             transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height ) ;
             transform = CGAffineTransformRotate(transform, M_PI) ;
             break ;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
             transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0) ;
             transform = CGAffineTransformRotate(transform, M_PI_2) ;
             break ;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
             transform = CGAffineTransformTranslate( transform, 0, srcImg.size.height ) ;
             transform = CGAffineTransformRotate(transform, -M_PI_2) ;
             break ;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
             break ;
    }
    
    switch (srcImg.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
             transform = CGAffineTransformTranslate( transform, srcImg.size.width, 0) ;
             transform = CGAffineTransformScale(transform, -1, 1) ;
             break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
             transform = CGAffineTransformTranslate( transform, srcImg.size.height, 0) ;
            transform = CGAffineTransformTranslate( transform, -1, 1) ;
             break ;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate( NULL, srcImg.size.width,  srcImg.size.height, CGImageGetBitsPerComponent(srcImg.CGImage), 0, CGImageGetColorSpace(srcImg.CGImage), CGImageGetBitmapInfo(srcImg.CGImage)) ;
    
    CGContextConcatCTM(ctx, transform) ;
    switch ( srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
             CGContextDrawImage( ctx, CGRectMake(0, 0, srcImg.size.height, srcImg.size.width ), srcImg.CGImage ) ;
             break;
        default:
             CGContextDrawImage( ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage) ;
             break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx) ;
    UIImage *img = [UIImage imageWithCGImage:cgimg] ;
    CGContextRelease(ctx) ;
    CGImageRelease( cgimg ) ;
    return img ;
}

@end
