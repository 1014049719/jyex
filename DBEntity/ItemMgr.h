/*
 *  ItemMgr.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-15.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "DBMng.h"

/*
struct WORK_KEY_INFO
{
    unsigned char ucWorkKey[WORK_KEY_LEN];
};
*/

#pragma mark -
#pragma mark 数据库管理-ItemMgr
@interface AstroDBMng (ForItemMgr)


+ (TItemInfo* )getItem:(NSString*)strItemGuid;

//某条笔记需上传的笔记项
+ (NSArray *)getNeedUploadItemListByNote:(NSString *)guidNote;

//返回某条笔记所有的Item列表
+ (NSArray *)getItemListByNote:(NSString *)guidNote includeDelete:(BOOL)includeDelete;


+ (BOOL)addItem:(TItemInfo*)pItemInfo;
+ (BOOL)deleteItem:(NSString *)strItemGuid;
+ (BOOL)deleteItemFromDB:(NSString *)strItemGuid;
+ (BOOL)saveItem:(TItemInfo*)itemInfo;



+ (int)saveToDB_ItemMgr:(TItemInfo*)obj;
+ (BOOL)objFromQuery_ItemMgr:(TItemInfo*)obj query:(CppSQLite3Query*)query;




@end


