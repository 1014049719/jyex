/*
 *  Business.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */
#import "BizLogic.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"

//和登录相关的业务逻辑
@interface BizLogic (ForLogin)
{

}


//移动缺省数据库文件到当前用户文件，当做当前用户的数据库文件（第一次使用账号登录时,会关掉数据库)
+(BOOL)switchDefaultUserToRegUser:(NSString*) regUserName;

//当前账号处理: 数据目录（没有则创建），确认数据库文件（没有则创建）、打开数据库、创建表、创建缺省记录等。
+(void)procCurAccount;

//登录成功后的业务逻辑
+(BOOL)procLoginSuccess:(TLoginUserInfo* )lgnUser;


@end