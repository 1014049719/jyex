//
//  MBNoteListMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "MBDataStruct.h"
#import "MBNoteListMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;

@implementation MBNoteListMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBNoteListMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str{
    
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getNoteListDidFailedWithError:)]){
		[delegate getNoteListDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
}

-(void)sendPacketWithData:(NSData *)data parentGUID:(GUID)guidDir version:(unsigned int)dwVerFrom{
	CMBNoteListExReq req;
	memcpy(&req, [data bytes], [data length]);
	
	int unLen=sizeof(req.m_dwConnectionID) + sizeof(req.m_dwDbID) + sizeof(req.m_dwAppUserID)+sizeof(guidDir)+sizeof(dwVerFrom)
                    + sizeof(req.m_szReserve);
	
	char* pSend = new(std::nothrow) char[unLen];
	if (NULL == pSend){
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}
	memset(pSend, 0, unLen);
	
	//拼装数据
    char *p = pSend;
	memcpy(p, &req.m_dwConnectionID, sizeof(req.m_dwConnectionID));
    p += sizeof(req.m_dwConnectionID);
	
    memcpy(p, &req.m_dwDbID, sizeof(req.m_dwDbID));
    p += sizeof(req.m_dwDbID);
	
    memcpy(p, &req.m_dwAppUserID, sizeof(req.m_dwAppUserID));
    p += sizeof(req.m_dwAppUserID);
	
    memcpy(p, &guidDir, sizeof(guidDir));
    p += sizeof(guidDir);  
	
    memcpy(p, &dwVerFrom, sizeof(dwVerFrom));
    p += sizeof(dwVerFrom);
    
    memcpy(p, req.m_szReserve, sizeof(req.m_szReserve));
    p += sizeof(req.m_szReserve);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_GET_NOTE_LIST_EX_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data{
	[self stopTimer];
	
	CMBRspURL MBRspURL;
	int code=MBRspURL.Decode((char *)[data bytes], [data length]);
	if(RET_SUCCESS!=code)
	{
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",code]];
		return;
	}
	if(MBRspURL.m_nRetCode!=0)
	{
        //记录为空是正常的
        if (MBRspURL.m_nRetCode == RET_DB_NO_SUCH_RECORD)
        {
            CMBNoteListExAck ack;
            [self stopTimer];
            if(delegate!=nil&&[delegate respondsToSelector:@selector(getNoteListDidSuccessWithData:)])
            {
                [delegate getNoteListDidSuccessWithData:&ack];
            } 
            return;
        }
        else
        {
            [self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",MBRspURL.m_nRetCode]];
            return;   
        }
	}
    
    [self downloadAndUnzipDataAnsyc:&MBRspURL];
//	NSData *myData=[self downloadAndUnzipData:&MBRspURL];
//	
//	if(myData==nil){
//		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
//		return;
//	}
//	
//	CMBNoteListExAck ack;
//	
//	unsigned int unLen=[myData length];
//	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) 
//                            + sizeof(ack.m_nRetCode) + sizeof(ack.m_szReserve);
//	unMinLen+=sizeof(unsigned int);
//	
//    if (unLen < unMinLen)
//    {
//        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//    }
//	
//    char *p=(char *)[myData bytes];
//	
//    unsigned int unOffSet = 0;//这个在没有指针的类中其实没有用
//	
//	ack.m_dwConnectionID = *((unsigned int*)p);
//    p += sizeof(ack.m_dwConnectionID);
//    unOffSet += sizeof(ack.m_dwConnectionID);
//	
//    ack.m_dwDbID = *((unsigned int*)p);
//    p += sizeof(ack.m_dwDbID);
//    unOffSet += sizeof(ack.m_dwDbID);
//	
//    ack.m_dwAppUserID = *((unsigned int*)p);
//    p += sizeof(ack.m_dwAppUserID);
//    unOffSet += sizeof(ack.m_dwAppUserID);  
//	
//    ack.m_nRetCode = *((int *)p);
//    p += sizeof(ack.m_nRetCode);
//    unOffSet += sizeof(ack.m_nRetCode);
//    
//    memcpy(ack.m_szReserve, p, sizeof(ack.m_szReserve));
//    p += sizeof(ack.m_szReserve);
//    unOffSet += sizeof(ack.m_szReserve);
//	
//    unsigned int unCnt =  *((unsigned int *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//	
//    // ack.ReleaseBuf();
//	
//    for (unsigned int i = 0; i < unCnt; i++)
//    {
//        unOffSet += offsetof(CMBNoteInfoEx, strTitle);
//        if (unOffSet > unLen)
//        {
//			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
//		
//        CMBNoteInfoEx pMBNoteInfo;
//        memcpy(&pMBNoteInfo, p, offsetof(CMBNoteInfoEx, strTitle));
//        p += offsetof(CMBNoteInfoEx, strTitle);
//		
//        unsigned int unStrLen = (wcslen_m((char *)p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
////        pMBNoteInfo->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
////        memcpy(pMBNoteInfo->pwszTitle, p, unStrLen);
//        pMBNoteInfo.strTitle = (unichar*)p;
//		
//        p += unStrLen;
//		
//        unStrLen = (wcslen_m((char *)p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
////        pMBNoteInfo->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
////        memcpy(pMBNoteInfo->pwszAddr, p, unStrLen);
//         pMBNoteInfo.strAddr = (unichar*)p;
//		
//        p += unStrLen;
//		
//        unStrLen = (wcslen_m((char *)p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
////        pMBNoteInfo->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
////        memcpy(pMBNoteInfo->pwszSrc, p, unStrLen);
//        pMBNoteInfo.strSrc = (unichar*)p;
//		
//        p += unStrLen;
//        //		MLOG(@"下载数据测试～～～～～～");
//        //		MLOG(@"i = %d,noteId = %@ \t itemId = %@",i,GUID2NSString(&pMBNoteInfo->guid),GUID2NSString(&pMBNoteInfo->guidFirstItem));
//        //		MLOG(@"i = %d,创建时间 %S", i,pMBNoteInfo->tHead.wszCreateTime);
//        //		MLOG(@"i = %d,修改时间 %S", i,pMBNoteInfo->tHead.wszModTime);
//        //		MLOG(@"i = %d,标题 %S",i,pMBNoteInfo->pwszTitle);
//        //		MLOG(@"i = %d,创建版本号：%d，修改版本号：%d",pMBNoteInfo->tHead.dwCreateVerID,pMBNoteInfo->tHead.dwCurVerID);
//        ack.m_lstPMBNoteInfoEx.push_back(pMBNoteInfo);
//    }
//	
//	if(ack.m_nRetCode==0)
//    {
//		if(delegate!=nil&&[delegate respondsToSelector:@selector(getNoteListDidSuccessWithData:)])
//        {
//			[delegate getNoteListDidSuccessWithData:&ack];
//		} 
//	}
//    else
//    {
//		MLOG([NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]);
//		[self throwErrorWithStr:[NSString stringWithFormat:NO_LIST]];
//		
//	}	
}

-(void)handleZipFileFromSrv:(NSData *)myData
{
    if(myData==nil)
    {
		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
		return;
	}
	
	CMBNoteListExAck ack;
	
	unsigned int unLen=[myData length];
	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) 
    + sizeof(ack.m_nRetCode) + sizeof(ack.m_szReserve);
	unMinLen+=sizeof(unsigned int);
	
    if (unLen < unMinLen)
    {
        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
    }
	
    char *p=(char *)[myData bytes];
	
    unsigned int unOffSet = 0;//这个在没有指针的类中其实没有用
	
	ack.m_dwConnectionID = *((unsigned int*)p);
    p += sizeof(ack.m_dwConnectionID);
    unOffSet += sizeof(ack.m_dwConnectionID);
	
    ack.m_dwDbID = *((unsigned int*)p);
    p += sizeof(ack.m_dwDbID);
    unOffSet += sizeof(ack.m_dwDbID);
	
    ack.m_dwAppUserID = *((unsigned int*)p);
    p += sizeof(ack.m_dwAppUserID);
    unOffSet += sizeof(ack.m_dwAppUserID);  
	
    ack.m_nRetCode = *((int *)p);
    p += sizeof(ack.m_nRetCode);
    unOffSet += sizeof(ack.m_nRetCode);
    
    memcpy(ack.m_szReserve, p, sizeof(ack.m_szReserve));
    p += sizeof(ack.m_szReserve);
    unOffSet += sizeof(ack.m_szReserve);
	
    unsigned int unCnt =  *((unsigned int *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
	
    for (unsigned int i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(NoteInfo, strTitle);
        if (unOffSet > unLen)
        {
			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }
		
        NoteInfo pMBNoteInfo;
        memcpy(&pMBNoteInfo, p, offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
		
        unsigned int unStrLen = (wcslen_m((char *)p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }

        pMBNoteInfo.strTitle = (unichar*)p;
		
        p += unStrLen;
		
        unStrLen = (wcslen_m((char *)p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }

        pMBNoteInfo.strAddr = (unichar*)p;
		
        p += unStrLen;
		
        unStrLen = (wcslen_m((char *)p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }

        pMBNoteInfo.strSrc = (unichar*)p;
        p += unStrLen;
        
        pMBNoteInfo.tHead.nEditState = 0;
        pMBNoteInfo.tHead.nNeedUpload = 0;
        pMBNoteInfo.tHead.nSyncState = 0;
        ack.m_lstPMBNoteInfoEx.push_back(pMBNoteInfo);
    }
	
	if(ack.m_nRetCode==0)
    {
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getNoteListDidSuccessWithData:)])
        {
			[delegate getNoteListDidSuccessWithData:&ack];
		} 
	}
    else
    {
		MLOG([NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]);
		[self throwErrorWithStr:[NSString stringWithFormat:NO_LIST]];
		
	}	
}

-(void)dealloc{
    [s_PSocket release];
	[super dealloc];
}
@end
