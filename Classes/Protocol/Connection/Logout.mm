//
//  Logout.m
//  pass91
//
//  Created by Zhaolin He on 09-8-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Plist.h"
#import "Logout.h"
#import "91NoteAppStruct.h"
#import "MBBaseStruct.h"
#import "P91PassDelegate.h"
#import "Global.h"

@interface Logout()
-(void)stopTimer;
-(void)sendPacket;
-(void)close_Socket;
-(void)throwErrorWithStr:(NSString *)str;
@property(nonatomic,retain)NSInputStream *input;
@property(nonatomic,retain)NSOutputStream *output;
@property(nonatomic,retain)NSMutableData *temp_data;
@property(nonatomic,retain)NSTimer *timer;
@end

static BOOL isWaitBody=FALSE;

@implementation Logout
@synthesize input,output,delegate,timer,temp_data;
//全局变量
AS_APP_PACK_WITH_TYPE appType;

-(id)initWithInput:(NSInputStream *)inputs Output:(NSOutputStream *)outputs target:(id)obj{
	if(self=[super init]){
		self.input=inputs;
		[self.input setDelegate:self];
		self.output=outputs;
		[self.output setDelegate:self];
		self.delegate=obj;
		
		isWaitBody=FALSE;
	}
	return self;
}

-(void)timeOut{
	MLOG(NSLocalizedString(@"sock_timeout",nil));
	[self throwErrorWithStr:NSLocalizedString(@"sock_timeout",nil)];
	if([delegate respondsToSelector:@selector(timeOut)])
		[delegate timeOut];
}

-(void)stopTimer{
	if(self.timer!=nil){
		[self.timer invalidate];
		self.timer=nil;
	}
}

-(void)throwErrorWithStr:(NSString *)str{
	[self stopTimer];
	//[self close_Socket];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(logoutDidFailedWithError:)]){
		[delegate logoutDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}   
	MLOG(str);
}
-(void)throwLoseConnectionError:(NSString *)str{
	[Global InitConnectState:NO];
	MLOG(@"################################ - connect failed - ###################");
	[self stopTimer];
	[self close_Socket];
	if(delegate!=nil&&[delegate respondsToSelector:@selector(requiredReLogin)]){
		//[delegate requiredReLogin];
	} 
	MLOG(str);
}

-(void)logoutWithData:(NSData *)data
{
	CMBUserLoginAck ack;
	memcpy(&ack, [data bytes], [data length]);
	
	unsigned int unLen= sizeof(ack.m_dwConnectionID) + sizeof(ack.m_dwDbID) + sizeof(ack.m_dwAppUserID);
	
	unsigned char szLoginInfo[1024]={0};
	unsigned char *p=szLoginInfo;
	
	memcpy(p, &ack.m_dwConnectionID, sizeof(ack.m_dwConnectionID));
    p += sizeof(ack.m_dwConnectionID);
	
    memcpy(p, &ack.m_dwDbID, sizeof(ack.m_dwDbID));
    p += sizeof(ack.m_dwDbID);
	
    memcpy(p, &ack.m_dwAppUserID, sizeof(ack.m_dwAppUserID));
    p += sizeof(ack.m_dwAppUserID);
	
	memset(&appType, 0, sizeof(appType));
	memcpy(appType.App.Buf, szLoginInfo, unLen);
	appType.dwDataSize=unLen;
	appType.wOpCode=OPN_MB_USER_LOGOUT_REQ;
	
	[self stopTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPacket];
}

#pragma mark <send Packet>
-(void)sendPacket{
	if(self.output==nil)return;
	self.temp_data=[NSMutableData data];//清空缓存数据
	isWaitBody=FALSE;
	
	//send data to socket
	unsigned int wOpCode=appType.wOpCode;
	unsigned int dwLen=appType.dwDataSize;	
	char *pBuf=(char*)appType.App.Buf;
	//构造数据包
	AS_PACKINFO AsPack;
	memset(&AsPack, 0, sizeof(AsPack));
	//添加起始标志
	AsPack.MsgHdr.wAsynFlag=0x5d5d;
	//操作码
	AsPack.MsgHdr.wOpCode = wOpCode;//6666;//
	//控制信息,包括客户端版本号,数据包是否压缩等
	AsPack.MsgHdr.wVersion=0x00;
	//无业务分包
	AsPack.MsgHdr.btOpSplitType = 0; 
	//有无分包标志
	AsPack.MsgHdr.wDivFlag = (unsigned short)((dwLen+(AS_APP_BUF_SIZE-1))/AS_APP_BUF_SIZE);
	//压缩数据包原始大小,包括每一次发送的消息头
	AsPack.MsgHdr.dwDataSize=0;//dwLen + (sizeof(AsPack.MsgHdr) * AsPack.MsgHdr.wDivFlag);
    
	//用于计算发送进度
	unsigned int dwIndex=0;
	unsigned int dwDivPackSize=0;//单个分包大小
	int totalByteSend = 0;
    
	do 
	{
		dwIndex += dwDivPackSize;
		dwDivPackSize = (dwLen - dwIndex);
		if(dwDivPackSize > AS_APP_BUF_SIZE)
		{
			dwDivPackSize = AS_APP_BUF_SIZE;
			//AsPack.MsgHdr.btOpSplitType = 1; //分包还未结束
		}
		else
		{
			//目前业务层分包暂不实现
			// 			if(AsPack.MsgHdr.btOpSplitType == 1)
			// 			{
			// 				AsPack.MsgHdr.btOpSplitType = 2;//业务分包结束
			// 			}
		}
		memset(AsPack.App.Buf, 0, AS_APP_BUF_SIZE);
		//此次数据包大小
		AsPack.MsgHdr.wMsgSize = dwDivPackSize + sizeof(AsPack.MsgHdr);
		//拷贝业务层数据
		memcpy(&AsPack.App.Buf, pBuf+dwIndex,dwDivPackSize);
		//发送数据
		[self.output write:(const uint8_t *)&AsPack maxLength:AsPack.MsgHdr.wMsgSize];
		MLOG(@"%d bytes sended!",AsPack.MsgHdr.wMsgSize);
		totalByteSend += AsPack.MsgHdr.wMsgSize;
		
		//分包标志,每一次都减一
		AsPack.MsgHdr.wDivFlag--;
		
	} while((AsPack.MsgHdr.wDivFlag > 0));
	
	[Global flowCount:totalByteSend];
}

-(void)handleSrvMessageWithData:(NSMutableData *)data{
    CMBUserLogoutAck obj;
    unsigned int unOffSet=0;
    
    char *p=(char *)[data bytes];
    p+=sizeof(AS_PACKINFO_HEADER);
    unsigned int unMinLen = sizeof(obj.m_dwConnectionID) + sizeof(obj.m_dwDbID) + sizeof(obj.m_dwAppUserID) + sizeof(obj.m_nRetCode);
    if(unMinLen>[data length]-sizeof(AS_PACKINFO_HEADER)){
        [self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
        return;
    }
    
    //解码
    obj.m_dwConnectionID = *((unsigned int*)p);
    p += sizeof(obj.m_dwConnectionID);
    unOffSet += sizeof(obj.m_dwConnectionID);
    
    obj.m_dwDbID = *((unsigned int*)p);
    p += sizeof(obj.m_dwDbID);
    unOffSet += sizeof(obj.m_dwDbID);
    
    obj.m_dwAppUserID = *((unsigned int*)p);
    p += sizeof(obj.m_dwAppUserID);
    unOffSet += sizeof(obj.m_dwAppUserID);  
    
    obj.m_nRetCode = *((int*)p);
    p += sizeof(obj.m_nRetCode);
    unOffSet += sizeof(obj.m_nRetCode); 
    
    if(obj.m_nRetCode==0)
    {
        [self stopTimer];
        if(delegate!=nil&&[delegate respondsToSelector:@selector(logoutDidSuccess)]){
            [delegate logoutDidSuccess];
        }
    }else
    {
        [self throwErrorWithStr:[NSString stringWithFormat:@"Error Code:%d",obj.m_nRetCode]];
    }
}


#pragma mark <NSStreamDelegate>
- (void)readBytes:(NSInputStream *)stream resData:(NSMutableData *)data
{
	while ([stream hasBytesAvailable]) {
		int maxLength = 1024;
		uint8_t buffer[maxLength];
		int length = [stream read:buffer maxLength:maxLength];
		
		if (length > 0) {
			[data appendBytes:buffer length:length];
		}
	}
}
-(void)handleInputStreamEvent:(NSStreamEvent)eventCode{
	static AS_PACKINFO_HEADER appHdr;
	static AS_APP_PACK appBody;
	
    
	switch(eventCode) 
	{
		case NSStreamEventHasBytesAvailable:
		{
			NSMutableData *data=[NSMutableData data];
			[self readBytes:self.input resData:data];
			[self.temp_data appendData:data];
			//MLOG(@"%d bytes recived!",[data length]);
			[Global flowCount:[data length]];
			if(!isWaitBody)
			{
				if([self.temp_data length]>=sizeof(appHdr))
				{
					memset(&appHdr, 0, sizeof(appHdr));
					memcpy(&appHdr, [self.temp_data bytes], sizeof(appHdr));
					if([self.temp_data length]==appHdr.wMsgSize){
						[self handleSrvMessageWithData:self.temp_data];
					}else{
						if([self.temp_data length]>sizeof(appHdr))
						{
							NSData *d=[self.temp_data subdataWithRange:NSMakeRange(sizeof(appHdr), [self.temp_data length]-sizeof(appHdr))];
							self.temp_data=[NSMutableData dataWithData:d];
						}else
						{
							self.temp_data=[NSMutableData data];
						}
						isWaitBody=TRUE;
						break;
					}					
				}
			}else
			{
				if([self.temp_data length]>=appHdr.wMsgSize-sizeof(appHdr)){
					memset(&appBody, 0, sizeof(appBody));
					memcpy(&appBody, [self.temp_data bytes], appHdr.wMsgSize-sizeof(appHdr));
					
					AS_PACKINFO temp;
					memcpy(&temp.MsgHdr, &appHdr, sizeof(appHdr));
					memcpy(temp.App.Buf, appBody.Buf, appHdr.wMsgSize-sizeof(appHdr));//拷贝业务数据
					
					NSMutableData *d=[NSMutableData dataWithBytes:&temp length:appHdr.wMsgSize];
					[self handleSrvMessageWithData:d];
					isWaitBody=FALSE;
				}
			}
            break;
		}
		case NSStreamEventEndEncountered:
		{
			[self close_Socket];
			break;
		}
		case NSStreamEventErrorOccurred:
        {
			
            NSError *theError = [self.input streamError];
            [self throwLoseConnectionError:[theError localizedDescription]];
			//MLOG(@"################################ - 失去链接:%@ - ###################",[theError localizedDescription]);
            break;
        }
    }
    
}

-(void)handleOutputStreamEvent:(NSStreamEvent)eventCode{
	switch (eventCode) {
		case NSStreamEventEndEncountered:
		{
			[self close_Socket];
			break;
		}
		case NSStreamEventErrorOccurred:
        {
			
            NSError *theError = [self.output streamError];
            [self throwLoseConnectionError:[theError localizedDescription]];
			//MLOG(@"################################ - 失去链接:%@ - ###################",[theError localizedDescription]);
            break;
        }			
	}
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode{
	if (stream == self.input) {
        [self handleInputStreamEvent:eventCode];
    }
    else if (stream == self.output) {
        [self handleOutputStreamEvent:eventCode];
    }	
}

-(void)close_Socket{
	if(self.input != nil){
		[self.input close];
		[self.input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.input=nil;
		[self.output close];
		[self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.output=nil;
	}
}

-(void)dealloc{
	[temp_data release];
	[timer release];
	
	[input setDelegate:nil]; [input release]; 
	[output setDelegate:nil]; [output release];
	[super dealloc];
}
@end
