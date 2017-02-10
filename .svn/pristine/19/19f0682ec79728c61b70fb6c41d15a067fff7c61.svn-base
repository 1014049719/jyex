//
//  iOSUtils.m
//  Weather
//
//  Created by xupeng mao on 11-12-9.
//  Copyright (c) 2011年 acher soft. All rights reserved.
//

#import "iOSUtils.h"
#include <QuartzCore/QuartzCore.h>

@implementation iOSUtils

#if !(TARGET_IPHONE_SIMULATOR) && defined (APP_CRACK_VERSION)

CGImageRef UIGetScreenImage();
//截取全屏
+ (UIImage *)screenImage {
    CGImageRef img = UIGetScreenImage();
    UIImage* screenshot=[UIImage imageWithCGImage:img];
    return screenshot;
}

#else

+ (UIImage *)screenImage {
    UIWindow *theScreen = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(theScreen.frame.size);
    [theScreen.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

#endif

@end
