//
//  UIDevice+Addition.m
//  TQAP_Common_Basic
//
//  Created by chenyan on 12-3-15.
//  Copyright (c) 2012年 TQND. All rights reserved.
//

#import "UIDevice+TAAddition.h"
#import "PubFunction.h"
#import "NSString+TABase64.h"

#import <mach/mach.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@interface UIDeviceTAAddition : NSObject {
	NSString *uuid4Device;
}
+ (NSString *)identifier4Device;
@property (nonatomic, retain) NSString *uuid4Device;
@end

#define TAC_UUID_INNSUSERDEFAULT_KEY	@"uuid_created_by_TQAP"


@implementation UIDeviceTAAddition
@synthesize uuid4Device;

static UIDeviceTAAddition* g_UIDeviceTAAddition = nil;

- (id)init {
	if (self = [super init]) {
		uuid4Device = NULL;
	}
	return self;
}

+ (UIDeviceTAAddition*)getInstance {

	if( nil == g_UIDeviceTAAddition ) {
		g_UIDeviceTAAddition = [[UIDeviceTAAddition alloc] init];
	}
	return g_UIDeviceTAAddition;
}

+ (NSString *)identifier4Device {
	
	NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
	[UIDeviceTAAddition getInstance].uuid4Device = [NSString stringWithFormat:@"%@", [handler objectForKey:TAC_UUID_INNSUSERDEFAULT_KEY]];
	
	if (NULL == [UIDeviceTAAddition getInstance].uuid4Device 
        || 46 > [[UIDeviceTAAddition getInstance].uuid4Device length]) {
		
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
		
		NSString *result = [NSString stringWithFormat:@"%@", uuidStr];
		
		CFRelease(uuidStr);
		CFRelease(uuid);
		
		[UIDeviceTAAddition getInstance].uuid4Device = result;
		
		[handler setObject:[UIDeviceTAAddition getInstance].uuid4Device
                    forKey:TAC_UUID_INNSUSERDEFAULT_KEY];
		[handler synchronize];
	}
	
	return [UIDeviceTAAddition getInstance].uuid4Device;
}

@end



#define kUDIDNoSuperLen			10

// deviceID 的前缀
#define KNDWIFIID               @"01"	//ND WIFI标识
#define KNDCFUUID               @"02"	//ND cfuuid标识


typedef enum{
	enumDeviceId_UDID	 = 0,		//udid标识
	enumDeviceId_WifiAddr = 1,		//wifi addr标识
	enumDeviceId_CFUUID   = 2,		//CFUUID标识
}DeviceIdType;


@implementation UIDevice(TAAddition)

/*ios udid--iPhone 3GS/iPhone 4x/iPod touch3/4 iPad1/2*/
+ (NSString *)getIOS4xOr3xUDID
{
	//return [UIDevice currentDevice].uniqueIdentifier; 
    //complie warning:'uniqueIdentifier' is deprecated,, if proj is set to deploy on iOS5.0
    /*
     网易科技讯 3月26日消息，据国外网站报道，作为更加严格地保护用户隐私的一部分，
     苹果已经开始对试图访问用户设备唯一标识符（UDID）的应用程序进行下架处理。
     
     TechCrunch周六的报道称，为了禁止开发者访问用户设备的UDID，苹果正开始悄然拒绝侵犯用户隐私的应用程序的上架请求，
     这么做是为了从根本上杜绝开发者对用户UDID的访问。有消息称，苹果有两个专门小组负责审查各程序访问UDID的情况。
     */
    return @"";
}

/*
 获取网卡地址
 */
+ (NSString *) macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    mib[5] = if_nametoindex("en0");
    if (mib[5] == 0) {
        //printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        //printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    buf = (char*)malloc(len);
    
    if (buf == NULL) {
        //printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        //printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

/*
 获取wifi地址（其实就是网卡地址）
 */
+ (NSString *)getWifiAddr{
	return [UIDevice macAddress];
}

//获取加密后真实加密数据
+(NSString *)getTQStringEncodeString:(NSString *)encodeTQData TQHeadID:(NSString *)strTQId{
    
	NSRange range = [encodeTQData rangeOfString:strTQId];
	if (!((range.location == NSNotFound) || (range.length != [strTQId length])))
	{
		return [encodeTQData substringFromIndex:range.length];
	}
	return  nil;
}

/*
 获取设备ID类型对应的前缀字符串
 */
+ (NSString *)prefixOfDeviceIdType:(DeviceIdType)type
{
	switch (type) {
		case enumDeviceId_UDID:
			return nil;
			break;
		case enumDeviceId_WifiAddr:
			return KNDWIFIID;
			break;
		case enumDeviceId_CFUUID:
			return KNDCFUUID;
			break;
		default:
			break;
	}
	return nil;//default
}

/*
 计算Base64编码过的设备id所对应的设备ID类型
 */
+ (DeviceIdType)getTypeOfUniqueDeviceIdBase64Encode:(NSString *)encodeTQData
{
	NSRange range = [encodeTQData rangeOfString:KNDWIFIID];
	if (((range.location != NSNotFound) && (range.length == 2))) {
		return enumDeviceId_WifiAddr;
	}
	else {
		range = [encodeTQData rangeOfString:KNDCFUUID];
		if (((range.location != NSNotFound) && (range.length == 2))) {
			return enumDeviceId_CFUUID;
		}
	}
	return  enumDeviceId_UDID;
}


//把字符串组装成带唯一标识标识字符串
+ (NSString *)getTQStringData:(NSString *)strData 
                         type:(DeviceIdType)type
{
	return (NULL != strData) ? ([[UIDevice prefixOfDeviceIdType:type] stringByAppendingString:strData]) : nil;
}

/*
 获取ios设备的经过BASE64编码的唯一ID（主要以wifi地址为依据）
 */
+ (NSString *)getIOSIdentifiesAtEncodeBase64{
	DeviceIdType type = enumDeviceId_WifiAddr;
	NSString *strOrigID = [UIDevice getWifiAddr];
	if (YES == [PubFunction stringIsNullOrEmpty:strOrigID]) {
		strOrigID = [UIDeviceTAAddition identifier4Device];
		type = enumDeviceId_CFUUID;
	}
    
	NSString *strEncodeID = [strOrigID encodeBase64];
	//NSLOG(@"EncodeID:%@",strEncodeID);
	NSString *strEncodeIDWithType = NULL;
    strEncodeIDWithType = [UIDevice getTQStringData:strEncodeID 
                                               type:type];
	//NSLOG(@"EncodeIDWithType:%@",strEncodeIDWithType);
	return strEncodeIDWithType;
}

/*
 把经过Base64编码的设备唯一id解密成原始的设备唯一id
 */
+ (NSString *)base64DecodeUniqueDevicdID:(NSString *)uniqueIDWithBase64Encode
{	
	NSString *strTQId = nil;
	DeviceIdType type = [UIDevice getTypeOfUniqueDeviceIdBase64Encode:uniqueIDWithBase64Encode];
	switch (type) {
		case enumDeviceId_UDID:
			break;
		case enumDeviceId_WifiAddr:
			strTQId = KNDWIFIID;
			break;
		case enumDeviceId_CFUUID:
			strTQId = KNDCFUUID;
			break;
		default:
			break;
	}
	if (strTQId != nil) {
		NSString *encodeData = [UIDevice getTQStringEncodeString:uniqueIDWithBase64Encode 
                                                    TQHeadID:strTQId];
		NSString *strDecodeData = [encodeData decodeBase64];
		//MLOG(@"DecodeData:%@",strDecodeData);
		return strDecodeData;
	}
	return uniqueIDWithBase64Encode;
}

/*
 获取设备的经过BASE64编码的全球唯一ID（算法来自博远无线, 兼容iOS4-iOS5, iPhone3,3GS,4,4S）
 */
+ (NSString*) uniqueDeviceIdWithBase64Encode{
    NSString *strUDID = [UIDevice getIOS4xOr3xUDID];    //利用早期SDK提供的对设备唯一ID的获取

	/*iPhone 4s以上设备无法获取UDID,5.0版本返回udid为5.0,长度少于kUDIDNoSuperLen,表示错误ID*/
	if(NULL == strUDID  || YES == [strUDID hasPrefix:@"5.0"] || [strUDID length] < kUDIDNoSuperLen){
        
        //base64编码过的WifiID
		NSString *strEncodeBase64WifiID = [UIDevice getIOSIdentifiesAtEncodeBase64];
        
		if (NULL == strEncodeBase64WifiID){ 
            // default cfuuid
		
			NSString *strEncodeBase64CFUUID = [self getTQStringData:[[UIDeviceTAAddition identifier4Device] encodeBase64] 
                                                               type:enumDeviceId_CFUUID];
			return strEncodeBase64CFUUID;
		}
		return strEncodeBase64WifiID;
	}
	return strUDID;
}

+ (NSString *) getMachineType{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

@end
