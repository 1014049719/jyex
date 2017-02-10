//
//  MBUpLoadA2BInfoMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBUpLoadA2BInfoMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;

@implementation MBUpLoadA2BInfoMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBUpLoadA2BInfoMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadA2BInfoDidFailedWithError:)]){
		[delegate upLoadA2BInfoDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)uploadWithUserInfo:(NSData *)data Body:(std::list<CMBA2BInfo>*)pA2BList
{
	int iRet = RET_SUCCESS;
	
	CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	unsigned int unLen=sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID);
	unLen+=sizeof(unsigned int);
	
    unsigned int unAtomLen = 0;
	std::list<CMBA2BInfo>::iterator it = pA2BList->begin();
    while (pA2BList->end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            [self throwErrorWithStr:[NSString stringWithFormat:@"Error Code:%d",iRet]];
            return;
        }
		
        unLen += unAtomLen;
        ++it;
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
	
    unsigned int unCnt = pA2BList->size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
	
	it = pA2BList->begin();
    while (pA2BList->end() != it)
    {
		(*it).dwRightUserID = [[Global GetUsrID] intValue];
        memcpy(p, &(*it), sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);
		
        ++it;
    }
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_UPLOAD_NOTEXITEM_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
	pSend=NULL;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
	CMBUpLoadA2BInfoAck ack;
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
		
        CDblKeyUpLoadRslt pSglKeyUpLoadRslt;
        memcpy(&pSglKeyUpLoadRslt, p, sizeof(CDblKeyUpLoadRslt));
        p += sizeof(CDblKeyUpLoadRslt);
		
        ack.m_lstPUpLoadRslt.push_back(pSglKeyUpLoadRslt);
    }
	
	if(ack.m_nRetCode==0){
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadA2BInfoDidSuccessWithData:)]){
			[delegate upLoadA2BInfoDidSuccessWithData:&ack];
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
