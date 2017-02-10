//
//  BizLogic_JYEX.h
//  NoteBook
//
//  Created by cyl on 13-3-29.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BizLogic.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"

@interface BizLogic (JYEX)
{
    
}

+(BOOL)procJYEXLoginSuccess:(TLoginUserInfo* )lgnUser;
+(BOOL)updateUserAppList:(NSArray *)appList WithUserName:(NSString*)sUserName;
+(NSArray*) getAppListByUserName:(NSString *)sUserName AppType:(UserAppType)appType;
+(JYEXUserAppInfo*)getAppListByUserName:(NSString *)sUserName AppCode:(NSString *)appCode;
+(NSArray*) getLanmuList;
+(BOOL) cleanLanmuList;
+(int) insertLanmuListByUserName:(NSArray*)lanmuList;

+(NSArray*) getClassList;
+(BOOL) cleanClassList;
+(int) insertClassListByUserName:(NSArray*)classList;
@end

