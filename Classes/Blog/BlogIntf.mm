//
//  BlogIntf.m
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubFunction.h"
#import "SBJSON.h"
#import "NetConstDefine.h"
#import "BlogIntf.h"
#import "DBMng.h"
//#import "UIDevice+TAAddition.h"


#pragma mark -
#pragma mark SNSInfo实现
@implementation SNSInfo

@synthesize snsType, snsName, logoUrl, logoCache, isBind; 

-(id) init
{
	self = [super init];
	if (self) {
		self.snsType = 0;
		self.snsName = @"";
		self.logoUrl = @"";
		self.logoCache = @"";
		self.isBind = NO;
	}
	return self;
}

- (id) copy {
    SNSInfo* info = [[SNSInfo alloc] init];
    info.snsType = self.snsType;
    info.snsName = self.snsName;
    info.logoUrl = self.logoUrl;
    info.logoCache = self.logoCache;
    info.isBind = self.isBind;
    return info;
}

-(void) dealloc
{
	self.snsType = 0;
	self.snsName = nil;
	self.logoUrl = nil;
	self.logoCache = nil;
	self.isBind = NO;
	[super dealloc];
}

@end

NSString *const kBlogUrl = @"url";
NSString *const kBlogNickname = @"nick";
NSString *const kBlogAvatar = @"head";

#pragma mark -
#pragma mark BlogIntf实现
@implementation BlogIntf

const int kStatusCodeSuccess = 200;
const int kStatusCodeNotLogin = 409;
const int kStatusCodeInvalidParam = 410;
const int kStatusCodeRequestFailed = 411;
const int kStatusCodeNotBindOrExpired = 413;

@synthesize list, isLogin, sharesid;

- (id)init {
	self = [super init];
	if (self) {
		self.list = [[[NSMutableArray alloc]init] autorelease]; 
        isLogin = NO;
        self.sharesid = @"";
        [self GetBlogList];
	}
	return self;
}

- (void)dealloc {
	self.list = nil;
	self.sharesid = nil;
	[super dealloc];
}

+ (BlogIntf*) instance {
    static id _instance = nil;
    if (!_instance) {
        @synchronized(self) {
            if(_instance == nil) 
                _instance = [[BlogIntf alloc] init];
        }
    }
    return _instance;
}


static NSString *productInfo = @"【来自@龙易算命网】";
static NSString *downloadUrl = @"推荐下载http://sm.91.com/portal.php?mod=list&catid=2";

+ (NSString *) productInfo {
    return productInfo;
}

+ (NSString *) downloadUrl {
    return downloadUrl;
}

#pragma mark HTTP功能函数
+ (NSInteger) readGetData: (NSString*) urlstr: (NSString**)result
{	 
	NSLog(@"urlstr:%@", urlstr);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]         
											 cachePolicy:NSURLRequestUseProtocolCachePolicy  
										 timeoutInterval:20.0];
	
	NSHTTPURLResponse *response;
	NSError *error = nil;
	NSData *newData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
	
	NSString *responseString = [[[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding] autorelease];
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response; 
	NSInteger responseStatusCode = [httpResponse statusCode]; 
	
	NSLog(@"responseString :  %@", responseString);
	if ((error) || ([responseString isEqual:@""]) || (responseString==nil))	{ 
		LOG_ERROR(@"FAIL urlstr:%@!", urlstr);
        *result = @"";
        return 0;
	}
	*result = responseString;
	
	LOG_ERROR(@"SUCC urlstr:%@ responseString:%@!", urlstr, responseString);
	return responseStatusCode;
	
}

+ (NSInteger) readPostData: (NSString*) urlstr: (NSString*)sid: (NSString*) jsonRequest: (NSString**)result
{
	NSLog(@"url: %@ sid: %@ post: %@", urlstr, sid, jsonRequest);
    DCHECK([urlstr hasSuffix:CS_URL_BLOG_LOGIN] || ![sid isEqualToString:@""]);
    if (![urlstr hasSuffix:CS_URL_BLOG_LOGIN] && [sid isEqualToString:@""])
        LOG_ERROR(@"url %@ with empty sid", urlstr);

	NSURL *url = [NSURL URLWithString:urlstr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	
	//NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
	NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[[NSString stringWithString:jsonRequest] 
							 dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"*/*" forHTTPHeaderField:@"Accept"];  //Accept-Encoding: gzip, deflate
	[request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"]; 
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	if (![sid isEqual:@""])
		[request setValue:[NSString stringWithFormat:@"PHPSESSID=%@", sid] forHTTPHeaderField:@"Cookie"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	//getting the data
	NSData *newData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	//json parse
	NSString *responseString = [[[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding] autorelease];
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response; 
	NSInteger responseStatusCode = [httpResponse statusCode]; 
	
	if (error) { 
        LOG_ERROR(@"sendRequest get error: %@", error);
        *result = @"";
	} else {
        *result = responseString;
	}
    
    if (responseStatusCode != 200) {
        LOG_ERROR(@"status code: %d, msg: %@", responseStatusCode, responseString);
    }
	return responseStatusCode;
}

#pragma mark 微博相关函数
- (BOOL)SendBlog:(NSString*)text: (NSString**)msg {
	BOOL bRet = [self wrapForSendBlog:text :msg];
	
	//记录今天分享成功过状态
	if (bRet)
	{
		[self markTodayShared];
	}
	
	return bRet;
}

- (BOOL) wrapForSendBlog:(NSString*)text: (NSString**)msg
{
	if (!self.isLogin)
		if (![self Login]) 
			return NO;

	BOOL retuFlag = NO;
	*msg = @"没有关联微博帐号";
	for (SNSInfo* info in self.list) {
        if (!info.isBind) continue;
		NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_SHARETEXT];
		NSString* jsonRequest = [NSString stringWithFormat:@"{\"snstype\":%d,\"text\":\"%@\"}", info.snsType, text];
		*msg = @"";
		if (([BlogIntf readPostData:url :self.sharesid: jsonRequest :msg]) == 200)		
		{
			retuFlag = YES; 
		}
	}
	return retuFlag;	
}

- (BOOL) SendBlog:(NSString*)text: (UIImage*) image: (NSString**)msg {
	BOOL bRet = [self wrapForSendBlog:text :image :msg];
	
	//记录今天分享成功过状态
	if (bRet)
	{
		[self markTodayShared];
	}
	
	return bRet;
}

- (BOOL) wrapForSendBlog:(NSString*)text: (UIImage*) image: (NSString**)msg;
{
    // 因为对sid失效的处理比较繁琐，而且用户发生微博的动作不会很频繁，所以每次发送前先登陆
    if (![self Login]) 
    {
    //    [PubFunction showTipMessage: @"请检查网络是否正常！" withImageNamed: @"icon_checkmark_02.png" inSeconds :2];
        *msg = LOC_STR("bg_qjc");
        return NO;
    }

	BOOL rtn = NO;
    BOOL bindStatusChanged = NO;
	
    NSString* sendMsg = nil;
	for (SNSInfo* info in self.list)
    {
        if (!info.isBind) continue;
        
        NSString *imageType = @"image/jpg";
        NSString *imageName = [PubFunction newUUID];
        NSString *imageData = [PubFunction Base64Encode: UIImageJPEGRepresentation(image, 0.5)];
        
        NSMutableString *blog_text = [NSMutableString stringWithFormat: @"%@", text];
        [blog_text setString: [blog_text stringByReplacingOccurrencesOfString:@"\n\r" withString:@" "]];
        [blog_text setString: [blog_text stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
        [blog_text setString: [blog_text stringByReplacingOccurrencesOfString:@"\r" withString:@" "]];
        if ([info.snsName isEqualToString:@"腾讯微博"])  // 腾讯微博特殊处理
            [blog_text appendString: @"【来自@龙易算命】"];
        else
            [blog_text appendString: productInfo];
        
        if (blog_text.length + downloadUrl.length <= kMaxBlogLength) 
        {
            [blog_text appendString: downloadUrl];
        }
        
		NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_SHAREIMAGE];
		NSString* jsonRequest = [NSString stringWithFormat:@"{\"snstype\":%d,\"text\":\"%@\",\"imagetype\":\"%@\",\"imagename\":\"%@\",\"imagedata\":\"%@\"}", info.snsType, blog_text, imageType, imageName, imageData];
        
		*msg = @"";
        
        NSInteger status_code = [BlogIntf readPostData:url :self.sharesid: jsonRequest :msg];
		
        if (status_code == 200)	
        {
            if (sendMsg!=nil) 
                sendMsg = [sendMsg stringByAppendingFormat:@"\n%@分享成功!", info.snsName];
            else
                sendMsg = [NSString stringWithFormat:@"%@分享成功!", info.snsName];
            
			rtn = YES; 
		}
		else 
        {
            if (sendMsg!=nil) 
                sendMsg = [sendMsg stringByAppendingFormat:LOC_STR("bg_fxsb_fmt1"), info.snsName];
            else
                sendMsg = [NSString stringWithFormat:LOC_STR("bg_fxsb_fmt2"), info.snsName];
            
           // NSString *result = [NSString stringWithFormat:@"%@分享失败!", info.snsName];
            //[PubFunction showTipMessage: result withImageNamed: @"icon_checkmark_02.png" inSeconds :2];
            
            if (status_code == kStatusCodeNotLogin)
            {  
                // sid失效处理
                self.sharesid = @"";
                self.isLogin = NO;
                info.isBind = 0;
                bindStatusChanged = YES;
            }
		}
        
        sleep(2);        
	}
    
    if (sendMsg==nil)
        *msg = LOC_STR("bg_mygl");
    else
        *msg = sendMsg;
    
    
    if (bindStatusChanged)
        [self SaveBlogList];
    
	return rtn;	
}

//分享免费标识
- (void) markTodayShared
{
	//记录今天分享成功。（可换取今天的免费测算一次）
	NSString* strToday = [PubFunction getTodayStr];
	
	NSString* canConsumeOnce = [AstroDBMng getUserCfg:@"canConsumeOnce" Cond:strToday Default:@""];
	if (![canConsumeOnce isEqualToString:@"NO"])
	{
		[AstroDBMng setUserCfg:@"canConsumeOnce" Cond:strToday Val:@"YES"];
	}
}

// 从数据库获取绑定列表
- (NSArray*) GetBlogList {
	@synchronized(self.list) {
		if (self.list.count == 0) {
			// load from db
			NSString *str = [AstroDBMng getBlogContent];
			NSLog(@"%@", str);
			NSDictionary *nodes = [str JSONValue]; 		
			if (nodes != nil) {    
				[self.list removeAllObjects];
				for (NSDictionary *item in nodes) { 
					SNSInfo *obj = [[SNSInfo alloc]init];
					obj.snsType = [[item objectForKey:@"snstype"] intValue]; 
					obj.snsName = [item objectForKey:@"snsname"]; 
					obj.logoUrl = [item objectForKey:@"logourl"]; 
					obj.logoCache = [item objectForKey:@"logocache"]; 
					obj.isBind = [[item objectForKey:@"isbind"] intValue];

                    //插入之前比较是否已存在相同的SNSInfo(有出现两个腾讯的情况)
                    int jj=0;
                    for (SNSInfo *sns in self.list ) {
                        if ( obj.snsType == sns.snsType && 
                            [obj.snsName isEqualToString:sns.snsName] && 
                            [obj.logoUrl isEqualToString:sns.logoUrl] ) {  //有相同
                            jj = 1;
                            break;
                        }
                    }
                    
                    if ( jj == 0 ) //不存在
                        [[self mutableArrayValueForKeyPath:@"list"] addObject: obj];		
					[obj release];
				}
			}
		}
		return self.list;
	}
}

// 存储到本地缓存
- (BOOL) SaveBlogList {    
    NSMutableArray *nodes = [NSMutableArray array];
	@synchronized(self.list) {
		for (SNSInfo* info in self.list) {
			NSMutableDictionary *snsDict = [[[NSMutableDictionary alloc]init]autorelease];
			[snsDict setObject:[NSNumber numberWithInt:info.snsType] forKey:@"snstype"];
			[snsDict setObject:info.snsName forKey:@"snsname"];
			[snsDict setObject:info.logoUrl forKey:@"logourl"];
			[snsDict setObject:info.logoCache forKey:@"logocache"];
			[snsDict setObject:[NSNumber numberWithInt:info.isBind?1:0] forKey:@"isbind"];

			[nodes addObject:snsDict];  
		}
	}
	NSString* strBlogInfo = [nodes JSONRepresentation];
    NSLog(@"%@", strBlogInfo);
    [AstroDBMng updateBlogContent:strBlogInfo];
    
    return NO;
}

- (BOOL) ReqBlogList {
    // 因为对sid失效的处理比较繁琐，而且用户发生微博的动作不会很频繁，所以每次发送前先登陆
    if (![self Login]) 
        return NO;
    	    
	NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/bloglogo"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:pngPath]) {
		[fileManager createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil];
		NSLog(@"Creating folder");
	}
	
	NSString* url = [NSString stringWithFormat:@"%@%@?sharesid=%@", CS_URL_BLOG_BASE, CS_URL_BLOG_QUERYSUPPORTS, self.sharesid];
 
	NSString *msg = @""; 
	if (([BlogIntf readGetData:url :&msg]) == 200) {
		NSDictionary *nodes = [msg JSONValue]; 		
		if (nodes != nil) { 
			@synchronized(self.list) {
				[self.list removeAllObjects];
			}
			for (NSDictionary *item in nodes) { 
				SNSInfo *obj = [[SNSInfo alloc]init];
				obj.snsType = [[item objectForKey:@"snstype"] intValue]; 
				obj.snsName = [item objectForKey:@"snsname"]; 
				obj.logoUrl = [item objectForKey:@"logourl"]; 
				
				NSArray *parts = [obj.logoUrl componentsSeparatedByString:@"/"];
				NSString *filename = [parts objectAtIndex:[parts count]-1];
				obj.logoCache = [NSString stringWithFormat:@"Documents/bloglogo/%@", filename];
				pngPath = [NSHomeDirectory() stringByAppendingPathComponent: obj.logoCache];				
				
				UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.logoUrl]]];
				// Write image to PNG
				[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
				
				obj.isBind = ([self QueryBind:obj.snsType] != nil);

				@synchronized(self.list) {
					[[self mutableArrayValueForKeyPath:@"list"] addObject: obj];		
				}
				[obj release];
			} 
		}

        [self SaveBlogList];
        return YES;
	} 
	return NO;
}

- (BOOL) IsBinded 
{
    BOOL binded = NO;
	@synchronized(self.list) {
		for (SNSInfo *info in self.list) {
			if (info.isBind) {
				binded = YES;
				break;
			}
		}
	}
    return binded;
}

- (BOOL) Login
{
	BOOL retuFlag = NO;
	NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_LOGIN];
    NSString* code = [PubFunction getMd5Value: [NSString stringWithFormat:@"%@%@%@", 
                                                CS_BLOG_APPID, 
                                                @"1111",//[UIDevice uniqueDeviceIdWithBase64Encode],
                                                CS_BLOG_APPSECRET]];

	NSString* jsonRequest = [NSString stringWithFormat:@"{\"devnum\":\"%@\",\"appid\":\"%@\",\"code\":\"%@\"}",
                @"11111",//[UIDevice uniqueDeviceIdWithBase64Encode],
                CS_BLOG_APPID, code];
	NSString *msg = @"";
	if (([BlogIntf readPostData:url : @"": jsonRequest :&msg]) == 200)		
	{
		retuFlag = YES;             
		NSDictionary *nodes = [msg JSONValue]; 		
		if (nodes != nil)
		{ 
			self.sharesid = [nodes objectForKey:@"sharesid"]; 
			self.isLogin = YES;
		}
	}
	return retuFlag;	
}

- (BOOL) Logout
{
	BOOL retuFlag = NO;
	NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_LOGOUT];
	NSString *msg = @"";
	if (([BlogIntf readPostData:url :self.sharesid: @"" :&msg]) == 200)		
	{
		retuFlag = YES; 
		self.isLogin = NO;
	}
	return retuFlag;
}

- (NSDictionary*)QueryBind:(NSInteger)snsType {
    // 因为对sid失效的处理比较繁琐，而且用户发生微博的动作不会很频繁，所以每次发送前先登陆
    if (![self Login]) 
        return nil;

	NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_QUERYBIND];
	NSString* jsonRequest = [NSString stringWithFormat:@"{\"snstype\":%d}", 
							 snsType];
	NSString *msg = @"";
	NSInteger status_code = [BlogIntf readPostData:url :self.sharesid: jsonRequest :&msg];
    if (status_code == 200)	{
        return  [msg JSONValue]; 		
    } else if (status_code == kStatusCodeNotLogin) {
        // sid失效处理
        self.sharesid = @"";
        self.isLogin = NO;
        return nil;	
    } else if (status_code == kStatusCodeNotBindOrExpired) {
        // if query faild , change bind status.
        [self SetBind: NO forSNSType: snsType];
        return nil;	
	}
	return nil;	
}

- (BOOL) UnBind: (NSInteger)snstype
{
    // 因为对sid失效的处理比较繁琐，而且用户发生微博的动作不会很频繁，所以每次发送前先登陆
    if (![self Login]) 
        return NO;

    sleep(5);
	BOOL retuFlag = NO;
	NSString* url = [NSString stringWithFormat:@"%@%@", CS_URL_BLOG_BASE, CS_URL_BLOG_UNBIND];
	NSString* jsonRequest = [NSString stringWithFormat:@"{\"snstype\":%d}", 
							 snstype];
	NSString *msg = @"";
    NSInteger status_code = [BlogIntf readPostData:url :self.sharesid: jsonRequest :&msg];
	if (status_code == 200)	{
		retuFlag = YES; 
        [self SetBind: NO forSNSType: snstype];
    } else if (status_code == kStatusCodeNotLogin) {
        // sid失效处理
        self.sharesid = @"";
        self.isLogin = NO;
	} 

	return retuFlag;
}

- (NSString*)getBindUrl:(NSInteger)snstype
{
    // 因为对sid失效的处理比较繁琐，而且用户发生微博的动作不会很频繁，所以每次发送前先登陆
    if (![self Login]) 
        return nil;

	NSString *url = [NSString stringWithFormat:@"%@?snstype=%d&sid=%@", CS_URL_BLOG_BIND, snstype, self.sharesid];
	[[url retain]autorelease];
	return url;
}

- (void) SetBindOK: (NSInteger) snstype 
{
    [self SetBind: YES forSNSType: snstype];
}

- (void) SetBind: (BOOL) isBind forSNSType: (NSInteger) snstype
{
//CMT(maoxp): block wasn't supported in iOS 3.0    
//    NSInteger index = [self.list indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
//        SNSInfo* info = (SNSInfo *)obj;
//        if (info.snsType == snstype) {
//            *stop = YES;
//            return YES;
//        }
//        return NO;
//    }];
    
	@synchronized(self.list) {
		NSInteger index = 0;
		BOOL found = NO;
		for (SNSInfo *info in self.list) {
			if (info.snsType == snstype) {
				found = YES;
				break;
			}
			index++;
		}

		if (!found) {
			NSLog(@"set bind error, snsType not found.");
			return;
		}

		SNSInfo* snsinfo = [[[self.list objectAtIndex:index] copy] autorelease];
		snsinfo.isBind = isBind;
		[[self mutableArrayValueForKeyPath:@"list"] replaceObjectAtIndex:index withObject:snsinfo];
	}
    
    [self SaveBlogList];    
}

@end
