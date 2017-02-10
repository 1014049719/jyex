//
//  MBSearchNoteMsg.mm
//  NoteBook
//
//  Created by wangsc on 10-10-19.
//  Copyright 2010 ND. All rights reserved.
//

#import "MBSearchNoteMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;

@implementation MBSearchNoteMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBSearchNoteMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getSearchNoteDidFailedWithError:)])
    {
		[delegate getSearchNoteDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
}

-(void)sendPacketWithData:(NSData *)data searchWord:(unistring)searchWord count:(int)count;
{
	CMBSearchNoteExReq req;
	memcpy(&req, [data bytes], [data length]);
	
    uint32_t nOrderType = 0;    //从新到旧
    
	int unLen = sizeof(req.m_dwConnectionID) + sizeof(req.m_dwDbID) + sizeof(req.m_dwAppUserID) + 
                sizeof(req.m_unLimitCnt) + sizeof(req.m_unOrderType);
	unLen += 2 * sizeof(uint32_t);   //两个空字符串
    
    unLen += (searchWord.length() + 1) * sizeof(UniChar);
    
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
	
    memcpy(p, &count, sizeof(uint32_t));
    p += sizeof(count);  
	
    memcpy(p, &nOrderType, sizeof(nOrderType));
    p += sizeof(nOrderType);
    
    //时间使用默认,用两个空字符串
    p += sizeof(uint32_t) * 2;
    
    memcpy(p, searchWord.c_str(), (searchWord.length() + 1) * sizeof(UniChar));
    p += (searchWord.length() + 1) * sizeof(UniChar);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_SEARCH_NOTE_EX_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
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
//	CMBSearchNoteExAck ack;
//	
//	unsigned int unLen=[myData length];
//	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) 
//    + sizeof(ack.m_nRetCode) + sizeof(ack.m_szReserve);
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
//    ack.m_unTotalCnt = *((uint32_t*)p);
//    p += sizeof(uint32_t);
//    unOffSet += sizeof(uint32_t);
//    
//    memcpy(ack.m_szReserve, p, sizeof(ack.m_szReserve));
//    p += sizeof(ack.m_szReserve);
//    unOffSet += sizeof(ack.m_szReserve);
//	
//    unsigned int unCnt =  *((unsigned int *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
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
//
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
//
//        pMBNoteInfo.strAddr = (unichar*)p;
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
//        pMBNoteInfo.strSrc = (unichar*)p;
//		
//        p += unStrLen;
//        ack.m_lstPMBNoteInfoEx.push_back(pMBNoteInfo);
//    }
//	
//	if(ack.m_nRetCode==0)
//    {
//		if(delegate!=nil&&[delegate respondsToSelector:@selector(getSearchNoteDidSuccessWithData:)])
//        {
//			[delegate getSearchNoteDidSuccessWithData:&ack];
//		} 
//	}
//    else
//    {
//		MLOG([NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]);
//		[self throwErrorWithStr:[NSString stringWithFormat:NO_LIST]];
//		
//	}	
	// 因为很多delegate 而且list 中的class 没有拷贝构造函数，所以选择动态分配内存
}

-(void)handleZipFileFromSrv:(NSData *)myData
{
    if(myData==nil){
		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
		return;
	}
	
	CMBSearchNoteExAck ack;
	
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
    
    ack.m_unTotalCnt = *((uint32_t*)p);
    p += sizeof(uint32_t);
    unOffSet += sizeof(uint32_t);
    
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
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getSearchNoteDidSuccessWithData:)])
        {
			[delegate getSearchNoteDidSuccessWithData:&ack];
		} 
	}
    else
    {
		MLOG([NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]);
		[self throwErrorWithStr:[NSString stringWithFormat:NO_LIST]];
	}	
}

-(void)dealloc
{
    [s_PSocket release];
	[super dealloc];
}

@end
