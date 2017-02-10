//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "ImageOPDelegate.h"
#import "ImageOPDelegate.h"
#import "PubFunction.h"


@protocol MJPhotoBrowserDelegate;
@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    UIView *navView ;//顶部导航条
    UILabel *lbTitle ;//标题
    UITextView *tvImageXQ;//图片详情显示
    
    BOOL flag ;//控制工具栏和导航栏显示
    
    __weak id<ImageOPDelegate> imageOpDelegate ;
    __weak NSDictionary *curImageDic ;
    
    //参数
    //MsgParam *msgParam;
    
}

// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic,weak) id<ImageOPDelegate> imageOpDelegate ;


// 显示
- (void)show;

- (void)updateTitle:(NSString*)title;

- (void)showImageXQ:(NSString*)imageXQStr ;

- (void)goback ;

- (void)godone:(NSDictionary*)imageDic ;

- (void)controlTS ;//控制导航栏与工具栏显示的函数

- (void)fullScreen;

- (void)resetScreen;

//点攒
- (void)imageDZ:(NSDictionary*)imageDic;

//详情
- (void)imageXQ:(NSDictionary*)imageDic;

@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end