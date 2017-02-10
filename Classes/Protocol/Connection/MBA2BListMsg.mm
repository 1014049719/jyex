//
//  MBA2BListMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBA2BListMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;
@implementation MBA2BListMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBA2BListMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getA2BListDidFailedWithError:)])
    {
		[delegate getA2BListDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)sendPacketWithData:(NSData *)data NoteID:(GUID)guidA version:(unsigned int)dwVerFrom{
	CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	int unLen=sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID)+sizeof(guidA)+sizeof(dwVerFrom);
	
	char* pSend = new(std::nothrow) char[unLen];
	if (NULL == pSend){
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}
	memset(pSend, 0, unLen);
	
	//拼装数据
    char *p = pSend;
	memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
	
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);
	
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);
	
    memcpy(p, &guidA, sizeof(guidA));
    p += sizeof(guidA);  
	
    memcpy(p, &dwVerFrom, sizeof(dwVerFrom));
    p += sizeof(dwVerFrom);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_GET_ITEM_LIST_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;//没有操作码
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
	CMBRspURL MBRspURL;
	int code=MBRspURL.Decode((char *)[data bytes], [data length]);
	if(RET_SUCCESS!=code)
	{
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",code]];
		return;
	}
	if(MBRspURL.m_nRetCode!=0)
	{
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",MBRspURL.m_nRetCode]];
		return;
	}
    
    [self downloadAndUnzipDataAnsyc:&MBRspURL];
    
//	NSData *myData=[self downloadAndUnzipData:&MBRspURL];
//	
//	if(myData==nil){
//		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
//		return;
//	}
//	
//	CMBA2BListAck ack;
//	
//	unsigned int unLen=[myData length];
//	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode);
//	unMinLen+=sizeof(unsigned int);
//	
//    if (unLen < unMinLen)
//    {
//        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//    }
//	
//    char *p=(char *)[myData bytes];
//	unsigned int unOffSet = 0;//这个在没有指针的类中其实没有用
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
//    unsigned int unCnt =  *((unsigned int *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//	
//    ack.ReleaseBuf();
//	for (unsigned int i = 0; i < unCnt; i++)
//    {
//        unOffSet += sizeof(CMBA2BInfo);
//        if (unOffSet > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
//		
//        CMBA2BInfo pMBA2BInfo;
//        memcpy(&pMBA2BInfo, p, sizeof(CMBA2BInfo));
//        p += sizeof(CMBA2BInfo);      
//		
//        ack.m_lstPA2BInfo.push_back(pMBA2BInfo);
//    }
//	
//	if(ack.m_nRetCode==0)
//    {
//		[self stopTimer];
//		if(delegate!=nil&&[delegate respondsToSelector:@selector(getA2BListDidSuccessWithData:)])
//        {
//			[delegate getA2BListDidSuccessWithData:&ack];
//		} 
//	}
//    else
//    {
//		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
//	}
}

-(void)handleZipFileFromSrv:(NSData *)myData
{
    if(myData==nil)
    {
		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
		return;
	}
	
	CMBA2BListAck ack;
	
	unsigned int unLen=[myData length];
	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode);
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
	
    unsigned int unCnt =  *((unsigned int *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
	
    ack.ReleaseBuf();
	for (unsigned int i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CMBA2BInfo);
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }
		
        CMBA2BInfo pMBA2BInfo;
        memcpy(&pMBA2BInfo, p, sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);      
		
        pMBA2BInfo.tHead.nEditState = 0;
        pMBA2BInfo.tHead.nNeedUpload = 0;
        pMBA2BInfo.tHead.nSyncState = 0;
        ack.m_lstPA2BInfo.push_back(pMBA2BInfo);
    }
	
	if(ack.m_nRetCode==0)
    {
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getA2BListDidSuccessWithData:)])
        {
			[delegate getA2BListDidSuccessWithData:&ack];
		} 
	}
    else
    {
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
	}
    
}

-(void)dealloc{
    [s_PSocket release];
	[super dealloc];
}
@end
