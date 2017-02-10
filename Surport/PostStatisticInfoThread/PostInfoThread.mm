/*
 *  PostInfoThread.mm
 *  NoteBook
 *
 *  Created by Huang Yan on 9/7/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#import "PostInfoThread.h"
#import "Global.h"
#import "Common.h"
//#import "Message/NetworkController.h"

@interface PostInfoThread (hide)

+ (NSString*)getSoftVersion;
+ (NSString*)getSoftChannel;
+ (NSString*)getImeiStr;
+ (NSString*)getMd5String:(NSString*)str;
+ (NSString*)getAutoLoginInfo;
+ (NSData*)getResponseDataWithUrl:(NSString *)url andData:(NSData *)paraData andTimes:(NSInteger)times andCode:(int &)code;

@end

@implementation PostInfoThread

+ (void)Post
{
	NSString* loginUrl = [self getAutoLoginInfo];
	int code = 0;
	[self getResponseDataWithUrl:loginUrl andData:nil andTimes:1 andCode:code];
	//getResponseData(loginUrl, nil, 1, code);
	MLOG(@"Return Code=%d",code);
}

+ (NSString*)getSoftVersion
{
	NSString* version = nil;	
	NSMutableString* plistPath = [NSMutableString stringWithString: [[NSBundle mainBundle] bundlePath]];
	[plistPath appendFormat:@"%s","/Info.plist"];
	NSMutableDictionary* verDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
 	if (verDict)
	{
		NSString* softVer = [verDict objectForKey:@"CFBundleVersion"];
		if (softVer && [softVer length] > 0)
		{
			version = [NSString stringWithString:softVer];
		}
		else
		{
			version = @"0";
		}
	}
	
	return version;
}

+ (NSString*)getSoftChannel
{
	NSString* channel;
#if TARGET_IPHONE_SIMULATOR	
	NSMutableString* filePath = [NSMutableString stringWithString:@"/Users/Shared/"];// [[NSBundle mainBundle] bundlePath]];
#else
	NSMutableString* filePath = [NSMutableString stringWithString:@"/Applications/91Note.app/"];
#endif
	[filePath appendFormat:@"%s","Channel.txt"];
	//MLOG(@"Channel_path[%@]",filePath);
	NSString* encChnal = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:0];
	if (encChnal && [encChnal length] > 0)
	{
		channel = [NSString stringWithString:encChnal];
	}
	else 
	{
		channel = @"0";
	}
	// 不需要渠道
	//channel = @"0";
	//MLOG(@"filePath=[%@],channel=[%@] >>>[%@]>>>",filePath,channel,encChnal);
	
	return channel;
}

+ (NSString*)getImeiStr
{
	//NetworkController *ntc=[[NetworkController sharedInstance] autorelease];
	//NSString *imeistring = [ntc IMEI];
	//UIDevice *device = [UIDevice currentDevice];
	//NSString *str = device.uniqueIdentifier;
    
//#if TARGET_IPHONE_SIMULATOR
    NSString *str = [CommonFunc createGUIDStr];
//#endif
	
	return str;
}

+ (NSString*)getAutoLoginInfo
{
	NSString* ver  = [self getSoftVersion];
	NSString* chl  = [self getSoftChannel];
	NSString* imei = [self getImeiStr];
	NSString* signStr = [imei stringByAppendingString:@"!!)@)^@$"];
	NSString* md5Sign = [self getMd5String:signStr];
	NSString* heardUrl = @"http://panda.sj.91.com/Service/GetResourceData.aspx";
	NSString* endUrl = [NSString stringWithFormat:@"?mt=1&qt=601&mobilekey=%@&sign=%@&pid=%d&ver=%@&chl=%@",imei,md5Sign,product_id,ver,chl];
	
	NSString* postUrl = [NSString stringWithFormat:@"%@%@", heardUrl, endUrl];
	
	return postUrl;
}

+ (NSString*)getMd5String:(NSString*)str
{
	const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

+ (NSData*)getResponseDataWithUrl:(NSString *)url andData:(NSData *)paraData andTimes:(NSInteger)times andCode:(int &)code
{
	MLOG(@"post url [%@]", url);
	NSURL *c_url = [NSURL URLWithString:url];
	NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:c_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
	
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setValue:@"multipart/form-data" forHTTPHeaderField: @"Content-Type"];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [paraData length]];
	[postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[postRequest setHTTPBody:paraData];
	
	NSHTTPURLResponse* response = nil;
	NSData *ret_data = nil;
    code = 0;
	int index = 0;
	int indicatorCount = 0;
	while (index < times)
	{
		indicatorCount++;
		if (indicatorCount > 0)
		{
			[UIApplication sharedApplication].networkActivityIndicatorVisible = false;
		}	
		ret_data= [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = false;
		indicatorCount--;
		code = [response statusCode];
		if (code == 200)
		{
			break;		
		}		
		index ++;		
	}
	//MLOG(@"return data = %@",ret_data);
	//[ret_data writeToFile:@"/tmp/ret_data.txt" atomically:YES];
	[postRequest release];
	
	return ret_data;
}

@end





