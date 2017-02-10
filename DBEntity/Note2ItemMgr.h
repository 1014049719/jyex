/*
 *  Note2ItemMgr.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */
#import "DBMng.h"


#pragma mark -
#pragma mark 数据库管理-Note2ItemMgr
@interface AstroDBMng (ForNote2ItemMgr)
{
   
}

+ (TNoteXItem *)getNote2Item:(NSString *)guidNote itemID:(NSString *)guidItem;
+ (BOOL)deleteNote2Item:(NSString *)guidNote itemID:(NSString *)guidItem;
+ (BOOL)deleteNote2Item:(TNoteXItem *)pInfo;
+ (BOOL)deleteNote2ItemFromDB:(TNoteXItem *)pInfo;
+ (void)updateNote2Item:(TNoteXItem *)pInfo;
+ (BOOL)saveNote2Item:(TNoteXItem *)pInfo;

+ (NSArray *)getNote2ItemListBySQL:(NSString *)strSQL;

//查询某条笔记需上传的笔记关联项
+ (NSArray *)getNeedUploadNote2ItemListByNote:(NSString *)guidNote;

//查询需下载的笔记关联项(指定笔记guid或所有)
+ (NSArray *)getNeedDownloadNote2ItemListByNote:(NSString *)guidNote;

//返回某条笔记所有的note2Item列表
+ (NSArray *)getNote2ItemList:(NSString *)guidNote includeDelete:(BOOL)includeDelete;

 //删除某条笔记的所有item和NoteXItem(只修改标志，不删除记录和文件)
+ (BOOL)DeleteAllItemNoFileByNote:(NSString *)guidNote includeDelete:(BOOL)includeDelete;


+ (NSArray *)getNeedUploadItemList:(NSString *)guidNote;

//获取某个笔记的笔记与笔记关联项的最大版本号
+ (int)getNote2ItemMaxVersionByNoteGuid:(NSString *)guidNote;
//获取某个笔记的笔记项的最大order号
+ (int)getNote2ItemMaxOrderByNoteGuid:(NSString *)guidNote;


+ (BOOL)deleteNote2ItemAndItemByNote:(NSString *)guidNote;
+ (BOOL)deleteNote2ItemAndItemByNoteFromDB:(NSString *)guidNote;

//数据库操作
+ (int)saveToDB_Note2ItemMgr:(TNoteXItem *)obj;
+ (BOOL)objFromQuery_Note2ItemMgr:(TNoteXItem*)obj query:(CppSQLite3Query*)query;


+ (int)getNoteXItemMaxVersion:(NSString *)strNoteGuid;
+ (BOOL)setNoteXItemMaxVersion:(NSString *)strNoteGuid version:(int)version;



@end

