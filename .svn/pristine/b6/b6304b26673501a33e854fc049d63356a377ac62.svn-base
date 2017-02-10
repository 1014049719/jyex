//
//  CPictureSelected.h
//  JYEX
//
//  Created by zd on 14-3-5.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAsset+AGIPC.h"

@interface CPictureSelected : NSObject
{
    NSString *strFileName ;//文件名
    NSString *strPictureFileBig ;//全路径信息
    NSString *strPictureFileSmall ;//全路径信息
    BOOL editFlag ;
    ALAsset *picAlasset ;
    int ID ;
    
    //add by zd 2015-01-14
    NSString *strPinLun ;//相片评论
    UILabel *lbPinLun ;
}
@property(nonatomic,copy)NSString *strFileName ;
@property(nonatomic,copy)NSString *strPictureFileBig ;
@property(nonatomic,copy)NSString *strPictureFileSmall ;
@property(nonatomic,assign)BOOL editFlag ;
@property(nonatomic,retain)ALAsset *picAlasset ;
@property(nonatomic,assign)int ID ;
@property(nonatomic,copy)NSString *strPinLun;
@property(nonatomic,retain)UILabel *lbPinLun;

- (void)initFileName ;

+ (int)GetNextID ;
+ (void)ResetID ;
@end
