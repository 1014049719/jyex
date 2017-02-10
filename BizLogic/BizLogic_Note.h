/*
 *  Business.h
 *  NoteBook
 *
 *  Created by wangsc on 10-9-17.
 *  Copyright 2010 ND. All rights reserved.
 *
 */
#import "BizLogic.h"

#import "CateMgr.h"
#import "NoteMgr.h"
#import "ItemMgr.h"
#import "Note2ItemMgr.h"



@interface BizLogic (ForNote)
{

}


//头结构各种操作
+ (TRecHead* )createHead;
+ (void)updateHeadForEdit:(TRecHead* )pHead;
+ (void)updateHeadForDelete:(TRecHead* )pHead;
+ (void)resetHead:(TRecHead*)pHead;


//目录操作

//创建文件夹结构
+(TCateInfo *)createCateInfo;
//插入或更新目录到数据库
+(BOOL)updateCate:(TCateInfo *)pCateInfo;


//创建根目录文件夹
+(BOOL)addRootCate:(NSString *)strTitle icon:(int)nCatalogIcon color:(int)nCatalogColor encrypt:(int)nEncryptFlag  sync:(int)nSyncFlag mobile_flag:(int)mobile_flag  order:(int)order;
//如果没有目录，创建根缺省目录记录
+(void)createDefaultRootCateRecord;


//根据指定GUID，获取某个目录
+ (TCateInfo*)getCate:(NSString *)guidCate;

//更改某个目录(包括更改父目录的)的记录总数
+(BOOL)updateCateNoteCount:(NSString *)strCateGuid;


//获取目录列表，其中guidParent为父目录的GUID，如果取根目录列表，置为空
+ (NSArray *)getCateList:(NSString *)guidParent;
//搜索目录的标题是否含有关键字
+ (NSArray*)getCateListBySearch_CateMgr:(NSString *)strKey catalog:(NSString *)strCatalog;
//删除指定目录下的所有子目录以及笔记
+(void) deleteSpecifiedCate:(NSString *)strCata;

//将目录cateInfo的PathGUID设置成目录parentCate的子目录
+(BOOL)setPathGUIDWith:(TCateInfo *)parentCate DesCate:(TCateInfo *)cateInfo;
//在指定目录下新建一个子目录
+(BOOL) createCateInSpacifiedCate:(NSString *)strParentCate CateInfo:(TCateInfo *)pCateInfo;
//设置文件夹
+(BOOL)setCateWithCateInfo:(TCateInfo*)cateInfo;
//更新一个文件夹的顺序号
+(BOOL)updataCateOrder:(NSString*)cateGuid Order:(int)newOrder;

//获取目录的当前最大版本号
+ (int)getCateMaxVersion;
//从服务端下载目录后，保存到当地数据库，同时更新目录的版本号到最大版本号
+ (BOOL)saveCateFromSvr:(TCateInfo *)cateInfo;
+ (int)getTableDirVersion:(NSString *)guidDir tableName:(NSString *)strTable;
+ (BOOL)setTableDirVersion:(NSString *)guidDir tableName:(NSString *)strTable version:(int)version;





//-----笔记操作----
//初始化一条笔记,输入参数为父目录GUID，自动生成笔记编号和第一条项目不编号
+(TNoteInfo *)createNoteInfo:(NSString *)guidCatalog;
//增加或修改一条笔记（暂不支持删除附件）
+ (BOOL)addNote:(TNoteInfo *)noteInfo ItemInfo:(NSArray *)arrItem;
//只更新笔记信息
+(BOOL)updataNoteInfo:(TNoteInfo *)noteInfo;
//增加或更改笔记，只更改笔记信息(笔记信息已填充好，同步过程中使用，不发通知消息)
+ (BOOL)addNoteForSync:(TNoteInfo *)noteInfo;

//读取一条笔记
+ (TNoteInfo *)getNote:(NSString *)guidNote;
//读取一条笔记的所有Item
+ (NSArray *)getAllItemByNoteGuid:(NSString *)guidNote;

//删除一条笔记
+ (BOOL)deleteNote:(NSString *)guidNote SendUpdataMsg:(BOOL)bSendFlag;
+ (void) deleteOldNote;

//读取某个目录下的所有笔记
+ (NSArray *)getAllNoteByCateGuid:(NSString *)strCateGuid;

//搜索笔记的标题和内容是否含有关键字
+ (NSArray*)getNoteListBySearch:(NSString *)strKey catalog:(NSString *)strCatalog;

//读取最新的的N篇笔记
//+ (NSArray*)getLatestNoteList:(int)count;

//返回需同步的记录数(包括上传和下载)
+ (int)needSyncNotesCount;


//照片操作
//2014.3.11
//初始化照片信息
+ (TNoteInfo *)createPicInfo;
//增加一张照片
+ (BOOL)addPic:(NSString *)strPicNameGuid title:(NSString *)strTitle albumname:(NSString *)strAlbumName albumid:(NSString *)strAlbumID uid:(NSString *)strUid username:(NSString *)strUsername;




//项目操作
//------------------------------------------------------------------------------------
//初始化一条笔记与笔记项关联
+(TNoteXItem *)createNoteXItem;

//初始化一条项目(item)，自动生成item编号
+(TItemInfo *)CreateItemInfo:(ENUM_ITEM_TYPE)nItemType itemguid:(NSString *)strItemGuid noteguid:(NSString *)strNoteGuid;
//初始化一条项目
+(TItemInfo *)CreateItemInfo;


//笔记冲突处理和笔记转换
//----------------------------------------------------------------------------------------
//变更笔记
+(BOOL)changeNote:(NSString *)strOldNoteGuid;

//把不是HTML的笔记转换成HTML笔记
+(BOOL)changeToHtmlNote:(NSString *)strGuidNote;

//笔记迁移：把某个目录中的所有笔记和目录迁移到另外一个目录
+(void)moveNoteFromDirectory:(NSString *)srcCateGuid to:(NSString *)destCateGuid;

//删除多余的默认目录
+(void)deleteRedundantDefaultDirectory;

//删除某个目录，把其中的笔记全部变成无整理笔记，全部子文件夹都删除
+(void) deleteSpecifiedDirectory:(NSString *)strCatalog;

//获取缺省目录(手机未整理目录)
+(void)setDefualtDirectory;


@end