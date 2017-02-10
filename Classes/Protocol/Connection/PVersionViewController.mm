/*
 *  PVersionViewController.mm
 *  NoteBook
 *
 *  Created by Huang Yan on 9/23/09.
 *  Copyright 2009 fj. All rights reserved.
 *
 */

#include "PVersionViewController.h"
#import "IntroductWebControl.h"

@interface PVersionViewController()

-(NSURLRequest *)getNewVertion;
-(NSURLRequest *)detectNewVertion;
- (void) keepNetWorkConnect:(id)net;

@end


@implementation PVersionViewController

- (id)init
{
	if ([super init])
	{
		self.title = _(@"check_update");
	}
	
	return self;
}

- (void)dealloc
{
	//[webView release];
	//webView = nil;
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	UIWebView *webView = nil;
	webView = [ [ UIWebView alloc ] initWithFrame:CGRectMake(0, 0, 320, 420) ];//[ UIScreen mainScreen ].applicationFrame ];
	webView.backgroundColor = [ UIColor whiteColor ];
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	
	//[webView loadRequest:[self detectNewVertion]];
	[webView loadRequest:[self getNewVertion]];
	
	[self.view addSubview:webView];
	[webView release];
}

- (NSData*)getResponseDataWithUrl:(NSString *)url andData:(NSData *)paraData andTimes:(NSInteger)times andCode:(int &)code
{
	//MLOG(@"post url [%@]", url);
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
	
	[ret_data writeToFile:@"/tmp/ret_data.txt" atomically:YES];
	
	[postRequest release];
	
	if (ret_data == nil)
	{
		MLOG(@"re failed !");
	}
	else
	{
		MLOG(@"re success !");
	}
	
	return ret_data;
}


//http://panda.sj.91.com/Service/GetResourceData.aspx?mt=1&qt=1502&softid=1&fwversion=3rd&version=0.5

-(NSURLRequest *)getNewVertion
{
	NSMutableDictionary              *dict = nil;
	NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
	MLOG(deviceVersion);
	NSString *systemFireVertion =  @"2.0";
	dict = [ NSMutableDictionary dictionaryWithContentsOfFile:[ NSString stringWithUTF8String:"/System/Library/CoreServices/SystemVersion.plist"] ];
	systemFireVertion = [ dict objectForKey:@"ProductVersion" ];
	
	
	NSString *postUrl = [NSString stringWithFormat:@"http://panda.sj.91.com/Service/GetResourceData.aspx?mt=1&qt=1502&softid=%d&fwversion=%@&version=%@",product_id,deviceVersion,systemFireVertion];
    
	// begin response
	/*
     int code = 0;
     [self getResponseDataWithUrl:postUrl andData:nil andTimes:1 andCode:code];
     MLOG(@"The Code=%d",code);
	 */
	// end response
	
	NSURL *urlremote = [NSURL URLWithString:postUrl];
	NSURLRequest *request = [ NSURLRequest requestWithURL:urlremote ];
	[ self keepNetWorkConnect:nil ];
	
	return request;
}

-(NSURLRequest *)detectNewVertion
{
	NSString			*systemFireVertion = @"2.0";
	NSString				  *softVersion = nil;
	NSString					   *softId = nil;
	NSString					*uiniqueid = nil;
	
	int						 timestamp_low = rand()%10000;
	int					   timestamp_hight = rand()%10000;
	
	NSMutableDictionary              *dict = nil;
	NSString					*plistPath = nil;
	
	NSString					*plainText = nil;
	char					  encodeBuffer[2048];
	int						  encodeLength = 0; 
	string							strEncode;
	
	int						            ks = rand()%10;
	int i;
	unsigned char				   key[16] = {0};
	char						keyHex[33] = {0};
	MD5Context							context;
	
	NSString					*strremote = nil;
	NSURL						*urlremote = nil;
	NSURLRequest				  *request = nil;
	
	// get iphone system version
	dict = [ NSMutableDictionary dictionaryWithContentsOfFile:[ NSString stringWithUTF8String:"/System/Library/CoreServices/SystemVersion.plist"] ];
	systemFireVertion = [ dict objectForKey:@"ProductVersion" ];
	
#if DEBUG
	systemFireVertion = @"2.0"; 
#endif
	
	// get firewall software version
	plistPath = [ [ [ NSBundle mainBundle ] bundlePath ] stringByAppendingString:@"/Info.plist" ];
	dict = [ NSMutableDictionary dictionaryWithContentsOfFile:plistPath ];
	softVersion = [ dict objectForKey:@"CFBundleVersion" ];
	
	// get firewall soft identify
	softId = [ dict objectForKey:@"CFBundleIdentifier" ];
	
	// get unique id
	uiniqueid = [ [ UIDevice currentDevice ] uniqueIdentifier ];
	
	// get the system version, unique id, identify together
	plainText = [ NSString stringWithFormat:@"src=%@&srcver=%@&phone=iphone&psys=&psysver=%@&uniqueid=%@&resolution=320x480&timestamp=%d%d", softId
				 , softVersion
				 , systemFireVertion
				 , uiniqueid 
				 , timestamp_low 
				 , timestamp_hight
				 ];
	
	memset(encodeBuffer, 0, sizeof(encodeBuffer));
	Base64XX::encode((unsigned char*) encodeBuffer, &encodeLength, [ plainText UTF8String ], [ plainText length]);
	
	strEncode = ((char*)encodeBuffer);
	
	if ( strEncode.size() > 2 )
	{
		strEncode = strEncode.substr(strEncode.size()/2) + strEncode.substr(0, strEncode.size()/2);
	}
	
	replace(strEncode.begin(), strEncode.end(), '+', '!');
	replace(strEncode.begin(), strEncode.end(), '/', '@');
	replace(strEncode.begin(), strEncode.end(), '=', '$');
	
	memset(encodeBuffer, 0, sizeof(encodeBuffer));
	strcpy(encodeBuffer, pKey[ks]);
	strcpy(encodeBuffer+8, strEncode.c_str());
	
	// encode 
	MD5Init(&context);
	MD5Update(&context, (unsigned char*) encodeBuffer, strlen(encodeBuffer));
	MD5Final((unsigned char*)key, &context);
	
	for ( i = 0; i < 16; ++i)
	{
		sprintf(keyHex + 2*i, "%02x", key[i]);
	}
	
	// fit it together 
	strremote = [ NSString stringWithFormat:@"http://sw.sj.91.com/?net=installer&app=misc&controller=iphone&action=checkupdate&identifier=%@&version=%@&i=%s&ks=%d&k=%s",
				 softId, softVersion, encodeBuffer + 8, ks, keyHex ];
	
	urlremote = [ NSURL URLWithString:strremote ];
	
	request = [ NSURLRequest requestWithURL:urlremote ];
    
	[ self keepNetWorkConnect:nil ];
	
	//[ webView loadRequest:request ];
	
	return request;
}

- (void) keepNetWorkConnect:(id)net
{/*
	if ( !([[NetworkController sharedInstance] isNetworkUp]) )
	{
		if ( ![[NetworkController sharedInstance] isEdgeUp] )
		{
			[ [ NetworkController sharedInstance ] keepEdgeUp ];
			[ [ NetworkController sharedInstance ] bringUpEdge ];
		}
	}*/
}


@end
