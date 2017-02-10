//
//  BizLogic_JYEX.m
//  NoteBook
//
//  Created by cyl on 13-3-29.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "BizLogicAll.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"
#import "CfgMgr.h"
#import "DbMngDataDef.h"

#import "CommonDateTime.h"
#import "CommonNoteOpr.h"
#import "CommonDirectory.h"

#import "Global.h"
#import "logging.h"
#import "PubFunction.h"

#import "BussMng.h"
#import "GlobalVar.h"
#import "DataSync.h"
#import "DBMng.h"


@implementation BizLogic (JYEX)

+(BOOL)procJYEXLoginSuccess:(TLoginUserInfo* )lgnUser
{
    //非缺省用户要更新数据库
    if ( ![lgnUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] )
    {
        LOG_DEBUG(@"更新登录用户信息.");
        TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo *)lgnUser;
        [AstroDBMng replaceJYEXLoginUser:u];
    }
    
    BOOL bIsOldDefault = [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME];
    BOOL bIsNewDefault = [lgnUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME];
    BOOL bIsSameUser = [TheCurUser.sUserName isEqualToString:lgnUser.sUserName];
    TheCurUser = lgnUser;  //赋值到当然用户全局变量
    LOG_DEBUG(@"当前登录用户：name=%@,nick=%@, pswd=%@, uid=%@, SID=%@ 91uid=%@", TheCurUser.sNickName,TheCurUser.sUserName, TheCurUser.sPassword, TheCurUser.sUserID,TheCurUser.sSID,TheCurUser.sNoteUserId);
    
    //初次登录时，必须将体验内容COPY到登录帐号
    if (bIsOldDefault && !bIsNewDefault)
    {
        [CommonFunc checkUserDirectory:TheCurUser.sUserName];
        [self switchDefaultUserToRegUser:TheCurUser.sUserName];
        [self procCurAccount];
        LOG_DEBUG(@"缺省用户切换至命造：name=%@, guid=%@", TheCurPeople.sPersonName, TheCurPeople.sGuid);
    }
    //否则，当登录帐号改变时，必须要切换数据库
    else if( !bIsSameUser )
    {
        [self procCurAccount];
        LOG_DEBUG(@"切换至命造：name=%@, guid=%@", TheCurPeople.sPersonName, TheCurPeople.sGuid);
        //[_GLOBAL clearAllMessageNum];
    }
    
    //读取原来保存的消息数
    [_GLOBAL readMesageNum];
    
    //add 2012.7.30 发更新页面通知消息
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (nc) {
        [nc postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    }
    
    //发起更新图像流程
    [[DataSync instance] syncRequest:BIZ_SYNC_AVATAR :nil :nil :nil];
    
    
    //仅在wifi打开时同步
    NSString *strValue=@"YES";
    [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"DINoteWifioNoly" value:strValue];
    if ( [strValue isEqualToString:@"YES"] && [[Global instance] getNetworkStatus] != kReachableViaWiFi)
    {
        return YES;
    }
    
    
    //每天只同步一次,取自动同步日期
    strValue=@"";
    [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"AutoSyncDate" value:strValue];
    NSString *strCurDate = [CommonFunc getCurrentDate];
    
    if ( ![strCurDate isEqualToString:strValue] || 0 == TheCurUser.iSavePasswd)
    {
        NSLog(@"发起自动同步。。");
        
        [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"AutoSyncDate" value:strCurDate];
        //同步
        //if ( 0 == TheCurUser.iSavePasswd)
        //    [[DataSync instance] syncRequest:BIZ_SYNC_DOWNCATALOG_NOTE_UPLOADNOTE :nil :nil :nil];
        //else
        //[[DataSync instance] syncRequest:BIZ_SYNC_AllCATALOG_NOTE :nil :nil :nil];
    }
    
    return YES;

    
    
    
    TheCurUser = lgnUser;  //赋值到当然用户全局变量
    LOG_DEBUG(@"当前登录用户：name=%@,nick=%@, pswd=%@, uid=%@", TheCurUser.sNickName,TheCurUser.sUserName, TheCurUser.sPassword, TheCurUser.sUserID);
    return YES;
}

+(BOOL)updateUserAppList:(NSArray *)appList WithUserName:(NSString*)sUserName
{
    [AstroDBMng deleteJYEXAppListByUserName:sUserName];
    [AstroDBMng insertAppListByUserName:sUserName AppList:appList];
    return YES;
}

+(NSArray*) getAppListByUserName:(NSString *)sUserName AppType:(UserAppType)appType
{
    NSArray *array = [AstroDBMng getAppListByUserName:sUserName AppType:appType];
    return array;
}

+(JYEXUserAppInfo*)getAppListByUserName:(NSString *)sUserName AppCode:(NSString *)appCode
{
    return [AstroDBMng getAppListByUserName:sUserName AppCode:appCode];
}

+(NSArray*) getLanmuList
{
    NSArray *array = [AstroDBMng getLanmuList];
    return array;
}

+(BOOL) cleanLanmuList
{
    return [AstroDBMng cleanLanmuList];
}

+(int) insertLanmuListByUserName:(NSArray*)lanmuList
{
    return [AstroDBMng insertLanmuListByUserName:lanmuList];
}

+(NSArray*) getClassList
{
    NSArray *array = [AstroDBMng getClassList];
    return array;
}
+(BOOL) cleanClassList
{
    return [AstroDBMng cleanClassList];
}
+(int) insertClassListByUserName:(NSArray*)classList
{
    return [AstroDBMng insertClassListByUserName:classList];
}
@end
