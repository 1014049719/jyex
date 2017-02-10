//
//  MBItemInfoMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "MBDataStruct.h"
#import "MBItemInfoMsg.h"
#import "P91PassDelegate.h"
#import "Common.h"

static PSocket* s_PSocket = nil;

@implementation MBItemInfoMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBItemInfoMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getItemInfoDidFailedWithError:)])
    {
        [str retain];
		[delegate getItemInfoDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)sendPacketWithData:(NSData *)data ItemID:(GUID)guidItem version:(unsigned int)dwCurVer a2binfo:(A2BInfo &)info
{
//	MLOG(@"sendPacketWithData item id = %@",GUID2NSString(&guidItem)) ;
	//dwCurVer = 1;
	NSLog(@"item: %@", [CommonFunc guidToNSString:guidItem]);
	
	CMBItemNewReq req;
	memcpy(&req, [data bytes], [data length]);
	
	int unLen=sizeof(req.m_dwConnectionID) + sizeof(req.m_dwDbID) + sizeof(req.m_dwAppUserID)+sizeof(guidItem)
                + sizeof(dwCurVer) + sizeof(int) + sizeof(int) + sizeof(req.m_szReserve);
	
	char* pSend = new(std::nothrow) char[unLen];
	if (NULL == pSend){
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}
	memset(pSend, 0, unLen);
	
	char *p=pSend;
	
    memcpy(p, &req.m_dwConnectionID, sizeof(req.m_dwConnectionID));
    p += sizeof(req.m_dwConnectionID);
	
	// 补充的修改
	if (info.dwRightUserID != 0) {
		req.m_dwDbID = info.dwRightUserID;
	}
	// end 补充的修改
    memcpy(p, &req.m_dwDbID, sizeof(req.m_dwDbID));
    p += sizeof(req.m_dwDbID);
	
    memcpy(p, &req.m_dwAppUserID, sizeof(req.m_dwAppUserID));
    p += sizeof(req.m_dwAppUserID);
	
    memcpy(p, &guidItem, sizeof(guidItem));
    p += sizeof(guidItem);   
	
    memcpy(p, &dwCurVer, sizeof(dwCurVer));
    p += sizeof(dwCurVer);
    
    *p = 0;                 // xScreen
    
    p += sizeof(int);
    
    *p = 0;                 // yScreen
    
    p += sizeof(int);
    
    memcpy(p, req.m_szReserve, sizeof(req.m_szReserve));
    p += sizeof(req.m_szReserve);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_GET_ITEM_NEW_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
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
//	CMBItemNewAck ack;
//	
//	unsigned int unLen=[myData length];
//	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode)+sizeof(ack.m_guidItem) 
//                            + sizeof(ack.m_nIsNeedDownLoad) + sizeof(ack.m_szReserve);
//	
//    if (unLen < unMinLen)
//    {
//        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//    }
//	
//    char *p=(char *)[myData bytes];
//	
//	unsigned int unOffSet = 0;
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
//    ack.m_guidItem = *((GUID *)p);
//    p += sizeof(ack.m_guidItem);
//    unOffSet += sizeof(ack.m_guidItem);
//	
//    ack.m_nIsNeedDownLoad = *((int *)p);
//    p += sizeof(ack.m_nIsNeedDownLoad);
//    unOffSet += sizeof(ack.m_nIsNeedDownLoad);
//    
//    memcpy(ack.m_szReserve, p, sizeof(ack.m_szReserve));
//    p += sizeof(ack.m_szReserve);
//    unOffSet += sizeof(ack.m_szReserve);
//	
//    unsigned int unCnt = *((unsigned int *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//	
//    if ((unOffSet + offsetof(CMBItemNew, m_pData)) > unLen)
//    {
//        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//    }
//	
//    if (0 != unCnt)
//    {
////        ack.m_pItemNew = new CMBItemNew();
//        memcpy(&ack.m_pItemNew, p, offsetof(CMBItemNew, m_pData));
//        p += offsetof(CMBItemNew, m_pData);
//		
//        if ((unOffSet + ack.m_pItemNew.m_unDataLen) > unLen)
//        {
//            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//			return;
//        }
//		
//        if (0 != ack.m_pItemNew.m_unDataLen)
//        {
//            ack.m_pItemNew.m_pData = new(std::nothrow) unsigned char[ack.m_pItemNew.m_unDataLen];
//            if (NULL == ack.m_pItemNew.m_pData)
//            {
//                [self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
//				return;
//            }            
//            memcpy(ack.m_pItemNew.m_pData, p, ack.m_pItemNew.m_unDataLen);
//			
//            p += ack.m_pItemNew.m_unDataLen;
//        }        
//    }
//	
//	if(ack.m_nRetCode==0){
//		[self stopTimer];
//		if(delegate!=nil&&[delegate respondsToSelector:@selector(getItemInfoDidSuccessWithData:)]){
//			[delegate getItemInfoDidSuccessWithData:&ack];
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
	
	CMBItemNewAck ack;
	
	unsigned int unLen=[myData length];
	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode)+sizeof(ack.m_guidItem) 
    + sizeof(ack.m_nIsNeedDownLoad) + sizeof(ack.m_szReserve);
	
    if (unLen < unMinLen)
    {
        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
    }
	
    unsigned char *p=(unsigned char *)[myData bytes];
	
	unsigned int unOffSet = 0;
	
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
	
    ack.m_guidItem = *((GUID *)p);
    p += sizeof(ack.m_guidItem);
    unOffSet += sizeof(ack.m_guidItem);
	
    ack.m_nIsNeedDownLoad = *((int *)p);
    p += sizeof(ack.m_nIsNeedDownLoad);
    unOffSet += sizeof(ack.m_nIsNeedDownLoad);
    
    memcpy(ack.m_szReserve, p, sizeof(ack.m_szReserve));
    p += sizeof(ack.m_szReserve);
    unOffSet += sizeof(ack.m_szReserve);
	
    unsigned int unCnt = *((unsigned int *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
	
    /*if ((unOffSet + offsetof(CMBItemNew, m_pData)) > unLen)
    {
        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
    }*/
	
    if (0 != unCnt)
    {
        //ack.m_pItemNew = new CMBItemNew();
        memcpy(&ack.m_pItemNew, p, offsetof(CMBItemNew, wszTitle));
        p += offsetof(CMBItemNew, wszTitle);
        
        unsigned int titlelen = getUnicodeLength((unsigned char *)p);
        p += (titlelen + 2);      
        unsigned int *datalen = (unsigned int *)p;
        ack.m_pItemNew.m_unDataLen = *datalen;
        p += sizeof(unsigned int);
        
        if ((unOffSet + ack.m_pItemNew.m_unDataLen) > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }
        ack.m_pItemNew.tHead.nEditState = 0;
        ack.m_pItemNew.tHead.nNeedUpload = 0;
        ack.m_pItemNew.tHead.nSyncState = 0;
		
        if (0 != ack.m_pItemNew.m_unDataLen)
        {
            ack.m_pItemNew.m_pData = new(std::nothrow) unsigned char[ack.m_pItemNew.m_unDataLen];
            if (NULL == ack.m_pItemNew.m_pData)
            {
                [self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
				return;
            }
            memcpy(ack.m_pItemNew.m_pData, p, ack.m_pItemNew.m_unDataLen);
			
            p += ack.m_pItemNew.m_unDataLen;
        }        
    }
	
	if(ack.m_nRetCode==0)
    {
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getItemInfoDidSuccessWithData:)])
        {
			[delegate getItemInfoDidSuccessWithData:&ack];
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
