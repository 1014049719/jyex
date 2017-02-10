/*
 *  CateMgr.cpp
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "DBMngAll.h"
#import "CfgMgr.h"

#include <algorithm>
//#import "Global.h"

#import "DbMngDataDef.h"

#import "ComCustomConstantDef.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "BussComdIDDef.h"
#import "CommonAll.h"
#import "BizLogicAll.h"


#pragma mark -
#pragma mark CateMgr类封装

/*
bool compareByName(CateInfo ele1, CateInfo ele2)
{
//    return ele1.strName < ele2.strName;
    NSString* strName1 = [NSString stringWithUnistring:ele1.strName];
    NSString* strName2 = [NSString stringWithUnistring:ele2.strName];
    if ([strName1 compare:strName2 options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strName1 length]) locale:[NSLocale currentLocale]] < 0)
        return true;
    return false;
}

static std::map<GUID, CateInfo> cateMap;
*/


@implementation AstroDBMng (ForCateMgr)


+ (TCateInfo* )getCate_CateMgr:(NSString *)strCateGuid
{
    //未整理文件夹
    if ( [strCateGuid isEqualToString:GUID_ZERO] )
    {
        //生成未整理文件夹
        int nNoteCount = [AstroDBMng getNoteCountByCate:strCateGuid];
        TCateInfo * pCateInfo = [BizLogic createCateInfo];
        pCateInfo.strCatalogName = @"未整理文件夹";
        pCateInfo.nNoteCount = nNoteCount;
        return pCateInfo;
    } 
    
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE catalog_id='%@';",strCateGuid];

		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TCateInfo *pCateInfo = [[TCateInfo new] autorelease];
            pCateInfo.tHead = pHead; 
            
            //NSLog(@"##############3:cateinfo=%@",pCateInfo);
            
            [self objFromQuery_CateMgr:pCateInfo query:&query];
            return pCateInfo;
        }
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表失败!");
		return nil;
	}
	return nil;
}

+ (int)addCate_CateMgr:(TCateInfo* )cateInfo
{
    //cateMap[objCate.guid] = objCate;
    return [self saveToDB_CateMgr:cateInfo];
}

+ (int)updateCate_CateMgr:(TCateInfo* )cateInfo
{
    //cateMap[objCate.guid] = objCate;
    return [self saveToDB_CateMgr:cateInfo];
}

+ (int)saveCate_CateMgr:(TCateInfo* )cateInfo
{
    //cateMap[objCate.guid] = objCate;
    return [self saveToDB_CateMgr:cateInfo];
}


//更改某个目录的记录总数
+ (int)updateCateNoteCount_CateMgr:(NSString *)strCateGuid notecount:(int)count
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE tb_catalog_info set note_count=%d WHERE catalog_id='%@';",count,strCateGuid];
    return [[AstroDBMng getDb91Note] execDML:sql];
}


//获取某个目录的下一级所有目录列表
+ (NSArray*)getCateList_CateMgr:(NSString *)strCateGuid
{
     NSMutableArray* aryData = [NSMutableArray array];
    
    @try
	{
        for (int jj=0;jj<3;jj++)
        {
            if ( 0 == jj ) {
                if ( ![strCateGuid isEqualToString:GUID_ZERO] ) continue;
                
                //生成未整理文件夹
                int nNoteCount = [AstroDBMng getNoteCountByCate:strCateGuid];
                if ( nNoteCount <= 0 ) continue;
                
                TCateInfo * pCateInfo = [BizLogic createCateInfo];
                pCateInfo.strCatalogIdGuid = GUID_ZERO;
                pCateInfo.strCatalogName = @"未整理文件夹";
                pCateInfo.nNoteCount = nNoteCount;
                [aryData addObject:pCateInfo];
                continue;
            }
            
            NSString* sql;
            if ( 1 == jj )
                sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE catalog_belong_to='%@' AND delete_state=%d AND mobile_flag=1;",strCateGuid,DELETESTATE_NODELETE];
            else if ( 2 == jj )//本地的
                sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE catalog_belong_to='%@' AND delete_state=%d AND mobile_flag!=1 ORDER BY catalog_order asc,catalog_name asc;",strCateGuid,DELETESTATE_NODELETE]; //AND mobile_flag>=10, order by mobile_flag asc,
           // else if ( jj == 2)  //PC的
           //     sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE catalog_belong_to='%@' AND delete_state=%d AND mobile_flag<=0 ORDER BY catalog_order asc,catalog_name asc;",strCateGuid,DELETESTATE_NODELETE];
            //else
            //    sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info;"];
        
            CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
            while ( !query.Eof()) 
            { 
                TRecHead * tHead = [[TRecHead new] autorelease];
                TCateInfo* cateInfo = [[TCateInfo new] autorelease];
                cateInfo.tHead = tHead;
            
                //NSLog(@"##############4:cateinfo=%@",cateInfo);
            
                [self objFromQuery_CateMgr:cateInfo query:&query];
                [aryData addObject:cateInfo];
			
                query.NextRow();
            }
        }
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表失败!");
		return nil;
	}
	return nil;
}

//获取所有有效目录
+ (NSArray*)getAllCateList_CateMgr
{
    NSMutableArray* aryData = [NSMutableArray array];
    
    @try
	{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE delete_state=%d;",DELETESTATE_NODELETE];
         
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        while ( !query.Eof()) 
        { 
            TRecHead * tHead = [[TRecHead new] autorelease];
            TCateInfo* cateInfo = [[TCateInfo new] autorelease];
            cateInfo.tHead = tHead;
                
            //NSLog(@"##############4:cateinfo=%@",cateInfo);
                
            [self objFromQuery_CateMgr:cateInfo query:&query];
            [aryData addObject:cateInfo];
                
            query.NextRow();
        }
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表失败!");
		return nil;
	}
	return nil;   
}

//获取需上传的目录列表
+ (NSArray*)getNeedUploadCateList_CateMgr
{
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"SELECT catalog_id FROM tb_catalog_info WHERE edit_state=%d;",EDITSTATE_EDITED];
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		while ( !query.Eof()) 
		{ 
            NSString *strNoteIdGuid = [NSString stringWithUTF8String:query.GetStringField("catalog_id","")];   //笔记编号
 			[aryData addObject:strNoteIdGuid];
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表guid失败!");
		return nil;
	}
	return nil;    
}


//更改某个目录下的所有子目录(包括子子目录)到另外一个目录
+ (void)updateCateListIncludeSubDir_CateMgr:(NSString *)strCateGuid to:(NSString *)strDestGuid
{
    @try
	{
        NSString* sql;
        sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info;"];
            
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        while ( !query.Eof()) 
        { 
            TRecHead * tHead = [[TRecHead new] autorelease];
            TCateInfo* cateInfo = [[TCateInfo new] autorelease];
            cateInfo.tHead = tHead;
                
            //NSLog(@"##############4:cateinfo=%@",cateInfo);
                
            [self objFromQuery_CateMgr:cateInfo query:&query];
            
            int flag = 0;
            for (int i=0;i<7;i++) {
                NSString *strGuid;
                if (i==0 ) strGuid = cateInfo.strCatalogBelongToGuid;
                else if (i==1 ) strGuid = cateInfo.strCatalogPaht1Guid;
                else if (i==2 ) strGuid = cateInfo.strCatalogPaht2Guid;
                else if (i==3 ) strGuid = cateInfo.strCatalogPaht3Guid;
                else if (i==4 ) strGuid = cateInfo.strCatalogPaht4Guid;
                else if (i==5 ) strGuid = cateInfo.strCatalogPaht5Guid;
                else if (i==6 ) strGuid = cateInfo.strCatalogPaht6Guid;
                
                if ( [strGuid isEqualToString:GUID_ZERO] ) break;
                
                if ( [strGuid isEqualToString:strCateGuid] ) {
                    flag = 1;
                    if (i==0 ) cateInfo.strCatalogBelongToGuid = strDestGuid;
                    else if (i==1 ) cateInfo.strCatalogPaht1Guid = strDestGuid;
                    else if (i==2 ) cateInfo.strCatalogPaht2Guid = strDestGuid;
                    else if (i==3 ) cateInfo.strCatalogPaht3Guid = strDestGuid;
                    else if (i==4 ) cateInfo.strCatalogPaht4Guid = strDestGuid;
                    else if (i==5 ) cateInfo.strCatalogPaht5Guid = strDestGuid;
                    else if (i==6 ) cateInfo.strCatalogPaht6Guid = strDestGuid;
                }
            }
            
            if ( 1 == flag ) {
                cateInfo.tHead.nEditState = EDITSTATE_EDITED;
                cateInfo.tHead.strModTime = [CommonFunc getCurrentTime];  //需要跟踪
                [self updateCate_CateMgr:cateInfo];
            }
                            
            query.NextRow();
        }
        
		return;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更改子目录信息失败!");
		return;
	}
	return;
}


//删除某个目录下的所有子目录(包括子子目录)
+ (int)deleteCateListIncludeSubDir_CateMgr:(NSString *)strCateGuid
{
    int count = 0;
    
    @try
	{
        NSString* sql;
        sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info;"];
        
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        while ( !query.Eof()) 
        { 
            TRecHead * tHead = [[TRecHead new] autorelease];
            TCateInfo* cateInfo = [[TCateInfo new] autorelease];
            cateInfo.tHead = tHead;
            
            //NSLog(@"##############4:cateinfo=%@",cateInfo);
            
            [self objFromQuery_CateMgr:cateInfo query:&query];
            
            int flag = 0;
            for (int i=0;i<7;i++) {
                NSString *strGuid;
                if (i==0 ) strGuid = cateInfo.strCatalogBelongToGuid;
                else if (i==1 ) strGuid = cateInfo.strCatalogPaht1Guid;
                else if (i==2 ) strGuid = cateInfo.strCatalogPaht2Guid;
                else if (i==3 ) strGuid = cateInfo.strCatalogPaht3Guid;
                else if (i==4 ) strGuid = cateInfo.strCatalogPaht4Guid;
                else if (i==5 ) strGuid = cateInfo.strCatalogPaht5Guid;
                else if (i==6 ) strGuid = cateInfo.strCatalogPaht6Guid;
                
                if ( [strGuid isEqualToString:GUID_ZERO] ) break;
                
                if ( [strGuid isEqualToString:strCateGuid] ) {
                    flag = 1;
                    if (i==0 ) cateInfo.strCatalogBelongToGuid = GUID_ZERO;
                    else if (i==1 ) cateInfo.strCatalogPaht1Guid = GUID_ZERO;
                    else if (i==2 ) cateInfo.strCatalogPaht2Guid = GUID_ZERO;
                    else if (i==3 ) cateInfo.strCatalogPaht3Guid = GUID_ZERO;
                    else if (i==4 ) cateInfo.strCatalogPaht4Guid = GUID_ZERO;
                    else if (i==5 ) cateInfo.strCatalogPaht5Guid = GUID_ZERO;
                    else if (i==6 ) cateInfo.strCatalogPaht6Guid = GUID_ZERO;
                }
            }
            
            if ( 1 == flag ) {
                cateInfo.tHead.nEditState = EDITSTATE_EDITED;
                cateInfo.tHead.strModTime = [CommonFunc getCurrentTime];  //需要跟踪
                cateInfo.tHead.nDelState = DELETESTATE_DELETE;
                [self updateCate_CateMgr:cateInfo];
                count++;
            }
                        
            query.NextRow();
        }
        
		return count;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除子目录信息失败!");
		return 0;
	}
	return 0;
}


//搜索目录的标题是否含有关键字
+ (NSArray*)getCateListBySearch_CateMgr:(NSString *)strKey catalog:(NSString *)strCatalog
{
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE delete_state=%d AND catalog_name like '%%%@%%';",DELETESTATE_NODELETE,strKey];
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		while ( !query.Eof()) 
		{ 
            TRecHead * tHead = [[TRecHead new] autorelease];
			TCateInfo* cateInfo = [[TCateInfo new] autorelease];
			cateInfo.tHead = tHead;

            //NSLog(@"##############5:cateinfo=%@",cateInfo);
            
            [self objFromQuery_CateMgr:cateInfo query:&query];
            
            if (strCatalog && strCatalog.length > 0 ) {
                if ( [strCatalog isEqualToString:cateInfo.strCatalogPaht1Guid] 
                  || [strCatalog isEqualToString:cateInfo.strCatalogPaht2Guid]
                  || [strCatalog isEqualToString:cateInfo.strCatalogPaht3Guid]
                  || [strCatalog isEqualToString:cateInfo.strCatalogPaht4Guid]
                  || [strCatalog isEqualToString:cateInfo.strCatalogPaht5Guid]
                  || [strCatalog isEqualToString:cateInfo.strCatalogPaht6Guid]
                    ) 
                    [aryData addObject:cateInfo];
            }
            else {
                [aryData addObject:cateInfo];
            }
			
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表失败!");
		return nil;
	}
	return nil;    
}


//获取指定mobile_flag 的文件夹
+ (NSArray*)getCateListByMobileFlag_CateMgr:(int)mobile_flag
{
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_info WHERE delete_state=%d AND mobile_flag=%d;",DELETESTATE_NODELETE,mobile_flag];
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		while ( !query.Eof()) 
		{ 
            TRecHead * tHead = [[TRecHead new] autorelease];
			TCateInfo* cateInfo = [[TCateInfo new] autorelease];
			cateInfo.tHead = tHead;
            
            //NSLog(@"##############5:cateinfo=%@",cateInfo);
            
            [self objFromQuery_CateMgr:cateInfo query:&query];
 
            [aryData addObject:cateInfo];
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录信息表失败!");
		return nil;
	}
	return nil;     
}


+ (int)getCateCount
{
    NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM tb_catalog_info ;"];
    @try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        if ( !query.Eof()) 
        { 
            int count = query.GetIntField(0, 0);
            return count;
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"SQL: %@\n Exception:%@", sql,[e reason]);
    }

    return 0;
}


+ (int)getNoteCountInCate_CateMgr:(NSString *)strCateGuid includeSubDir:(BOOL)includeSubDir
{
    int noteCount = 0;
    TCateInfo* cateInfo = [self getCate_CateMgr:strCateGuid];
    if ( !cateInfo ) return 0;
    
    NSMutableArray* aryData = [NSMutableArray array];
    [aryData addObject:cateInfo];
    
    for (int i=0; i<[aryData count]; i++)
    {
        TCateInfo *curCateInfo = [aryData objectAtIndex:i];
        if (includeSubDir )  //包括子文件夹
        {
            NSArray *arrSubCate= [self getCateList_CateMgr:curCateInfo.strCatalogIdGuid];
            if ( [arrSubCate isKindOfClass:[NSArray class]] && [arrSubCate count]>0 )
            {
                [aryData addObjectsFromArray:arrSubCate];
            }
        }
        
        //获取笔记数量
        NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM tb_note_info WHERE catalog_id='%@' AND delete_state=%d;",curCateInfo.strCatalogIdGuid,DELETESTATE_NODELETE];
        @try
        {
            CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
            if ( !query.Eof()) 
            { 
                noteCount += query.GetIntField(0, 0);
             }
        }
        @catch (NSException * e)
        {
            NSLog(@"SQL: %@\n Exception:%@", sql,[e reason]);
            continue;
        }
    }
    return noteCount;
}


/*
+ (BOOL)isSubCate:(GUID)guidParent subCate:(GUID)guidSubCate
{
    if (cateMap.find(guidSubCate) == cateMap.end())
        return NO;
    
    if (guidParent == guidSubCate)
        return YES;
    
    CateInfo objCate = cateMap[guidSubCate];
    for (int i = 0; i < MAX_PATH_DEPTH; i++)
    {
        if (objCate.guidPath[i] == guidParent)
            return YES;
    }
    
    return NO;
}
*/
    
+ (BOOL)isSubCate_CateMgr:(NSString *)strParentGuid subCate:(NSString *)strSubGuid
{
    BOOL bRet = NO;
    
    TCateInfo* cateInfo = [self getCate_CateMgr:strSubGuid];
    if ( !cateInfo ) return NO;
    
    if ( [strParentGuid isEqualToString:cateInfo.strCatalogPaht1Guid] 
         || [strParentGuid isEqualToString:cateInfo.strCatalogPaht2Guid]
         || [strParentGuid isEqualToString:cateInfo.strCatalogPaht3Guid]
         || [strParentGuid isEqualToString:cateInfo.strCatalogPaht4Guid]
         || [strParentGuid isEqualToString:cateInfo.strCatalogPaht5Guid]
         || [strParentGuid isEqualToString:cateInfo.strCatalogPaht6Guid]
       ){
        bRet = YES;
    }
    
    return bRet;
}
    
    

+ (int)getCateMaxVersion_CateMgr
{
    NSString *strValue;
    if ( ![AstroDBMng getCfg_cfgMgr:@"tb_catalog_info" name:@"tableMaxVer" value:strValue] )
        return 0;
    
    int maxVer = [strValue intValue];
    return maxVer;
}

+ (BOOL)setCateMaxVersion_CateMgr:(int)version
{
    NSString *strValue = [NSString stringWithFormat:@"%d",version];
    return [AstroDBMng setCfg_cfgMgr:@"tb_catalog_info" name:@"tableMaxVer" value:strValue];
}

/*
+ (int)getTableDirVersion:(GUID)guidDir tableName:(string)strTable
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    int version = 0;
    string strSQL = "select * from tb_catalog_version_info where catalog_belong_to='" + [CommonFunc guidToString:guidDir] 
                    + "' and table_name='" + strTable + "';";
    try
    {
        CppSQLite3Query query = [[DBObject shareDB] execQuery:strSQL.c_str()];
        if (!query.eof())
        {
            version = query.getIntField("max_ver", 0);
        }
        query.finalize();
    }
    catch (CppSQLite3Exception e) 
    {
        MLOG(@"SQL: %s\n Exception:%s", strSQL.c_str(), e.errorMessage());
        return version;
    }
    return version;
}
*/

+ (int)getTableDirVersion_CateMgr:(NSString *)strCateGuid tableName:(NSString *)strTableName
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_catalog_version_info WHERE catalog_belong_to='%@' AND table_name='%@';",strCateGuid,strTableName];
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        
        int version = 0;
		if ( !query.Eof()) 
		{ 
            version = query.GetIntField("max_ver", 0);
		}
		
		return version;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询目录失败!");
		return 0;
	}
	return 0;
}


//更改文件夹版本信息表
+ (int)setTableDirVersion_CateMgr:(TCatalogVersionInfo *)obj
{
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"replace into %@"
						 "( [user_id],"
						 "[catalog_belong_to], "
						 "[table_name], "
						 "[max_ver] )"
						 "values(?,?,?,?);",
						 TB_CATALOG_VERSION_INFO];
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新目录版本信息出错");
			return -1;
		}
		
		int i = 1;
		stmt.Bind(i++, obj.nUserID);
		stmt.Bind(i++, [obj.strCatalogBelongToGuid UTF8String]);
		stmt.Bind(i++, [obj.strTableName UTF8String]);
		stmt.Bind(i++, obj.nMaxVer);
		
		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新目录版本信息出错");
		return -1;
	}
	return -1;    
    
}


//数据库操作
+ (int)saveToDB_CateMgr:(TCateInfo*)obj
{
    /*
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    char szBCDVerfyData[2 * sizeof(obj.szVerifyData) + 1];
    BCDToStr((unsigned char*) obj.szVerifyData, sizeof(obj.szVerifyData), szBCDVerfyData, 0);
	szBCDVerfyData[sizeof(szBCDVerfyData) - 1] = 0;
    
	string strSQL = "REPLACE INTO tb_catalog_info (" + [super commonFields] + ","
    + "catalog_id, catalog_path1, catalog_path2, catalog_path3, catalog_path4, catalog_path5, "
    + "catalog_path6, catalog_belong_to, catalog_order, encrypt_flag, catalog_name, verify_data"
    + ") values(" + [super commonFieldsValue:obj.tHead] + 
    + "'" + [CommonFunc guidToString:obj.guid] + "', "			// 自身GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[0]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[1]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[2]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[3]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[4]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidPath[5]] + "', "	// 父文件夹GUID
    + "'" + [CommonFunc guidToString:obj.guidBelongTo] + "', "	// 父文件夹GUID
    + [CommonFunc i2a:obj.nOrder] + ", "					// 排列位置
    + [CommonFunc i2a:obj.nEncryptFlag] + ", "				// 加密标识
    + "'" + [CommonFunc transSqliteStrW:obj.strName] + "',"		// 名称
    + "'" + string(szBCDVerfyData) +"');";
    
    try
    {
        CppSQLite3Statement stmt = [[DBObject shareDB] compileStatement:strSQL.c_str()];
        stmt.execDML();   
    }
    catch(CppSQLite3Exception& e)
    {
        MLOG(@"SQL: %s\n Exception:%s", strSQL.c_str(), e.errorMessage());
        return NO;
    }
    
    return YES;
    */
    
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"replace into %@"
						 "( [user_id],"
						 "[curr_ver], "
						 "[create_ver], "
						 "[create_time], "
						 "[modify_time], "
						 "[delete_state], "
						 "[edit_state], "
						 "[conflict_state], "
						 "[sync_state], "
						 "[need_upload], "
                         
						 "[catalog_id], "
						 "[catalog_belong_to], "
						 "[catalog_path1], "
						 "[catalog_path2], "
						 "[catalog_path3], "
						 "[catalog_path4], "
						 "[catalog_path5], "
						 "[catalog_path6], "
						 "[catalog_order], "
						 "[catalog_name], "
						 "[encrypt_flag], "
						 "[verify_data], "
						 "[server_type], "
						 "[catalog_color], "
						 "[catalog_icon], "
						 "[mobile_flag], "
						 "[note_count] )"
						 "values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);",
						 TB_CATALOG_INFO];
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新目录信息出错");
			return -1;
		}
		
		int i = 1;
		stmt.Bind(i++, obj.tHead.nUserID);
		stmt.Bind(i++, obj.tHead.nCurrVerID);
		stmt.Bind(i++, obj.tHead.nCreateVerID);
		stmt.Bind(i++, [obj.tHead.strCreateTime UTF8String]);
		stmt.Bind(i++, [obj.tHead.strModTime UTF8String]);
		stmt.Bind(i++, obj.tHead.nDelState);
		stmt.Bind(i++, obj.tHead.nEditState);
		stmt.Bind(i++, obj.tHead.nConflictState);
		stmt.Bind(i++, obj.tHead.nSyncState);
		stmt.Bind(i++, obj.tHead.nNeedUpload);
        
		stmt.Bind(i++, [obj.strCatalogIdGuid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogBelongToGuid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht1Guid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht2Guid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht3Guid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht4Guid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht5Guid UTF8String]);
		stmt.Bind(i++, [obj.strCatalogPaht6Guid UTF8String]);
		stmt.Bind(i++, obj.nOrder);
		stmt.Bind(i++, [obj.strCatalogName UTF8String]);
		stmt.Bind(i++, obj.nEncryptFlag);
		stmt.Bind(i++, [obj.strVerifyData UTF8String]);
		stmt.Bind(i++, obj.nCatalogType);
		stmt.Bind(i++, obj.nCatalogColor);
		stmt.Bind(i++, obj.nCatalogIcon);
		stmt.Bind(i++, obj.nMobileFlag);
		stmt.Bind(i++, obj.nNoteCount);
		
		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新目录信息表出错");
		return -1;
	}
	return -1;    
    
}

+ (BOOL)objFromQuery_CateMgr:(TCateInfo*)cateInfo query:(CppSQLite3Query*)query
{
    cateInfo.tHead.nUserID = query->GetIntField("user_id", 0); // 用户编号
    cateInfo.tHead.nCurrVerID = query->GetIntField("curr_ver", 0);                // 当前版本号
    cateInfo.tHead.nCreateVerID = query->GetIntField("create_ver", 0);             // 创建版本号
        
    cateInfo.tHead.strCreateTime = [NSString stringWithUTF8String:query->GetStringField("create_time","")];     // 创建时间
    cateInfo.tHead.strModTime = [NSString stringWithUTF8String:query->GetStringField("modify_time","")];      // 修改时间
        
    cateInfo.tHead.nDelState = query->GetIntField("delete_state", 0);                 // 删除状态
    cateInfo.tHead.nEditState = query->GetIntField("edit_state", 0);                // 编辑状态
    cateInfo.tHead.nConflictState = query->GetIntField("conflict_state", 0);             // 冲突状态
    cateInfo.tHead.nSyncState = query->GetIntField("sync_state", 0);                 // 同步状态，1表示正在同步
    cateInfo.tHead.nNeedUpload = query->GetIntField("need_upload", 0);                // 是否上传
        
        
    cateInfo.strCatalogIdGuid = [NSString stringWithUTF8String:query->GetStringField("catalog_id","")];   // 目录编号;
    cateInfo.strCatalogBelongToGuid = [NSString stringWithUTF8String:query->GetStringField("catalog_belong_to","")];  //当前目录上一级目录
    cateInfo.strCatalogPaht1Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path1","")]; //第一级目录位置
    cateInfo.strCatalogPaht2Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path2","")]; //第二级目录位置
    cateInfo.strCatalogPaht3Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path3","")]; //第三级目录位置
    cateInfo.strCatalogPaht4Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path4","")]; //第四级目录位置
    cateInfo.strCatalogPaht5Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path5","")]; //第五级目录位置
    cateInfo.strCatalogPaht6Guid = [NSString stringWithUTF8String:query->GetStringField("catalog_path6","")]; //第六级目录位置
    
    cateInfo.nOrder = query->GetIntField("catalog_order", 0);                     // 排列位置
    cateInfo.strCatalogName = [NSString stringWithUTF8String:query->GetStringField("catalog_name","")];;       // 目录名称
    cateInfo.nEncryptFlag = query->GetIntField("encrypt_flag", 0);			// 加密标识(是否加密)
    cateInfo.strVerifyData = [NSString stringWithUTF8String:query->GetStringField("verify_data","")];		// 验证密码
        
    cateInfo.nCatalogType = query->GetIntField("server_type", 0);   //目录类型  (以下为新增的)
    cateInfo.nCatalogColor = query->GetIntField("catalog_color", 0);   //目录颜色
    cateInfo.nCatalogIcon = query->GetIntField("catalog_icon", 0);   //目录图标
    cateInfo.nMobileFlag = query->GetIntField("mobile_flag", 0);    //手机目录标志
    cateInfo.nNoteCount = query->GetIntField("note_count", 0);     //笔记数量
    
    cateInfo.nCurdayNoteCount = 0;  //不是从数据库中读出来的。
    
    //int  nIsRoot;        // 是否是根目录 （服务端没有，这个还需要吗）    
         
    //NSLog(@"**catalog:%@ %@ edit:%d needdown:%d delete:%d",cateInfo.strCatalogName,cateInfo.strCatalogIdGuid,
    //      cateInfo.tHead.nEditState,cateInfo.tHead.nNeedUpload,cateInfo.tHead.nDelState);
    
    //NSLog(@"**catalog:strCatalogIdGuid=%p,strCatalogName=%p",cateInfo.strCatalogIdGuid,cateInfo.strCatalogName);
    
    /*    
    [super headFromQuery:query head:&obj->tHead];
    
    obj->guid = [CommonFunc stringToGUID:query->getStringField("catalog_id", "")];
    obj->guidBelongTo = [CommonFunc stringToGUID:query->getStringField("catalog_belong_to", "")];
    
    for (int i = 0; i < MAX_PATH_DEPTH; i++)
    {
        char szFieldName[32] = {0};
        sprintf(szFieldName, "catalog_path%d", i + 1);
		obj->guidPath[i] = [CommonFunc stringToGUID:query->getStringField(szFieldName, "")];
    }
    
    obj->nOrder = query->getIntField("catalog_order", 0);
    obj->nEncryptFlag = query->getIntField("encrypt_flag", 0);
    const char* pszData = query->getStringField("verify_data", "");
    StrToBCD((char*) pszData, obj->szVerifyData, 0);
    string str = query->getStringField("catalog_name", "");
    obj->strName = [CommonFunc utf8ToUnicode:str];
     */    
    return YES;
}

@end
