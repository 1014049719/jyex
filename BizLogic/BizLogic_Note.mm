/*
 *  Business.mm
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "BizLogic_Note.h"
#import "DataSync.h"

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
#import "GlobalVar.h"

#import "UIProgress.h"

//#import "MBBaseStruct.h"
//#import "ObjEncrypt.h"

@implementation BizLogic (ForNote)


//头结构各种操作
+ (TRecHead* )createHead
{
    TRecHead* pHead = [[TRecHead new] autorelease];
    
    pHead.nUserID = [TheCurUser.sNoteUserId intValue];       // 用户编号
    pHead.nCurrVerID = 0;//[AstroDBMng getCateMaxVersion_CateMgr];     // 当前版本号
    pHead.nCreateVerID = 0;//[AstroDBMng getCateMaxVersion_CateMgr];    // 创建版本号
    
    pHead.strCreateTime = [CommonFunc getCurrentTime];           // 创建时间
    pHead.strModTime = [CommonFunc getCurrentTime];              // 修改时间
    
    pHead.nDelState = DELETESTATE_NODELETE;                  // 删除状态
    pHead.nEditState = EDITSTATE_EDITED;                           // 编辑状态
    pHead.nConflictState = CONFLICTSTATE_NOCONFLICT;             // 冲突状态
    //pHead.nSyncState = SYNCSTATE_NOSYNC;                 // 同步状态（本地不用）
    //pHead.nNeedUpload = CanUpload;                // 是否上传（本地不用）
    
    
    return pHead;
}


+ (void)updateHeadForEdit:(TRecHead* )pHead
{
    pHead.nEditState = EDITSTATE_EDITED;
    pHead.strModTime = [CommonFunc getCurrentTime];  //需要跟踪
}

+ (void)updateHeadForDelete:(TRecHead* )pHead
{
    pHead.nDelState = DELETESTATE_DELETE;    //置为删除
    pHead.nEditState = EDITSTATE_EDITED;
    pHead.strModTime = [CommonFunc getCurrentTime];  //需要跟踪
}


+ (void)resetHead:(TRecHead*)pHead
{
	pHead.nEditState = EDITSTATE_EDITED;
}


//目录操作
//-----------------------------------------------------------------------------------------------------------------------

//创建文件夹结构
+(TCateInfo *)createCateInfo
{
    TRecHead *pHead = [self createHead];
    TCateInfo *pCateInfo = [[TCateInfo new] autorelease];
    pCateInfo.tHead = pHead; 
    
    pCateInfo.tHead.nNeedUpload = 0; //本地不用
    
    pCateInfo.strCatalogIdGuid = [CommonFunc createGUIDStr];   // 目录编号;
    pCateInfo.strCatalogBelongToGuid = GUID_ZERO;  //当前目录上一级目录
    pCateInfo.strCatalogPaht1Guid = GUID_ZERO; //第一级目录位置
    pCateInfo.strCatalogPaht2Guid = GUID_ZERO; //第二级目录位置
    pCateInfo.strCatalogPaht3Guid = GUID_ZERO; //第三级目录位置
    pCateInfo.strCatalogPaht4Guid = GUID_ZERO; //第四级目录位置
    pCateInfo.strCatalogPaht5Guid = GUID_ZERO; //第五级目录位置
    pCateInfo.strCatalogPaht6Guid = GUID_ZERO; //第六级目录位置
    
    //多数为默认
    pCateInfo.nOrder = 0;                      // 排列位置
    pCateInfo.strCatalogName = @"";       // 目录名称
    
    pCateInfo.nEncryptFlag = EF_NOT_ENCRYPTED;	   // 加密标识(是否加密)
    pCateInfo.strVerifyData = @"";		// 验证密码
    
    pCateInfo.nCatalogType = 0;   //目录类型  (以下为新增的)
    pCateInfo.nCatalogColor = COLOR_1;   //目录颜色
    pCateInfo.nCatalogIcon = ICON_DEFAULT;   //目录图标
    pCateInfo.nMobileFlag = MOBILEFLAG_USER_CREATE;    //手机目录标志
    pCateInfo.nNoteCount = 0;     //笔记数量
    
    pCateInfo.nIsRoot = 1;        // 是否是根目录 （服务端没有，这个还需要吗）
    pCateInfo.nSyncFlag = SYNCFLAG_NEED;  
    
    pCateInfo.nCurdayNoteCount = 0;
    
    //插入数据库
    return pCateInfo;
}


//插入或更新目录到数据库
+(BOOL)updateCate:(TCateInfo *)pCateInfo
{
    //插入数据库
    return [AstroDBMng addCate_CateMgr:pCateInfo];
}


//创建根目录文件夹
+(BOOL)addRootCate:(NSString *)strTitle icon:(int)nCatalogIcon color:(int)nCatalogColor encrypt:(int)nEncryptFlag  sync:(int)nSyncFlag mobile_flag:(int)mobile_flag  order:(int)order
{
    TRecHead *pHead = [self createHead];
    TCateInfo *pCateInfo = [[TCateInfo new] autorelease];
    pCateInfo.tHead = pHead; 
    
    pCateInfo.tHead.nNeedUpload = 0; //本地不用

    pCateInfo.strCatalogIdGuid = [CommonFunc createGUIDStr];   // 目录编号;
    pCateInfo.strCatalogBelongToGuid = GUID_ZERO;  //当前目录上一级目录
    pCateInfo.strCatalogPaht1Guid = GUID_ZERO; //第一级目录位置
    pCateInfo.strCatalogPaht2Guid = GUID_ZERO; //第二级目录位置
    pCateInfo.strCatalogPaht3Guid = GUID_ZERO; //第三级目录位置
    pCateInfo.strCatalogPaht4Guid = GUID_ZERO; //第四级目录位置
    pCateInfo.strCatalogPaht5Guid = GUID_ZERO; //第五级目录位置
    pCateInfo.strCatalogPaht6Guid = GUID_ZERO; //第六级目录位置
    
    //多数为默认
    pCateInfo.nOrder = order;                      // 排列位置
    pCateInfo.strCatalogName = strTitle;       // 目录名称
    
    pCateInfo.nEncryptFlag = nEncryptFlag;	   // 加密标识(是否加密)
    pCateInfo.strVerifyData = @"";		// 验证密码
    
    pCateInfo.nCatalogType = 0;   //目录类型  (以下为新增的)
    pCateInfo.nCatalogColor = nCatalogColor;   //目录颜色
    pCateInfo.nCatalogIcon = nCatalogIcon;   //目录图标
    pCateInfo.nMobileFlag = mobile_flag;    //手机目录标志
    pCateInfo.nNoteCount = 0;     //笔记数量
    
    pCateInfo.nIsRoot = 1;        // 是否是根目录 （服务端没有，这个还需要吗）
    pCateInfo.nSyncFlag = nSyncFlag;  
    
    pCateInfo.nCurdayNoteCount = 0;
    
    //插入数据库
    return [AstroDBMng addCate_CateMgr:pCateInfo];
}


//如果没有目录，创建根缺省目录
+(void) createDefaultRootCateRecord
{
    //如果目录数目为0，则创建
    if ( [AstroDBMng getCateCount] >= 1 ) return;
    
    [self addRootCate:@"手机未整理" icon:ICON_DEFAULT color:COLOR_1 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_1 order:1];
    [self addRootCate:@"工作" icon:ICON_WORK color:COLOR_2 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_6 order:2];
    [self addRootCate:@"TO DO LIST" icon:ICON_TODOLIST color:COLOR_3 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_3 order:3];
    [self addRootCate:@"灵感" icon:ICON_AFFLATUS color:COLOR_4 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_4 order:4];
    [self addRootCate:@"个人笔记" icon:ICON_PERSONAL color:COLOR_5 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_7 order:5];
   // [self addRootCate:@"日志" icon:ICON_PERSONAL color:COLOR_1 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_7];
    //[self addRootCate:@"购物" icon:ICON_DEFAULT color:COLOR_2 encrypt:EF_NOT_ENCRYPTED  sync:SYNCFLAG_NEED mobile_flag:MOBILEFLAG_2];
        
}


//增加目录，主动修改时间、状态等数据(二期实现)
/*
+ (BOOL)AddCate:(TCateInfo *)cateInfo
{
    cateInfo
    return [AstroDBMng addCate_CateMgr:cateInfo];
}
*/

//根据指定GUID，获取某个目录
+ (TCateInfo*)getCate:(NSString *)guidCate
{
    return [AstroDBMng getCate_CateMgr:guidCate];
}


/*
//获取目录列表GUID，其中guidParent为父目录的GUID，如果取根目录列表，置为空
+ (NSArray *)getCateIDList:(NSString *)guidParent
{
    std::vector<CateInfo> cateList;
    [CateMgr getCateList:guidParent cateList:&cateList];
    for(vector<CateInfo>::iterator itor = cateList.begin(); itor != cateList.end(); ++itor)
    {
        pCateIDList->push_back(itor->guid);
    }
    
    return YES;
}
*/

//更改某个目录(包括更改父目录的)的记录总数
+(BOOL)updateCateNoteCount:(NSString *)strCateGuid
{
    TCateInfo  *pCateInfo = [AstroDBMng getCate_CateMgr:strCateGuid];
    if ( pCateInfo) {
        for (int i=0;i<7;i++) {
            NSString *strGuid=@"";
            if (i==0 ) strGuid = pCateInfo.strCatalogIdGuid;
            else if (i==1 ) strGuid = pCateInfo.strCatalogPaht1Guid;
            else if (i==2 ) strGuid = pCateInfo.strCatalogPaht2Guid;
            else if (i==3 ) strGuid = pCateInfo.strCatalogPaht3Guid;
            else if (i==4 ) strGuid = pCateInfo.strCatalogPaht4Guid;
            else if (i==5 ) strGuid = pCateInfo.strCatalogPaht5Guid;
            else strGuid = pCateInfo.strCatalogPaht6Guid;
            
            if ( ![strGuid isEqualToString:GUID_ZERO] ) {
                int notecount = [AstroDBMng getNoteCountInCate_CateMgr:strGuid includeSubDir:YES];
                //更改当前目录总的记录数
                [AstroDBMng updateCateNoteCount_CateMgr:strGuid notecount:notecount];
                NSLog(@"catalog guid:%@ notecount:%d (i=%d %@)",strGuid,notecount,i,pCateInfo.strCatalogName);
            }
            else break;
        }
    }
    
    return TRUE;
}


//提取当天每个目录的更新的记录数。
+(void) getCateCurNoteCount:(NSArray *)arrCateList
{
    if ( !arrCateList ) return;
    
    NSString *strCurDate = [CommonFunc getCurrentDate];
    int count = [AstroDBMng getNoteCountByCateByDate:@"" date:strCurDate];
    if ( count > 0 ) {
        int allcount = 0,count1 = 0;
        for ( id obj in arrCateList ) {
            TCateInfo *pCateInfo = (TCateInfo *)obj;
            if ( pCateInfo.nNoteCount > 0 ) {  //目录有记录
                count1 = [AstroDBMng getNoteCountByCateByDate:pCateInfo.strCatalogIdGuid date:strCurDate];
                if ( count1 > 0 ) {
                    allcount += count1;
                    pCateInfo.nCurdayNoteCount = count1;
                }
                if ( allcount >= count ) break;  //已找完
            }
        }
    }
}

//获取目录列表，其中guidParent为父目录的GUID，如果取根目录列表，置为空
+ (NSArray *)getCateList:(NSString *)guidParent
{
    if ( guidParent && [guidParent isEqualToString:GUID_ZERO] ) return nil;
    
    NSString *strCateGuidNew = guidParent;
    if ( !strCateGuidNew || [strCateGuidNew length] == 0 ) strCateGuidNew = GUID_ZERO;
    
    NSArray *arrCateList = [AstroDBMng getCateList_CateMgr:strCateGuidNew];
    
    //提取当天每个目录的更新的记录数。
    [self getCateCurNoteCount:arrCateList];
     
    return  arrCateList;
}

//搜索目录的标题是否含有关键字
+ (NSArray*)getCateListBySearch_CateMgr:(NSString *)strKey catalog:(NSString *)strCatalog
{
    NSArray *arrCateList = [AstroDBMng getCateListBySearch_CateMgr:strKey catalog:strCatalog];
    //提取当天天每个目录的更新的记录数。
    [self getCateCurNoteCount:arrCateList];
    
    return arrCateList;
}

//删除指定目录下的所有子目录以及笔记
+(void) deleteSpecifiedCate:(NSString *)strCata
{
    int  nDeleteFlag = 0;
    
    TCateInfo *cateInfo = [BizLogic getCate:strCata];
    if ( cateInfo ) {
        nDeleteFlag = 1;
    }
    //处理笔记(改所属文件夹)
    NSArray *arrNote = [AstroDBMng getNoteListByCateIncludeSub:strCata];
    if ( arrNote ) {
        for (int jj=0;jj<[arrNote count];jj++)
        {
            TNoteInfo *noteInfo = [arrNote objectAtIndex:jj];
            
            if ( noteInfo && [BizLogic deleteNote:noteInfo.strNoteIdGuid SendUpdataMsg:NO] ) {
                nDeleteFlag = 1;
            }
        }
    }
    
    //处理子文件夹(删除)
    int count = [AstroDBMng deleteCateListIncludeSubDir_CateMgr:strCata];
    if ( count > 0 ) nDeleteFlag = 1;
    
    cateInfo.strCatalogBelongToGuid = GUID_ZERO;
    cateInfo.strCatalogPaht1Guid = GUID_ZERO;
    cateInfo.strCatalogPaht2Guid = GUID_ZERO;
    cateInfo.strCatalogPaht3Guid = GUID_ZERO;
    cateInfo.strCatalogPaht4Guid = GUID_ZERO;
    cateInfo.strCatalogPaht5Guid = GUID_ZERO;
    cateInfo.strCatalogPaht6Guid = GUID_ZERO;

    cateInfo.tHead.nEditState = EDITSTATE_EDITED;
    cateInfo.tHead.strModTime = [CommonFunc getCurrentTime];  //需要跟踪
    cateInfo.tHead.nDelState = DELETESTATE_DELETE;
    [AstroDBMng updateCate_CateMgr:cateInfo];

    
    if ( 1 == nDeleteFlag ) {//需同步
        //发通知消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
        
        NSLog(@"deleteSpecifiedCate:send sync message");
        //发同步上传消息
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
    }
}

//将目录cateInfo的PathGUID设置成目录parentCate的子目录
+(BOOL)setPathGUIDWith:(TCateInfo *)parentCate DesCate:(TCateInfo *)cateInfo
{
    if ( !cateInfo ) {
        return NO;
    }
    
    if ( parentCate ) {
        if ( ![parentCate.strCatalogPaht6Guid isEqualToString:GUID_ZERO] ) {
            return NO;
        }
        if ( [parentCate.strCatalogPaht1Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht1Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht1Guid = parentCate.strCatalogPaht1Guid;
        }
        
        if ( [parentCate.strCatalogPaht2Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht2Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht2Guid = parentCate.strCatalogPaht2Guid;
        }
        
        if ( [parentCate.strCatalogPaht3Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht3Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht3Guid = parentCate.strCatalogPaht3Guid;
        }
        
        if ( [parentCate.strCatalogPaht4Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht4Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht4Guid = parentCate.strCatalogPaht4Guid;
        }
        
        if ( [parentCate.strCatalogPaht5Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht5Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht5Guid = parentCate.strCatalogPaht5Guid;
        }
        
        if ( [parentCate.strCatalogPaht6Guid isEqualToString:GUID_ZERO] ) {
            cateInfo.strCatalogPaht6Guid = parentCate.strCatalogIdGuid;
            cateInfo.strCatalogBelongToGuid = parentCate.strCatalogIdGuid;
        }
        else
        {
            cateInfo.strCatalogPaht6Guid = parentCate.strCatalogPaht6Guid;
        }
    }
    else
    {
        cateInfo.strCatalogPaht1Guid = GUID_ZERO;
        cateInfo.strCatalogPaht2Guid = GUID_ZERO;
        cateInfo.strCatalogPaht3Guid = GUID_ZERO;
        cateInfo.strCatalogPaht4Guid = GUID_ZERO;
        cateInfo.strCatalogPaht5Guid = GUID_ZERO;
        cateInfo.strCatalogPaht6Guid = GUID_ZERO;
        cateInfo.strCatalogBelongToGuid = GUID_ZERO;
    }
    return YES;
}

//在指定目录下新建一个子目录
+(BOOL) createCateInSpacifiedCate:(NSString *)strParentCate CateInfo:(TCateInfo *)pCateInfo
{
    if ( !pCateInfo ) {
        return NO;
    }
    
    //在根目录创建文件夹
    if ( !strParentCate
         || [strParentCate isEqualToString:GUID_ZERO]
         || [strParentCate isEqualToString:@""] ) {
        if( [BizLogic updateCate:pCateInfo] )
        {
            //发通知消息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
            
            NSLog(@"createCateInSpacifiedCate:send sync message");
            //发同步上传消息
            [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
            return YES;
        }
        return NO;
    }
    
    TCateInfo *parentCate = [BizLogic getCate:strParentCate];
    if ( [BizLogic setPathGUIDWith:parentCate DesCate:pCateInfo] ) {
        if( [BizLogic updateCate:pCateInfo] )
        {
            //发通知消息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
            
            NSLog(@"createCateInSpacifiedCate:send sync message");
            //发同步上传消息
            [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
            return YES;
        }
        return NO;
    }
    return NO;
}

//更新指定目录
+(BOOL)setCateWithCateInfo:(TCateInfo*)cateInfo
{
    if( cateInfo && [BizLogic updateCate:cateInfo] )
    {
        //发通知消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
        
        NSLog(@"createCateInSpacifiedCate:send sync message");
        //发同步上传消息
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
        return YES;
    }
    return NO;
}

//更新一个文件夹的顺序号
+(BOOL)updataCateOrder:(NSString*)cateGuid Order:(int)newOrder
{
    TCateInfo* cate = [BizLogic getCate:cateGuid];
    if ( cate ) {
        cate.nOrder = newOrder;
        return [BizLogic updateCate:cate];
    }
    return NO;
}
/*
+ (BOOL)updateCate:(CateInfo)cateInfo
{
    return [CateMgr updateCate:cateInfo];
}
*/

//获取目录的当前最大版本号
+ (int)getCateMaxVersion
{
    return [AstroDBMng getCateMaxVersion_CateMgr];
}


//从服务端下载目录后，保存到当地数据库，同时更新目录的版本号到最大版本号
+ (BOOL)saveCateFromSvr:(TCateInfo *)cateInfo
{
    //先更新版本号
    int maxVersion = [AstroDBMng getCateMaxVersion_CateMgr];
    if (cateInfo.tHead.nCurrVerID > maxVersion)
    {
        [AstroDBMng setCateMaxVersion_CateMgr:cateInfo.tHead.nCurrVerID];
    }
    
    cateInfo.tHead.nEditState = 0;
    return [AstroDBMng saveCate_CateMgr:cateInfo];
}


+ (int)getTableDirVersion:(NSString *)guidDir tableName:(NSString *)strTable
{
    return [AstroDBMng getTableDirVersion_CateMgr:guidDir tableName:strTable];
}

+ (BOOL)setTableDirVersion:(NSString *)guidDir tableName:(NSString *)strTable version:(int)version
{
    TCatalogVersionInfo * catalogVersionInfo = [[TCatalogVersionInfo new] autorelease];
    catalogVersionInfo.nUserID = [TheCurUser.sNoteUserId intValue];
    catalogVersionInfo.strCatalogBelongToGuid = guidDir;
    catalogVersionInfo.strTableName = strTable;
    catalogVersionInfo.nMaxVer = version;
    //return [AstroDBMng :guidDir tableName:strTable version:version];
    return [AstroDBMng setTableDirVersion_CateMgr:catalogVersionInfo];
}





//-----笔记操作----
//---------------------------------------------------------------------------------------------------------------

//初始化一条笔记,输入参数为父目录GUID，自动生成笔记编号和第一条项目不编号
+(TNoteInfo *)createNoteInfo:(NSString *)guidCatalog
{
    TRecHead *pHead = [self createHead];
    TNoteInfo *pNoteInfo = [[TNoteInfo new] autorelease];
    pNoteInfo.tHead = pHead; 
    
    pNoteInfo.strCatalogIdGuid = guidCatalog;   // 目录编号(笔记存放的目录);
    pNoteInfo.strNoteIdGuid = [CommonFunc createGUIDStr];   //笔记编号
    
    pNoteInfo.strNoteTitle = @"";              // NOTE的名称    
    pNoteInfo.nNoteType = NOTE_WEB;                     // NOTE的类型
    pNoteInfo.nNoteSize = 0;                     // NOTE包含的所有ITEM总长度，不包含自身
    
    pNoteInfo.strFilePath = [CommonFunc getTempDir];               //文件保存路径
    pNoteInfo.strFileExt = [CommonFunc getItemTypeExt:NI_HTML];           //文件扩展名
    pNoteInfo.strEditLocation = @"";           //2014.4.8 用作服务端返回的错误提示
    pNoteInfo.strNoteSrc = @"IOS";                //文件来源
    
    pNoteInfo.strFirstItemGuid = [CommonFunc createGUIDStr];              //第一条item(当NOTE自身含有文件时，此GUID对应存储实际文件内容的ITEM)。
    
    pNoteInfo.nShareMode = 0;                      // 共享模式，0不共享，1共享给好友，2共享给所有人（备用）
    pNoteInfo.nEncryptFlag = EF_NOT_ENCRYPTED;	   // 加密标识(是否加密)
    
    pNoteInfo.nNeedDownlord = DOWNLOAD_NONEED;        //是否下载 (本地用)
    pNoteInfo.nOwnerId = [TheCurUser.sNoteUserId intValue];
    pNoteInfo.nFromId = [TheCurUser.sNoteUserId intValue]; 
    
    //新增星星级别、到期日期、完成状态、完成日期等属性
    pNoteInfo.nStarLevel = 1;					//星星级别
    pNoteInfo.strExpiredDate = @"";			//到期日期
    pNoteInfo.strFinishDate = @"";			//完成日期
    pNoteInfo.nFinishState = 1;				//完成状态 0： 表示未完成 1：表示已完成  
    
    pNoteInfo.strContent = @"";
    
    pNoteInfo.nFailTimes = 0;
    pNoteInfo.strNoteClassId = 0;
    pNoteInfo.nFriend = 0;
    pNoteInfo.nSendSMS = 1;
    pNoteInfo.strJYEXTag = @"";
    return pNoteInfo;
}


//增加或修改一条笔记（暂不支持删除附件）
+ (BOOL)addNote:(TNoteInfo *)noteInfo ItemInfo:(NSArray *)arrItem
{
    //先更改笔记状态
    [self updateHeadForEdit:noteInfo.tHead];
        
    //插入note记录
    if (![AstroDBMng addNote:noteInfo])
    {
        LOG_ERROR(@"AddNote FAILED");
        return NO;
    }
    
    //把该条笔记所有的item和NoteXItem先改为删除标志、编辑标志(只修改标志，不删除记录和文件)
    [AstroDBMng DeleteAllItemNoFileByNote:noteInfo.strNoteIdGuid includeDelete:NO];

    int nItemOrder = [AstroDBMng getNote2ItemMaxOrderByNoteGuid:noteInfo.strNoteIdGuid];
    //插入项目记录和项目关联表记录
    if ( arrItem ) {
        for ( id obj in arrItem )
        {
            TItemInfo *pInfo = (TItemInfo *)obj;
        
            TNoteXItem *pNoteXItemInfo = [AstroDBMng getNote2Item:noteInfo.strNoteIdGuid itemID:pInfo.strItemIdGuid];
            if ( !pNoteXItemInfo )  //新增加的
            {
                TRecHead *pHead = [self createHead];
                pNoteXItemInfo = [[TNoteXItem new] autorelease];
                pNoteXItemInfo.tHead = pHead;
                
                pNoteXItemInfo.strNoteIdGuid = noteInfo.strNoteIdGuid;
                pNoteXItemInfo.strItemIdGuid = pInfo.strItemIdGuid;
                pNoteXItemInfo.nCreatorID = [TheCurUser.sNoteUserId intValue];
                
                pNoteXItemInfo.strCatalogBelongToGuid = noteInfo.strCatalogIdGuid;  //当前笔记所在目录
                pNoteXItemInfo.nItemVer = pInfo.tHead.nCurrVerID; 
                pNoteXItemInfo.nNeedDownlord = DOWNLOAD_NONEED;        //是否下载 (本地用); 
                pNoteXItemInfo.nItemOrder = ++nItemOrder; 
            }
            else  //原来就有的项目
            {
                //先更改项目状态
                if ([pInfo.strItemIdGuid isEqualToString:noteInfo.strFirstItemGuid]) {  //第一项HTML
                    [self updateHeadForEdit:pInfo.tHead]; //更改编辑状态
                    pInfo.tHead.nDelState = DELETESTATE_NODELETE;  //恢复不删除
                    pInfo.nUploadSize = 0; //上传字节为0
                    
                    [self updateHeadForEdit:pNoteXItemInfo.tHead];  //更改编辑状态
                    pNoteXItemInfo.tHead.nDelState = DELETESTATE_NODELETE; //恢复不删除
                }
                else {
                    pInfo.tHead.nEditState = EDITSTATE_NOEDIT;  //恢复不编辑
                    pInfo.tHead.nDelState = DELETESTATE_NODELETE;  //恢复不删除
                    pInfo.nUploadSize = 0; //上传字节为0
                    
                    pNoteXItemInfo.tHead.nEditState = EDITSTATE_NOEDIT;  //恢复不编辑
                    pNoteXItemInfo.tHead.nDelState = DELETESTATE_NODELETE; //恢复不删除
                }
            }
            
            [AstroDBMng saveToDB_Note2ItemMgr:pNoteXItemInfo]; //更新
            [AstroDBMng addItem:pInfo];
        }
    }
    
    //更改当前笔记所在目录(包括更改父目录的)的记录总数
    [BizLogic updateCateNoteCount:noteInfo.strCatalogIdGuid];
    
    NSLog(@"noteEdit:send sync message");
    //发同步上传消息
    //[[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :noteInfo];
    [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_JYEX_NOTE :nil :nil :noteInfo];
    
    //显示进展信息
    [UIProgress dispProgress];

    //发通知消息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    
    return YES;
}

//只更新笔记信息
+(BOOL)updataNoteInfo:(TNoteInfo *)noteInfo
{
    //插入note记录
    if (![AstroDBMng addNote:noteInfo])
    {
        LOG_ERROR(@"AddNote FAILED");
        return NO;
    }
    
    //更改当前笔记所在目录(包括更改父目录的)的记录总数
    [BizLogic updateCateNoteCount:noteInfo.strCatalogIdGuid];
    
    NSLog(@"noteEdit:send sync message");
    //发同步上传消息
    [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :noteInfo];
    
    //发通知消息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    return YES;
}

//增加或更改笔记，只更改笔记信息(笔记信息已填充好，同步过程中使用，不发通知消息) 
+ (BOOL)addNoteForSync:(TNoteInfo *)noteInfo
{    
    //插入note记录
    if (![AstroDBMng addNote:noteInfo])
    {
        LOG_ERROR(@"AddNote FAILED");
        return NO;
    }
    
    //更改当前笔记所在目录(包括更改父目录的)的记录总数
    [BizLogic updateCateNoteCount:noteInfo.strCatalogIdGuid];
        
    return YES;
}

//删除一条笔记
+ (BOOL)deleteNote:(NSString *)guidNote SendUpdataMsg:(BOOL)bSendFlag
{
    TNoteInfo *noteInfo;
    if ( !(noteInfo = [AstroDBMng getNote:guidNote]) )
    {
        return NO;
    }
    
    //根据笔记GUID，获得Note2Item列表
    NSArray *arrNote2Item = [AstroDBMng getNote2ItemList:guidNote includeDelete:YES];
    
    if (noteInfo.tHead.nCurrVerID == 0)  //还没上传，直接删除
    {
        //根据笔记guid,和itemID，直接删除笔记和项目对应表和项目表
        
        //直接删除笔记表
        [AstroDBMng deleteNoteFromDB:guidNote];  //删除笔记
        
        if ( arrNote2Item ) {
            for (id obj in arrNote2Item ) {
                TNoteXItem *pNoteXItem = (TNoteXItem *)obj;
                TItemInfo *pItemInfo = [AstroDBMng getItem:pNoteXItem.strItemIdGuid];
                
                [AstroDBMng deleteNote2ItemFromDB:pNoteXItem];  //删除NoteXItem
                [AstroDBMng deleteItemFromDB:pNoteXItem.strItemIdGuid];  //删除 Item
                
                //还要增加删除文件
                NSString *filename = [CommonFunc getItemPath:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
                [CommonFunc deleteFile:filename];
                if ([CommonFunc isImageFile:pItemInfo.strItemExt]) {
                    //删除图片原文件
                    filename = [CommonFunc getItemPathAddSrc:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
                    [CommonFunc deleteFile:filename];
                }
            }
        }
    }
    else
    {
        //设置为删除标志
        //[self updateHeadForDelete:noteInfo.tHead];
        noteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
        [AstroDBMng updateNote:noteInfo]; //置为删除标志
        
        if ( arrNote2Item ) {
            for (id obj in arrNote2Item ) {
                TNoteXItem *pNoteXItem = (TNoteXItem *)obj;
                //[self updateHeadForDelete:pNoteXItem.tHead]; //置为删除标志
                noteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
                [AstroDBMng saveNote2Item:pNoteXItem];
                
                TItemInfo *pItemInfo = [AstroDBMng getItem:pNoteXItem.strItemIdGuid];
                //[self updateHeadForDelete:pItemInfo.tHead]; //置为删除标志
                noteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
                [AstroDBMng saveItem:pItemInfo];
                
                //还要增加删除文件
                //还要增加删除文件
                NSString *filename = [CommonFunc getItemPath:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
                [CommonFunc deleteFile:filename];
                if ([CommonFunc isImageFile:pItemInfo.strItemExt]) {
                    //删除图片原文件
                    filename = [CommonFunc getItemPathAddSrc:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
                    [CommonFunc deleteFile:filename];
                }
            }
        }
    }
    
    //更改当前目录总的记录数(同时更改父目录)
    
    [self updateCateNoteCount:noteInfo.strCatalogIdGuid];
    
    //检查发送更新消息的标志,如果是YES就发送消息,否则不发
    if(bSendFlag)
    {
        //NSLog(@"noteEdit:send sync message");
        //发同步上传消息
        //[[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :noteInfo];
        
        //发通知消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    }
    
    
    return YES;
}


+ (void) deleteOldNote
{
    NSArray *arrNote = [self getAllNoteByCateGuid:[_GLOBAL getCurrentCateGUID]];
    if ( arrNote ) {
        for (id obj in arrNote ) {
            TNoteInfo *note = (TNoteInfo *)obj;
            NSTimeInterval interval = -31*24*3600;
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
            NSString *dateStr = [CommonFunc getTimeString:date format:nil];
            if ( [dateStr compare:note.tHead.strModTime] == NSOrderedDescending) { //大于
                [self deleteNote:note.strNoteIdGuid SendUpdataMsg:YES];
            }
        }
    }
    
    //清除时间超过1个半月的无主文件和目录
    NSString *strPath = [CommonFunc getTempDir] ;
    NSFileManager *fm = [NSFileManager defaultManager] ;
    NSArray *flist = [fm contentsOfDirectoryAtPath:strPath error:nil];
    NSLog( @"%@", flist ) ;
    [fm changeCurrentDirectoryPath:strPath] ;
    for(NSString* name in flist)
    {
        if ( [name isEqualToString:@"recordicon.png"] ) continue;
         
        NSError *error = nil;
        NSDictionary* properties =
        [fm attributesOfItemAtPath:[strPath stringByAppendingPathComponent:name] error:&error];
        if ( !error) {
            NSString *type = [properties objectForKey:NSFileType];
            if ( [type isEqualToString:NSFileTypeDirectory]) continue;
                
            NSDate* modDate = [properties objectForKey:NSFileModificationDate];
            NSTimeInterval interval = [modDate timeIntervalSinceNow];
            NSLog(@"file:%@ modify date:%@ interval=%.1f",name,[modDate description],interval );
            if ( interval <= -45*24*3600 ) {
                [fm removeItemAtPath:name error:nil] ;
            }
        }
    }
}



//读取一条笔记
+ (TNoteInfo *)getNote:(NSString *)guidNote
{
    TNoteInfo *pNoteInfo = [AstroDBMng getNote:guidNote];
    return pNoteInfo;
}

//读取一条笔记的所有Item
+ (NSArray *)getAllItemByNoteGuid:(NSString *)guidNote
{
    TNoteInfo *pNoteInfo = [AstroDBMng getNote:guidNote];
    if ( !pNoteInfo ) return nil;
    
    NSArray *arrItemInfo1 = [AstroDBMng getItemListByNote:guidNote includeDelete:NO];
    if ( !arrItemInfo1 ) return nil;  //至少应该存在一条
    
    NSMutableArray *arrItemInfo = [NSMutableArray arrayWithArray:arrItemInfo1];
    
    //把第一条item，排在数组中的第一个位置
    for (int index=0;index<[arrItemInfo count];index++)
    {
        TItemInfo *pItemInfo = [arrItemInfo objectAtIndex:index];
        if ( [pItemInfo.strItemIdGuid isEqualToString:pNoteInfo.strFirstItemGuid] ) {
            if ( index != 0 ) {  //插入第一的位置
                [arrItemInfo exchangeObjectAtIndex:0 withObjectAtIndex:index];
            }
            break;
        }
    }
    
    return arrItemInfo;
    
}



//读取某个目录下的所有笔记
+ (NSArray *)getAllNoteByCateGuid:(NSString *)strCateGuid
{
    return [AstroDBMng getNoteListByCate:strCateGuid];
}

//搜索笔记的标题和内容是否含有关键字
+ (NSArray*)getNoteListBySearch:(NSString *)strKey catalog:(NSString *)strCatalog
{
    return [AstroDBMng getNoteListBySearch:strKey catalog:strCatalog];
}

//读取最新的的N篇笔记
//+ (NSArray*)getLatestNoteList:(int)count
//{
//    return [AstroDBMng getMostRecentNotes:count];
//}

//返回需同步的记录数(包括上传和下载)
+ (int)needSyncNotesCount
{
    return [AstroDBMng needSyncNotesCount];
}

//2014.3.11
//初始化照片信息
+(TNoteInfo *)createPicInfo
{
    TNoteInfo *pinfo = [self createNoteInfo:GUID_ZERO];
    pinfo.nNoteType = NOTE_PIC;
    return pinfo;
}

//增加一张照片
+ (BOOL)addPic:(NSString *)strPicNameGuid title:(NSString *)strTitle albumname:(NSString *)strAlbumName albumid:(NSString *)strAlbumID uid:(NSString *)strUid username:(NSString *)strUsername

{
    TNoteInfo *pNote = [self createPicInfo];
    pNote.strNoteTitle = strTitle;
    pNote.strFirstItemGuid = strPicNameGuid;
    pNote.strContent = strAlbumName;
    pNote.strNoteSrc = strAlbumID;
    pNote.strNoteClassId = strUid;  //add 2014.9.26
    pNote.strJYEXTag = strUsername; //add 2014.9.26
    
    if ( !strAlbumID || [strAlbumID isEqualToString:@""] ) {
        pNote.strContent = @"默认相册";
        pNote.strNoteSrc = @"0";
        pNote.strNoteClassId = TheCurUser.sUserID; //add 2014.9.26
        pNote.strJYEXTag = TheCurUser.sUserName; //add 2014.9.26
    }
    
    pNote.strCatalogIdGuid = [_GLOBAL defaultCateID];
    
    //生成Item
    TItemInfo *pItemInfo = [BizLogic CreateItemInfo:NI_PIC itemguid:strPicNameGuid noteguid:pNote.strNoteIdGuid];
    
    NSString *imagePathSrc = [CommonFunc getItemPathAddSrc:strPicNameGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    NSString *urlPath =[NSString stringWithFormat:@"%@.%@",strPicNameGuid,[CommonFunc getItemTypeExt:NI_PIC]];
    
    //更新属性
    pItemInfo.nItemSize = (int)[CommonFunc GetFileSize:imagePathSrc];
    pItemInfo.strItemTitle = urlPath;  //文件名
    
    
    NSLog(@"src imgsize=%lld\n",[CommonFunc GetFileSize:imagePathSrc]);
    
    return [self addNote:pNote ItemInfo:[NSArray arrayWithObject:pItemInfo]];
}




//项目操作
//------------------------------------------------------------------------------------
//初始化一条笔记与笔记项关联
+(TNoteXItem *)createNoteXItem
{
    TRecHead *pHead = [self createHead];
    TNoteXItem *pNoteXItemInfo = [[TNoteXItem new] autorelease];
    pNoteXItemInfo.tHead = pHead; 
    
    pNoteXItemInfo.strNoteIdGuid = GUID_ZERO;
    pNoteXItemInfo.strItemIdGuid = GUID_ZERO;
    pNoteXItemInfo.nCreatorID = [TheCurUser.sNoteUserId intValue];
    
    pNoteXItemInfo.strCatalogBelongToGuid = GUID_ZERO;  //当前目录上一级目录 ,要更换
    pNoteXItemInfo.nItemVer = [TheCurUser.sNoteUserId intValue];
    pNoteXItemInfo.nNeedDownlord = DOWNLOAD_NONEED; 
    pNoteXItemInfo.nItemOrder = 0; 
    
    return pNoteXItemInfo;
}


//初始化一条项目(item)，自动生成item编号
+(TItemInfo *)CreateItemInfo:(ENUM_ITEM_TYPE)nItemType itemguid:(NSString *)strItemGuid noteguid:(NSString *)strNoteGuid
{
    TRecHead *pHead = [self createHead];
    TItemInfo *pItemInfo = [[TItemInfo new] autorelease];
    pItemInfo.tHead = pHead; 
    
    pItemInfo.strItemIdGuid = strItemGuid; //项目编号
    pItemInfo.strNoteIdGuid = strNoteGuid;
    pItemInfo.nCreatorID = [TheCurUser.sNoteUserId intValue];         //ITEM创建者编号,备用
    pItemInfo.nItemType = nItemType;          //ITEM的类型
    pItemInfo.strItemExt = [CommonFunc getItemTypeExt:nItemType];   //ITEM的扩展名
    pItemInfo.nItemSize = 0;          //项目大小 
    pItemInfo.nEncryptFlag = EF_NOT_ENCRYPTED;	    //加密标识
    pItemInfo.strItemTitle = @"";  //文件名
    pItemInfo.nUploadSize = 0;
    pItemInfo.strServerPath = @"";
    return pItemInfo;
}

//初始化一条项目(item)
+(TItemInfo *)CreateItemInfo
{
    TRecHead *pHead = [self createHead];
    TItemInfo *pItemInfo = [[TItemInfo new] autorelease];
    pItemInfo.tHead = pHead; 
    
    pItemInfo.strItemIdGuid = GUID_ZERO; //项目编号
    pItemInfo.strNoteIdGuid = GUID_ZERO;
    pItemInfo.nCreatorID = [TheCurUser.sNoteUserId intValue];         //ITEM创建者编号,备用
    pItemInfo.nItemType = NI_HTML;          //ITEM的类型
    pItemInfo.strItemExt = [CommonFunc getItemTypeExt:NI_HTML];   //ITEM的扩展名
    pItemInfo.nItemSize = 0;          //项目大小 
    pItemInfo.nEncryptFlag = EF_NOT_ENCRYPTED;	    //加密标识
    pItemInfo.strItemTitle = @"";  //文件名
    pItemInfo.nUploadSize = 0;
    pItemInfo.strServerPath = @"";
    return pItemInfo;
}

//笔记冲突处理
//----------------------------------------------------------------------------------------

//变更笔记
+(BOOL)changeNote:(NSString *)strOldNoteGuid
{
    TNoteInfo *pOldNoteInfo = [AstroDBMng getNote:strOldNoteGuid];
    if ( !pOldNoteInfo ) return NO;
    
    NSString *strNewNoteGuid = [CommonFunc createGUIDStr]; //新笔记guid
    NSString *strNewFirstItemGuid;   //新笔记第一项item
    NSString *strNewFirstItemFileName; //新笔记第一项文件名
    NSMutableArray *arrOldItemGuid = [NSMutableArray array];   //旧item项guid数据
    NSMutableArray *arrNewItemGuid = [NSMutableArray array];   //新item项guid数据
    
    NSArray *arrOldNoteXItemList = [AstroDBMng getNote2ItemList:strOldNoteGuid includeDelete:YES];
    if ( !arrOldNoteXItemList ) return NO;
    
    for ( id obj in arrOldNoteXItemList ) {
        TNoteXItem *pOldNoteXItem = (TNoteXItem *)obj;
        TItemInfo *pOldItemInfo = [AstroDBMng getItem:pOldNoteXItem.strItemIdGuid];
        
        NSString *strNewItemGuid = [CommonFunc createGUIDStr];
        
        //添加到数组
        [arrOldItemGuid addObject:pOldItemInfo.strItemIdGuid];
        [arrNewItemGuid addObject:strNewItemGuid];
        
        //文件名
        NSString *strOldItemFile = [CommonFunc getItemPath:pOldItemInfo.strItemIdGuid fileExt:pOldItemInfo.strItemExt];
        NSString *strNewItemFile = [CommonFunc getItemPath:strNewItemGuid fileExt:pOldItemInfo.strItemExt];
        //拷贝文件
        [[NSFileManager defaultManager] removeItemAtPath:strNewItemFile error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:strOldItemFile toPath:strNewItemFile error:nil];
        
        if ( [CommonFunc isImageFile:pOldItemInfo.strItemExt] ) { //图片文件
            //文件名
            NSString *strOldItemFileSrc = [CommonFunc getItemPathAddSrc:pOldItemInfo.strItemIdGuid fileExt:pOldItemInfo.strItemExt];
            NSString *strNewItemFileSrc = [CommonFunc getItemPathAddSrc:strNewItemGuid fileExt:pOldItemInfo.strItemExt];
            //拷贝文件
            [[NSFileManager defaultManager] removeItemAtPath:strNewItemFileSrc error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:strOldItemFileSrc toPath:strNewItemFileSrc error:nil];
        }
        
        //更改笔记记录的firstitem
        if ( [pOldNoteInfo.strFirstItemGuid isEqualToString:pOldItemInfo.strItemIdGuid] )
        {
            strNewFirstItemGuid = strNewItemGuid;
            strNewFirstItemFileName = strNewItemFile;
        }
        
        //旧版本,编辑标志为不编辑，版本号为0
        pOldItemInfo.tHead.nCurrVerID = 0;
        pOldItemInfo.tHead.nCreateVerID = 0;
        pOldItemInfo.tHead.nEditState = EDITSTATE_NOEDIT;
        [AstroDBMng addItem:pOldItemInfo];  //旧item
        
        //新item,编辑标志为编辑，版本号为0
        pOldItemInfo.strItemIdGuid = strNewItemGuid;
        pOldItemInfo.strNoteIdGuid = strNewNoteGuid;
        pOldItemInfo.tHead.nEditState = EDITSTATE_EDITED;
        pOldItemInfo.nUploadSize = 0;  //上传的字节变为0
        pOldNoteInfo.strFilePath = [CommonFunc getItemPath:strNewItemGuid fileExt:pOldItemInfo.strItemExt];
        [AstroDBMng addItem:pOldItemInfo];  //新item
        
        pOldNoteXItem.tHead.nCurrVerID = 0;
        pOldNoteXItem.tHead.nCreateVerID = 0;
        pOldNoteXItem.tHead.nEditState = EDITSTATE_NOEDIT;
        [AstroDBMng updateNote2Item:pOldNoteXItem];  //旧NoteXItem
        
        pOldNoteXItem.strItemIdGuid = strNewItemGuid;
        pOldNoteXItem.strNoteIdGuid = strNewNoteGuid;
        pOldNoteXItem.tHead.nEditState = EDITSTATE_EDITED;
        [AstroDBMng updateNote2Item:pOldNoteXItem];  //新NoteXItem
    }
    
    //处理HTML文件，替换guid (要不要判断是不是HTML文件)
    [CommonFunc replaceHTMLItemGuid:strNewFirstItemFileName oldguid:arrOldItemGuid newguid:arrNewItemGuid];

    //清空数组
    [arrOldItemGuid removeAllObjects];
    [arrNewItemGuid removeAllObjects];
    
    //最后更新笔记
    pOldNoteInfo.tHead.nCurrVerID = 0;
    pOldNoteInfo.tHead.nCreateVerID = 0;
    pOldNoteInfo.tHead.nEditState = EDITSTATE_NOEDIT;
    [AstroDBMng updateNote:pOldNoteInfo];  //旧Note
    
    pOldNoteInfo.strNoteIdGuid = strNewNoteGuid;
    pOldNoteInfo.strFirstItemGuid = strNewFirstItemGuid;
    pOldNoteInfo.tHead.nEditState = EDITSTATE_EDITED; //编辑状态
    pOldNoteInfo.strNoteTitle = [NSString stringWithFormat:@"(冲突)%@",pOldNoteInfo.strNoteTitle];
    pOldNoteInfo.strFilePath = [CommonFunc getItemPath:strNewFirstItemGuid fileExt:pOldNoteInfo.strFileExt];
    [AstroDBMng addNote:pOldNoteInfo];  //新Note
    
    return YES;
}


//把不是HTML的笔记转换成HTML笔记
+(BOOL)changeToHtmlNote:(NSString *)strGuidNote
{
    //1.提取笔记信息、提取item信息
    //2.先处理first item，根据扩展名类型来处理， 如果是 txt ，放到文本，如果是图片 和 其它，生成 html 链接
    //3.依次处理其它 item
    //4.保存HTML文件
    
    TNoteInfo *pNoteInfo = [AstroDBMng getNote:strGuidNote];
    if ( !pNoteInfo ) return NO;
    NSArray *arrItemInfo1 = [AstroDBMng getItemListByNote:strGuidNote includeDelete:NO];
    if ( !arrItemInfo1 || [arrItemInfo1 count] == 0 ) return NO;
    
    NSMutableArray *arrItemInfo = [NSMutableArray arrayWithArray:arrItemInfo1];
    
    //把第一条item，排在数组中的第一个位置
    for (int index=0;index<[arrItemInfo count];index++)
    {
        TItemInfo *pItemInfo = [arrItemInfo objectAtIndex:index];
        if ( [pItemInfo.strItemIdGuid isEqualToString:pNoteInfo.strFirstItemGuid] ) {
            if ( index != 0 ) {  //插入第一的位置
                [arrItemInfo exchangeObjectAtIndex:0 withObjectAtIndex:index];
            }
            break;
        }
    }
    
    NSString *strHTMLContent = @"";
    for (int index=0;index<[arrItemInfo count];index++)
    {
        TItemInfo *pItemInfo = [arrItemInfo objectAtIndex:index];
        NSString *strFullFileName = [CommonFunc getItemPath:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
        NSString *strFileName = [NSString stringWithFormat:@"%@.%@",pItemInfo.strItemIdGuid,pItemInfo.strItemExt];
        if ( [pItemInfo.strItemExt isEqualToString:@"txt"] || [pItemInfo.strItemExt isEqualToString:@"TXT"]) {
            NSString *strFileContent = [NSString stringWithContentsOfFile:strFullFileName encoding:NSUTF8StringEncoding error:nil];
            if ( strFileContent ) strHTMLContent = [strHTMLContent stringByAppendingString:strFileContent];
            
            strHTMLContent = [strHTMLContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            strHTMLContent = [strHTMLContent stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
            strHTMLContent = [strHTMLContent stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];   
        }
        else if ( [CommonFunc isImageFile:pItemInfo.strItemExt] ) {
            NSString *requeststr =[NSString stringWithFormat:@"<div><img src=\"%@\"></div><br><br> ",strFileName];
            strHTMLContent = [strHTMLContent stringByAppendingString:requeststr];
        }
        else  //其它
        {
            NSString *requeststr =[NSString stringWithFormat:@"<div><a href=\"%@\">%@</a></div><br><br><br> ",strFileName,strFileName]; 
            strHTMLContent = [strHTMLContent stringByAppendingString:requeststr];
        }
    }
    
    //保存HTML文件
    [CommonFunc replaceHTMLBody:[CommonFunc getItemPath:pNoteInfo.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_HTML]] content:strHTMLContent];
    
    return YES;
    
}



/*
//更新一条笔记
+ (BOOL)updateNote:(NoteInfo)noteInfo
{
    return [NoteMgr updateNote:noteInfo];
}

//复位一条笔记
+ (BOOL)resetNote:(NoteInfo)noteInfo {
	return [NoteMgr resetNote:noteInfo];
}

+ (BOOL)updateNote2Item:(GUID)noteGuid item:(GUID)itemGuid {
	A2BInfo a2bInfo;
	[Note2ItemMgr getNote2Item:noteGuid itemID:itemGuid note2ItemInfo:&a2bInfo];
	[Note2ItemMgr updateNote2Item:a2bInfo];
	return YES;
}

+ (BOOL)saveNote:(NoteInfo)noteInfo
{
    return [NoteMgr saveNote:noteInfo];
}
*/
 
//笔记冲突时，把笔记设为新的笔记
/*
+ (BOOL)resaveNote:(NoteInfo &)noteInfo
{
	//获取该笔记对应的文件的路径
	NSString *filePath = [CommonFunc getItemPath:noteInfo.guidFirstItem fileExt:noteInfo.wszFileExt];
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:filePath]) {
		
		// 获取noteInfo对应的itemInfo
		ItemInfo itemInfo;
		[Business getItem:noteInfo.guidFirstItem itemInfo:&itemInfo];
		
		// 读取文件的数据
		NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filePath];
		NSData *fData = [file readDataToEndOfFile];

		GUID guidNote = [CommonFunc createGUID];
		GUID guidItem = [CommonFunc createGUID];
		NSString *strItemGuid = [CommonFunc guidToNSString:guidItem];
		
		unistring strExtFuck = noteInfo.wszFileExt;
		
		NSString *strFilePathNew = [NSString stringWithFormat:@"%@/%@.%@", [CommonFunc getTempDir], strItemGuid, [NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()]];
		[fm createFileAtPath:strFilePathNew contents:fData attributes:nil];
		
		// 创建新的NoteInfo和ItemInfo
		NoteInfo noteInfoNew;
		ItemInfo itemInfoNew;
		NSString *strTitle = [NSString stringWithFormat:@"%@_副本", [NSString stringWithCharacters:noteInfo.strTitle.c_str() length:noteInfo.strTitle.size()]];
    
        [CommonFunc makeNoteInfo:&noteInfoNew noteID:guidNote title:strTitle noteType:(EM_NOTE_TYPE)noteInfo.dwType size:noteInfo.dwSize star:noteInfo.nStarLevel fileExt:[NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()] firstItemID:guidItem];
		 [CommonFunc makeItemInfo:&itemInfoNew itemId:guidItem itemType:(ENUM_ITEM_TYPE)itemInfo.nNoteItemType fileExt:[NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()] size:itemInfo.m_unDataLen];
		
        noteInfoNew.nEncryptFlag = noteInfo.nEncryptFlag;
        itemInfoNew.nEncryptFlag = itemInfo.nEncryptFlag;
        
		// 保存该笔记
		[Business addNote:noteInfoNew firstItemInfo:itemInfoNew];
		return YES;
	}
	else {
		return NO;
	}
}
*/

/*
+ (BOOL)resaveNoteWithGuid:(GUID &)noteGuid {
	NoteInfo ni;
	[Business getNote:noteGuid noteInfo:&ni];
	
	[Business resaveNote:ni];
}


+ (int)needUploadNotesCount
{
    return [NoteMgr needUploadNotesCount];
}

+ (BOOL)deleteNote:(GUID)guidNote
{
    return [NoteMgr deleteNote:guidNote];
}

+ (BOOL)deleteNoteFromDB:(GUID)guidNote
{
    return [NoteMgr deleteNoteFromDB:guidNote];
}



+ (BOOL)getNeedDownNoteList:(GUID)guidCate recursive:(BOOL)recursive noteList:(std::vector<NoteInfo>*)pNoteList
{
    return [NoteMgr getNeedDownNoteList:guidCate recursive:recursive noteList:pNoteList];
}

+ (BOOL)needDecrypt:(GUID)guidNote
{
    return [NoteMgr needDecrypt:guidNote];
}

+ (int)decryptNote:(GUID)guidNote password:(string)strPassword;
{
    return [NoteMgr decryptNote:guidNote password:strPassword];
}

+ (BOOL)resetEncryptStatus:(GUID)guidNote
{
    return YES;
}
*/


/*
 
// Note2Item
+ (BOOL)saveNote2Item:(A2BInfo)a2bInfo
{
    return [Note2ItemMgr saveNote2Item:a2bInfo];
}

+ (BOOL)saveNote2ItemFromSrv:(A2BInfo)a2bInfo
{
    
    if (a2bInfo.tHead.nDelState == STATE_DELETE)
    {
        //直接删除item与note2item
        [Note2ItemMgr deleteNote2ItemFromDB:a2bInfo];
        [ItemMgr deleteItemFromDB:a2bInfo.guidSecond];
        return YES;
    }
    
    return [Note2ItemMgr saveToDB:a2bInfo];
}

+ (BOOL)getNote2Item:(GUID)guidNote itemID:(GUID)guidItem note2ItemInfo:(A2BInfo*)pInfo
{
    return [Note2ItemMgr getNote2Item:guidNote itemID:guidItem note2ItemInfo:pInfo];
}

+ (BOOL)getNeedUploadItemList:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList
{
    return [Note2ItemMgr getNeedUploadItemList:guidNote itemList:pItemList];
}

+ (BOOL)getItem:(GUID)guidItem itemInfo:(ItemInfo*)pItem
{
    return [ItemMgr getItem:guidItem itemInfo:pItem];
}

// Item
+ (BOOL)updateItemLen:(GUID)guidItem newItemLen:(int)len
{
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        return NO;
    }

    objItem.m_unDataLen = len;
    [ObjMgr updateHead:&objItem.tHead];
    
    return [ItemMgr saveItem:objItem];
}

+ (BOOL)updateItem:(GUID)guidItem encrypttype:(int)encrypttype {
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        return NO;
    }
    
    objItem.nEncryptFlag = encrypttype;
    [ObjMgr updateHead:&objItem.tHead];
    
    return [ItemMgr saveItem:objItem];
}

+ (BOOL)updataEncryptItem:(GUID)guidNote itemID:(GUID)guidItem;
{
    WORK_KEY_INFO workKeyInfo;
    if (![NoteMgr getWorkKey:guidNote workKey:&workKeyInfo])
        return NO;
    
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        MLOG(@"getItem failed");
        return NO;
    }
    
    if (objItem.nEncryptFlag == EF_HIGH_ENCRYPTED)
    {
        if (![ItemMgr encryptItem:&objItem workKey:workKeyInfo.ucWorkKey])
        {
            MLOG(@"encryptItem failed");
            return NO;
        }
    }
    else if (objItem.nEncryptFlag == EF_NORMAL_ENCRYPTED) {
        if (![ItemMgr encryptItem:&objItem workKey:workKeyInfo.ucWorkKey]) {
            MLOG(@"encryptItem failed");
            return NO;
        }
    }
    else
    {
        
    }
    
    NoteInfo objNote;
    [NoteMgr getNote:guidNote noteInfo:&objNote];
    objNote.dwSize = objItem.m_unDataLen;
    [NoteMgr updateNote:objNote];
    
    return YES;
}

+ (BOOL)getItemListByNote:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList {
    return [Note2ItemMgr getItemListByNote:guidNote itemList:pItemList];
}

+ (BOOL)saveItem:(ItemInfo)itemInfo
{
    return [ItemMgr saveItem:itemInfo];
}

+ (BOOL)deleteItem:(GUID)guidItem
{
    return [ItemMgr deleteItem:guidItem];
}

+ (BOOL)deleteItemFromDB:(GUID)guidItem
{
    return [ItemMgr deleteItemFromDB:guidItem];
}

//charge control
+ (BOOL)addFlows:(int) bytes
{
    return [DischargeMgr addFlows:bytes];
}

+ (uint64_t)getDishargeSince:(NSString *)date
{
    return [DischargeMgr getDishargeSince:date];
}

+ (NSString *)getLastUpdateDay
{
    return [DischargeMgr getLastUpdateDay];
}

//tb_card_info
+ (int)getMaxDisCharge
{
    return [DischargeMgr getMaxDisCharge];
}

+ (BOOL)setMaxDisCharge:(int)maxCharge
{
    return [DischargeMgr setMaxDisCharge:maxCharge];
}

+ (int)getClearDay
{
    return [DischargeMgr getClearDay];
}

+ (BOOL)setClearDay:(int)clearDay
{
    return [DischargeMgr setClearDay:clearDay];
}
+ (BOOL)getGPRSFlag
{
    return [DischargeMgr getGPRSFlag];
}

+ (BOOL)setGPRSFlag:(BOOL)flag
{
    return [DischargeMgr setGPRSFlag:flag];
}

+ (std::string)getCfgString:(const char*)pszKey name:(const char*)pszName
{
    return [CfgMgr getCfgString:pszKey name:pszName];
}
+ (BOOL)setCfgString:(const char*)pszKey name:(const char*)pszName value:(const char*)szValue
{
    return [CfgMgr setCfgString:pszKey name:pszName value:szValue];
}
+ (uint32_t)getCfgUint:(const char*)pszKey name:(const char*)pszName
{
    return [CfgMgr getCfgUint:pszKey name:pszName];
}
+ (BOOL)setCfgUint:(const char*)pszKey name:(const char*)pszName value:(uint32_t)nValue
{
    return [CfgMgr setCfgUint:pszKey name:pszName value:nValue];
}

+ (BOOL)setMasterKey:(unsigned char*)pMasterKey length:(int)len
{
    return [CfgMgr setMyMasterKey:pMasterKey length:len];
}
+ (BOOL)getMasterKey:(char *)outdata {
    
    return [CfgMgr getMyMasterKey:(unsigned char *)outdata];
}

+ (BOOL)needUpload:(RecHead*)pHead
{
    return [NoteMgr needUpload:pHead];
    
}

+ (bool)changeToPassword:(NSString *)newpassword oldPassword:(NSString *)oldPassword toEncryptType:(int)newtype oldEncryptType:(int)oldtype info:(NoteInfo *)noteinfo {
    if (newpassword == nil || oldPassword == nil) {
        return false;
    }
    if ([newpassword isEqualToString:oldPassword] && newtype == oldtype) {
        return true;
    }
    
    // 先解析出原来的数据
    NSString *path = [CommonFunc getItemPath:noteinfo->guidFirstItem fileExt:noteinfo->wszFileExt];
    NSFileHandle * file  = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fData = [file readDataToEndOfFile];
    
    int result = ENCRYPT_ERR_PROCESS;
    unsigned char *src = NULL;
    unsigned char *dst = NULL;
    int srclen = 0;
    int dstlen = 0;
    
    src = (unsigned char *)fData.bytes;
    srclen = fData.length;
    
    // 根据密码解密文件的数据
    if (oldtype == EF_NORMAL_ENCRYPTED) {
        result = [ObjEncrypt DecryptItemEx:src len:srclen pwd:[oldPassword cStringUsingEncoding:NSASCIIStringEncoding] outdata:&dst outlen:&dstlen];
    }
    else if (oldtype == EF_HIGH_ENCRYPTED) {
        result = [ObjEncrypt DecryptItem:src len:srclen pwd:[oldPassword cStringUsingEncoding:NSASCIIStringEncoding] outdata:&dst outlen:&dstlen];
    }
    
    // 解密正确
    if (result == ENCRYPT_SUCCESS) {
        
        // 将数据保存成文件，以便显示出来
        NSData *dstData = nil;
        if (oldtype == EF_HIGH_ENCRYPTED) {
            dstData = [NSData dataWithBytes:(dst+8) length:(dstlen-8)];
        }
        else if (oldtype == EF_NORMAL_ENCRYPTED) {
            dstData = [NSData dataWithBytes:dst length:dstlen];
        }
        if (nil != dstData) {                
            // 得到了原数据
            if ([newpassword isEqualToString:@""]) {
                // 直接保存成文件，并且将noteinfo中的加密位设置成不加密
                noteinfo->nEncryptFlag = EF_NOT_ENCRYPTED;
                // 将数据直接保存回去
                [dstData writeToFile:path atomically:NO];
                
                [Business updateItemLen:noteinfo->guidFirstItem newItemLen:dstData.length];
                [Business updateItem:noteinfo->guidFirstItem encrypttype:EF_NOT_ENCRYPTED];
                [Business updateNote:*noteinfo];
            }
            // 按照新的方式加密，并保存
            else {
                NSData *data = nil;
                bool writetofile = false;
                char *dstdata = NULL;
                int dstlen = 0;
                if (newtype == EF_NORMAL_ENCRYPTED) {
                    if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItemEx:(const char *)dstData.bytes srclen:dstData.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[newpassword cStringUsingEncoding:NSASCIIStringEncoding]]) {
                            data = [NSData dataWithBytes:dstdata length:dstlen];
                            writetofile = [data writeToFile:path atomically:NO];
                        }
                }
                else if (newtype == EF_HIGH_ENCRYPTED) {
                    if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItem:(const char *)dstData.bytes srclen:dstData.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[newpassword cStringUsingEncoding:NSASCIIStringEncoding]]) {
                            data = [NSData dataWithBytes:dstdata length:dstlen];
                            writetofile = [data writeToFile:path atomically:NO];
                        }
                }
                if (writetofile) {
                    noteinfo->nEncryptFlag = newtype;
                    noteinfo->dwSize = data.length;
                    [Business updateItemLen:noteinfo->guidFirstItem newItemLen:data.length];
                    [Business updateItem:noteinfo->guidFirstItem encrypttype:newtype];
                    [Business updateNote:*noteinfo];
                }
                if (dstdata) {
                    delete dstdata;
                }
            }
        }
        
        SAFE_DELETE(dst);
    }
    else {
        return false;
    }
    return true;
}
*/



//笔记迁移：把某个目录中的所有笔记和目录迁移到另外一个目录
+(void)moveNoteFromDirectory:(NSString *)srcCateGuid to:(NSString *)destCateGuid
{
    NSArray *arrNote = [AstroDBMng getNoteListByCate:srcCateGuid];
    if ( !arrNote ) return;
    
    for (int jj=0;jj<[arrNote count];jj++)
    {
        TNoteInfo *pNote = [arrNote objectAtIndex:jj];
        pNote.strCatalogIdGuid = destCateGuid;
        [AstroDBMng updateNote:pNote];
    }
}

//删除多余的默认目录
+(void) deleteRedundantDefaultDirectory
{
    int  nDeleteFlag = 0;
    
    for (int jj=1;jj<=7;jj++) {
         //获取指定mobile_flag 的文件夹
        NSArray *arr = [AstroDBMng getCateListByMobileFlag_CateMgr:jj];
        if ( !arr ) continue;
        
        if ( [arr count] >= 2 ) {
            nDeleteFlag = 1;
            
            //排序,先看userid是否为0,为0就迁移
            TCateInfo *destCateInfo = [arr objectAtIndex:0];
            //int destorder = destCateInfo.nOrder;
            int dest_xh = 0;
            for (int ll=1;ll<[arr count];ll++)
            {
                TCateInfo *pCate = [arr objectAtIndex:ll];
                if ( pCate.tHead.nUserID > 0 ) {  //服务端下来的
                    dest_xh = ll;
                    //destorder = pCate.nOrder;
                    break;
                }
                //if ( destorder > pCate.nOrder ) {
                //    dest_xh = ll;
                //    destorder = pCate.nOrder;
                //}
            }
            destCateInfo = [arr objectAtIndex:dest_xh];
            
            for (int kk=0;kk<[arr count];kk++)
            {
                if ( kk == dest_xh ) continue;
                
                //迁移笔记
                TCateInfo *srcCateInfo = [arr objectAtIndex:kk];
                
                [self moveNoteFromDirectory:srcCateInfo.strCatalogIdGuid to:destCateInfo.strCatalogIdGuid];
                
                //迁移各层子目录
                //更改某个目录下的所有子目录(包括子子目录)到另外一个目录
                [AstroDBMng updateCateListIncludeSubDir_CateMgr:srcCateInfo.strCatalogIdGuid to:destCateInfo.strCatalogIdGuid];
                
                //更改当前目录总的记录数(同时更改父目录)
                [self updateCateNoteCount:destCateInfo.strCatalogIdGuid];
           
                //删除文件夹
                [self updateHeadForDelete:srcCateInfo.tHead];
                [AstroDBMng updateCate_CateMgr:srcCateInfo];
                NSLog(@"delete catalog:%@ %@",srcCateInfo.strCatalogName,srcCateInfo.strCatalogIdGuid);
                
            }
        }
    }
    
    if ( 1 == nDeleteFlag ) {//需同步
        NSLog(@"deleteRedundantDefaultDirectory:send sync message");
        //发同步上传消息
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
    }
    
}

//删除某个目录，把其中的笔记全部变成无整理笔记，全部子文件夹都删除
+(void) deleteSpecifiedDirectory:(NSString *)strCatalog
{
    int  nDeleteFlag = 0;
    
    //处理笔记(改所属文件夹)
    NSArray *arrNote = [AstroDBMng getNoteListByCateIncludeSub:strCatalog];
    if ( arrNote ) {
        for (int jj=0;jj<[arrNote count];jj++)
        {
            TNoteInfo *pNote = [arrNote objectAtIndex:jj];
            pNote.strCatalogIdGuid = GUID_ZERO;
            [AstroDBMng updateNote:pNote];
            nDeleteFlag = 1;
        }
    }
    
    //处理子文件夹(删除)
    int count = [AstroDBMng deleteCateListIncludeSubDir_CateMgr:strCatalog];
    if ( count > 0 ) nDeleteFlag = 1;
    
    if ( 1 == nDeleteFlag ) {//需同步
        NSLog(@"deleteSpecifiedDirectory:send sync message");
        //发同步上传消息
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_NOTE :nil :nil :nil];
    }
    
}


//获取缺省目录(手机未整理目录)
+(void)setDefualtDirectory
{
    [_GLOBAL setDefaultCateID:GUID_ZERO];
    NSArray *arrCate = [BizLogic getCateList:@""];
    if ( arrCate )
    {
        int i=0;
        for (i=0;i<[arrCate count];i++) {
            TCateInfo *pCateInfo = [arrCate objectAtIndex:i];
            if ( pCateInfo.nMobileFlag == MOBILEFLAG_1 )
            {
                [_GLOBAL setDefaultCateID:pCateInfo.strCatalogIdGuid];
                NSLog(@"default catalog:%@ %@",pCateInfo.strCatalogName,pCateInfo.strCatalogIdGuid);
                break;
            }
        }
        //如果没找到
        if ( i == [arrCate count] && [arrCate count] > 0 )
            [_GLOBAL setDefaultCateID:((TCateInfo *)[arrCate objectAtIndex:0]).strCatalogIdGuid];
    }
    
    NSLog(@"default catalog guid:%@",[_GLOBAL defaultCateID]);
}



@end