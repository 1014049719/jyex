//
//  BlogIntf.h
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSInfo : NSObject
{
	NSInteger snsType;
	NSString *snsName, *logoUrl, *logoCache;
	BOOL      isBind;
	
}

@property(nonatomic) NSInteger snsType;
@property(nonatomic, copy) NSString *snsName, *logoUrl, *logoCache;
@property(nonatomic) BOOL isBind;

@end

#define kMaxBlogLength  140
extern NSString *const kBlogUrl;
extern NSString *const kBlogNickname;
extern NSString *const kBlogAvatar;

@interface BlogIntf : NSObject {
	NSMutableArray* list;
	BOOL isLogin;
	NSString *sharesid;
}

@property(nonatomic, retain) NSMutableArray* list;
@property(nonatomic) BOOL isLogin;
@property(nonatomic, copy) NSString* sharesid;

+ (BlogIntf*) instance;

+ (NSString *) productInfo;
+ (NSString *) downloadUrl;

// 发布分享内容
- (BOOL) SendBlog:(NSString*)text: (NSString**)msg;
- (BOOL) wrapForSendBlog:(NSString*)text: (NSString**)msg;
- (BOOL) SendBlog:(NSString*)text: (UIImage*) image: (NSString**)msg;
- (BOOL) wrapForSendBlog:(NSString*)text: (UIImage*) image: (NSString**)msg;

//分享免费标识
- (void) markTodayShared;

// 从本地获取绑定列表
- (NSArray*) GetBlogList;

// 存储到本地缓存
- (BOOL) SaveBlogList;

// 从服务器查询绑定列表
- (BOOL) ReqBlogList;

// 查询是否有绑定微博
- (BOOL) IsBinded;
- (BOOL) Login;
- (BOOL) Logout;

// 查询指定微博的绑定状态
- (NSDictionary*)QueryBind:(NSInteger)snstype;
- (BOOL) UnBind: (NSInteger)snstype;

- (NSString*) getBindUrl: (NSInteger)snstype;
- (void) SetBindOK: (NSInteger) snstype;
- (void) SetBind: (BOOL) isBind forSNSType: (NSInteger) snstype;

@end
