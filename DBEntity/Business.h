/*
 *  Business.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */
#include "MyStruct.h"
#include "Common.h"

@interface Business : NSObject
{

}

//DB
+ (BOOL)setDBPath:(NSString*)strDBPath;
+ (BOOL)isDbConnect;

//Cate
+ (BOOL)getCate:(GUID)guidCate cateInfo:(CateInfo*)pCate;
+ (BOOL)getCateIDList:(GUID)guidParent cateList:(std::vector<GUID>*)pCateList;
+ (BOOL)getCateList:(GUID)guidParent cateList:(std::vector<CateInfo>*)pCateList;
+ (BOOL)updateCate:(CateInfo)cateInfo;
+ (int)getCateMaxVersion;
+ (BOOL)saveCate:(CateInfo)cateInfo;
+ (BOOL)saveCateFromSvr:(CateInfo)cateInfo;
+ (int)getTableDirVersion:(GUID)guidDir tableName:(string)strTable;
+ (BOOL)setTableDirVersion:(GUID)guidDir tableName:(string)strTable version:(int)version;
+ (int)getNoteCountInCate:(GUID)guidDir includeSubDir:(BOOL)includeSubDir;

//Note
+ (BOOL)getNote:(GUID)guidNote noteInfo:(NoteInfo*)pNote;
+ (BOOL)getNoteByFirstItemID:(GUID)guidFirstItem noteInfo:(NoteInfo*)pNote;
+ (BOOL)getNoteListByCate:(GUID)guidCate noteList:(std::vector<NoteInfo>*)pNoteList;
+ (BOOL)addNote:(NoteInfo)noteInfo firstItemInfo:(ItemInfo)itemInfo;
+ (BOOL)updateNote:(NoteInfo)noteInfo;
+ (BOOL)updateNote2Item:(GUID)noteGuid item:(GUID)itemGuid;
+ (BOOL)resetNote:(NoteInfo)noteInfo;
+ (BOOL)saveNote:(NoteInfo)noteInfo;
+ (BOOL)resaveNote:(NoteInfo &)noteInfo;
+ (BOOL)resaveNoteWithGuid:(GUID &)noteGuid;
+ (BOOL)getMostRecentNotes:(int)count noteList:(std::vector<NoteInfo>*)pNoteList;
+ (int)needUploadNotesCount;
+ (BOOL)deleteNote:(GUID)guidNote;
+ (BOOL)deleteNoteFromDB:(GUID)guidNote;
+ (BOOL)getUnuploadNoteList:(std::vector<NoteInfo>*)pNoteList includeDelete:(BOOL)includeDelete;
+ (BOOL)getNeedDownNoteList:(GUID)guidCate recursive:(BOOL)recursive noteList:(std::vector<NoteInfo>*)pNoteList;

+ (BOOL)needDecrypt:(GUID)guidNote; //判断Note是否需要解密
+ (int)decryptNote:(GUID)guidNote password:(string)strPassword;
+ (BOOL)resetEncryptStatus:(GUID)guidNote;

// Note2Item
+ (BOOL)saveNote2Item:(A2BInfo)a2bInfo;
+ (BOOL)saveNote2ItemFromSrv:(A2BInfo)a2bInfo;
+ (BOOL)getNote2Item:(GUID)guidNote itemID:(GUID)guidItem note2ItemInfo:(A2BInfo*)pInfo;
+ (BOOL)getNeedUploadItemList:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList;

// Item
+ (BOOL)getItem:(GUID)guidItem itemInfo:(ItemInfo*)pItem;
+ (BOOL)updateItemLen:(GUID)guidItem newItemLen:(int)len;
+ (BOOL)updateItem:(GUID)guidItem encrypttype:(int)encrypttype;
+ (BOOL)updataEncryptItem:(GUID)guidNote itemID:(GUID)guidItem;
+ (BOOL)saveItem:(ItemInfo)itemInfo;
+ (BOOL)deleteItem:(GUID)guidItem;
+ (BOOL)deleteItemFromDB:(GUID)guidItem;

//charge control
+ (BOOL)addFlows:(int) bytes;
+ (uint64_t)getDishargeSince:(NSString *)date;
+ (NSString *)getLastUpdateDay;

//tb_card_info
+ (int)getMaxDisCharge;
+ (BOOL)setMaxDisCharge:(int)maxCharge;
+ (int)getClearDay;
+ (BOOL)setClearDay:(int)clearDay;
+ (BOOL)getGPRSFlag;
+ (BOOL)setGPRSFlag:(BOOL)flag;

+ (BOOL)getItemListByNote:(GUID)guidNote itemList:(std::list<ItemInfo>*)pItemList;

//tb_config_info
+ (std::string)getCfgString:(const char*)pszKey name:(const char*)pszName;
+ (BOOL)setCfgString:(const char*)pszKey name:(const char*)pszName value:(const char*)szValue;
+ (uint32_t)getCfgUint:(const char*)pszKey name:(const char*)pszName;
+ (BOOL)setCfgUint:(const char*)pszKey name:(const char*)pszName value:(uint32_t)nValue;
+ (BOOL)setMasterKey:(unsigned char*)pMasterKey length:(int)len;
+ (BOOL)getMasterKey:(char *)outdata;

//common
+ (BOOL)needUpload:(RecHead*)pHead;

+ (bool)changeToPassword:(NSString *)newpassword oldPassword:(NSString *)oldPassword toEncryptType:(int)newtype oldEncryptType:(int)oldtype info:(NoteInfo *)noteinfo;

@end