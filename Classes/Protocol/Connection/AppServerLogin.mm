//
//  AppServerLogin.m
//  idCard91
//
//  Created by Zhaolin He on 09-8-21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Global.h"
#import "AppServerLogin.h"
#import "P91PassDelegate.h"
#import "RootViewController.h"
#import "MBGetDefCataListMsg.h"
#import "PFunctions.h"
#import "Business.h"

#import "XPBCocoaDebugger.h"

#import "RootViewController.h"
#import "CommonReconnectObject.h"

#define WAIT_FOR_TICK_TIME  14.5//心跳频率

@interface AppServerLogin()
-(void)stopTimer;
-(void)stopTickTimer;
-(bool)openSocket;
-(void)close_Socket;
- (bool)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream **)inputStreamPtr 
				 outputStream:(NSOutputStream **)outputStreamPtr;
-(void)createFirstPacket;
-(int)sendPacket;
-(void)throwErrorWithStr:(NSString *)str;
@property(nonatomic,retain)NSInputStream *input;
@property(nonatomic,retain)NSOutputStream *output;
@property(nonatomic,retain)NSMutableData *temp_data;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)NSTimer *sendTickTimer;
@end


@implementation AppServerLogin
@synthesize input,output,delegate,username,password,temp_data,timer,isLogined,sendTickTimer;

//全局变量
static BOOL isWaitBody=FALSE;
NOTE_LOGIN_LBS_REPLY srvInfo;//服务器ip等信息
AS_APP_PACK_WITH_TYPE AppWithType;//业务数据
AS_LOGINAPPSRVRSP srvRsp; //服务器第一次返回的数据

-(id)initWithSrvInfo:(NOTE_LOGIN_LBS_REPLY)info
{
	if(self=[super init])
	{
		memset(&srvInfo, 0, sizeof(info));
		memcpy(&srvInfo, &info, sizeof(info));
		//memcpy(srvInfo.szInfo, "111", strlen("111"));
		
		isWaitBody=FALSE;
        isLogined = FALSE;
        
        delegate = nil;
	}
	return self;
}

-(int)startRequest
{
	[self stopTimer];
    [self stopTickTimer];
	self.timer=[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self createFirstPacket];
	return  [self sendPacket];
}

-(void)timeOut
{
	[Global InitConnectState:NO];
	MLOG(@"################################ - sock链接超时 - ###################");
    isLogined = FALSE;
	[self throwErrorWithStr:NSLocalizedString(@"sock_timeout",nil)];
	[[RootViewController sharedView] stopWaiting];
}

-(void)stopTimer
{
	if(self.timer!=nil)
    {
		[self.timer invalidate];
		self.timer=nil;
	}
}

- (void)stopTickTimer
{
    if(self.timer!=nil)
    {
		[self.timer invalidate];
		self.timer=nil;
	}
}

//发生心跳包
- (void)sendTick
{
    if(isLogined && output != nil && [Global getSyncStatus] == SS_NONE)
    {
        AS_PACKINFO_HEADER StopPack;
        memset(&StopPack, 0x00, sizeof(StopPack));
        
        StopPack.wAsynFlag = 0x5d5d;
        StopPack.wOpCode = 4998;
        StopPack.wMsgSize = sizeof(StopPack);
        
        NSInteger len = [output write:(const uint8_t*)&StopPack maxLength:StopPack.wMsgSize];
        if(len == -1)
        {
			NSError * err = [output streamError];
            MLOG(@"sendTickTimer Failed, %@", [err localizedDescription]);
            [self stopTickTimer];
        }
    }
    else
    {
        [self stopTickTimer];       
    }
}

-(void)throwErrorWithStr:(NSString *)str
{
	[Global InitConnectState:NO];
	MLOG(@"################################ - 登录失败 - ###################");
	[self stopTimer];
	[self close_Socket];
    isLogined = FALSE;
	if(delegate!=nil&&[delegate respondsToSelector:@selector(loginDidFailedWithError:)])
	{
		[delegate loginDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
	}
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
	[[RootViewController sharedView] stopWaiting];
	
	MLOG(str);
}
-(void)throwLoseConnectionError:(NSString *)str
{
	[Global InitConnectState:NO];
	MLOG(@"################################ - 与服务器断开链接 - ###################");
	MLOG(@"throwLoseConnectionError 掉线");
    isLogined = FALSE;
	[self stopTimer];
	[self close_Socket];
	[Global InitConnectState:NO];
	//if(delegate!=nil&&[delegate respondsToSelector:@selector(requiredReLogin)])
	//{
		//[delegate requiredReLogin];
	//} 
	// 在这里设置重连
	CommonReconnectObject *cro = [CommonReconnectObject shareCommonReconnectObject];
	
	RootViewController *log = [RootViewController sharedView];
	log.delegate = cro;
	[log reConnect:@""];
	
	[[RootViewController sharedView] stopWaiting];
	MLOG(str);
}

#pragma mark <Create Packet>
-(void)createFirstPacket
{
	memset(&AppWithType, 0, sizeof(AppWithType));
	AppWithType.wOpCode=AS_OPCODE_LOGIN_REQ;
	AppWithType.dwDataSize=sizeof(AS_LOGINAPPSRVREQ);
	
	memcpy(AppWithType.App.LoginReq.strUserName,[self.username UTF8String],[self.username lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	AppWithType.App.LoginReq.dwGAID = srvInfo.idAccount;
	AppWithType.App.LoginReq.dwUserID = srvInfo.dwUin;
	AppWithType.App.LoginReq.dwData = srvInfo.dwData;
	AppWithType.App.LoginReq.wOpType = AS_OPTYPE_NOTE;
	AppWithType.App.LoginReq.wAssistInfo = 0;
}

-(void)createSecondPacket
{
	unichar *uname=new(std::nothrow)unichar[([self.username length] + 1)*sizeof(unichar)];
	memset(uname, 0, ([self.username length] + 1)*sizeof(unichar));
	unichar *pass=new(std::nothrow)unichar[([self.password length] + 1)*sizeof(unichar)];
	memset(pass, 0, ([self.password length] + 1)*sizeof(unichar));
	
	if(NULL==uname||NULL==pass)
	{
		//RELEASE_LOG(@"AppServerLogin.mm createSecondPacket NULL==uname||NULL==pass");
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		return;
	}

	NSRange range;
	range.location = 0;
	
	range.length = [self.username length];
	[self.username getCharacters:uname range:range];
	range.length = [self.password length];
	[self.password getCharacters:pass range:range];
    
	int m_nUserType=0;
	CMBMobileInfo m_MobileInfo;
	unsigned int unLen = sizeof(srvRsp.GAID) + sizeof(srvRsp.dwUserid) + sizeof(m_nUserType) + sizeof(m_MobileInfo);
	unLen += (wcslen_m((char *)uname) + 1) * 2 + (wcslen_m((char *)pass) + 1) * 2;
	//拼装数据
	unsigned char *szLoginInfo=new unsigned char[unLen];
	if(NULL==szLoginInfo)
	{
		//RELEASE_LOG(@"AppServerLogin.mm createSecondPacket NULL==szLoginInfo");
		[self throwErrorWithStr:NSLocalizedString(@"memory_alloc_error",nil)];
		delete[] uname; uname=NULL;
		delete[] pass; pass=NULL;
		return;
	}
	
	unsigned char *p=szLoginInfo;
	memcpy(p, &srvRsp.GAID, sizeof(srvRsp.GAID));
    p += sizeof(srvRsp.GAID);
	
	memcpy(p, &srvRsp.dwUserid, sizeof(srvRsp.dwUserid));
    p += sizeof(srvRsp.dwUserid);
	
	memcpy(p, &m_nUserType, sizeof(m_nUserType));
    p += sizeof(m_nUserType);
	
    memcpy(p, &m_MobileInfo, sizeof(m_MobileInfo));
    p += sizeof(m_MobileInfo);
    
	int strLen=(wcslen_m((char *)uname) + 1) * 2;
    memcpy((unichar*)p, uname,strLen);
	p += strLen;
	
	strLen=(wcslen_m((char *)pass) + 1) * 2;
	memcpy((unichar*)p, pass,strLen);
	p += strLen;
	
	memset(&AppWithType, 0, sizeof(AppWithType));
	memcpy(AppWithType.App.Buf, szLoginInfo, unLen);
	AppWithType.dwDataSize=unLen;
	AppWithType.wOpCode=OPN_MB_USER_LOGIN_EX_REQ;
	
	delete[] uname; uname=NULL;
	delete[] pass; pass=NULL;
	delete[] szLoginInfo; szLoginInfo=NULL;
}

#pragma mark <send Packet>
-(int)sendPacket
{
	int totalByteSend = 0;
	if(self.output==nil)
	{
		if(![self openSocket])
		{
			//RELEASE_LOG(@"AppServerLogin.mm sendPacket self.output==nil");
			[self throwErrorWithStr:NSLocalizedString(@"sock_path_error",nil)];
			
			return totalByteSend;
		}
	}
	self.temp_data=[NSMutableData data];//清空临时数据
	isWaitBody=FALSE;
	//send data to socket
	unsigned int wOpCode=AppWithType.wOpCode;
	unsigned int dwLen=AppWithType.dwDataSize;	
	char *pBuf=(char*)AppWithType.App.Buf;
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
	
	if(totalByteSend>0)
		[Global flowCount:totalByteSend];
	return totalByteSend;
}

#pragma mark <Socket Manager>
-(bool)openSocket
{
	MLOG(@"Enter openSocket ...");
	NSString *server_ip=[NSString stringWithUTF8String:srvInfo.szInfo];
	NSInteger server_port=srvInfo.nServerPort;
	NSInputStream *iStream=nil;
	NSOutputStream *oStream=nil;
	bool isON=[self getStreamsToHostNamed:server_ip port:server_port inputStream:&iStream outputStream:&oStream];
	if(isON)
	{
		MLOG(@"in openSocket, isON is true...");
		self.output=oStream;
		[self.output setDelegate:self];
		[self.output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[self.output open];
        
		self.input=iStream;
		[self.input setDelegate:self];
		[self.input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[self.input open];
	}
	return isON;
}

-(void)close_Socket
{
	if(self.input != nil)
	{
		[self.input close];
		[self.input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.input=nil;
		[self.output close];
		[self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.output=nil;
	}
}
- (bool)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream **)inputStreamPtr 
				 outputStream:(NSOutputStream **)outputStreamPtr
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
	
    if(	(hostName == nil)||
	   ((port < 0) || (port > 65536))||
	   ((inputStreamPtr == NULL) || (outputStreamPtr == NULL) )
	   )
	{
		return NO;
	}	
	
    readStream = NULL;
    writeStream = NULL;
	
    CFStreamCreatePairWithSocketToHost(
									   NULL, 
									   (CFStringRef) hostName, 
									   port, 
									   ((inputStreamPtr  != nil) ? &readStream : NULL),
									   ((outputStreamPtr != nil) ? &writeStream : NULL)
									   );
	
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = [NSMakeCollectable(readStream) autorelease];
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = [NSMakeCollectable(writeStream) autorelease];
    }
	return YES;
}

#pragma mark <process message>

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
	AS_PACKINFO_HEADER header;
	memcpy(&header, [data bytes], sizeof(header));
	if(header.wOpCode==AS_OPCODE_LOGIN_RSP)
	{
		AS_PACKINFO *packet=(AS_PACKINFO *)[data bytes];
		memset(&srvRsp, 0, sizeof(srvRsp));
		memcpy(&srvRsp, &packet->App.LoginRsp, sizeof(packet->App.LoginRsp));
        
		[self createSecondPacket];
		[self sendPacket];
	}
	else if(header.wOpCode==OPN_MB_USER_LOGIN_EX_ACK)
	{
		CMBUserLoginExAck obj;
		unsigned int unOffSet=0;
		
		unsigned int unMinLen = sizeof(obj.m_dwConnectionID) + sizeof(obj.m_dwDbID) + sizeof(obj.m_dwAppUserID) + sizeof(obj.m_nRetCode);
		if(unMinLen>[data length]-sizeof(AS_PACKINFO_HEADER))
		{
			//RELEASE_LOG(@"AppServerLogin.mm handleSrvMessageWithData unMinLen>[data length]-sizeof(AS_PACKINFO_HEADER)");
			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
		}
		
		char *p=(char *)[data bytes];
		p+=sizeof(AS_PACKINFO_HEADER);
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
        
        memcpy(obj.m_ucMasterKey, p, sizeof(obj.m_ucMasterKey));
        p += sizeof(obj.m_ucMasterKey);
        unOffSet += sizeof(obj.m_ucMasterKey);
        
		
		if(obj.m_nRetCode==0)
		{
			[self stopTimer];
			
			NSString *user;
			NSString *pass;
			//保存用户名和密码
			if ([PFunctions getBackgroudLogin] == NO)
			{
				user = [PFunctions getUsernameFromKeyboard];
				pass = [PFunctions getPassnameFromKeyboard];
				
			}
			else
			{
				user = [PFunctions getUserName];
				pass = [PFunctions getPassword];
			}
			[Global initPassWordInMemory:pass];
            
			[PFunctions setUsername:user Password:pass];
			
			if(delegate!=nil&&[delegate respondsToSelector:@selector(loginDidSuccessWithData:inputStream:outputStream:)])
			{
				[Global InitConnectState:YES];
                isLogined = TRUE;
                
                // 启动定时器发送心跳包
                self.sendTickTimer = [NSTimer scheduledTimerWithTimeInterval:WAIT_FOR_TICK_TIME
                                                                      target:self selector:@selector(sendTick) userInfo:nil repeats:YES];
                
				// 返回登录成功消息
				[delegate loginDidSuccessWithData:[NSData dataWithBytes:&obj length:sizeof(obj)] inputStream:self.input outputStream:self.output];
			}
			else
			{
				//MLOG(@"no delegate");
			}
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
			//
			//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
			[[RootViewController sharedView] stopWaiting];
		}
		else
		{
			[Global InitConnectState:NO];
			MLOG(@"failed_login<delegate>?");
			//RELEASE_LOG(@"AppServerLogin.mm handleSrvMessageWithData obj.m_nRetCode!=0");
			//[self throwErrorWithStr:[NSString stringWithFormat:@"Error retCode:%d",obj.m_nRetCode]];
			[self throwLoseConnectionError:NSLocalizedString(@"server_ret_error",nil)];
			
			[[RootViewController sharedView] stopWaiting];
		}
        
        [PFunctions setMasterKey:[NSData dataWithBytes:obj.m_ucMasterKey length:8]];
        [Business setMasterKey:obj.m_ucMasterKey length:sizeof(obj.m_ucMasterKey)];
	}
	else
	{
		[Global InitConnectState:NO];
		MLOG(@"socket_break<delegate>?");
		//RELEASE_LOG(@"AppServerLogin.mm handleSrvMessageWithData header.wOpCode else");
		[self throwErrorWithStr:NSLocalizedString(@"sock_opCode_error",nil)];
		[[RootViewController sharedView] stopWaiting];
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

-(void)handleInputStreamEvent:(NSStreamEvent)eventCode
{
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
					if([self.temp_data length]==appHdr.wMsgSize)
                    {
                        //DLOG(@"%d bytes received!", [self.temp_data length]);
						[self handleSrvMessageWithData:self.temp_data];
					}
                    else
                    {
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
			}
			else
			{
				if([self.temp_data length]>=appHdr.wMsgSize-sizeof(appHdr)){
					memset(&appBody, 0, sizeof(appBody));
					memcpy(&appBody, [self.temp_data bytes], appHdr.wMsgSize-sizeof(appHdr));
                    
					AS_PACKINFO temp;
					memcpy(&temp.MsgHdr, &appHdr, sizeof(appHdr));
					memcpy(temp.App.Buf, appBody.Buf, appHdr.wMsgSize-sizeof(appHdr));//拷贝业务数据
                    
					NSMutableData *d=[NSMutableData dataWithBytes:&temp length:appHdr.wMsgSize];
                    DLOG(@"%d bytes received!", [d length]);
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
			MLOG(@"################################ - 失去链接:%@ - ###################",[theError localizedDescription]);
            [self throwLoseConnectionError:[theError localizedDescription]];
			[[RootViewController sharedView] stopWaiting];
            break;
        }
    }
    
}

-(void)handleOutputStreamEvent:(NSStreamEvent)eventCode
{
	switch (eventCode) 
    {
		case NSStreamEventEndEncountered:
		{
			[self close_Socket];
			break;
		}
		case NSStreamEventErrorOccurred:
        {
            NSError *theError = [self.output streamError];
			//MLOG(@"################################ - 失去链接:%@ - ###################",[theError localizedDescription]);
            // 与服务器链接断开
			[self throwLoseConnectionError:[theError localizedDescription]];
			[[RootViewController sharedView] stopWaiting];
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

#pragma mark <GetDirecSuccessDelegate>
-(void)getDefDirDidSuccessWithData:(CMBGetDefCataListAck *)items
{
	if ([Global defaultCateID] == GUID_NULL)
	{
		MLOG(@"获取目录成功!");
		CMBCateInfo cateInfo = *(items->m_lstPMBCateInfo.begin());
        cateInfo.tHead.nEditState = 0;
        [Business saveCate:cateInfo];
        
        //保持默认文件夹GUID
        string strDefaultId = [CommonFunc guidToString:cateInfo.guid];
        [Business setCfgString:"user" name:"defaultCateID" value:strDefaultId.c_str()];
        [Global setDefaultCateID:cateInfo.guid];
	}
}

-(void)dealloc
{
	[temp_data release];
	[timer release];
	
	[input release]; 
	[output release]; 
	[username release];
	[password release];
	[super dealloc];
}

@end
