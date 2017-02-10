//
//  DBObject.mm
//  NoteBook
//
//  Created by chen wu on 09-7-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBObject.h"
#import "Global.h"
#import "Logger.h"
#import "PFunctions.h"

static DBObject * g_db = nil;

static TABLEINDEX_INFO tableIndexInfo[] = 
{
    // 目录表
    {
        DT_NOTE, TT_TABLE, "tb_catalog_info",
        "CREATE TABLE [tb_catalog_info] ("
        "[user_id] INT, "
        "[catalog_id] varchar(36) UNIQUE, "
        "[catalog_belong_to] varchar(36), "
        "[catalog_path1] varchar(36), "
        "[catalog_path2] varchar(36), "
        "[catalog_path3] varchar(36), "
        "[catalog_path4] varchar(36), "
        "[catalog_path5] varchar(36), "
        "[catalog_path6] varchar(36), "
        "[catalog_order] int, "
        "[catalog_name] varchar(256),"
        "[encrypt_flag] tinyint, "
        "[verify_data]  char(24),"
        "[curr_ver] int, "
        "[create_ver] int, "
        "[create_time] datetime, "
        "[modify_time] datetime, "
        "[delete_state] tinyint, "
        "[edit_state] tinyint, "
        "[conflict_state] tinyint, "
        "[sync_state] tinyint, "
        "[need_upload] tinyint, "
        "CONSTRAINT [idx_catalog_info] PRIMARY KEY ([catalog_id]));"
    },
    // 标签树表
    {
        DT_NOTE, TT_TABLE, "tb_tag_tree",
        "CREATE TABLE [tb_tag_tree] ("
        "[user_id] INT NOT NULL,"
        "[tag_id] varchar(36) UNIQUE,"
        "[tag_order] int,"
        "[tag_name] varchar(256),"
        "[curr_ver] int,"
        "[create_ver] int,"
        "[create_time] datetime,"
        "[modify_time] datetime,"
        "[delete_state] tinyint, "
        "[edit_state] tinyint, "
        "[conflict_state] tinyint, "
        "[sync_state] tinyint, "
        "[need_upload] tinyint, "
        "CONSTRAINT [idx_tag_tree] PRIMARY KEY ([tag_id]));"
    },

    //笔记表
    {
        DT_NOTE, TT_TABLE, "tb_note_info",
        "CREATE TABLE [tb_note_info] ("
        "[user_id] INT,"
        "[catalog_id] varchar(36),"
        "[note_id] varchar(36) UNIQUE,"
        "[note_title] varchar(1024),"
        "[note_type] tinyint,"
        "[note_size] int,"
        "[file_path] varchar(256),"
        "[file_ext] varchar(8),"
        "[edit_location] varchar(128),"
        "[note_src] varchar( 512),"
        "[first_item] varchar(36),"
        "[share_mode] tinyint,"
        "[encrypt_flag] tinyint, "
        "[curr_ver] int,"
        "[create_ver] int,"
        "[create_time] datetime,"
        "[modify_time] datetime,"
        "[delete_state] tinyint, "
        "[edit_state] tinyint, "
        "[conflict_state] tinyint, "
        "[sync_state] tinyint, "
        "[need_upload] tinyint, "
        "[need_downlord] tinyint, "
        "[owner_id] int, "
        "[from_id] int, "
        "CONSTRAINT [idx_note_info] PRIMARY KEY ([note_id]));"
    },

    // Item信息表
    {
        DT_NOTE, TT_TABLE, "tb_item_info",
        "CREATE TABLE [tb_item_info] ("
        "[user_id] INT,"
        "[item_id] varchar(36) UNIQUE,"
        "[creator_id] int,"
        "[item_type] tinyint,"
        "[item_ext] varchar(8),"
        "[item_size] int,"
        "[item_content] BLOB,"
        "[encrypt_flag] tinyint, "
        "[curr_ver] int,"
        "[create_ver] int,"
        "[create_time] datetime,"
        "[modify_time] datetime,"
        "[delete_state] tinyint, "
        "[edit_state] tinyint, "
        "[conflict_state] tinyint, "
        "[sync_state] tinyint, "
        "[need_upload] tinyint, "

        "CONSTRAINT [idx_item_info] PRIMARY KEY ([item_id]));"
    },
    // 笔记、项目关联表
    {
        DT_NOTE, TT_TABLE, "tb_note_x_item",
        "CREATE TABLE [tb_note_x_item] ("
        "[user_id] INT,"
        "[note_id] varchar(36),"
        "[item_id] varchar(36),"
        "[item_creator] INT,"
        "[catalog_belong_to] varchar(36), "
        "[item_ver] int,"
        "[curr_ver] int,"
        "[create_ver] int,"
        "[create_time] datetime,"
        "[modify_time] datetime,"
        "[delete_state] tinyint, "
        "[edit_state] tinyint, "
        "[conflict_state] tinyint, "
        "[sync_state] tinyint, "
        "[need_upload] tinyint, "
        "[need_downlord] tinyint, "
        "CONSTRAINT [idx_note_x_item] PRIMARY KEY ([note_id], [item_id]));"
    },

    // 文件夹版本信息表
    {
        DT_NOTE, TT_TABLE, "tb_catalog_version_info",
        "CREATE TABLE [tb_catalog_version_info] ("
        "[user_id] INT,"
        "[catalog_belong_to] varchar(36),"
        "[table_name] varchar(32),"
        "[max_ver] int,"
        "CONSTRAINT [idx_catalog_version_info] PRIMARY KEY ([user_id], [table_name], [catalog_belong_to]));"
    },

    {
        DT_NOTE,TT_TABLE,"tb_charge_info", 
        "CREATE TABLE tb_charge_info ([imsi] varchar(16), [flow] int64, [day] DateTime,"
        "CONSTRAINT [idx_charge_info] PRIMARY KEY ([imsi], [day]));"
    },

    {
        DT_NOTE,TT_TABLE,"tb_card_info",
        "CREATE TABLE tb_card_info ("
        "imsi varchar(16) primary key,"
        "max_discharge int default 10,"
        "clear_day int default 1,"
        "gprs_flag int default 1);"
    },

    // 笔记索引
    {
        DT_NOTE, TT_INDEX, "idx_catalog_id",
        "CREATE INDEX [idx_catalog_id] ON [tb_note_info] ([catalog_id] COLLATE NOCASE);"
    },

    // 笔记是否需要下载索引
    {
        DT_NOTE, TT_INDEX, "idx_need_downlord",
        "CREATE INDEX [idx_need_downlord] ON [tb_note_info] (need_downlord);"
    },

    // 项目信息是否编辑索引
    {
        DT_NOTE, TT_INDEX, "idx_edit_state",
        "CREATE INDEX [idx_edit_state] ON [tb_item_info] (edit_state);"
    },

    // 用户配置信息数据库
    { 
        DT_NOTE, TT_TABLE, "tb_config_info", 
        "CREATE TABLE tb_config_info(sKey char(36) NOT NULL, sName char(36) NOT NULL, BData blob, Primary Key(sKey,sName));"
    },
    
    // 反馈信息
    { 
        DT_NOTE, TT_TABLE, "tb_feedback",
        "CREATE TABLE tb_feedback(id char(30), question char(255), asktime char(100), answer char(255), answertime char(30), PRIMARY KEY (id));"
    }

};


@implementation DBObject
// init

+(DBObject *)shareDB
{
	if(g_db == nil)
	{
		g_db = [[DBObject alloc] init];
	}
	return g_db;
}

-(id)init
{
	if(self=[super init])
	{
        pMainDB = NULL;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString *strDBDir = [[[NSHomeDirectory() 
//                                    stringByAppendingPathComponent:@"Documents/91NoteDat"]
//                                    stringByAppendingPathComponent:[PFunctions getUsernameFromKeyboard]]
//                                    stringByAppendingPathComponent:@"Data"];
//        NSString *strDBPath = [strDBDir stringByAppendingPathComponent:@"91Note.db"];
//        
//        //判断数据库文件是否存在
//        if(![fileManager fileExistsAtPath:strDBPath])
//        {
//            if(![fileManager fileExistsAtPath:strDBDir])
//            {
//                BOOL result = [fileManager createDirectoryAtPath:strDBDir withIntermediateDirectories:YES attributes:nil error:nil];
//                if(!result)
//                {
//                    MLOG(@"Create Directory %@ failed!", strDBDir);
//                }
//            }
//            
//            BOOL result = [fileManager createFileAtPath:strDBPath contents:nil attributes:nil];
//            if(!result)
//            {
//                MLOG(@"Create Directory %@ failed!", strDBDir);
//            }
//        }
//		
//        pMainDB = new CppSQLite3DB();
//        if (![self open:[strDBPath UTF8String]])
//        {
//            MLOG(@"open db failed");
//            return nil;
//        }
//        
//        [self createTables];
        
//        // 查看该卡是否注册
//        if(![self isCardActive])
//        {
//            [self insertACardInfo];
//            [Global setClearDay:[self getClearDay]];
//            [Global setMaxFlow:[[self getMaxDisCharge] intValue]];
//            
//        }else
//        {
//            int max = [[self getMaxDisCharge] intValue];
//            NSString *clearDay = [self getClearDay];
//            [Global setClearDay:clearDay];
//            [Global setMaxFlow:max];
//        }
//        
        // 启动时查找数据库获得当前最近登录时间
//        NSString * lastDayStr = [self getLastUpdateDay];
//        if(lastDayStr == nil)// 第一次使用时，数据库为空插入当天
//        {
//            [self insertToday];
//        }else
//        {
//            NSString * today = [Global  GetCurrentDate];
//            
//            //如果最后一次时间比 今天来得小 或者大 插入今天时间，今天时间如果存在插入不成功
//            if([lastDayStr caseInsensitiveCompare:today] != 0)
//            {
//                [self insertToday];
//            }
//        }
	}
	return self;
}

- (bool)createTables
{
    
    for (int i = 0; i < sizeof(tableIndexInfo) / sizeof(tableIndexInfo[0]); i++)
    {
        string tableType;
        if (tableIndexInfo[i].nTableIndexType == TT_INDEX)
            tableType = "index";
        else
            tableType = "table";
        
        try
        {
            // 查看数据库中是否已经存在表
            string strQuery = "SELECT count(*) FROM sqlite_master WHERE type='" + tableType + "' and name='" 
                                + tableIndexInfo[i].pszTableIndexName + "';";
            int nRet = [self execScalar:strQuery.c_str()];
            if (nRet <= 0)
            {
                int result = [self execDML:tableIndexInfo[i].pszCreateSql];
                if (result != SQLITE_OK)
                {
                    continue;
                }
            }
        }
        catch(CppSQLite3Exception e)
        {
            MLOG(@"SQL: %s exception: %s", tableIndexInfo[i].pszCreateSql, e.errorMessage());
        }
    }
    
    // 如果查询不到则修改表
    try {
        [self execDML:"SELECT 1 FROM tb_note_info WHERE star_level=0;"];
    } catch (CppSQLite3Exception e) {
        // 为tb_note_info添加字段
        [self execDML:"ALTER TABLE tb_note_info ADD star_level tinyint;"];
    }
    
    return true;
}

//db operation
- (bool)open:(const char*)szFile
{
    if (NULL != pMainDB)
    {
        pMainDB->close();
        delete pMainDB;
        pMainDB = NULL;
    }
    
    [CommonFunc checkUserDirectory:[Global userAccount]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strDBDir = [[[NSHomeDirectory() 
                            stringByAppendingPathComponent:@"Documents/91NoteDat"]
                           stringByAppendingPathComponent:[Global userAccount]]
                          stringByAppendingPathComponent:@"Data"];
    NSString *strDBPath = [strDBDir stringByAppendingPathComponent:@"91Note.db"];
    
    //判断数据库文件是否存在
    if(![fileManager fileExistsAtPath:strDBPath])
    {
        BOOL result = [fileManager createFileAtPath:strDBPath contents:nil attributes:nil];
        if(!result)
        {
            MLOG(@"Create Directory %@ failed!", strDBDir);
            return false;
        }
    }
    
    pMainDB = new CppSQLite3DB();
    pMainDB->open(szFile);
    [self createTables];
    
    return true;
}

- (bool)isOpen
{
    if (NULL == pMainDB)
    {
        return false;
    }
    return true;
}

- (void)close
{
    if (NULL == pMainDB)
    {
        return;
    }
    pMainDB->close();
    delete pMainDB;
    pMainDB = NULL;
}

/*以下函数用于执行sql语句*/
- (int)execDML:(const char*)szSQL //执行SQL语句
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return -1;
    }
    return pMainDB->execDML(szSQL);
}

- (int)execScalar:(const char*)szSQL
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return -1;
    }
    return pMainDB->execScalar(szSQL);
}

- (CppSQLite3Query)execQuery:(const char*)szSQL          
{
    CppSQLite3Query objNULL;
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return objNULL;
    }
    return pMainDB->execQuery(szSQL);
}

- (CppSQLite3Table)getTable:(const char*)szSQL
{
    CppSQLite3Table objNULL;
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return objNULL;
    }
    return pMainDB->getTable(szSQL);
}

- (CppSQLite3Statement)compileStatement:(const char*)szSQL
{
    CppSQLite3Statement objNULL;
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return objNULL;
    }
    return pMainDB->compileStatement(szSQL);
}

- (long)lastRowId
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return -1;
    }
    return pMainDB->lastRowId();
}

- (void)interrupt
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return;
    }
    pMainDB->interrupt();
}

- (void)setBusyTimeout:(int)nMillisecs
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return ;
    }
    pMainDB->setBusyTimeout(nMillisecs);
}

- (const char*) SQLiteVersion
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return NULL;
    }
    return pMainDB->SQLiteVersion();
}

- (bool)tableExists:(const char*)szTable
{
    if (NULL == pMainDB)
    {
        MLOG(@"DB未连接");
        return false;
    }
    return pMainDB->tableExists(szTable);
}

@end











//- (BOOL)deleteAnNote:(NSString *)noteId//其实是firstItem
//{
//	NSString * mysql = [NSString stringWithFormat:@"delete from tb_note_info where first_item = '%@' and (user_id = %@ or user_id = -1)"
//						,noteId,[Global GetUsrID]];
//	NSString * sqlab = [NSString stringWithFormat:@"delete from tb_note_x_item where item_id = '%@' and (user_id = %@ or user_id = -1)"
//						,noteId,[Global GetUsrID]];
//	NSString * sqlitem =  [NSString stringWithFormat:@"delete from tb_item_info where item_id = '%@' and (user_id = %@ or user_id = -1)"
//						   ,noteId,[Global GetUsrID]];
//	//MLOG(mysql);
//	int ret = db->exec((char *)[mysql UTF8String]);
//	db->exec((char *)[sqlab UTF8String]);
//	db->exec((char *)[sqlitem UTF8String]);
//	if(ret==0) return YES;
//	return NO;
//}
//
///**************************************************************
// /				  |textItem	 =  { path + time ...
// /	dictionary  --|	(array)		(dictionary)
// /				  |imageItem =  { path + time ...
// /				  |photoItem =  { path + time ...
// /				  |recordItem = { path + time ...
// ***************************************************************/ 
//- (NSDictionary * )getAllItems:(int)byKind titleLike:(NSString *) lt
//{
//	//MLOG(@"get all item begin");
//	NSMutableArray * textArr = [[NSMutableArray alloc] init];
//	NSMutableArray * imgArr = [[NSMutableArray alloc] init];
//	NSMutableArray * picArr = [[NSMutableArray alloc] init];
//	NSMutableArray * recArr = [[NSMutableArray alloc] init];
//	NSMutableArray * noteArr = [[NSMutableArray alloc] init];//new
//	NSMutableArray * typeArr = [[NSMutableArray alloc] init];
//	NSMutableArray * guidArr = [[NSMutableArray alloc] init];
//	NSMutableArray * titleArr= [[NSMutableArray alloc] init];// Add by huangyan
//	NSMutableArray * tagArr	 = [[NSMutableArray  alloc] init];
//	NSMutableArray * ctimeArr = [[NSMutableArray alloc] init];
//	NSMutableArray * mtimeArr = [[NSMutableArray alloc] init];
//	NSMutableArray * uploadArr= [[NSMutableArray alloc] init];
//	
//	NSMutableString * sql = nil;
//	if([lt length]== 0){
//		sql = [NSMutableString stringWithFormat:@"select first_item,note_type,note_title,create_time,modify_time,note_tag,upload_flag from tb_note_info where (user_id = %@ or user_id = -1) order by modify_time desc"
//			   ,[Global GetUsrID]];
//        //		sql = [NSMutableString stringWithFormat:@"select first_item,note_type,note_title,create_time,modify_time,note_tag,upload_flag from tb_note_info where (user_id = %@ or user_id = -1) group by upload_flag order by upload_flag asc,modify_time desc"
//        //			   ,[Global GetUsrID]];	
//	}
//	else
//	{
//		NSString * str0 = [NSMutableString stringWithFormat:@"select first_item,note_type,note_title,create_time,modify_time,note_tag,upload_flag from tb_note_info where (user_id = %@ or user_id = -1)" 
//                           ,[Global GetUsrID]];
//		NSString * str = [NSString stringWithFormat: @" and note_title like '%@%@%@' order by modify_time desc",@"%",lt,@"%"];
//		sql = [NSMutableString stringWithFormat:@"%@%@",str0,str];
//		
//		//printf("%s",[sql UTF8String]);
//		
//	}
//	//MLOG(sql);	
//	int result = db->query((char *)[sql UTF8String]);
//	
//	for(int row = 0; row < result; row++)
//	{
//		NSString * noteType = [NSString stringWithUTF8String:db->queryData(row,1)];
//		NSString * itemGuid = [NSString stringWithUTF8String:db->queryData(row,0)];
//		NSString * noteTitle = [NSString stringWithUTF8String:db->queryData(row,2)];// Add by huangyan
//		NSString * createTm = [NSString stringWithUTF8String:db->queryData(row,3)];
//		NSString * modifyTm = [NSString stringWithUTF8String:db->queryData(row,4)];
//		NSString * tags		= [NSString stringWithUTF8String:db->queryData(row,5)];
//		NSString * upFlag   = [NSString stringWithUTF8String:db->queryData(row,6)];
//		
//		[typeArr	addObject:noteType];
//		[guidArr	addObject:itemGuid];
//		[titleArr	addObject:noteTitle];// Add by huangyan
//		[ctimeArr	addObject:createTm];
//		[mtimeArr	addObject:modifyTm];
//		[tagArr		addObject:tags];
//		[uploadArr	addObject:upFlag];
//	}	
//    
//	NSString * fname = nil;
//	NSString * fext = nil;
//	for(int i = 0 ;i < result; i++)
//	{
//		fname = [guidArr objectAtIndex:i];
//		NSString * mysql = [NSString stringWithFormat:@"select item_ext from tb_item_info where item_id = '%@'",fname];
//        
//		db->query((char *)[mysql UTF8String]);
//		if(db->queryData(0,0) == NULL)
//		{
//			[self deleteAnNote:fname];
//			[guidArr removeObjectAtIndex:i];
//            [typeArr removeObjectAtIndex:i];
//            [titleArr removeObjectAtIndex:i];// Add by huangyan
//            [ctimeArr removeObjectAtIndex:i];
//            [mtimeArr removeObjectAtIndex:i];
//            [tagArr removeObjectAtIndex:i];
//            [uploadArr removeObjectAtIndex:i];
//            i--;
//            result--;
//            
//			continue;
//		}
//		fext  = [NSString stringWithUTF8String:db->queryData(0,0)];
//		NSString * path = [NSString stringWithFormat:@"%@/%@.%@",DATA_PATH,fname,fext];
//        
//		NSFileManager * manager = [NSFileManager defaultManager];
//		if(![manager fileExistsAtPath:path])
//		{
//			[self deleteAnNote:fname];
//			continue;
//		}
//        
//		
//		NSString *tag = [tagArr objectAtIndex:i];
//		NSString *time = [ctimeArr objectAtIndex:i];
//		NSString *title = [titleArr objectAtIndex:i];// Add by huangyan
//		NSString *editTime = [mtimeArr objectAtIndex:i];
//		NSString *uploadFlag = [uploadArr objectAtIndex:i];
//		
//		
//		NSDictionary * element = [NSDictionary dictionaryWithObjectsAndKeys:
//								  fname,@"guid",path,@"path",title,
//								  @"title",editTime,@"editTime",time,
//								  @"time",tag,@"tag",uploadFlag,@"uploadFlag",nil];
//		if(byKind == 0)
//		{
//			int nType = [(NSString *)[typeArr objectAtIndex:i] intValue];
//			switch (nType) {
//				case NOTE_CUST_WRITE:
//					[textArr addObject:element];
//					break;
//				case NOTE_CUST_DRAW:
//					[imgArr addObject:element];
//					break;
//				case NOTE_PIC:
//					[picArr addObject:element];
//					break;
//				case NOTE_AUDIO:
//					[recArr addObject:element];
//					break;
//				default:
//					break;
//			}
//		}else if(byKind == 1)
//		{
//			[noteArr addObject:element];
//		}
//		
//	}
//	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
//						   textArr,@"textItem",
//						   imgArr,@"imageItem",
//						   picArr,@"photoItem",
//						   recArr,@"recordItem",
//						   noteArr,@"noteItem",nil];
//	[textArr	release];
//	[imgArr		release];
//	[picArr		release];
//	[recArr		release];
//	[typeArr	release];
//	[guidArr	release];
//	[titleArr	release];// Add by huangyan
//	[noteArr	release];
//	[uploadArr	release];
//	[ctimeArr	release];
//	[mtimeArr	release];
//	[tagArr		release];
//    
//	return dict;
//}
//- (NSMutableDictionary *)freshNoteInfoByFirstItem:(NSString *)itemId
//{
//	NSMutableDictionary * element = nil;
//	NSString * sql = nil;
//    
//	sql = [NSString stringWithFormat:@"select note_title,create_time,modify_time,note_tag from tb_note_info where first_item = '%@' ",itemId];
//	int ret = db -> query((char *)[sql UTF8String]);
//	
//	if(ret > 0)
//	{
//		NSString * fname  = [NSString stringWithUTF8String:db -> queryData(0,0)];
//		
//		NSString * title = [NSString stringWithUTF8String:db -> queryData(0,1)];
//		NSString * time	 = [NSString stringWithUTF8String:db -> queryData(0,2)];
//		NSString * editTime  = [NSString stringWithUTF8String:db -> queryData(0,3)];
//		NSString * tag = [NSString stringWithUTF8String:db -> queryData(0,4)];
//		
//		NSString * mysql = [NSString stringWithFormat:@"select item_ext from tb_item_info where item_id = '%@'",fname];
//		
//		db->query((char *)[mysql UTF8String]);	
//		NSString * fext  = [NSString stringWithUTF8String:db->queryData(0,0)];
//		NSString * path = [NSString stringWithFormat:@"%@/%@.%@",DATA_PATH,fname,fext];
//		
//		element = [NSDictionary dictionaryWithObjectsAndKeys:fname,@"guid",path,@"path",title,@"title",editTime,@"editTime",time,@"time",tag,@"tag",nil];
//	}
//	
//	return element;
//}
//
//- (NSMutableDictionary *)getNextItemByTime:(NSString *) time increment:(BOOL) yesOrno
//{
//	NSMutableDictionary * element = nil;
//	NSString * sql = nil;
//	if(yesOrno)
//		sql = [NSString stringWithFormat:@"select first_item,note_title,create_time,modify_time,note_tag,upload_flag from tb_note_info where modify_time > '%@' and (user_id = '%@' or user_id = -1) order by modify_time asc limit 1",time,[Global GetUsrID]];
//	else
//		sql = [NSString stringWithFormat:@"select first_item,note_title,create_time,modify_time,note_tag,upload_flag from tb_note_info where modify_time < '%@' and (user_id = '%@' or user_id = -1) order by modify_time desc limit 1",time,[Global GetUsrID]];
//	//MLOG(sql);
//	int ret = db -> query((char *)[sql UTF8String]);
//	
//	if(ret > 0)
//	{
//		NSString * fname  = [NSString stringWithUTF8String:db -> queryData(0,0)];
//		
//		NSString * title = [NSString stringWithUTF8String:db -> queryData(0,1)];
//		NSString * time	 = [NSString stringWithUTF8String:db -> queryData(0,2)];
//		NSString * tag	 = [NSString stringWithUTF8String:db -> queryData(0,4)];
//		NSString * editTime  = [NSString stringWithUTF8String:db -> queryData(0,3)];
//		NSString * uploadFlag = [NSString stringWithUTF8String:db -> queryData(0,5)];
//		
//		NSString * mysql = [NSString stringWithFormat:@"select item_ext from tb_item_info where item_id = '%@'",fname];
//		
//		db->query((char *)[mysql UTF8String]);	
//		NSString * fext  = [NSString stringWithUTF8String:db->queryData(0,0)];
//		NSString * path = [NSString stringWithFormat:@"%@/%@.%@",DATA_PATH,fname,fext];
//		
//		element = [NSMutableDictionary dictionaryWithObjectsAndKeys:fname,@"guid",path,@"path",title,@"title",editTime,@"editTime",time,@"time",tag,@"tag",uploadFlag,@"uploadFlag",nil];
//	}else
//	{
//		element = [[NSMutableDictionary alloc] init];
//	}
//	
//	return element;
//}
//
//- (int) getNoteCount
//{
//	NSString * sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where (user_id = %@ or user_id = -1)",[Global GetUsrID]];
//	int rows = 0;
//	if(db->query((char *)[sql UTF8String])>0)
//		rows = atoi(db->queryData(0,0));
//	return rows;
//}
//
//- (NSDictionary *)getPreItemByTime:(NSString *)time
//{
//	NSDictionary * dict = nil;
//	return dict;
//}
//
///****************************************************************************
// /				  | (NSMutableArray)		          (NSString *)
// /	              | tag_flag	     =  { tag1.flag,	 tag2.flag,     ... }
// /	tb_tags     --| tag_context      =  { tag1.context,	 tag2.context,  ... }
// /				  | tag_location     =  { tag1.location, tag2.location, ... }
// /				  |
// ****************************************************************************/ 
//
//- (int) getUnReadCount
//{
//	int count = 0;
//	NSString * sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where (user_id = %@ or user_id = -1) and read_flag = 0",[Global GetUsrID]];
//	int x = db->query((char *)[sql UTF8String]);
//	if(x)
//	{
//		count = atoi(db->queryData(0,0));
//	}
//	
//	return count;
//}
//
//- (int) setRead:(NSString *)firstItem
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_note_info set read_flag = 1 where (user_id = %@ or user_id = -1) and first_item = '%@'",[Global GetUsrID],firstItem];
//	return db->exec((char *)[sql UTF8String]);
//}
//
//- (int) getUnUploadCount
//{
//	int count = 0;
//	NSString * sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where (user_id = %@ or user_id = '-1') and upload_flag = 0",[Global GetUsrID]];
//	int x = db->query((char *)[sql UTF8String]);
//	if(x>0)
//	{
//		count = atoi(db->queryData(0,0));
//	}
//	
//	return count;
//}
//
//- (int)setVersionId:(NSString *)firstItem vid:(int) vid 
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_note_info set version_id = %d where (user_id = %@ or user_id = -1) and first_item = '%@'",vid,[Global GetUsrID],firstItem];
//	return db->exec((char *)[sql UTF8String]);
//}
//
//- (int)setUploadFlag:(NSString *)firstItem flag:(int) isUpload
//{
//	//上传只针对注册的用户
////	if([[Global GetGUID] intValue] == -1)
////	{
////		return -1;
////	}
//	NSString * sql = [NSString stringWithFormat:@"update tb_note_info set upload_flag = %d where (user_id = %@ or user_id = -1)and first_item = '%@'",isUpload,[Global GetUsrID],firstItem];
//	MLOG(sql);
//	return db->exec((char *)[sql UTF8String]);
//}
//
//- (int)setUploadFlag:(NSString *)firstItem 
//{
//	return  [self setUploadFlag:firstItem flag:1];
//}
//
//- (void)setUserId:(NSString *)uid withNote:(NSString *)noteId
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_note_info set user_id = %@ where note_id = '%@'",uid,noteId];
//	db->exec((char *)[sql UTF8String]);
//}
//
////- (BOOL) hasNote:(NSString *) nid
////{
////	BOOL ret = NO;
////	NSString * sql = [NSString stringWithFormat:@"select * from tb_note_info where noteId = '%@' and user_id = %@",nid,[Global GetUsrID]];
////	if(db->query((char *)[sql UTF8String])>0)
////		ret = YES;
////	return  ret;
////}
//
////- (int) getCurVersionIdByNote:(NSString *) noteId
////{
////	NSString * sql = [NSString stringWithFormat:@"select version_id from tb_note_info where (user_id = %@ or user_id = -1) and note_id = '%@'",[Global GetUsrID],noteId];
////	int ver = 0;
////	if(db->query((char *)[sql UTF8String])>0)
////	{
////		ver = atoi(db->queryData(0,0));
////	}
////	return ver;
////}
////
////- (int) getCreateVersionIdByNote:(NSString *)noteId
////{
////	NSString * sql = [NSString stringWithFormat:@"select create_version_id from tb_note_info where (user_id = %@ or user_id = -1) and note_id = '%@'",[Global GetUsrID],noteId];
////	int ver = 0;
////	if(db->query((char *)[sql UTF8String])>0)
////	{
////		ver = atoi(db->queryData(0,0));
////	}
////	return ver;
////}
//
//- (int) getMaxVersionID
//{
//	NSString * sql = [NSString stringWithFormat:@"select max(version_id) from tb_note_info where (user_id = %@ or user_id = -1)",[Global GetUsrID]];
//	int ver = 0;
//	if(db->query((char *)[sql UTF8String])>0 && db->queryData(0,0)!=NULL)
//	{
//		ver = atoi(db->queryData(0,0));
//	}
//	return ver;
//	
//}
//
////- (NSString *) getCreateTime:(NSString *)noteId
////{
////	NSString * sql = [NSString stringWithFormat:@"select create_time from tb_note_info where (user_id = %@ or user_id = -1) and note_id = '%@'",[Global GetUsrID],noteId];
////	NSString * time = @"";
////	if(db->query((char *)[sql UTF8String])>0)
////	{
////		char * tmp = db->queryData(0,0);
////		if(tmp!=NULL)
////			time = [NSString stringWithUTF8String:tmp];
////	}
////	return time;
////}
////
////- (NSString *) getEditTime:(NSString *)noteId
////{
////	NSString * sql = [NSString stringWithFormat:@"select modify_time from tb_note_info where (user_id = %@ or user_id = -1) and note_id = '%@'",[Global GetUsrID],noteId];
////	NSString * time = @"";
////	if(db->query((char *)[sql UTF8String])>0)
////	{
////		char * tmp = db->queryData(0,0);
////		if(tmp!=NULL)
////			time = [NSString stringWithUTF8String:tmp];
////	}
////	return time;
////}
//
//- (NSString *) getNoteTypeById:(NSString *)noteId
//{
//	NSString * ret = @"-1";
//	NSString * sql = [NSString stringWithFormat:@"select note_type from tb_note_info where (user_id = %@ or user_id = -1) and note_id = '%@'",[Global GetUsrID],noteId];
//	if(db->query((char *)[sql UTF8String])>0)
//	{
//		ret = [NSString stringWithUTF8String:db->queryData(0,0)];
//	}
//	return ret;
//}
//
//// 流量控制
//- (BOOL)isTodayRecorded
//{
//	
//    //	NSString * dateStr = [Global GetCurrentDate];
//    //	NSDate  *date = [Global NSString2Day:dateStr];
//    //	double  myAbsoluteTime = [date timeIntervalSince1970];
//	//sqlite3 dateTime 类型查询不能加引号
//	NSString * sql = [NSString stringWithFormat:@"select * from tb_charge_info where day = %@",[Global GetCurrentDate]];
//	if(db->query((char *)[sql UTF8String])>0)
//	{
//		return YES;
//	}
//	return NO;
//}
//
//- (BOOL)insertToday
//{
//	NSString * sql = [NSString stringWithFormat:@"insert into tb_charge_info(day,flow,imsi) values('%@',0,'%@')",[Global GetCurrentDate],[Global getIMSI]];
//	if(db->exec((char *)[sql UTF8String]) == 0)
//	{
//		return YES;
//	}
//	return NO;
//}
//
//- (void)addFlows:(int) bytes
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_charge_info set flow = flow + %f where day = '%@' and imsi = '%@'",(float)bytes,[Global GetCurrentDate],[Global getIMSI]];
//	//MLOG(sql);
//	db->exec((char *)[sql UTF8String]);
//}
//
//- (double)getChargeSince:(NSString *)date
//{
//	double ret = 0;
//	NSString * sql = nil;
//	if([date isEqualToString:[Global GetCurrentDate]])
//	{
//		sql = [NSString stringWithFormat:@"select sum(flow) from tb_charge_info where day = date('%@') and imsi = '%@'",[Global GetCurrentDate],[Global getIMSI]];
//	}else
//	{
//		sql = [NSString stringWithFormat:@"select sum(flow) from tb_charge_info where (day > date('%@') and day <= date('%@')) and imsi = '%@'",date,[Global GetCurrentDate],[Global getIMSI]];
//	}
//	//MLOG(sql);
//	if(db->query((char *)[sql UTF8String])>0)
//	{
//		char * data = db->queryData(0,0);
//		if(data == NULL)
//		{
//			ret = 0;// 防止用户本地时间超时设置
//		}else
//			ret = atof(data);
//	}
//	return ret;
//}
//
//- (NSString *)getLastUpdateDay
//{
//	NSString * ret = nil;
//	NSString * sql = [NSString stringWithFormat:@"select max(day) from tb_charge_info where imsi = '%@'",[Global getIMSI]];
//	
//	if( db->query((char *)[sql UTF8String])>0)
//	{
//		char * tmp = db->queryData(0,0);
//		if(tmp!=NULL)
//			ret = [NSString stringWithUTF8String:tmp];
//	}
//	return ret;
//}
//
//// tb_card_info
//- (NSString *)getMaxDisCharge
//{
//	NSString * ret = nil;
//	NSString * sql = [NSString stringWithFormat:@"select max_discharge from tb_card_info where imsi = '%@'",[Global getIMSI]];
//	
//	if( db -> query((char *)[sql UTF8String])>0)
//	{
//		ret = [NSString stringWithUTF8String: db->queryData(0,0)];
//	}
//	return ret;
//}
//
//- (void)setMaxDisCharge:(NSString *)maxCharge
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_card_info set max_discharge = '%@' where imsi = '%@'",maxCharge,[Global getIMSI]];
//	db->exec((char *)[sql UTF8String]);
//}
//
//- (NSString *)getClearDay
//{
//	NSString * ret = nil;
//	NSString * sql = [NSString stringWithFormat:@"select clear_day from tb_card_info where imsi = '%@'",[Global getIMSI]];
//	
//	if( db -> query((char *)[sql UTF8String])>0)
//	{
//		ret = [NSString stringWithUTF8String: db->queryData(0,0)];
//	}
//	return ret;
//}
//
//- (void)setClearDay:(NSString *)clearDay
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_card_info set clear_day = '%@' where imsi = '%@'",clearDay,[Global getIMSI]];
//	//MLOG(sql);
//	db->exec((char *)[sql UTF8String]);
//}
//
//- (BOOL)getGPRSFlag
//{
//	BOOL  ret = YES;
//	NSString * sql = [NSString stringWithFormat:@"select gprs_flag from tb_card_info where imsi = '%@'",[Global getIMSI]];
//	
//	if( db -> query((char *)[sql UTF8String])>0)
//	{
//		ret = [[NSString stringWithUTF8String: db->queryData(0,0)] boolValue];
//	}
//	return ret;
//}
//
//- (void)setGPRSFlag:(BOOL)flag
//{
//	NSString * sql = [NSString stringWithFormat:@"update tb_card_info set gprs_flag = %d where imsi = '%@'",flag,[Global getIMSI]];
//	//MLOG(sql);
//	db->exec((char *)[sql UTF8String]);
//}
//
//- (BOOL)isCardActive
//{
//	NSString * sql = [NSString stringWithFormat:@"select * from tb_card_info where imsi = '%@'",[Global getIMSI]];
//	//MLOG(sql);
//	
//	if(db->query((char *)[sql UTF8String]) > 0)
//	{
//		return YES;
//	}
//	return NO;
//}
//
//- (void)insertACardInfo
//{
//	NSString * sql = [NSString stringWithFormat:@"insert into tb_card_info(imsi,max_discharge,clear_day,gprs_flag) values('%@',15,1,1)",
//					  [Global getIMSI]];
//	//MLOG(sql);
//	db->exec((char *)[sql UTF8String]);
//}
//
//- (int)getNoteIndexById:(NSString *)noteId
//{
//	NSString * sql = [NSString stringWithFormat:@"select note_id from tb_note_info where (user_id = '%@' or user_id = -1) order by modify_time desc",[Global GetUsrID]];
//	int ret = -1;
//	int rows = db->query((char *)[sql UTF8String]);
//	for(int i = 0 ; i<rows; i++)
//	{
//		char *text = db->queryData(i,0);
//		if(text!=nil)
//		{
//			NSString * str = [NSString stringWithUTF8String:text];
//			if([str caseInsensitiveCompare:noteId]==0)
//			{
//				ret = i;
//				break;
//			}
//		}	
//	}
//	return ret;
//}
//
//- (void)dealloc {
//	delete db;
//    [super dealloc];
//}
//
//
//@end
