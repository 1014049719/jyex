//
//  PSocket.h
//  pass91
//
//  Created by Zhaolin He on 09-8-31.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "91NoteAppStruct.h"
#import "MBBaseStruct.h"
#import "Global.h"

#define TIME_OUT_SECOND 5*60 //下载一条记录超时时间

struct SendDataStruct
{
    SendDataStruct()
    {
        ZeroMemory(this, sizeof(SendDataStruct));
    }
    
    ~SendDataStruct()
    {
        reset();
    }
    
    BOOL isValid()
    {
        return (data != nil);
    }
    
    void reset()
    {
        if (data != nil)
        {
            [data release];
            data = nil;
        }
        
        ZeroMemory(this, sizeof(SendDataStruct));
    }
    
    AS_PACKINFO AsPack;
    NSData*     data;
    int dwDivPackSize;
    int totalByteSend;
    int dwIndex;
};

@protocol P91PassDelegate;
@interface PSocket : NSObject 
{
	id<P91PassDelegate> delegate;
	bool m_bStopTrans;
@protected
	NSData *logic_data;
	NSInputStream *input; 
	NSOutputStream *output;
	NSTimer *timer;
    
    NSURLConnection* zipFileConnect;
    NSMutableData *tempZipFileData;
}
-(id)initWithInput:(NSInputStream *)inputs Output:(NSOutputStream *)outputs target:(id)obj;
- (void)stop;

- (int)SendStopPack;
- (void)stopTimer;
- (void)close_Socket;
- (void)throwErrorWithStr:(NSString *)str;
- (PSocket*)getProperMBMsg:(unsigned int)wOpCode;

- (NSData *)downloadAndUnzipData:(CMBRspURL *)MBRspURL;
- (void)downloadAndUnzipDataAnsyc:(CMBRspURL *)MBRspURL;
- (int)sendPacket;
- (int)sendPackWithCode:(unsigned int)wOpCode Content:(NSData *)pBuf contentLen:(unsigned int)dwLen;
- (int)sendPackWithCodeAnsyc:(unsigned int)wOpCode Content:(NSData *)data contentLen:(unsigned int)dwLen;
- (BOOL)sendAPack;

- (void)handleSrvMessageWithData:(NSMutableData *)data;
- (void)handleZipFileFromSrv:(NSData *)data;

@property(nonatomic,assign)id<P91PassDelegate> delegate;
@property(nonatomic,assign)bool m_bStopTrans;

@property(nonatomic,retain)NSData *logic_data;
@property(nonatomic,retain)NSInputStream *input;
@property(nonatomic,retain)NSOutputStream *output;
@property(nonatomic,retain)NSTimer *timer;
@end