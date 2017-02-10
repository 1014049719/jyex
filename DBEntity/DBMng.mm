//
//  DBController.m
//  SparkEnglish
//
//  Created by huanghb on 11-1-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import  "CommonDirectory.h"

#import "DBMng.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "BussComdIDDef.h"

#import "ComCustomConstantDef.h"
#import "Calendar.h"
#import "Festival.h"


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
        "[sync_state] tinyint, "           //没有用到
        "[need_upload] tinyint, "          //没有用到
        //以下add 1.3版本
        "[server_type] varchar,"
        "[catalog_color] int,"
        "[catalog_icon] int,"
        "[mobile_flag] int,"
        "[note_count] int,"
        
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
        "[need_downlord] tinyint, "      //这里，应该时 need_download, 为了兼容考虑，先不改
        "[owner_id] int, "
        "[from_id] int, "
        "[star_level] tinyint,"
        //以下add 1.3版本
        "[expire_date] datetime,"
        "[finish_date] datetime,"
        "[finish_state] tinyint,"
        "[content] varchar(255),"
        
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
        //以下add 1.3版本
        "[item_title] varchar(255),"
        "[upload_size] int,"
        "[note_id] varchar(36),"
        
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
        "[need_downlord] tinyint, "   //应该是 need_download, 但为了兼容，不修改
        //以下add 1.3版本
        "[item_order] int,"
        
        
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



#pragma mark -
#pragma mark 数据库对象封装

@implementation DbItem

@synthesize	fDBFileName, fCppSqlite3DB, iDbTypeID;
@synthesize bUpdatedWhenLoading;

- (id) init
{
    self = [super init];
	if (self )
	{
		fDBFileName = nil;
		fCppSqlite3DB = nil;
		iDbTypeID = EDbTypeNull;
		bUpdatedWhenLoading = NO;
	}
	return self;
}

- (void) dealloc
{
	self.fDBFileName = nil;
	self.fCppSqlite3DB = nil;

	[super dealloc];
}
- (BOOL) openWithType: (EDataBaseType) dbType
{
    //路径
	NSString* path = [CommonFunc getDbFilePathBy:dbType UserName:TheCurUser.sUserName];
	if ([PubFunction stringIsNullOrEmpty:path])
	{
		return NO;
	}
    
	//数据库文件名
	NSString* dbname = [CommonFunc getDbFileNameBy:dbType];
	if ([PubFunction stringIsNullOrEmpty:dbname])
	{
		return NO;
	}
    
	//全路径
	NSString* fullPath = [path stringByAppendingPathComponent:dbname];
	if ([self.fDBFileName caseInsensitiveCompare:fullPath]==0 && [self isOpen])
	{
		return YES;
	}
	
	self.iDbTypeID = dbType;
	
    if (nil == fCppSqlite3DB) 
	{
		self.fCppSqlite3DB = new CppSQLite3DB();
	}
	
	fCppSqlite3DB->Open([fullPath UTF8String], "");
	if (fCppSqlite3DB->IsOpen())
	{
		self.fDBFileName = fullPath;
		return YES;
	}
	
	return NO;
    
}

- (BOOL) isOpen
{
	if (nil == fCppSqlite3DB) 
	{
		return NO;
	}
	
	return fCppSqlite3DB->IsOpen() ? YES : NO;
}

- (BOOL) close
{
	if (nil == fCppSqlite3DB || [PubFunction stringIsNullOrEmpty:fDBFileName]) 
	{
		return YES;
	}
	//self.fDBFileName = [NSString stringWithString:@""];
    self.fDBFileName = @"";
    //	[fDBFileName setString:@""];
	@try 
	{
		fCppSqlite3DB->Close();
		delete fCppSqlite3DB;
		fCppSqlite3DB = nil;
	}
	@catch (NSException * e) 
	{
		return NO;
	}
	@finally 
	{
		
	}
	return YES;
}


/*
- (BOOL) openWithName:(NSString *) dbFileNameWithFullPath
{
	return [self openWithName:dbFileNameWithFullPath  DbKey:@""];
}

- (BOOL) openWithName:(NSString *) dbFileNameWithFullPath DbKey:(NSString *) dbKey
{
	//LOG_DEBUG(@"dbfile name is:%@, key is:%@", dbFileNameWithFullPath, dbKey);
	
	if ([self isOpen])
	{
		return YES;
	}
	
    self.iDbTypeID = [AstroDBMng getDbTypeFromFile:dbFileNameWithFullPath];

	if (nil == fCppSqlite3DB) 
	{
		self.fCppSqlite3DB = new CppSQLite3DB();
	}
	else 
	{
		if ([dbFileNameWithFullPath caseInsensitiveCompare:fDBFileName])
		{
			return YES;
		}
	}
	
	fCppSqlite3DB->Open([dbFileNameWithFullPath UTF8String], [dbKey UTF8String]);
	if (fCppSqlite3DB->IsOpen())
	{
		self.fDBFileName = [NSString stringWithString:dbFileNameWithFullPath];
//		[fDBFileName setString:];
		return YES;
	}
	
	return YES;
}
 */



/*
- (BOOL) openWithType: (EDataBaseType) dbType DbKey:(NSString*) key
{
	NSString* path = [AstroDBMng getDbFilePathBy:dbType UserName:TheCurUser.sUserName];
	if ([PubFunction stringIsNullOrEmpty:path])
	{
		return NO;
	}
	
	NSString* dbname = [AstroDBMng getDbFileNameBy:dbType];
	if ([PubFunction stringIsNullOrEmpty:dbname])
	{
		return NO;
	}
	
	self.iDbTypeID = dbType;
	NSString* fullPath = [path stringByAppendingPathComponent:dbname];
	return [self openWithName:fullPath DbKey:key];
}
*/


- (BOOL) setKey: (NSString *) key
{
	if (nil == fCppSqlite3DB || [PubFunction stringIsNullOrEmpty:fDBFileName])
	{
		return NO;
	}
	@try 
	{
		fCppSqlite3DB->SetKey([key UTF8String], [key length]);
	}
	@catch (NSException * e)
	{
		return NO;
	}
	@finally 
	{
		
	}
	return YES;
}

- (BOOL) resetKey: (NSString *) key
{
	if (nil == fCppSqlite3DB || [PubFunction stringIsNullOrEmpty:fDBFileName])
	{
		return NO;
	}
	@try
	{
		fCppSqlite3DB->ResetKey([key UTF8String], [key length]);
	}
	@catch (NSException * e)
	{
		return NO;
	}
	@finally 
	{
		
	}
	return YES;
}

/*
- (NSString *) getDBFileName
{
	return fDBFileName;
}
*/

- (NSString*) getDbFileShortName
{
	NSString* fileName = [fDBFileName lastPathComponent];
	return fileName;
}

		 
//执行查询语句，返回动态记录集
- (CppSQLite3Query) execQuery: (NSString *) sql
{
	return fCppSqlite3DB->ExecQuery([sql UTF8String]);
}

//执行SQL语句
- (int) execDML: (NSString *) sql
{
	if (nil == fCppSqlite3DB) 
	{
		return 0;
	}
	return fCppSqlite3DB->ExecDML([sql UTF8String]);
}

//执行返回单个数值的查询语句
- (int) execScalar: (NSString *) sql
{
	if (nil == fCppSqlite3DB) 
	{
		return 0;
	}
	return fCppSqlite3DB->ExecScalar([sql UTF8String]);
}

//以下函数用于事务处理
- (BOOL) beginTransaction
{
	if (nil == fCppSqlite3DB)
	{
		return NO;
	}
	return (SQLITE_OK == fCppSqlite3DB->BeginTransaction());
}

- (BOOL) commitTransaction
{
	if (nil == fCppSqlite3DB) 
	{
		return NO;
	}
	return (SQLITE_OK == fCppSqlite3DB->Commit());
}

- (BOOL) rollbackTransaction
{
	if (nil == fCppSqlite3DB) 
	{
		return NO;
	}
	return (SQLITE_OK == fCppSqlite3DB->Rollback());
}


- (BOOL) pepareStatement:(NSString*) sql Statement:(CppSQLite3Statement*) stmt
{
	if (nil == fCppSqlite3DB)
	{
		return NO;
	}
	
	*stmt = fCppSqlite3DB->CompileStatement([sql UTF8String]);
	return YES;
}

- (int) commitStatement:(CppSQLite3Statement*) stmt
{
	int result = stmt->ExecDML();
	stmt->Reset();
	return result;
}

@end



@implementation AstroDBMng

@synthesize dctDbItem;
#pragma mark -
#pragma mark 静态方法－－获取访问数据库的实例

//数据库管理
+(AstroDBMng *) getAstroDbMng
{
	if(TheDbMng == nil)
	{
		TheDbMng = [[AstroDBMng new] autorelease];
	}
	return TheDbMng;
}



//系统数据库

+(DbItem *) getDbCustom1
{
	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbTypeCustom1];
	return db;
}

+(DbItem *) getDbCustom2
{
	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbTypeCustom2];
	return db;
}

+(DbItem *) getDbCustom3
{
	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbTypeCustom3];
	return db;
}


+(DbItem *) getDbAstroCommon
{
	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbTypeAstroCommon];
	return db;
}


//用户数据库
+(DbItem *) getDbUserLocal
{
	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbTypeUserLocal];
	return db;
}


//91Note数据库
+(DbItem *) getDb91Note
{
   	DbItem* db = [[AstroDBMng getAstroDbMng] getDbInstace:EDbType91Note];
	return db; 
}


#pragma mark -
#pragma mark 实例方法

-(id) init
{
	self = [super init];
	if (self)
	{
		if (self.dctDbItem)
		{
			[self.dctDbItem removeAllObjects];
		}
		self.dctDbItem = [NSMutableDictionary dictionary];
	}
	return self;
}

-(DbItem*) getDbInstace:(EDataBaseType) typeID
{
	if (nil == dctDbItem)
	{
		self.dctDbItem = [NSMutableDictionary dictionary];
	}
	
	DbItem* dbItem = [dctDbItem objectForKey:[NSNumber numberWithInt:typeID]];
	if (!dbItem)
	{
		dbItem = [DbItem new];
		[dctDbItem setObject:dbItem forKey:[NSNumber numberWithInt:typeID]];
		[dbItem release];
	}

	return dbItem;
}

-(void) dealloc
{
	if (self.dctDbItem)
	{
		[self.dctDbItem removeAllObjects];
		self.dctDbItem = nil;
	}
	
	
	[super dealloc];
}



//升级数据库
+(BOOL) updateDatabase
{
	LOG_INFO(@"数据库版本升级...  username=%@", TheCurUser.sUserName);
	[AstroDBMng UpdateCommonDataTable];
	
	return YES;
}

+(BOOL) UpdateCommonDataTable
{
    [self checkCommonDatabase];
    return YES;
    
    /*
	DbItem* dbCommon = [AstroDBMng getDbAstroCommon];
	if (!dbCommon)
	{
		return NO;
	}
    
    //-------
    
    //-------
    
	if (dbCommon.bUpdatedWhenLoading)
	{
		return YES;
	}
	
	
	@try
	{
		int nCurDbVer = [AstroDBMng getDbVersion:EDbTypeAstroCommon];
		if (nCurDbVer < 1)
		{
			[AstroDBMng initCommonDb_V1];
		}
		
		if (nCurDbVer < APP_DBVER_COMMON)
		{
			[AstroDBMng setDbVersion:EDbTypeAstroCommon Vers:APP_DBVER_COMMON Desc:@""];
		}
		
		dbCommon.bUpdatedWhenLoading = YES;
		return YES;
	}
	@catch (NSException * e)
	{
		return NO;
	}
	
	return NO;
    */
}

//Common数据库升级
+(BOOL)checkCommonDatabase
{
    try {
        [[AstroDBMng getDbAstroCommon] execDML:@"SELECT 1 FROM AccountInfo WHERE iSchoolType=0;"];
    }
    
    catch (CppSQLite3Exception e) {
           
        NSString *strSql = @"ALTER TABLE AccountInfo ADD [iSchoolType] int;";
        try{
            [[AstroDBMng getDbAstroCommon] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
    
        NSLog(@"update database(common) success");
        
        return TRUE;
    }
    
    return FALSE;
}



+(void) initCommonDb_V1
{
	//建表脚本	
	NSMutableArray* arySQL = [[NSMutableArray alloc] initWithObjects:
							  
							  //[DbVersion]
							  @"CREATE TABLE IF NOT EXISTS [DbVersion] (	\
							  [ver] integer UNIQUE NOT NULL,	\
							  [verDesc] varchar(100)	\
							  ); "
							  ,

							  //[CONFIG]
							  @"CREATE TABLE IF NOT EXISTS [CONFIG] (	\
							  [cfg_key] varchar(100) UNIQUE NOT NULL,	\
							  [cfg_condition] varchar(100),	\
							  [cfg_value] varchar(300) \
							  );" 
							  ,	
							  
							  //ACCOUNTINFO
							  @"CREATE TABLE IF NOT EXISTS [AccountInfo] (	\
							  [sUserName] varchar(300) PRIMARY KEY NOT NULL	\
							  ,[sUserPasswd] VARCHAR(300)	\
							  ,[sUserID] varchar(50)	\
							  ,[sNickName] VARCHAR(200)	\
							  ,[sRealName] VARCHAR(200)	\
							  ,[sUAPID] VARCHAR(200)	\
							  ,[sSID] VARCHAR(200)	\
							  ,[sSessionID] VARCHAR(200)	\
							  ,[sLoginTime] datetime	\
							  ,[iLoginType] INTEGER DEFAULT 0	\
							  ,[iGroupID] INTEGER DEFAULT 0	\
							  ,[iAppID] INTEGER	\
							  ,[sBlowfish] INTEGER	\
							  ,[iSavePasswd] INTEGER DEFAULT 0	\
							  ,[iAutoLogin] INTEGER DEFAULT 0	\
							  ,[sSrvTbName] varchar(50)		\
							  ,[sMsg] VARCHAR(200)	\
                              ,[sNoteUserId] VARCHAR(50)	\
                              ,[sNoteMasterKey] VARCHAR(50)	\
                              ,[sNoteIpLocation] VARCHAR(200)	\
							  );"  //2013.1.6 增加note的3个字段
							  ,
							  
							  nil];
	
	//执行脚本
	@try
	{
		for(int i = 0; i < [arySQL count]; i ++)
		{
			[[AstroDBMng getDbAstroCommon] execDML:[arySQL objectAtIndex:i]];
		}
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"创建数据表出错");
	}
	@finally
	{
		[arySQL release];
	}
	
}

+(BOOL) UpdateUserDataTable
{
	DbItem* dbCustom1 = [AstroDBMng getDbUserLocal];
	if (!dbCustom1)
	{
		return NO;
	}
	if (dbCustom1.bUpdatedWhenLoading)
	{
		return YES;
	}
	
	
	@try
	{
		int nCurDbVer = [AstroDBMng getDbVersion:EDbTypeUserLocal];
		if (nCurDbVer < 1)
		{
			[AstroDBMng initUserLocalDb_V1];
		}
        
        if (nCurDbVer==1 && APP_DBVER_USERLOCAL==2)
        {
            [AstroDBMng updateUserLocalDb_1_2];
        }
        
		if (nCurDbVer < APP_DBVER_USERLOCAL)
		{
			[AstroDBMng setDbVersion:EDbTypeUserLocal Vers:APP_DBVER_USERLOCAL Desc:@""];
		}
				
		dbCustom1.bUpdatedWhenLoading = YES;
		return YES;
	}
	@catch (NSException * e)
	{
		return NO;
	}
	
	return NO;
}


+(void) initUserLocalDb_V1
{
	//建表脚本	
	NSMutableArray* arySQL = [[NSMutableArray alloc] initWithObjects:
							  
							  //[DbVersion]
							  @"CREATE TABLE IF NOT EXISTS [DbVersion] (	\
							  [ver] integer UNIQUE NOT NULL,	\
							  [verDesc] varchar(100)	\
							  ); "
							  ,
							  
							  //[CONFIG]
							  @"CREATE TABLE IF NOT EXISTS [CONFIG] (	\
							  [cfg_key] varchar(100) UNIQUE NOT NULL,	\
							  [cfg_condition] varchar(100),	\
							  [cfg_value] varchar(300) \
							  );" 
							  ,	
							  
							  
							  //[PeopInfo]
							  @"CREATE TABLE IF NOT EXISTS [PeopInfo] (		\
							  [iPeopleId] INTEGER PRIMARY KEY ASC AUTOINCREMENT UNIQUE NOT NULL,	\
							  [sGuid] varchar(50) UNIQUE,	\
							  [sPersonName] varchar(20),	\
							  [sPersonTitle] varchar(20),	\
							  [sSex] varchar(6),	\
							  [sBirthplace] varchar(50),	\
							  [bIsHost] int,	\
							  [iYear] int,	\
							  [iMonth] int,	\
							  [iDay] int,	\
							  [iHour] int,	\
							  [iMinute] int,	\
							  [iLlYear] int,	\
							  [iLlDay] int,	\
							  [iLlMonth] int,	\
							  [sLlHour] varchar(10),	\
							  [bLeap] int,	\
							  [sTimeZone] varchar(10),	\
							  [sWdZone] varchar(10),	\
							  [iLongitude] int,	\
							  [iLongitude_ex] int,	\
							  [iLatitude] int,	\
							  [iLatitude_ex] int,	\
							  [iTimeZone] int,	\
							  [iDifRealTime] int,	\
							  [sSaveUserInput] varchar(50),		\
							  [iGroupId] int,	\
							  [sHeadImg] varchar(30),	\
							  [sUid] varchar(30),	\
							  [iDataOpt] int default 0,	\
							  [iVersion] int,	\
							  [bSync] int default 0	\
							  ); "
							  ,
							  
							  //[CityWeather] 
							  @"CREATE TABLE IF NOT EXISTS [CityWeather] (	\
							  [sCityCode] varchar PRIMARY KEY UNIQUE NOT NULL,	\
							  [sCityName] varchar,	\
							  [iSort] integer,	\
							  [sWkWeathJson] varchar,	\
							  [sImWeathJson] varchar,	\
							  [sWkWeathTime] varchar,	\
							  [sImWeathTime] varchar,	\
							  [iDefCity] int ); "
							  ,
							  
							  //[Suggest]
							  @"CREATE TABLE IF NOT EXISTS [Suggest] (	\
							  [sQuestNO] varchar PRIMARY KEY UNIQUE NOT NULL,	\
							  [sQuestion] text(300),	\
							  [sAskTime] datetime,		\
							  [iFlag] int DEFAULT 0		\
							  ); "
							  ,

							  //[SuggestAnswer]
							  @"CREATE TABLE IF NOT EXISTS [SuggestAnswer] (	\
							  [sQuestNO] varchar(70) NOT NULL,		\
							  [sAnswer] text(300),		\
							  [sAnsTime] datetime	\
							  );"
							  ,

							  //[LocalData]
							  @"CREATE TABLE IF NOT EXISTS [LocalData] (		\
							  [ID] integer PRIMARY KEY AUTOINCREMENT UNIQUE,	\
							  [groupkey] varchar(20),	\
							  [groupitem] varchar(20),	\
							  [itemno] integer,		\
							  [itemcode] varchar(50),	\
							  [itemvalue] varchar(100),	\
							  [itemnote] varchar(200),	\
							  [itemtext] text		\
							  );"
							  ,
							  
							  
							  //[YunshiCache]
							  @"CREATE TABLE IF NOT EXISTS [YunshiCache] (	\
							  [sGuid] varchar(50) NOT NULL,		\
							  [sPeplSumInfo] varchar(100) NOT NULL,		\
							  [iType] integer DEFAULT 0,	\
							  [iYear] integer DEFAULT 0,	\
							  [iMonth] integer DEFAULT 0,	\
							  [iDay] integer DEFAULT 0,		\
							  [sYunshiDesc] text	\
							  );"
							  ,
							  
							  @"CREATE UNIQUE INDEX IF NOT EXISTS [INDEX_YUNSHI_GUID_TYPE_DATE] On [YunshiCache] (	\
							  [sPeplSumInfo] ,	\
							  [iType] ,	\
							  [iYear] ,	\
							  [iMonth] ,	\
							  [iDay]	\
							  );"
							  ,
							  
							  @"CREATE UNIQUE INDEX IF NOT EXISTS [INDEX_YUNSHI_TYPE] On [YunshiCache] (	\
							  [iType]	\
							  );"
							  ,
							  
							  nil];
    
	
	//执行脚本
	@try
	{
		for(int i = 0; i < [arySQL count]; i ++)
		{
			[[AstroDBMng getDbUserLocal] execDML:[arySQL objectAtIndex:i]];
		}
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"创建数据表出错");
	}
	@finally
	{
		[arySQL release];
	}
	
}

+(void) updateUserLocalDb_1_2
{
    DbItem* db = [AstroDBMng getDbUserLocal];
    //create table WeatherInfo;
    NSString* sql = @"CREATE TABLE IF NOT EXISTS [WeatherInfo] "
    "([sCityCode] varchar PRIMARY KEY UNIQUE NOT NULL, "
    "[sDate] varchar, [sJson] varchar, [rUpdateTime] real);";
    [db execDML:sql];
    
    //get all cityseting;
     sql = @"SELECT sCityCode, sCityName, iSort FROM CityWeather ORDER BY iSort;";
    
    NSMutableArray *citys = [NSMutableArray array];
    CppSQLite3Query query = [db execQuery:sql];
    while (!query.Eof()) 
    { 
        TCityWeather* data = [TCityWeather new];
        data.sCityCode = [NSString stringWithUTF8String:query.GetStringField("sCityCode","")];
        data.sCityName = [NSString stringWithUTF8String:query.GetStringField("sCityName","")];
        data.iSort = query.GetIntField("iSort", 0);
        
        [citys addObject:data];
        [data release];
        
        query.NextRow();
    }
    
    //drop city setting;
    sql = @"DROP TABLE CityWeather;";
    [db execDML:sql];
    
    //addnew
    sql = @"CREATE TABLE IF NOT EXISTS [CityWeather] "
    "([sCityCode] varchar PRIMARY KEY UNIQUE NOT NULL, "
    "[sCityName] varchar, [iSort] integer);";
    [db execDML:sql];
    
    //inset setting;
    sql = @"REPLACE INTO CityWeather VALUES(?,?,?);";
    for (TCityWeather* city in citys)
    {
    
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
            continue;
        
		int i = 1;
		stmt.Bind(i++, [city.sCityCode UTF8String]);
		stmt.Bind(i++, [city.sCityName UTF8String]);
		stmt.Bind(i++, city.iSort);
		[db commitStatement:&stmt];
    }
}


//执行91note脚本
+(BOOL) create91NoteTables
{
    
    for (int i = 0; i < sizeof(tableIndexInfo) / sizeof(tableIndexInfo[0]); i++)
    {
        NSString  *tableType;
        if (tableIndexInfo[i].nTableIndexType == TT_INDEX)
            tableType = @"index";
        else
            tableType = @"table";
        
        try
        {
            // 查看数据库中是否已经存在表
            NSString  *strQuery =[NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='%@' and name='%@';",tableType, [NSString stringWithUTF8String:tableIndexInfo[i].pszTableIndexName]];
            
            CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strQuery];
            if ( !query.Eof()) 
            {        
                int nRet = query.GetIntField(0, 0);
                if (nRet <= 0)
                {
                    int result = [[AstroDBMng getDb91Note] execDML:[NSString stringWithUTF8String:tableIndexInfo[i].pszCreateSql]];
                    if (result != SQLITE_OK)
                    {
                        continue;
                    }
                }
            }
        }
        catch(CppSQLite3Exception e)
        {
            LOG_ERROR(@"SQL: %@ error", [NSString stringWithUTF8String:tableIndexInfo[i].pszCreateSql]);
        }
    }
    
    // 如果查询不到则修改表
    //try {
    //    [self execDML:"SELECT 1 FROM tb_note_info WHERE star_level=0;"];
    //} catch (CppSQLite3Exception e) {
        // 为tb_note_info添加字段
    //    [self execDML:"ALTER TABLE tb_note_info ADD star_level tinyint;"];
    //}
    
    return true;
}


//91note数据库升级(从1.2.5到1.3.0)
+(BOOL)check91NoteTables_V125_To_V130
{
 
    try {
        [[AstroDBMng getDb91Note] execDML:@"SELECT 1 FROM tb_catalog_info WHERE catalog_color=0;"];
    }
    
    catch (CppSQLite3Exception e) {
        //为tb_catalog_info添加字段
        
        NSString *strSql = @"ALTER TABLE tb_catalog_info ADD [server_type] varchar;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_catalog_info ADD [catalog_color] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_catalog_info ADD [catalog_icon] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_catalog_info ADD [mobile_flag] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_catalog_info ADD [note_count] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        //更改值
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
            server_type='0', \
            catalog_color=%d,\
            catalog_icon=%d,\
            mobile_flag=%d,\
            note_count=0;",COLOR_1,ICON_DEFAULT,MOBILEFLAG_USER_CREATE];
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        //更改默认目录的部分参数
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
                  catalog_color=%d,\
                  catalog_icon=%d,\
                  mobile_flag=%d WHERE catalog_name='手机未整理';",COLOR_1,ICON_DEFAULT,MOBILEFLAG_1];
        [[AstroDBMng getDb91Note] execDML:strSql];
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
                  catalog_color=%d,\
                  catalog_icon=%d,\
                  mobile_flag=%d WHERE catalog_name='工作';",COLOR_2,ICON_WORK,MOBILEFLAG_6];
        [[AstroDBMng getDb91Note] execDML:strSql];
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
                  catalog_color=%d,\
                  catalog_icon=%d,\
                  mobile_flag=%d WHERE catalog_name='TO DO LIST';",COLOR_3,ICON_TODOLIST,MOBILEFLAG_3];
        [[AstroDBMng getDb91Note] execDML:strSql];
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
                  catalog_color=%d,\
                  catalog_icon=%d,\
                  mobile_flag=%d WHERE catalog_name='灵感';",COLOR_4,ICON_AFFLATUS,MOBILEFLAG_4];
        [[AstroDBMng getDb91Note] execDML:strSql];
        strSql = [NSString stringWithFormat:@"UPDATE tb_catalog_info SET \
                  catalog_color=%d,\
                  catalog_icon=%d,\
                  mobile_flag=%d WHERE catalog_name='个人笔记';",COLOR_5,ICON_PERSONAL,MOBILEFLAG_7];
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        
        //为tb_note_info添加字段
        strSql = @"ALTER TABLE tb_note_info ADD [star_level] tinyint;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_note_info ADD [expire_date] datetime;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_note_info ADD [finish_date] datetime;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_note_info ADD [finish_state] tinyint;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_note_info ADD [content] varchar(255);";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        //更改值
        strSql = [NSString stringWithFormat:@"UPDATE tb_note_info SET \
                  star_level=0, \
                  expire_date='2100-01-01 00:00:00' ,\
                  finish_date='2100-01-01 00:00:00',\
                  finish_state=%d,\
                  content=' ';",1];
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        //为tb_note_x_item添加字段
        strSql = @"ALTER TABLE tb_note_x_item ADD [item_order] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        //更改值
        strSql = [NSString stringWithFormat:@"UPDATE tb_note_x_item SET item_order=%d;",0];
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        
        //为tb_item_info添加字段
        strSql = @"ALTER TABLE tb_item_info ADD [item_title] varchar(255);";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        strSql = @"ALTER TABLE tb_item_info ADD [upload_size] int;";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }

        strSql = @"ALTER TABLE tb_item_info ADD [note_id] varchar(36);";
        try{
            [[AstroDBMng getDb91Note] execDML:strSql];
        }
        catch (CppSQLite3Exception e) {
        }
        
        //更改值
        strSql = [NSString stringWithFormat:@"UPDATE tb_item_info SET \
                  item_title=' ', \
                  upload_size=%d;",0];
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        //更改note guid
        strSql = @"UPDATE tb_item_info SET note_id=(SELECT note_id FROM tb_note_x_item WHERE item_id=tb_item_info.item_id);";
        [[AstroDBMng getDb91Note] execDML:strSql];
        
        //统计目录的记录总数
        //NSArray *arrCatalog = [AstroDBMng getCateList_CateMgr:@""];
        //--
        NSLog(@"update database(1.25 to 1.3) success");
        
        return TRUE;
     }

    return FALSE;
}


@end




#pragma mark -
#pragma mark 数据库管理-Utility
@implementation AstroDBMng (Utility)


+ (NSString *) getErrorInfo: (NSString *) errorInfo{
	return NSLocalizedString(errorInfo, nil);	 
}

+ (NSString *) getResourceInfo: (NSString *) resourceInfo{
	return NSLocalizedString(resourceInfo, nil);
}

+ (NSString *) getErrorInfoWhenOperateDB: (NSString *) dbName : (NSString *) errorInfo{
	return [NSString stringWithFormat: NSLocalizedString(errorInfo, nil), NSLocalizedString(dbName, nil)];	 
}


+ (NSString *) getErrorInfoWhenAtomOperate: (NSString *) tableName : (NSString *) errorInfo{
	return [NSString stringWithFormat: NSLocalizedString(errorInfo, nil), NSLocalizedString(tableName, nil)];	 
}

+ (NSString *) getResourceInfo_int: (NSString *) resourceInfo : (int) paramInt{
	return [NSString stringWithFormat: NSLocalizedString(resourceInfo, nil), paramInt];
}

+ (int) getIntFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName : (int) nullValue{
	return query.GetIntField([fieldName UTF8String], nullValue);
}

+ (int) getIntFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName{
	return [AstroDBMng getIntFromCppSqlite3Query:query: fieldName: 0];
}

+ (long) getLongFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName : (long) nullValue{
	return query.GetBigIntField([fieldName UTF8String], nullValue);
}

+ (long) getLongFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName{
	return [AstroDBMng getLongFromCppSqlite3Query:query: fieldName: 0];
}

+ (NSString *) getStringFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName : (NSString *) nullValue{
	return [NSString stringWithCString: query.GetStringField([fieldName UTF8String], [nullValue UTF8String]) encoding: NSASCIIStringEncoding];
}

+ (NSString *) getStringFromCppSqlite3Query: (CppSQLite3Query) query : (NSString *) fieldName{
	return [AstroDBMng getStringFromCppSqlite3Query:query: fieldName: @""];
}

+ (NSString *) getStringFromChar: (const char *) sou{
	return [NSString stringWithCString:sou encoding:NSUTF8StringEncoding];
}


+(int) getDbVersion:(EDataBaseType)dbType
{
	int nResult = 0;
	NSString *sql = [[NSString alloc] initWithFormat:@"select ver,verDesc from [DbVersion]"];
	@try
	{
		DbItem* db = [TheDbMng getDbInstace:dbType];
		if (!db)
		{
			LOG_ERROR(@"没有相应数据库: dbtype=%d", dbType);
			return -1;
		}
		
		CppSQLite3Query query = [db execQuery:sql];
		if (query.Eof()) 
		{
			LOG_ERROR(@"数据库版本未找到: dbtype=%d", dbType);
			return nResult;
		}
		
		nResult = query.GetIntField("ver", 0);
		return nResult;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"数据库版本未找到: dbtype=%d", dbType);
		return -1;
	}
	@finally
	{
		[sql release];
	}
	
	return nResult;
}

+(BOOL) setDbVersion:(EDataBaseType)dbType Vers:(int)newVer Desc:(NSString*)sDesc
{
	NSString* sqlDel = [[NSString alloc] initWithFormat:@"delete from [DbVersion]"];
	NSString *sqlAdd = [[NSString alloc] initWithFormat:@"insert into DbVersion(ver,verDesc) values(%d,'%@')", newVer, sDesc];
	@try
	{
		DbItem* db = [TheDbMng getDbInstace:dbType];
		if (!db)
		{
			LOG_ERROR(@"没有相应数据库");
			return NO;
		}
		
		//先删除
		[db execDML:sqlDel];
		//再增加
		return ([db execDML:sqlAdd] > 0 ? YES : NO);
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"数据库版本设置出错");
		return NO;
	}
	@finally
	{
		[sqlDel release];
		[sqlAdd release];
	}
	return NO;
}


@end

@implementation AstroDBMng (ForCustom1)
+(BOOL) loadDbCustom1
{
    DbItem* db = [AstroDBMng getDbCustom1];
	if (db==nil)
	{
		LOG_ERROR(@"数据库对象(customresult_1)不存在");
		return NO;
	}
	return [db openWithType:EDbTypeCustom1];
}

#pragma mark -
#pragma mark 黄历

//宜忌冲
//参数：农历月干支，干支，返回：宜忌冲
+ (BOOL) getHuangli_YJC:(NSString*)nlMonthDZ NLDay:(NSString*)nlDayGZ HL:(THuangLi *)huangli
{
	NSString *sql = [[NSString alloc] initWithFormat:
					 @"select fetus,favonian,appropriate,terrible,avoid from advices where \
					 dayGZ = '%@' \
					 and code in (select code from advice where monthDz='%@') ",
					 nlDayGZ, nlMonthDZ];
	LOG_DEBUG(@"getHuangli_YJC:\n%@", sql);
	@try 
	{
		CppSQLite3Query query = [gDbCustom1 execQuery:sql];
		if (query.Eof()) 
		{
			LOG_ERROR(@"黄历未找到");
			return NO;
		}
		
		huangli.HuangTS = [NSString stringWithUTF8String:query.GetStringField("fetus", "")];
		huangli.HuangJS = [NSString stringWithUTF8String:query.GetStringField("favonian", "")]; 
		huangli.HuangY = [NSString stringWithUTF8String:query.GetStringField("appropriate", "")]; 			
		huangli.HuangJ = [NSString stringWithUTF8String:query.GetStringField("avoid", "")];		
		huangli.HuangC = [NSString stringWithUTF8String:query.GetStringField("terrible", "")];

		return YES;
	}
	@finally 
	{
		[sql release];
	}
	return NO;	
}

//参数：新历年，月，日，返回：宜忌冲
+ (BOOL) getHuangli_YJC:(int)yr Month:(int)mon Day:(int)day HL:(THuangLi *)huangli
{
	DateInfo tdInfo(yr, mon, day);
	//NSString *month = [NSString stringWithCString: Calendar::GetLunarInfo(Calendar::Lunar(tdInfo)).monthname.c_str() encoding:NSUTF8StringEncoding];
    
    //农历
    DateInfo nl  = Calendar::Lunar(DateInfo(yr, mon, day));
    
    NSString *monthDZ = [NSString stringWithCString: Calendar::GetLlGZMonth(nl).c_str() encoding:NSUTF8StringEncoding];  //改用农历 2012.9.10
    monthDZ = [monthDZ substringFromIndex:1]; //取第二个汉字
	NSString *dayGZ = [NSString stringWithCString: Calendar::GetLlGZDay(tdInfo).c_str() encoding:NSUTF8StringEncoding];
	
	return [AstroDBMng getHuangli_YJC:monthDZ NLDay:dayGZ HL:huangli];
}


//取得所有黄道吉日选项
+ (NSArray*) getHuangliAllItem
{
	@try
	{
		NSMutableArray* aryHuangItem = [NSMutableArray array];
		
		NSString *sql = [NSString stringWithFormat:@"select distinct sDetailModernName FROM HuangDaoJiRi order by autocode"]; // order by Pinyin 
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		while (!query.Eof())
		{
			
			NSString* sitem = [NSString stringWithUTF8String:query.GetStringField("sDetailModernName", "")];
			[aryHuangItem addObject:sitem];
			
			query.NextRow();
		}
		
		return aryHuangItem;
	}
	@finally 
	{
	}
	
	return nil;
}


//黄历名词解释
+ (BOOL) getHuangDesc: (NSString*)type : (NSString*) name : (NSString*&) orig : (NSString*&)desc
{
	//NSString* sResult = @""; 
	BOOL bResult = NO;
	orig = @"";
	desc = @"";
	NSString *sql = @"";
	
	//数据库
	DbItem* db = nil;
	
	if (([type isEqual:@"宜"]) || ([type isEqual:@"忌"]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select sOrigName, sDescribe from HuangDaoJiRi where sDetailModernName='%@' or sOrigName like '%%%@%%' ", 
			   name, name 
			   ];
		
		db = [AstroDBMng getDbCustom1];
	} 
	else if (([type isEqual:@"生肖"]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from ShengXiaoExp where name='%@' ", 
			   name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("hl_hl")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from NounsExp where name='%@' ", 
			   name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("cong")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from ChongExp where name='%@' ", 
			   [[name substringFromIndex:1] substringToIndex:1]
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("hl_jq")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from SolarTermsExp where name='%@' ", 
			   name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("hl_jr")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from TaiShenExp where name='%@' or name like '%%%@%% and 1=2' ", 
			   name, name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:@"胎神占方"]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from TaiShenExp where name='%@' or name like '%%%@%%' ", 
			   name, name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:@"彭祖百忌"]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from PengZuExp where name='%@' ", 
			   [name substringToIndex:1] 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("jsyq")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from JiShenExp where name='%@' or name like '%%%@%%' ", 
			   name, name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	else if (([type isEqual:LOC_STR("hl_xsyj")]))
	{	
		sql = [[NSString alloc] initWithFormat:
			   @"select name as sOrigName, sDescribe from XiongShenExp where name='%@' or name like '%%%@%%' ", 
			   name, name 
			   ];
		db = [AstroDBMng getDbCustom3];
	} 
	
	
	LOG_DEBUG(@"getHuangDesc:\n%@", sql);
	if ([sql isEqual:@""])
	{
		return NO;
	}
	
	@try
	{
		if (!db)
		{
			LOG_ERROR(@"未找到数据库对象.sql=%@", sql);
			return NO;
		}
		
		CppSQLite3Query query = [db execQuery:sql];
		if (!query.Eof()) 
		{
			orig = [AstroDBMng getStringFromChar:query.GetStringField("sOrigName", "")];  
			desc = [AstroDBMng getStringFromChar:query.GetStringField("sDescribe", "")];  
			if ([orig isEqual:name])
			{
				orig = @"";
			}
			else 
			{
				orig = [NSString stringWithFormat:@"(%@)", orig];
			}		
			bResult = YES;
		} 
	}
	@finally
	{
		[sql release];
	}
	//LOG_DEBUG(@"getHuangDesc result:\n%@", sResult);
	return bResult;
}


// 彭祖百忌
+ (NSString*) getPZBJ: (int) nYear : (int) nMonth : (int) nDay
{
	DateInfo info(nYear, nMonth, nDay); 
	
	NSString *sDayTgDz = [NSString stringWithCString: Calendar::GetLlGZDay(info).c_str() encoding:NSUTF8StringEncoding];
	NSString *sDayDizhi = [sDayTgDz substringFromIndex:1];
	const char *str1 = [sDayDizhi UTF8String]; 	
	int iDzIdx = Calendar::GetDiZhiIndex(str1); 
	
	NSString *sDayTiangan = [sDayTgDz substringToIndex:1];
	const char *str2 = [sDayTiangan UTF8String]; 	 
	int iTgIdx = Calendar::GetTianGanIndex(str2);
	
	NSString *result = [NSString stringWithFormat:@"%@ %@",
						[NSString stringWithCString:PZ[(iTgIdx+22)%22].c_str() encoding:NSUTF8StringEncoding], 
						[NSString stringWithCString: PZ[(iDzIdx+32)%22].c_str() encoding:NSUTF8StringEncoding]
						];
	LOG_DEBUG(@"%@", result);
	return result;
}

//节气
+ (NSString*) getJQ: (int) nYear : (int) nMonth : (int) nDay
{
	NSMutableString *result = [NSMutableString stringWithFormat:@""];
	
	int y = nYear;
	int m = nMonth;
	int d = nDay;
	
	string ymd1, ftv1, ymd2, ftv2;
	int y1, m1, d1, y2, m2, d2;
	Festival::DateOfBetweenFestival(y, m, d, ymd1, ftv1, ymd2, ftv2);
	sscanf(ymd1.c_str(), "%04d%02d%02d", &y1, &m1, &d1);
	sscanf(ymd2.c_str(), "%04d%02d%02d", &y2, &m2, &d2);
	
	[result appendString:[NSString stringWithFormat:@"%d.%d %@ ; ",
						  m1, d1,
						  [NSString stringWithCString: ftv1.c_str() encoding:NSUTF8StringEncoding]]
	 ]; 
	[result appendString:[NSString stringWithFormat:@"%d.%d %@ ",
						  m2, d2,
						  [NSString stringWithCString: ftv2.c_str() encoding:NSUTF8StringEncoding]]
	 ]; 

	return result;
}

//节日
//+ (void) getSelfFtv: (DateInfo) info : (FtvList&)vecSelfFtv
//{
//	vecSelfFtv.clear();
//	NSMutableArray* list=[[NSMutableArray alloc]init];
//	NSInteger y, m, d, y_nl, m_nl, d_nl;
//	y = info.year;
//	m = info.month;
//	d = info.day;
//	
//	Calendar dar;
//	DateInfo info_nl = dar.Lunar(info);
//	y_nl = info_nl.year;
//	m_nl = info_nl.month;
//	d_nl = info_nl.day;
//	
//	[[Bussiness getInstance]getSelfDateForOneDay: y: m: d: y_nl: m_nl: d_nl: list];
//	for (NSInteger i=0; i<list.count; i++) {
//		NSString* dateName = [list objectAtIndex:i];
//		std::string str = [dateName UTF8String];
//		vecSelfFtv.push_back(str);
//	}
//	
//	[list release];
//}


+ (NSString*) getJR: (int) nYear : (int) nMonth : (int) nDay
{
	DateInfo info(nYear, nMonth, nDay); 
	Calendar dar;
	
	LunarInfo lunar = dar.GetLunarInfoByYanLi(info);
	NSMutableString *result = [NSMutableString stringWithFormat:@""];
	
	lunar = dar.GetLunarInfoByYanLi(info);
	
	FtvList vecSelfFtv, vecGlFtv, vecNlFtv, vecJqFtv;
	Festival val;
	//TODO: 当前没有自定义节日
//	[AstroDBMng getSelfFtv: info: vecSelfFtv];
	val.DateOfFestival2(info, vecGlFtv, vecNlFtv, vecJqFtv);
	for (int i=0; i<vecSelfFtv.size(); i++) 
	{ 		
		[result appendString:[NSString stringWithFormat:@"%@ ",
							  [NSString stringWithCString: vecSelfFtv.at(i).c_str() encoding:NSUTF8StringEncoding]]
		 ]; 
	}	
	
	
	for (int i=0; i<vecGlFtv.size(); i++) 
	{ 		
		[result appendString:[NSString stringWithFormat:@"%@ ",
							  [NSString stringWithCString: vecGlFtv.at(i).c_str() encoding:NSUTF8StringEncoding]]
		 ]; 
	}	
	
	for (int i=0; i<vecNlFtv.size(); i++) 
	{ 		
		[result appendString:[NSString stringWithFormat:@"%@ ",
							  [NSString stringWithCString: vecNlFtv.at(i).c_str() encoding:NSUTF8StringEncoding]]
		 ]; 
	}	 
	
	return result;
}

//生肖
+ (NSString*) getSX: (int) nYear : (int) nMonth : (int) nDay
{
	Calendar dar;
	DateInfo info(nYear, nMonth, nDay);
	LunarInfo lunar = dar.GetLunarInfoByYanLi(info);	
	NSString *result = [NSString stringWithCString:lunar.shenxiao.c_str() encoding:NSUTF8StringEncoding];
	return result;
}

//星座
+ (NSString*) getXZ: (int) nYear : (int) nMonth : (int) nDay
{
	NSInteger nDate = nMonth * 100 + nDay;
	
	NSString* strStar = @"";
	
	if ((nDate >= 321) && (nDate <=419))
		strStar = @"白羊座";
	else if ((nDate >= 420) && (nDate <=520))
		strStar = @"金牛座";
	else if ((nDate >= 521) && (nDate <=621))
		strStar = LOC_STR("szz");
	else if ((nDate >= 622) && (nDate <=722))
		strStar = @"巨蟹座";
	else if ((nDate >= 723) && (nDate <=822))
		strStar = LOC_STR("sizz");
	else if ((nDate >= 823) && (nDate <=922))
		strStar = LOC_STR("cnz");
	else if ((nDate >= 923) && (nDate <=1022))
		strStar = @"天秤座";
	else if ((nDate >= 1023) && (nDate <=1122))
		strStar = LOC_STR("txz");
	else if ((nDate >= 1123) && (nDate <=1221))
		strStar = @"射手座";
	else if ((nDate >= 1222) || (nDate <=119))
		strStar = @"摩羯座";
	else if ((nDate >= 1123) && (nDate <=1221))
		strStar = @"水瓶座";
	else if ((nDate >= 219) && (nDate <=320))
		strStar = LOC_STR("syz");
	
	return strStar;
}

//冲
+ (NSString*) getC: (int) nYear : (int) nMonth : (int) nDay
{
	DateInfo info(nYear, nMonth, nDay); 
	
	NSString *sDayTgDz = [NSString stringWithCString: Calendar::GetLlGZDay(info).c_str() encoding:NSUTF8StringEncoding];
	NSString *sDayDizhi = [sDayTgDz substringFromIndex:1];
	const char *str1 = [sDayDizhi UTF8String]; 	
	int iDzIdx = Calendar::GetDiZhiIndex(str1); 
	
    if (IS_FT)
        return [NSString stringWithCString:TwelveClash_FT[(iDzIdx+18)%12].c_str() encoding:NSUTF8StringEncoding];
    else
        return [NSString stringWithCString:TwelveClash[(iDzIdx+18)%12].c_str() encoding:NSUTF8StringEncoding];
//	NSString *result = [NSString stringWithCString:TwelveClash[(iDzIdx+18)%12].c_str() encoding:NSUTF8StringEncoding];
    
    
//	return result;
}


/////////黄历查询////////////
#pragma mark -
#pragma mark 黄历查询
//宜、忌
+(BOOL) getHuangli_YJ:(NSString*)nlMonthDZ nLDay:(NSString*)dayGZ HLYi:(NSString*&)strYi HLJi:(NSString*&)strJi
{
	BOOL result = NO;
	strYi = @"";
	strJi = @"";
	NSString *sql = [[NSString alloc] initWithFormat:
					 @"select fetus,favonian,appropriate,terrible,avoid from advices where \
					 dayGZ = '%@' \
					 and code in (select code from advice where monthDz='%@') ",
					 dayGZ, nlMonthDZ];
	LOG_DEBUG(@"getHuangli_YJC2:\n%@", sql);
	
	@try 
	{
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if (!query.Eof())
		{ 
			strYi = [AstroDBMng getStringFromChar:query.GetStringField("appropriate", "")]; 			
			strJi = [AstroDBMng getStringFromChar:query.GetStringField("avoid", "")];			
		}
		query.Finalize();		
		result = YES;
	}
	@finally
	{
		[sql release];
	}
	return result;	
}

+(void) getHuangli_YJ:(int)nYear Month:(int)nMonth Day:(int)nDay HLYi:(NSString*&)strYi HLJi:(NSString*&)strJi
{	
	LOG_INFO(@"");
	DateInfo info(nYear, nMonth, nDay); 
	//NSString *month = [NSString stringWithCString: Calendar::GetLunarInfo(Calendar::Lunar(info)).monthname.c_str() encoding:NSUTF8StringEncoding];
    //农历
    DateInfo nl  = Calendar::Lunar(DateInfo(nYear, nMonth, nDay));
    
    NSString *monthDZ = [NSString stringWithCString: Calendar::GetLlGZMonth(nl).c_str() encoding:NSUTF8StringEncoding];  //改用公历,2012.9.10
    monthDZ = [monthDZ substringFromIndex:1]; //取第二个汉字  
	NSString *dayGZ = [NSString stringWithCString: Calendar::GetLlGZDay(info).c_str() encoding:NSUTF8StringEncoding];
	strYi = @"";
	strJi = @"";
	[AstroDBMng getHuangli_YJ:monthDZ nLDay:dayGZ HLYi:strYi HLJi:strJi];
	LOG_INFO(@"");
}


//宜、忌查询
+(NSArray*) findHuangli_YJ:(int)nYear Month:(int)nMonth Flag:(ESearchHuangLiOption)optHL Item:(NSString*)itemHL
{ 	
	NSMutableArray* aryHuangli = [NSMutableArray array];
	if ([PubFunction stringIsNullOrEmpty:itemHL])
	{
		return aryHuangli;
	}
	
	//遍历
	int maxDay = Calendar::GetMonthDays(nYear, nMonth);
	int nDay = 0;
	for (int i=1; i<= maxDay; i++) 
	{		
		nDay++;
		if (nDay > maxDay)
		{
			nDay = 1;
			if (nMonth<12)
			{
				nMonth ++;
			}
			else 
			{
				nMonth = 1;
				nYear ++;
			}
		}

		//查询宜忌
		NSString* strYi, *strJi;
		[AstroDBMng getHuangli_YJ:nYear Month:nMonth Day:nDay HLYi:strYi HLJi:strJi];
		if (((optHL	== ESearchHuangLi_Yi) && ([strYi rangeOfString:itemHL].location == NSNotFound)) ||
			((optHL == ESearchHuangLi_Ji) && ([strJi rangeOfString:itemHL].location == NSNotFound)) )
		{
			continue;
		}
		
		//查询冲
		NSString *strChong = [AstroDBMng getC: nYear: nMonth: nDay];
		
		//符合条件的
		THuangLiSearchResult* tResult = [[THuangLiSearchResult new] autorelease];
		[aryHuangli addObject:tResult];
		//黄历
		tResult.strYi = strYi;
		tResult.strJi = strJi;
		tResult.strChong = strChong;
		//对应的日期
		tResult.tDate = [[TDateInfo new] autorelease];
		tResult.tDate.year = nYear;
		tResult.tDate.month = nMonth;
		tResult.tDate.day = nDay;
	}
	
	return aryHuangli;
}

+(NSString*) getstrYJForFindHuangli:(ESearchHuangLiOption)optHL
{
	switch (optHL)
	{
		case ESearchHuangLi_Yi:
			return @"宜";
			
		case ESearchHuangLi_Ji:
			return @"忌";
			
		default:
			break;
	}
	
	return @"";
}

//结婚典礼查询
+(NSArray*) findHuangli_Marry:(int)nYear Month:(int)nMonth SX1:(NSString*)manSX SX2:(NSString*)womanSX
{
	NSMutableArray* aryHuangli = [NSMutableArray array];
	NSString* keyword = LOC_STR("hl_jhdl");

	int maxDay = Calendar::GetMonthDays(nYear, nMonth);
	int nDay = 0;
	for (int i=1; i<= maxDay; i++) 
	{		
		nDay ++;
		if (nDay > maxDay)
		{
			nDay = 1;
			if (nMonth<12)
			{
				nMonth ++;
			}
			else 
			{
				nMonth = 1;
				nYear ++;
			}
		}
		
		//查询宜忌
		NSString* strYi, *strJi;
		[AstroDBMng getHuangli_YJ:nYear Month:nMonth Day:nDay HLYi:strYi HLJi:strJi];
		if ([strYi rangeOfString:keyword].location == NSNotFound)
		{
			continue;
		}
		
		//查询冲
		NSString *strChong = [AstroDBMng getC: nYear: nMonth: nDay];
		if (([strChong rangeOfString:manSX].location!=NSNotFound) || ([strChong rangeOfString:womanSX].location!=NSNotFound))
		{
			continue;		
		}

		//符合条件的
		THuangLiSearchResult* tResult = [[THuangLiSearchResult new] autorelease];
		[aryHuangli addObject:tResult];

		//黄历
		tResult.strYi = strYi;
		tResult.strJi = strJi;
		tResult.strChong = strChong;
		//对应的日期
		tResult.tDate = [[TDateInfo new] autorelease];
		tResult.tDate.year = nYear;
		tResult.tDate.month = nMonth;
		tResult.tDate.day = nDay;
		
	}
	
	return aryHuangli;
}

//黄历选项查询
+(NSArray*) findHuangli_Other: (NSString*)itemHL;
{ 	
	NSMutableArray* aryHuangli = [NSMutableArray array];
	if ([PubFunction stringIsNullOrEmpty:itemHL] || [itemHL isEqual:@"/"])
	{
		return aryHuangli;
	}
	
	//TODO:保存搜索历史
//	[[Bussiness getInstance]addHistHuangItem: item];
	
	int nCurYear, nCurMonth, nCurDay;
	[PubFunction getToday:&nCurYear :&nCurMonth :&nCurDay];	

	int nYear = nCurYear;
	int nMonth = nCurMonth;
	int nFirstDay = nCurDay;
	
	int maxDay = Calendar::GetMonthDays(nCurYear, nCurMonth);
	int nDay = nFirstDay-1;
	for (int i=1; i<= maxDay; i++) 
	{		
		nDay ++;
		if (nDay > maxDay)
		{
			nDay = 1;
			if (nMonth<12)
			{
				nMonth ++;
			}
			else 
			{
				nMonth = 1;
				nYear ++;
			}
		}
        
        //还要除去非法日期，如2月30，2月等
        if ( nDay > Calendar::GetMonthDays(nYear, nMonth) ) {
            continue;
        }
		
		//查询宜忌
		NSString* strYi, *strJi;
		[AstroDBMng getHuangli_YJ:nYear Month:nMonth Day:nDay HLYi:strYi HLJi:strJi];
		if ([strYi rangeOfString:itemHL].location==NSNotFound)
			continue;
		
		//查询冲
		NSString *strChong = [AstroDBMng getC: nYear: nMonth: nDay];
		
		//符合条件的
		THuangLiSearchResult* tResult = [[THuangLiSearchResult new] autorelease];
		[aryHuangli addObject:tResult];
		
		//黄历
		tResult.strYi = strYi;
		tResult.strJi = strJi;
		tResult.strChong = strChong;
		//对应的日期
		tResult.tDate = [[TDateInfo new] autorelease];
		tResult.tDate.year = nYear;
		tResult.tDate.month = nMonth;
		tResult.tDate.day = nDay;
	}
	
	return aryHuangli;
}

#pragma mark -
#pragma mark 流日吉时

+(NSArray*)getFlowDayJS:(NSDate*)date
{
    NSMutableArray *its = nil;
    if (IS_FT)
    {
        its =[NSMutableArray arrayWithObjects:@"天牢（兇）", @"玄武（兇）", @"司命（吉）", @"勾陳（兇）", @"青龍（吉）",
              @"明堂（吉）", @"天刑（兇）", @"朱雀（兇）", @"金匱（吉）", @"天德（吉）", @"白虎（兇）", @"玉堂（吉）", nil];
    }
    else
    {
        its =[NSMutableArray arrayWithObjects:@"天牢（凶）", @"玄武（凶）", @"司命（吉）", @"勾陈（凶）", @"青龙（吉）",
              @"明堂（吉）", @"天刑（凶）", @"朱雀（凶）", @"金匮（吉）", @"天德（吉）", @"白虎（凶）", @"玉堂（吉）", nil];
       
    }
    
    DateInfo tday;
    NSInteger year,month,dayy;
    
    
	[PubFunction decodeNSDate:date :&year :&month :&dayy];
    tday.year = (int)year;
    tday.month = (int)month;
    tday.day = (int)dayy;
    
	long dayCyclical =  Calendar::LDaysFrom1900(tday);
	int iBiaoShi = (int)((dayCyclical -1) % 6);
    
    
    for (int i=iBiaoShi*2; i>0; i--)
    {
        id it = [its objectAtIndex:11];
        [its removeObjectAtIndex:11];
        [its insertObject:it atIndex:0];
    }
    
    return its;
}

    /*
	// 时辰吉凶数据
	static std::string	JiXiongResult[6][12] =
	{
		{
			"天牢（凶）",
			"玄武（凶）",
			"司命（吉）",
			"勾陈（凶）",
			"青龙（吉）",
			"明堂（吉）",
			"天刑（凶）",
			"朱雀（凶）",
			"金匮（吉）",
			"天德（吉）",
			"白虎（凶）",
			"玉堂（吉）" },
		{
			"白虎（凶）",
			"玉堂（吉）",
			"天牢（凶）",
			"玄武（凶）",
			"司命（吉）",
			"勾陈（凶）",
			"青龙（吉）",
			"明堂（吉）",
			"天刑（凶）",
			"朱雀（凶）",
			"金匮（吉）",
			"天德（吉）" },
		{
			"金匮（吉）",
			"天德（吉）",
			"白虎（凶）",
			"玉堂（吉）",
			"天牢（凶）",
			"玄武（凶）",
			"司命（吉）",
			"勾陈（凶）",
			"青龙（吉）",
			"明堂（吉）",
			"天刑（凶）",
			"朱雀（凶）" },
		{
			"天刑（凶）",
			"朱雀（凶）",
			"金匮（吉）",
			"天德（吉）",
			"白虎（凶）",
			"玉堂（吉）",
			"天牢（凶）",
			"玄武（凶）",
			"司命（吉）",
			"勾陈（凶）",
			"青龙（吉）",
			"明堂（吉）" },
		{
			"青龙（吉）",
			"明堂（吉）",
			"天刑（凶）",
			"朱雀（凶）",
			"金匮（吉）",
			"天德（吉）",
			"白虎（凶）",
			"玉堂（吉）",
			"天牢（凶）",
			"玄武（凶）",
			"司命（吉）",
			"勾陈（凶）" },
		{
			"司命（吉）",
			"勾陈（凶）",
			"青龙（吉）",
			"明堂（吉）",
			"天刑（凶）",
			"朱雀（凶）",
			"金匮（吉）",
			"天德（吉）",
			"白虎（凶）",
			"玉堂（吉）",
			"天牢（凶）",
			"玄武（凶）" } 
	};
     
     
     NSMutableArray* aryJS = [NSMutableArray array];
     for (int i = 0; i < 12; i ++)
     {
     NSString* sJS = [NSString stringWithCString:JiXiongResult[iBiaoShi][i].c_str() encoding:NSUTF8StringEncoding];
     [aryJS addObject:sJS];
     }
     return aryJS;
*/
	
	



#pragma mark -
#pragma mark 天气城市管理
//所有省
+(NSArray*) getAllProvince
{
	@try
	{
		NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"select provcode,provname from %@ order by pinyin", TBL_CUSTM1_PROV];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TCityData* cdt = [TCityData new];
			cdt.iType = ECityType_Prov;
			cdt.sID = [NSString stringWithUTF8String:query.GetStringField("provcode","")];
			cdt.sName = [NSString stringWithUTF8String:query.GetStringField("provname","")];
			[aryData addObject:cdt];
			[cdt release];
			
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询省份失败!");
		return nil;
	}
	return nil;
}

//指定省的所有地区
+(NSArray*) getAllAreasOfProv:(NSString*)provCode
{
	@try
	{
		NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"select areacode,areaname from %@ where provcode='%@' order by pinyin", TBL_CUSTM1_AREA, provCode];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TCityData* cdt = [TCityData new];
			cdt.iType = ECityType_Area;
			cdt.sID = [NSString stringWithUTF8String:query.GetStringField("areacode","")];
			cdt.sName = [NSString stringWithUTF8String:query.GetStringField("areaname","")];
			[aryData addObject:cdt];
			[cdt release];
			
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询地区失败!");
		return nil;
	}
	return nil;
}

//指定地区的所有城市
+(NSArray*) getAllCitysOfArea:(NSString*)areaCode
{
	@try
	{
		NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"select citycode,cityname from %@ where areacode='%@' order by pinyin", TBL_CUSTM1_CITY, areaCode];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TCityData* cdt = [TCityData new];
			cdt.iType = ECityType_City;
			cdt.sID = [NSString stringWithUTF8String:query.GetStringField("citycode","")];
			cdt.sName = [NSString stringWithUTF8String:query.GetStringField("cityname","")];
			[aryData addObject:cdt];
			[cdt release];
			
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询城市失败!");
		return nil;
	}
	return nil;
}

//根据输入拼音搜索城市
+(NSArray*) getAllCityByPinyin:(NSString*)pinyin
{
	@try
	{
        
		NSMutableArray* aryData = [NSMutableArray array];
		
		NSString* sql = [NSString stringWithFormat:
						 @"select distinct citycode, cityname from		\
						 ( select *, 1 as x from %@ where py like '%@%%'   \
						   union  \
						   select *, 2 as x from %@ where pinyin like '%@%%'   \
						 ) order by x",
						 TBL_CUSTM1_CITY, [PubFunction formatNSString4Sqlite:pinyin], 
						 TBL_CUSTM1_CITY, [PubFunction formatNSString4Sqlite:pinyin] ];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TCityData* cdt = [TCityData new];
			cdt.iType = ECityType_City;
			cdt.sID = [NSString stringWithUTF8String:query.GetStringField("citycode","")];
			cdt.sName = [NSString stringWithUTF8String:query.GetStringField("cityname","")];
			[aryData addObject:cdt];
			[cdt release];
			
			query.NextRow();
		}
        
        //模糊音
        if (pinyin.length<2)
            return aryData;
        
        if (![PubFunction stringContainYM:pinyin])
            return aryData;
        
        
        sql = [NSString stringWithFormat:@"SELECT citycode, cityname FROM %@ WHERE pinyin LIKE '_%%%@%%' ORDER BY pinyin;", TBL_CUSTM1_CITY, pinyin];
        
        CppSQLite3Query query1 = [[AstroDBMng getDbCustom1] execQuery:sql];
        
        int n = aryData.count;
		while (!query1.Eof()) 
		{ 
            
            NSString* citycode = [NSString stringWithUTF8String:query1.GetStringField("citycode","")];
            int i = 0;
            BOOL exist = NO;
            for (TCityData* da in aryData)
            {
                if ([da.sID isEqualToString:citycode])
                {
                    exist = YES;
                    break;
                }
                
                if (++i>=n)
                    break;
            }
            
            if (!exist)
            {
                TCityData* cdt = [TCityData new];
                cdt.iType = ECityType_City;
                cdt.sID = citycode;
                cdt.sName = [NSString stringWithUTF8String:query1.GetStringField("cityname","")];
                [aryData addObject:cdt];
                [cdt release];
            }
			
			query1.NextRow();
		}
        
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询城市失败!");
		return nil;
	}
	return nil;
}

//根据城市代码获得城市名
+(NSString*) getCityNameByCityCode:(NSString*)cityCode
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select cityname from %@ where citycode='%@'", TBL_CUSTM1_CITY, cityCode];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if ( query.Eof()) 
		{ 
			LOG_ERROR(@"未找到相应城市名!");
			return @"";
		}
		
		return [NSString stringWithUTF8String:query.GetStringField("cityname","")];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询城市失败!");
		return nil;
	}
	return nil;
}

//根据城市名称返回城市代码
+(NSArray*) getCityCodeByCityName:(NSString*)sCityName
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select citycode from %@ where cityname='%@'", TBL_CUSTM1_CITY, sCityName];
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if ( query.Eof()) 
		{ 
			LOG_ERROR(@"未找到相应城市!");
			return nil;
		}
		
		NSMutableArray* aryCityCode = [NSMutableArray array];
		while ( !query.Eof()) 
		{ 
			TCityData* cdt = [TCityData new];
			cdt.iType = ECityType_City;
			cdt.sID = [NSString stringWithUTF8String:query.GetStringField("citycode","")];
			cdt.sName = sCityName;
			[aryCityCode addObject:cdt];
			[cdt release];
			
			query.NextRow();
		}
		
		return aryCityCode;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询城市失败!");
		return nil;
	}
	return nil;
}

//根据城市代码返回省份
+(NSString*) getProvNameByCityCode:(NSString*)cityCode
{
	NSString* strProvCode = [AstroDBMng getProvCodeByCityCode:cityCode];
	if ([PubFunction stringIsNullOrEmpty:strProvCode])
	{
		LOG_ERROR(@"未找到相应省份名!");
		return @"";
	}

	@try
	{
        //add 2012.9.4
        NSString *strFirst = [cityCode substringToIndex:1];
        if ( [strFirst isEqualToString:@"2"] || [strFirst isEqualToString:@"4"] ) {
            //国外的
            NSString* strAreaCode;
            strAreaCode = [NSString stringWithFormat:@"4%@",[cityCode substringWithRange:NSMakeRange(1,3)]];
            
            NSString* sql = [NSString stringWithFormat:@"select areaname from %@ where areacode='%@'", TBL_CUSTM1_AREA, strAreaCode];
            CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
            if ( query.Eof()) 
            { 
                LOG_ERROR(@"未找到相应外国名!");
                return @"";
            }
            
            return [NSString stringWithUTF8String:query.GetStringField("areaname","")];
        }
        else {
            //国内的
            NSString* sql = [NSString stringWithFormat:@"select provname from %@ where provcode='%@'", TBL_CUSTM1_PROV, strProvCode];
            CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
            if ( query.Eof()) 
            { 
                LOG_ERROR(@"未找到相应省份名!");
                return @"";
            }
		
            return [NSString stringWithUTF8String:query.GetStringField("provname","")];
        }
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询省份失败!");
		return nil;
	}
	return nil;
}

//根据城市代码返回省份代码
+(NSString*) getProvCodeByCityCode:(NSString*)cityCode
{
	if ([PubFunction stringIsNullOrEmpty:cityCode])
	{
		LOG_ERROR(@"未找到相应省份名!");
		return @"";
	}
	if ([cityCode length] != 9)
	{
		LOG_ERROR(@"未找到相应省份名!");
		return @"";
	}
	
	NSRange rng = NSMakeRange(3, 2);	//101010100 => 第4，5位（“01”）是省份代码 
	NSString* strProvCode = [cityCode substringWithRange:rng];
	return strProvCode;
}

//根据城市名称返回城市、省份
+(NSArray*) getCityDataByCityName:(NSString*)sCityName
{
	@try
	{
		NSMutableArray* aryCityData = [NSMutableArray array];
		NSArray* aryCityCode = [AstroDBMng getCityCodeByCityName:sCityName];
		for (int i = 0; aryCityCode && i < [aryCityCode count]; i++)
		{
			TCityDataDetail* ctDetail = [[TCityDataDetail new] autorelease]; 
			//城市
			ctDetail.datCity = [aryCityCode objectAtIndex:i];
			
			//省份
			TCityData* ctProv = [[TCityData new] autorelease];
			ctDetail.datProv = ctProv;
			ctDetail.datProv.iType = ECityType_Prov;
			ctDetail.datProv.sName = [AstroDBMng getProvNameByCityCode:ctDetail.datCity.sID];
			ctDetail.datProv.sID = [AstroDBMng getProvCodeByCityCode:ctDetail.datCity.sID];
			
			[aryCityData addObject:ctDetail];
		}
		
		return aryCityData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询城市失败!");
		return nil;
	}
	return nil;
}

#pragma mark -
#pragma mark 速配
//星座速配
+(TXingZuoMatch*) getXingzuoMatch:(NSString*)manXZ :(NSString*)womanXZ
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select [sConstellationOne],[sConstellationTwo],[sScore],[sProportion],[sExplain],[sAttention]	\
						 from %@ where [sConstellationOne]='%@' and [sConstellationTwo]='%@' ", 
						 TBL_MATCH_CONSTELLATION, manXZ, womanXZ];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if ( query.Eof()) 
		{
			LOG_ERROR(@"未找到星座匹配信息!");
			return nil;
		}
		
		TXingZuoMatch* result = [TXingZuoMatch new];
		result.sManXingzuo = [NSString stringWithUTF8String:query.GetStringField("sConstellationOne", "")];
		result.sWomanXingzuo = [NSString stringWithUTF8String:query.GetStringField("sConstellationTwo", "")];
		result.iScore = [[NSString stringWithUTF8String:query.GetStringField("sScore", "")] intValue];
		result.sPropotion = [NSString stringWithUTF8String:query.GetStringField("sProportion", "")];
		result.sExplain = [NSString stringWithUTF8String:query.GetStringField("sExplain", "")];
		result.sAttention = [NSString stringWithUTF8String:query.GetStringField("sAttention", "")];
		
		return [result autorelease];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到星座匹配信息!");
		return nil;
	}
	return nil;
}

//生肖速配
+(TShengxiaoMatch*) getShengxiaoMatch:(NSString*)manSX :(NSString*)womanSX
{
	@try
	{
		NSString* sMatch = [NSString stringWithFormat:@"%@+%@", manSX, womanSX];
		NSString* sql = [NSString stringWithFormat:@"select [iLevel],[sTitle],[sContent] from %@ where [sTitle]='%@' ", 
						 TBL_MATCH_SHENGXIAO, sMatch];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if ( query.Eof()) 
		{
			LOG_ERROR(@"未找到生肖匹配信息!");
			return nil;
		}
		
		TShengxiaoMatch* result = [TShengxiaoMatch new];
		result.iLevel = query.GetIntField("iLevel", 0);
		result.sTitle = [NSString stringWithUTF8String:query.GetStringField("sTitle", "")];
		result.sContent = [NSString stringWithUTF8String:query.GetStringField("sContent", "")];
		
		return [result autorelease];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到生肖匹配信息!");
		return nil;
	}
	return nil;
}

//生肖特点
+(NSString*) getShengxiaoCharaInfo:(NSString*)sx
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select [sChara] from %@ where [sShengXiao]='%@' ", 
						 TBL_MATCH_SHENGXIAOCHARA, sx];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom1] execQuery:sql];
		if ( query.Eof()) 
		{
			LOG_ERROR(@"未找到生肖信息!");
			return nil;
		}
		
		NSString* sSxChara = [NSString stringWithUTF8String:query.GetStringField("sChara", "")];
		return sSxChara;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到生肖信息!");
		return nil;
	}
	return nil;
}

//生日速配
+(TBirthdayMatch*) getBrithdayMatch:(TDateInfo*)manGlBirthday :(TDateInfo*)womanGlBirthday
{
	return [AstroDBMng GetBirthDayQuickMathResult:manGlBirthday Woman:womanGlBirthday];
}

@end


#pragma mark -
#pragma mark 数据库管理-CUSTOM2
@implementation AstroDBMng (ForCustom2)

+(BOOL) loadDbCustom2
{
	DbItem *db = [AstroDBMng getDbCustom2];
	if (!db)
	{
		LOG_ERROR(@"数据库对象(customresult_2)不存在");
		return NO;
	}
	return [db openWithType:EDbTypeCustom2];
}


#pragma mark -
#pragma mark 抽签和掷杯
//抽签
+(int) getCastLotsNumber
{
	//生成随机数
	int nNo = [PubFunction makeRandomNumberBySeed:100];
	LOG_DEBUG(@"抽到第%d签", nNo);
	
	return nNo;
}

//签文解释
+(TCastLots*) getCastLotsDetailByNumber:(int)nNum
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where [iRandomNumber]=%d ", 
						 TBL_CUSTM2_CASTLOTS, nNum];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom2] execQuery:sql];
		if ( query.Eof()) 
		{
			LOG_ERROR(@"未找到抽签信息!");
			return nil;
		}
		
		TCastLots* result = [TCastLots new];
		result.iRandNum = query.GetIntField("iRandomNumber", 0);
		result.sNumber = [NSString stringWithUTF8String:query.GetStringField("sNumber", "")];
		result.sStandOrFall = [NSString stringWithUTF8String:query.GetStringField("sStandOrFall", "")];
		result.sStory = [NSString stringWithUTF8String:query.GetStringField("sStory", "")];
		result.sPoetry = [NSString stringWithUTF8String:query.GetStringField("sPoetry", "")];
		result.sParaphrase = [NSString stringWithUTF8String:query.GetStringField("sParaphrase", "")];
		result.sResult = [NSString stringWithUTF8String:query.GetStringField("sResult", "")];
		result.sParticularStory = [NSString stringWithUTF8String:query.GetStringField("sParticularStory", "")];
		
		return [result autorelease];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到抽签信息!");
		return nil;
	}
	return nil;
}

//掷杯
+(ERollCupResult) RollCup
{
	//生成随机数
	int nNo = [PubFunction makeRandomNumberBySeed:3];
	ERollCupResult nResult = (ERollCupResult)nNo;

	LOG_DEBUG(@"掷杯：%d", nResult);
	return nResult;
}



#pragma mark -
#pragma mark 周公解禁
+(NSArray*) getDreamGroupNames
{
	NSArray* aryGroupName = [NSArray arrayWithObjects:
							 LOC_STR("dwp"),
							 @"植物篇",
							 LOC_STR("jzp"),
							 @"器物篇",
							 LOC_STR("qap"),
							 @"人身篇",
							 @"山地篇",
							 @"神鬼篇",
							 @"生活篇",
							 @"天象篇",
							 @"文化篇",
							 @"其他篇",
							 nil];
	
	return aryGroupName;
}

+(NSArray*) getDreamItemsByGroupName:(NSString*)sGroupName
{
	if ([PubFunction stringIsNullOrEmpty:sGroupName])
	{
		LOG_ERROR(@"未找到解梦信息!");
		return nil;
	}
	
	@try
	{
		NSMutableArray* aryParseDeramResult = [NSMutableArray array];
		
		NSString* sql = [NSString stringWithFormat:@"select [sDream] from %@ where [sSort]='%@' ", 
						 TBL_CUSTM2_PARSEDREAM, 
						 sGroupName ];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom2] execQuery:sql];
		while ( !query.Eof()) 
		{
			NSString* strDream = [NSString stringWithUTF8String:query.GetStringField("sDream", "")];
			[aryParseDeramResult addObject:strDream];
			
			query.NextRow();
		}
		
		return aryParseDeramResult;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到解梦信息!");
		return nil;
	}
	return nil;
}

+(TParseDream*) getDreamParseResult:(NSString*)sDreamContent
{
	if ([PubFunction stringIsNullOrEmpty:sDreamContent])
	{
		LOG_ERROR(@"未找到解梦信息!");
		return nil;
	}
	
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where [sDream] like '%%%@%%' ", 
						 TBL_CUSTM2_PARSEDREAM, 
						 [PubFunction formatNSString4Sqlite:sDreamContent] ];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom2] execQuery:sql];
		if ( query.Eof()) 
		{
			LOG_ERROR(@"未找到解梦信息!");
			return nil;
		}
		
		TParseDream* result = [TParseDream new];
		result.sSort = [NSString stringWithUTF8String:query.GetStringField("sSort", "")];
		result.sDream = [NSString stringWithUTF8String:query.GetStringField("sDream", "")];
		result.sResult = [NSString stringWithUTF8String:query.GetStringField("sResult", "")];
		
		return [result autorelease];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到解梦信息!");
		return nil;
	}
	return nil;
}

+(NSArray*) searchDreamGroupNames:(NSString*)sInput
{
	NSMutableArray* aryDream = [NSMutableArray array];

	if ([PubFunction stringIsNullOrEmpty:sInput])
	{
		return aryDream;
	}
	
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where [sDream] like '%%%@%%' ", 
						 TBL_CUSTM2_PARSEDREAM, 
						 [PubFunction formatNSString4Sqlite:sInput] ];
		
		CppSQLite3Query query = [[AstroDBMng getDbCustom2] execQuery:sql];
		while ( !query.Eof()) 
		{
			NSString* sDream = [NSString stringWithUTF8String:query.GetStringField("sDream", "")];
			[aryDream addObject:sDream];
			
			query.NextRow();
		}
		
		return aryDream;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到梦境信息!");
		return aryDream;
	}
	return aryDream;
}

@end



#pragma mark -
#pragma mark 数据库管理-CUSTOM3
@implementation AstroDBMng (ForCustom3)

+(BOOL) loadDbCustom3
{
	DbItem *db = [AstroDBMng getDbCustom3];
	if (!db)
	{
		LOG_ERROR(@"数据库对象(customresult_3)不存在");
		return NO;
	}
	return [db openWithType:EDbTypeCustom3];
}

@end


#pragma mark -
#pragma mark 数据库管理-ASTROCOMMON
@implementation AstroDBMng (AstroCommon)

+(BOOL) loadDbAstroCommon
{
	BOOL bExist = [CommonFunc EnsureDbFileExist:EDbTypeAstroCommon UserName:@""];
	if (!bExist)
	{
		LOG_ERROR(@"数据库文件(astrocommon)不存在");
		return NO;
	}
	
	DbItem *db = [AstroDBMng getDbAstroCommon];
	if (!db)
	{
		LOG_ERROR(@"数据库对象(astrocommon)不存在");
		return NO;
	}
    
	return [db openWithType:EDbTypeAstroCommon];
}

+(BOOL) getLastLoginUser:(TLoginUserInfo*) user
{
	@try
	{
		NSString *sql = @"select * from AccountInfo order by sLoginTime desc limit 1;";
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return NO;
		}
		
		[AstroDBMng pickAccountFromQuery:user Query:&query];
		
		return YES;
		
	}
	@catch (NSException * e)
	{
		return NO;
	}
	return NO;
}

+(TLoginUserInfo*) getLoginUserBySID:(NSString*)sSID
{
	@try
	{
		NSString *sql = [NSString stringWithFormat:@"select * from AccountInfo where sSID='%@'", sSID];
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return nil;
		}
		
		TLoginUserInfo* user = [TLoginUserInfo new];
		[AstroDBMng pickAccountFromQuery:user Query:&query];
		
		return [user autorelease];
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	return nil;
}

+(TLoginUserInfo*) getLoginUserByUID:(NSString*)sUserID
{
	@try
	{
		NSString *sql = [NSString stringWithFormat:@"select * from AccountInfo where sUserID='%@'", sUserID];
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return nil;
		}
		
		TLoginUserInfo* user = [TLoginUserInfo new];
		[AstroDBMng pickAccountFromQuery:user Query:&query];
		
		return [user autorelease];
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	return nil;
}

+(int) replaceLoginUser:(TLoginUserInfo*) user
{
	if (!user)
	{
		return 0;
	}
	
	NSString* sql=@"replace into AccountInfo values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
	
	DbItem *db = [AstroDBMng getDbAstroCommon];
	CppSQLite3Statement stmt;
	if (![db pepareStatement:sql Statement:&stmt])
		return -1;

	int i = 1;
	stmt.Bind(i++, [user.sUserName UTF8String]);
	stmt.Bind(i++, [user.sPassword UTF8String]);
	stmt.Bind(i++, [user.sUserID UTF8String]);
	stmt.Bind(i++, [user.sNickName UTF8String]);
	stmt.Bind(i++, [user.sRealName UTF8String]);
	stmt.Bind(i++, [user.sUAPID UTF8String]);
	stmt.Bind(i++, [user.sSID UTF8String]);
	stmt.Bind(i++, [user.sSessionID UTF8String]);
	stmt.Bind(i++, [user.sLoginTime UTF8String]);
	stmt.Bind(i++, user.iLoginType);
	stmt.Bind(i++, user.iGroupID);
	stmt.Bind(i++, user.iAppID);
	stmt.Bind(i++, [user.sBlowfish UTF8String]);
	stmt.Bind(i++, user.iSavePasswd);
	stmt.Bind(i++, user.iAutoLogin);
	stmt.Bind(i++, [user.sSrvTbName UTF8String]);
	stmt.Bind(i++, [user.sMsg UTF8String]);
    stmt.Bind(i++, [user.sNoteUserId UTF8String]);
	stmt.Bind(i++, [user.sNoteMasterKey UTF8String]);
	stmt.Bind(i++, [user.sNoteIpLocation UTF8String]);
    
	return [db commitStatement:&stmt];
	
}

+(NSMutableArray* ) getLoginUserList
{
	NSString* sql = [NSString stringWithFormat:@"select * from %@ order by sUserName", TBL_ASTRO_ACCOUNTINFO];
	
	CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
	
	NSMutableArray *userList = [NSMutableArray array];
	while (!query.Eof()) 
	{ 
		TLoginUserInfo *user = [[TLoginUserInfo alloc] init];
		[AstroDBMng pickAccountFromQuery:user Query:&query];
		[userList addObject:user];

		[user release]; 			
		query.NextRow();
	}
	
	return userList;
}

//本地登录过的帐号数
+(int) getLoginedUserCount
{
	NSString* sql = [NSString stringWithFormat:@"select count(*) from %@;", TBL_ASTRO_ACCOUNTINFO];
	return [gDbAstroCommon execScalar:sql];
}

//删除账户
+(BOOL) deleteLoginUserByUserName:(NSString*)sUserName
{
	@try
	{
		NSString *sql = [NSString stringWithFormat:@"DELETE FROM AccountInfo where sUserName='%@'", sUserName];
		return [gDbAstroCommon execDML:sql];
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	return nil;
}



//查询结果转为数据结构
+(void) pickAccountFromQuery:(TLoginUserInfo*) user Query:(CppSQLite3Query*)query
{
	if (!user || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return;
	}

	user.sUserName = [NSString stringWithUTF8String:query->GetStringField("sUserName", "")];
	user.sPassword = [NSString stringWithUTF8String:query->GetStringField("sUserPasswd", "")];
	user.sUserID = [NSString stringWithUTF8String:query->GetStringField("sUserID", "")];
	user.sNickName = [NSString stringWithUTF8String:query->GetStringField("sNickName", "")];
	user.sRealName = [NSString stringWithUTF8String:query->GetStringField("sRealName", "")];
	user.sUAPID = [NSString stringWithUTF8String:query->GetStringField("sUAPID", "")];
	user.sSID = [NSString stringWithUTF8String:query->GetStringField("sSID", "")];
	user.sSessionID = [NSString stringWithUTF8String:query->GetStringField("sSessionID", "")];
	user.sLoginTime = [NSString stringWithUTF8String:query->GetStringField("sLoginTime", "")];
	user.iLoginType = query->GetIntField("iLoginType", 0);
	user.iGroupID = query->GetIntField("iGroupID", 0);
	user.iAppID = query->GetIntField("iAppID", 0);
	user.sBlowfish = [NSString stringWithUTF8String:query->GetStringField("sBlowfish", "")];
	user.iSavePasswd = query->GetIntField("iSavePasswd", 0);
	user.iAutoLogin = query->GetIntField("iAutoLogin", 1);
	user.sSrvTbName = [NSString stringWithUTF8String:query->GetStringField("sSrvTbName", "")];
	user.sMsg = [NSString stringWithUTF8String:query->GetStringField("sMsg", "")];
    
    user.sNoteUserId = [NSString stringWithUTF8String:query->GetStringField("sNoteUserId", "")];
    user.sNoteMasterKey = [NSString stringWithUTF8String:query->GetStringField("sNoteMasterKey", "")];
    user.sNoteIpLocation = [NSString stringWithUTF8String:query->GetStringField("sNoteIpLocation", "")];

	
}

//家园E线
//查询用户
+(TJYEXLoginUserInfo*) getJYEXLoginUserByUID:(NSString*)sUserID
{
    @try
	{
		NSString *sql = [NSString stringWithFormat:@"select * from AccountInfo where sUserID='%@'", sUserID];
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return nil;
		}
		
		TJYEXLoginUserInfo* user = [TJYEXLoginUserInfo new];
		[AstroDBMng pickJYEXAccountFromQuery:user Query:&query];
		
		return [user autorelease];
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	return nil;
}

+(TJYEXLoginUserInfo*) getJYEXLoginUserByUserName:(NSString*)sUserName
{
    @try
	{
		NSString *sql = [NSString stringWithFormat:@"select * from AccountInfo where sUserName='%@'", sUserName];
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return nil;
		}
		
		TJYEXLoginUserInfo* user = [TJYEXLoginUserInfo new];
		[AstroDBMng pickJYEXAccountFromQuery:user Query:&query];
		
		return [user autorelease];
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	return nil;
}
//更新账号
+(int) replaceJYEXLoginUser:(TJYEXLoginUserInfo*) user
{
    if (!user)
	{
		return 0;
	}
	
	NSString* sql=@"replace into AccountInfo values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
	
	DbItem *db = [AstroDBMng getDbAstroCommon];
	CppSQLite3Statement stmt;
	if (![db pepareStatement:sql Statement:&stmt])
		return -1;
    
	int i = 1;
	stmt.Bind(i++, [user.sUserName UTF8String]);
	stmt.Bind(i++, [user.sPassword UTF8String]);
	stmt.Bind(i++, [user.sUserID UTF8String]);
	stmt.Bind(i++, [user.sNickName UTF8String]);
	stmt.Bind(i++, [user.sRealName UTF8String]);
    
	stmt.Bind(i++, [user.sUAPID UTF8String]);
	stmt.Bind(i++, [user.sSID UTF8String]);
	stmt.Bind(i++, [user.sSessionID UTF8String]);
	stmt.Bind(i++, [user.sLoginTime UTF8String]);
	stmt.Bind(i++, user.iLoginType);
    
	stmt.Bind(i++, user.iGroupID);
	stmt.Bind(i++, user.iAppID);
	stmt.Bind(i++, [user.sBlowfish UTF8String]);
	stmt.Bind(i++, user.iSavePasswd);
	stmt.Bind(i++, user.iAutoLogin);
    
	stmt.Bind(i++, [user.sSrvTbName UTF8String]);
	stmt.Bind(i++, [user.sMsg UTF8String]);
    stmt.Bind(i++, [user.sNoteUserId UTF8String]);
	stmt.Bind(i++, [user.sNoteMasterKey UTF8String]);
	stmt.Bind(i++, [user.sNoteIpLocation UTF8String]);
    
    stmt.Bind(i++, [user.sEmail UTF8String]);
    stmt.Bind(i++, [user.sMobilephone UTF8String]);
    stmt.Bind(i++, [user.sTelephone UTF8String]);
    stmt.Bind(i++, [user.sAddress UTF8String]);
    stmt.Bind(i++, user.iLoginFlag );
    
    stmt.Bind(i++, user.iSchoolType);
    
	return [db commitStatement:&stmt];
}

//查询用户信息结果转为数据结构
+(void) pickJYEXAccountFromQuery:(TJYEXLoginUserInfo*) user Query:(CppSQLite3Query*)query
{
    if (!user || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return;
	}
    [AstroDBMng pickAccountFromQuery:user Query:query];
    user.sEmail = [NSString stringWithUTF8String:query->GetStringField("sEmail", "")];
    user.sMobilephone = [NSString stringWithUTF8String:query->GetStringField("sMobilephone", "")];
    user.sTelephone = [NSString stringWithUTF8String:query->GetStringField("sTelephone", "")];
    user.sAddress = [NSString stringWithUTF8String:query->GetStringField("sAddress", "")];
    user.iLoginFlag = query->GetIntField("iLoginFlag", 0);
    user.iSchoolType = query->GetIntField("iSchoolType", 0);
}

//自定义数据
+(NSString*) getSystemCfg:(NSString*)sKey Cond:(NSString*)sCondition Default:(NSString*)sDefValue
{
	NSString* sDefv = [NSString stringWithFormat:@"%@", sDefValue];
	NSString *sql = [[NSString alloc] initWithFormat:@"select [cfg_value] from %@ where [cfg_key]='%@' and [cfg_condition]='%@'",
					 TBL_CONFIG, 
					 [PubFunction formatNSString4Sqlite:sKey], 
					 [PubFunction formatNSString4Sqlite:sCondition]
					 ];
	
	NSLog(@"%@", sql);
	@try 
	{
		CppSQLite3Query query = [[AstroDBMng getDbAstroCommon] execQuery:sql];
		if (query.Eof())
		{
			return sDefv;
		}
		
		const char* defv = [sDefv cStringUsingEncoding:NSUTF8StringEncoding]; 
		if (!defv)
		{
			defv = "";
		}
		NSString* sValue = [NSString stringWithUTF8String:query.GetStringField("cfg_value", defv)];
		return sValue;
	}
	@finally
	{
		[sql release];
	}
	return sDefv;		
}

+(BOOL) setSystemCfg:(NSString*)sKey Cond:(NSString*)sCondition Value:(NSString*)sValue
{
	NSString *sql = [[NSString alloc] initWithFormat:@"replace into %@(cfg_key, cfg_condition, cfg_value) values(?,?,?)",
					 TBL_CONFIG
					 ];
	
	NSLog(@"%@", sql);
	@try 
	{
		CppSQLite3Statement stmt;
		if (![gDbAstroCommon pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新设置出错");
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [sKey UTF8String]);
		stmt.Bind(i++, [sCondition UTF8String]);	
		stmt.Bind(i++, [sValue UTF8String]);
		
		int n = [gDbAstroCommon commitStatement:&stmt];
		return n>0 ? YES : NO;
	}
	@finally
	{
		[sql release];
	}
	return NO;		
}


@end

#pragma mark-
#pragma mark 家园E线用户应用表
@implementation AstroDBMng (AppList)
+(BOOL) deleteJYEXAppListByUserName:(NSString *)sUserName
{
    if ( sUserName ) {
        @try
        {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where sUserName='%@'", TBL_APPLIST, sUserName];
            return [gDbAstroCommon execDML:sql];
            
        }
        @catch (NSException * e)
        {
            LOG_ERROR(@"删除用户 %@ 的应用记录出错!\r\n",  sUserName);
            return NO;
        }
    }
    return NO;
}

+(NSArray*) getAppListByUserName:(NSString *)sUserName
{
    @try
	{
        NSString* sql = [NSString stringWithFormat:@"select * from %@ where sUserName='%@'", TBL_APPLIST, sUserName];
		CppSQLite3Query query = [gDbAstroCommon execQuery:sql];
		
		NSMutableArray *appList = [NSMutableArray array];
		while (!query.Eof()) 
		{             
            JYEXUserAppInfo *appInfo = [JYEXUserAppInfo new];
            [AstroDBMng pickAppInfoFromQuery:appInfo Query:&query];
            [appList addObject:appInfo];
            [appInfo release];
            query.NextRow();
		}
		
		return appList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询用户 %@ 的应用列表出错!\r\n", sUserName );
		return nil;
	}
	return nil;
}

+(NSArray*) getAppListByUserName:(NSString *)sUserName AppType:(UserAppType)appType
{
    @try
	{
        NSString* sql = [NSString stringWithFormat:@"select * from %@ where sUserName='%@' AND iAppType=%d", TBL_APPLIST, sUserName, appType];
        NSLog(@"getAppList sql:%@\r\n", sql );
		CppSQLite3Query query = [gDbAstroCommon execQuery:sql];
		
		NSMutableArray *appList = [NSMutableArray array];
		while (!query.Eof()) 
		{             
            JYEXUserAppInfo *appInfo = [JYEXUserAppInfo new];
            [AstroDBMng pickAppInfoFromQuery:appInfo Query:&query];
            [appList addObject:appInfo];
            [appInfo release];
            query.NextRow();
		}
		
		return appList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询用户 %@ 的应用列表出错!\r\n", sUserName );
		return nil;
	}
	return nil;
}


+(JYEXUserAppInfo*)getAppListByUserName:(NSString *)sUserName AppCode:(NSString *)appCode
{
    @try
	{
        NSString* sql = [NSString stringWithFormat:@"select * from %@ where sUserName='%@' AND sAppCode='%@'", TBL_APPLIST, sUserName, appCode];
        NSLog(@"getAppList sql:%@\r\n", sql );
		CppSQLite3Query query = [gDbAstroCommon execQuery:sql];
		
		while (!query.Eof())
		{
            JYEXUserAppInfo *appInfo = [[JYEXUserAppInfo new] autorelease];
            [AstroDBMng pickAppInfoFromQuery:appInfo Query:&query];
            return appInfo;
		}		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询用户 %@ 的应用业务[%@]出错!\r\n", sUserName,appCode );
		return nil;
	}
	return nil;
}


+(int) insertAppListByUserName:(NSString *)sUserName AppList:(NSArray*)appList
{
    int c = 0;
    if ( !appList || ![appList count] ) {
        return c;
    }
    try {
        for (JYEXUserAppInfo* appInfo in appList ) {
            if ( appInfo ) {
                NSString* sql = [NSString stringWithFormat:@"replace into %@(sUserName,sAppCode,sAppName,iAppID,iAppType) values(?,?,?,?,?)", TBL_APPLIST];
                DbItem *db = [AstroDBMng getDbAstroCommon];
                CppSQLite3Statement stmt;
                if (![db pepareStatement:sql Statement:&stmt])
                    return c;
                int i = 1;
                stmt.Bind(i++, [appInfo.sUserName UTF8String]);
                stmt.Bind(i++, [appInfo.sAppCode UTF8String]);
                stmt.Bind(i++, [appInfo.sAppName UTF8String]);
                stmt.Bind(i++, appInfo.iAppID);
                stmt.Bind(i++, appInfo.iAppType);
                [db commitStatement:&stmt];
                ++c;
            }
        }
    } catch (NSException * e) {
        LOG_ERROR(@"插入用户应用记录出错!");
        return c;
    }
    return c;
}

+(BOOL) pickAppInfoFromQuery:(JYEXUserAppInfo*) appInfo Query:(CppSQLite3Query*)query
{
	if (!appInfo || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof())
	{
		return NO;
	}
	
    appInfo.sUserName = [NSString stringWithUTF8String:query->GetStringField("sUserName", "")];
    appInfo.sAppCode = [NSString stringWithUTF8String:query->GetStringField("sAppCode", "")];
    appInfo.sAppName = [NSString stringWithUTF8String:query->GetStringField("sAppName", "")];
    appInfo.iAppID = query->GetIntField("iAppID", 0);
    appInfo.iAppType = query->GetIntField("iAppType", 0);
	return YES;
}	

+(NSArray*) getLanmuList
{
    @try
	{
        NSString* sql = [NSString stringWithFormat:@"select * from %@", TB_LANMU_LIST];
        NSLog(@"getLanmuList sql:%@\r\n", sql );
		CppSQLite3Query query = [gDb91Note execQuery:sql];
		
		NSMutableArray *lanmuList = [NSMutableArray array];
		while (!query.Eof()) 
		{             
            TJYEXLanmu *lanmuInfo = [TJYEXLanmu new];
            [AstroDBMng pickLanmuInfoFromQuery:lanmuInfo Query:&query];
            [lanmuList addObject:lanmuInfo];
            [lanmuInfo release];
            query.NextRow();
		}
		
		return lanmuList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询栏目表出错!\r\n");
		return nil;
	}
	return nil;
}

+(BOOL) pickLanmuInfoFromQuery:(TJYEXLanmu*) lanmuInfo Query:(CppSQLite3Query*)query
{
    if (!lanmuInfo || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof())
	{
		return NO;
	}
	
    lanmuInfo.sLanmuName = [NSString stringWithUTF8String:query->GetStringField("sLanmuName", "")];
	return YES;
}
+(BOOL) cleanLanmuList
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"delete from %@", TB_LANMU_LIST];
		[[AstroDBMng getDb91Note] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除栏目表记录!");
		return NO;
	}
	return NO;
}

+(int) insertLanmuListByUserName:(NSArray*)lanmuList
{
    int c = 0;
    if ( !lanmuList || ![lanmuList count] ) {
        return c;
    }
    try {
        for (TJYEXLanmu* lanmuInfo in lanmuList ) {
            if ( lanmuInfo ) {
                NSString* sql = [NSString stringWithFormat:@"replace into %@(sLanmuName) values(?)", TB_LANMU_LIST];
                DbItem *db = [AstroDBMng getDb91Note];
                CppSQLite3Statement stmt;
                if (![db pepareStatement:sql Statement:&stmt])
                    return c;
                int i = 1;
                stmt.Bind(i++, [lanmuInfo.sLanmuName UTF8String]);
                [db commitStatement:&stmt];
                ++c;
            }
        }
    } catch (NSException * e) {
        LOG_ERROR(@"插入栏目记录出错!");
        return c;
    }
    return c;
}

+(BOOL) pickClassInfoFromQuery:(TJYEXClass*) classInfo Query:(CppSQLite3Query*)query
{
    if (!classInfo || !classInfo)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof())
	{
		return NO;
	}
	
    classInfo.sClassId = [NSString stringWithUTF8String:query->GetStringField("sClassId", "")];
    classInfo.sClassName = [NSString stringWithUTF8String:query->GetStringField("sClassName", "")];
	return YES;
}

+(NSArray*) getClassList
{
    @try
	{
        NSString* sql = [NSString stringWithFormat:@"select * from %@", TB_CLASS_INFO];
        NSLog(@"getClassList sql:%@\r\n", sql );
		CppSQLite3Query query = [gDb91Note execQuery:sql];
		
		NSMutableArray *classList = [NSMutableArray array];
		while (!query.Eof()) 
		{             
            TJYEXClass *classInfo = [TJYEXClass new];
            [AstroDBMng pickClassInfoFromQuery:classInfo Query:&query];
            [classList addObject:classInfo];
            [classInfo release];
            query.NextRow();
		}
		
		return classList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询班级表出错!\r\n");
		return nil;
	}
	return nil;
}

+(BOOL) cleanClassList
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"delete from %@", TB_CLASS_INFO];
		[[AstroDBMng getDb91Note] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除班级表记录!");
		return NO;
	}
	return NO;
}

+(int) insertClassListByUserName:(NSArray*)classList
{
    int c = 0;
    if ( !classList || ![classList count] ) {
        return c;
    }
    try {
        for (TJYEXClass* classInfo in classList ) {
            if ( classInfo ) {
                NSString* sql = [NSString stringWithFormat:@"replace into %@(sClassId,sClassName) values(?,?)", TB_CLASS_INFO];
                DbItem *db = [AstroDBMng getDb91Note];
                CppSQLite3Statement stmt;
                if (![db pepareStatement:sql Statement:&stmt])
                    return c;
                int i = 1;
                stmt.Bind(i++, [classInfo.sClassId UTF8String]);
                stmt.Bind(i++, [classInfo.sClassName UTF8String]);
                [db commitStatement:&stmt];
                ++c;
            }
        }
    } catch (NSException * e) {
        LOG_ERROR(@"插入班级记录出错!");
        return c;
    }
    return c;
}
@end

#pragma mark -
#pragma mark 数据库管理-USERLOCAL
@implementation AstroDBMng (ForUserLocal)

+(BOOL) loadDbUserLocal
{
	return [AstroDBMng loadDbUserLocal:TheCurUser.sUserName];
}

+(BOOL) loadDbUserLocal:(NSString*) userName
{
	BOOL bExist = [CommonFunc EnsureDbFileExist:EDbTypeUserLocal UserName:userName];
	if (!bExist)
	{
		LOG_ERROR(@"数据库文件(userlocal)不存在。 username=%@", userName);
		return NO;
	}
	
	DbItem *dbuser = [AstroDBMng getDbUserLocal];
	if (!dbuser)
	{
		LOG_ERROR(@"数据库对象(astrocommon)不存在。 username=%@", userName);
		return NO;
	}
	
	BOOL bOpened = [dbuser openWithType:EDbTypeUserLocal];
	LOG_INFO(@"加载用户数据库. username=%@,  result=%d", userName, bOpened);
	return bOpened;
}


+(BOOL) CloseDbUserLocal	//关闭
{
	return [[AstroDBMng getDbUserLocal] close];
}


//创建并加载缺省帐号（uapsmuser:uapsmuser）数据
+(BOOL) loadDefaultUserData
{
	return [AstroDBMng loadDbUserLocal:CS_DEFAULTACCOUNT_USERNAME];
}

//切换缺省帐号到登录帐号
/*
+(BOOL) switchDefaultUserToRegUser:(NSString*) regUserName
{
	//源帐号目录
	NSString* fromPath = [CommonFunc getDbFilePathBy:EDbTypeUserLocal UserName:CS_DEFAULTACCOUNT_USERNAME];
	if ( [PubFunction stringIsNullOrEmpty:fromPath])
	{
		LOG_ERROR(@"缺省帐号目录错误！");
		return NO;
	}
	if (![CommonFunc isFileExisted:fromPath])
	{
		LOG_ERROR(@"缺省帐号目录不存在！");
		return NO;
	}	
	
	//目标帐号目录
	NSString* toPath = [CommonFunc getDbFilePathBy:EDbTypeUserLocal UserName:regUserName];
	if ( [PubFunction stringIsNullOrEmpty:toPath])
	{
		LOG_ERROR(@"目标帐号目录错误！");
		return NO;
	}
	
	if ([CommonFunc isFileExisted:toPath])
	{
		LOG_ERROR(@"目标帐号已经存在！");
		return NO;
	}	
	
	//先保证关闭缺省帐号数据库
	BOOL bIsOpen = [gDbUserLocal isOpen];
	if (bIsOpen)
	{
		if ( ![AstroDBMng CloseDbUserLocal] )
		{
			LOG_ERROR(@"缺省数据库关闭失败！");
			return NO;
		}
	}
	
	//缺省帐号改名为登录帐号目录
	NSError* err = nil;
	BOOL bSucc = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&err];
	//如果上次打开了数据库，则修改目录后再重新打开
	if (bIsOpen && bSucc)
	{
		return [AstroDBMng loadDbUserLocal:regUserName];
	}
	else
	{
		return NO;
	}
	
}
*/


/*
+(BOOL) switchUserDB:(NSString*)sNewUser
{
	//先保证关闭缺省帐号数据库
	BOOL bIsOpen = [gDbUserLocal isOpen];
	if (bIsOpen)
	{
		if ( ![AstroDBMng CloseDbUserLocal] )
		{
			LOG_ERROR(@"数据库关闭失败！");
			return NO;
		}
	}
	
	//再打开新登录用户数据库
	BOOL rtn = [AstroDBMng loadDbUserLocal:sNewUser];
    if (rtn==NO)
        return NO;
    
    return [AstroDBMng UpdateUserDataTable];
}
*/ 

+(BOOL) getHostPeopleInfo:(TPeopleInfo*)pep
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where bIsHost=1 and iDataOpt!=%d;", TBL_USR_PEPOINFO, EPEPL_OPT_DEL];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickPeopleFromQuery:pep Query:&query];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询主命造失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) pickPeopleFromQuery:(TPeopleInfo*) pep Query:(CppSQLite3Query*)query
{
	if (!pep || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof())
	{
		return NO;
	}
	
	pep.ipeopleId = query->GetIntField("ipeopleId", 0);
	pep.sGuid = [NSString stringWithUTF8String:query->GetStringField("sGuid", "")];
	pep.sPersonName = [NSString stringWithUTF8String:query->GetStringField("sPersonName", "")];
	pep.sPersonTitle = [NSString stringWithUTF8String:query->GetStringField("sPersonTitle", "")];
	pep.sSex = [NSString stringWithUTF8String:query->GetStringField("sSex", "")];
	pep.sBirthplace = [NSString stringWithUTF8String:query->GetStringField("sBirthplace", "")];
	pep.bIsHost = query->GetIntField("bIsHost", 0);
	pep.iYear = query->GetIntField("iYear", 0);
	pep.iMonth = query->GetIntField("iMonth", 0);
	pep.iDay = query->GetIntField("iDay", 0);
	pep.iHour = query->GetIntField("iHour", 0);
	pep.iMinute = query->GetIntField("iMinute", 0);
	pep.iLlYear = query->GetIntField("iLlYear", 0);
	pep.iLlDay = query->GetIntField("iLlDay", 0);
	pep.iLlMonth = query->GetIntField("iLlMonth", 0);
	pep.sLlHour = [NSString stringWithUTF8String:query->GetStringField("sLlHour", "")];
	pep.bLeap = query->GetIntField("bLeap", 0);
	pep.sTimeZone = [NSString stringWithUTF8String:query->GetStringField("sTimeZone", "")];
	pep.sWdZone = [NSString stringWithUTF8String:query->GetStringField("sWdZone", "")];
	pep.iLongitude = query->GetIntField("iLongitude", 0);
	pep.iLongitude_ex = query->GetIntField("iLongitude_ex", 0);
	pep.iLatitude = query->GetIntField("iLatitude", 0);
	pep.iLatitude_ex = query->GetIntField("iLatitude_ex", 0);
	pep.iTimeZone = query->GetIntField("iTimeZone", 0);
	pep.iDifRealTime = query->GetIntField("iDifRealTime", 0);
	pep.sSaveUserInput = [NSString stringWithUTF8String:query->GetStringField("sSaveUserInput", "")];
	pep.iGroupId = query->GetIntField("iGroupId", 0);
	pep.sHeadImg = [NSString stringWithUTF8String:query->GetStringField("sHeadImg", "")];
	pep.sUid = [NSString stringWithUTF8String:query->GetStringField("sUid", "")];
	pep.iDataOpt = query->GetIntField("iDataOpt", 0);
	pep.iVersion = query->GetIntField("iVersion", 0);
	pep.bSynced = query->GetIntField("bSync", 0);
	
	return YES;
}	

+(int)setHostPeople:(NSString*) sGuid Host:(BOOL)bHost
{
	@try
	{
		int isHost = bHost ? 1 : 0;
		NSString* sql = [NSString stringWithFormat:@"update %@ set bIsHost=%d where sGuid='%@';", TBL_USR_PEPOINFO, isHost, sGuid];
		return [[AstroDBMng getDbUserLocal] execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"设置主命造失败!");
		return -1;
	}
	
	return 0;
}

+(TPeopleInfo*) getDemoPeople
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt=%d;", TBL_USR_PEPOINFO, EPEPL_OPT_DEMO];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		//TPeopleInfo *pep = [TPeopleInfo new];
		//[AstroDBMng pickPeopleFromQuery:pep Query:&query];
		//return [pep autorelease];
        
        //因为DEMO命造都放在同一个库，增加简体繁体的区别
        TPeopleInfo *pep = [TPeopleInfo new];
		[AstroDBMng pickPeopleFromQuery:pep Query:&query];
        
        query.NextRow();
        if (!query.Eof()) 
		{ 
			TPeopleInfo *pep1 = [TPeopleInfo new];
			if ( [AstroDBMng pickPeopleFromQuery:pep1 Query:&query] ) //如果存在两个
            {
                if (IS_FT ) {  //需要繁体
                    if ( [pep->sPersonName isEqualToString:@"张三"] ) {
                        [pep release];
                        return [pep1 autorelease];
                    }
                    else {
                        [pep1 release];
                        return [pep autorelease];
                    }
                }
                else { //需要简体
                    if ( [pep->sPersonName isEqualToString:@"张三"] ) {
                        [pep1 release];
                        return [pep autorelease];
                    }
                    else {
                        [pep release];
                        return [pep1 autorelease];
                    }
                }
            }
		}
        return [pep autorelease];
        //--------------
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询演示命造失败!");
		return nil;
	}
	
	return nil;
}

+(TPeopleInfo*) getPeopleInfoBysGUID:(NSString*) sGuid
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@'", TBL_USR_PEPOINFO, sGuid];
		LOG_DEBUG(@"SQL = %@", sql);
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		if (query.Eof())
		{
			return nil;
		}
		
		TPeopleInfo *pep = [TPeopleInfo new];
		[AstroDBMng pickPeopleFromQuery:pep Query:&query];
		return [pep autorelease];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造失败!");
		return nil;
	}
	return nil;
}

+(TPeopleInfo*) getPeopleInfoByGUID:(GUID&) guid
{
    //2015.2.13
	std::string str = "11111";//GUID2STR(guid);
	NSString* sguid = [NSString stringWithCString:str.c_str() encoding:NSASCIIStringEncoding];
	return [AstroDBMng getPeopleInfoBysGUID:sguid];
}


+(NSMutableArray*) getBeShownPeopleInfoList
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt!=%d;", TBL_USR_PEPOINFO, EPEPL_OPT_DEL];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		NSMutableArray *pepList = [NSMutableArray array];
		while (!query.Eof()) 
		{ 
			TPeopleInfo *pep = [TPeopleInfo new];
			[AstroDBMng pickPeopleFromQuery:pep Query:&query];
			[pepList addObject:pep];
			[pep release];
			query.NextRow();
		}
		
		return pepList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return nil;
	}
	return nil;
}

//将要同步的命造列表：不包括演示数据
+(NSMutableArray*) getBeSyncdPeopleInfoList
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt!=%d and bSync=0;", TBL_USR_PEPOINFO, EPEPL_OPT_DEMO];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		NSMutableArray *pepList = [NSMutableArray array];
		while (!query.Eof()) 
		{ 
			TPeopleInfo *pep = [TPeopleInfo new];
			[AstroDBMng pickPeopleFromQuery:pep Query:&query];
			[pepList addObject:pep];
			[pep release];
			query.NextRow();
		}
		
		return pepList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return nil;
	}
	return nil;
}

+(int) getBeSyncdPeopleCount
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where iDataOpt!=%d and bSync=0;", TBL_USR_PEPOINFO, EPEPL_OPT_DEMO];
		return [[AstroDBMng getDbUserLocal] execScalar:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return -1;
	}
	return -1;
}

//全部非演示命造
+(NSMutableArray*) getAllPeopleInfoList
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt!=%d;", TBL_USR_PEPOINFO, EPEPL_OPT_DEMO];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		NSMutableArray *pepList = [NSMutableArray array];
		while (!query.Eof()) 
		{ 
			TPeopleInfo *pep = [TPeopleInfo new];
			[AstroDBMng pickPeopleFromQuery:pep Query:&query];
			[pepList addObject:pep];
			[pep release];
			query.NextRow();
		}
		return pepList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return nil;
	}
	return nil;
}

+(int) getAllPeopleInfoCount
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where iDataOpt!=%d;", TBL_USR_PEPOINFO, EPEPL_OPT_DEMO];
        
		return [[AstroDBMng getDbUserLocal] execScalar:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return -1;
	}
	return -1;
}

//全部非演示的可显示命造
+(NSMutableArray*) getAllRealPeopleList
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt!=%d and iDataOpt!=%d;", 
						 TBL_USR_PEPOINFO, EPEPL_OPT_DEMO, EPEPL_OPT_DEL];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		NSMutableArray *pepList = [NSMutableArray array];
		while (!query.Eof()) 
		{ 
			TPeopleInfo *pep = [TPeopleInfo new];
			[AstroDBMng pickPeopleFromQuery:pep Query:&query];
			[pepList addObject:pep];
			[pep release];
			query.NextRow();
		}
        
		return pepList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return nil;
	}
	return nil;
}

+(int) getAllRealPeopleCount
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where iDataOpt!=%d and iDataOpt!=%d;", 
						 TBL_USR_PEPOINFO, EPEPL_OPT_DEMO, EPEPL_OPT_DEL];
        
		return [[AstroDBMng getDbUserLocal] execScalar:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造列表失败!");
		return -1;
	}
	return -1;
}

+(int) updatePeopleInfo:(TPeopleInfo*) pepInfo
{
	pepInfo.bSynced = 0;	//未同步
	pepInfo.iVersion = [AstroDBMng getLocalSyncVer] + 1;	//版本号

	return [AstroDBMng synUpdatePeopleInfo:pepInfo];
}


+(BOOL) removePopleInfoBysGUID:(NSString*) sGuid
{
	@try
	{
		int xver = [AstroDBMng getLocalSyncVer] + 1;	//版本号
		
		NSString* sql = [NSString stringWithFormat:@"update %@ set iDataOpt=%d,bSync=0,iVersion=%d where sGuid='%@'", 
						 TBL_USR_PEPOINFO, EPEPL_OPT_DEL, xver, sGuid];
		[[AstroDBMng getDbUserLocal] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除命造失败!");
		return NO;
	}
	return NO;
}


+(BOOL) clearPopleBysGUID:(NSString*) sGuid
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where sGuid='%@'", TBL_USR_PEPOINFO, sGuid];
		[[AstroDBMng getDbUserLocal] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除命造失败!");
		return NO;
	}
	return NO;
}

+(BOOL) addNewPeople:(TPeopleInfo*) userInfo
{
	return [AstroDBMng updatePeopleInfo:userInfo] > 0 ? YES : NO;
}

+(BOOL) setPeolpeSynced:(NSString*)sGuid SynFlag:(int)iSynced
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update %@ set bSync=%d where sGuid='%@'", TBL_USR_PEPOINFO, iSynced, sGuid];
		[[AstroDBMng getDbUserLocal] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除命造失败!");
		return NO;
	}
	return NO;
}


+(BOOL) setAllPeopleSynced
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update %@ set bSync=1 where bSync!=1", TBL_USR_PEPOINFO];
		[[AstroDBMng getDbUserLocal] execDML:sql];
        
        //add 2012.8.20,要把所有add标志改为update标识
        sql = [NSString stringWithFormat:@"update %@ set iDataOpt=%d where iDataOpt=%d",
               TBL_USR_PEPOINFO, EPEPL_OPT_MOD, EPEPL_OPT_ADD];
		[[AstroDBMng getDbUserLocal] execDML:sql];
        
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"同步标记设置失败!");
		return NO;
	}
	return NO;
}

+(int) synUpdatePeopleInfo:(TPeopleInfo*) pepInfo
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"replace into %@"
						 "( [iPeopleId],"
						 "[sGuid], "
						 "[sPersonName], "
						 "[sPersonTitle], "
						 "[sSex], "
						 "[sBirthplace], "
						 "[bIsHost], "
						 "[iYear], "
						 "[iMonth], "
						 "[iDay], "
						 "[iHour], "
						 "[iMinute], "
						 "[iLlYear], "
						 "[iLlDay], "
						 "[iLlMonth], "
						 "[sLlHour], "
						 "[bLeap], "
						 "[sTimeZone], "
						 "[sWdZone], "
						 "[iLongitude], "
						 "[iLongitude_ex], "
						 "[iLatitude], "
						 "[iLatitude_ex], "
						 "[iTimeZone], "
						 "[iDifRealTime], "
						 "[sSaveUserInput], "
						 "[iGroupId], "
						 "[sHeadImg], "
						 "[sUid], "
						 "[iDataOpt], "
						 "[iVersion], "
						 "[bSync] )"
						 "values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);",
						 TBL_USR_PEPOINFO];
		
		DbItem *db = [AstroDBMng getDbUserLocal];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新命造信息出错");
			return -1;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);		//(i++, pepInfo.ipeopleId);
		stmt.Bind(i++, [pepInfo.sGuid UTF8String]);
		stmt.Bind(i++, [pepInfo.sPersonName UTF8String]);
		stmt.Bind(i++, [pepInfo.sPersonTitle UTF8String]);
		stmt.Bind(i++, [pepInfo.sSex UTF8String]);
		stmt.Bind(i++, [pepInfo.sBirthplace UTF8String]);
		stmt.Bind(i++, pepInfo.bIsHost);
		stmt.Bind(i++, pepInfo.iYear);
		stmt.Bind(i++, pepInfo.iMonth);
		stmt.Bind(i++, pepInfo.iDay);
		stmt.Bind(i++, pepInfo.iHour);
		stmt.Bind(i++, pepInfo.iMinute);
		stmt.Bind(i++, pepInfo.iLlYear);
		stmt.Bind(i++, pepInfo.iLlDay);
		stmt.Bind(i++, pepInfo.iLlMonth);
		stmt.Bind(i++, [pepInfo.sLlHour UTF8String]);
		stmt.Bind(i++, pepInfo.bLeap);
		stmt.Bind(i++, [pepInfo.sTimeZone UTF8String]);
		stmt.Bind(i++, [pepInfo.sWdZone UTF8String]);
		stmt.Bind(i++, pepInfo.iLongitude);
		stmt.Bind(i++, pepInfo.iLongitude_ex);
		stmt.Bind(i++, pepInfo.iLatitude);
		stmt.Bind(i++, pepInfo.iLatitude_ex);
		stmt.Bind(i++, pepInfo.iTimeZone);
		stmt.Bind(i++, pepInfo.iDifRealTime);
		stmt.Bind(i++, [pepInfo.sSaveUserInput UTF8String]);
		stmt.Bind(i++, pepInfo.iGroupId);
		stmt.Bind(i++, [pepInfo.sHeadImg UTF8String]);
		stmt.Bind(i++, [pepInfo.sUid UTF8String]);
		stmt.Bind(i++, pepInfo.iDataOpt);
		stmt.Bind(i++, pepInfo.iVersion);
		stmt.Bind(i++, pepInfo.bSynced);
		
		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新命造信息出错");
		return -1;
	}
	return -1;
}

+(BOOL) synRemovePopleInfoBysGUID:(NSString*) sGuid
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update %@ set iDataOpt=%d where sGuid='%@'", TBL_USR_PEPOINFO, EPEPL_OPT_DEL, sGuid];
		[[AstroDBMng getDbUserLocal] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除命造失败!");
		return NO;
	}
	return NO;
}

+(BOOL) synAddNewPeople:(TPeopleInfo*) pepInfo
{
	return [AstroDBMng synUpdatePeopleInfo:pepInfo] > 0 ? YES : NO;
}

+(NSMutableArray*) getHostPeopleList
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where bIsHost=1", TBL_USR_PEPOINFO];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		NSMutableArray *pepList = [NSMutableArray array];
		while (!query.Eof()) 
		{ 
			TPeopleInfo *pep = [TPeopleInfo new];
			[AstroDBMng pickPeopleFromQuery:pep Query:&query];
			[pepList addObject:pep];
			[pep release];
			query.NextRow();
		}
		
		return pepList;
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询主命造列表失败!");
		return nil;
	}
	return nil;
}

//第1条非删除非演示命造
+(TPeopleInfo*) getFirstUnDelPeople
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iDataOpt!=%d and iDataOpt!=%d limit 1", TBL_USR_PEPOINFO, EPEPL_OPT_DEL, EPEPL_OPT_DEMO];
		LOG_DEBUG(@"SQL = %@", sql);
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		if (query.Eof() )
			return nil;
		
		TPeopleInfo *pep = [TPeopleInfo new];
		[AstroDBMng pickPeopleFromQuery:pep Query:&query];
		return [pep autorelease];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询命造失败!");
		return nil;
	}
	return nil;
}

#pragma mark -
//自定义数据

+(NSString*) getUserCfg:(NSString*)sItem Cond:(NSString*)sCondition Default:(NSString*)sDefVal
{
	NSString* sDefv = [NSString stringWithFormat:@"%@", sDefVal];
	NSString *sql = [[NSString alloc] initWithFormat:@"select [cfg_value] from %@ where [cfg_key]='%@' and [cfg_condition]='%@'",
					 TBL_CONFIG, 
					 [PubFunction formatNSString4Sqlite:sItem], 
					 [PubFunction formatNSString4Sqlite:sCondition]
					 ];
	
	NSLog(@"%@", sql);
	@try 
	{
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		if (query.Eof())
		{
			return sDefv;
		}
		
		const char* defv = [sDefv cStringUsingEncoding:NSUTF8StringEncoding]; 
		if (!defv)
		{
			defv = "";
		}
		NSString* sValue = [NSString stringWithUTF8String:query.GetStringField("cfg_value", defv)];
		return sValue;
	}
	@finally
	{
		[sql release];
	}
	return sDefv;		
}

+(BOOL) setUserCfg:(NSString*)sItem Cond:(NSString*)sCondition Val:(NSString*)sValue
{
	NSString *sql = [[NSString alloc] initWithFormat:@"replace into %@(cfg_key, cfg_condition, cfg_value) values(?,?,?)",
					 TBL_CONFIG
					 ];
	
	NSLog(@"%@", sql);
	@try 
	{
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新设置出错");
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [sItem UTF8String]);
		stmt.Bind(i++, [sCondition UTF8String]);	
		stmt.Bind(i++, [sValue UTF8String]);
		
		int n = [gDbUserLocal commitStatement:&stmt];
		return n>0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新设置出错!");
		return nil;
	}
//	@catch (CppSQLite3Exception *e)
//	{
//		LOG_ERROR(@"更新设置出错: reseason=%@!", [NSString stringWithUTF8String:e->ErrorMessage()]);
//		return nil;
//	}
	@finally
	{
		[sql release];
	}
	return NO;		
}


//同步日志标识
+(int) getLocalSyncVer
{
	NSString* strVer = [AstroDBMng getUserCfg:LDGT_SYNVER Cond:@"" Default:@""];
	if (![PubFunction stringIsNullOrEmpty:strVer])
	{
		return [strVer intValue];
	}
	else
	{
		return 0;
	}

}

+(void) setLocalSynVer:(int)iNewVer
{
	[AstroDBMng setUserCfg:LDGT_SYNVER Cond:@"" Val:[NSString stringWithFormat:@"%d", iNewVer]];
}


//微博分享
+(BOOL) hasBlogSharedToday
{
	NSString* strVal = [AstroDBMng getUserCfg:LDGT_BLOGSHARE Cond:[PubFunction getTodayStr] Default:@"0"];
	if (![PubFunction stringIsNullOrEmpty:strVal])
	{
		return NO;
	}
	
	if ([strVal isEqualToString:@"1"])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+(void) setBlogSharedFlag
{
	NSString* sToday = [PubFunction getTodayStr];
	[AstroDBMng setUserCfg:LDGT_BLOGSHARE Cond:sToday Val:@"1"];
}

+(NSString*) getBlogContent
{
	//再添加新数据
	NSString* sql = [[NSString alloc] initWithFormat:@"select * from %@ where groupkey='%@' ", TBL_USR_LOCALDATA, LDGT_BLOG];
	NSLog(@"%@", sql);
	
	TUserLocalData* localData = [TUserLocalData new];
	@try 
	{
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询BLOG内容出错!");
			return nil;
		}
		
		[AstroDBMng pickLocalDataFromQuery:localData Query:&query];
		NSString* strContent = [localData.sItemText copy];
		return strContent;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询BLOG内容出错!");
		return nil;
	}
	@finally
	{
		[sql release];
		[localData release];
	}
	return nil;		
}

+(BOOL) updateBlogContent:(NSString*)sContent
{
	
	@try
	{
		//先删除
		[AstroDBMng removeBlogContent];
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新BLOG内容出错!");
			return NO;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_BLOG UTF8String]);	//groupkey
		stmt.Bind(i++, "");		//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, "");		//itemcode
		stmt.Bind(i++, "");		//itemvalue
		stmt.Bind(i++, "");		//itemnote
		stmt.Bind(i++, [sContent UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新BLOG内容出错!");
		return NO;
	}
	
	return NO;
}

+(BOOL) removeBlogContent
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@'", 
						 TBL_USR_LOCALDATA, LDGT_BLOG];
		
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除BLOG内容出错!");
		return NO;
	}
	
	return NO;
}


#pragma mark -
//皮肤
+(NSString*) getSkinImage
{
	//根据91算命UI样式,修改UI样式. {
	//old:
//	NSString* sImg = @"001.jpg";
	//new:
	NSString* sImg = @"main_bk.jpg";
	//}
	NSString* sGrpItem = @"SkinImage";
	NSString *sql = [[NSString alloc] initWithFormat:
					 @"select * from %@ where groupkey='%@' and groupitem='%@' ",
					 TBL_USR_LOCALDATA, LDGT_USER, sGrpItem];
	NSLog(@"getSkinImage:\n%@", sql);
	@try
	{
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (!query.Eof()) 
		{
			sImg = [AstroDBMng getStringFromChar:query.GetStringField("itemvalue", "")];  
		}
		else 
		{
			NSString *sql2 = [NSString stringWithFormat:@"insert into %@(groupkey, groupitem, itemno, itemcode, itemvalue) "
							  "values('%@', '%@', '0', '', '%@') ",
							  TBL_USR_LOCALDATA, LDGT_USER, sGrpItem, sImg];
			[gDbUserLocal execDML: sql2];
		} 
	}
	@finally
	{
		[sql release];
	}
	return sImg;	
}


+(BOOL) getShowOldbak
{
	BOOL bResult = NO;
	NSString* sGrpItem = @"Oldbak";
	NSString *sql = [[NSString alloc] initWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' ",
					 TBL_USR_LOCALDATA, LDGT_USER, sGrpItem];

	@try 
	{
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (!query.Eof()) 
		{
			NSString *obj = [self getStringFromChar:query.GetStringField("itemvalue", "0")]; 
			bResult = ([obj intValue] == 1); 
		}
		else
		{
			NSString *sql2 = [NSString stringWithFormat:@"insert into %@(groupkey, groupitem, itemno, itemcode, itemvalue) "
							  "values('%@', '%@', '0', '', '0') ",
							  TBL_USR_LOCALDATA, LDGT_USER, sGrpItem];
			[gDbUserLocal execDML:sql2];
		} 
	}
	@finally 
	{
		[sql release];
	}
	return bResult;		
}

+(BOOL) setShowOldbak: (BOOL)isShow
{
	NSInteger itemValue = 0;
	if (isShow)
		itemValue = 1;
	
	NSString* sGrpItem = @"Oldbak";
	NSString *sql = [NSString stringWithFormat:@"update %@ set itemvalue='%d' where groupkey='%@' and groupitem='%@' ", 
					 TBL_USR_LOCALDATA, (int)itemValue, LDGT_USER, sGrpItem];
	return [gDbUserLocal execDML:sql];
}



#pragma mark -
////////本地请求数据缓存相关/////////////

+(BOOL) pickLocalDataFromQuery:(TUserLocalData*)localData Query:(CppSQLite3Query*)query
{
	if (!localData || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	localData.iID = query->GetIntField("ID", 0);
	localData.sGroupKey = [NSString stringWithUTF8String:query->GetStringField("groupkey", "")];
	localData.sGroupItem = [NSString stringWithUTF8String:query->GetStringField("groupitem", "")]; 
	localData.iItemNo = query->GetIntField("itemno", 0);
	localData.sItemCode = [NSString stringWithUTF8String:query->GetStringField("itemcode", "")];
	localData.sItemValue = [NSString stringWithUTF8String:query->GetStringField("itemvalue", "")];
	localData.sItemNote = [NSString stringWithUTF8String:query->GetStringField("itemnote", "")];
	localData.sItemText = [NSString stringWithUTF8String:query->GetStringField("itemtext", "")];
	
	return YES;
}

+(NSString*) makePeplSumInfoByGUID:(NSString*)sGUID
{
	TPeopleInfo* pepl = [AstroDBMng getPeopleInfoBysGUID:sGUID];
	if (pepl == nil)
		return nil;
	
    /*
	NSString* shichen;
	if ([PubFunction stringIsNullOrEmpty:pepl.sLlHour])
	{
		shichen = [PubFunction getNlHourFromHour:pepl.iHour];
	}
	else
	{
		shichen = [pepl.sLlHour substringToIndex:1];
	}
	
	if ([PubFunction stringIsNullOrEmpty:shichen])
		return nil;
    */
    
    //2012.8.1 时辰用小时代替
	
	//姓-名|性别|出生年-月-日|出生时辰
    //姓-名|性别|出生年-月-日|时
	NSString* strInfo = [NSString stringWithFormat:@"%@|%@|%04d-%02d-%02d|%02d", pepl.sPersonName, pepl.sSex, 
						 pepl.iYear, pepl.iMonth, pepl.iDay,
						 pepl.iHour];
	
	return strInfo;
}

+(NSString*) makePeplSumInfoByObj:(TPeopleInfo*)pepl
{
	if (pepl == nil)
		return nil;
	
    /*
	NSString* shichen;
	if ([PubFunction stringIsNullOrEmpty:pepl.sLlHour])
	{
		shichen = [PubFunction getNlHourFromHour:pepl.iHour];
	}
	else
	{
		shichen = [pepl.sLlHour substringToIndex:1];
	}
	
	if ([PubFunction stringIsNullOrEmpty:shichen])
		return nil;
    */ 
    
    //2012.8.1 时辰用小时代替
	
	//姓-名|性别|出生年-月-日|出生时辰
    //姓-名|性别|出生年-月-日|时
	NSString* strInfo = [NSString stringWithFormat:@"%@|%@|%04d-%02d-%02d|%02d", pepl.sPersonName, pepl.sSex, 
						 pepl.iYear, pepl.iMonth, pepl.iDay,
						 pepl.iHour];
	
	return strInfo;
}

#pragma mark -
/////////////运势///////////////
+(BOOL) getFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TFlowYS*)tYunshi
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickFlowYSFromQuery:tYunshi Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询流日运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) removeFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除流日运势失败!");
		return NO;
	}
	
	return NO;
}

+(int) replaceFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date JsonData:(NSString*)jsLrYs
{
	@try
	{
		//先删除旧数据
		[AstroDBMng removeFlowYS:userGuid YsType:type Date:date];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return -1;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?, ?,?,?);", TBL_USR_YUNSHICACHE];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新流日运势信息出错");
			return -1;
		}
		
		int i = 1;
		stmt.Bind(i++, [userGuid UTF8String]);
		stmt.Bind(i++, [sPepInfo UTF8String]);
		stmt.Bind(i++, type);
		stmt.Bind(i++, date.year);	
		stmt.Bind(i++, date.month);
		stmt.Bind(i++, date.day);
		stmt.Bind(i++, [jsLrYs UTF8String]);
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新流日运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) pickFlowYSFromQuery:(TFlowYS*)tYunshi Query:(CppSQLite3Query*)query
{
	if (!tYunshi || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof()) 
	{ 
		LOG_ERROR(@"查询无结果!");
		return NO;
	}
	
	int year = query->GetIntField("iYear", 0);
	int month = query->GetIntField("iMonth", 0);
	int day = query->GetIntField("iDay", 0);
	NSString* strYunshi = [NSString stringWithUTF8String:query->GetStringField("sYunshiDesc", "")];
	
	//请求时间
	tYunshi.sDataTime = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
	
	//请求数据
	[BussFlowYS unpackFlowYSJson:strYunshi DataOut:tYunshi];
	
	return YES;
}


//紫微运势
+(BOOL) getZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
//						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickZwJsFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询运势失败!");
		return NO;
	}
	
	return NO;
}

//日运势
+(BOOL) getZwYs_Day:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	return [AstroDBMng getZwYs:userGuid YsType:EYunshiTypeDay Date:date YS:ZwYs];
}

//月运势
+(BOOL) getZwYs_Month:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	return [AstroDBMng getZwYs:userGuid YsType:EYunshiTypeMonth Date:date YS:ZwYs];
}

//年运势
+(BOOL) getZwYs_Year:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	return [AstroDBMng getZwYs:userGuid YsType:EYunshiTypeYear Date:date YS:ZwYs];
}


+(BOOL) removeZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
//						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除运势失败!");
		return NO;
	}
	
	return NO;
}

+(int) replaceZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date JsonData:(NSString*)jstrZwYs
{
	@try
	{
		//先删除旧数据
		[AstroDBMng removeZwYs:userGuid YsType:type Date:date];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return -1;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?, ?,?,?);", TBL_USR_YUNSHICACHE];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
            if(EMoneyFortune == type)
            {
                LOG_ERROR(@"更新财富趋势信息出错");
            }
            else
            {
                LOG_ERROR(@"更新运势信息出错");
            }
			return -1;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [userGuid UTF8String]);
		stmt.Bind(i++, [sPepInfo UTF8String]);
		stmt.Bind(i++, type);
		stmt.Bind(i++, date.year);	
		stmt.Bind(i++, date.month);
		stmt.Bind(i++, date.day);
		stmt.Bind(i++, [jstrZwYs UTF8String]);
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
        if(EMoneyFortune == type)
        {
            LOG_ERROR(@"更新财富趋势失败!");
        }
        else
        {
            LOG_ERROR(@"更新运势失败!");
        }
		return NO;
	}
	
	return NO;
}

+(BOOL) pickZwJsFromQuery:(TZWYS_FLOWYEAR_EXT*)ZwYs Query:(CppSQLite3Query*)query
{
	if (!ZwYs || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof()) 
	{ 
		LOG_ERROR(@"查询无结果!");
		return NO;
	}
	
	int year = query->GetIntField("iYear", 0);
	int month = query->GetIntField("iMonth", 0);
	int day = query->GetIntField("iDay", 0);
	NSString* strYunshi = [NSString stringWithUTF8String:query->GetStringField("sYunshiDesc", "")];
	
	//请求时间
	ZwYs.sDataTime = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
	
	//请求数据
	[BussZiweiYunshi unpackZwYsJson:strYunshi DataOut:ZwYs];
	
	return YES;
}

//紫微运势
+(BOOL) getLYSMMoney:(NSString*)userGuid Date:(TDateInfo*)date YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
        //		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
        //						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 EMoneyFortune, date.year, date.month, date.day];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickSMMoneyFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) pickSMMoneyFromQuery:(TLYSM_MONEYFORTUNE_EXT*)ZwYs Query:(CppSQLite3Query*)query
{
	if (!ZwYs || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof()) 
	{ 
		LOG_ERROR(@"查询无结果!");
		return NO;
	}
	
	int year = query->GetIntField("iYear", 0);
	int month = query->GetIntField("iMonth", 0);
	int day = query->GetIntField("iDay", 0);
	NSString* strYunshi = [NSString stringWithUTF8String:query->GetStringField("sYunshiDesc", "")];
	
	//请求时间
	ZwYs.sDataTime = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
	
	//请求数据
	[BussZiweiYunshi unpackLYSMJson:strYunshi DataOut:ZwYs];
	
	return YES;
}

//财富趋势
+(BOOL) getLYMoney:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
        //		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
        //						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickSMMoneyFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询财富趋势失败!");
		return NO;
	}
	
	return NO;
}

//事业成长  add 2012.8.16
+(BOOL) getYs_Career:(NSString*)userGuid Date:(TDateInfo*)date YS:(TSYYS_EXT*)SyYs
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
        //		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
        //						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 EYunshiTypeCareer, date.year, date.month, date.day];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickSyYsFromQuery:SyYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) pickSyYsFromQuery:(TSYYS_EXT*)SyYs Query:(CppSQLite3Query*)query
{
	if (!SyYs || !query)
	{
		LOG_ERROR(@"查取数据出错");
		return NO;
	}
	
	if (query->Eof()) 
	{ 
		LOG_ERROR(@"查询无结果!");
		return NO;
	}
	
	int year = query->GetIntField("iYear", 0);
	int month = query->GetIntField("iMonth", 0);
	int day = query->GetIntField("iDay", 0);
	NSString* strYunshi = [NSString stringWithUTF8String:query->GetStringField("sYunshiDesc", "")];
	
	//请求时间
	SyYs.sDataTime = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
	
	//请求数据
	[BussShiYeYunshi unpackZwYsJson:strYunshi DataOut:SyYs];
	
	return YES;
}

//本地是否有缓存运势
+(BOOL) hasSavedYunshi:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where sGuid='%@' and sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
//						 TBL_USR_YUNSHICACHE, userGuid, sPepInfo,
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where sPeplSumInfo='%@' and iType='%d' and iYear=%d and iMonth=%d and iDay=%d", 
						 TBL_USR_YUNSHICACHE, sPepInfo,
						 type, date.year, date.month, date.day];
		int nCnt = [[AstroDBMng getDbUserLocal] execScalar:sql];
		
		return nCnt > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询失败!");
		return NO;
	}
	
	return NO;
}



#pragma mark -
#pragma mark 天气信息

+ (WeatherInfo*) getWeatherInfo:(NSString*)citycode 
                           Date:(NSString*)date
{
    NSString* sql = [NSString stringWithFormat:
                     @"SELECT sJson,rUpdateTime FROM WeatherInfo WHERE sCityCode='%@' AND sDate='%@';", 
                     citycode, date];
    
    NSString* json = nil;
    NSTimeInterval ts = 0.0;
    
    try 
    {
        CppSQLite3Query query = [gDbUserLocal execQuery:sql];
        if (query.Eof()) 
        { 
            //LOG_ERROR(@"查询天气出错!");
            return nil;
        }
        
        json = [NSString stringWithUTF8String:query.GetStringField("sJson","")];
        ts = query.GetFloatField("rUpdateTime", 0.0);
        
    }
    catch (NSException * e) 
    {
        LOG_ERROR(@"查询天气失败!");
		return NO;
    }
    
    if ([PubFunction stringIsNullOrEmpty:json])
        return nil;
    
    WeatherInfo* wi = [WeatherInfo weatherWithJson:json];
    wi.rTs = ts;
    wi.sCityCode = citycode;
    wi.sDate = date;
    
    return wi;
}

+ (BOOL) replaceWeatherInfo:(NSString*)cityCode 
                       Date:(NSString*)date 
                       Json:(NSString*)json 
                  TimeStamp:(NSTimeInterval)ts
{
    try 
    {
        NSString* sql = @"replace into WeatherInfo values(?,?,?,?);";
        CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新天气出错!");
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [cityCode UTF8String]);
		stmt.Bind(i++, [date UTF8String]);
		stmt.Bind(i++, [json UTF8String]);
		stmt.Bind(i++, ts);
		return [gDbUserLocal commitStatement:&stmt];
    } 
    catch (NSException * e) 
    {
        LOG_ERROR(@"更新天气失败!");
		return NO;
    }
    
    return NO;
}


#pragma mark -
#pragma mark 天气城市设置
+(TCityWeather*) getCityWeatherData:(NSString*)cityCode
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sCityCode='%@';", TBL_USR_CITYWEATHER, cityCode];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"获取天气失败!");
			return nil;
		}
		
		TCityWeather *cw = [[TCityWeather new] autorelease];
        cw.sCityCode = [NSString stringWithUTF8String:query.GetStringField("sCityCode","")];
        cw.sCityName = [NSString stringWithUTF8String:query.GetStringField("sCityName","")];
        cw.iSort = query.GetIntField("iSort",0);
        return cw;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"获取天气失败!");
		return nil;
	}
	return nil;
}
 

+(TCityWeather*) getDefaultCityData
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where iSort=(select min(iSort) from %@);", TBL_USR_CITYWEATHER, TBL_USR_CITYWEATHER];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询默认天气城市失败!");
			return nil;
		}
		
        TCityWeather *cw = [[TCityWeather new] autorelease];
        cw.sCityCode = [NSString stringWithUTF8String:query.GetStringField("sCityCode","")];
        cw.sCityName = [NSString stringWithUTF8String:query.GetStringField("sCityName","")];
        cw.iSort = query.GetIntField("iSort",0);
        return cw;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询默认天气城市失败!");
		return nil;
	}
	return nil;
}


+(BOOL) addCity:(NSString*)cityID Name:(NSString*)cityName Order:(int)order
{
	@try
	{
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?);", TBL_USR_CITYWEATHER];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"增加城市出错!");
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [cityID UTF8String]);
		stmt.Bind(i++, [cityName UTF8String]);
		stmt.Bind(i++, order);
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"增加城市出错!");
		return NO;
	}
	
	return NO;
}

+(BOOL) removeCity:(NSString*) cityID
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where sCityCode='%@';", TBL_USR_CITYWEATHER, cityID];
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除天气城市失败: citycode=%@", cityID);
		return NO;
	}
	
	return NO;
}

//设置顺序
+(BOOL) setDispOrderByCode:(NSString*) citycode Order:(int)order
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update %@ set iSort=%d where sCityCode='%@';", TBL_USR_CITYWEATHER, order, citycode];
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"设置天气城市顺序失败: citycode=%@ order=%d", citycode, order);
		return NO;
	}
	return NO;
}

+(NSArray*) getAllCityByOrder
{
	@try
	{
		NSMutableArray* aryCityCode = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ order by iSort;", TBL_USR_CITYWEATHER];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TCityWeather* data = [TCityWeather new];
			data.sCityCode = [NSString stringWithUTF8String:query.GetStringField("sCityCode","")];
			data.sCityName = [NSString stringWithUTF8String:query.GetStringField("sCityName","")];
			data.iSort = query.GetIntField("iSort", 0);
			
			[aryCityCode addObject:data];
			[data release];
			
			query.NextRow();
		}
		
		return aryCityCode;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询天气城市失败!");
		return nil;
	}
	
	return nil;
}

+ (int) getCityNum
{
	NSString* sql = [NSString stringWithFormat:@"select count(*) from %@;", TBL_USR_CITYWEATHER];
	
	@try
	{				
		return [gDbUserLocal execScalar:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询天气城市数失败!");
		return 0;
	}
	
	return 0;
}


#pragma mark -
#pragma mark 人格特质
+(BOOL) getPeopleCharacter:(NSString*)userGuid OutData:(TNatureResult*) datout
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_CHARACTER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_CHARACTER, sPepInfo];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询人格特质出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickPeopleCharacter:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询人格特质出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) pickPeopleCharacter:(TNatureResult*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussCharacter unpackJson:dat.sItemText DataOut:data];
	
	return YES;
}

+(BOOL) replacePepoCharacter:(NSString*)userGuid Data:(NSString*)jsCharct Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removePeopleCharacter:userGuid];
		TPeopleInfo* pepl = [AstroDBMng getPeopleInfoBysGUID:userGuid];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByObj:pepl];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return NO;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新人格特质出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_CHARACTER UTF8String]);	//groupkey
		stmt.Bind(i++, "");	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [sPepInfo UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsCharct UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新人格特质出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) removePeopleCharacter:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid]; 
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_CHARACTER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_CHARACTER, sPepInfo];
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除人格特质出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) hasSavedPeopleCharacter:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_CHARACTER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_CHARACTER, sPepInfo];
		int res = [gDbUserLocal execScalar:sql];
		
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询人格特质出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

#pragma mark -
#pragma mark 爱情桃花

+(BOOL) getLoveFlower:(NSString*)userGuid OutData:(TLoveTaoHuaResult*) datout
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, sPepInfo];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询爱情桃花出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickLoveFlower:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询爱情桃花出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) pickLoveFlower:(TLoveTaoHuaResult*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussLoveFlower unpackLoveJson:dat.sItemText DataOut:data];
	
	return YES;
}

+(BOOL) replaceLoveFlower:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removeLoveFlower:userGuid];
		TPeopleInfo* pepl = [AstroDBMng getPeopleInfoBysGUID:userGuid];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByObj:pepl];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return NO;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新爱情桃花出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_LOVEFLOWER UTF8String]);	//groupkey
		stmt.Bind(i++, "");	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [sPepInfo UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsResp UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新爱情桃花出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) removeLoveFlower:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, sPepInfo];
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除爱情桃花出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) hasSavedLoveFlower:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_LOVEFLOWER, sPepInfo];
	
		int res = [gDbUserLocal execScalar:sql];
		
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询爱情桃花出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

#pragma mark -
#pragma mark 姓名分析
+(BOOL) getNameParsePlate:(NSString*)userGuid OutData:(TNT_PLATE_INFO*) datout
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, sPepInfo];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickNameParsePlate:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) getNameParseExplain:(NSString*)userGuid OutData:(TNT_EXPLAIN_INFO*) datout
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, sPepInfo];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickNameParseExplain:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}


+(BOOL) pickNameParsePlate:(TNT_PLATE_INFO*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussNameParse unpackNameParsePlateJson:dat.sItemText DataOut:data];
	
	return YES;
}

+(BOOL) pickNameParseExplain:(TNT_EXPLAIN_INFO*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussNameParse unpackNameParseExplainJson:dat.sItemText DataOut:data];
	
	return YES;
}


+(BOOL) replaceNameParsePlate:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removeNameParsePlate:userGuid];
		TPeopleInfo* pepl = [AstroDBMng getPeopleInfoBysGUID:userGuid];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByObj:pepl];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return NO;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新姓名分析出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_NAMEPARSE UTF8String]);	//groupkey
		stmt.Bind(i++, [LDGT_NAMEPARSE_PLATE UTF8String]);	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [sPepInfo UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsResp UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) replaceNameParseExplain:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removeNameParseExplain:userGuid];
		TPeopleInfo* pepl = [AstroDBMng getPeopleInfoBysGUID:userGuid];
		
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByObj:pepl];
		if([PubFunction stringIsNullOrEmpty:sPepInfo])
		{
			LOG_ERROR(@"命造信息不完整");
			return NO;
		}
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新姓名分析出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_NAMEPARSE UTF8String]);	//groupkey
		stmt.Bind(i++, [LDGT_NAMEPARSE_EXPLAIN UTF8String]);	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [sPepInfo UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsResp UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}


+(int) removeNameParsePlate:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, sPepInfo];
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除姓名分析出错 guid=%@!", userGuid);
		return 0;
	}
	
	return 0;
}

+(int) removeNameParseExplain:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, sPepInfo];
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除姓名分析出错 guid=%@!", userGuid);
		return 0;
	}
	
	return 0;
}

+(BOOL) hasSavedNameParsePlate:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_PLATE, sPepInfo];
		int res = [gDbUserLocal execScalar:sql];
		
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) hasSavedNameParseExplain:(NSString*)userGuid
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];	
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@' ", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, userGuid, sPepInfo];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@' ", 
						 TBL_USR_LOCALDATA, LDGT_NAMEPARSE, LDGT_NAMEPARSE_EXPLAIN, sPepInfo];
		int res = [gDbUserLocal execScalar:sql];
		
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名分析出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}


#pragma mark -
#pragma mark 姓名测试
+(BOOL) getNameTest:(NSString*)userGuid Name:(TNameYxParam*)param OutData:(TNameYxTestInfo*) datout
{
	@try
	{
		//“姓-名|性别”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@", 
							 [PubFunction formatNSString4Sqlite:param.pepName.sFamilyName], 
							 [PubFunction formatNSString4Sqlite:param.pepName.sSecondName], 
							 param.sSex];
		
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, strName];
		
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询姓名测试出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickNameTest:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名测试出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) pickNameTest:(TNameYxTestInfo*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussNameYxTest unpackNameYxTestInfoJson:dat.sItemText DataOut:data];
	
	return YES;
}

+(BOOL) replaceNameTest:(NSString*)userGuid Name:(TNameYxParam*)param Data:(NSString*)jsResp Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removeNameTest:userGuid Name:param];
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新姓名测试出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		//“姓-名|性别”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@", 
							 [PubFunction formatNSString4Sqlite:param.pepName.sFamilyName], 
							 [PubFunction formatNSString4Sqlite:param.pepName.sSecondName], 
							 param.sSex];
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_NAMETEST UTF8String]);	//groupkey
		stmt.Bind(i++, [param.sConsumeItem UTF8String]);	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [strName UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsResp UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新姓名测试出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(int) removeNameTest:(NSString*)userGuid Name:(TNameYxParam*)param
{
	@try
	{
		//“姓-名|性别”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@", 
							 [PubFunction formatNSString4Sqlite:param.pepName.sFamilyName], 
							 [PubFunction formatNSString4Sqlite:param.pepName.sSecondName], 
							 param.sSex];
		
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, strName];
		
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除姓名测试出错 guid=%@!", userGuid);
		return 0;
	}
	
	return 0;
}

+(BOOL) hasSavedNameTest:(NSString*)userGuid Name:(TNameYxParam*)param
{
	@try
	{
		//“姓-名|性别”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@", 
							 [PubFunction formatNSString4Sqlite:param.pepName.sFamilyName], 
							 [PubFunction formatNSString4Sqlite:param.pepName.sSecondName], 
							 param.sSex];
		
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and groupitem='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMETEST, param.sConsumeItem, strName];
		
		int res = [gDbUserLocal execScalar:sql];
		
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名测试出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

#pragma mark -
#pragma mark 姓名匹配
+(BOOL) getNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param OutData:(TNAME_PD_RESULT*) datout
{
	@try
	{
		//“姓-名|姓-名”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@-%@", 
							 [PubFunction formatNSString4Sqlite:param.sManXin], 
							 [PubFunction formatNSString4Sqlite:param.sManMing], 
							 [PubFunction formatNSString4Sqlite:param.sWomanXin], 
							 [PubFunction formatNSString4Sqlite:param.sWomanMing]];
		
//		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where groupkey='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, strName];
		
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		if (query.Eof()) 
		{ 
			LOG_ERROR(@"查询姓名匹配出错 guid=%@!", userGuid);
			return NO;
		}
		
		return [AstroDBMng pickNameMatch:datout Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名匹配出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(BOOL) pickNameMatch:(TNAME_PD_RESULT*)data Query:(CppSQLite3Query*)query
{
	TUserLocalData* dat = [[TUserLocalData new] autorelease];
	[AstroDBMng pickLocalDataFromQuery:dat Query:query];
	if ([PubFunction stringIsNullOrEmpty:dat.sItemText])
	{
		return NO;
	}
	
	//请求数据
	[BussNameMatch unpackNameMatchJson:dat.sItemText DataOut:data];
	
	return YES;
}

+(BOOL) replaceNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param Data:(NSString*)jsResp Time:(NSString*) sTime
{
	@try
	{
		//先删除
		[AstroDBMng removeNameMatch:userGuid Name:param];
		
		//再添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?,?,?,?,?);", TBL_USR_LOCALDATA];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新姓名匹配出错 guid=%@!", userGuid);
			return NO;
			
		}
		
		//“姓-名|姓-名”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@-%@", 
							 [PubFunction formatNSString4Sqlite:param.sManXin], 
							 [PubFunction formatNSString4Sqlite:param.sManMing], 
							 [PubFunction formatNSString4Sqlite:param.sWomanXin], 
							 [PubFunction formatNSString4Sqlite:param.sWomanMing]];
		
		int i = 1;
		stmt.BindNull(i++);
		stmt.Bind(i++, [LDGT_NAMEMATCH UTF8String]);	//groupkey
		stmt.Bind(i++, "");	//groupitem
		stmt.Bind(i++, 0);		//itemno
		stmt.Bind(i++, [userGuid UTF8String]);		//itemcode
		stmt.Bind(i++, [strName UTF8String]);		//itemvalue
		stmt.Bind(i++, [sTime UTF8String]);		//itemnote
		stmt.Bind(i++, [jsResp UTF8String]);	//itemtext
		
		return [gDbUserLocal commitStatement:&stmt];
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新姓名匹配出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}

+(int) removeNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param
{
	@try
	{
		//“姓-名|姓-名”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@-%@", 
							 [PubFunction formatNSString4Sqlite:param.sManXin], 
							 [PubFunction formatNSString4Sqlite:param.sManMing], 
							 [PubFunction formatNSString4Sqlite:param.sWomanXin], 
							 [PubFunction formatNSString4Sqlite:param.sWomanMing]];
		
//		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where groupkey='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, strName];
		
		return [gDbUserLocal execDML:sql];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除姓名匹配出错 guid=%@!", userGuid);
		return 0;
	}
	
	return 0;
}

+(BOOL) hasSavedNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param
{
	@try
	{
		//“姓-名|姓-名”
		NSString* strName = [NSString stringWithFormat:@"%@-%@|%@-%@", 
							 [PubFunction formatNSString4Sqlite:param.sManXin], 
							 [PubFunction formatNSString4Sqlite:param.sManMing], 
							 [PubFunction formatNSString4Sqlite:param.sWomanXin], 
							 [PubFunction formatNSString4Sqlite:param.sWomanMing]];
		
//		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemcode='%@' and itemvalue='%@'", 
//						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, userGuid,  strName];
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where groupkey='%@' and itemvalue='%@'", 
						 TBL_USR_LOCALDATA, LDGT_NAMEMATCH, strName];
		
		int res = [gDbUserLocal execScalar:sql];
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询姓名匹配出错 guid=%@!", userGuid);
		return NO;
	}
	
	return NO;
}


#pragma mark -
#pragma mark 检查新版本
//是否有新版本
+(BOOL) hasNewVersion
{
	TCheckVersionResult* objResult = nil;
	if (![AstroDBMng getVerCheckResult:&objResult] || !objResult)
	{
		return NO;
	}
	
	if (![PubFunction stringIsNullOrEmpty:objResult.sVerCode] && ![PubFunction stringIsNullOrEmpty:objResult.sDownURL])
	{ 
		// 显示版本比较结果
		NSString *verLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
		NSComparisonResult compareResult = [BussCheckVersion compareVersion:objResult.sVerCode :verLocal];
		return (compareResult == NSOrderedDescending);
	}
	
	return NO;
}

//
+(BOOL)getVerCheckResult:(TCheckVersionResult**)dataOut
{
	@try
	{
		//日期
		NSString* strVal = [AstroDBMng getSystemCfg:@"checksoftver" Cond:@"" Default:@""];
		if ([PubFunction stringIsNullOrEmpty:strVal])
		{
			return NO;
		}

		if (!*dataOut)
		{
			*dataOut = [[TCheckVersionResult new] autorelease];
		}
		return [BussCheckVersion unpackJsonCheckVersion:strVal :*dataOut];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询新版本出错");
		return NO;
	}
	
	return NO;
}

+(BOOL)replaceVerCheckResult:(NSString*)jsResp
{
	return [AstroDBMng setSystemCfg:@"checksoftver" Cond:@"" Value:jsResp];
}

+(BOOL)removeVerCheckResult
{
	@try
	{
		//
		NSString* sql = [NSString stringWithFormat:@"delete from %@ where cfg_key='%@'", 
						 TBL_CONFIG, @"checksoftver"];
		
		[gDbAstroCommon execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除版本检查结果出错!");
		return NO;
	}
	
	return NO;
}

+(BOOL) hasSavedVerCheckResult
{
	@try
	{
		//
		NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where cfg_key='%@'", 
						 TBL_CONFIG, @"checksoftver"];
		
		int res = [gDbAstroCommon execScalar:sql];
		return res > 0 ? YES : NO;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询版本检查结果出错");
		return NO;
	}
	
	return NO;
}



#pragma mark -
#pragma mark 悬赏&建议
//增加新问题
+(BOOL)addNewQuestion:(NSString*)sQuestion QuestNO:(NSString*)sQuestNO Time:(NSString*)sAskTime
{
	@try
	{
		//添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?,?);", TBL_USR_SUGGEST];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"添加悬赏问题出错 guid=%@!", sQuestNO);
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [sQuestNO UTF8String]);
		stmt.Bind(i++, [sQuestion UTF8String]);
		stmt.Bind(i++, [sAskTime UTF8String]);
		stmt.Bind(i++, 0);
		
		return [gDbUserLocal commitStatement:&stmt] > 0;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"添加悬赏问题出错");
		return NO;
	}
	
	return NO;
}

//更新问题标识
+(BOOL)updateQuestionFlagByAnswerTable
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update Suggest set iFlag=1 where iFlag=0 "
						 "and (select count(*) from SuggestAnswer as SA where sQuestNO=SA.sQuestNO) > 0 ;"
						 ];
		
		[gDbUserLocal execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新悬赏问题标识出错");
		return NO;
	}
	
	return NO;
}

+(BOOL)updateQuestionFlag:(NSString*)sQuestNO Flag:(int)flag
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"update %@ set iFlag=%d where sQuestNO=%@", TBL_USR_SUGGEST, flag, sQuestNO];
		
		return [gDbUserLocal execDML:sql] > 0;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新悬赏问题回复标识出错");
		return NO;
	}
	
	return NO;
}

//取得所有问题（按时间排序）
+(NSArray*)getAllQuestions
{
	@try
	{
		NSMutableArray* aryQuest = [NSMutableArray array];
		
		//问题
		NSString* sql = [NSString stringWithFormat:@"select * from %@ order by sAskTime DESC", TBL_USR_SUGGEST];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TQuestionAnswer* qs = [TQuestionAnswer new];
			[aryQuest addObject:qs];
			[qs release];
			
			qs.itemQuest = [[TSuggestItem new] autorelease];
			qs.itemQuest.sQuestNO = [NSString stringWithUTF8String:query.GetStringField("sQuestNO", "")];
			qs.itemQuest.sQuestion = [NSString stringWithUTF8String:query.GetStringField("sQuestion", "")];
			qs.itemQuest.sAskTime = [NSString stringWithUTF8String:query.GetStringField("sAskTime", "")];
			qs.itemQuest.iFlag = query.GetIntField("iFlag", 0);
			
			query.NextRow();
		}
		
		//回复
		for (TQuestionAnswer* qs in aryQuest)
		{
			if (!qs || !qs.itemQuest)
			{
				continue;
			}
			
			qs.aryAnswer = (NSMutableArray*)[AstroDBMng getSuggestAnswers:qs.itemQuest.sQuestNO];
		}
		
		return aryQuest;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新悬赏问题回复标识出错");
		return nil;
	}
	
	return nil;
}

//取得所有未回复问题GUID
+(NSArray*)getUnanswerQuestions
{
	@try
	{
		NSMutableArray* aryQuest = [NSMutableArray array];
		
		//问题
		NSString* sql = [NSString stringWithFormat:@"select sQuestNO from %@ where iFlag=0", TBL_USR_SUGGEST];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		while ( !query.Eof()) 
		{ 
			NSString* sGUID = [NSString stringWithUTF8String:query.GetStringField("sQuestNO", "")];
			[aryQuest addObject:sGUID];
			
			query.NextRow();
		}
		
		return aryQuest;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"取未回复悬赏问题出错");
		return nil;
	}
	
	return nil;
}


#pragma mark -
#pragma mark 悬赏&建议-回复
//增加新的问题回复
+(BOOL)addNewAnswer:(NSString*)sQuestNO Answer:(NSString*)sAns Time:(NSString*)sAnsTime
{
	@try
	{
		if ([PubFunction stringIsNullOrEmpty:sQuestNO])
		{
			LOG_ERROR(@"问题GUID为空!");
			return NO;
		}
		//添加新数据
		NSString* sql = [NSString stringWithFormat:@"replace into %@ values(?,?,?);", TBL_USR_SUGGESTANSWER];
		
		CppSQLite3Statement stmt;
		if (![gDbUserLocal pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"添加悬赏问题回复出错 sQuestNO=%@!", sQuestNO);
			return NO;
			
		}
		
		int i = 1;
		stmt.Bind(i++, [sQuestNO UTF8String]);
		stmt.Bind(i++, [sAns UTF8String]);
		stmt.Bind(i++, [sAnsTime UTF8String]);
		
		return [gDbUserLocal commitStatement:&stmt] > 0;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"添加悬赏问题回复出错 sQuestNO=%@!", sQuestNO);
		return NO;
	}
	
	return NO;
}

//取得某问题的所有回复 (TAnswerItem)
+(NSArray*)getSuggestAnswers:(NSString*)sQuestNO
{
	@try
	{
		if ([PubFunction stringIsNullOrEmpty:sQuestNO])
		{
			LOG_ERROR(@"问题GUID为空!");
			return nil;
		}
		
		NSMutableArray* aryAnswer = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sQuestNO='%@'", TBL_USR_SUGGESTANSWER, sQuestNO];
		CppSQLite3Query query = [gDbUserLocal execQuery:sql];
		while ( !query.Eof()) 
		{ 
			TAnswerItem* itemAns = [TAnswerItem new];
			[aryAnswer addObject:itemAns];
			[itemAns release];
			
			itemAns.sQuestNO = [NSString stringWithUTF8String:query.GetStringField("sQuestNO", "")];
			itemAns.sAnswer = [NSString stringWithUTF8String:query.GetStringField("sAnswer", "")];
			itemAns.sAnsTime = [NSString stringWithUTF8String:query.GetStringField("sAnsTime", "")];
			
			query.NextRow();
		}
		
		return aryAnswer;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询悬赏问题回复出错. sQuestNO=%@", sQuestNO);
		return nil;
	}
	
	return nil;
}

@end


#pragma mark -
#pragma mark 数据管理－生日速配&号码测试
//生日速配
const int S_BIRTHDAYRES[][9] = 
{
	{2,4,5,3,4,1,2,3,4},
	{3,3,3,4,2,2,5,3,1},
	{4,2,2,2,3,4,2,1,5},
	{2,4,4,1,4,3,3,5,2},
	{3,3,3,5,2,2,1,4,4},
	{1,2,2,3,3,5,3,4,3},
	{4,5,1,4,2,4,4,2,3},
	{2,1,4,2,5,3,4,2,3},
	{5,3,2,3,1,2,3,3,4}
};

const std::string S_BIRTHDAYEXPLAIN[] = 
{
	"你属于领导型的人。必要时，你能够说出一些语气强硬的话来，你的爱憎十分分明、立场坚定，通常，你周围的人都比较信赖你。不过有时你的强硬态度会令别人对你敬而远之。因为你过于自信的一面太突出，所以就会引起他人的反感，其实有时候，冷静就是避免麻烦缠身的关键。",
	"你很有作为幕后工作者的实力，常常会让你周围的人觉得自己在你面前就会略逊你一筹。性格方面也具有很强的流动性。不过你的情绪波动常会比较大，所以，千万不能让压力积累在一起，应该时时注意适时地宣泄一下，去散散心，让情绪稳定下来，在工作或学习方面的表现就会更加突出。",
	"你总能在朋友圈里保持自己的重要地位一样，你和各种类型的人都能友好相处，请随时保持友善的微笑和幽默。不过你具有过于依赖别人的倾向，如果你在性情上的散漫表现得过于突出的话，很有可能会失去周围朋友对你的信任，因此树立一个远大的目标，并逐步实现它，对你是很有帮助的。",
	"你做事基本是脚踏实地，性格坚韧不拔，而你坚实的表面则会给人一种安全感。和朋友相处时，不妨多起协调的作用，别人对你的好感度就会提升。不过你有时候也顽固不化，喜欢一根筋地按自己的方式去处理事情，这反而会让自己成为麻烦的制造者。多听听别人的意见有时候对你会有帮助。",
	"你漂亮的外表能够引起大多数人的好感，但最好要做一个表里如一的人，否则别人会发现，漂亮的装饰底下竟是平淡无奇。你也应该分清朋友的类别，结交一些良师益友，不要在人前炫耀自己的见识，避免给人留下肤浅的印象。",
	"你生动活泼，真诚待人的话，会极度收到别人的追捧，人气很旺。不过办事表达还是要略有分寸，不能过火，否则别人会觉得有点烦。略带情绪化的你，要懂得善于控制感情，如过于任性，别人对你的评价会变差，不要被别人对你的赞美所迷惑，善待别人是让人际关系往更好方向发展的最佳途径。",
	"你那细腻的性格是周围的人喜欢你的所在。多培养自己艺术方面的修养，你会更加出色。不过有的时候，你内心的冷漠会情不自禁地在不经意的言谈举止中流露出来，这样就破坏了你在别人心目中完美的形象了。以后处事果断一些，就不会被人说你是优柔寡断的人。",
	"你的耐力颇强，所以常常被朋友当作精神支柱，你不论在哪种场合都不会失去冷静，即使做个不发言的听众也能博得旁人的好感。建议你不要太以自我为中心了，有的时候太过顽固会被周围的人反对，虚心听取一下别人的意见和建议没什么不好，这样一来，紧张的人际关系就会得到明显的改善。",
	"性格干脆而坦率，有较强的正义感和决断力，做起事来也是风风火火的，经常能获得别人的敬佩。当然，为了避免破坏自己的形象以及人际关系，请保持冷静的头脑，别随便对人发火。在怒火上升的时候时，最好不要再说话，让自己的头脑冷静一下，这样往往可以避免争执，避免不必要的麻烦。 "
};

const std::string S_BIRTHDAYEXPLAIN_FT[] = 
{
	"你屬於領導型的人。必要時，你能夠說出一些語氣強硬的話來，你的愛憎十分分明、立場堅定，通常，你周圍的人都比較信賴你。不過有時你的強硬態度會令別人對你敬而遠之。因為你過於自信的一面太突出，所以就會引起他人的反感，其實有時候，冷靜就是避免麻煩纏身的關鍵。",
	"你很有作為幕後工作者的實力，常常會讓你周圍的人覺得自己在你面前就會略遜你一籌。性格方面也具有很強的流動性。不過你的情緒波動常會比較大，所以，千萬不能讓壓力積累在一起，應該時時註意適時地宣泄一下，去散散心，讓情緒穩定下來，在工作或學習方面的表現就會更加突出。",
	"你總能在朋友圈裏保持自己的重要地位一樣，你和各種類型的人都能友好相處，請隨時保持友善的微笑和幽默。不過你具有過於依賴別人的傾向，如果你在性情上的散漫表現得過於突出的話，很有可能會失去周圍朋友對你的信任，因此樹立一個遠大的目標，並逐步實現它，對你是很有幫助的。",
	"你做事基本是腳踏實地，性格堅韌不拔，而你堅實的表面則會給人一種安全感。和朋友相處時，不妨多起協調的作用，別人對你的好感度就會提升。不過你有時候也頑固不化，喜歡一根筋地按自己的方式去處理事情，這反而會讓自己成為麻煩的制造者。多聽聽別人的意見有時候對你會有幫助。",
	"你漂亮的外表能夠引起大多數人的好感，但最好要做一個表裏如一的人，否則別人會發現，漂亮的裝飾底下竟是平淡無奇。你也應該分清朋友的類別，結交一些良師益友，不要在人前炫耀自己的見識，避免給人留下膚淺的印象。",
	"你生動活潑，真誠待人的話，會極度收到別人的追捧，人氣很旺。不過辦事表達還是要略有分寸，不能過火，否則別人會覺得有點煩。略帶情緒化的你，要懂得善於控制感情，如過於任性，別人對你的評價會變差，不要被別人對你的贊美所迷惑，善待別人是讓人際關系往更好方向發展的最佳途徑。",
	"你那細膩的性格是周圍的人喜歡你的所在。多培養自己藝術方面的修養，你會更加出色。不過有的時候，你內心的冷漠會情不自禁地在不經意的言談舉止中流露出來，這樣就破壞了你在別人心目中完美的形象了。以後處事果斷一些，就不會被人說你是優柔寡斷的人。",
	"你的耐力頗強，所以常常被朋友當作精神支柱，你不論在哪種場合都不會失去冷靜，即使做個不發言的聽眾也能博得旁人的好感。建議你不要太以自我為中心了，有的時候太過頑固會被周圍的人反對，虛心聽取一下別人的意見和建議沒什麽不好，這樣一來，緊張的人際關系就會得到明顯的改善。",
	"性格幹脆而坦率，有較強的正義感和決斷力，做起事來也是風風火火的，經常能獲得別人的敬佩。當然，為了避免破壞自己的形象以及人際關系，請保持冷靜的頭腦，別隨便對人發火。在怒火上升的時候時，最好不要再說話，讓自己的頭腦冷靜一下，這樣往往可以避免爭執，避免不必要的麻煩。 "
};

// 电话号码吉凶数据
const std::string TelResult[] = 
{
	"得而复失，枉费心机，守成无贪，可保安稳。（吉带凶）",
	"大展鸿图，信用得固，名利双收，可获成功。（吉）",
	"根基不固，摇摇欲坠，一盛一衰，劳而无获。（凶）",
	"根深蒂固，蒸蒸日上，如意吉祥，百事顺遂。（吉）",
	"前途坎坷，苦难折磨，非有毅力，难望成功。（凶）",
	"阴阳和合，生意兴隆，名利双收，后福重重。（吉）",
	"万宝集门，天降幸运，立志奋发，得成大功。（吉）",
	"独营生意，和气吉祥，排除万难，必获成功。（吉）",
	"努力发达，贯彻志望，不忘进退，可望成功。（吉）",
	"虽抱奇才，有才无命，独营无力，财力难望。（凶）",
	"乌云遮月，暗淡无光，空费心力，徒劳无功。（凶）",
	"草木逢春，枝叶沾露，稳健着实，必得人望。（吉）",
	"薄弱无力，孤立无援，外祥内苦，谋事难成。（凶）",
	"天赋吉运，能得人望，善用智慧，必获成功。（吉）",
	"忍得若难，必有后福，是成是败，惟靠紧毅。（凶）",
	"谦恭做事，外得人和，大事成就，一门兴隆。（吉）",
	"能获众望，成就大业，名利双收，盟主四方。（吉）",
	"排除万难，有贵人助，把握时机，可得成功。（吉）",
	"经商做事，顺利昌隆，如能慎始，百事亨通。（吉）",
	"成功虽早，慎防亏空，内外不合，障碍重重。（凶）",
	"智商志大，历尽艰难，焦心忧劳，进得两难。（凶）",
	"先历困苦，后得幸福，霜雪梅花，春来怒放。（吉）",
	"秋草逢霜，怀才不遇，忧愁怨苦，事不如意。（凶）",
	"旭日升天，名显四方，渐次进展，终成大业。（吉）",
	"锦绣前程，须靠自力，多用智谋，能奏大功。（吉）",
	"天时地利，只欠人和，讲信修睦，即可成功。（吉）",
	"波澜起伏，千变万化，凌架万难，必可成功。（凶带吉）",
	"一成一败，一盛一衰，惟靠谨慎，可守成功。（吉带凶）",
	"鱼临旱地，难逃恶运，此数大凶，不如更名。（凶）",
	"如龙得云，青云直上，智谋奋进，才略奏功。（吉）",
	"吉凶参半，得失相伴，投机取巧，吉凶无常。（吉带凶）",
	"此数大吉，名利双收，渐进向上，大业成就。（吉）",
	"池中之龙，风云际会，一跃上天，成功可望。（吉）",
	"意气用事，人和必失，如能慎始，必可昌隆。（吉）",
	"灾难不绝，难望成功，此数大凶，不如更名。（凶）",
	"中吉之数，进退保守，生意安稳，成就普通。（吉）",
	"波澜得叠，常陷穷困，动不如静，有才无命。（凶）",
	"逢凶化吉，吉人天相，风调雨顺，生意兴隆。（吉）",
	"名虽可得，利则难获，艺界发展，可望成功。（凶带吉） ",
	"云开见月，虽有劳碌，光明坦途，指日可望。（吉）",
	"一成一衰，沉浮不定，知难而退，自获天佑。（吉带凶）",
	"天赋吉运，德望兼备，继续努力，前途无限。（吉）",
	"事业不专，十九不成，专心进取，可望成功。（吉带凶）",
	"雨夜之花，外祥内苦，忍耐自重，转凶为吉。（吉带凶）",
	"虽用心计，事难遂愿，贪功冒进，必招失败。（凶）",
	"杨柳遇春，绿叶发枝，冲破难关，一举成名。（吉）",
	"坎坷不平，艰难重重，若无耐心，难望有成。（凶）",
	"有贵人助，可成大业，虽遇不幸，浮沉不定。（吉）",
	"美化丰实，鹤立鸡群，名利俱全，繁荣富贵。（吉）",
	"遇吉则吉，遇凶则凶，惟靠谨慎，逢凶化吉。（凶）",
	"吉凶互见，一成一败，凶中有吉，吉中有凶。（吉带凶）",
	"一盛一衰，浮沉不常，自重自处，可保平安。（吉带凶）",
	"草木逢春，雨过天晴，渡过难关，即获成功。（吉）",
	"盛衰参半，外祥内苦，先吉后凶，先凶后吉。（吉带凶）",
	"虽倾全力，难望成功，此数大凶，最好改名。（凶）",
	"外观昌隆，内隐祸患，克服难关，开出泰运。（吉带凶）",
	"事与愿违，终难成功，欲速不达，有始无终。（凶）",
	"虽有困难，时来运转，旷野枯草，春来花开。（凶带吉）",
	"半凶半吉，浮沉多端，始凶终吉，能保成功。（凶带吉）",
	"遇事猜疑，难望成事，大刀阔斧，始可有成。（凶）",
	"黑暗无光，心迷意乱，出尔反尔，难定方针。（凶）",
	"云遮半月，内隐风波，应有谨慎，始保平安。（吉带凶）",
	"烦闷懊恼，事业难展，自防灾祸，始免困境。（凶）",
	"万物化育，繁荣之象，专心一意，必能成功。（吉）",
	"见异思迁，十九不成，徒劳无功，不如更名。（凶）",
	"吉运自来，能享盛名，把握时机，必获成功。（吉）",
	"黑夜温长，进退维谷，内外不和，信用缺乏。（凶）",
	"独营事业，事事如意，功成名就，富贵自来。（吉）",
	"思虑周祥，计书力行，不失先机，可望成功。（吉）",
	"动摇不安，常陷逆境，不得时运，难得利润。（凶）",
	"惨淡经营，难免贫困，此数不吉，最好改名。（凶）",
	"吉凶参半，惟赖勇气，贯彻力行，始可成功。（吉带凶）",
	"利害混集，凶多吉少，得而复失，难以安顺。（凶）",
	"安乐自来，自然吉祥，力行不懈，终必成功。（吉）",
	"利不及费，坐食山空，如无章法，难望成功。（凶）",
	"吉中带凶，欲速不达，进不如守，可保安祥。（吉带凶）",
	"此数大凶，破产之象，宜速改名，以避厄运。（凶）",
	"先苦后甘，先甜后苦，如能守成，不致失败。（吉带凶）",
	"有得有失，华而不实，须防劫财，始保安顺。（吉带凶）",
	"如走夜路，前途无光，希望不大，劳而无功。（凶）"
};

const std::string TelResult_FT[] = 
{
	"得而復失，枉費心機，守成無貪，可保安穩。（吉帶兇）",
	"大展鴻圖，信用得固，名利雙收，可獲成功。（吉）",
	"根基不固，搖搖欲墜，一盛一衰，勞而無獲。（兇）",
	"根深蒂固，蒸蒸日上，如意吉祥，百事順遂。（吉）",
	"前途坎坷，苦難折磨，非有毅力，難望成功。（兇）",
	"陰陽和合，生意興隆，名利雙收，後福重重。（吉）",
	"萬寶集門，天降幸運，立誌奮發，得成大功。（吉）",
	"獨營生意，和氣吉祥，排除萬難，必獲成功。（吉）",
	"努力發達，貫徹誌望，不忘進退，可望成功。（吉）",
	"雖抱奇才，有才無命，獨營無力，財力難望。（兇）",
	"烏雲遮月，暗淡無光，空費心力，徒勞無功。（兇）",
	"草木逢春，枝葉沾露，穩健著實，必得人望。（吉）",
	"薄弱無力，孤立無援，外祥內苦，謀事難成。（兇）",
	"天賦吉運，能得人望，善用智慧，必獲成功。（吉）",
	"忍得若難，必有後福，是成是敗，惟靠緊毅。（兇）",
	"謙恭做事，外得人和，大事成就，一門興隆。（吉）",
	"能獲眾望，成就大業，名利雙收，盟主四方。（吉）",
	"排除萬難，有貴人助，把握時機，可得成功。（吉）",
	"經商做事，順利昌隆，如能慎始，百事亨通。（吉）",
	"成功雖早，慎防虧空，內外不合，障礙重重。（兇）",
	"智商誌大，歷盡艱難，焦心憂勞，進得兩難。（兇）",
	"先歷困苦，後得幸福，霜雪梅花，春來怒放。（吉）",
	"秋草逢霜，懷才不遇，憂愁怨苦，事不如意。（兇）",
	"旭日升天，名顯四方，漸次進展，終成大業。（吉）",
	"錦繡前程，須靠自力，多用智謀，能奏大功。（吉）",
	"天時地利，只欠人和，講信修睦，即可成功。（吉）",
	"波瀾起伏，千變萬化，淩架萬難，必可成功。（兇帶吉）",
	"一成一敗，一盛一衰，惟靠謹慎，可守成功。（吉帶兇）",
	"魚臨旱地，難逃惡運，此數大兇，不如更名。（兇）",
	"如龍得雲，青雲直上，智謀奮進，才略奏功。（吉）",
	"吉兇參半，得失相伴，投機取巧，吉兇無常。（吉帶兇）",
	"此數大吉，名利雙收，漸進向上，大業成就。（吉）",
	"池中之龍，風雲際會，一躍上天，成功可望。（吉）",
	"意氣用事，人和必失，如能慎始，必可昌隆。（吉）",
	"災難不絕，難望成功，此數大兇，不如更名。（兇）",
	"中吉之數，進退保守，生意安穩，成就普通。（吉）",
	"波瀾得疊，常陷窮困，動不如靜，有才無命。（兇）",
	"逢兇化吉，吉人天相，風調雨順，生意興隆。（吉）",
	"名雖可得，利則難獲，藝界發展，可望成功。（兇帶吉） ",
	"雲開見月，雖有勞碌，光明坦途，指日可望。（吉）",
	"一成一衰，沈浮不定，知難而退，自獲天佑。（吉帶兇）",
	"天賦吉運，德望兼備，繼續努力，前途無限。（吉）",
	"事業不專，十九不成，專心進取，可望成功。（吉帶兇）",
	"雨夜之花，外祥內苦，忍耐自重，轉兇為吉。（吉帶兇）",
	"雖用心計，事難遂願，貪功冒進，必招失敗。（兇）",
	"楊柳遇春，綠葉發枝，沖破難關，一舉成名。（吉）",
	"坎坷不平，艱難重重，若無耐心，難望有成。（兇）",
	"有貴人助，可成大業，雖遇不幸，浮沈不定。（吉）",
	"美化豐實，鶴立雞群，名利俱全，繁榮富貴。（吉）",
	"遇吉則吉，遇兇則兇，惟靠謹慎，逢兇化吉。（兇）",
	"吉兇互見，一成一敗，兇中有吉，吉中有兇。（吉帶兇）",
	"一盛一衰，浮沈不常，自重自處，可保平安。（吉帶兇）",
	"草木逢春，雨過天晴，渡過難關，即獲成功。（吉）",
	"盛衰參半，外祥內苦，先吉後兇，先兇後吉。（吉帶兇）",
	"雖傾全力，難望成功，此數大兇，最好改名。（兇）",
	"外觀昌隆，內隱禍患，克服難關，開出泰運。（吉帶兇）",
	"事與願違，終難成功，欲速不達，有始無終。（兇）",
	"雖有困難，時來運轉，曠野枯草，春來花開。（兇帶吉）",
	"半兇半吉，浮沈多端，始兇終吉，能保成功。（兇帶吉）",
	"遇事猜疑，難望成事，大刀闊斧，始可有成。（兇）",
	"黑暗無光，心迷意亂，出爾反爾，難定方針。（兇）",
	"雲遮半月，內隱風波，應有謹慎，始保平安。（吉帶兇）",
	"煩悶懊惱，事業難展，自防災禍，始免困境。（兇）",
	"萬物化育，繁榮之象，專心一意，必能成功。（吉）",
	"見異思遷，十九不成，徒勞無功，不如更名。（兇）",
	"吉運自來，能享盛名，把握時機，必獲成功。（吉）",
	"黑夜溫長，進退維谷，內外不和，信用缺乏。（兇）",
	"獨營事業，事事如意，功成名就，富貴自來。（吉）",
	"思慮周祥，計書力行，不失先機，可望成功。（吉）",
	"動搖不安，常陷逆境，不得時運，難得利潤。（兇）",
	"慘淡經營，難免貧困，此數不吉，最好改名。（兇）",
	"吉兇參半，惟賴勇氣，貫徹力行，始可成功。（吉帶兇）",
	"利害混集，兇多吉少，得而復失，難以安順。（兇）",
	"安樂自來，自然吉祥，力行不懈，終必成功。（吉）",
	"利不及費，坐食山空，如無章法，難望成功。（兇）",
	"吉中帶兇，欲速不達，進不如守，可保安祥。（吉帶兇）",
	"此數大兇，破產之象，宜速改名，以避厄運。（兇）",
	"先苦後甘，先甜後苦，如能守成，不致失敗。（吉帶兇）",
	"有得有失，華而不實，須防劫財，始保安順。（吉帶兇）",
	"如走夜路，前途無光，希望不大，勞而無功。（兇）"
};


//用户个性
const std::string Personality[] = 
{
	"个性系数为 9 ，主人性格类型：[自我牺牲/性格被动型]，其具体表现为：惯于无条件付出，从不祈求有回报，有为了成全他人不惜牺牲自己的情操。但讲到本身的爱情观，却流于被动，往往因为内敛而错过大好姻缘。",
	"个性系数为 1 ，主人性格类型：[要面包不要爱情型]，其具体表现为：责任心重，尤其对工作充满热诚，是个彻头彻尾工作狂。但往往因为过分专注职务，而忽略身边的家人及朋友，是个宁要面包不需要爱情的理性主义者。",
	"个性系数为 2 ，主人性格类型：[不善表达/疑心大型]，其具体表现为：在乎身边各人对自己的评价及观感，不善表达个人情感，是个先考虑别人感受，再作出相应配合的内敛一族。对于爱侣，经常存有怀疑之心。",
	"个性系数为 3 ，主人性格类型：[大胆行事冲动派型]，其具体表现为：爱好追寻刺激，有不理后果大胆行事的倾向。崇尚自由奔放的恋爱，会拼尽全力爱一场，是就算明知无结果都在所不惜的冲动派。",
	"个性系数为 4 ，主人性格类型：[高度戒备难交心型]，其具体表现为：经常处于戒备状态，对任何事都没法放松处理，孤僻性情难以交朋结友。对于爱情，就更加会慎重处理。任何人必须经过你长期观察及通过连番考验，方会减除戒备与你交往。",
	"个性系数为 5 ，主人性格类型：[好奇心旺求知欲强型]，其具体表现为：好奇心极度旺盛，求知欲又强，有打烂沙盘问到笃的锲而不舍精神。此外，你天生有语言天分，学习外文比一般人更易掌握。",
	"个性系数为 6 ，主人性格类型：[做事喜好凭直觉型]，其具体表现为：有特强的第六灵感，性格率直无机心，深得朋辈爱戴。感情路上多采多姿。做事喜好凭个人直觉及预感做决定。",
	"个性系数为 7 ，主人性格类型：[独断独行/吸引人型]，其具体表现为：为人独断独行，事事自行作主解决，鲜有求助他人。而这份独立个性，正正就是吸引异性的特质。但其实心底里，却是渴望有人可让他/她依赖。",
	"个性系数为 8 ，主人性格类型：[热情/善变梦想家型]，其具体表现为：对人热情无遮掩，时常梦想可以谈一场戏剧性恋爱，亲身体会个中悲欢离合的动人经历，是个大梦想家。但对于感情却易变卦。"
};


const std::string Personality_FT[] = 
{
	"個性系數為 9 ，主人性格類型：[自我犧牲/性格被動型]，其具體表現為：慣於無條件付出，從不祈求有回報，有為了成全他人不惜犧牲自己的情操。但講到本身的愛情觀，卻流於被動，往往因為內斂而錯過大好姻緣。",
	"個性系數為 1 ，主人性格類型：[要面包不要愛情型]，其具體表現為：責任心重，尤其對工作充滿熱誠，是個徹頭徹尾工作狂。但往往因為過分專註職務，而忽略身邊的家人及朋友，是個寧要面包不需要愛情的理性主義者。",
	"個性系數為 2 ，主人性格類型：[不善表達/疑心大型]，其具體表現為：在乎身邊各人對自己的評價及觀感，不善表達個人情感，是個先考慮別人感受，再作出相應配合的內斂一族。對於愛侶，經常存有懷疑之心。",
	"個性系數為 3 ，主人性格類型：[大膽行事沖動派型]，其具體表現為：愛好追尋刺激，有不理後果大膽行事的傾向。崇尚自由奔放的戀愛，會拼盡全力愛一場，是就算明知無結果都在所不惜的沖動派。",
	"個性系數為 4 ，主人性格類型：[高度戒備難交心型]，其具體表現為：經常處於戒備狀態，對任何事都沒法放松處理，孤僻性情難以交朋結友。對於愛情，就更加會慎重處理。任何人必須經過你長期觀察及通過連番考驗，方會減除戒備與你交往。",
	"個性系數為 5 ，主人性格類型：[好奇心旺求知欲強型]，其具體表現為：好奇心極度旺盛，求知欲又強，有打爛沙盤問到篤的鍥而不舍精神。此外，你天生有語言天分，學習外文比一般人更易掌握。",
	"個性系數為 6 ，主人性格類型：[做事喜好憑直覺型]，其具體表現為：有特強的第六靈感，性格率直無機心，深得朋輩愛戴。感情路上多采多姿。做事喜好憑個人直覺及預感做決定。",
	"個性系數為 7 ，主人性格類型：[獨斷獨行/吸引人型]，其具體表現為：為人獨斷獨行，事事自行作主解決，鮮有求助他人。而這份獨立個性，正正就是吸引異性的特質。但其實心底裏，卻是渴望有人可讓他/她依賴。",
	"個性系數為 8 ，主人性格類型：[熱情/善變夢想家型]，其具體表現為：對人熱情無遮掩，時常夢想可以談一場戲劇性戀愛，親身體會個中悲歡離合的動人經歷，是個大夢想家。但對於感情卻易變卦。"
};


@implementation AstroDBMng (ForSolidData)

#pragma mark -
#pragma mark 生日速配

/**
 * @brief  查询生日速配结果
 *
 *
 * @n<b>函数名称</b>     :GetBirthDayQuickMathResult
 * @see
 
 * @param manGlDate   男性公历生日
 * @param womanGlDate  女性公历生日
 * @param birthMatchInfo  速配结果对象
 * @return
 * boolean
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-30上午10:41:48      
 */
+(TBirthdayMatch*) GetBirthDayQuickMathResult:(TDateInfo*)manGlDate Woman:(TDateInfo*)womanGlDate
{
	TBirthdayMatch* birthMatchInfo = [TBirthdayMatch new];
	
	int iManBirthCode   = [AstroDBMng ChangeDateToBirthCode:manGlDate];
	int iWomanBirthCode = [AstroDBMng ChangeDateToBirthCode:womanGlDate];
	if (iManBirthCode<=8&&iManBirthCode>=0 && iWomanBirthCode<=8&&iWomanBirthCode>=0)
	{
		birthMatchInfo.nLevel = S_BIRTHDAYRES[iManBirthCode][iWomanBirthCode];
	}
	
    if (IS_FT)
    {
        NSString* strExp = [NSString stringWithCString:S_BIRTHDAYEXPLAIN_FT[iManBirthCode].c_str() encoding:NSUTF8StringEncoding];
        birthMatchInfo.strManBirthExp = [NSString stringWithFormat:@"男生%@", strExp];

        strExp = [NSString stringWithCString:S_BIRTHDAYEXPLAIN_FT[iWomanBirthCode].c_str() encoding:NSUTF8StringEncoding];
        birthMatchInfo.strWomanBirthExp = [NSString stringWithFormat:@"女生%@", strExp];
    }
    else
    {
        NSString* strExp = [NSString stringWithCString:S_BIRTHDAYEXPLAIN[iManBirthCode].c_str() encoding:NSUTF8StringEncoding];
        birthMatchInfo.strManBirthExp = [NSString stringWithFormat:@"男生%@", strExp];
        
        strExp = [NSString stringWithCString:S_BIRTHDAYEXPLAIN[iWomanBirthCode].c_str() encoding:NSUTF8StringEncoding];
        birthMatchInfo.strWomanBirthExp = [NSString stringWithFormat:@"女生%@", strExp];
    }
	
	return [birthMatchInfo autorelease];
}

/**
 * @brief  将公历日期的每位数值相加，变成一个和，并用这个和求出生日信息码，用来计算生日匹配用
 *
 *
 * @n<b>函数名称</b>     :ChangeDateToBirthCode
 * @see
 
 * @param glDate   输入的公历日期
 * @return  生日信息码（0~8）
 * int
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-29下午11:20:00      
 */
+(int) ChangeDateToBirthCode:(TDateInfo*)glDate
{
	int intTemp = glDate.year/1000+(glDate.year%1000)/100+(glDate.year%100)/10+(glDate.year%10)
	+ glDate.month/10 + glDate.month%10 + glDate.day/10 + glDate.day%10;
	
	// 类型分为9种，分别序号为0,1，2,3,4,5,6,7,8
	return (intTemp/10 + intTemp%10)%9;
}


#pragma mark -
#pragma mark 号码测试


/**
 * @brief   测试手机号码的吉凶
 *
 *
 * @n<b>函数名称</b>     :GetTelePhoneJiXResult
 * @see
 
 * @param strTelNumber
 * @return
 * TelephoneJiXiong
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-29下午05:51:53      
 */
+(TTelephoneJiXiong*) GetTelePhoneJiXResult:(NSString*)strTelNumber
{
	NSString* sTelNum = [strTelNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([PubFunction stringIsNullOrEmpty:sTelNum])
	{
		return nil;
	}
	
	//判断是否都是数字
	if (![sTelNum isDecimalDigitString])
	{
		return nil;
	}
	
	//11位手机号
	if ([sTelNum length] != 11)
	{
		return nil;
	}
	
	// 判断第一个数字是不是“1”，不是1的话表示可能不是手机号码。
	NSRange rang = NSMakeRange(0, 1);
	int intFirst = [[sTelNum substringWithRange:rang] intValue];
	if (intFirst != 1)
	{
		return nil;
	}
	
	// 获得手机号码的最后4位
	rang = NSMakeRange(7, 4);
	int intLastFour = [[sTelNum substringWithRange:rang] intValue];
	
	// 获得11位手机号码之和
	int intTelCount = 0;
	for (int i = 0; i < 11; i++)
	{
		rang = NSMakeRange(i, 1);
		intTelCount += [[sTelNum substringWithRange:rang] intValue];
	}
	
	// 手机号码吉凶测试结果
	TTelephoneJiXiong* result = [TTelephoneJiXiong new];
    
    
    if (IS_FT)
    {
        result.strPctemp = [NSString stringWithCString:TelResult_FT[intLastFour%80].c_str() encoding:NSUTF8StringEncoding];
        
        result.strTelResult = [NSString stringWithCString:Personality_FT[intTelCount%9].c_str() encoding:NSUTF8StringEncoding];
    }
    else
    {
        result.strPctemp = [NSString stringWithCString:TelResult[intLastFour%80].c_str() encoding:NSUTF8StringEncoding];
        
        result.strTelResult = [NSString stringWithCString:Personality[intTelCount%9].c_str() encoding:NSUTF8StringEncoding];
    }
	
	return [result autorelease];
}


// 测试QQ号码的吉凶结果
+(TTITLE_EXP*) GetQqNumberTestRes:(NSString*)strQQNumber
{
	TTITLE_EXP* result = [TTITLE_EXP new];
	int iNumber = [AstroDBMng CountNumber:strQQNumber];
	result.sTitle = strQQNumber;
	result.sExplain = [NSString stringWithCString:TelResult[iNumber%80].c_str() encoding:NSUTF8StringEncoding];
	return [result autorelease];
}

/**
 * @brief   获得数字之和
 *
 *
 * @n<b>函数名称</b>     :CountNumber
 * @see
 
 * @param strTemp
 * @return
 * int
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-29下午05:54:10      
 */
+(int) CountNumber:(NSString*)strTemp
{
	int intLenth = [strTemp length];
	int nCount = 0;
	for (int i = 0; i < intLenth; i++)
	{
		NSRange rang = NSMakeRange(i, 1);
		nCount += [[strTemp substringWithRange:rang] intValue];
	}
	return nCount;
}


/**
 * @brief   获取车牌号码的吉凶解释
 *
 *
 * @n<b>函数名称</b>     :GetCarLicensePlataoteResult
 * @see
 
 * @param strProvince  省份的简写，例如   闽A00002 中的“闽”字
 * @param strCityLetter 城市的字母带啊：例如闽A00002 中的 “A”
 * @param strNumber   车牌的主号:例如 闽A00002 中的“00002”
 * @return
 * String
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-29下午05:54:38      
 */
+(NSString*) GetCarLicensePlateResult:(NSString*)strProvince CityLetter:(NSString*)strCityLetter Number:(NSString*)strNumber
{ 
	int iChePaiNum = 0;
	
	// 省份汉字代表的数字
	int iProvNum = [AstroDBMng changeProvinceToNum:strProvince];
	if (iProvNum <= 0)
		return nil;
	
	// 城市26字母代表的数字
	NSString* strTemp;
	int iCityLetterNum = 0;
	if ([strCityLetter length] == 1)
	{
		strTemp = [strCityLetter uppercaseString];
		iCityLetterNum = [strTemp characterAtIndex:0] - 65;
		if (iCityLetterNum < 0)
			return nil;
	}
	
	// 具体车牌号码
	strTemp = [strNumber uppercaseString];
	unichar charEach = 'A';
	for (int i = 0; i < [strTemp length]; i++)
	{
		charEach = [strTemp characterAtIndex:i];
		if (charEach >= '0' and charEach <= '9')
		{
			iChePaiNum += charEach-48;
		}
		else
		{
			iChePaiNum += charEach-65;
		}
	}
	
	if (iChePaiNum < 0)
		return nil;
	
	// 车牌吉凶结果
	int intTotal = iProvNum + iCityLetterNum + iChePaiNum;
    NSString* result = nil;
    if (IS_FT)
        result = [NSString stringWithCString:TelResult_FT[intTotal%80].c_str() encoding:NSUTF8StringEncoding];
    else
        result = [NSString stringWithCString:TelResult[intTotal%80].c_str() encoding:NSUTF8StringEncoding];
	return result;
}

/**
 * @brief 将车牌号省份的简写转换成相应的数理值（根据康熙笔画）
 *
 *
 * @n<b>函数名称</b>     :changeProvinceToNum
 * @see
 
 * @param strProvince  输入的省份简写
 * @return
 * int
 * @<b>作者</b>          :  tanyt
 * @<b>创建时间</b>      :  2011-6-29下午02:49:26      
 */
+(int) changeProvinceToNum:(NSString*)strProvince
{
    NSArray* strs = [LOC_STR("cm_sjc") componentsSeparatedByString:@" "];
    
	if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:0]])
		return 8;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:1]])
		return 12;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:2]])
		return 12;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:3]])
		return 14;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:4]])
		return 5;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:5]])
		return 10;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:6]])
		return 12;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:7]])
		return 20;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:8]])
		return 16;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:9]])
		return 16;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:10]])
		return 12;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:11]])
		return 16;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:12]])
		return 13;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:13]])
		return 6;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:14]])
		return 22;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:15]])
		return 24;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:16]])
		return 19;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:17]])
		return 16;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:18]])
		return 14;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:19]])
		return 8;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:20]])
		return 15;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:21]])
		return 10;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:22]])
		return 15;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:23]])
		return 15;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:24]])
		return 3;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:25]])
		return 10;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:26]])
		return 20;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:27]])
		return 13;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:28]])
		return 12;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:29]])
		return 11;
	else if ([strProvince isEqualToString:(NSString*)[strs objectAtIndex:30]])
		return 13;
	else
		return 0;
}

@end



#pragma mark -
#pragma mark 数据库管理－演示命造专用

@implementation AstroDBMng (ForDemoPeople)

//流势
+(BOOL) getDemoFlowYSDay:(NSString*)userGuid YS:(TFlowYS*)tYunshi
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EYunshiTypeLiuri];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickFlowYSFromQuery:tYunshi Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询流日运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) getDemoFlowYSMonth:(NSString*)userGuid YS:(TFlowYS*)tYunshi;
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EYunshiTypeLiuyue];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickFlowYSFromQuery:tYunshi Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询流月运势失败!");
		return NO;
	}
	
	return NO;
}

//紫微运势
+(BOOL) getDemoZwYsDay:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EYunshiTypeDay];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickZwJsFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询日运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) getDemoZwYsMonth:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EYunshiTypeMonth];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickZwJsFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询月运势失败!");
		return NO;
	}
	
	return NO;
}

+(BOOL) getDemoZwYsYear:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EYunshiTypeYear];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickZwJsFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询年运势失败!");
		return NO;
	}
	
	return NO;
}

//财富趋势
+(BOOL) getDemoLYSMMoney:(NSString*)userGuid YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sGuid='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, userGuid, EMoneyFortune];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickSMMoneyFromQuery:ZwYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询财富趋势失败!");
		return NO;
	}
	
	return NO;
}

//事业成长
+(BOOL) getDemoYsCareer:(NSString*)userGuid YS:(TSYYS_EXT*)SyYs
{
	@try
	{
		NSString* sPepInfo = [AstroDBMng makePeplSumInfoByGUID:userGuid];
		NSString* sql = [NSString stringWithFormat:@"select * from %@ where sPeplSumInfo='%@' and iType='%d' ", 
						 TBL_USR_YUNSHICACHE, sPepInfo,EYunshiTypeCareer];
		CppSQLite3Query query = [[AstroDBMng getDbUserLocal] execQuery:sql];
		
		return [AstroDBMng pickSyYsFromQuery:SyYs Query:&query];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询事业成长失败!");
		return NO;
	}
	
	return NO;
}


@end

