//
//  MBListener.mm
//  NoteBook
//
//  Created by chen wu on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "DBObject.h"
#import "MBListener.h"
#import "Global.h"
#import "PFunctions.h"
#import "LbsServer.h"
#import "Plist.h"
#import "Business.h"
#import "MBNoteThumbMsg.h"
#import "UapMgr.h"

static MBListener * listener = NULL;


@implementation MBListener
@synthesize delegate;

- (void) dealloc
{
	[super dealloc];
}

+ (id)defaultListener
{
	if(	listener == NULL)
	{
		listener = [[MBListener alloc] init];
	}
	return listener;
}

- (void)stop
{
    [currentSocket stop];
    
    noteList.clear();
    noteIterator = noteList.end();
    itemList.clear();
    itemIterator = itemList.end();
	MLOG(@"MBListener.mm: in stop, itemIterator set to be an invalid value and itemList is cleared!");
    
    [self uploadFinished:NO];
}

- (void)uploadNoteList:(std::list<NoteInfo>*)pNoteList
{
    if (pNoteList->empty())
    {
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [Global setSyncStatus:SS_UPLOAD_NOTE_LIST];
    
    noteList.clear();
    noteList = *pNoteList;
    noteIterator = noteList.begin();
    itemList.clear();
    itemIterator = itemList.end();
    
	if ([Global GetConnectState] == NO)
	{/*
		MLOG(@"开始自动重连...>>>>");
		
		NSString *usrNames = [PFunctions getUserName];
		NSString *passWds  = [Global getPassWordFromMemory];//[[PFunctions getPassword] copy];
		MLOG(@"usr[%@],pass[%@]", usrNames, passWds);
		LbsServer *sv = [LbsServer shareLbServer];
        
        if(sv.bIsLBSLogined)
        {
            [sv reloginAppSvr];
        }
        else
        {
            [sv createWithUsername:usrNames Password:passWds APpType:@"6" delegate:self];
            [sv startLogin];
            MLOG(@"bbb>>>");            
        }
        return;*/
	}
    
    //开始上传
    [self startUpload];
}

- (void)startUpload
{
    if (noteList.empty())
    {
        [self uploadFinished:YES];
        return;;
    }
    
    [self uploadANote];
}

- (void)uploadANote
{
    isItemUploadSuccess = YES;
    itemList.clear();
    [Business getNeedUploadItemList:noteIterator->guid itemList:&itemList];
    itemIterator = itemList.begin();
	
    //先上传noteInfo
    [self uploadNoteInfo];
    return;
}

//上传item ,返回NO代表没有ITEM被上传,
- (void)uploadAItem
{
    if (itemIterator == itemList.end())
    {
        [self uploadMore];
        return;
    }
    
    A2BInfo a2bInfo;
    [Business getNote2Item:noteIterator->guid itemID:itemIterator->guid note2ItemInfo:&a2bInfo];
    //如果需要上传note2item,先上传note2item,完成后再上传item
    if ([Business needUpload:&a2bInfo.tHead])
    {
        MBUpLoadA2BInfoMsg* uploadA2BMsg = [[MBUpLoadA2BInfoMsg shareMsg] initWithInput:[Global GetInputStream] 
                                                                                 Output:[Global GetOutputStream] target:self];
        currentSocket = uploadA2BMsg;
        std::list<A2BInfo> a2bList;
        a2bList.push_back(a2bInfo);
        [uploadA2BMsg uploadWithUserInfo:[Global AckGet] Body:&a2bList];
        return;
    }
    
    //直接上传ITEM
    [self uploadItemInfo];
    return;
}

- (void)uploadItemInfo
{
    //直接上传ITEM
    ItemInfo& itemInfo = *itemIterator;
    if (![CommonFunc loadItemData:&itemInfo])
    {
        //item文件不存在,跳过
        [self uploadMore];
        return;
    }
    
    MBUpLoadItemMsg* uploadItemMsg = [[MBUpLoadItemMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    currentSocket = uploadItemMsg;
	[uploadItemMsg uploadWithUserInfo:[Global AckGet] content:&itemInfo];
    
    itemIterator->ReleaseBuf();
}

//上传noteInfo
- (void)uploadNoteInfo
{
    MBUpLoadNoteMsg* uploadNoteMsg = [[MBUpLoadNoteMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    currentSocket = uploadNoteMsg;
    std::list<NoteInfo> tmpNoteList;
    tmpNoteList.push_back(*noteIterator);
    [uploadNoteMsg uploadWithUserInfo:[Global AckGet] Body:&tmpNoteList];
}

- (void)uploadMore
{
    currentSocket = nil;
    if (itemList.size() != 0 && itemIterator != itemList.end())
    {
        ++itemIterator;
		
		MLOG(@"MBListener.mm: in uploadMore, itemIterator plus 1 itself, itemlist Count %d		self:%d", itemList.size(), (void*)self);
        //进行上传item
        if (itemIterator != itemList.end())
        {
            [self uploadAItem];
            return;
        }
        else
        {
            if (isItemUploadSuccess)
            {
                //item上传完成note设置为上传完成
                noteIterator->tHead.nEditState = 0;
                [Business saveNote:*noteIterator];
                
                //下载缩略图
//                if (noteIterator->tHead.nDelState != STATE_DELETE)
//                {
//                    [self getANoteThumb];
//                    return;
//                }
            }

        }
    }
    itemList.clear();
	itemIterator = itemList.end();
	MLOG(@"MBListener.mm: in uploadMore, all the item in itemList is done, clear itemList		self:%d", (void*)self);
    
    if (noteIterator != noteList.end())
    {
        ++noteIterator;
        if (noteIterator != noteList.end())
        {
            [self uploadANote];
            return;
        }
    }
    noteList.clear();
    
    [self uploadFinished:YES];
}

- (void)uploadFinished:(BOOL)isSuccess
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    EM_SYNC_STATUS syncStatus = [Global getSyncStatus];
    [Global setSyncStatus:SS_NONE];
    switch (syncStatus) 
    {
        case SS_UPLOAD_NOTE_LIST:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUploadNoteListNotification object:nil];
        }
        default:
            break;
    }
}

#pragma mark <upLoad delegate>

-(void)upLoadNoteDidSuccessWithData:(CMBUpLoadNoteExAck *)ack
{
    //笔记上传完成
    CSglKeyUpLoadRslt& rsp = *ack->m_lstPUpLoadRslt.begin();
    NoteInfo& objNote = *noteIterator;
    
    objNote.tHead.dwCurVerID = rsp.m_dwCurVid;
    
    //没有ITEM需要被上传,直接更新nEditState,否则等到所有ITEM都成功上传后再更新
    if (itemIterator == itemList.end())
    {
        objNote.tHead.nEditState = 0;
        [Business saveNote:objNote];
        [self uploadMore];
    }
    else
    {
		objNote.tHead.nEditState = 0;
        [Business saveNote:objNote];
        [self uploadAItem];
    }
}

-(void)upLoadNoteDidFailedWithError:(NSError *)error
{
	MLOG(@"上传 note 失败,noteid = %@, error = %@", [CommonFunc guidToNSString:noteIterator->guid], [error description]);
	
    [self uploadMore];
}

-(void)upLoadA2BInfoDidSuccessWithData:(CMBUpLoadA2BInfoAck *)ack
{
    CDblKeyUpLoadRslt& rsp = *ack->m_lstPUpLoadRslt.begin();
    if (rsp.m_dwResult != 0)
    {
        MLOG(@"上传note2item失败");
        isItemUploadSuccess = NO;
        [self uploadMore];
    }
    
    A2BInfo a2bInfo;
    [Business getNote2Item:noteIterator->guid itemID:itemIterator->guid note2ItemInfo:&a2bInfo];
    a2bInfo.tHead.nEditState = 0;
    a2bInfo.tHead.dwCurVerID = rsp.m_dwCurVid;
    [Business saveNote2ItemFromSrv:a2bInfo];
    
    //已经被删除的ITEM不需要上传
    if (a2bInfo.tHead.nDelState == STATE_DELETE)
    {
        [self uploadMore];
        return;
    }
    
    //note2item上传完成,开始上传item
	[self uploadItemInfo];
}

-(void)upLoadA2BInfoDidFailedWithError:(NSError *)error
{
	MLOG(@"上传关联关系失败，%@",error);
	isItemUploadSuccess = NO;
    
    [self uploadMore];
}

- (void)getANoteThumb
{
    NoteInfo& noteInfo = *noteIterator;
    
    MBNoteThumbMsg *thumbMsg = [[MBNoteThumbMsg shareMsg] initWithInput:[Global GetInputStream] Output:[Global GetOutputStream] target:self];
    [thumbMsg sendPacketWithData:[Global AckGet] noteID:noteInfo.guid  version:noteInfo.tHead.dwCurVerID imgWidth:64 imgHeight:64];
    currentSocket = thumbMsg;
}

- (void)getNoteThumbDidSuccessWithData:(CMBNoteThumbAck*)ack
{
    if (ack->m_unDataLen <= 0 || ack->m_pData == NULL)
    {
        MLOG(@"缩略图数据为空.");
        [self uploadMore];
        return;
    }
    
    NSData* data = [NSData dataWithBytes:ack->m_pData length:ack->m_unDataLen];
    NSString* strExt = @"jpg";
    NSString* thumbFilePath = [CommonFunc getItemPath:noteIterator->guid fileExt:[strExt getUnistring]]; //用NoteID所为缩略图名称,放在temp目录
    if (![data writeToFile:thumbFilePath atomically:NO])
    {
        MLOG(@"保存缩略图失败");
    }
    
    [strExt release];
    [self uploadMore];
}

- (void)getNoteThumbDidFailedWithError:(NSError*)error
{
    MLOG(@"%@", error);

    [self uploadMore];
}

-(void)upLoadItemDidSuccessWithData:(CMBUpLoadItemNewAck *)ack
{
    CSglKeyUpLoadRslt& rsp = *ack->m_lstPUpLoadRslt.begin();
    
	ItemInfo *pInfo = &(*itemIterator);
	
    pInfo->tHead.dwCurVerID = rsp.m_dwCurVid;
    pInfo->tHead.nEditState = 0;
    [Business saveItem:*pInfo];
    
	[self uploadMore];
    
    //获取note2item的当前版本号,防止item重复下载
}

-(void)upLoadItemDidFailedWithError:(NSError *)error
{
	MLOG(@"上传Item 失败，%@",error);
	isItemUploadSuccess = NO;
    
    [self uploadMore];
}

#pragma mark <loginDelegate>
-(void)loginDidSuccessWithData:(NSData *)data inputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output
{
	MLOG(@"重连成功");
	[Global InitConnectState:YES];
    [Global setUserAccount:[PFunctions getUsernameFromKeyboard]];
	CMBUserLoginExAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	[Global AckCpy:data ];
	[Global SaveInputStream:input ];
	[Global SaveOutputStream:output];
	
	int userID = ack.m_dwAppUserID;
	NSString *uID = [NSString stringWithFormat:@"%d", userID];
	[Global InitUsrID:uID];
	[Global setLogin:YES];
	
    	//登陆UAP
	[[UapMgr instance] uapLoginAsync];
    
	[PFunctions setAccount:[Global userAccount]];
	[PFunctions setLogInfo:[Global userAccount]];
	[PFunctions setUserId:uID];
	
    [Business setDBPath:[CommonFunc getDBPath]];
    [Business setMasterKey:ack.m_ucMasterKey length:sizeof(ack.m_ucMasterKey)];
	
    [self startUpload];
}

-(void)loginDidFailedWithError:(NSError *)error
{
	MLOG(@"链接失败!");
	[Global InitConnectState:NO];
	[Global InitUsrID:nil]; 
}

-(void)requiredReLogin
{/*
	MLOG(@"与服务器断开链接!,开始重连");
	[Global InitConnectState:NO];
	*/
}

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

	[self startUpload];
}

-(void)getDefDirDidFailedWithError:(NSError *)error
{
//	[Global SaveCateStruct:nil];
    //	[dirMsg release];
	LOG(@"获取目录失败!");
}

@end
