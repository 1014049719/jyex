//
//  MBNoteThumbMsg.mm
//  NoteBook
//
//  Created by wangsc on 10-10-25.
//  Copyright 2010 ND. All rights reserved.
//

#import "MBNoteThumbMsg.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;
@implementation MBNoteThumbMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBNoteThumbMsg alloc] init];
    }
    return s_PSocket;
}

-(void)throwErrorWithStr:(NSString *)str
{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getNoteThumbDidFailedWithError:)])
    {
        [str retain];
		[delegate getNoteThumbDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)sendPacketWithData:(NSData *)data noteID:(GUID)guidNote version:(uint32_t)version imgWidth:(uint32_t)nWidth imgHeight:(uint32_t)nHeight;
{
	
	CMBNoteThumbReq req;
	memcpy(&req, [data bytes], [data length]);
	
	int unLen=sizeof(req.m_dwConnectionID) + sizeof(req.m_dwDbID) + sizeof(req.m_dwAppUserID) + sizeof(req.m_guidNote)
    + sizeof(req.m_dwCurVer) + sizeof(req.m_unWidth) + sizeof(req.m_unHeight);
	
	char* pSend = new(std::nothrow) char[unLen];
	if (NULL == pSend)
    {
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}
    
	memset(pSend, 0, unLen);
	
	char *p=pSend;
	
    memcpy(p, &req.m_dwConnectionID, sizeof(req.m_dwConnectionID));
    p += sizeof(req.m_dwConnectionID);
	
    memcpy(p, &req.m_dwDbID, sizeof(req.m_dwDbID));
    p += sizeof(req.m_dwDbID);
	
    memcpy(p, &req.m_dwAppUserID, sizeof(req.m_dwAppUserID));
    p += sizeof(req.m_dwAppUserID);
	
    memcpy(p, &guidNote, sizeof(guidNote));
    p += sizeof(guidNote);   
	
    memcpy(p, &version, sizeof(version));
    p += sizeof(req.m_dwCurVer);
    
    memcpy(p, &nWidth, sizeof(nWidth));
    p += sizeof(nWidth);
    
    memcpy(p, &nHeight, sizeof(nHeight));
    p += sizeof(nHeight);
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPackWithCodeAnsyc:OPN_MB_GET_NOTE_THUMB_REQ Content:[NSData dataWithBytes:pSend length:unLen] contentLen:unLen];
	delete[] pSend;
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
//    char *p=(char *)[myData bytes];
//    
//	CMBNoteThumbAck ack;
//	if (ack.Decode(p, [myData length]) != RET_SUCCESS)
//    {
//        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
//		return;
//    }
//	
//	if(ack.m_nRetCode==0)
//    {
//		[self stopTimer];
//		if(delegate != nil && [delegate respondsToSelector:@selector(getNoteThumbDidSuccessWithData:)])
//        {
//			[delegate getNoteThumbDidSuccessWithData:&ack];
//		} 
//	}
//    else
//    {
//		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
//	}	
}

-(void)handleZipFileFromSrv:(NSData *)myData
{
	if(myData==nil){
		[self throwErrorWithStr:NSLocalizedString(@"sock_getUrl_error",nil)];
		return;
	}
	
    char *p=(char *)[myData bytes];
    
	CMBNoteThumbAck ack;
	if (ack.Decode(p, [myData length]) != RET_SUCCESS)
    {
        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
		return;
    }
	
	if(ack.m_nRetCode==0)
    {
		[self stopTimer];
		if(delegate != nil && [delegate respondsToSelector:@selector(getNoteThumbDidSuccessWithData:)])
        {
			[delegate getNoteThumbDidSuccessWithData:&ack];
		} 
	}
    else
    {
		[self throwErrorWithStr:[NSString stringWithFormat:@"error code:%d",ack.m_nRetCode]];
	}	
}

-(void)dealloc
{
    [s_PSocket release];
	[super dealloc];
}

@end
