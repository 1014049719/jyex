//
//  CopyrightInfo.m
//  Astro
//
//  Created by root on 12-2-22.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import "CopyrightInfo.h"
#import "PubFunction.h"
#import "CommonDirectory.h"


@implementation CopyrightInfo


//文件名
+(NSString*) resourceFileName
{
    if (IS_FT)
        return @"copyright.bg5";
    else
        return @"copyright.gb";
}

+(NSString*) resourcePathOfCopyright
{
	NSString* resource = [CopyrightInfo resourceFileName];
	if ([PubFunction stringIsNullOrEmpty:resource])
	{
		return nil;
	}
	
	NSString* resoucepath = [[NSBundle mainBundle] resourcePath];
	NSString *tmplFilePath = [resoucepath stringByAppendingPathComponent:resource];
	if (![CommonFunc isFileExisted:tmplFilePath])
	{
		return nil;
	}
	
	return tmplFilePath;
}

+(NSString*) getCopyrightInfo
{
	NSString* filePath = [CopyrightInfo resourcePathOfCopyright];
	if ([PubFunction stringIsNullOrEmpty:filePath])
	{
		return @"";
	}
	
	NSString* sCtxt;
	@try
	{
		sCtxt = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
		if (sCtxt == nil)
		{
			LOG_ERROR(@"读取使用协议内容异常");
			return @"";
		}
		else
			return [sCtxt autorelease];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"读取使用协议内容失败: %@", [e reason]);
		[sCtxt release];
		return @"";
	}
	
	LOG_ERROR(@"读取使用协议内容失败");
	[sCtxt release];
	return @"";
}

@end
