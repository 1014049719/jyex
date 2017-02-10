/*
 *  CateMgr.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "DBMng.h"

#pragma mark -
#pragma mark 数据库管理-CateMgr
@interface AstroDBMng (ForCateMgr)

//目录操作

//增加目录
+ (int)addCate_CateMgr:(TCateInfo* )cateInfo;

//根据目录GUID，读取整个目录
+ (TCateInfo* )getCate_CateMgr:(NSString *)strCateGuid;

//获取某个目录的所有子目录列表
+ (NSArray*)getCateList_CateMgr:(NSString *)strCateGuid;

//获取所有有效目录
+ (NSArray*)getAllCateList_CateMgr;

//获取需上传的目录列表
+ (NSArray*)getNeedUploadCateList_CateMgr;

//更改某个目录下的所有子目录(包括子子目录)到另外一个目录
+ (void)updateCateListIncludeSubDir_CateMgr:(NSString *)strCateGuid to:(NSString *)strDestGuid;

//删除某个目录下的所有子目录(包括子子目录)
+ (int)deleteCateListIncludeSubDir_CateMgr:(NSString *)strCateGuid;


//搜索目录的标题是否含有关键字
+ (NSArray*)getCateListBySearch_CateMgr:(NSString *)strKey catalog:(NSString *)strCatalog;

//获取指定mobile_flag 的文件夹
+ (NSArray*)getCateListByMobileFlag_CateMgr:(int)mobile_flag;



//更改目录
+ (int)updateCate_CateMgr:(TCateInfo* )cateInfo;


+ (int)saveCate_CateMgr:(TCateInfo* )cateInfo;

//更改某个目录的记录总数
+ (int)updateCateNoteCount_CateMgr:(NSString *)strCateGuid notecount:(int)count;


//获取目录总数
+ (int)getCateCount;

+ (int)getNoteCountInCate_CateMgr:(NSString *)strCateGuid includeSubDir:(BOOL)includeSubDir;
+ (BOOL)isSubCate_CateMgr:(NSString *)strParentGuid subCate:(NSString *)strSubGuid;

//取或设置文件信息表最大版本号
+ (int)getCateMaxVersion_CateMgr;
+ (BOOL)setCateMaxVersion_CateMgr:(int)version;
+ (int)getTableDirVersion_CateMgr:(NSString *)strCatalogGuid tableName:(NSString *)strTableName;

//更改文件夹版本信息表
+ (int)setTableDirVersion_CateMgr:(TCatalogVersionInfo *)obj;

//数据库操作
+ (int)saveToDB_CateMgr:(TCateInfo*)obj;

+ (BOOL)objFromQuery_CateMgr:(TCateInfo*)cateInfo query:(CppSQLite3Query*)query;

@end
