//
//  Common.h
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "Common.h"
#import "DbMngDataDef.h"



@interface CommonFunc (ForNoteOpr)
{
    
}


+ (void)makeNoteInfo:(TNoteInfo*&)noteInfo noteID:(NSString *)guidNote title:(NSString*)strTitle noteType:(EM_NOTE_TYPE)noteType size:(int)noteSize star:(int)starLevel fileExt:(NSString*)strFileExt firstItemID:(NSString *)guidFirstItem;
+ (void)makeNoteInfo:(TNoteInfo*&)noteInfo noteID:(NSString *)guidNote title:(NSString*)strTitle noteType:(EM_NOTE_TYPE)noteType size:(int)noteSize star:(int)starLevel fileExt:(NSString*)strFileExt firstItemID:(NSString *)guidFirstItem cateID:(NSString *)guidCate;
+ (void)makeItemInfo:(TItemInfo*&)itemInfo itemId:(NSString *)guidItem itemType:(ENUM_ITEM_TYPE)itemType fileExt:(NSString*)strExt size:(int)nItemSize;
+ (NSData *)loadItemData:(TItemInfo*)pItemInfo;


// 将一批笔记记录加入到当前账户的数据库中，并将对应的文件拷贝到当前账户的目录中
+ (void)SaveNoteInfosToCurrentAccount:(NSArray *)list preaccount:(NSString*)strPreAccount curaccount:(NSString*)strCurAccount;

+(void) CopyNoteInfosFileToTempDirectory:(NSArray *)listNoteInfo account:(NSString *)strCurAccount;

// 将一批笔记记录加入到当前账户的数据库中，并将对应的文件拷贝到当前账户的目录中
+ (void)SaveNoteInfosToCurrentAccount:(NSArray *)listNoteInfo curaccount:(NSString*)strCurAccount;


@end

