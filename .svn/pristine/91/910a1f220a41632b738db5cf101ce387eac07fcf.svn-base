/*
 *  Responds.mm
 *  NoteBook
 *
 *  Created by Huang Yan on 9/7/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#import "Responds.h"

int indicatorCount = 0;

//void URLEncodeStr(const unsigned char *inBuf,int inBufLen,NSMutableData *outData)
//{
//	char szTmp,szTmp1;
//	
//	for (int i=0; i<inBufLen; i++)
//	{
//		if (inBuf[i] <= 0x7f)
//		{
//			if (inBuf[i] == '%')
//			{
//				[outData appendBytes:"%25" length:3];
//			}
//			else if (inBuf[i] == ' ')
//			{
//				[outData appendBytes:"%20" length:3];
//			}
//			else if (inBuf[i] == '&')
//			{
//				[outData appendBytes:"%26" length:3];
//			}
//			else
//			{
//				[outData appendBytes:&inBuf[i] length:1];
//			}
//		}
//		else
//		{
//			[outData appendBytes:"%" length:1];
//			szTmp = ((inBuf[i] & 0xf0)>>4);
//			if (szTmp <= 0x09)
//			{
//				szTmp1 = szTmp + 0x30;
//				[outData appendBytes:&szTmp1 length:1];
//			}
//			else if (szTmp >= 0x0a)
//			{
//				szTmp1 = szTmp + 0x57;
//				[outData appendBytes:&szTmp1 length:1];
//			}
//			
//			szTmp = (inBuf[i] & 0x0f);
//			if (szTmp <= 0x09)
//			{
//				szTmp1 = szTmp + 0x30;
//				[outData appendBytes:&szTmp1 length:1];
//			}
//			else if (szTmp >= 0x0a)
//			{
//				szTmp1 = szTmp + 0x57;
//				[outData appendBytes:&szTmp1 length:1];
//			}
//		}
//	}
//}
//
//void URLEncodeData(NSData *inData,NSMutableData *outData)
//{
//	const unsigned char* inBuf = (const unsigned char*)[inData bytes];
//	int inBufLen = [inData length];
//	
//	URLEncodeStr(inBuf,inBufLen,outData);
//}
//
/*NSMutableData *getpara(NSString *str)
 {
 NSMutableData* m_data = [[NSMutableData alloc]init];
 URLEncodeStr((const unsigned char *)[str cString],[str length],m_data);
 return [m_data autorelease];
 }
 */


NSData* getResponseData(NSString *url, NSData *paraData , NSInteger times, int &code)
{
	NSURL *c_url = [NSURL URLWithString:url];  
	NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:c_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
	
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setValue:@"multipart/form-data" forHTTPHeaderField: @"Content-Type"];
	
	long long g_upload_data_byte = 0;
	long long g_download_data_byte = 0;
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Media/91Show/byte.plist"];
	if (dict)
	{
		g_upload_data_byte = [(NSString*)[dict objectForKey:@"upload"] intValue];		
		g_download_data_byte = [(NSString*)[dict objectForKey:@"download"]intValue];
	}
	
	//[postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];	
	NSString *postLength = [NSString stringWithFormat:@"%d", [paraData length]];
	[postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[postRequest setHTTPBody:paraData];
	
	NSHTTPURLResponse* response = nil;
	NSData *ret_data = nil;
    code = 0;
	int index = 0;
	while (index < times)
	{
		indicatorCount++;
		if (indicatorCount > 0)
		{
			[UIApplication sharedApplication].networkActivityIndicatorVisible = true;
		}	
		ret_data= [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:nil];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = false;
		indicatorCount--;
		if (dict)
		{
			[dict removeAllObjects];
			g_upload_data_byte += [paraData length]; 
			g_download_data_byte += [ret_data length];
			[dict setObject:[NSString stringWithFormat:@"%d",g_upload_data_byte] forKey:@"upload"];
			[dict setObject:[NSString stringWithFormat:@"%d",g_download_data_byte] forKey:@"download"];
			[dict writeToFile:@"/var/mobile/Media/91Show/byte.plist"  atomically:YES];
		}
		code = [response statusCode];
		if (code == 200)
		{
			break;		
		}		
		index ++;		
	}
	
	[postRequest release];
	return ret_data;
}

bool getFileFromURL(NSString* url,NSString* filePath)
{
	int code = 0;
	NSData *fileCont = getResponseData(url, nil, 1, code);
	if (fileCont)
	{
		[fileCont writeToFile:filePath atomically:YES];
		return true;
	}
	return false;
}

//NSString* encryptStr(NSString *str)
//{
//	return str;
//}

