//
//  MBGetDefCataListMsg.m
//  pass91
//
//  Created by Zhaolin He on 09-8-31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MBGetDefCataListMsg.h"
#import "MBBaseStruct.h"
#import "P91PassDelegate.h"

static PSocket* s_PSocket = nil;
@implementation MBGetDefCataListMsg

+ (PSocket*)shareMsg
{
    if(s_PSocket == nil)
    {
        s_PSocket = [[MBGetDefCataListMsg alloc] init];
    }
    return s_PSocket;
}

-(void)sendPacketWithData:(NSData *)data
{
	CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	int unLen=sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID);
	
	char *pSend = new(std::nothrow) char[unLen];
    if (NULL == pSend)
    {
        [self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
    }
	
	char *p = pSend;
    memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
	
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);
	
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);
	
	AS_APP_PACK_WITH_TYPE my_app_type;
	memcpy(my_app_type.App.Buf, pSend, unLen);
	my_app_type.dwDataSize=unLen;
	my_app_type.wOpCode=OPN_MB_GET_DEFAULT_CATA_LIST_REQ;
	self.logic_data=[NSData dataWithBytes:&my_app_type length:unLen+sizeof(my_app_type.dwDataSize)+sizeof(my_app_type.wOpCode)];
	delete[] pSend;
	pSend=NULL;
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:TIME_OUT_SECOND target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPacket];
}

-(void)throwErrorWithStr:(NSString *)str{
	[super throwErrorWithStr:str];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(getDefDirDidFailedWithError:)]){
		[delegate getDefDirDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}

-(void)handleSrvMessageWithData:(NSMutableData *)data{
	CMBGetDefCataListAck ack;
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
	
    ack.m_nRetCode = *((int *)p);
    p += sizeof(ack.m_nRetCode);
    unOffSet += sizeof(ack.m_nRetCode);
	
    unsigned int unCnt =  *((unsigned int *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
	
    ack.ReleaseBuf();
    for (unsigned int i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(CMBCateInfo, strName);
        if (unOffSet > unLen)
        {
			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
            return;
        }
		
		CMBCateInfo objCate;
        memcpy(&objCate, p, offsetof(CMBCateInfo, strName));
        p += offsetof(CMBCateInfo, strName);
		
        unsigned int unStrLen = (wcslen_m((char*)p) + 1) * 2;
        unOffSet += unStrLen;
		
        if (unOffSet > unLen)
        {
			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
            return;
        }
		
//        pMBCateInfo->pwszName = new unichar[unStrLen / 2];
//        memcpy(pMBCateInfo->pwszName, p, unStrLen);//已经把"\0"算进去了
        objCate.strName = (unichar*)p;
		
		//MLOG(@"DIR:%S",pMBCateInfo->pwszName) ;
		
        p += unStrLen;
        
        //根据guidPath设置guidBelongTo
        if (memcmp(&objCate.guidPath[0], &GUID_NULL, sizeof(GUID)) == 0)
        {
            objCate.guidBelongTo = GUID_NULL;            
        }
        else
        {
            int i = 1;
            for(; i < MAX_PATH_DEPTH; i++)
            {
                if (memcmp(&objCate.guidPath[i], &GUID_NULL, sizeof(GUID)) == 0)
                {
                    objCate.guidBelongTo = objCate.guidPath[i-1];         
                    break;
                }
            }
            if (i == MAX_PATH_DEPTH - 1)
                objCate.guidBelongTo = objCate.guidPath[MAX_PATH_DEPTH - 1];
        }
		
        objCate.tHead.nEditState = 0;
        objCate.tHead.nNeedUpload = 0;
        objCate.tHead.nSyncState = 0;
		ack.m_lstPMBCateInfo.push_back(objCate);
    }
	
	if(ack.m_nRetCode==0)
    {
		[self stopTimer];
		if(delegate!=nil&&[delegate respondsToSelector:@selector(getDefDirDidSuccessWithData:)]){
			[delegate getDefDirDidSuccessWithData:&ack];
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
