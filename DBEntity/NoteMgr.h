//
//  NoteMgr.h
//  NoteBook
//
//  Created by wangsc on 10-9-15.
//  Copyright 2010 ND. All rights reserved.
//

#import "DBMng.h"


#pragma mark -
#pragma mark 数据库管理-NoteMgr
@interface AstroDBMng (ForNoteMgr)
{
    
}

+(BOOL) loadDb91Note;	//打开
+(BOOL) loadDb91Note:(NSString*) userName;
+(BOOL) CloseDb91Note;	//关闭

+ (BOOL)addNote:(TNoteInfo *)objNote;
+ (TNoteInfo*)getNote:(NSString *)strNoteGuid;
+ (BOOL)updateNote:(TNoteInfo*)objNote;
+ (BOOL)resetNote:(TNoteInfo* )objNote;
+ (BOOL)deleteNote:(NSString *)guidNote;
+ (BOOL)deleteNoteFromDB:(NSString *)strNoteGuid;
+ (BOOL)saveNote:(TNoteInfo *)objNote;

+ (NSArray *)getNoteListBySQL:(NSString *)strSQL count:(int)nLimitCount;
+ (NSArray *)getNoteListByCate:(NSString *)strCateGuid;

//+ (NSArray *)getMostRecentNotes:(int)count;
//+ (NSArray *)getUnuploadNoteList:(BOOL)includeDelete;

//获取一条需上传的笔记
//+ (TNoteInfo*)getOneNoteNeedUpload;

//+ (NSArray *)getNoteByFirstItemID:(NSString *)guidFirstItem;
//+ (int)needUploadNotesCount;

//返回需同步的记录数(上传)
+ (int)needSyncNotesCount;

//返回需上传的笔记的Guid()
+ (NSArray *)getNeedUploadNoteListGuid;

+ (NSArray *)getNeedDownNoteList:(NSString *)guidCate recursive:(BOOL)recursive;

//返回目录所有笔记的Guid
+ (NSArray *)getNoteListGuidByCate:(NSString *)strCateGuid;
//返回目录所有的笔记（包括子目录)
+ (NSArray *)getNoteListByCateIncludeSub:(NSString *)guidCate;

//搜索笔记的标题和内容是否含有关键字(在所有目录或指定目录)
+ (NSArray*)getNoteListBySearch:(NSString *)strKey catalog:(NSString *)strCatalog;


//获得指定目录的记录总数
+ (int)getNoteCountByCate:(NSString *)strCateGuid;
//获得指定目录当天时间的记录总数
+ (int)getNoteCountByCateByDate:(NSString *)strCateGuid date:(NSString *)strDate;


+ (int)saveToDB_NoteMgr:(TNoteInfo *)obj;
+ (BOOL)objFromQuery_NoteMgr:(TNoteInfo*)obj query:(CppSQLite3Query*)query;

//最大版本号
+ (int)getNoteMaxVersion;
+ (BOOL)setNoteMaxVersion:(int)version;


//+ (BOOL)needDecrypt:(GUID)guidNote; //判断Note是否需要解密
//+ (int)decryptNote:(GUID)guidNote password:(string)strPassword;
//+ (BOOL)getWorkKey:(GUID)guidNote workKey:(WORK_KEY_INFO*)pWorkKeyInfo;



@end
