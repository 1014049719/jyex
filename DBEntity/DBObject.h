//
//  DBObject.h
//  NoteBook
//
//  Created by chen wu on 09-7-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQSQLite.h"
#import "Common.h"
#import "CppSQLite3.h"

typedef enum tagDatabaseType
    {
        DT_NOTE,							// NOTE数据库,
        DT_LOCAL,							// 本地库包括缩略图，分词等
        DT_CONFIG,							// 用户配置信息数据库
        DT_GLOBAL_CONFIG					// 全局配置信息数据库
    } DATABASE_TYPE;

typedef enum tagTableIndexType {
    TT_TABLE,							// 创建表
    TT_INDEX							// 创建索引
} TABLEINDEX_TYPE;

typedef struct tagTableIndexInfo {
    DATABASE_TYPE    nDBType;			// 数据库
    TABLEINDEX_TYPE  nTableIndexType;	// 表或是索引
    const char*      pszTableIndexName;	// 表名或索引名
    const char*      pszCreateSql;		// 建表(索引)的SQL语句
} TABLEINDEX_INFO;



@interface DBObject : NSObject 
{
    CppSQLite3DB *pMainDB;
}

+(DBObject *)shareDB;
- (bool)createTables;

//db operation
- (bool)open:(const char*)szFile;
- (bool)isOpen;
- (void)close;

/*以下函数用于执行sql语句*/
- (int)execDML:(const char*)szSQL; //执行SQL语句
- (int)execScalar:(const char*) szSQL;                  //执行返回单个数值的查询语句
- (CppSQLite3Query)execQuery:(const char*)szSQL;           //执行查询语句，返回动态记录集
- (CppSQLite3Table)getTable:(const char*)szSQL;            //执行查询语句，返回静态记录集
- (CppSQLite3Statement)compileStatement:(const char*)szSQL;//解析SQL语句，返回解析后的SQL对象
- (long)lastRowId;           //返回最近的插入操作的整形键
- (void)interrupt;           //中断数据库任何运行操作

- (void)setBusyTimeout:(int)nMillisecs;                 //设置数据库函数超时时间
- (const char*) SQLiteVersion;                  //返回数据库版本

/*其它函数*/
- (bool)tableExists:(const char*)szTable;               //判断表是否存在



/////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)deleteAnNote:(NSString *)noteId;
//
////  get_Note_id
//- (NSString *)getNoteIdByFirstItem:(NSString *)fItem;
//- (int)getNoteIndexById:(NSString *)noteId;
////  tb_item_info
//-(BOOL) updateAnItem:(NSString *)itemGuid;// Add by huangyan
//-(BOOL) saveAnItem:(NSString *)itemId type:(NSInteger) itemType itemExt:(NSString *)ext itemSize:(NSInteger)size;
//-(BOOL) reSaveAItem:(NSString *)itemId type:(NSInteger) itemType itemExt:(NSString *)ext itemSize:(NSInteger)itemSize;
//
////  tb_note_info
//-(BOOL) updateAnNote:(NSString *)noteGuid noteTitle:(NSString *)noteTitle noteTag:(NSString *)noteTag len:(NSInteger) length;// Add by huangyan
//-(BOOL) saveANote:(NSString *)noteId title:(NSString *) noteTitle tag:(NSString *)tags noteType:(NSInteger)type 
//		 noteSize:(NSInteger)nsize fileExt:(NSString *)ext fristItem:(NSString *)guid;
//-(BOOL) saveANote:(NSString *)noteId title:(NSString *) noteTitle tag:(NSString *)tags noteType:(NSInteger)type 
//		 noteSize:(NSInteger)nsize fileExt:(NSString *)ext fristItem:(NSString *)guid createTime:(NSString *)recordTime
//		 editTime:(NSString *)eTime createVersion:(NSUInteger)cvid curVersion:(NSUInteger)curVid uploadFlag:(NSInteger)flag;
//- (void)deleteAnNoteByNoteID:(NSString *)noteId;
//
////  tb_note_x_item
//- (BOOL) configuresNote:(NSString *)noteId withItem:(NSString *)itemId;
//- (NSArray *)getItemsByNote:(NSString *)noteId;
//
////- (NSDictionary * )getAllItems:(int)byKind;
//- (NSDictionary * )getAllItems:(int)byKind titleLike:(NSString *) lt;
//- (int) getNoteCount;
//- (NSMutableDictionary *)getNextItemByTime:(NSString *) time increment:(BOOL) yesOrno;
//
////  tb_tags
//- (BOOL)getAllTags:(NSMutableArray *)tagsArray;
//- (BOOL)getSysTags:(NSMutableArray *)sysTags andUsrTags:(NSMutableArray *)usrTags;
//- (NSString *)getTagByLocation:(NSInteger)location;
//- (BOOL)exchangeLocationBySourceRow:(NSInteger)sourceRow sourceContext:(NSString *)sourceContext
//					 destinationRow:(NSInteger)destinationRow distinationContext:(NSString *)destinationContext;
//- (BOOL)insertTagByContext:(NSString *)tagContext;
//- (BOOL)deleteTagByRow:(NSInteger)row;
//
//
////update time
//- (BOOL) updateAnNoteItem:(NSString *)itemId time:(NSString *) motifiyTime;
//
////read flag
//- (int) getUnReadCount;
//- (int) setRead:(NSString *)firstItem;
//
////upload flag
//- (int) getUnUploadCount;
//- (int)setVersionId:(NSString *)firstItem vid:(int) vid ;
//- (int)setUploadFlag:(NSString *)firstItem flag:(int) isUpload;
//- (int)setUploadFlag:(NSString *)firstItem ;
//
////set userId
//- (void)setUserId:(NSString *)uid withNote:(NSString *)noteId;
//- (int) getUserIdByNote:(NSString *)noteId;
//
////if record exist and version id
//- (BOOL) hasNote:(NSString *) nid;
//- (void) updateCurVersionId:(int)curVid withNoteId:(NSString *)nid;
//- (void) updateCurVersionId:(int)curVid createVersionId:(int)cid withNoteId:(NSString *)nid;
//- (void) newVersionId:(int)vid withNoteId:(NSString *)nid;
//- (int) getCurVersionIdByNote:(NSString *) noteId;
//- (int) getCreateVersionIdByNote:(NSString *)noteId;
//- (int) getMaxVersionID;
//- (NSString *) getCreateTime:(NSString *)noteId;
//- (NSString *) getEditTime:(NSString *)noteId;
//- (NSString *) getNoteTypeById:(NSString *)noteId;
//
////charge control
//
//- (void)addFlows:(int) bytes; //
//- (double)getChargeSince:(NSString *)date; //
//
////tb_card_info
//- (NSString *)getMaxDisCharge; //
//- (void)setMaxDisCharge:(NSString *)maxCharge;  //
//- (NSString *)getClearDay; //
//- (void)setClearDay:(NSString *)clearDay; //
//- (BOOL)getGPRSFlag;//
//- (void)setGPRSFlag:(BOOL)flag;//
//
//- (BOOL)isTodayRecorded;
//- (BOOL)insertToday;
//- (NSString *)getLastUpdateDay;
//- (BOOL)isCardActive;
//- (void)insertACardInfo;
//
////new 2009-11-10
//- (int)getNoteIndexById:(NSString *)noteId;
@end
