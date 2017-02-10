//
//  MBUpLoadNoteMsg.mm
//  pass91
//
//  Created by Zhaolin He on 09-9-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBUpLoadNoteMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;

@implementation MBUpLoadNoteMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBUpLoadNoteMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
//	[Global InitConnectState:NO];
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadNoteDidFailedWithError:)])
	{
		MLOG(@"isDelegate here");
		[delegate upLoadNoteDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(@"throwEroor[%@]",str);
}

-(void)uploadWithUserInfo:(NSData *)data Body:(std::list<NoteInfo>*)pNoteList
{
	int iRet = RET_SUCCESS;
	
	CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
    
    CMBUpLoadNoteExReq uploadNoteReq;
	unsigned int unLen=sizeof(uploadNoteReq.m_dwConnectionID) + sizeof(uploadNoteReq.m_dwDbID) + sizeof(uploadNoteReq.m_dwAppUserID) + sizeof(uploadNoteReq.m_szReserve);
	unLen += sizeof(unsigned int);
	
    unsigned int unAtomLen = 0;
	std::list<NoteInfo>::iterator it = pNoteList->begin();
    while (pNoteList->end() != it)
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
    char* pSend = new(std::nothrow) char[unLen];
    if (NULL == pSend)
    {
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
        return;
    }
	
    //拼装数据
    char *p = pSend;
    
    memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
    
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);    
    
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);
    
    //char m_szReserve[8];
    p += 8;
    
    uint32_t unCnt = (uint32_t)pNoteList->size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = pNoteList->begin();
    while (pNoteList->end() != it)
    {
        memcpy(p, &(*it), offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        wcscpy_m(p, (char*)(*it).strTitle.c_str());
        p += ((*it).strTitle.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strAddr.c_str());
        p += ((*it).strAddr.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strSrc.c_str());
        p += ((*it).strSrc.length() + 1) * 2;
        ++it;
    }
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	if (0 == [self sendPackWithCodeAnsyc:OPN_MB_UPLOAD_NOTE_EX_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen])
	{
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
        return;
	}
	
    SAFE_DELETE_ARRAY(pSend);
}

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
	CMBUpLoadNoteExAck ack;
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
	
	if(ack.m_nRetCode==0){
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(upLoadNoteDidSuccessWithData:)]){
			[delegate upLoadNoteDidSuccessWithData:&ack];
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
