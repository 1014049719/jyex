/*
 *  Note2ItemMgr.cpp
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "Note2ItemMgr.h"
#import "ItemMgr.h"
#import "CfgMgr.h"

#import "Global.h"
#import "logging.h"

#import "CommonDateTime.h"
#import "CommonNoteOpr.h"

@implementation AstroDBMng (ForNote2ItemMgr)

+ (TNoteXItem *)getNote2Item:(NSString *)guidNote itemID:(NSString *)guidItem
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_note_x_item WHERE note_id='%@' AND item_id='%@';",guidNote,guidItem];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteXItem *pInfo = [[TNoteXItem new] autorelease];
            pInfo.tHead = pHead; 
            
            [self objFromQuery_Note2ItemMgr:pInfo query:&query];
            
            return pInfo;
		}
		
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记和项目关联表失败!");
		return nil;
	}
	return nil;
    
}


+ (BOOL)deleteNote2Item:(NSString *)guidNote itemID:(NSString *)guidItem
{
    //MLOG(@"need implemention");
    return YES;
}

+ (BOOL)deleteNote2Item:(TNoteXItem *)pInfo
{
    if (pInfo.tHead.nCurrVerID == 0)
    {
        return [self deleteNote2ItemFromDB:pInfo];
    }

    //[CommonFunc updateHead:pInfo.tHead];
    pInfo.tHead.nEditState = 1;
    pInfo.tHead.strModTime = [CommonFunc getCurrentTime];
    
    pInfo.tHead.nDelState = DELETESTATE_DELETE;
    
    //[super updateHead:&a2bInfo.tHead];
    //a2bInfo.tHead.nDelState = STATE_DELETE;
    return [self saveToDB_Note2ItemMgr:pInfo];
}

+ (BOOL)deleteNote2ItemFromDB:(TNoteXItem *)pInfo
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"DELETE FROM tb_note_x_item WHERE note_id='%@' AND item_id='%@';", pInfo.strNoteIdGuid,pInfo.strItemIdGuid];
		[[AstroDBMng getDb91Note] execDML:sql];
		return YES;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"删除笔记和项目关联信息失败!");
	}
	return NO;
    
}


+ (void)updateNote2Item:(TNoteXItem *)pInfo
{
	//[CommonFunc updateHead:pInfo.tHead];
    
	[self saveToDB_Note2ItemMgr:pInfo];
}

+ (BOOL)saveNote2Item:(TNoteXItem *)pInfo
{
    return [self saveToDB_Note2ItemMgr:pInfo];
}


+ (NSArray *)getNote2ItemListBySQL:(NSString *)strSQL
{
    @try
	{
        //int nNowCount;
        NSMutableArray* aryData = [NSMutableArray array];
        
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:strSQL];
		while ( !query.Eof()) 
		{ 
            TRecHead *pHead = [[TRecHead new] autorelease];
            TNoteXItem *pInfo = [[TNoteXItem new] autorelease];
            pInfo.tHead = pHead;
			
            [self objFromQuery_Note2ItemMgr:pInfo query:&query];
			[aryData addObject:pInfo];
            
            //nNowCount++;
            //if ( nLimitCount>0 && nNowCount>= nLimitCount ) break;
            
			query.NextRow();
		}
		
		return aryData;
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询笔记和项目关联表失败!");
		return nil;
	}
	return nil;
}

//查询某条笔记需上传的笔记关联项
+ (NSArray *)getNeedUploadNote2ItemListByNote:(NSString *)guidNote
{
    
    NSString *strSQL;
    strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_note_x_item WHERE note_id='%@' AND edit_state=%d;",guidNote,EDITSTATE_EDITED];
    
    return [self getNote2ItemListBySQL:strSQL];
}

//查询需下载的笔记关联项
+ (NSArray *)getNeedDownloadNote2ItemListByNote:(NSString *)guidNote
{
    
    NSString *strSQL;
    if ( guidNote )
        strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_note_x_item WHERE note_id='%@' AND need_downlord=%d AND delete_state=%d;",guidNote,DOWNLOAD_NEED,DELETESTATE_NODELETE];
    else
        strSQL = [NSString stringWithFormat:@"SELECT * FROM tb_note_x_item WHERE need_downlord=%d AND delete_state=%d;",DOWNLOAD_NEED,DELETESTATE_NODELETE];
    
    return [self getNote2ItemListBySQL:strSQL];
}




+ (NSArray *)getNote2ItemList:(NSString *)guidNote includeDelete:(BOOL)includeDelete
{
    
    NSString *strSQL;
    if ( includeDelete )
        strSQL = [NSString stringWithFormat:@"select * from tb_note_x_item where note_id='%@';",guidNote];
    else
        strSQL = [NSString stringWithFormat:@"select * from tb_note_x_item where note_id='%@' AND delete_state=%d;",guidNote,DELETESTATE_NODELETE];
    
    return [self getNote2ItemListBySQL:strSQL];
}




 //删除某条笔记的所有item和NoteXItem(只修改标志，不删除记录和文件)
+ (BOOL)DeleteAllItemNoFileByNote:(NSString *)guidNote includeDelete:(BOOL)includeDelete
{
    NSArray *arrNote2Item = [self getNote2ItemList:guidNote includeDelete:includeDelete];
    if ( !arrNote2Item ) return NO;
    
    for (id obj in arrNote2Item )
    {
        TNoteXItem *pNoteXItem = (TNoteXItem *)obj;
        
        TItemInfo *pItemInfo = [AstroDBMng getItem:pNoteXItem.strItemIdGuid];
        if ( pItemInfo ) { //删除
            pItemInfo.tHead.nEditState = EDITSTATE_EDITED;
            pItemInfo.tHead.nDelState = DELETESTATE_DELETE;
            [AstroDBMng saveItem:pItemInfo];
        }
        
        //修改Note2Item标记
        pNoteXItem.tHead.nEditState = EDITSTATE_EDITED;
        pNoteXItem.tHead.nDelState = DELETESTATE_DELETE;
        [self saveNote2Item:pNoteXItem];
           
    }
  
    return YES;
}


+ (NSArray *)getNeedUploadItemList:(NSString *)guidNote
{
    //本地新建已删除,不需要上传
    NSString *strSQL = [NSString stringWithFormat:@"select * from tb_note_x_item where note_id='%@' AND curr_ver!=0;",guidNote];
    return [self getNote2ItemListBySQL:strSQL];
}

//获取某个笔记的笔记与笔记关联项的最大版本号
+ (int)getNote2ItemMaxVersionByNoteGuid:(NSString *)guidNote
{
    NSString* sql;
    if ( isGuidNull(guidNote) )
        sql = [NSString stringWithFormat:@"SELECT max(curr_ver) FROM %@;",TB_NOTE_X_ITEM];
    else 
        sql = [NSString stringWithFormat:@"SELECT max(curr_ver) FROM %@ where note_id='%@';",TB_NOTE_X_ITEM,guidNote];
    
    @try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        if ( !query.Eof()) 
        { 
            int max_ver = query.GetIntField(0, 0);
            return max_ver;
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"SQL: %@\n Exception:%@", sql,[e reason]);
    }
    
    return 0;
}

//获取某个笔记的笔记项的最大order号
+ (int)getNote2ItemMaxOrderByNoteGuid:(NSString *)guidNote
{
    NSString* sql;
    if ( isGuidNull(guidNote) )
        sql = [NSString stringWithFormat:@"SELECT max(item_order) FROM %@;",TB_NOTE_X_ITEM];
    else 
        sql = [NSString stringWithFormat:@"SELECT max(item_order) FROM %@ where note_id='%@';",TB_NOTE_X_ITEM,guidNote];
    
    @try
    {
        CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
        if ( !query.Eof()) 
        { 
            int max_ver = query.GetIntField(0, 0);
            return max_ver;
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"SQL: %@\n Exception:%@", sql,[e reason]);
    }
    
    return 0;
}


+ (BOOL)deleteNote2ItemAndItemByNote:(NSString *)guidNote
{
    NSArray *arrNote2Item = [self getNote2ItemList:guidNote includeDelete:NO];
    if ( !arrNote2Item ) return NO;
    
    for (int index=0;index<[arrNote2Item count];index++)
    {
        TNoteXItem *pInfo = [arrNote2Item objectAtIndex:index];
    
        //[CommonFunc updateHead:pInfo.tHead];  //需要跟踪
        pInfo.tHead.nDelState = DELETESTATE_DELETE;
        [self saveToDB_Note2ItemMgr:pInfo];
        
        [AstroDBMng deleteItem:pInfo.strItemIdGuid];
    }
    
    return YES;
    
    /*
    std::list<A2BInfo> note2ItemList;
    [self getNote2ItemList:guidNote a2bList:&note2ItemList includeDelete:NO];
    
    for (list<A2BInfo>::iterator itor = note2ItemList.begin(); 
         itor != note2ItemList.end(); ++itor)
    {
        A2BInfo a2bInfo = *itor;
        [super updateHead:&a2bInfo.tHead];
        a2bInfo.tHead.nDelState = STATE_DELETE;
        [self saveToDB:a2bInfo];
        
        [ItemMgr deleteItem:a2bInfo.guidSecond];
    }
    
    return YES;
    */
}

+ (BOOL)deleteNote2ItemAndItemByNoteFromDB:(NSString *)guidNote
{
    NSArray *arrNote2Item = [self getNote2ItemList:guidNote includeDelete:NO];
    if ( !arrNote2Item ) return NO;
    
    for (int index=0;index<[arrNote2Item count];index++)
    {
        TNoteXItem *pInfo = [arrNote2Item objectAtIndex:index];
                
        [AstroDBMng deleteItemFromDB:pInfo.strItemIdGuid];
        [self deleteNote2ItemFromDB:pInfo];
    }
    
    return YES;

    /*
    std::list<A2BInfo> note2ItemList;
    [self getNote2ItemList:guidNote a2bList:&note2ItemList includeDelete:NO];
    
    for (list<A2BInfo>::iterator itor = note2ItemList.begin(); 
         itor != note2ItemList.end(); ++itor)
    {
        [ItemMgr deleteItemFromDB:itor->guidSecond];
        [self deleteNote2ItemFromDB:*itor];
    }
    
    return YES;
    */
}


//数据库操作
+ (int)saveToDB_Note2ItemMgr:(TNoteXItem *)obj
{

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
                         "[item_id], "
                         "[item_creator], "
                         "[catalog_belong_to], "
                         "[item_ver], "
                         "[need_downlord], "
                         "[item_order])"
						 "values(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?);",
						 TB_NOTE_X_ITEM];
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新笔记和项目关联表出错");
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
        stmt.Bind(i++, [obj.strItemIdGuid UTF8String]);
        
        stmt.Bind(i++, obj.nCreatorID);
        
        stmt.Bind(i++, [obj.strCatalogBelongToGuid UTF8String]);
        stmt.Bind(i++, obj.nItemVer);
        stmt.Bind(i++, obj.nNeedDownlord);
        stmt.Bind(i++, obj.nItemOrder);
                
  		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新笔记和项目关联表出错");
		return -1;
	}
	return -1;  
}

+ (BOOL)objFromQuery_Note2ItemMgr:(TNoteXItem*)obj query:(CppSQLite3Query*)query
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
    

    obj.strNoteIdGuid = [NSString stringWithUTF8String:query->GetStringField("note_id","")];   //笔记编号
    obj.strItemIdGuid = [NSString stringWithUTF8String:query->GetStringField("item_id","")];
    obj.nCreatorID = query->GetIntField("item_creator", 0);      
  
    obj.strCatalogBelongToGuid = [NSString stringWithUTF8String:query->GetStringField("catalog_belong_to","")];   // 目录编号;
    obj.nItemVer = query->GetIntField("item_ver", 0);            
    obj.nNeedDownlord = query->GetIntField("need_downlord", 0);      
    obj.nItemOrder = query->GetIntField("item_order", 0);   
    
    //NSLog(@"++noteXitem:%@ note:%@ edit:%d needdown:%d delete:%d",obj.strItemIdGuid,obj.strNoteIdGuid,
    //      obj.tHead.nEditState,obj.tHead.nNeedUpload,obj.tHead.nDelState);
    
    return YES;
}

+ (int)getNoteXItemMaxVersion:(NSString *)strNoteGuid
{
    NSString *strValue;
    if ( ![AstroDBMng getCfg_cfgMgr:TB_NOTE_X_ITEM name:strNoteGuid value:strValue] )
        return 0;
    
    int maxVer = [strValue intValue];
    return maxVer;
}

+ (BOOL)setNoteXItemMaxVersion:(NSString *)strNoteGuid version:(int)version
{
    NSString *strValue = [NSString stringWithFormat:@"%d",version];
    return [AstroDBMng setCfg_cfgMgr:TB_NOTE_X_ITEM name:strNoteGuid value:strValue];
}


@end