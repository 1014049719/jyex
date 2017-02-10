//
//  idCard91ViewController.m
//  idCard91
//
//  Created by Zhaolin He on 09-8-18.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "Global.h"
#import "LbsServer.h"
#import "DES3.h"
#import "AppServerLogin.h"
#import "P91PassDelegate.h"
#import "RootViewController.h"
#import "EncryptKey.h"
#import "PFunctions.h"

#import "XPBCocoaDebugger.h"

//#ifndef _DEBUG_
//#define _DEBUG_
//#endif

#define CONST_PHONE_KEY_LEN 24

@interface LbsServer()
-(void)stopTimer;
-(void)throwErrorWithStr:(NSString *)str;
-(bool)openSocket;
-(void)sendPacketWithIndex:(NSInteger)index;
- (bool)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream **)inputStreamPtr 
				 outputStream:(NSOutputStream **)outputStreamPtr;
-(void)close_Socket;
@property(nonatomic,retain)NSInputStream *input;
@property(nonatomic,retain)NSOutputStream *output;
@property(nonatomic,retain)NSMutableData *temp_data;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,retain)AppServerLogin *appBusiness;
@end


@implementation LbsServer
@synthesize input,output,appBusiness,delegate,temp_data,timer,bIsLBSLogined;

//全局变量
static LbsServer *gb_server = nil;
static BOOL isWaitBody=FALSE;
NOTE_LOGIN_LBS_APP_WITH_TYPE lbsAppWithType;
//客户端的密钥
unsigned char pkey[CONST_PHONE_KEY_LEN]={0};
//服务器的密钥
unsigned char skey[512]={0};
int m_nLenOfMobileSerkey=0;

+(LbsServer *)shareLbServer
{
	if (gb_server == nil)
	{
		gb_server = [[LbsServer alloc] initWithUsername:[PFunctions getUserName] Password:[Global getPassWordFromMemory] AppType:@"6" delegate:self];
	}
	else
	{
		[gb_server close_Socket];
	}
	
	return gb_server;
}

-(void)createWithUsername:(NSString *)uname Password:(NSString *)passwd APpType:(NSString *)type delegate:(id)obj{
	username=[uname retain];
	pass=[passwd retain];
	appType=[type retain];
	self.delegate=obj;
	
	isWaitBody=FALSE;
    bIsLBSLogined = NO;
}


-(id)initWithUsername:(NSString *)uname Password:(NSString *)passwd AppType:(NSString *)type delegate:(id)obj
{
	if(self=[super init]){
		//to do...
		username=[uname retain];
		pass=[passwd retain];
		appType=[type retain];
		self.delegate=obj;
		
		isWaitBody=FALSE;
	}
	return self;
}

-(void)startLogin
{
	MLOG(@"Begin Login >>>");
	[self stopTimer];
	//初始化定时器
	self.timer=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
	[self sendPacketWithIndex:1];
}

-(void)timeOut
{
	//[self throwErrorWithStr:NSLocalizedString(@"sock_timeout",nil)];
    if([delegate respondsToSelector:@selector(timeOut)])
        [delegate timeOut];
}

-(void)stopTimer
{
	if(self.timer!=nil)
	{
		if ([self.timer isValid] == YES)
		{
			[self.timer invalidate];
			self.timer=nil;
		}
	}
}

-(void)throwErrorWithStr:(NSString *)str
{
	[self stopTimer];
	[self close_Socket];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	if(delegate!=nil&&[delegate respondsToSelector:@selector(loginDidFailedWithError:)])
    {
		[delegate loginDidFailedWithError:[NSError errorWithDomain:str code:10 userInfo:nil]];
		[[RootViewController sharedView] stopWaiting];
	} 
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
	
	
	//MLOG(str);
}

-(void)CreatePhoneRandomKey
{
	srand(time(NULL));
	for (int i= 0 ;i<CONST_PHONE_KEY_LEN; i++)
	{
		int nRand = rand();
		pkey[i] = (unsigned char)nRand;
	}
}

#pragma mark <create packet>
-(void)createFirstPaket
{
	
	memset(&lbsAppWithType, 0, sizeof(lbsAppWithType));
	// ----------------公钥加密手机的key----------------- 
	[self CreatePhoneRandomKey];//先获取本机24字节的KEY(随机)
	unsigned char* ekey = NULL;
	unsigned int m_nLenOfEncryKey = 0;
	ekey=CEncryptKEY::encryptPubKeyRSA(pkey, m_nLenOfEncryKey);
	memcpy(lbsAppWithType.App.MobDesKey.btDesKey,ekey,m_nLenOfEncryKey);
    free(ekey);
    
    /*
    unsigned int len = 0;
    unsigned char *testresult = 0;
    unsigned char teststring[24] = { '5','g',';','m','(','{','c','R','v','!','`','g','f','6','H','*','+','B','=','$','^','b','d','.' };
    testresult=CEncryptKEY::encryptPubKeyRSA(teststring, len);
    free(testresult);
    
    char a[] = "C6QExuk3UxiVxnEzWA7RUXWgRAmOqxfd+iJj4z5hahblFMPTs512Hs+ulWDpeenphpwekTKLofOZROQ1SQHybw==";
    char b[] = "JDys4m0kD8hi9UhayF54wZ1RK3yW9Rk0Qzho2ul6nHdQqyuqzM7frkaFdOqHsk/u+EhYyki30hAOANKSjx3Ziw==";
    char c[] = "bwV+CNbsASogVyhG9raPKXk/Jkr4MvogqmtnDyPSf0qwv9kgXG/ygW5QfeEoCf/v0buUuIBRKAfZsoyqzFvEDA==";
    */
	
	lbsAppWithType.wAppSize=sizeof(lbsAppWithType.App.MobDesKey);//m_nLenOfEncryKey;//
	//客户端版本号
	lbsAppWithType.App.MobDesKey.dwVersion= 1;
	//加入数据包头
	lbsAppWithType.wConnectFlag=DATA_TYPE_EXCHANG_KEY;
}

-(void)createSecondPaket
{
	MLOG(@"createSecondPaket begin");
	memset(&lbsAppWithType, 0, sizeof(lbsAppWithType));
	
	unsigned char szLoginInfo[1024]={0};
	////------------------用mobileSer的KEY加密用户名和密码及应用服务器名------------------------ 
	int nLenOfAppType = [appType lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1;//服务类型，笔记是“6”
	char* pAppType =(char*)szLoginInfo;// new unsigned char[nLenOfAppType];
	memcpy(pAppType, [appType UTF8String], nLenOfAppType);
	
	int nLenOfUserName = [username lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1;
	char* pUserName =(char*) szLoginInfo + nLenOfAppType;//new unsigned char[nLenOfUserName];
	memcpy(pUserName, [username UTF8String], nLenOfUserName);
	MLOG(@"User name ok");
	int nLenOfPassword = [pass lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1;
	char* pPassword = (char*)szLoginInfo + nLenOfAppType + nLenOfUserName;// new unsigned char[nLenOfPassword];
	memcpy(pPassword, [pass UTF8String], nLenOfPassword);
	
    //#ifdef _DEBUG_
    //	NSString *m_strSvrName =@"appsvr811";
    //#else
	NSString *m_strSvrName = NOTE_LBS_SVRNAME;
    //#endif
	int nLenOfSerName = [m_strSvrName lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1;
	char* pSerName =(char*) szLoginInfo + nLenOfAppType + nLenOfUserName+ nLenOfPassword;//new unsigned char[nLenOfSerName];
	memcpy(pSerName, [m_strSvrName UTF8String], nLenOfSerName);//负载均衡器的名字
	
	unsigned int nTotalSize = nLenOfAppType + nLenOfUserName + nLenOfPassword + nLenOfSerName;
	//MLOG(@"total length of packet2:%d",nTotalSize);
	
	char* pBuf=(char*)lbsAppWithType.App.Buf;
	int unEnOutLenOf = 0;
	////加密
	//EncryptDES3(skey, szLoginInfo, nTotalSize, (unsigned char*)pBuf, &unEnOutLenOf);
	SetDES3Param(skey, DES3_3KEY_ENCRYPT, PAD_PKCS_7, DES_CBC);
	Run_Des(szLoginInfo, nTotalSize, (unsigned char*)pBuf, &unEnOutLenOf);
	
	lbsAppWithType.wAppSize=unEnOutLenOf;
	lbsAppWithType.wConnectFlag=DATA_TYPE_LOGIN_ACCOUNT_SERVER;
	MLOG(@"createSecondPaket begin end");
}

#pragma mark <sendPacketWithIndex>
-(void)sendPacketWithIndex:(NSInteger)index
{
	if(self.output==nil)
	{
		if(![self openSocket])
		{
			//RELEASE_LOG(@"LbsServer.mm sendPacketWithIndex ![self openSocket]");
			[self throwErrorWithStr:NSLocalizedString(@"sock_path_error",nil)];
			return;
		}
	}
	self.temp_data=[NSMutableData data];//清空临时数据
	isWaitBody=FALSE;
	
	switch (index) 
	{
		case 1:
			[self createFirstPaket];
			break;
		case 2:
			[self createSecondPaket];
			break;
		default:
			return;
	}
	
	//init pack
	NOTE_LOGIN_LBS_PACKAGE lbsPack;
	memset(&lbsPack, 0, sizeof(lbsPack));
	
	//添加起始标志
	lbsPack.MsgHdr.bytes.btStartFlag1=0xff;
	lbsPack.MsgHdr.bytes.btStartFlag2=0xfe;
	
	//填充数据包大小及消息类型
	lbsPack.MsgHdr.wMsgSize=lbsAppWithType.wAppSize+sizeof(lbsPack.MsgHdr);
	lbsPack.MsgHdr.wConnectFlag=lbsAppWithType.wConnectFlag;
	
	//拷贝业务层数据
	memcpy(&lbsPack.AppLayer,&lbsAppWithType.App,lbsAppWithType.wAppSize);
	
	
	NSInteger len=[self.output write:(const uint8_t *)&lbsPack maxLength:lbsPack.MsgHdr.wMsgSize];
	MLOG(@"%d bytes sended!",len);
	[Global flowCount:len];
}

#pragma mark <Socket Manager>
-(bool)openSocket
{
	MLOG(@"openSocket");
    //#ifdef _DEBUG
    //	NSString *server_ip=@"192.168.9.104";
    //#else
	NSString *server_ip= NOTE_HOST;
    //#endif
	NSInteger server_port= NOTE_PORT;
	NSInputStream *iStream=nil;
	NSOutputStream *oStream=nil;
	bool isON=[self getStreamsToHostNamed:server_ip port:server_port inputStream:&iStream outputStream:&oStream];
	if(isON)
	{
		MLOG(@"Server is ON >>>>>>");
		self.output=oStream;
		[self.output setDelegate:self];
		[self.output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[self.output open];
		
		self.input=iStream;
		[self.input setDelegate:self];
		[self.input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[self.input open];
		
	}	
	else
	{
		MLOG(@"Server is OFF >>>>>>");
	}
	return isON;
}

-(void)close_Socket
{
	MLOG(@"close_Socket");
	if(self.input!=nil)
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
	//解包
	NOTE_LOGIN_LBS_PACKAGE recvd;
	memcpy(&recvd, [data bytes], [data length]);
	if(recvd.MsgHdr.wConnectFlag==DATA_TYPE_EXCHANG_KEY)
	{
		if([data length]!=38)
		{
			//RELEASE_LOG(@"LbsServer.mm handleSrvMessageWithData [data length]!=38");
			[self throwErrorWithStr:NSLocalizedString(@"sock_length_error",nil)];
			return;
		}
		unsigned char *pDesKeyBuf=recvd.AppLayer.MobSrvDesKey.btDesKey;
		//利用客户端的密钥解密，得到服务器的密钥。。。
		unsigned char strMobileSerkey[512]={0};
		unsigned char strEnMoibleSerKey[32]={0};//服务器返回的加密串
		unsigned int unLenOfMobileSerkey = recvd.MsgHdr.wMsgSize-sizeof(recvd.MsgHdr); //加密串长度
		memcpy(strEnMoibleSerKey,pDesKeyBuf,unLenOfMobileSerkey);
		//DecryptDes3((char *)pkey, strEnMoibleSerKey, unLenOfMobileSerkey, strMobileSerkey, &m_nLenOfMobileSerkey);
		SetDES3Param(pkey, DES3_3KEY_DECRYPT, PAD_PKCS_7, DES_CBC);
		Run_Des(strEnMoibleSerKey, unLenOfMobileSerkey, strMobileSerkey, &m_nLenOfMobileSerkey);
		
		memcpy(skey,strMobileSerkey,m_nLenOfMobileSerkey);
		[self sendPacketWithIndex:2];
		
	}else if(recvd.MsgHdr.wConnectFlag==DATA_TYPE_SENDBACK_APPSERVERINFO)
	{
		[self close_Socket];
		unsigned char *pSrvInfoBuf=recvd.AppLayer.Buf;
		//利用服务端的密钥解密，得到应用服务器的信息。。。
		unsigned char strSrvInfo[512]={0};
		unsigned char strEnSrvInfo[512]={0};//服务器返回的加密串
		unsigned int unLenOfSrvInfo = recvd.MsgHdr.wMsgSize-sizeof(recvd.MsgHdr); //加密串长度
		int iLenOfSrvInfo=0;
		memcpy(strEnSrvInfo,pSrvInfoBuf,unLenOfSrvInfo);
		//DecryptDes3((char *)pkey, strEnSrvInfo, unLenOfSrvInfo, strSrvInfo, &iLenOfSrvInfo);
		SetDES3Param(pkey, DES3_3KEY_DECRYPT, PAD_PKCS_7, DES_CBC);
		Run_Des(strEnSrvInfo, unLenOfSrvInfo, strSrvInfo, &iLenOfSrvInfo);
		
        bIsLBSLogined = YES;
		//明文信息
		NOTE_LOGIN_LBS_REPLY srvInfo;
		memset(&srvInfo,0,sizeof(srvInfo));
		memcpy(&srvInfo, strSrvInfo, iLenOfSrvInfo);
		if(srvInfo.idAccount!=0){
			[self stopTimer];
			
			MLOG(@"服务器 IP:%s:%d",srvInfo.szInfo,srvInfo.nServerPort);
			AppServerLogin *temp=[[AppServerLogin alloc] initWithSrvInfo:srvInfo];
			self.appBusiness=temp;
			[temp release];
			appBusiness.delegate=self.delegate;
			appBusiness.username=username;
			appBusiness.password=pass;
			[appBusiness startRequest];
		}else{
			CFStringRef ch=CFStringCreateWithCString(NULL, srvInfo.szInfo, kCFStringEncodingGB_18030_2000);
			NSString *str=[NSString stringWithFormat:@"%@!",(NSString *)ch];
			if(ch!=NULL){
				CFRelease(ch);
			}
			//RELEASE_LOG(@"LbsServer.mm handleSrvMessageWithData srvInfo.idAccount==0");
			[self throwErrorWithStr:str];
		}
	}else if(recvd.MsgHdr.wConnectFlag==DATA_TYPE_ERRO_NOTIFY)
	{
		CFStringRef ch=CFStringCreateWithCString(NULL, recvd.AppLayer.ErrInfo.szInfo, kCFStringEncodingGB_18030_2000);
		NSString *str=[NSString stringWithFormat:@"%@!",(NSString *)ch];
		if(ch!=NULL){
			CFRelease(ch);
		}
		//RELEASE_LOG(@"LbsServer.mm handleSrvMessageWithData recvd.MsgHdr.wConnectFlag==DATA_TYPE_ERRO_NOTIFY");
		[self throwErrorWithStr:str];
	}else //返回数据不对
	{
		//RELEASE_LOG(@"LbsServer.mm handleSrvMessageWithData 返回的数据不对");
		[self throwErrorWithStr:NSLocalizedString(@"sock_opCode_error",nil)];
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

-(int)handleInputStreamEvent:(NSStreamEvent)eventCode{
	static NOTE_LOGIN_LBS_HEADER lbsHdr;
	static NOTE_LOGIN_LBS_APP_LAYER lbsApp;
	
	int bufferLen = 0;
	switch(eventCode) 
	{
		case NSStreamEventHasBytesAvailable:
		{
			NSMutableData *data=[NSMutableData data];
			[self readBytes:self.input resData:data];
			[self.temp_data appendData:data];
			//MLOG(@"%d bytes recived!",[data length]);
			bufferLen += [data length];
			
			if(!isWaitBody)
			{
				if([self.temp_data length]>=sizeof(lbsHdr))
				{
					memset(&lbsHdr, 0, sizeof(lbsHdr));
					memcpy(&lbsHdr, [self.temp_data bytes], sizeof(lbsHdr));
					if([self.temp_data length]==lbsHdr.wMsgSize){
						[self handleSrvMessageWithData:self.temp_data];
					}else{
						if([self.temp_data length]>sizeof(lbsHdr))
						{
							NSData *d=[self.temp_data subdataWithRange:NSMakeRange(sizeof(lbsHdr), [self.temp_data length]-sizeof(lbsHdr))];
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
				if([self.temp_data length]>=lbsHdr.wMsgSize-sizeof(lbsHdr)){
					memset(&lbsApp, 0, sizeof(lbsHdr));
					memcpy(&lbsApp, [self.temp_data bytes],lbsHdr.wMsgSize-sizeof(lbsHdr));
					self.temp_data=[NSMutableData data];
					
					NOTE_LOGIN_LBS_PACKAGE temp;
					memcpy(&temp.MsgHdr, &lbsHdr, sizeof(lbsHdr));
					memcpy(temp.AppLayer.Buf, lbsApp.Buf, lbsHdr.wMsgSize-sizeof(lbsHdr));//拷贝业务数据
					
					NSMutableData *d=[NSMutableData dataWithBytes:&temp length:lbsHdr.wMsgSize];
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
			//RELEASE_LOG(@"handleInputStreamEvent NSStreamEventErrorOccurred");
            NSError *theError = [self.input streamError];
			[self throwErrorWithStr:[theError localizedDescription]];
			//[self throwErrorWithStr:NSLocalizedString(@"server_link_error",nil)];
            break;
        }
    }
	if(bufferLen>0)
	{
		[Global flowCount:bufferLen];
	}
	return bufferLen;
	
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
			//RELEASE_LOG(@"handleOutputStreamEvent NSStreamEventErrorOccurred");
            NSError *theError = [self.output streamError];
            [self throwErrorWithStr:[theError localizedDescription]];
			//[self throwErrorWithStr:NSLocalizedString(@"server_link_error",nil)];
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

- (void)reloginAppSvr
{/*
    if(appBusiness != nil && bIsLBSLogined)
    {
        [appBusiness startRequest];
    }*/
}


- (void)dealloc 
{
	MLOG(@"dealloc>>>");
	[self close_Socket];
	[temp_data release];
	[timer release];
	
	[username release];
	[pass release];
	[appType release];
	
	[appBusiness release];
    [super dealloc];
	MLOG(@"safe dealloc>>>");
}

@end
