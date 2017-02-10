/*
 *  Business.mm
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */

#import "Business.h"
#import "NoteMgr.h"
#import "CateMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"
#import "DischargeMgr.h"
#import "CfgMgr.h"
#import "MBBaseStruct.h"
#import "ObjEncrypt.h"

@implementation Business

//DB
+ (BOOL)setDBPath:(NSString*)strDBPath
{
    if (![[DBObject shareDB] open:[strDBPath UTF8String]])
    {
        MLOG(@"open db failed");
        return NO;
    }
    
    [CateMgr initCache];
    [DischargeMgr checkDischargeInfo];
    
    return YES;
}

+ (BOOL)isDbConnect
{
    return [[DBObject shareDB] isOpen];
}

//Cate
+ (BOOL)getCate:(GUID)guidCate cateInfo:(CateInfo*)pCate
{
    return [CateMgr getCate:guidCate cateInfo:pCate];
}

+ (BOOL)getCateIDList:(GUID)guidParent cateList:(std::vector<GUID>*)pCateIDList
{
    std::vector<CateInfo> cateList;
    [CateMgr getCateList:guidParent cateList:&cateList];
    for(vector<CateInfo>::iterator itor = cateList.begin(); itor != cateList.end(); ++itor)
    {
        pCateIDList->push_back(itor->guid);
    }
    
    return YES;
}

+ (BOOL)getCateList:(GUID)guidParent cateList:(std::vector<CateInfo>*)pCateList
{
    return [CateMgr getCateList:guidParent cateList:pCateList];
}

+ (BOOL)updateCate:(CateInfo)cateInfo
{
    return [CateMgr updateCate:cateInfo];
}

+ (int)getCateMaxVersion
{
    return [CateMgr getCateMaxVersion];
}

+ (BOOL)saveCate:(CateInfo)cateInfo
{
    return [CateMgr saveCate:cateInfo];
}

+ (BOOL)saveCateFromSvr:(CateInfo)cateInfo
{
    int maxVersion = [CateMgr getCateMaxVersion];
    if (cateInfo.tHead.dwCurVerID > maxVersion)
    {
        [CateMgr setCateMaxVersion:cateInfo.tHead.dwCurVerID];
    }
    
    cateInfo.tHead.nEditState = 0;
    return [CateMgr saveCate:cateInfo];
}

+ (int)getTableDirVersion:(GUID)guidDir tableName:(string)strTable
{
    return [CateMgr getTableDirVersion:guidDir tableName:strTable];
}

+ (BOOL)setTableDirVersion:(GUID)guidDir tableName:(string)strTable version:(int)version
{
    return [CateMgr setTableDirVersion:guidDir tableName:strTable version:version];
}

+ (int)getNoteCountInCate:(GUID)guidDir includeSubDir:(BOOL)includeSubDir
{
    return [CateMgr getNoteCountInCate:guidDir includeSubDir:includeSubDir];
}

+ (BOOL)getNote:(GUID)guidNote noteInfo:(NoteInfo*)pNote
{
    return [NoteMgr getNote:guidNote noteInfo:pNote];
}

+ (BOOL)getNoteByFirstItemID:(GUID)guidFirstItem noteInfo:(NoteInfo*)pNote
{
    return [NoteMgr getNoteByFirstItemID:guidFirstItem noteInfo:pNote];
}

+ (BOOL)getNoteListByCate:(GUID)guidCate noteList:(std::vector<NoteInfo>*)pNoteList
{
    return [NoteMgr getNoteListByCate:guidCate noteList:pNoteList];
}

+ (BOOL)addNote:(NoteInfo)noteInfo firstItemInfo:(ItemInfo)itemInfo
{
    [ObjMgr createHead:&noteInfo.tHead];
    if (![NoteMgr addNote:noteInfo])
    {
        MLOG(@"AddNote FAILED");
        return NO;
    }
    
    if (![Note2ItemMgr addNote2Item:noteInfo.guid itemID:itemInfo.guid])
    {
        MLOG(@"AddNote2Item FAILED");
        return NO;
    }
    
    [ObjMgr createHead:&itemInfo.tHead];
    if (![ItemMgr addItem:itemInfo])
    {
        MLOG(@"AddItem FAILED");
        return NO;
    }
    
    return YES;
}

+ (BOOL)updateNote:(NoteInfo)noteInfo
{
    return [NoteMgr updateNote:noteInfo];
}

+ (BOOL)resetNote:(NoteInfo)noteInfo {
	return [NoteMgr resetNote:noteInfo];
}

+ (BOOL)updateNote2Item:(GUID)noteGuid item:(GUID)itemGuid {
	A2BInfo a2bInfo;
	[Note2ItemMgr getNote2Item:noteGuid itemID:itemGuid note2ItemInfo:&a2bInfo];
	[Note2ItemMgr updateNote2Item:a2bInfo];
	return YES;
}

+ (BOOL)saveNote:(NoteInfo)noteInfo
{
    return [NoteMgr saveNote:noteInfo];
}

+ (BOOL)resaveNote:(NoteInfo &)noteInfo
{
	// 获取该笔记对应的文件的路径
	NSString *filePath = [CommonFunc getItemPath:noteInfo.guidFirstItem fileExt:noteInfo.wszFileExt];
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:filePath]) {
		
		// 获取noteInfo对应的itemInfo
		ItemInfo itemInfo;
		[Business getItem:noteInfo.guidFirstItem itemInfo:&itemInfo];
		
		// 读取文件的数据
		NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filePath];
		NSData *fData = [file readDataToEndOfFile];

		GUID guidNote = [CommonFunc createGUID];
		GUID guidItem = [CommonFunc createGUID];
		NSString *strItemGuid = [CommonFunc guidToNSString:guidItem];
		
		unistring strExtFuck = noteInfo.wszFileExt;
		
		NSString *strFilePathNew = [NSString stringWithFormat:@"%@/%@.%@", [CommonFunc getTempDir], strItemGuid, [NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()]];
		[fm createFileAtPath:strFilePathNew contents:fData attributes:nil];
		
		// 创建新的NoteInfo和ItemInfo
		NoteInfo noteInfoNew;
		ItemInfo itemInfoNew;
		NSString *strTitle = [NSString stringWithFormat:@"%@_副本", [NSString stringWithCharacters:noteInfo.strTitle.c_str() length:noteInfo.strTitle.size()]];
    
        [CommonFunc makeNoteInfo:&noteInfoNew noteID:guidNote title:strTitle noteType:(EM_NOTE_TYPE)noteInfo.dwType size:noteInfo.dwSize star:noteInfo.nStarLevel fileExt:[NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()] firstItemID:guidItem];
		 [CommonFunc makeItemInfo:&itemInfoNew itemId:guidItem itemType:(ENUM_ITEM_TYPE)itemInfo.nNoteItemType fileExt:[NSString stringWithCharacters:strExtFuck.c_str() length:strExtFuck.size()] size:itemInfo.m_unDataLen];
		
        noteInfoNew.nEncryptFlag = noteInfo.nEncryptFlag;
        itemInfoNew.nEncryptFlag = itemInfo.nEncryptFlag;
        
		// 保存该笔记
		[Business addNote:noteInfoNew firstItemInfo:itemInfoNew];
		return YES;
	}
	else {
		return NO;
	}
}

+ (BOOL)resaveNoteWithGuid:(GUID &)noteGuid {
	NoteInfo ni;
	[Business getNote:noteGuid noteInfo:&ni];
	
	[Business resaveNote:ni];
}

+ (BOOL)getMostRecentNotes:(int)count noteList:(std::vector<NoteInfo>*)pNoteList
{
    return [NoteMgr getMostRecentNotes:count noteList:pNoteList];
}

+ (int)needUploadNotesCount
{
    return [NoteMgr needUploadNotesCount];
}

+ (BOOL)deleteNote:(GUID)guidNote
{
    return [NoteMgr deleteNote:guidNote];
}

+ (BOOL)deleteNoteFromDB:(GUID)guidNote
{
    return [NoteMgr deleteNoteFromDB:guidNote];
}

+ (BOOL)getUnuploadNoteList:(std::vector<NoteInfo>*)pNoteList  includeDelete:(BOOL)includeDelete
{
    return [NoteMgr getUnuploadNoteList:pNoteList includeDelete:includeDelete];
}

+ (BOOL)getNeedDownNoteList:(GUID)guidCate recursive:(BOOL)recursive noteList:(std::vector<NoteInfo>*)pNoteList
{
    return [NoteMgr getNeedDownNoteList:guidCate recursive:recursive noteList:pNoteList];
}

+ (BOOL)needDecrypt:(GUID)guidNote
{
    return [NoteMgr needDecrypt:guidNote];
}

+ (int)decryptNote:(GUID)guidNote password:(string)strPassword;
{
    return [NoteMgr decryptNote:guidNote password:strPassword];
}

+ (BOOL)resetEncryptStatus:(GUID)guidNote
{
    return YES;
}

// Note2Item
+ (BOOL)saveNote2Item:(A2BInfo)a2bInfo
{
    return [Note2ItemMgr saveNote2Item:a2bInfo];
}

+ (BOOL)saveNote2ItemFromSrv:(A2BInfo)a2bInfo
{
    
    if (a2bInfo.tHead.nDelState == STATE_DELETE)
    {
        //直接删除item与note2item
        [Note2ItemMgr deleteNote2ItemFromDB:a2bInfo];
        [ItemMgr deleteItemFromDB:a2bInfo.guidSecond];
        return YES;
    }
    
    return [Note2ItemMgr saveToDB:a2bInfo];
}

+ (BOOL)getNote2Item:(GUID)guidNote itemID:(GUID)guidItem note2ItemInfo:(A2BInfo*)pInfo
{
    return [Note2ItemMgr getNote2Item:guidNote itemID:guidItem note2ItemInfo:pInfo];
}

+ (BOOL)getNeedUploadItemList:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList
{
    return [Note2ItemMgr getNeedUploadItemList:guidNote itemList:pItemList];
}

+ (BOOL)getItem:(GUID)guidItem itemInfo:(ItemInfo*)pItem
{
    return [ItemMgr getItem:guidItem itemInfo:pItem];
}

// Item
+ (BOOL)updateItemLen:(GUID)guidItem newItemLen:(int)len
{
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        return NO;
    }

    objItem.m_unDataLen = len;
    [ObjMgr updateHead:&objItem.tHead];
    
    return [ItemMgr saveItem:objItem];
}

+ (BOOL)updateItem:(GUID)guidItem encrypttype:(int)encrypttype {
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        return NO;
    }
    
    objItem.nEncryptFlag = encrypttype;
    [ObjMgr updateHead:&objItem.tHead];
    
    return [ItemMgr saveItem:objItem];
}

+ (BOOL)updataEncryptItem:(GUID)guidNote itemID:(GUID)guidItem;
{
    WORK_KEY_INFO workKeyInfo;
    if (![NoteMgr getWorkKey:guidNote workKey:&workKeyInfo])
        return NO;
    
    ItemInfo objItem;
    if (![ItemMgr getItem:guidItem itemInfo:&objItem])
    {
        MLOG(@"getItem failed");
        return NO;
    }
    
    if (objItem.nEncryptFlag == EF_HIGH_ENCRYPTED)
    {
        if (![ItemMgr encryptItem:&objItem workKey:workKeyInfo.ucWorkKey])
        {
            MLOG(@"encryptItem failed");
            return NO;
        }
    }
    else if (objItem.nEncryptFlag == EF_NORMAL_ENCRYPTED) {
        if (![ItemMgr encryptItem:&objItem workKey:workKeyInfo.ucWorkKey]) {
            MLOG(@"encryptItem failed");
            return NO;
        }
    }
    else
    {
        
    }
    
    NoteInfo objNote;
    [NoteMgr getNote:guidNote noteInfo:&objNote];
    objNote.dwSize = objItem.m_unDataLen;
    [NoteMgr updateNote:objNote];
    
    return YES;
}

+ (BOOL)getItemListByNote:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList {
    return [Note2ItemMgr getItemListByNote:guidNote itemList:pItemList];
}

+ (BOOL)saveItem:(ItemInfo)itemInfo
{
    return [ItemMgr saveItem:itemInfo];
}

+ (BOOL)deleteItem:(GUID)guidItem
{
    return [ItemMgr deleteItem:guidItem];
}

+ (BOOL)deleteItemFromDB:(GUID)guidItem
{
    return [ItemMgr deleteItemFromDB:guidItem];
}

//charge control
+ (BOOL)addFlows:(int) bytes
{
    return [DischargeMgr addFlows:bytes];
}

+ (uint64_t)getDishargeSince:(NSString *)date
{
    return [DischargeMgr getDishargeSince:date];
}

+ (NSString *)getLastUpdateDay
{
    return [DischargeMgr getLastUpdateDay];
}

//tb_card_info
+ (int)getMaxDisCharge
{
    return [DischargeMgr getMaxDisCharge];
}

+ (BOOL)setMaxDisCharge:(int)maxCharge
{
    return [DischargeMgr setMaxDisCharge:maxCharge];
}

+ (int)getClearDay
{
    return [DischargeMgr getClearDay];
}

+ (BOOL)setClearDay:(int)clearDay
{
    return [DischargeMgr setClearDay:clearDay];
}
+ (BOOL)getGPRSFlag
{
    return [DischargeMgr getGPRSFlag];
}

+ (BOOL)setGPRSFlag:(BOOL)flag
{
    return [DischargeMgr setGPRSFlag:flag];
}

+ (std::string)getCfgString:(const char*)pszKey name:(const char*)pszName
{
    return [CfgMgr getCfgString:pszKey name:pszName];
}
+ (BOOL)setCfgString:(const char*)pszKey name:(const char*)pszName value:(const char*)szValue
{
    return [CfgMgr setCfgString:pszKey name:pszName value:szValue];
}
+ (uint32_t)getCfgUint:(const char*)pszKey name:(const char*)pszName
{
    return [CfgMgr getCfgUint:pszKey name:pszName];
}
+ (BOOL)setCfgUint:(const char*)pszKey name:(const char*)pszName value:(uint32_t)nValue
{
    return [CfgMgr setCfgUint:pszKey name:pszName value:nValue];
}

+ (BOOL)setMasterKey:(unsigned char*)pMasterKey length:(int)len
{
    return [CfgMgr setMyMasterKey:pMasterKey length:len];
}
+ (BOOL)getMasterKey:(char *)outdata {
    
    return [CfgMgr getMyMasterKey:(unsigned char *)outdata];
}

+ (BOOL)needUpload:(RecHead*)pHead
{
    return [NoteMgr needUpload:pHead];
    
}

+ (bool)changeToPassword:(NSString *)newpassword oldPassword:(NSString *)oldPassword toEncryptType:(int)newtype oldEncryptType:(int)oldtype info:(NoteInfo *)noteinfo {
    if (newpassword == nil || oldPassword == nil) {
        return false;
    }
    if ([newpassword isEqualToString:oldPassword] && newtype == oldtype) {
        return true;
    }
    
    // 先解析出原来的数据
    NSString *path = [CommonFunc getItemPath:noteinfo->guidFirstItem fileExt:noteinfo->wszFileExt];
    NSFileHandle * file  = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fData = [file readDataToEndOfFile];
    
    int result = ENCRYPT_ERR_PROCESS;
    unsigned char *src = NULL;
    unsigned char *dst = NULL;
    int srclen = 0;
    int dstlen = 0;
    
    src = (unsigned char *)fData.bytes;
    srclen = fData.length;
    
    // 根据密码解密文件的数据
    if (oldtype == EF_NORMAL_ENCRYPTED) {
        result = [ObjEncrypt DecryptItemEx:src len:srclen pwd:[oldPassword cStringUsingEncoding:NSASCIIStringEncoding] outdata:&dst outlen:&dstlen];
    }
    else if (oldtype == EF_HIGH_ENCRYPTED) {
        result = [ObjEncrypt DecryptItem:src len:srclen pwd:[oldPassword cStringUsingEncoding:NSASCIIStringEncoding] outdata:&dst outlen:&dstlen];
    }
    
    // 解密正确
    if (result == ENCRYPT_SUCCESS) {
        
        // 将数据保存成文件，以便显示出来
        NSData *dstData = nil;
        if (oldtype == EF_HIGH_ENCRYPTED) {
            dstData = [NSData dataWithBytes:(dst+8) length:(dstlen-8)];
        }
        else if (oldtype == EF_NORMAL_ENCRYPTED) {
            dstData = [NSData dataWithBytes:dst length:dstlen];
        }
        if (nil != dstData) {                
            // 得到了原数据
            if ([newpassword isEqualToString:@""]) {
                // 直接保存成文件，并且将noteinfo中的加密位设置成不加密
                noteinfo->nEncryptFlag = EF_NOT_ENCRYPTED;
                // 将数据直接保存回去
                [dstData writeToFile:path atomically:NO];
                
                [Business updateItemLen:noteinfo->guidFirstItem newItemLen:dstData.length];
                [Business updateItem:noteinfo->guidFirstItem encrypttype:EF_NOT_ENCRYPTED];
                [Business updateNote:*noteinfo];
            }
            // 按照新的方式加密，并保存
            else {
                NSData *data = nil;
                bool writetofile = false;
                char *dstdata = NULL;
                int dstlen = 0;
                if (newtype == EF_NORMAL_ENCRYPTED) {
                    if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItemEx:(const char *)dstData.bytes srclen:dstData.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[newpassword cStringUsingEncoding:NSASCIIStringEncoding]]) {
                            data = [NSData dataWithBytes:dstdata length:dstlen];
                            writetofile = [data writeToFile:path atomically:NO];
                        }
                }
                else if (newtype == EF_HIGH_ENCRYPTED) {
                    if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItem:(const char *)dstData.bytes srclen:dstData.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[newpassword cStringUsingEncoding:NSASCIIStringEncoding]]) {
                            data = [NSData dataWithBytes:dstdata length:dstlen];
                            writetofile = [data writeToFile:path atomically:NO];
                        }
                }
                if (writetofile) {
                    noteinfo->nEncryptFlag = newtype;
                    noteinfo->dwSize = data.length;
                    [Business updateItemLen:noteinfo->guidFirstItem newItemLen:data.length];
                    [Business updateItem:noteinfo->guidFirstItem encrypttype:newtype];
                    [Business updateNote:*noteinfo];
                }
                if (dstdata) {
                    delete dstdata;
                }
            }
        }
        
        SAFE_DELETE(dst);
    }
    else {
        return false;
    }
    return true;
}

@end