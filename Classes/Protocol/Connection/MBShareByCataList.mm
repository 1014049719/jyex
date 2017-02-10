//
//  MBShareByCataList.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBShareByCataList.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;

@implementation MBShareByCataList

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBShareByCataList alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getShareInfoDidFailedWithError:)]){
		[delegate getShareInfoDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)sendPacketWithData:(NSData *)data version:(unsigned int)dwVerFrom
{
	CMBUserLoginExAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	int unLen=sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID)+sizeof(dwVerFrom);
	
	char* pSend = new(std::nothrow) char[unLen];
	if (NULL == pSend){
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}
	memset(pSend, 0, unLen);
	
	char *p = pSend;
	
    memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
	
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);
	
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);
	
    memcpy(p, &dwVerFrom, sizeof(dwVerFrom));
    p += sizeof(dwVerFrom);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_GET_SHARE_TO_CATA_LIST_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data{
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
//	CMBShareByCataListAck ack;
//	unsigned int unOffSet=0;
//	unsigned int unLen=[myData length];
//	
//	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode);
//	unMinLen+=sizeof(unsigned int);
//	
//	if(unMinLen>unLen){
//		[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//	}
//	
//	char *p=(char *)[myData bytes];
//	
//    ack.m_dwConnectionID = *((unsigned int*)p);
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
//	
//    for (unsigned int i = 0; i < unCnt; i++)
//    {
//        unOffSet += sizeof(CMBShareInfo);        
//        if (unOffSet > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
//		
//        CMBShareInfo pMBShareInfo;
//        memcpy(&pMBShareInfo, p, sizeof(CMBShareInfo));
//        p += sizeof(CMBShareInfo);
//		
//        ack.m_lstPMBShareInfo.push_back(pMBShareInfo);
//    }
//	
//	if(ack.m_nRetCode==0){
//		[self stopTimer];
//		if(delegate!=nil&&[delegate respondsToSelector:@selector(getShareInfoDidSuccessWithData:)]){
//			[delegate getShareInfoDidSuccessWithData:&ack];
//		} 
//	}else{
//		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
//	}
}

-(void)handleZipFileFromSrv:(NSData *)myData
{
    if(myData==nil){
		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
		return;
	}
	
	CMBShareByCataListAck ack;
	unsigned int unOffSet=0;
	unsigned int unLen=[myData length];
	
	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode);
	unMinLen+=sizeof(unsigned int);
	
	if(unMinLen>unLen){
		[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
	}
	
	char *p=(char *)[myData bytes];
	
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
        unOffSet += sizeof(CMBShareInfo);        
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }
		
        CMBShareInfo pMBShareInfo;
        memcpy(&pMBShareInfo, p, sizeof(CMBShareInfo));
        p += sizeof(CMBShareInfo);
		
        ack.m_lstPMBShareInfo.push_back(pMBShareInfo);
    }
	
	if(ack.m_nRetCode==0){
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getShareInfoDidSuccessWithData:)]){
			[delegate getShareInfoDidSuccessWithData:&ack];
		} 
	}else{
		[self stopTimer];
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
	}
}

-(void)dealloc{
    [s_PSocket release];
	[super dealloc];
}
@end
