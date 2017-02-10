//
//  Common.mm
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "CommonNoteOpr.h"
#import "Constant.h"

#import "Global.h"
#import "CommonDirectory.h"
#import "CommonDateTime.h"

#import "DbMngDataDef.h"
#import "ItemMgr.h"
#import "NoteMgr.h"
#import "Note2ItemMgr.h"
#import "CateMgr.h"

#import "Logger.h"

@implementation CommonFunc (ForNoteOpr)


+ (void)makeNoteInfo:(TNoteInfo*&)noteInfo noteID:(NSString*)guidNote title:(NSString*)strTitle noteType:(EM_NOTE_TYPE)noteType size:(int)noteSize star:(int)starLevel fileExt:(NSString*)strFileExt firstItemID:(NSString *)guidFirstItem
{
    noteInfo.strNoteIdGuid = guidNote;
    noteInfo.strNoteTitle = strTitle;
    noteInfo.nNoteType = noteType;
    noteInfo.nNoteSize = noteSize;
    noteInfo.nStarLevel = starLevel;
    noteInfo.strFileExt = strFileExt;
    noteInfo.strFirstItemGuid = guidFirstItem;
    
    noteInfo.nFailTimes = 0;
    noteInfo.strNoteClassId = @"";
    noteInfo.nFriend = 0;
    noteInfo.nSendSMS = 1;
    noteInfo.strJYEXTag = @"";
    
    noteInfo.strCatalogIdGuid = [_GLOBAL defaultCateID];
}

+ (void)makeNoteInfo:(TNoteInfo*&)noteInfo noteID:(NSString *)guidNote title:(NSString*)strTitle noteType:(EM_NOTE_TYPE)noteType
                size:(int)noteSize star:(int)starLevel fileExt:(NSString*)strFileExt firstItemID:(NSString *)guidFirstItem cateID:(NSString *)guidCate {
  
    [self makeNoteInfo:noteInfo noteID:guidNote title:strTitle noteType:noteType size:noteSize star:starLevel fileExt:strFileExt firstItemID:guidFirstItem ];
    
    noteInfo.strCatalogIdGuid = guidCate;
 
}


+ (void)makeItemInfo:(TItemInfo*&)itemInfo itemId:(NSString *)guidItem itemType:(ENUM_ITEM_TYPE)itemType fileExt:(NSString*)strExt size:(int)nItemSize
{
    itemInfo.strItemIdGuid = guidItem; //项目编号
    //int nCreatorID;                 //ITEM创建者编号,备用
    itemInfo.nItemType = itemType;          //ITEM的类型
    itemInfo.strItemExt = strExt;   //ITEM的扩展名
    itemInfo.nItemSize = nItemSize;          //项目大小 
}


+ (NSData *)loadItemData:(TItemInfo*)pItemInfo
{
    NSString* filePath = [self getItemPath:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil)
        return nil;
    
    
    //除去BOM头
    unsigned char* index =  (unsigned char*)[data bytes];
    if ((pItemInfo.nItemType == NI_HTML || pItemInfo.nItemType == NI_TEXT || pItemInfo.nItemType == NI_TXT)
        && (index[0] == 0xFF && index[1] == 0xFE))
    {
        //为什么除去2个字节？
        //memcpy(pItemInfo->m_pData, index + 2, [data length] - 2);
        //pItemInfo->m_unDataLen = [data length] - 2;
    }
    else
    {
        //memcpy(pItemInfo->m_pData, [data bytes], [data length]);
        //pItemInfo->m_unDataLen = [data length];
    }
    
    return data;
}


+(void) CopyNoteInfosFileToTempDirectory:(NSArray *)listNoteInfo account:(NSString *)strCurAccount
{
    
	if (!listNoteInfo || !strCurAccount) {
		return ;
	}
	
	NSString *tmpPath = [CommonFunc getNoteDataPath];
	// 准备源文件目录
	NSString *srcPath = [NSString stringWithFormat:@"%@/%@/Temp", tmpPath, strCurAccount];
	// 准备目标文件目录
	NSString *dstPath = [NSString stringWithFormat:@"%@", tmpPath];
	
	//遍历各个项，准备添加数据库并移动文件
    for (int index=0;index<[listNoteInfo count];index++)
    {
		TNoteInfo *pInfo = [listNoteInfo objectAtIndex:index];
		if (pInfo) {
			// 获取itemType数据
			ENUM_ITEM_TYPE dwType = NI_NOTEINFO;
			// 获取文件扩展名
			NSString *strFileExt = nil;
			switch (pInfo.nNoteType) {
				case NOTE_CUST_WRITE:{
					dwType = NI_HTML;
					strFileExt = @"html";
				}
					break;
				case NOTE_CUST_DRAW:{
					dwType = NI_PIC;
					strFileExt = @"jpg";
				}
					break;
				case NOTE_AUDIO:{
					dwType = NI_AUDIO;
					strFileExt = @"wav";  //amr
				}
					break;
				case NOTE_TXT: {
					dwType = NI_TXT;
					strFileExt = @"txt";
				}
					break;
                case NOTE_PIC: {
                    dwType = NI_PIC;
					strFileExt = @"jpg";
                }
                    break;
				default:
					break;
			}
						
			// 移动Note记录的文件
			
			// 构造源文件路径
			NSString *srcFilePath = [NSString stringWithFormat:@"%@/%@.%@", srcPath, pInfo.strNoteIdGuid, strFileExt];
			// 构造目标文件路径
			NSString *dstFilePath = [NSString stringWithFormat:@"%@/%@.%@", dstPath, pInfo.strNoteIdGuid, strFileExt];
			
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			// 将源文件拷贝到目标文件
			if ([fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil]){
				// 删除源文件				
				[fileManager removeItemAtPath: srcFilePath error:nil];
			}
		}
	}
}

// 将一批笔记记录加入到当前账户的数据库中，并将对应的文件拷贝到当前账户的目录中
+ (void)SaveNoteInfosToCurrentAccount:(NSArray *)listNoteInfo curaccount:(NSString*)strCurAccount
{
    
	if (!listNoteInfo || !strCurAccount)
		return ;
	
	NSString *tmpPath = [CommonFunc getNoteDataPath];
	// 准备源文件目录
	NSString *srcPath = [NSString stringWithFormat:@"%@", tmpPath];
	// 准备目标文件目录
	NSString *dstPath = [NSString stringWithFormat:@"%@/%@/Temp", tmpPath, strCurAccount];
	
	// 遍历各个项，准备添加数据库并移动文件
    for (int index=0;index<[listNoteInfo count];index++)
    {
		TNoteInfo *pInfo = [listNoteInfo objectAtIndex:index];

		if (pInfo) {
			// 获取itemType数据
			ENUM_ITEM_TYPE dwType = NI_NOTEINFO;
			// 获取文件扩展名
			NSString *strFileExt = nil;
			switch (pInfo.nNoteType) {
				case NOTE_CUST_WRITE:{
					dwType = NI_HTML;
					strFileExt = @"html";
				}
					break;
				case NOTE_CUST_DRAW:{
					dwType = NI_PIC;
					strFileExt = @"jpg";
				}
					break;
				case NOTE_AUDIO:{
					dwType = NI_AUDIO;
					strFileExt = @"wav"; //amr
				}
					break;
				case NOTE_TXT: {
					dwType = NI_TXT;
					strFileExt = @"txt";
				}
					break;
				case NOTE_PIC: {
					dwType = NI_PIC;
					strFileExt = @"jpg";
				}
					break;
				default:
					break;
			}
			
			// 创建对应的iteminfo
			TNoteInfo *noteInfo = [[TNoteInfo new] autorelease];
            TItemInfo *itemInfo = [[TItemInfo new] autorelease];
            //noteInfo.tHead = [self createHead];
            //itemInfo.tHead = [self createHead];
            
			[CommonFunc makeNoteInfo:noteInfo noteID:pInfo.strNoteIdGuid title:pInfo.strNoteTitle noteType:(EM_NOTE_TYPE)pInfo.nNoteType size:pInfo.nNoteSize star:pInfo.nStarLevel fileExt:pInfo.strFileExt firstItemID:pInfo.strFirstItemGuid];
            [CommonFunc makeItemInfo:itemInfo itemId:pInfo.strFirstItemGuid itemType:dwType fileExt:strFileExt size:pInfo.nNoteSize];
			// 将该Note记录加入到数据库中
            //[self addNote:noteInfo firstItemInfo:itemInfo];
			
            
			// 移动Note记录的文件
			
			// 构造源文件路径
			NSString *srcFilePath = [NSString stringWithFormat:@"%@/%@.%@", srcPath, pInfo.strNoteIdGuid, strFileExt];
			// 构造目标文件路径
			NSString *dstFilePath = [NSString stringWithFormat:@"%@/%@.%@", dstPath, pInfo.strNoteIdGuid, strFileExt];
			
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			// 将源文件拷贝到目标文件
			if ([fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil]){
				// 删除源文件				
				[fileManager removeItemAtPath: srcFilePath error:nil];
			}
		}
	}
}


// 将一批笔记记录加入到当前账户的数据库中，并将对应的文件拷贝到当前账户的目录中
+ (void)SaveNoteInfosToCurrentAccount:(NSArray*)listNoteInfo preaccount:(NSString*)strPreAccount curaccount:(NSString*)strCurAccount
{
    /*
	if (!listNoteInfo || !strPreAccount || !strCurAccount)
		return ;
	
	NSString *tmpPath = [CommonFunc getNoteDataPath];
	// 准备源文件目录
	NSString *srcPath = [NSString stringWithFormat:@"%@/%@/Temp", tmpPath, strPreAccount];
	// 准备目标文件目录
	NSString *dstPath = [NSString stringWithFormat:@"%@/%@/Temp", tmpPath, strCurAccount];
	
	// 遍历各个项，准备添加数据库并移动文件
	NoteInfoItr itr = listNoteInfo->begin();
	while (itr != listNoteInfo->end()) {
		NoteInfo *pInfo = *itr;
		if (pInfo) {
			// 获取itemType数据
			ENUM_ITEM_TYPE dwType = NI_NOTEINFO;
			// 获取文件扩展名
			NSString *strFileExt = nil;
			switch (pInfo->dwType) {
				case NOTE_CUST_WRITE:{
					dwType = NI_HTML;
					strFileExt = @"html";
				}
					break;
				case NOTE_CUST_DRAW:{
					dwType = NI_PIC;
					strFileExt = @"jpg";
				}
					break;
				case NOTE_AUDIO:{
					dwType = NI_AUDIO;
					strFileExt = @"wav";  //amr
				}
					break;
				case NOTE_TXT: {
					dwType = NI_TXT;
					strFileExt = @"txt";
				}
					break;
				default:
					break;
			}
			
			// 创建对应的iteminfo
			NoteInfo noteInfo;
            ItemInfo itemInfo;
			[CommonFunc makeNoteInfo:&noteInfo noteID:pInfo->guid title:[NSString stringWithCharacters:pInfo->strTitle.c_str() length:pInfo->strTitle.length()] noteType:(EM_NOTE_TYPE)pInfo->dwType size:pInfo->dwSize star:pInfo->nStarLevel fileExt:strFileExt firstItemID:pInfo->guidFirstItem];
            [CommonFunc makeItemInfo:&itemInfo itemId:(pInfo->guidFirstItem) itemType:dwType fileExt:strFileExt size:(pInfo->dwSize)];
			// 将该Note记录加入到数据库中
            [Business addNote:noteInfo firstItemInfo:itemInfo];
			
			// 移动Note记录的文件
			NSString *strFile = [CommonFunc guidToNSString:(pInfo->guidFirstItem)];
			
			// 构造源文件路径
			NSString *srcFilePath = [NSString stringWithFormat:@"%@/%@.%@", srcPath, strFile, strFileExt];
			// 构造目标文件路径
			NSString *dstFilePath = [NSString stringWithFormat:@"%@/%@.%@", dstPath, strFile, strFileExt];
			
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			// 将源文件拷贝到目标文件
			if ([fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil]){
				// 删除源文件				
				[fileManager removeItemAtPath: srcFilePath error:nil];
			}
		}
		
		itr ++;
	}
*/
}
// end add by xupb


@end


