//
//  UIImageEditorVC.h
//  CLImageEditorDemo
//
//  Created by zd on 14-2-19.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAsset+AGIPC.h"
#import "CPictureSelected.h"

@interface UIImageEditorVC:UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITabBarDelegate, UIActionSheetDelegate, UIScrollViewDelegate,UIAlertViewDelegate>
{
    IBOutlet __weak UIScrollView *_scrollView;
    IBOutlet __weak UIImageView  *_imageView;
    IBOutlet __weak UITabBar *_tabBar ;
    
    __weak CPictureSelected *pic ;
    __weak id callBackObject ;
    SEL callBackSEL ;
}

@property(nonatomic,weak)id callBackObject ;
@property(nonatomic,assign)SEL callBackSEL ;

- (void)setEditPicture:(CPictureSelected*)p ;

@end
