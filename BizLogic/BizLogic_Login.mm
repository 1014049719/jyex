/*
 *  Business.mm
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

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

@implementation BizLogic (ForLogin)


//移动缺省数据库文件到当前用户文件，当做当前用户的数据库文件（第一次使用账号登录时,会关掉数据库)
+(BOOL)switchDefaultUserToRegUser:(NSString*) regUserName
{
	//源帐号文件
	NSString* fromPath = [CommonFunc getDbFileFullName:EDbType91Note UserName:CS_DEFAULTACCOUNT_USERNAME];
	if (![CommonFunc isFileExisted:fromPath])
	{
		LOG_ERROR(@"缺省帐号目录文件不存在.file=%@！",fromPath);
		return NO;
	}	
	
	//目标帐号目录
	NSString* toPath = [CommonFunc getDbFileFullName:EDbType91Note UserName:regUserName];
	if ([CommonFunc isFileExisted:toPath])
	{
		LOG_ERROR(@"目标帐号已经存在.file=%@！",toPath);
		return NO;
	}
	
    //先保证关闭缺省帐号数据库
    [AstroDBMng CloseDb91Note];
		
	//缺省帐号改名为登录帐号目录
	NSError* err = nil;
	BOOL bSucc = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&err];
    if ( !bSucc )
    {
        LOG_ERROR(@"移动数据库文件失败.src=%@,dest=%@",fromPath,toPath);
        return NO;
    }
    
    LOG_ERROR(@"移动数据库文件成功.src=%@,dest=%@",fromPath,toPath);
    
    //要拷贝文件
    NSString *srcDir = [CommonFunc getTempDir:CS_DEFAULTACCOUNT_USERNAME];
    NSString *dstDir = [CommonFunc getTempDir];
  
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:srcDir error:nil];
    if ( arr ) {
        for ( id obj in arr ) {
            NSString *srcFile = [srcDir stringByAppendingFormat:@"/%@",(NSString *)obj];
            if ( [CommonFunc isFileExisted:srcFile] ) {
                NSString *dstFile = [dstDir stringByAppendingFormat:@"/%@",(NSString *)obj];
                if ( [[NSFileManager defaultManager] copyItemAtPath:srcFile toPath:dstFile error:nil] ) {
                    [[NSFileManager defaultManager] removeItemAtPath:srcFile error:nil];
                }
                else {
                    NSLog(@"Error:copy %@ to %@",srcFile,dstFile);
                }
            }
        }
    }
    
    return YES;
	
}

//当前账号处理: 数据目录（没有则创建），确认数据库文件（没有则创建）、打开数据库、创建表、创建缺省记录等。
+(void)procCurAccount
{
    //检查用户目录
    [CommonFunc checkUserDirectory:TheCurUser.sUserName];
    
    //拷贝录音图标文件到附件目录
    NSString *strRecordFile = [[NSBundle mainBundle] pathForResource:@"recordicon" ofType:@"png"];
    NSString *strDestFile = [CommonFunc getItemPath:@"recordicon" fileExt:@"png"];
    if ( ![CommonFunc isFileExisted:strDestFile] )
        [[NSFileManager defaultManager] copyItemAtPath:strRecordFile toPath:strDestFile error:nil];
    
    
    //拷贝web静态文件
    /*
    NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *strJsPath = [strResourcePath stringByAppendingPathComponent:@"static/js"];
    NSString *strMobImgPath = [strResourcePath stringByAppendingPathComponent:@"static/mobimg"];
    
    NSArray *arrJsFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strJsPath error:nil];
    NSArray *arrMobImgFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strMobImgPath error:nil];
    
    
    for (NSString *filename in arrJsFile ) {
        NSString *strSrc = [strJsPath stringByAppendingPathComponent:filename];
        NSString *strDest = [[CommonFunc getJsDir] stringByAppendingPathComponent:filename];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:strDest])
            [[NSFileManager defaultManager] copyItemAtPath:strSrc toPath:strDest error:nil];
    }
    for (NSString *filename in arrMobImgFile ) {
        NSString *strSrc = [strMobImgPath stringByAppendingPathComponent:filename];
        NSString *strDest = [[CommonFunc getMobImgDir] stringByAppendingPathComponent:filename];
        if(![[NSFileManager defaultManager] fileExistsAtPath:strDest])
            [[NSFileManager defaultManager] copyItemAtPath:strSrc toPath:strDest error:nil];
    }
    */
    
    //--------------
    
    //判断版本文件是否相同，如果不相同，就全部拷贝文件
    NSString *strSrcVerFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"static/ver.txt"];
    NSString *strDestVerFile = [[CommonFunc getStaticDir] stringByAppendingPathComponent:@"ver.txt"];
    int nOverWriteFlag = 0;
    if( [[NSFileManager defaultManager] fileExistsAtPath:strSrcVerFile]) {
        if( ![[NSFileManager defaultManager] fileExistsAtPath:strDestVerFile]) {
            nOverWriteFlag = 1;
        }
        else {
            long long nSizeSrc = [CommonFunc GetFileSize:strSrcVerFile];
            long long nSizeDest = [CommonFunc GetFileSize:strDestVerFile];
            if ( nSizeSrc > 0 &&  nSizeSrc != nSizeDest )
                nOverWriteFlag = 1;
        }
    }
    
    
    NSMutableArray *arrSrc = [NSMutableArray array];
    
    [arrSrc addObject:@"static"];
    [arrSrc addObject:@"static/js"];
    [arrSrc addObject:@"static/mobimg"];
    [arrSrc addObject:@"static/mobv5"];
    [arrSrc addObject:@"static/mobv5/css"];
    [arrSrc addObject:@"static/mobv5/images"];
    [arrSrc addObject:@"static/mobv5/images/ico"];
    [arrSrc addObject:@"static/mobv5/js"];
    [arrSrc addObject:@"static/mobv51"];
    [arrSrc addObject:@"static/mobv51/css"];
    [arrSrc addObject:@"static/mobv51/images"];
    [arrSrc addObject:@"static/mobv51/images/ico"];
    
    
    NSMutableArray *arrDest = [NSMutableArray array];
    [arrDest addObject:[CommonFunc getStaticDir]];
    [arrDest addObject:[CommonFunc getJsDir]];
    [arrDest addObject:[CommonFunc getMobImgDir]];
    [arrDest addObject:[CommonFunc getMobV5]];
    [arrDest addObject:[CommonFunc getMobV5_css]];
    [arrDest addObject:[CommonFunc getMobV5_images]];
    [arrDest addObject:[CommonFunc getMobV5_images_ico]];
    [arrDest addObject:[CommonFunc getMobV5_js]];
    [arrDest addObject:[CommonFunc getMobV51]];
    [arrDest addObject:[CommonFunc getMobV51_css]];
    [arrDest addObject:[CommonFunc getMobV51_images]];
    [arrDest addObject:[CommonFunc getMobV51_images_ico]];
    
    
    NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];
    for (int jj=0;jj<[arrSrc count];jj++) {
        NSString *strSubDir = [arrSrc objectAtIndex:jj];
        NSString *strDestDir = [arrDest objectAtIndex:jj];
        
        NSString *strSrcPath = [strResourcePath stringByAppendingPathComponent:strSubDir];
        NSArray *arrSrcFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strSrcPath error:nil];
 
        for (NSString *filename in arrSrcFile ) {
            NSString *strSrc = [strSrcPath stringByAppendingPathComponent:filename];
            NSString *strDest = [strDestDir stringByAppendingPathComponent:filename];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:strDest] ) {
                if ( nOverWriteFlag == 1 ) {
                    [CommonFunc deleteFile:strDest];
                }
                else {
                    continue;
                }
            }
                
            [[NSFileManager defaultManager] copyItemAtPath:strSrc toPath:strDest error:nil];
            NSLog(@"copy [%@] to [%@]",strSrc,strDest);
        }
    }
    //--------------
    
    
    
	//打开账户对应的数据库
    //[AstroDBMng CloseDbUserLocal];
	//[AstroDBMng loadDbUserLocal];
    
    [AstroDBMng CloseDb91Note];
    [AstroDBMng loadDb91Note];  //add 2012.11.13
    //如果没有目录，则创建根缺省目录记录
    [BizLogic createDefaultRootCateRecord];	
    
    //设置笔记缺省目录
    [BizLogic setDefualtDirectory];
}


//登录成功后的业务逻辑
+(BOOL)procLoginSuccess:(TLoginUserInfo* )lgnUser
{
    //非缺省用户要更新数据库
    if ( ![lgnUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] )
    {
        LOG_DEBUG(@"更新登录用户信息.");
        [AstroDBMng replaceLoginUser:lgnUser];
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
    }
    
    //add 2012.7.30 发更新页面通知消息
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (nc) {
        [nc postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    }
    
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
            [[DataSync instance] syncRequest:BIZ_SYNC_AllCATALOG_NOTE :nil :nil :nil];
    }

    return YES;
}



@end