//
//  NoteMgr.m
//  NoteBook
//
//  Created by wangsc on 10-9-15.
//  Copyright 2010 ND. All rights reserved.
//

#import "NoteMgr.h"
#import "Note2ItemMgr.h"
#import "ItemMgr.h"
#import "CateMgr.h"
#import "CfgMgr.h"

#include <algorithm>
#include <map>

#include "logging.h"
#import "CommonNoteOpr.h"
#import "CommonDirectory.h"
#import "GlobalVar.h"

//static std::map<GUID, WORK_KEY_INFO> decrypedNoteMap;    //已解密笔记

/*
bool compareByModifyTime(NoteInfo ele1, NoteInfo ele2)
{
//    return unistring(ele1.tHead.wszModTime) < unistring(ele2.tHead.wszModTime);
    return unistring(ele2.tHead.wszModTime) < unistring(ele1.tHead.wszModTime);
}
*/


@implementation AstroDBMng (ForNoteMgr)


+(BOOL) loadDb91Note
{
	return [AstroDBMng loadDb91Note:TheCurUser.sUserName];
}

+(BOOL) loadDb91Note:(NSString*) userName
{
	BOOL bExist = [CommonFunc EnsureDbFileExist:EDbType91Note UserName:userName];
	if (!bExist)
	{
		LOG_ERROR(@"数据库文件不存在。 username=%@", userName);
		return NO;
	}
	
	DbItem *dbuser = [AstroDBMng getDb91Note];
	if (!dbuser)
	{
		LOG_ERROR(@"数据库对象不存在。 username=%@", userName);
		return NO;
	}
	
	BOOL bOpened = [dbuser openWithType:EDbType91Note];
	LOG_INFO(@"加载用户数据库. username=%@,  result=%d", userName, bOpened);
    
    
    //创建表
    [AstroDBMng create91NoteTables];
    
    //表结构检查(1.2.5 到 1.3)
    BOOL ret = [AstroDBMng check91NoteTables_V125_To_V130];
    
    if ( ret ) {
        //需统计每个目录的记录数
        NSArray *arr = [AstroDBMng getAllCateList_CateMgr];
        if ( arr ) {
            for ( id obj in arr ) {
                TCateInfo *pCateInfo = obj;
                int notecount = [AstroDBMng getNoteCountInCate_CateMgr:pCateInfo.strCatalogIdGuid includeSubDir:YES];
                //更改当前目录总的记录数
                [AstroDBMng updateCateNoteCount_CateMgr:pCateInfo.strCatalogIdGuid notecount:notecount];
                NSLog(@"catalog guid:%@ notecount:%d (%@)",pCateInfo.strCatalogIdGuid,notecount,pCateInfo.strCatalogName);
            }
        }
    }
    
	return bOpened;
}


+(BOOL) CloseDb91Note	//关闭
{
	return [[AstroDBMng getDb91Note] close];
}


+ (BOOL)addNote:(TNoteInfo *)objNote
{
    return [self saveNote:objNote];
}

+ (TNoteInfo*)getNote:(NSString *)strNoteGuid
{

	@try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE note_id='%@';",strNoteGuid];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteInfo *pNoteInfo = [[TNoteInfo new] autorelease];
            pNoteInfo.tHead = pHead; 
            
            [self objFromQuery_NoteMgr:pNoteInfo query:&query];
            
            return pNoteInfo;
		}
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表失败!");
		return nil;
	}
	return nil;
    
}

+ (BOOL)updateNote:(TNoteInfo*)objNote
{
    //[CommonFunc updateHead:objNote.tHead];
    return [self saveToDB_NoteMgr:objNote];
}

+ (BOOL)resetNote:(TNoteInfo* )objNote 
{
	//[CommonFunc resetHead:objNote.tHead];
	return [self saveToDB_NoteMgr:objNote];
}

+ (BOOL)deleteNote:(NSString *)guidNote
{
    TNoteInfo *noteInfo;
    if (!( noteInfo = [self getNote:guidNote]))
    {
        return NO;
    }
    
    if (noteInfo.tHead.nCurrVerID == 0)
    {
        //直接删除
        [self deleteNoteFromDB:guidNote];
    }
    else
    {
        //[CommonFunc updateHead:noteInfo.tHead];
        noteInfo.tHead.nDelState = DELETESTATE_DELETE;
        
        [self saveNote:noteInfo];
    }
    
    //删除Note2Item 和 Item;
    [AstroDBMng deleteNote2ItemAndItemByNote:guidNote];
    
    return YES;
}

+ (BOOL)deleteNoteFromDB:(NSString *)strNoteGuid
{
    BOOL bRet = NO;
	@try
	{
		NSString* sql = [NSString stringWithFormat:@"DELETE FROM tb_note_info WHERE note_id='%@'", strNoteGuid];
		[[AstroDBMng getDb91Note] execDML:sql];
		bRet = YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除笔记信息失败!");
	}
	return bRet;
    
}

+ (BOOL)saveNote:(TNoteInfo *)objNote
{
    return [self saveToDB_NoteMgr:objNote];
}



+ (NSArray *)getNoteListBySQL:(NSString *)strSQL count:(int)nLimitCount
{
    @try
	{
        int nNowCount=0;
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteInfo *noteInfo = [[TNoteInfo new] autorelease];
            noteInfo.tHead = pHead;
			
            [self objFromQuery_NoteMgr:noteInfo query:&query];
			[aryData addObject:noteInfo];
            
            nNowCount++;
            if ( nLimitCount>0 && nNowCount>= nLimitCount ) break;
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表失败!");
		return nil;
	}
	return nil;
    
    //sort(pNoteList->begin(), pNoteList->end(), compareByModifyTime);
    //return YES;
}

+ (NSArray *)getNoteListByCate:(NSString *)strCateGuid
{
    //根据更新时间排序
    
    //NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE catalog_id='%@' AND delete_state=%d ORDER BY modify_time desc;",strCateGuid,DELETESTATE_NODELETE];
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE catalog_id='%@' ORDER BY modify_time desc;",strCateGuid];
        
    return [self getNoteListBySQL:sql count:0];
        
    //sort(pNoteList->begin(), pNoteList->end(), compareByModifyTime);
    //return YES;
}

/*
+ (NSArray *)getMostRecentNotes:(int)count
{
    //根据更新时间排序
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE delete_state=%d ORDER BY modify_time desc;",DELETESTATE_NODELETE];
    return [self getNoteListBySQL:sql count:count];
}
*/

/*
+ (NSArray *)getUnuploadNoteList:(BOOL)includeDelete
{
    NSString* sql;
    
    if ( includeDelete )
        sql =[NSString stringWithFormat:@"select * from tb_note_info where edit_state=%d;",EDITSTATE_EDITED];
    else sql = [NSString stringWithFormat:@"select * from tb_note_info where edit_state=%d AND delete_state=%d;",EDITSTATE_EDITED,DELETESTATE_NODELETE];  //不包括删除的
    
    return [self getNoteListBySQL:sql count:0];
    
}
*/


//获取一条需上传的笔记
/*
+ (TNoteInfo*)getOneNoteNeedUpload
{
    NSString* sql;
    
    sql =[NSString stringWithFormat:@"select * from tb_note_info where edit_state=%d;",EDITSTATE_EDITED];
 
    NSArray *arrNote = [self getNoteListBySQL:sql count:1];
    if ( arrNote && [arrNote count]> 0 ) return [arrNote objectAtIndex:0];
    return nil;
}
*/

/*
+ (NSArray *)getNoteByFirstItemID:(NSString *)guidFirstItem
{
 
    NSString* sql = [NSString stringWithFormat:@"select * from tb_note_info where first_item= '%@';",guidFirstItem];
    return [self getNoteListBySQL:sql count:0];
}
*/

/*
+ (int)needUploadNotesCount
{
    NSString* sql = [NSString stringWithFormat:@"select count(note_id) from tb_note_info where edit_state=%d;",EDITSTATE_EDITED];
    
    try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
        {        
            int nRet = query.GetIntField(0, 0);
            return nRet;
        }
    }
    catch (CppSQLite3Exception e) 
    {
        return 0;
    }
    return 0;
}
*/ 

//返回需同步的记录数(包括上传和下载)
+ (int)needSyncNotesCount
{
    //NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM tb_note_info;"];
    NSString* sql = [NSString stringWithFormat:@"SELECT count(*) FROM tb_note_info WHERE edit_state=%d;",EDITSTATE_EDITED];
    
    try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
        {        
            int nRet = query.GetIntField(0, 0);
            return nRet;
        }
    }
    catch (CppSQLite3Exception e) 
    {
        return 0;
    }
    return 0;    
}

//返回需上传的笔记的Guid
+ (NSArray *)getNeedUploadNoteListGuid
{
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
        
        //根据更新时间排序
        NSString* strSQL = [NSString stringWithFormat:@"SELECT note_id FROM tb_note_info WHERE edit_state=%d ORDER BY modify_time desc;",EDITSTATE_EDITED]; 
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            NSString *strNoteIdGuid = [NSString stringWithUTF8String:query.GetStringField("note_id","")];   //笔记编号
 			[aryData addObject:strNoteIdGuid];
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表笔记guid失败!");
		return nil;
	}
	return nil;    
}


+ (NSArray *)getNeedDownNoteList:(NSString *)guidCate recursive:(BOOL)recursive
{
     
    NSString *strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE need_downlord=%d AND delete_state=%d;",DOWNLOAD_NEED,DELETESTATE_NODELETE];
  
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteInfo *noteInfo = [[TNoteInfo new] autorelease];
            noteInfo.tHead = pHead;
			
            [self objFromQuery_NoteMgr:noteInfo query:&query];
            
            
            //if (noteInfo.tHead.nDelState == DELETESTATE_NODELETE && noteInfo.nNeedDownlord)
            //{
                if ( !guidCate || [guidCate isEqualToString:@""] )
                {
                    NSString *strNote = [noteInfo.strNoteIdGuid copy];
                    [aryData addObject:strNote];
                    [strNote release];  
                }
                else if ([guidCate isEqualToString:noteInfo.strCatalogIdGuid])
                {
                    NSString *strNote = [noteInfo.strNoteIdGuid copy];
                    [aryData addObject:strNote];
                    [strNote release];
                }
                else if (recursive && ![guidCate isEqualToString:GUID_ZERO] && [AstroDBMng isSubCate_CateMgr:guidCate subCate:noteInfo.strCatalogIdGuid])
                {
                    NSString *strNote = [noteInfo.strNoteIdGuid copy];
                    [aryData addObject:strNote];
                    [strNote release];
                }
            //}

			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表失败!");
		return nil;
	}
	return nil;
}    
    

//返回目录所有笔记的Guid
+ (NSArray *)getNoteListGuidByCate:(NSString *)strCateGuid
{
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
        
        //根据更新时间排序
        NSString* strSQL = [NSString stringWithFormat:@"SELECT note_id FROM tb_note_info WHERE catalog_id='%@' AND delete_state=%d ORDER BY modify_time desc;",strCateGuid,DELETESTATE_NODELETE];  //不包括删除的
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            NSString *strNoteIdGuid = [NSString stringWithUTF8String:query.GetStringField("note_id","")];   //笔记编号
 			[aryData addObject:strNoteIdGuid];
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表笔记guid失败!");
		return nil;
	}
	return nil;    
}


//返回目录所有的笔记（包括子目录)
+ (NSArray *)getNoteListByCateIncludeSub:(NSString *)guidCate
{
    NSString *strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_note_info WHERE delete_state=%d;",DELETESTATE_NODELETE];
    
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof())
		{
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteInfo *noteInfo = [[TNoteInfo new] autorelease];
            noteInfo.tHead = pHead;
			
            [self objFromQuery_NoteMgr:noteInfo query:&query];
            
            
            if ([guidCate isEqualToString:noteInfo.strCatalogIdGuid])
            {
                [aryData addObject:noteInfo];
            }
            else if ( ![guidCate isEqualToString:GUID_ZERO] && [AstroDBMng isSubCate_CateMgr:guidCate subCate:noteInfo.strCatalogIdGuid])
            {
                [aryData addObject:noteInfo];
            }
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记信息表失败!");
		return nil;
	}
	return nil;
}


//搜索目录的标题和内容是否含有关键字
+ (NSArray*)getNoteListBySearch:(NSString *)strKey catalog:(NSString *)strCatalog
{
    NSString *strSQL = [NSString stringWithFormat:@"select * from tb_note_info where delete_state=%d AND (note_title like '%%%@%%' OR content like '%%%@%%');",DELETESTATE_NODELETE,strKey,strKey];  //download
    
    @try
	{
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteInfo *noteInfo = [[TNoteInfo new] autorelease];
            noteInfo.tHead = pHead;
			
            [self objFromQuery_NoteMgr:noteInfo query:&query];
            
            if ( strCatalog && strCatalog.length > 0 && ![strCatalog isEqualToString:noteInfo.strCatalogIdGuid] ) {
                TCateInfo *pCateInfo = [AstroDBMng getCate_CateMgr:noteInfo.strCatalogIdGuid];
                if ( [strCatalog isEqualToString:pCateInfo.strCatalogPaht1Guid]
                  || [strCatalog isEqualToString:pCateInfo.strCatalogPaht2Guid]
                  || [strCatalog isEqualToString:pCateInfo.strCatalogPaht3Guid]
                  || [strCatalog isEqualToString:pCateInfo.strCatalogPaht4Guid]
                  || [strCatalog isEqualToString:pCateInfo.strCatalogPaht5Guid]
                  || [strCatalog isEqualToString:pCateInfo.strCatalogPaht6Guid]
                    ) {
                   [aryData addObject:noteInfo]; 
                }
            }
            else {
                [aryData addObject:noteInfo];
            }
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"搜索笔记信息表失败!");
		return nil;
	}
	return nil;
    
}



//获得指定目录的记录总数
+ (int)getNoteCountByCate:(NSString *)strCateGuid
{
    NSString* sql;
    if ( !strCateGuid || [strCateGuid length] == 0 )
        sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where delete_state=%d;",DELETESTATE_NODELETE];
    else 
        sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where catalog_id='%@' AND delete_state=%d;",strCateGuid,DELETESTATE_NODELETE];
    
    try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
        {        
            int nRet = query.GetIntField(0, 0);
            return nRet;
        }
    }
    catch (CppSQLite3Exception e) 
    {
        return 0;
    }
    return 0;
    
}

//获得指定目录当天时间的记录总数
+ (int)getNoteCountByCateByDate:(NSString *)strCateGuid date:(NSString *)strDate
{
    NSString* sql;
    
    if (!strCateGuid || [strCateGuid length] == 0 ) 
        sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where delete_state=%d AND modify_time like '%@%%';",DELETESTATE_NODELETE,strDate];
    else 
        sql = [NSString stringWithFormat:@"select count(*) from tb_note_info where catalog_id='%@' AND delete_state=%d AND modify_time like '%@%%';",strCateGuid,DELETESTATE_NODELETE,strDate];
    
    try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
        {        
            int nRet = query.GetIntField(0, 0);
            return nRet;
        }
    }
    catch (CppSQLite3Exception e) 
    {
        return 0;
    }
    return 0;    
}



//数据库操作
+ (int)saveToDB_NoteMgr:(TNoteInfo *)obj
{
    /* 
    string strSQL = string("REPLACE INTO tb_note_info (") + [super commonFields] + ","
    + "note_id, catalog_id, note_title, note_type, note_size, edit_location, note_src, first_item, file_ext, encrypt_flag, share_mode, need_downlord, star_level"
    + ") values(" + [super commonFieldsValue:obj.tHead] + 
    + "'" + [CommonFunc guidToString:obj.guid] + "', "			// 自身GUID
    + "'" + [CommonFunc guidToString:obj.guidCate] + "', "		// NOTE存放的文件夹GUID
    + "'" + [CommonFunc transSqliteStrW:obj.strTitle] + "', "		// NOTE的名称
    + [CommonFunc ul2a:obj.dwType] + ", "					// NOTE的类型
    + [CommonFunc ul2a:obj.dwSize] + ", "					// NOTE包含的所有ITEM总长度
    + "'" + [CommonFunc transSqliteStrW:obj.strAddr] + "', "		// NOTE编辑时所在的地理位置
    + "'" + [CommonFunc transSqliteStrW:obj.strSrc] + "', "		// NOTE的URL链接地址
    + "'" + [CommonFunc guidToString:obj.guidFirstItem] + "', "	// 当NOTE自身含有文件时，此GUID对应存储实际文件内容的ITEM。
    + "'" + [CommonFunc unicodeToUTF8:obj.wszFileExt] + "', "		// NOTE文件的扩展名, 与FirstItem一致
    + [CommonFunc i2a:obj.nEncryptFlag] + ", "				// 加密标识
    + [CommonFunc i2a:obj.nShareMode] + ", "				// 共享模式
    + [CommonFunc i2a:obj.nNeedDownlord] + "," 
    + [CommonFunc i2a:obj.nStarLevel] + ");";
    //    + CCommon::i2a(obj.dwOwnerID) + ","				// 创建人
    //    + CCommon::i2a(obj.dwFromID) + ");";				// 收藏笔记的原始创建人
    
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
                         
                         "[note_id], "   
                         "[catalog_id], "
                         "[note_title], "
                         "[note_type], "
                         "[note_size], "
                         "[edit_location], "
                         "[note_src], "
                         "[first_item], "
                         "[file_ext], "
                         "[encrypt_flag], "
                         
                         "[share_mode], "
                         "[need_downlord], "
                         "[owner_id], "
                         "[from_id], "
                         "[star_level], "
                         "[expire_date], "
                         "[finish_date], "
                         "[finish_state], "
                         "[content],"
                         "[fail_times],"
                         
                         "[note_class_id],"
                         "[note_friend],"
                         "[send_sms],"
                         "[note_tag])"
						 "values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);",
						 TB_NOTE_INFO];
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新笔记信息出错");
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
        
		stmt.Bind(i++, [obj.strNoteIdGuid UTF8String]);
        stmt.Bind(i++, [obj.strCatalogIdGuid UTF8String]);
        stmt.Bind(i++, [obj.strNoteTitle UTF8String]);
        
        stmt.Bind(i++, obj.nNoteType);
        stmt.Bind(i++, obj.nNoteSize);
        
        stmt.Bind(i++, [obj.strEditLocation UTF8String]);
        stmt.Bind(i++, [obj.strNoteSrc UTF8String]);
        stmt.Bind(i++, [obj.strFirstItemGuid UTF8String]);
        stmt.Bind(i++, [obj.strFileExt UTF8String]);
        
        stmt.Bind(i++, obj.nEncryptFlag);
        stmt.Bind(i++, obj.nShareMode);
        stmt.Bind(i++, obj.nNeedDownlord);
        
        stmt.Bind(i++, obj.nOwnerId);
        stmt.Bind(i++, obj.nFromId);
        stmt.Bind(i++, obj.nStarLevel);
        stmt.Bind(i++, [obj.strExpiredDate UTF8String]);
        stmt.Bind(i++, [obj.strFinishDate UTF8String]);
        
        stmt.Bind(i++, obj.nFinishState);
        
        stmt.Bind(i++, [obj.strContent UTF8String]);
        
        stmt.Bind(i++, obj.nFailTimes);
        stmt.Bind(i++, [obj.strNoteClassId UTF8String]);
        stmt.Bind(i++, obj.nFriend);
        stmt.Bind(i++, obj.nSendSMS);
        stmt.Bind(i++, [obj.strJYEXTag UTF8String]);
        
  		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新笔记表出错");
		return -1;
	}
	return -1;  
}

/*
+ (BOOL)objFromQuery:(NoteInfo*)obj query:(CppSQLite3Query*)query
{
    [super headFromQuery:query head:&obj->tHead];
    
    obj->guid = [CommonFunc stringToGUID:query->getStringField("note_id", "")];
    obj->guidCate = [CommonFunc stringToGUID:query->getStringField("catalog_id", "")];
    obj->guidFirstItem = [CommonFunc stringToGUID:query->getStringField("first_item", "")];
    obj->dwType = query->getIntField("note_type", 0);
    obj->dwSize = query->getIntField("note_size", 0);
    obj->nShareMode = query->getIntField("share_mode", 0);
    obj->nEncryptFlag = query->getIntField("encrypt_flag", 0);
    obj->nNeedDownlord = query->getIntField("need_downlord", 0);
    obj->nStarLevel = query->getIntField("star_level", 0);
    obj->strTitle = [CommonFunc utf8ToUnicode:query->getStringField("note_title", "")];
    obj->strAddr = [CommonFunc utf8ToUnicode:query->getStringField("edit_location", "")];
    obj->strSrc = [CommonFunc utf8ToUnicode:query->getStringField("note_src", "")];
    wcscpy_m((char*)obj->wszFileExt, (char*)[CommonFunc utf8ToUnicode:query->getStringField("file_ext", "")].c_str());

    return YES;
}
*/

+ (BOOL)objFromQuery_NoteMgr:(TNoteInfo*)obj query:(CppSQLite3Query*)query
{
    obj.tHead.nUserID = query->GetIntField("user_id", 0); // 用户编号
    obj.tHead.nCurrVerID = query->GetIntField("curr_ver", 0);                // 当前版本号
    obj.tHead.nCreateVerID = query->GetIntField("create_ver", 0);             // 创建版本号
    
    obj.tHead.strCreateTime = [NSString stringWithUTF8String:query->GetStringField("create_time","")];     // 创建时间
    obj.tHead.strModTime = [NSString stringWithUTF8String:query->GetStringField("modify_time","")];      // 修改时间
    
    obj.tHead.nDelState = query->GetIntField("delete_state", 0);                 // 删除状态
    obj.tHead.nEditState = query->GetIntField("edit_state", 0);                // 编辑状态
    obj.tHead.nConflictState = query->GetIntField("conflict_state", 0);             // 冲突状态
    obj.tHead.nSyncState = query->GetIntField("sync_state", 0);                 // 同步状态，1表示正在同步
    obj.tHead.nNeedUpload = query->GetIntField("need_upload", 0);                // 是否上传
    
    
    obj.strCatalogIdGuid = [NSString stringWithUTF8String:query->GetStringField("catalog_id","")];   // 目录编号;
    obj.strNoteIdGuid = [NSString stringWithUTF8String:query->GetStringField("note_id","")];   //笔记编号
    obj.strNoteTitle = [NSString stringWithUTF8String:query->GetStringField("note_title","")];              // NOTE的名称    
    obj.nNoteType = query->GetIntField("note_type", 0);                     // NOTE的类型
    obj.nNoteSize = query->GetIntField("note_size", 0);         // NOTE包含的所有ITEM总长度，不包含自身
    
    obj.strFilePath = [NSString stringWithUTF8String:query->GetStringField("file_path","")];               //文件保存路径
    obj.strFileExt = [NSString stringWithUTF8String:query->GetStringField("file_ext","")];                //文件扩展名
    obj.strEditLocation = [NSString stringWithUTF8String:query->GetStringField("edit_location","")];           //编辑环境
    obj.strNoteSrc = [NSString stringWithUTF8String:query->GetStringField("note_src","")];               //文件来源
    
    obj.strFirstItemGuid = [NSString stringWithUTF8String:query->GetStringField("first_item","")];              //第一条item(当NOTE自身含有文件时，此GUID对应存储实际文件内容的ITEM)。
    
    obj.nShareMode = query->GetIntField("share_mode", 0);      // 共享模式，0不共享，1共享给好友，2共享给所有人（备用）
    obj.nEncryptFlag = query->GetIntField("encrypt_flag", 0);		// 加密标识(是否加密)
    
    obj.nNeedDownlord = query->GetIntField("need_downlord", 0);      //是否下载 
    obj.nOwnerId = query->GetIntField("owner_id", 0);
    obj.nFromId = query->GetIntField("from_id", 0);
    
    //新增星星级别、到期日期、完成状态、完成日期等属性
    obj.nStarLevel = query->GetIntField("star_level", 0);					//星星级别
    obj.strExpiredDate = [NSString stringWithUTF8String:query->GetStringField("expire_date", "")];		//到期日期
    obj.strFinishDate = [NSString stringWithUTF8String:query->GetStringField("finish_date", "")];		//完成日期
    obj.nFinishState = query->GetIntField("finish_state", 0);		//完成状态 0： 表示未完成 1：表示已完成  
    obj.strContent = [NSString stringWithUTF8String:query->GetStringField("content", "")];		//HTML内容
//    @property (nonatomic,assign) int	nFailTimes;
//    @property (nonatomic,retain) NSString* strNoteClassId;
//    @property (nonatomic,assign) int	nFriend;
//    @property (nonatomic,assign) int	nSendSMS;
//    @property (nonatomic,retain) NSString* strJYEXTag;
    obj.nFailTimes = query->GetIntField("fail_times", 0);
    obj.strNoteClassId = [NSString stringWithUTF8String:query->GetStringField("note_class_id", "")];
    obj.nFriend = query->GetIntField("note_friend", 0);
    obj.nSendSMS = query->GetIntField("send_sms", 0);
    obj.strJYEXTag = [NSString stringWithUTF8String:query->GetStringField("note_tag", "")];
    
    //NSLog(@"##note:%@ %@ parent:%@ edit:%d needdown:%d delete:%d",obj.strNoteTitle, obj.strNoteIdGuid,obj.strCatalogIdGuid,obj.tHead.nEditState,obj.tHead.nNeedUpload,obj.tHead.nDelState);
    
    return YES;
}



+ (int)getNoteMaxVersion
{
    NSString *strValue;
    if ( ![AstroDBMng getCfg_cfgMgr:TB_NOTE_INFO name:@"tableMaxVer" value:strValue] )
        return 0;
    
    int maxVer = [strValue intValue];
    return maxVer;
}

+ (BOOL)setNoteMaxVersion:(int)version
{
    NSString *strValue = [NSString stringWithFormat:@"%d",version];
    return [AstroDBMng setCfg_cfgMgr:TB_NOTE_INFO name:@"tableMaxVer" value:strValue];
}



@end
