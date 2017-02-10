//
//  MBSynManager.m
//  NoteBook
//
//  Created by chen wu on 09-10-14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBSynManager.h"
#import "Global.h"
#import "MBGetDefCataListMsg.h"
#import "MBSubDirListMsg.h"
#import "DBObject.h"
#import "PFunctions.h"
#import "LbsServer.h"
#import "Common.h"
#import "Business.h"
#import "MBCateListMsg.h"
#import "MBNewNoteListMsg.h"
#import "MBSearchNoteMsg.h"
#import "MBNoteThumbMsg.h"
#import "UapMgr.h"

static MBSynManager * manager = nil;

@implementation MBSynManager

+(MBSynManager *)defaultManager
{
	if(manager == nil)
	{
		manager = [[MBSynManager alloc] init];
	}
	return manager;
}

-(id) init {
	if (self = [super init]) {
		itemDownloadDelegate = nil;
	}
	
	return self;
}

- (void)stop
{
    [currentSocket stop];
    
    noteList.clear();
    noteIt = noteList.end();
    note2ItemList.clear();
    abIt = note2ItemList.end();
    
    [self finishSync:NO];
}

- (void)synMoreInfo
{
	//	download more note or item
	if(abIt != note2ItemList.end())
	{
		CMBA2BInfo& a2bInfo = (*abIt);
		
		MBItemInfoMsg *itemRequest =[[MBItemInfoMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
		[itemRequest sendPacketWithData:[Global AckGet] ItemID:a2bInfo.guidSecond version:0 a2binfo:a2bInfo];
        currentSocket = itemRequest;
        tmpA2BInfo = a2bInfo;
        ++abIt;
        return;
	}
    // free item list
    note2ItemList.clear();
    
    //下载完ITEM后,修改note的nNeedDownlord状态
    if (noteIt->nNeedDownlord == 1 && downItemFailedCount == 0)
    {
        noteIt->nNeedDownlord = 0;
        [Business saveNote:*noteIt];
    }
    
    ++noteIt;
    if(noteIt!=noteList.end())
    {
        [self getANote];
        return;
    }

    // free note list
    noteList.clear();

    if ([Global getSyncStatus] == SS_DOWN_BY_DIR && cateIt != cateIDList.end())
    {

        ++cateIt;
        if (cateIt != cateIDList.end())
        {
            [self downNotesInCate:*cateIt];
            return;
        }            
        else if (needDownItem && downUnFinishedNote)
        {
            downUnFinishedNote = NO;
            //批量下载完成后同步完后,获取所有需要下载的笔记列表
            vector<NoteInfo> vecNotes;
            [Business getNeedDownNoteList:guidCateToSync recursive:needDownSubDir noteList:&vecNotes];
            if (!vecNotes.empty())
            {
                noteList.assign(vecNotes.begin(), vecNotes.end());
                noteIt = noteList.begin();
                [self getANote];
                return;
            }
        }
    }
    
    [self finishSync:YES];
}

- (void)syncMoreThumb
{
    ++noteIt;
    if(noteIt != noteList.end())
    {
        [self getANoteThumb];
        return;
    }
    
    //缩略图下载完成后,判断是否下载item
    if ([Global getSyncStatus] == SS_DOWN_BY_DIR && !noteList.empty() && needDownItem)
    {
        noteIt = noteList.begin();
        [self getANote];
        return;
    }
    
    noteList.clear();
    [self finishSync:YES];
}

- (void)getANote
{
    downItemFailedCount = 0;
    
	NoteInfo& noteInfo = *noteIt;
	
	if(noteInfo.tHead.nDelState == STATE_NORMAL)// 未被删除
	{
		MBA2BListMsg *a2bListMsg = [[MBA2BListMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
		[a2bListMsg sendPacketWithData:[Global AckGet] NoteID:noteInfo.guid version:0];
        currentSocket = a2bListMsg;
	}
    else
    {
        abIt = note2ItemList.end();
        [self synMoreInfo];
    }
}

-(void)getNoteListDidSuccessWithData:(CMBNoteListExAck *)items
{
    //如果是下载最新笔记, 设置最新笔记列表
//    if ([Global getSyncStatus] == SS_DOWN_NEWEST)
//    {
//        if (noteListCtrDelegate != nil && [noteListCtrDelegate respondsToSelector:@selector(recentNoteListReceived:)])
//        {
//            [noteListCtrDelegate recentNoteListReceived:&items->m_lstPMBNoteInfoEx];
//        }
//    }
    
    noteList.clear();
    NoteInfo objTemp;
    //保持从服务器获取的NoteInfo
    for (std::list<NoteInfo>::iterator itor = items->m_lstPMBNoteInfoEx.begin(); itor != items->m_lstPMBNoteInfoEx.end(); ++itor)
    {
        NoteInfo& objSrv = *itor;
        objSrv.tHead.nEditState = 0;
        objSrv.tHead.nNeedUpload = 0;
        objSrv.tHead.nSyncState = 0;
        
        BOOL needUpdateObj = NO;   //是否更新本地
        BOOL needDown = NO;     //是否需要下载
        
        NoteInfo objLocal;
        BOOL bRet = [Business getNote:objSrv.guid noteInfo:&objLocal];
        if (!bRet)//本地不存在直接更新
        {
            objTemp = objSrv;
            objTemp.nNeedDownlord = 1;
            needUpdateObj = YES;
            needDown = YES;
        }
        else
        {
            if (objLocal.tHead.nEditState == 0)
            {
                //服务器版本新
                if (objSrv.tHead.dwCurVerID > objLocal.tHead.dwCurVerID)
                {
                    objTemp = objSrv;
                    objTemp.nNeedDownlord = 1;
                    needUpdateObj = YES;     
                    needDown = YES;
                    
                }
                else if(objSrv.tHead.dwCurVerID == objLocal.tHead.dwCurVerID)
                {
                    objTemp = objSrv;
                }
            }
            else
            {
				/*
                //冲突处理
                EM_CONFLICT_POLICY conflictPolicy = [Global conflictPolicy];
                if (conflictPolicy == CP_USE_NEWER)
                {
                    if (unistring(objSrv.tHead.wszModTime) > unistring(objLocal.tHead.wszModTime))
                        conflictPolicy = CP_USE_SERVER;
                    else
                        conflictPolicy = CP_USE_LOCAL;                    
                }
                
                if (conflictPolicy == CP_USE_LOCAL)
                {
                    objTemp = objLocal;
                    objTemp.tHead.dwCurVerID = objSrv.tHead.dwCurVerID;
                    needUpdateObj = YES;   
                }
                else
                {
                    objTemp = objSrv;
                    objTemp.nNeedDownlord = 1;
                    needUpdateObj = YES;   
                    needDown = YES;
                }
				*/
				if (objSrv.tHead.dwCurVerID > objLocal.tHead.dwCurVerID) {
					// 冲突处理
					// 将本地的该笔记重新复制成一份新的笔记
					[Business resaveNote:objLocal];
					
					objTemp = objSrv;
					objTemp.nNeedDownlord = 1;
					needUpdateObj = YES;
					needDown = YES;
				}
				else {
					
				}
            }
        }
        
        if (needUpdateObj)
        {
            [Business saveNote:objTemp];
        }
        
        //采用文件夹下载,需要更新版本号
        if ([Global getSyncStatus] == SS_DOWN_BY_DIR)
        {
            if (objSrv.tHead.dwCurVerID > [Business getTableDirVersion:objSrv.guidCate tableName:"tb_note_info"])
            {
                [Business setTableDirVersion:itor->guidCate tableName:"tb_note_info" version:objSrv.tHead.dwCurVerID];
            }
        }
        
        if (needDown)
        {
            if (objTemp.tHead.nDelState != STATE_DELETE)
            {
                noteList.push_back(objTemp); 
            }
            else
            {
                //删除本地NOTE
                [Business deleteNoteFromDB:objTemp.guid];
            }
        }
    }
    
    if ([Global downNoteThumb] && !noteList.empty())
    {
        noteIt = noteList.begin();
        [self getANoteThumb];
        return;
    }
    
    //是否需要马上下载item
    if ([Global getSyncStatus] == SS_DOWN_BY_DIR && !noteList.empty() && needDownItem)
    {
        noteIt = noteList.begin();
        [self getANote];
        return;
    }
    
    noteList.clear();
    noteIt = noteList.end();
    abIt = note2ItemList.end();
    
    [self synMoreInfo];
    //[self finishSync:YES];
}


- (void)getANoteThumb
{
    NoteInfo& noteInfo = *noteIt;

	if(noteInfo.tHead.nDelState == STATE_NORMAL)// 未被删除
	{
		MBNoteThumbMsg *thumbMsg = [[MBNoteThumbMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
		[thumbMsg sendPacketWithData:[Global AckGet] noteID:noteInfo.guid  version:noteInfo.tHead.dwCurVerID imgWidth:64 imgHeight:64];
        currentSocket = thumbMsg;
	}
    else
    {
        [self syncMoreThumb];
    }
}

- (void)getNoteThumbDidSuccessWithData:(CMBNoteThumbAck*)ack
{
    if (ack->m_unDataLen <= 0 || ack->m_pData == NULL)
    {
        MLOG(@"缩略图数据为空.");
        [self syncMoreThumb];
        return;
    }
    
    NSData* data = [NSData dataWithBytes:ack->m_pData length:ack->m_unDataLen];
    NSString* strExt = @"jpg";
    NSString* thumbFilePath = [CommonFunc getItemPath:noteIt->guid fileExt:[strExt getUnistring]]; //用NoteID所为缩略图名称,放在temp目录
    if (![data writeToFile:thumbFilePath atomically:NO])
    {
        MLOG(@"保存缩略图失败");
    }
    
    [strExt release];
    [self syncMoreThumb];
}

- (void)getNoteThumbDidFailedWithError:(NSError*)error
{
    MLOG(@"%@", error);
    
    [self syncMoreThumb];
}

-(void)getA2BListDidSuccessWithData:(CMBA2BListAck *)items
{
    note2ItemList.clear();
    
	// 是否有冲突的标识
	BOOL bConflict = NO;
	BOOL bResave = NO;
	
    for(std::list<CMBA2BInfo>::iterator itor = items->m_lstPA2BInfo.begin(); 
        itor != items->m_lstPA2BInfo.end(); ++itor)
    {
        CMBA2BInfo& objSrv = *itor;
        objSrv.tHead.nEditState = 0;
        
        A2BInfo objTemp;
        A2BInfo objLocal;
        BOOL needDown = NO;     //是否需要下载
        BOOL bRet = [Business getNote2Item:objSrv.guidFirst itemID:objSrv.guidSecond note2ItemInfo:&objLocal];
        if (!bRet)
        {
            objTemp = objSrv;
            needDown = YES;
        }
        else
        {
			NoteInfo ni;
			[Business getNote:objLocal.guidFirst noteInfo:&ni];
            if (ni.tHead.nEditState == 0)
            {
                //服务器版本新
                if (objSrv.tHead.dwCurVerID > objLocal.tHead.dwCurVerID)
                {
                    objTemp = objSrv;      
                    needDown = YES;
                }
                else
                {
                    //判断Item文件是否存在
                    NSString * strItemFile = [CommonFunc getItemPath:noteIt->guidFirstItem fileExt:noteIt->wszFileExt];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:strItemFile])
                    {
                        objTemp = objSrv;
                        needDown = YES;
                    }
                }
            }
            else
            {
				// 有冲突
				if (objSrv.tHead.dwCurVerID > objLocal.tHead.dwCurVerID) {
					objTemp = objSrv;
					needDown = YES;
					//objTemp.tHead.dwCurVerID = objSrv.tHead.dwCurVerID;
					
					if (!bResave) {
						// 将已经存在的笔记文件重新保存一份
						[Business resaveNoteWithGuid:objLocal.guidFirst];
						[Business resetNote:ni];
						
						if (itemDownloadDelegate) {
							[itemDownloadDelegate conflictNote:objSrv.guidFirst];	
						}
						
						bResave = YES;
					}
				}
				else {
					// 此处不用做处理
				}
                //冲突处理
				/*
                EM_CONFLICT_POLICY conflictPolicy = [Global conflictPolicy];
                if (conflictPolicy == CP_USE_NEWER)
                {
                    if (unistring(objSrv.tHead.wszModTime) > unistring(objLocal.tHead.wszModTime))
                        conflictPolicy = CP_USE_SERVER;
                    else
                        conflictPolicy = CP_USE_LOCAL;                    
                }
                
                if (conflictPolicy == CP_USE_LOCAL)
                {
                    objTemp = objLocal;
                    objTemp.tHead.dwCurVerID = objSrv.tHead.dwCurVerID;
                }
                else
                {
                    objTemp = objSrv;
                    needDown = YES;
                }*/
            }
        }
        
        if (needDown)
        {
            if (objTemp.tHead.nDelState != STATE_DELETE)
            {
                note2ItemList.push_back(objTemp);
            }
            else
            {
                //已删除,不需要下载item
                [Business saveNote2ItemFromSrv:objTemp];
            }
        }
    }
	
	if (!note2ItemList.empty())
	{
		if (itemDownloadDelegate) {
			[itemDownloadDelegate toDownloadItem];	
			itemDownloadDelegate = nil;
		}
		
        abIt = note2ItemList.begin();
		CMBA2BInfo& a2bInfo = (*abIt);
		
		MBItemInfoMsg *itemRequest = [[MBItemInfoMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
		[itemRequest sendPacketWithData:[Global AckGet] ItemID:a2bInfo.guidSecond version:0 a2binfo:a2bInfo];
        currentSocket = itemRequest;
        tmpA2BInfo = a2bInfo;
		abIt++;
	}
    else
    {
        abIt = note2ItemList.end();
        [self synMoreInfo];
    }
}

-(void)getItemInfoDidSuccessWithData:(CMBItemNewAck *)items
{
	
	//	analysis item data	
	CMBItemNew& item = items->m_pItemNew;
    item.tHead.nEditState = 0;
	
	NSString *itemFilePath = [CommonFunc getItemPath:item.guid fileExt:item.wszFileExt];
	
	//	save data to file
//	if(item.nNoteItemType == NI_HTML || item.nNoteItemType == NI_TEXT)
//	{
//		char * data = (char *)item.m_pData;
//		
//		if(item.m_unDataLen>0)
//		{
//#ifdef USE_UTF8
//            NSStringEncoding htmlEncoding = NSUTF8StringEncoding;
//#else 
//            NSStringEncoding htmlEncoding = NSUnicodeStringEncoding;
//#endif
//            
//            NSString * str = [[NSString alloc] initWithBytes:data length:item.m_unDataLen encoding:NSUnicodeStringEncoding];
//            item.m_unDataLen = [str length];
//			if([str writeToFile:itemFilePath atomically:1 encoding:htmlEncoding error:nil])
//			{
//                [Business saveItem:item];
//			}
//            
//            if (item.m_pData)
//            {
//                delete [] item.m_pData;
//                item.m_pData = NULL;
//            }
//            [str release];
//		}
//	}
//    else
//	{
        NSData * data= [[NSData alloc] initWithBytes:(char *)item.m_pData length:item.m_unDataLen];
        if (item.m_pData)
        {
            delete [] item.m_pData;
            item.m_pData = NULL;
        }
        
        if([data writeToFile:itemFilePath atomically:1])
        {
            [Business saveItem:item];
        }
        [data release];
//    }

    //item下载完成后,再保持note2item
    [Business saveNote2Item:tmpA2BInfo];
	
	[self synMoreInfo];
	
}

-(void)getItemInfoDidFailedWithError:(NSError *)error
{
	MLOG(@"下载 iTEM 失败，%@",[error description]);
	downItemFailedCount++;
    
//    if (noteIt != noteList.end() && abIt != note2ItemList.end())
//    {
//        //firstItem下载失败,其他的ITEM就不需要下载了
//        if (noteIt->guidFirstItem == abIt->guidSecond)
//        {
//            abIt = note2ItemList.end();
//        }        
//    }
    
	[self synMoreInfo];
}

-(void)requiredReLogin
{/*
	MLOG(@"与服务器断开链接!,开始重连");
	
	NSString *usrName = [PFunctions getUserName];
	NSString *passWd  = [PFunctions getPassword];
	LbsServer *sv = [LbsServer shareLbServer];
    
    if( sv.bIsLBSLogined)
    {
        [sv reloginAppSvr];
    }
	else
    {
        [sv createWithUsername:usrName Password:passWd APpType:@"6" delegate:self];
        [sv startLogin];	
    }*/
}

-(void)getNoteListDidFailedWithError:(NSError *)error
{
//	NSString * reason = [error domain];
//	if([reason isEqualToString:TIME_OUT]&&[Global GetConnectState])// 超时
//	{
//		[Global InitConnectState:NO];
//		[self requiredReLogin];
//	}
//    else
//	{
//		[[NSNotificationCenter defaultCenter] postNotificationName:kHaveSynDataNotification object:nil];
//	}
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    MLOG(@"Error: %@", error);
    
    [self finishSync:NO];
}

-(void)getA2BListDidFailedWithError:(NSError *)error
{
	MLOG(@"下载关联关系失败 code %@",[error description]);
	
//	itemList = NULL;
    note2ItemList.clear();
    abIt = note2ItemList.end();
	[self synMoreInfo];
}

-(void)loginDidFailedWithError:(NSError *)error
{
	MLOG(@"链接失败!");
}

-(void)loginDidSuccessWithData:(NSData *)data inputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output
{
	MLOG(@"重连成功");
	
	[Global InitConnectState:YES];
    
	CMBUserLoginExAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	[Global AckCpy:data ];
	[Global SaveInputStream:input];
	[Global SaveOutputStream:output];
	
	int userID = ack.m_dwAppUserID;
	NSString *uID = [NSString stringWithFormat:@"%d", userID];
	[Global InitUsrID:uID];
	[Global setLogin:YES];
    
	[PFunctions setAccount:[Global userAccount]];
	[PFunctions setLogInfo:[Global userAccount]];
	[PFunctions setUserId:uID];
	
    [Business setDBPath:[CommonFunc getDBPath]];
    [Business setMasterKey:ack.m_ucMasterKey length:sizeof(ack.m_ucMasterKey)];
	
		//登陆UAP
	[[UapMgr instance] uapLoginAsync];
	
	if ([Global defaultCateID] == GUID_NULL)
	{
		MBGetDefCataListMsg *defaultDirMsg = [[MBGetDefCataListMsg shareMsg] initWithInput:input Output:output target:self];
		[defaultDirMsg sendPacketWithData:data];
        currentSocket = defaultDirMsg;
	}
}

//接收默认文件夹成功
-(void)getDefDirDidSuccessWithData:(CMBGetDefCataListAck *)items
{
	if ([Global defaultCateID] == GUID_NULL)
	{
		MLOG(@"获取目录成功!");
		CMBCateInfo cateInfo = *(items->m_lstPMBCateInfo.begin());
        cateInfo.tHead.nEditState = 0;
        [Business saveCate:cateInfo];
        
        //保持默认文件夹GUID
        string strDefaultId = [CommonFunc guidToString:cateInfo.guid];
        [Business setCfgString:"user" name:"defaultCateID" value:strDefaultId.c_str()];
        [Global setDefaultCateID:cateInfo.guid];
	}
}

-(void)getDefDirDidFailedWithError:(NSError *)error
{
    LOG(@"获取目录失败!");
//	[Global SaveCateStruct:nil];
}

- (void) dealloc
{
	noteList.clear();
    note2ItemList.clear();
	[super dealloc];
}

- (void)downNewNotes:(int)nIndex count:(int)count  delegate:(id)delegate
{
    [Global setSyncStatus:SS_DOWN_NEWEST];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    noteListCtrDelegate = delegate;
    MBNewNoteListMsg *newNoteListMsg = [[MBNewNoteListMsg shareMsg]  initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    [newNoteListMsg sendPacketWithData:[Global AckGet] fromVersion:0 count:nIndex + count];
    currentSocket = newNoteListMsg;
}

- (void)downByCate:(GUID)guidCate downSubCate:(BOOL)downSubCate downItem:(BOOL)downItem;
{
    downUnFinishedNote = YES;
    needDownSubDir = downSubCate;
    needDownItem = downItem;
    guidCateToSync = guidCate;
    
    [Global setSyncStatus:SS_DOWN_BY_DIR];
    
    [self syncCate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)getAllDirListDidSuccessWithData:(CMBAllDirListAck *)items
{
    std::list<CMBCateInfo>& tmpCateList = items->m_lstPMBCateInfo;
    for(std::list<CMBCateInfo>::iterator itor = tmpCateList.begin(); itor != tmpCateList.end(); ++itor)
    {
        [Business saveCateFromSvr:*itor];
    }
    
    EM_SYNC_STATUS syncStatus = [Global getSyncStatus];
    switch (syncStatus) 
    {
        case SS_DOWN_CATE:
            {
                [self finishSync:YES];
                return;
            }
            break;
        case SS_DOWN_BY_DIR:
            {
                cateIDList.clear();
                cateIDList.push_back(guidCateToSync);
                
                //是否需要下载子文件夹
                if (needDownSubDir && guidCateToSync != GUID_NULL)
                {
                    vector<GUID> tmpCateIDList;
                    tmpCateIDList.push_back(guidCateToSync);
                    
                    for (int i = 0; i < tmpCateIDList.size(); i++)
                    {
                        [Business getCateIDList:tmpCateIDList[i] cateList:&tmpCateIDList];
                    }
                    
                    cateIDList.assign(tmpCateIDList.begin(), tmpCateIDList.end());
                }
                
                cateIt = cateIDList.begin();
                [self downNotesInCate:*cateIt];
                return;
            }
            break;
        default:
            break;
    }
}

-(void)getAllDirListDidFailedWithError:(NSError*)error
{
    MLOG(@"%@", error);
    
    [self finishSync:NO];
}

- (void)downNotesInCate:(GUID)guidCate
{
    MBNoteListMsg *noteListMsg = [[MBNoteListMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
	[noteListMsg sendPacketWithData:[Global AckGet] parentGUID:guidCate version:[Business getTableDirVersion:guidCate tableName:"tb_note_info"]];
    currentSocket = noteListMsg;
}

- (void)downSingleNote:(GUID)guidNote target:(id<DownloadItemDelegate>)delegate
{
	
	NSLog(@"downSingleNote: %@", [CommonFunc guidToNSString:guidNote]);
	
	itemDownloadDelegate = delegate;
	
    guidNoteToDown = guidNote;
    [Global setSyncStatus:SS_DOWN_SINGEL_NOTE];
    
    NoteInfo objNote;
    if (![Business getNote:guidNote noteInfo:&objNote])
    {
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    note2ItemList.clear();
    abIt = note2ItemList.end();
    
    noteList.clear();
    noteList.push_back(objNote);
    noteIt = noteList.begin();
    
    [self getANote];
}

- (void)syncCate
{
    MBCateListMsg *dirListMsg = [[MBCateListMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    [dirListMsg sendPacketWithData:[Global AckGet] parentGUID:GUID_NULL version:[Business getCateMaxVersion]];
    currentSocket = dirListMsg;
}

- (void)downCates
{
    [Global setSyncStatus:SS_DOWN_CATE];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self syncCate];
}

- (void)searchNotes:(NSString*)searchWord count:(int)count delegate:(id)delegate;
{
    noteListCtrDelegate = delegate;
    
    [Global setSyncStatus:SS_DOWN_SEARCH];
    MBSearchNoteMsg* searchMsg = [[MBSearchNoteMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    [searchMsg sendPacketWithData:[Global AckGet]  searchWord:[searchWord getUnistring] count:count];
    currentSocket = searchMsg;
}
            
-(void)getSearchNoteDidSuccessWithData:(CMBSearchNoteExAck *)items
{
    //如果是搜索,保存搜索结果
    if ([Global getSyncStatus] == SS_DOWN_SEARCH)
    {
        if (noteListCtrDelegate != nil && [noteListCtrDelegate respondsToSelector:@selector(searchResultReceived:searchCount:)])
        {
            [noteListCtrDelegate searchResultReceived:&items->m_lstPMBNoteInfoEx searchCount:items->m_unTotalCnt];
        }
    }
    
    CMBNoteListExAck noteListAck;
    noteListAck.m_lstPMBNoteInfoEx = items->m_lstPMBNoteInfoEx;
    [self getNoteListDidSuccessWithData:&noteListAck];
}

-(void)getSearchNoteDidFailedWithError:(NSError *)error
{
    MLOG(@"Error: %@", error);
    [self finishSync:NO];
}



- (void)finishSync:(BOOL)isSuccess
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    EM_SYNC_STATUS syncStatus = [Global getSyncStatus];
    [Global setSyncStatus:SS_NONE];
    switch (syncStatus) 
    {
        case SS_DOWN_CATE:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownCatesNotification object:nil];
            }
            break;
        case SS_DOWN_BY_DIR:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownNotesByCateNotification object:nil];
            }
            break;
        case SS_DOWN_NEWEST:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownNewNotesNotification object:nil];
            }
            break;
        case SS_DOWN_SINGEL_NOTE:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDownSingleNotesNotification object:nil];
            }
            break;
        case SS_DOWN_SEARCH:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:KDownSearchNotesNotificatiton object:nil];
            }
            break;
        default:
            break;
    }
}

@end
