//
//  MBSynManager.h
//  NoteBook
//
//  Created by chen wu on 09-10-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBUpLoadNoteMsg.h"
#import "MBNoteListMsg.h"
#import "MBShareByCataList.h"
#import "MBA2BListMsg.h"
#import "MBItemInfoMsg.h"
#import "MBBaseStruct.h"
#import "MBGetDefCataListMsg.h"
#import "MBDataStruct.h"
#import "MBCateListMsg.h"
#import "NoteListCtrDelegate.h"
#import "DownloadItemDelegate.h"

@interface MBSynManager : NSObject 
{
    std::list<GUID> cateIDList;
	std::list<NoteInfo> noteList;
	std::list<CMBA2BInfo>  note2ItemList;
    
    std::list<GUID>::iterator cateIt;
	std::list<NoteInfo>::iterator noteIt;
	std::list<CMBA2BInfo>::iterator abIt;
    
    GUID guidCateToSync;    //当前要下载的Cate
    GUID guidNoteToDown;    //当前要下载的Note
    
    BOOL needDownSubDir;   //下载子文件下的Note
    BOOL needDownItem; //下载Note后下载Item
    BOOL downUnFinishedNote;    //下载未完成的笔记
    int  downItemFailedCount;   //笔记中的ITEM下载失败个数
    
    A2BInfo tmpA2BInfo;     //上传完ITEM后再保存note2item
    
    id<NoteListCtrDelegate>      noteListCtrDelegate;
    PSocket*    currentSocket;
	@public
	id<DownloadItemDelegate> itemDownloadDelegate;
}

+ (MBSynManager *)defaultManager;

- (void)stop;
- (void)getANote;
- (void)getANoteThumb;

- (void)downCates;  //下载目录
- (void)downNewNotes:(int)nIndex count:(int)count delegate:(id)delegate;       //下载最新笔记
- (void)downByCate:(GUID)guidCate downSubCate:(BOOL)downSubCate downItem:(BOOL)downItem;  //文件夹同步
- (void)downNotesInCate:(GUID)guidCate;
- (void)downSingleNote:(GUID)guidNote target:(id<DownloadItemDelegate>)delegate;
- (void)syncCate;
- (void)searchNotes:(NSString*)searchWord count:(int)count delegate:(id)delegate;

- (void)finishSync:(BOOL)isSuccess;

@end
