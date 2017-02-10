//
//  MBUpLoadItemMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBUpLoadItemMsg.h"
#import "P91PassDelegate.h"
#import "Common.h"

static PSocket* s_PSocket = nil;

@implementation MBUpLoadItemMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBUpLoadItemMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
	[Global InitConnectState:NO];
	MLOG(@"########################## - connect failed - ########################");
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadItemDidFailedWithError:)])
	{
		[delegate upLoadItemDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)uploadWithUserInfo:(NSData *)data content:(CMBItemNew *)item
{
	int iRet = RET_SUCCESS;	
    CMBUpLoadItemNewReq req;
    CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	unsigned int unLen=sizeof(req.m_dwConnectionID) + sizeof(req.m_dwDbID) + sizeof(req.m_dwAppUserID) + sizeof(req.m_szReserve);
	unLen+=sizeof(unsigned int);
	
    unsigned int unContentSize = 0;
    unsigned int unCnt         = 0;
	
    if (NULL != item)
    {       
        if (RET_SUCCESS != (iRet = item->GetObjSize(unContentSize)))
        {
			[self throwErrorWithStr:[NSString stringWithFormat:@"Error Code:%d",iRet]];
            return;
        }
		
        unLen += unContentSize;
        unCnt = 1;
    }
	
    // 申请内存块用于发送数据    
    char *pSend = new(std::nothrow) char[unLen];
    if (NULL == pSend)
    {
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
        return;
    }
	
    memset(pSend, 0x0, unLen);
	
    //拼装数据
    char *p = pSend;
	
    memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
	
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);    
	
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);    
    
    //memcpy(p, m_szReserve, sizeof(m_szReserve));
    //p += sizeof(m_szReserve);
    p += sizeof(req.m_szReserve);
    
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);
	
    if (NULL != item)
    {
        //memcpy(p, item, offsetof(CMBItemNew, m_pData));
        //p += offsetof(CMBItemNew, m_pData);
        memcpy(p, item, offsetof(CMBItemNew, wszTitle));
        p += offsetof(CMBItemNew, wszTitle);
        if (item->wszTitle != NULL) {
            unsigned int titlelen = getUnicodeLength((unsigned char *)p);
            memcpy(p, item->wszTitle, titlelen);
            p += titlelen; 
            memset(p, 0, 2);
            p += 2;
        }
        else {
            memset(p, 0, 2);
            p += 2;
        }
        *(unsigned int*)p = item->m_unDataLen;
        p += sizeof(unsigned int);
		
        memcpy(p, item->m_pData, item->m_unDataLen);
        p += item->m_unDataLen;
    }
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_UPLOAD_ITEM_NEW_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data{
	CMBUpLoadItemNewAck ack;
	unsigned int unOffSet=0;
	unsigned int unLen=[data length]-sizeof(AS_PACKINFO_HEADER);
	
	unsigned int unMinLen = sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID) + sizeof(ack.m_nRetCode);
	unMinLen+=sizeof(unsigned int);
	
	if(unMinLen>unLen){
		[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
	}
	
    char *p=(char *)[data bytes];
	p+=sizeof(AS_PACKINFO_HEADER);
	
	ack.m_dwConnectionID = *((unsigned int*)p);
    p += sizeof(ack.m_dwConnectionID);
    unOffSet += sizeof(ack.m_dwConnectionID);
	
    ack.m_dwDbID = *((unsigned int*)p);
    p += sizeof(ack.m_dwDbID);
    unOffSet += sizeof(ack.m_dwDbID);
	
    ack.m_dwAppUserID = *((unsigned int*)p);
    p += sizeof(ack.m_dwAppUserID);
    unOffSet += sizeof(ack.m_dwAppUserID);  
	
    ack.m_nRetCode = *((int*)p);
    p += sizeof(ack.m_nRetCode);
    unOffSet += sizeof(ack.m_nRetCode); 
	
    unsigned int unCnt =  *((unsigned int *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
	
	ack.ReleaseBuf();
    for (unsigned int i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CSglKeyUpLoadRslt);
        if (unOffSet > unLen)
        {
            [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
        }
		
        CSglKeyUpLoadRslt pSglKeyUpLoadRslt;
        memcpy(&pSglKeyUpLoadRslt, p, sizeof(CSglKeyUpLoadRslt));
        p += sizeof(CSglKeyUpLoadRslt);
		
        ack.m_lstPUpLoadRslt.push_back(pSglKeyUpLoadRslt);
		
    }	
	
	if(ack.m_nRetCode==0)
	{
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadItemDidSuccessWithData:)])
		{
			[delegate upLoadItemDidSuccessWithData:&ack];
		} 
	}
	else
	{
		[self stopTimer];
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
	}
}

-(void)dealloc{
    [s_PSocket release];
	[super dealloc];
}
@end
