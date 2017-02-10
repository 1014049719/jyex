//
//  ImageOPDelegate.h
//  图片浏览器示例
//
//  Created by zd on 14-12-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageOPDelegate <NSObject>
@required
- (void)imageDianZhan:(NSDictionary*)imageDic; //点赞
- (void)imageQuXiaoDianZhan:(NSDictionary*)imageDic;//取消点赞
- (void)sendImagePinLun:(NSDictionary*)imageDic  Content:(NSString*)content;//发送评论
- (void)sendImageOP:(NSDictionary*)imageDic;//图片操作
- (void)imageXianQing:(NSDictionary*)imageDic;//图片详情
@end
