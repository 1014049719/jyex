//
//  PSocket.m
//  pass91
//
//  Created by Zhaolin He on 09-8-31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PSocket.h"
#import "P91PassDelegate.h"
#import "Plist.h"
#import <zlib.h>
#import "ZipArchive.h"

#import "MBA2BListMsg.h"
#import "MBGetDefCataListMsg.h"
#import "MBItemInfoMsg.h"
#import "MBNoteListMsg.h"
#import "MBShareByCataList.h"
#import "MBSubDirListMsg.h"
#import "MBUpLoadItemMsg.h"
#import "MBUpLoadA2BInfoMsg.h"
#import "MBUpLoadNoteMsg.h"
#import "MBNewNoteListMsg.h"
#import "MBSearchNoteMsg.h"
#import "MBCateListMsg.h"
#import "MBNoteThumbMsg.h"
#import "Common.h"

#import "Global.h"

#import "XPBCocoaDebugger.h"
#import "CommonReconnectObject.h"
#import "RootViewController.h"

static SendDataStruct g_sendData;

@implementation PSocket
@synthesize input,output,delegate,timer/*,temp_data*/,logic_data,m_bStopTrans;

static BOOL isWaitBody=FALSE;
-(id)initWithInput:(NSInputStream *)inputs Output:(NSOutputStream *)outputs target:(id)obj
{
	if(self=[super init])
    {
		self.input=inputs;
		[self.input setDelegate:self];
		self.output=outputs;
		[self.output setDelegate:self];
		self.delegate=obj;
		
		self.m_bStopTrans=NO;
        
        zipFileConnect = nil;
        tempZipFileData = nil;
	}
	return self;
}

-(void)timeOut
{
	MLOG(NSLocalizedString(@"sock_timeout",nil));
    if (g_sendData.isValid() && g_sendData.AsPack.MsgHdr.wDivFlag > 0)
    {
        int len = [self SendStopPack];
        [Global flowCount:g_sendData.totalByteSend + len];
        DLOG(@"total: %d bytes sended!", g_sendData.totalByteSend + len);
        g_sendData.reset();
    }
    
	[self throwErrorWithStr:TIME_OUT];
}

- (void)stop
{
    [self stopTimer];
    
    //停止上传
    if (g_sendData.isValid() && g_sendData.AsPack.MsgHdr.wDivFlag > 0)
    {
        int len = [self SendStopPack];
        [Global flowCount:g_sendData.totalByteSend + len];
        DLOG(@"total: %d bytes sended!", g_sendData.totalByteSend + len);
        g_sendData.reset();
    }
    
    //停止下载
    if (zipFileConnect != nil)
    {
        [zipFileConnect cancel];
        [zipFileConnect release];
        zipFileConnect = nil;
    }
    
    if (tempZipFileData != nil)
    {
        [tempZipFileData release];
        tempZipFileData = nil;
    }
}

-(void)stopTimer
{
	if(self.timer!=nil)
	{
		[self.timer invalidate];
		self.timer=nil;
	}
}

-(void)throwErrorWithStr:(NSString *)str
{
	NSLog(@"PSocket throwErrorWithStr:%@", str);
    [self stopTimer];
	MLOG(@"%@", str);
}

-(void)throwLoseConnectionError:(NSString *)str
{
	NSLog(@"PSocket throwLoseConnectionError");
	//MLOG(@"throwLoseConnectionError 掉线");
	[Global InitConnectState:NO];
	[self stopTimer];
	[self close_Socket];
    //	if(delegate!=nil&&[delegate respondsToSelector:@selector(requiredReLogin)])
    //	{
    //		[delegate requiredReLogin];
    //	} 
	
	// 当前状态没有登录的情况，进行登录并执行操作
	/*
	id<ReConnectDelegate> rcObject = [Global getReconnectObject];
	if (rcObject) {
		[rcObject reConnectAndExecute:YES];
	}
	*/
	if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
	
	// 在这里设置重连
	CommonReconnectObject *cro = [CommonReconnectObject shareCommonReconnectObject];
	
	RootViewController *log = [RootViewController sharedView];
	log.delegate = cro;
	[log reConnect:@""];
	
	MLOG(str);
}

#pragma mark <send Packet>
-(int)sendPacket
{
	AS_APP_PACK_WITH_TYPE my_app_type;
	memcpy(&my_app_type, [self.logic_data bytes], [self.logic_data length]);
	//send data to socket
	unsigned int wOpCode=my_app_type.wOpCode;
	unsigned int dwLen=my_app_type.dwDataSize;	
	char *pBuf=(char*)my_app_type.App.Buf;
	
	return [self sendPackWithCodeAnsyc:wOpCode Content:[NSData dataWithBytes:pBuf length:dwLen] contentLen:dwLen];
}

-(int)sendPackWithCode:(unsigned int)wOpCode Content:(NSData *)data contentLen:(unsigned int)dwLen
{
	int totalByteSend = 0;
	if(self.output==nil)
        return totalByteSend;
	//self.temp_data=[NSMutableData data];//初始化缓存数据
	isWaitBody=FALSE;
	
	char *pBuf=(char *)[data bytes];
	
	AS_PACKINFO AsPack;
	memset(&AsPack,0,sizeof(AsPack));
	
	//添加起始标志
	AsPack.MsgHdr.wAsynFlag=0x5d5d;
	//操作码
	AsPack.MsgHdr.wOpCode = wOpCode;//6666;//
	//控制信息,包括客户端版本号,数据包是否压缩等
	AsPack.MsgHdr.wVersion=0x00;
	//无业务分包
	AsPack.MsgHdr.btOpSplitType = 0; 
	
	//有无分包标志
	//AsPack.MsgHdr.wDivFlag = (unsigned short)((dwLen+(AS_APP_BUF_SIZE-1))/AS_APP_BUF_SIZE);
    AsPack.MsgHdr.wDivFlag = (unsigned short)(dwLen/AS_APP_BUF_SIZE + 1);
	//压缩数据包原始大小,包括每一次发送的消息头
	AsPack.MsgHdr.dwDataSize=0;//dwLen + (sizeof(AsPack.MsgHdr) * AsPack.MsgHdr.wDivFlag);
	
	
	unsigned int dwIndex=0;
	unsigned int dwDivPackSize=0;//单个分包大小
	do 
	{
		if(m_bStopTrans == TRUE)
		{
			int len = [self SendStopPack];
			totalByteSend += len;
			[Global flowCount:totalByteSend];
			return totalByteSend;
		}
		
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
		
		memset(AsPack.App.Buf,0,AS_APP_BUF_SIZE);
		
		//此次数据包大小
		AsPack.MsgHdr.wMsgSize = dwDivPackSize + sizeof(AsPack.MsgHdr);
		
		//拷贝业务层数据
		memcpy(&AsPack.App.Buf, pBuf+dwIndex,dwDivPackSize);
		
		int len=[self.output write:(const uint8_t *)&AsPack maxLength:AsPack.MsgHdr.wMsgSize];
		DLOG(@"%d bytes sended!",len);
		
		
		if(len==-1)
		{
//			MLOG(@"服务器已断开");
//			[self stopTimer];
			[Global flowCount:totalByteSend];
			
//			if([self.delegate respondsToSelector:@selector(requiredReLogin)])
//				[self.delegate requiredReLogin];
			
			id<ReConnectDelegate> rcObject = [Global getReconnectObject];
			if (rcObject) {
				[rcObject reConnectAndExecute:YES];
			}
						
			return totalByteSend;
		}
		totalByteSend += len;
		//分包标志,每一次都减一
		AsPack.MsgHdr.wDivFlag--;
		
	} 
	while((AsPack.MsgHdr.wDivFlag > 0));// && uCurPackNum < uTotalPackNum);// && (AsPack.MsgHdr.btOpSplitType == 1));
	if(totalByteSend>0)
	{
		[Global flowCount:totalByteSend];
	}
	return totalByteSend;
}

- (BOOL)sendAPack
{
    if (!g_sendData.isValid())
        return NO;
    
    g_sendData.dwIndex += g_sendData.dwDivPackSize;
    g_sendData.dwDivPackSize = ([g_sendData.data length] - g_sendData.dwIndex);
    if(g_sendData.dwDivPackSize > AS_APP_BUF_SIZE)
    {
        g_sendData.dwDivPackSize = AS_APP_BUF_SIZE;
    }
    
    memset(g_sendData.AsPack.App.Buf, 0, AS_APP_BUF_SIZE);
    
    //此次数据包大小
    g_sendData.AsPack.MsgHdr.wMsgSize = g_sendData.dwDivPackSize + sizeof(g_sendData.AsPack.MsgHdr);
    
    //拷贝业务层数据
    char *pBuf = (char *)[g_sendData.data bytes];
    memcpy(&g_sendData.AsPack.App.Buf, pBuf + g_sendData.dwIndex, g_sendData.dwDivPackSize);
    
	// 先循环尝试10次
	int iTryTime = 0;
	int len = -1;
	while (-1 == (len = [self.output write:(const uint8_t *)&g_sendData.AsPack maxLength:g_sendData.AsPack.MsgHdr.wMsgSize])) {
		NSError *err = [self.output streamError];
		NSLog(@"%@ ...", [err localizedDescription]);
		
		
		iTryTime ++;
		
		DLOG(@"sendAPack try %d times!", iTryTime + 1);
		
		if (iTryTime == 10) {
			break;
		}
		
		sleep(0.1);
	}
	// 如果尝试的次数达到或超过了10次，则提示当前操作不成功
	if (iTryTime >= 10) {
		[Global flowCount:g_sendData.totalByteSend];
        //DLOG(@"total: %d bytes sended!", g_sendData.totalByteSend);
		id<ReConnectDelegate> rcObject = [Global getReconnectObject];
		if (rcObject) {
			[rcObject reConnectAndExecute:YES];
		}
        return NO;
	}
		
    
    g_sendData.totalByteSend += len;
    //分包标志,每一次都减一
    g_sendData.AsPack.MsgHdr.wDivFlag--;
    
    return YES;
}

- (int)sendPackWithCodeAnsyc:(unsigned int)wOpCode Content:(NSData *)data contentLen:(unsigned int)dwLen
{
	if(self.output==nil)
        return 0;

    g_sendData.reset();
	memset(&g_sendData.AsPack,0,sizeof(g_sendData.AsPack));
	
	//添加起始标志
	g_sendData.AsPack.MsgHdr.wAsynFlag=0x5d5d;
	//操作码
	g_sendData.AsPack.MsgHdr.wOpCode = wOpCode;//6666;//
	//控制信息,包括客户端版本号,数据包是否压缩等
	g_sendData.AsPack.MsgHdr.wVersion=0x00;
	//无业务分包
	g_sendData.AsPack.MsgHdr.btOpSplitType = 0; 
	
	//有无分包标志
	g_sendData.AsPack.MsgHdr.wDivFlag = (unsigned short)((dwLen+(AS_APP_BUF_SIZE-1))/AS_APP_BUF_SIZE);
	//压缩数据包原始大小,包括每一次发送的消息头
	g_sendData.AsPack.MsgHdr.dwDataSize=0;//dwLen + (sizeof(AsPack.MsgHdr) * AsPack.MsgHdr.wDivFlag);
    
    g_sendData.data = data;
    [g_sendData.data retain];
    
    //直接发生第一包
    if (![self sendAPack])
    {
        MLOG(@"发送数据包失败");
        g_sendData.reset();
        return 0;
    }

    if (g_sendData.AsPack.MsgHdr.wDivFlag == 0)
    {
        //只有一包,发生完成
        [Global flowCount:g_sendData.totalByteSend];
        g_sendData.reset();
    }
    
    return dwLen;
}

// 发送停止传输（接收、发送）数据包
-(int)SendStopPack
{
	AS_PACKINFO_HEADER StopPack;
	memset(&StopPack, 0,sizeof(StopPack));
	
	StopPack.wAsynFlag = 0x5d5d;
	StopPack.wOpCode = 100;
	StopPack.wMsgSize = sizeof(StopPack);
	
	int len=[self.output write:(const uint8_t *)&StopPack maxLength:StopPack.wMsgSize];
	MLOG(@"stop %d bytes sended!",len);
	return len;
}

-(void)handleSrvMessageWithData:(NSMutableData *)data
{
	MLOG(@"不能调用接口里面的方法！");
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

-(int)handleInputStreamEvent:(NSStreamEvent)eventCode
{
	static AS_PACKINFO_HEADER appHdr;
//	static AS_APP_PACK appBody;
	
	int totalByteRec = 0;
	switch(eventCode) 
	{
		case NSStreamEventHasBytesAvailable:
		{
			NSLog(@"PSocket.mm handleInputStreamEvent, NSStreamEventHasBytesAvailable");
			NSMutableData *data=[NSMutableData data];
			[self readBytes:self.input resData:data];
            
            if(sizeof(appHdr) > [data length]) {
                return [data length];
			}
            
            NSInteger nDataLength = [data length];
            totalByteRec += nDataLength;
            NSInteger nBytesLeft = nDataLength;
            do
            {
                //读取包头
                memset(&appHdr, 0, sizeof(appHdr));
                memcpy(&appHdr, (uint8_t*)[data bytes] + (nDataLength - nBytesLeft), sizeof(appHdr));
                
                if (nBytesLeft >= appHdr.wMsgSize)
                {
                    //无业务分包
                    if (appHdr.btOpSplitType == 0)
                    {
                        NSData *tmpData = [data subdataWithRange:NSMakeRange(nDataLength - nBytesLeft, appHdr.wMsgSize)];
                        NSMutableData* oneData = [NSMutableData dataWithData:tmpData];
                        
                        //PSocket *pSocket = [self getProperMBMsg:appHdr.wOpCode];
                        //[pSocket handleSrvMessageWithData:oneData];
                        [self handleSrvMessageWithData:oneData];
                        nBytesLeft -= appHdr.wMsgSize;
                    }
                }
                else
                {
                    MLOG(@"等待分包");
                }
            }
            while(nBytesLeft > 0);
            
            //			NSMutableData *data=[NSMutableData data];
            //			[self readBytes:self.input resData:data];
            //			[self.temp_data appendData:data];
            //			MLOG(@"%d bytes recived!",[data length]);
            //			totalByteRec += [data length];
            //			if(!isWaitBody)
            //			{
            //				if([self.temp_data length]>=sizeof(appHdr))
            //				{
            //					memset(&appHdr, 0, sizeof(appHdr));
            //					memcpy(&appHdr, [self.temp_data bytes], sizeof(appHdr));
            //					if([self.temp_data length]==appHdr.wMsgSize)
            //                    {
            //						[self handleSrvMessageWithData:self.temp_data];/////////
            //						//self.temp_data=[NSMutableData data];
            //					}
            //                    else
            //                    {
            //						if([self.temp_data length]>sizeof(appHdr))
            //						{
            //							NSData *d=[self.temp_data subdataWithRange:NSMakeRange(sizeof(appHdr), [self.temp_data length])];
            //							self.temp_data=[NSMutableData dataWithData:d];
            //						}else
            //						{
            //							self.temp_data=[NSMutableData data];
            //						}
            //						isWaitBody=TRUE;
            //						break;
            //					}					
            //				}
            //			}
            //            else
            //			{
            //				if([self.temp_data length]>=appHdr.wMsgSize-sizeof(appHdr))
            //                {
            //					memset(&appBody, 0, sizeof(appBody));
            //					memcpy(&appBody, [self.temp_data bytes], appHdr.wMsgSize-sizeof(appHdr));
            //					
            //					AS_PACKINFO temp;
            //					memcpy(&temp.MsgHdr, &appHdr, sizeof(appHdr));
            //					memcpy(temp.App.Buf, appBody.Buf, appHdr.wMsgSize-sizeof(appHdr));//拷贝业务数据
            //					
            //					NSMutableData *d=[NSMutableData dataWithBytes:&temp length:appHdr.wMsgSize];
            //					[self handleSrvMessageWithData:d];//////////////
            //					//self.temp_data=[NSMutableData data];
            //					isWaitBody=FALSE;
            //				}
            //			}
            break;		
        }
		case NSStreamEventEndEncountered:
		{
			NSLog(@"PSocket.mm handleInputStreamEvent, NSStreamEventEndEncountered");
			[self close_Socket];
			break;
		}
		case NSStreamEventErrorOccurred:
        {
			NSLog(@"PSocket.mm handleInputStreamEvent, NSStreamEventErrorOccurred");
			[Global InitConnectState:NO];
			
            NSError *theError = [self.input streamError];
            [self throwLoseConnectionError:[theError localizedDescription]];
			MLOG(@"################################ - 失去链接:%@ - ###################",[theError localizedDescription]);
            break;
        }
    }
	if(totalByteRec>0)
	{
		[Global flowCount:totalByteRec];
	}
	return totalByteRec;
}

-(PSocket*)getProperMBMsg:(unsigned int)wOpCode
{
    switch (wOpCode) 
    {
        case OPN_MB_GET_ITEM_INFO_ACK:
        case OPN_MB_GET_ITEM_NEW_ACK:
            return [MBItemInfoMsg shareMsg];
            break;
        case OPN_MB_GET_NOTE_LIST_EX_ACK:
            return [MBNoteListMsg shareMsg];
            break;
        case OPN_MB_GET_LIMIT_NOTE_LIST_EX_ACK:
            return [MBNewNoteListMsg shareMsg];
            break;
        case OPN_MB_GET_NOTE_THUMB_ACK:
            return [MBNoteThumbMsg shareMsg];
            break;
        case OPN_MB_SEARCH_NOTE_EX_ACK:
            return [MBSearchNoteMsg shareMsg];
            break;
        case OPN_MB_GET_ITEM_LIST_ACK:
            return [MBA2BListMsg shareMsg];
            break;
        case OPN_MB_GET_SHARE_TO_CATA_LIST_ACK:
            return [MBShareByCataList shareMsg];
            break;
        case OPN_MB_GET_ALL_DIR_LIST_ACK:
            return [MBCateListMsg shareMsg];
            break;   
        case OPN_MB_GET_DEFAULT_CATA_LIST_ACK:
            return [MBGetDefCataListMsg shareMsg];
            break;
        case OPN_MB_GET_SUB_DIR_LIST_ACK:
            return [MBSubDirListMsg shareMsg];
            break;
        case OPN_MB_UPLOAD_NOTE_ACK:
            return [MBUpLoadNoteMsg shareMsg];
            break;
        case OPN_MB_UPLOAD_NOTEXITEM_REQ:
            return [MBUpLoadA2BInfoMsg shareMsg];
            break;
        case OPN_MB_UPLOAD_ITEM_ACK:
            return [MBUpLoadItemMsg shareMsg];
            break;
        default:
            {
                return self;
            }
            break;
    }
}

-(void)handleOutputStreamEvent:(NSStreamEvent)eventCode
{
//	MLOG(@"eventcode = %d\n",eventCode);
	switch (eventCode) 
	{
        case NSStreamEventHasSpaceAvailable:
        {
            if (g_sendData.isValid() && g_sendData.AsPack.MsgHdr.wDivFlag != 0)
            {
                //发送一包
                if (![self sendAPack])
                {
                    MLOG(@"发送数据包失败");
                    g_sendData.reset();
                    return;
                }
                
                if (g_sendData.AsPack.MsgHdr.wDivFlag == 0)
                {
                    //发送完成
                    DLOG(@"total: %d bytes sended!", g_sendData.totalByteSend);
                    [Global flowCount:g_sendData.totalByteSend];
                    g_sendData.reset();
                }
            }
            break;
        }
		case NSStreamEventEndEncountered:
		{
            MLOG(@"eventcode = %d, socket closed!", eventCode);
			[self close_Socket];
			break;
		}
		case NSStreamEventErrorOccurred:
        {
			[Global InitConnectState:NO];
            //NSError *theError = [self.output streamError];
            [self throwLoseConnectionError:@"无法执行操作！"];//[theError localizedDescription]];
            break;
        }
	}
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
	if (stream == self.input) 
	{
        [self handleInputStreamEvent:eventCode];
		
    }
    else if (stream == self.output) 
	{
        [self handleOutputStreamEvent:eventCode];
    }	
}

-(void)close_Socket
{
	//MLOG(@"close_Socket");
	if(self.input != nil)
	{
		[self.input setDelegate:nil];
		[self.input close];
		//[self.input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.input=nil;
		[self.output setDelegate:nil];
		[self.output close];
		//[self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.output=nil;
	}
}

//B类通信所须的下载和解压函数
-(NSData *)downloadAndUnzipData:(CMBRspURL *)MBRspURL
{
	if(0!=*(MBRspURL->m_pwszURL))
	{
		NSString *str=[NSString stringWithFormat:@"%S",MBRspURL->m_pwszURL];
		NSURL *url=[NSURL URLWithString:str];
		NSData *d=[NSData dataWithContentsOfURL:url]; 
		MLOG(@"%d bytes received",[d length]);
		[Global flowCount:[d length]];
		
		if(d!=nil)
		{
			//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
			//NSString *saveDir=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp_download"];
            NSString *saveDir = [CommonFunc getTempDownDir];
			NSString *savePath=[saveDir stringByAppendingPathComponent:@"d.zip"];
			NSString *unCompressDir=[saveDir stringByAppendingPathComponent:@"Decompressed"];
			NSFileManager *fileMamager=[NSFileManager defaultManager];
			
			//检测目录是否被创建
			if(![fileMamager fileExistsAtPath:saveDir])
			{
				[fileMamager createDirectoryAtPath:saveDir attributes:nil];
			}
			if(![fileMamager fileExistsAtPath:unCompressDir])
			{
				[fileMamager createDirectoryAtPath:unCompressDir attributes:nil];
			}
			//移除上次写入的文件
			if([fileMamager fileExistsAtPath:savePath])
			{
				[fileMamager removeItemAtPath:savePath error:nil];
			}
			//移除上次解压的文件
			NSArray *files= [fileMamager directoryContentsAtPath:unCompressDir];
			if([files count]>0)
			{
				for(NSString *path in files)
				{
					NSString *dataFile=[unCompressDir stringByAppendingPathComponent:path];
					[fileMamager removeItemAtPath:dataFile error:nil];
				}
			}
			
			//写入数据文件
			[d writeToFile:savePath atomically:NO];
			//解压数据文件
			BOOL ret=FALSE;
			ZipArchive *zip=[[ZipArchive alloc] init];
			if([zip UnzipOpenFile:savePath])
			{
				ret = [zip UnzipFileTo:unCompressDir overWrite:YES];
				[zip UnzipCloseFile];
			}
			[zip release];
			//读取解压后的数据
			if(ret)
			{
				files= [fileMamager directoryContentsAtPath:unCompressDir];
				if([files count]>0)
				{
					NSString *dataFile=[unCompressDir stringByAppendingPathComponent:[files objectAtIndex:0]];
					NSData *z_data=[NSData dataWithContentsOfFile:dataFile];
					return z_data;
				}
			}
		}//data!=nil
	}//url!=nil
	return nil;
}

//异步下载zip文件
-(void)handleZipFileFromSrv:(NSData *)data
{
    MLOG(@"PSocket handleZipFileFromSrv");
}

- (void)downloadAndUnzipDataAnsyc:(CMBRspURL *)MBRspURL
{
    if(0 != *(MBRspURL->m_pwszURL))
	{
		NSString *str=[NSString stringWithFormat:@"%S",MBRspURL->m_pwszURL];
		NSURL *url=[NSURL URLWithString:str];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        if (zipFileConnect != nil)
        {
            [zipFileConnect release];
        }
        zipFileConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    else
    {
        MLOG(@"URL 未空.");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [zipFileConnect release];
    zipFileConnect = nil;
    
    [tempZipFileData release];
    tempZipFileData = nil;
    
    MLOG(@"下载zip文件失败, error=%@", error);
    
    
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData 
{
    if (tempZipFileData == nil) 
    {
        tempZipFileData = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [tempZipFileData appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
    if (zipFileConnect != nil)
    {
        [zipFileConnect release];
        zipFileConnect = nil;
    }
    
    MLOG(@"%d bytes received",[tempZipFileData length]);
    [Global flowCount:[tempZipFileData length]];
    
    if(tempZipFileData != nil)
    {
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        //NSString *saveDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp_download"];
        NSString *saveDir = [CommonFunc getTempDownDir];
        NSString *savePath=[saveDir stringByAppendingPathComponent:@"d.zip"];
        NSString *unCompressDir=[saveDir stringByAppendingPathComponent:@"Decompressed"];
        NSFileManager *fileMamager=[NSFileManager defaultManager];
        
        //检测目录是否被创建
        if(![fileMamager fileExistsAtPath:saveDir])
        {
            [fileMamager createDirectoryAtPath:saveDir attributes:nil];
        }
        if(![fileMamager fileExistsAtPath:unCompressDir])
        {
            [fileMamager createDirectoryAtPath:unCompressDir attributes:nil];
        }
        //移除上次写入的文件
        if([fileMamager fileExistsAtPath:savePath])
        {
            [fileMamager removeItemAtPath:savePath error:nil];
        }
        //移除上次解压的文件
        NSArray *files= [fileMamager directoryContentsAtPath:unCompressDir];
        if([files count]>0)
        {
            for(NSString *path in files)
            {
                NSString *dataFile=[unCompressDir stringByAppendingPathComponent:path];
                [fileMamager removeItemAtPath:dataFile error:nil];
            }
        }
        
        //写入数据文件
        [tempZipFileData writeToFile:savePath atomically:NO];
        [tempZipFileData release];
        tempZipFileData = nil;
        
        //解压数据文件
        BOOL ret=FALSE;
        ZipArchive *zip=[[ZipArchive alloc] init];
        if([zip UnzipOpenFile:savePath])
        {
            ret = [zip UnzipFileTo:unCompressDir overWrite:YES];
            [zip UnzipCloseFile];
        }
        [zip release];
        //读取解压后的数据
        if(ret)
        {
            files= [fileMamager directoryContentsAtPath:unCompressDir];
            if([files count]>0)
            {
                NSString *dataFile=[unCompressDir stringByAppendingPathComponent:[files objectAtIndex:0]];
                NSData *z_data = [NSData dataWithContentsOfFile:dataFile];
                [self handleZipFileFromSrv:z_data];
            }
        }
    }//data!=nil    
}

-(void)dealloc
{
	[logic_data release];
	//[temp_data release];
	[timer release];
	
	[input setDelegate:nil];[input release]; 
	[output setDelegate:nil];[output release];
	[super dealloc];
}

@end
