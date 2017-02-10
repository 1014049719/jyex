//
//  ObjMgr.h
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#ifndef _OBJMGR_H_
#define _OBJMGR_H_

#import "MBBaseStruct.h"
#import "Common.h"
#import "DBObject.h"
#import <Foundation/Foundation.h>

@interface ObjMgr : NSObject
{
    
}

+ (string)commonFieldsValue:(RecHead)objHead;
+ (string)commonFields;
+ (BOOL)headFromQuery:(CppSQLite3Query*)query head:(RecHead*)pHead;
+ (void)createHead:(RecHead*)pHead;
+ (void)updateHead:(RecHead*)pHead;
+ (BOOL)resetHead:(RecHead*)pHead;
+ (BOOL)needUpload:(RecHead*)pHead;

@end



//class CObjMgr
//{
//public:
//    static string GetCommonFieldsValue(const RecHead& objHead)
//    {
//        
//        string strSql = CCommon::intToStr(objHead.dwUserID) + ","				// 用户编号
//        + CCommon::intToStr(objHead.dwCurVerID)+ ","						// 当前版本
//        + CCommon::intToStr(objHead.dwCreateVerID)+ ","						// 创建版本
//        + "'" + CCommon::unicodeToUTF8(objHead.wszCreateTime)+ "',"							// 创建时间
//        + "'" + CCommon::unicodeToUTF8(objHead.wszModTime) + "',"							// 修改时间
//        + CCommon::intToStr(objHead.nDelState)+ ","							// 状态
//        + CCommon::intToStr(objHead.nEditState)+ ","						// 是否被编辑
//        + CCommon::intToStr(objHead.nConflictState)+ ","					// 是否冲突
//        + CCommon::intToStr(objHead.nSyncState)+ ","					// 是否冲突
//        + CCommon::intToStr(objHead.nNeedUpload)+ ",";					// 是否冲突
//        
//        return strSql;
//    }
//    
//    static std::string GetCommonFields()
//    {
//        return "user_id, curr_ver, create_ver, create_time, modify_time, delete_state, edit_state, conflict_state, sync_state, need_upload";
//    }
//    
//   static  bool HeadFromQuery(CDBMgr* pDBMgr, int row, RecHead& objHead)
//    {
//        ZeroMemory(&objHead, sizeof(objHead));
//        
//        objHead.dwUserID = atoi(pDBMgr->queryData(row, "user_id"));                    // 用户编号
//        objHead.dwCurVerID = atoi(pDBMgr->queryData(row, "curr_ver"));                 // 当前版本号
//        objHead.dwCreateVerID = atoi(pDBMgr->queryData(row, "create_ver"));            // 创建版本号
//        CCommon::UTF8ToUnicode(pDBMgr->queryData(row, "create_ver"), objHead.wszCreateTime);   // 创建时间
//        CCommon::UTF8ToUnicode(pDBMgr->queryData(row, "modify_time"), objHead.wszModTime);     // 修改时间
//        objHead.nDelState = atoi(pDBMgr->queryData(row, "delete_state"));             // 状态
//        objHead.nEditState = atoi(pDBMgr->queryData(row, "edit_state"));              // 是否被编辑
//        objHead.nConflictState = atoi(pDBMgr->queryData(row, "conflict_state"));      // 是否冲突
//        objHead.nSyncState = atoi(pDBMgr->queryData(row, "sync_state"));              // 备用
//        objHead.nNeedUpload = atoi(pDBMgr->queryData(row, "need_upload"));            // 是否上传
//        return true;
//    }
//    
//    static void CreateHead(RecHead& tHead)
//    {
//        tHead.nEditState = 1;
//        CCommon::GetCurrentTime(tHead.wszCreateTime);
//        CCommon::GetCurrentTime(tHead.wszModTime);
//    }
//    
//    static void UpdateHead(RecHead& tHead)
//    {
//        tHead.nEditState = 1;
//        CCommon::GetCurrentTime(tHead.wszModTime);
//    }
//    
//};
//
#endif