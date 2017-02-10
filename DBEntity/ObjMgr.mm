//
//  ObjMgr.m
//  NoteBook
//
//  Created by wangsc on 10-9-27.
//  Copyright 2010 ND. All rights reserved.
//
#import "ObjMgr.h"
#import "Global.h"

@implementation ObjMgr

+ (string)commonFieldsValue:(RecHead)objHead
{
    string strSql = [CommonFunc intToStr:objHead.dwUserID] + ","				// 用户编号
    + [CommonFunc intToStr:objHead.dwCurVerID] + ","						// 当前版本
    + [CommonFunc intToStr:objHead.dwCreateVerID]+ ","						// 创建版本
    + "'" + [CommonFunc unicodeToUTF8:objHead.wszCreateTime]+ "',"							// 创建时间
    + "'" + [CommonFunc unicodeToUTF8:objHead.wszModTime] + "',"							// 修改时间
    + [CommonFunc intToStr:objHead.nDelState] + ","							// 状态
    + [CommonFunc intToStr:objHead.nEditState]+ ","						// 是否被编辑
    + [CommonFunc intToStr:objHead.nConflictState]+ ","					// 是否冲突
    + [CommonFunc intToStr:objHead.nSyncState] + ","					// 是否冲突
    + [CommonFunc intToStr:objHead.nNeedUpload] + ",";					// 是否冲突
    
    return strSql;
}

+ (string)commonFields
{
    return "user_id, curr_ver, create_ver, create_time, modify_time, delete_state, edit_state, conflict_state, sync_state, need_upload";
}

+ (BOOL)headFromQuery:(CppSQLite3Query*)query head:(RecHead*)pHead
{
    ZeroMemory(pHead, sizeof(RecHead));
    
    try
    {
        pHead->dwUserID = query->getIntField("user_id", 0);
        pHead->dwCurVerID = query->getIntField("curr_ver", 0);
        pHead->dwCreateVerID = query->getIntField("create_ver", 0);
        
        string strCreateTm = query->getStringField("create_time","");
        string strModifyTm = query->getStringField("modify_time","");
        [CommonFunc utf8ToUnicode:strCreateTm buffer:pHead->wszCreateTime];
        [CommonFunc utf8ToUnicode:strModifyTm buffer:pHead->wszModTime];
        
        pHead->nDelState = query->getIntField("delete_state", 0);
        pHead->nEditState = query->getIntField("edit_state", 0);
        pHead->nConflictState = query->getIntField("conflict_state", 0);
        pHead->nSyncState = query->getIntField("sync_state", 0);
        pHead->nNeedUpload = query->getIntField("need_upload", 0);       
    }
    catch (CppSQLite3Exception e) 
    {
        MLOG(@"Exception:%s", e.errorMessage());
        return NO;
    }
    
    return YES;
}

+ (void)createHead:(RecHead*)pHead
{
    pHead->dwUserID = atoi([[Global GetUsrID] UTF8String]);
    pHead->dwCreateVerID = pHead->dwUserID;
    pHead->nEditState = 1;
    [CommonFunc getCurrentTimeW:pHead->wszCreateTime];
    [CommonFunc getCurrentTimeW:pHead->wszModTime];
}

+ (void)updateHead:(RecHead*)pHead
{
    pHead->nEditState = 1;
    [CommonFunc getCurrentTimeW:pHead->wszModTime];
}

+ (BOOL)resetHead:(RecHead*)pHead {
	pHead->nEditState = 0;
}

+ (BOOL)needUpload:(RecHead*)pHead;
{
    if (pHead->nEditState == 0)
    {
        return NO;
    }
    
    //本地新建已删除,不需要上传
    if (pHead->nDelState != STATE_NORMAL && pHead->dwCurVerID == 0)
    {
        return NO;
    }
    
    return YES;
}

@end
