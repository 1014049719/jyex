//
//  BussInterImpl.mm
//  Astro
//
//  Created by root on 11-11-22.
//  Copyright 2011 ND SOFT. All rights reserved.
//

#import "BussInterImpl.h"
#import "CommonDef.h"
#import "SBJson.h"
#import "BussComdIDDef.h"
#import "NetConstDefine.h"
#import "GlobalVar.h"
#import "PubFunction.h"
#import "BussIntfWeather.h"
//#import "UIImage+WebCache.h"
//#import "UIDevice+TAAddition.h"

#import "BizLogicAll.h"
#import "CommonAll.h"

#import <mach/mach.h>
#import <CommonCrypto/CommonDigest.h>

#import "UIProgress.h"
#import "Reachability.h"
#import "Global.h"


//#define LOG_NETINFO //调试使用


///////////////////////////////
///////全局函数////////////
id pickJsonValue(NSDictionary* jObj, NSString* jsKey, id defVal)
{
	id val = [jObj objectForKey:jsKey] ;
	if (!val || [val isKindOfClass:[NSNull class]])
	{
		return defVal;
	}
	else
	{
		return val;
	}
}				 

BOOL pickJsonBOOLValue(NSDictionary* jObj, NSString* jsKey, BOOL defVal)
{
	return [(NSNumber*)pickJsonValue(jObj, jsKey, [NSNumber numberWithBool:defVal]) boolValue];
}

int pickJsonIntValue(NSDictionary* jObj, NSString* jsKey, int defVal)
{
	return [(NSNumber*)pickJsonValue(jObj, jsKey, [NSNumber numberWithInt:defVal]) intValue];
}

float pickJsonFloatValue(NSDictionary* jObj, NSString* jsKey, float defVal)
{
	return [(NSNumber*)pickJsonValue(jObj, jsKey, [NSNumber numberWithFloat:defVal]) floatValue];
}

double pickJsonDoubleValue(NSDictionary* jObj, NSString* jsKey, double defVal)
{
	return [(NSNumber*)pickJsonValue(jObj, jsKey, [NSNumber numberWithDouble:defVal]) doubleValue];
}

NSString* pickJsonStrValue(NSDictionary* jObj, NSString* jsKey, NSString* defVal)
{
	return (NSString*)pickJsonValue(jObj, jsKey, defVal);
}
///////////////////////////////



#pragma mark -
#pragma mark BussInterImplBase公有方法

@implementation BussInterImplBase 

@synthesize objASIHttpReqt;
@synthesize	delgtPackData, strURL, eHttpMethod;
@synthesize iHttpCode;
@synthesize	callbackObj, callbackFunc;
@synthesize bContinueProc, callbackObj_preProc, callbackFunc_preProc;	

+ (id) InstantiateBussInter:(NSString*)url Method:(EHttpMethod)method
{
	id buss = [[self class] new];	//可适合子类对象
	BussInterImplBase *base = (BussInterImplBase *)buss;
	base.strURL = url;
	base.eHttpMethod = method;
	
	return [buss autorelease];
}

+ (id) InstantiateBussInter:(NSString*)url Method:(EHttpMethod)method ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	id buss = [[self class] new];	//可适合子类对象
	BussInterImplBase *base = (BussInterImplBase *)buss;
	base.strURL = url;
	base.eHttpMethod = method;
	base.callbackObj = target;
	base.callbackFunc = selector;
	
	return [buss autorelease];
}

- (id) init
{
	self = [super init];
	if (self)
	{
		self.strURL = @"";	//连接地址
		self.eHttpMethod = HTTP_METHOD_POST;	 //连接方式
		self.callbackFunc = nil;
		self.callbackObj = nil;
		self.delgtPackData = nil;
		self.bContinueProc = YES;
		self.callbackObj_preProc = nil;
		self.callbackFunc_preProc = nil;	
	}
	
	return self;
}

-(void)dealloc
{
	[self destroyBussReqObj];

	self.strURL = nil;
	self.callbackFunc = nil;
	self.callbackObj = nil;
	self.delgtPackData = nil;
	self.callbackObj_preProc = nil;
	self.callbackFunc_preProc = nil;	
	
	[super dealloc];
}

- (NSString*) WrapJsonStringWithBussID:(int) bussID DictData:(NSDictionary*)innerData
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//加上业务命令ID
	[jObjRoot setObject:[NSNumber numberWithInt:bussID] forKey:@"comdcode"];
	[jObjRoot setObject:[innerData JSONRepresentation] forKey:@"paramcontent"];
	
	
	//转成字符串
    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
	
}

- (NSString*) WrapJsonStringWithBussID:(int) bussID AryData:(NSArray*)innerData
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//加上业务命令ID
	[jObjRoot setObject:[innerData JSONRepresentation] forKey:@"paramcontent"];
	
	
	//转成字符串
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

-(NSString*) WrapJsonStringWithOption:(NSString*)option DictData:(NSDictionary*)innerData
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//加上业务命令ID
	[jObjRoot setObject:option forKey:@"option"];
	[jObjRoot setObject:innerData forKey:@"param"];
	
	
	//转成字符串
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

-(NSString*) WrapJsonStringWithOption:(NSString*)option AryData:(NSArray*)innerData
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//加上业务命令ID
	[jObjRoot setObject:option forKey:@"option"];
	[jObjRoot setObject:innerData forKey:@"param"];
	
	
	//转成字符串
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

+(BOOL) prepareUnpackRecvData:(id) rcvData ToJsonObj:(id*)retJsObj HttpStatus:(int)statusCode Error:(NSError**)err
{
	//LOG_DEBUG(@"返回数据：%@", rcvData);
        
    do 
    {
        if (statusCode==0) //网络出错
        {
            *err = [NSError errorWithDomain:LOC_STR("wlqqsb") code:statusCode userInfo:nil];
            break;
        }
        
        if ([rcvData isKindOfClass:[NSError class]])
        {
            *err = rcvData;
            break;
        }
        
        if ( nil == rcvData )
        {
            NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:statusCode];
            *err = [NSError errorWithDomain:errHttp code:statusCode userInfo:nil]; 
            break;            
        }
        
        //收到的非字符串（json字符串）
        if (  ![rcvData isKindOfClass:[NSString class]])
        {
            NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:statusCode];
            *err = [NSError errorWithDomain:errHttp code:statusCode userInfo:nil]; 
            break;
        }
        NSString *sJSON = (NSString*)rcvData;
        if ( statusCode == 200 && [rcvData isKindOfClass:[NSString class]] ) {
            //NSLog(@"%@", (NSString*)rcvData );
            //剔除第一个 { 或者 ] 之前的空格或换行符
            if( (![(NSString*)rcvData hasPrefix:@"{"])  && (![(NSString*)rcvData hasPrefix:@"["])){
                NSRange r1 = [sJSON rangeOfString:@"{"];
                NSRange r2 = [sJSON rangeOfString:@"["];
                if ( r1.location == NSNotFound && r2.location == NSNotFound ) {
                    break;
                }
                else
                {
                    r1.location = ((r1.location <= r2.location) ? r1.location : r2.location);
                    sJSON = [(NSString*)rcvData substringFromIndex:r1.location];
                }
            }
        }
        
        if ( [rcvData isKindOfClass:[NSString class]] ) 
        {
            //*retJsObj = [(NSString*)rcvData JSONValue];
            *retJsObj = [(NSString*)sJSON JSONValue];
            //是空json串
            if ([PubFunction isObjNull:*retJsObj])
            {
                NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:statusCode];
                *err = [NSError errorWithDomain:errHttp code:statusCode userInfo:nil]; 
                break;
            }
        
            if ([BussInterImplBase IsErrMsgJson:*retJsObj HttpStatus:statusCode Error:err])
            {            
                break;
            }
        }
        
        return YES;
        
    } while (NO);
    
    if (statusCode==200) {
        *err = nil;
        return YES;
    }
    return NO;
}

/*
    
    if (statusCode==0)
    {
        *err = [NSError errorWithDomain:LOC_STR("wlqqsb") code:statusCode userInfo:nil];
        return NO;
    }
	
	if ([rcvData isKindOfClass:[NSError class]])
	{
		*err = rcvData;
		LOG_ERROR(@"请求出错：errcode=%d, errstr=%@", [*err code], [*err localizedFailureReason]);
		return NO;
	}
	else if([rcvData isKindOfClass:[NSString class]])
	{
		*retJsObj = [(NSString*)rcvData JSONValue];
		if ([PubFunction isObjNull:*retJsObj])
		{
            
            if (statusCode==200)
                return YES;
            else
            {
                
            }
            
			if (err && ![PubFunction isObjNull:*err])
			{
				LOG_ERROR(@"返回数据解析出错：errcode=%d, errstr=%@", [*err code], [*err localizedFailureReason]);
			}
			else
			{
				//状态码200时，都认为正常
				if (statusCode == 200)
				{
					LOG_ERROR(@"返回数据解析出错, 但HTTP状态码是200，判断为正常!");
					return YES;
				}
				
				NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:statusCode];
				*err = [NSError errorWithDomain:errHttp code:statusCode userInfo:nil];
				
				LOG_ERROR(@"返回数据解析出错：errcode=%d, errstr=%@", [*err code], [*err localizedFailureReason]);
			}

			return NO;
		}
        
        
        
		if (![BussInterImplBase IsErrMsgJson:*retJsObj Error:err])
		{
			NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:statusCode];
			NSError* errTmp = [NSError errorWithDomain:errHttp code:statusCode userInfo:nil];
			*err = nil;
			*err = errTmp;
			LOG_ERROR(@"请求出错：errcode=%d, errstr=%@", [*err code], [*err domain]);
		}
		
		return NO;
	}
	
	return NO;
*/

+(NSString*)getHttpStatusDescByCode:(int)httpCode
{
	NSMutableDictionary* allStatusDesc = nil;
	@try
	{
		allStatusDesc = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
						 @"Continue",							@"100", 
						 @"Switching Protocols",				@"101",
						 @"Processing",							@"102",
						 @"OK",									@"200",
						 @"Created",							@"201",
						 @"Accepted",							@"202", 
						 @"Non-Authoritative Information",		@"203",
						 @"No Content",							@"204", 
						 @"Reset Content",						@"205",
						 @"Partial Content",					@"206", 
						 @"Multi-Status",						@"207", 
						 @"IM Used",							@"226",
						 @"Multiple Choices",					@"300", 
						 @"Moved Permanently",					@"301", 
						 @"Found",								@"302", 
						 @"See Other",							@"303", 
						 @"Not Modified",						@"304", 
						 @"Use Proxy",							@"305", 
						 @"(Unused)",							@"306", 
						 @"Temporary Redirect",					@"307", 
						 @"Bad Request",						@"400", 
						 @"Unauthorized",						@"401", 
						 @"Payment Required",					@"402", 
						 @"Forbidden",							@"403", 
						 @"Not Found",							@"404", 
						 @"Method Not Allowed",					@"405", 
						 @"Not Acceptable",						@"406", 
						 @"Proxy Authentication Required",		@"407", 
						 @"Request Time out",					@"408",
						 @"Conflict",							@"409", 
						 @"Gone",								@"410", 
						 @"Length Required",					@"411", 
						 @"Precondition Failed",				@"412", 
						 @"Request Entity Too Large",			@"413", 
						 @"Request-URI Too Long",				@"414", 
						 @"Unsupported Media Type",				@"415", 
						 @"Requested Range Not Satisfiable",	@"416", 
						 @"Expectation Failed",					@"417", 
						 @"I'm a teapot",						@"418", 
						 @"Unprocessable Entity",				@"422", 
						 @"Locked",								@"423", 
						 @"Failed Dependency",					@"424", 
						 @"(Unordered Collection)",				@"425", 
						 @"Upgrade Required",					@"426", 
						 @"Internal Server Error",				@"500", 
						 @"Not Implemented",					@"501", 
						 @"Bad Gateway",						@"502", 
						 @"Service Unavailable",				@"503", 
						 @"Gateway Timeout",					@"504", 
						 @"HTTP Version Not Supported",			@"505", 
						 @"Variant Also Negotiates",			@"506", 
						 @"Insufficient Storage",				@"507", 
						 @"Not Extended",						@"510", 
						 nil];
		
		NSString* sKey = [NSString stringWithFormat:@"%d", httpCode];
		return [allStatusDesc objectForKey:sKey];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"未找到http状态码. code=%d", httpCode);
	}
	@finally
	{
		if (allStatusDesc)
		{
			[allStatusDesc release];
		}
	}
	return @"";
}


+(NSString*) pickResponBufFromRecvJsObj:(NSDictionary*)jsObj
{
	if ([PubFunction isObjNull:jsObj])
	{
		return nil;
	}

	NSString* strBuf = pickJsonStrValue(jsObj, @"sresponbuf");
	//LOG_DEBUG(@"返回数据内容：%@", strBuf);
	return strBuf;
}


+ (BOOL) IsErrMsgJson:(id) objJson HttpStatus:(int)statusCode Error:(NSError**) err
{
	if ([objJson isKindOfClass:[NSArray class]])
	{
		return NO;
	}
	else if([objJson isKindOfClass:[NSDictionary class]])
	{
		
		if([objJson count] == 1 )
		{
			NSString *msgKey = [[objJson allKeys] objectAtIndex:0];
			if ( [msgKey compare:@"msg"] == 0)
			{
				*err = [NSError errorWithDomain:pickJsonStrValue(objJson, @"msg") code:statusCode userInfo:nil];
				return YES;
			}
		}
	}
	
	return NO;
}

+ (NSString*) getQueryBaseURL
{
#ifdef TARGET_IPHONE_SIMULATOR
	#if ACCESS_OUTER_SERVICE
		return CS_OUTER_URL_BASE;
	#else
		return CS_INNER_URL_BASE;
	#endif
#else
	return CS_OUTER_URL_BASE;
#endif
}

+(NSString*) makeQueryURLWithCgi:(NSString*) cgiName
{
	NSString *url = [NSString stringWithFormat:@"%@%@",[BussInterImplBase getQueryBaseURL],cgiName];
    

    //调试---------
#ifdef LOG_NETINFO
    LOG_ERROR(@"URL=%@", url);
#else 
    LOG_DEBUG(@"URL=%@", url);
#endif    
	return url;
}

+(NSString*) makeQueryURLWithCgiSID:(NSString*)cgiName UserSID:(NSString*)sSID
{
	NSString *url = [NSString stringWithFormat:@"%@%@?sid=%@",[BussInterImplBase getQueryBaseURL],cgiName,sSID];
	
    //调试---------
#ifdef LOG_NETINFO    
    LOG_ERROR(@"URL=%@", url);
#else 
    LOG_DEBUG(@"URL=%@", url);
#endif    
	return url;
}


+(NSString*) makeQueryURLWithCgiSIDWithParam:(NSString*)cgiName UserSID:(NSString*)sSID param:(NSString *)strParam
{
    NSString *url;
    
    if ( !strParam )
        url = [NSString stringWithFormat:@"http://api1.note.91.com/%@?sid=%@",cgiName,sSID];
    else
        url = [NSString stringWithFormat:@"http://api1.note.91.com/%@?sid=%@%@",cgiName,sSID,strParam];
    
    //调试---------
#ifdef LOG_NETINFO    
    LOG_ERROR(@"URL=%@", url);
#else 
    LOG_DEBUG(@"URL=%@", url);
#endif    
	return url;
}



+(NSString*) makeQueryURLWithSID:(NSString*)sSID
{
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"astrocommand" UserSID:sSID];
	
    //调试---------
#ifdef LOG_NETINFO    
    LOG_ERROR(@"URL=%@", url);
#else
    LOG_DEBUG(@"URL=%@", url);
#endif    
	return url;
}


#pragma mark -
//对象释放
-(void) cancelHttpRequest
{
	if (objASIHttpReqt)
	{
		LOG_DEBUG(@"ASIHttpRequest对象释放：%@", objASIHttpReqt);
		[self.objASIHttpReqt clearDelegatesAndCancel];
        //[self.objASIHttpReqt release];
		self.objASIHttpReqt = nil;
	}
}

-(void) destroyBussReqObj
{
	[self cancelHttpRequest];
	self.strURL = nil;
	self.delgtPackData = nil;
	self.callbackObj = nil;
	self.callbackFunc = nil;
	self.callbackObj_preProc = nil;
	self.callbackFunc_preProc = nil;	
	self.bContinueProc = nil;
}


-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"收到数据预处理错误");
		return NO;
	}

    return YES;
}

-(BOOL)unpackJsonForResult:(NSString*)jsRep Result:(TBussStatus *)sts
{
    if ( ![jsRep isKindOfClass:[NSString class]] ) return YES;
    
    if ( ![jsRep hasPrefix:@"{"]  )  return YES;
    
    NSDictionary *nodes = [jsRep JSONValue]; 		
    if (nodes == nil)
        return YES;
    
    sts.rtnData = nodes;
    NSString *strMsg = [nodes objectForKey:@"msg"];
    if ( strMsg) sts.sInfo = strMsg;
    
    return YES;
}


@end

#pragma mark -
#pragma mark BussInterImplBase私有方法

//私有方法
@implementation BussInterImplBase (Private)


-(void)HttpRequest
{
	[self DoASyncRequest];
}


-(void)HttpRequest:(NSString*)url Method:(EHttpMethod)method ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	self.strURL = url;
	self.eHttpMethod = method;
	self.callbackObj = target;
	self.callbackFunc = selector;
	
	[self HttpRequest];
	
}

-(void)HttpRequest_DownloadFile:(NSString*)url Method:(EHttpMethod)method filename:(NSString *)strFilename contenttype:(NSString *)strContentTypeValue ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	self.strURL = url;
	self.eHttpMethod = method;
	self.callbackObj = target;
	self.callbackFunc = selector;
	
	[self DoASyncRequest_DownloadFile:strFilename contenttype:strContentTypeValue];
	
}

-(void)HttpRequest_uploadFile:(NSString*)url Method:(EHttpMethod)method contenttype:(NSString *)strContentTypeValue ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	self.strURL = url;
	self.eHttpMethod = method;
	self.callbackObj = target;
	self.callbackFunc = selector;
	
	[self DoASyncRequest_uploadFile:strContentTypeValue];
	
}

-(void)HttpRequest_uploadJYEXFile:(NSString*)url Method:(EHttpMethod)method contenttype:(NSString *)strContentTypeValue FileName:(NSString*)strFileName FileExt:(NSString*)strFileExt ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	self.strURL = url;
	self.eHttpMethod = method;
	self.callbackObj = target;
	self.callbackFunc = selector;

	[self DoASyncRequest_uploadJYEXFile:strContentTypeValue FileName:strFileName FileExt:strFileExt];
}


-(void)HttpRequest_uploadFormData:(NSString*)url Method:(EHttpMethod)method data:(NSArray *)arrFormData  ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	self.strURL = url;
	self.eHttpMethod = method;
	self.callbackObj = target;
	self.callbackFunc = selector;
    
    [self DoASyncRequest_uploadFormData:arrFormData];
}



-(NSString*) HttpMethodString
{
	switch (eHttpMethod)
	{
		case HTTP_METHOD_GET:
			return @"GET";
			
		case HTTP_METHOD_POST:
			return @"POST";
			
		case HTTP_METHOD_PUT:
			return @"PUT";
			
		default:
			break;
	}
	return @"";
}

-(ASIHTTPRequest*) InitRequestWhithHeader
{
	//URL
	NSURL *url = [NSURL URLWithString:self.strURL];  
	//HTTP请求Header设置
	[self cancelHttpRequest];
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url]; 
	self.objASIHttpReqt = request;
	LOG_DEBUG(@"ASIHttpRequest对象创建：%@", objASIHttpReqt);
	
	//[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"];
	[request addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
	[request addRequestHeader:@"Accept" value:@"*/*" ];
	[request addRequestHeader:@"Accept-Encoding" value:@""];   //Accept-Encoding: gzip, deflate
	//请求方法
	NSString* method = [self HttpMethodString];
	if (![PubFunction stringIsNullOrEmpty:method])
	{
		[request setRequestMethod:method];
	}
	
	return request;
}

-(ASIHTTPRequest*) InitRequestWhithHeader:(NSString *)strContentTypeValue
{
	//URL
	NSURL *url = [NSURL URLWithString:self.strURL];  
	//HTTP请求Header设置
	[self cancelHttpRequest];
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url]; 
	self.objASIHttpReqt = request;
	LOG_DEBUG(@"ASIHttpRequest对象创建：%@", objASIHttpReqt);
	
	//[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"];
	[request addRequestHeader:@"Content-Type" value:strContentTypeValue]; 
	[request addRequestHeader:@"Accept" value:@"*/*" ];
	[request addRequestHeader:@"Accept-Encoding" value:@""];   //Accept-Encoding: gzip, deflate
	//请求方法
	NSString* method = [self HttpMethodString];
	if (![PubFunction stringIsNullOrEmpty:method])
	{
		[request setRequestMethod:method];
	}
	
	return request;
}

-(ASIFormDataRequest*) InitJYEXRequestWhithHeader:(NSString *)strContentTypeValue
{
    //URL
	NSURL *url = [NSURL URLWithString:self.strURL];  
	//HTTP请求Header设置
	[self cancelHttpRequest];
	ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url]; 
	self.objASIHttpReqt = request;
	LOG_DEBUG(@"ASIFormDataRequest对象创建：%@", objASIHttpReqt);
	
	//[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"];
	[request addRequestHeader:@"Content-Type" value:strContentTypeValue]; 
	[request addRequestHeader:@"Accept" value:@"*/*" ];
	[request addRequestHeader:@"Accept-Encoding" value:@""];   //Accept-Encoding: gzip, deflate
	//请求方法
	NSString* method = [self HttpMethodString];
	if (![PubFunction stringIsNullOrEmpty:method])
	{
		[request setRequestMethod:method];
	}
	
	return request;
}

-(ASIFormDataRequest*) InitFormRequestWithHeader
{
    //URL
	NSURL *url = [NSURL URLWithString:self.strURL];
	//HTTP请求Header设置
	[self cancelHttpRequest];
	ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
	self.objASIHttpReqt = request;
	LOG_DEBUG(@"ASIFormDataRequest对象创建：%@", objASIHttpReqt);
	
	//[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"];
	[request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
	[request addRequestHeader:@"Accept" value:@"*/*" ];
	[request addRequestHeader:@"Accept-Encoding" value:@""];   //Accept-Encoding: gzip, deflate
	//请求方法
	NSString* method = [self HttpMethodString];
	if (![PubFunction stringIsNullOrEmpty:method])
	{
		[request setRequestMethod:method];
	}
	
	return request;
}



-(void) DoSyncRequest
{
	LOG_DEBUG(@"HTTP同步请求...");
	ASIHTTPRequest* request = [self InitRequestWhithHeader];
	//发出数据
    if ( self.eHttpMethod == HTTP_METHOD_POST)
        [request appendPostData:[self MakeSendParam]];
	[request startSynchronous]; 
	NSError* err = [request error];
	if (!err)
	{
		NSString* response = [request responseString];
		int code = [request responseStatusCode];
		LOG_ERROR(@"%@", response);
		
		//处理数据
		[self doProcRecvData:response HttpCode:code];
	}
	else
	{
		//处理后通知
		[self notifyCallBack:err];
	}

}


-(void) DoASyncRequest
{
	LOG_DEBUG(@"HTTP异步请求...");
	//ASIHTTPRequest* request = [self InitRequestWhithHeader];
    ASIHTTPRequest* request = [self InitRequestWhithHeader:@"application/x-www-form-urlencoded"];
    //
    request.useCookiePersistence = YES;
	//发出数据
    if ( self.eHttpMethod == HTTP_METHOD_POST)
        [request appendPostData:[self MakeSendParam]];
    
	[request setDelegate:self];
	[request startAsynchronous];  
}

-(void) DoASyncRequest_DownloadFile:(NSString *)strFilename contenttype:(NSString *)strContentTypeValue
{
	LOG_DEBUG(@"HTTP异步请求下载文件...");
	ASIHTTPRequest* request = [self InitRequestWhithHeader:strContentTypeValue];
    
	//发出数据
    if ( self.eHttpMethod == HTTP_METHOD_POST)
        [request appendPostData:[self MakeSendParam]];
    
    //add
    [request setDownloadDestinationPath :strFilename];
    
    
	[request setDelegate:self];
	[request startAsynchronous];  
}

-(void) DoASyncRequest_uploadFile:(NSString *)strContentTypeValue
{
	LOG_DEBUG(@"HTTP异步请求上传文件数据...");
	ASIHTTPRequest* request = [self InitRequestWhithHeader:strContentTypeValue];
    
	//发出数据
    if ( self.eHttpMethod == HTTP_METHOD_POST)
        [request appendPostData:[self MakeSendBytesParam]];
    
	[request setDelegate:self]; 
	[request startAsynchronous];  
}

-(void) DoASyncRequest_uploadJYEXFile:(NSString *)strContentTypeValue FileName:(NSString*)strFileName FileExt:(NSString*)strExt
{
	LOG_DEBUG(@"HTTP异步请求上传文件数据...");
	ASIFormDataRequest* request = [self InitJYEXRequestWhithHeader:strContentTypeValue];
    
	//发出数据
    if ( self.eHttpMethod == HTTP_METHOD_POST)
    {
        [request setData:[self MakeSendBytesParam] withFileName:[NSString stringWithFormat:@"%@.%@", strFileName, strExt] andContentType:strContentTypeValue forKey:@"attachment"];
        
        //设置显示代理
        [request setUploadProgressDelegate:[UIProgress instance]];
        request.showAccurateProgress = YES;
        
        [request setDelegate:self]; 
        [request startAsynchronous];  
    }
}


-(void) DoASyncRequest_uploadFormData:(NSArray *)arrFormData
{
	LOG_DEBUG(@"HTTP异步请求上传Form格式文件数据...");
	ASIFormDataRequest* request = [self InitFormRequestWithHeader];
    
    for (NSDictionary *obj in arrFormData ) {
        
        NSString *key = [obj objectForKey:@"key"];
        NSString *value = [obj objectForKey:@"value"];
        NSString *type = [obj objectForKey:@"type"];
        
        if ( [type isEqualToString:@"data"] )
            [request addPostValue:value forKey:key];
        else
            [request addFile:value forKey:key];  //文件
    }
    
    //设置显示代理
    [request setUploadProgressDelegate:[UIProgress instance]];
    request.showAccurateProgress = YES;
    
    [request setDelegate:self];
    [request startAsynchronous];
}



//HTTP响应:成功
- (void)requestFinished:(ASIHTTPRequest *)request  
{  
	// Use when fetching text data  
	NSString *responseString = [request responseString];
	iHttpCode = [request responseStatusCode];
	LOG_DEBUG(@"HTTP异步请求成功. code=%d", iHttpCode);
	
//	// Use when fetching binary data  
//	NSData *responseData = [request responseData];  

	LOG_DEBUG(@"HTTP异步请求响应->回调函数...");
	[self doProcRecvData:responseString HttpCode:iHttpCode];
    
    //网络状态是否发生变化  add 2012.8.20
    if ( TheNetStatus == 1 ) { //网络不正常
        TheNetStatus = 0;  //正常
        //发通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if (nc) {
            [nc postNotificationName:NOTIFICATION_NETSTATUS_CHANGE object:nil userInfo:nil];
        }
    }
}  

//HTTP响应:失败
- (void)requestFailed:(ASIHTTPRequest *)request  
{  
	NSError *err = [request error];
	iHttpCode = [request responseStatusCode];
	LOG_DEBUG(@"HTTP异步请求失败(%d)...", iHttpCode);
    
    
    if ( iHttpCode == 200 ) iHttpCode = 1;  //特殊处理
    
	if (err)
	{
		// If an error occurs, error will contain an NSError
		// If error code is = ASIConnectionFailureErrorType (1, Connection failure occurred) - inspect [[error userInfo] objectForKey:NSUnderlyingErrorKey] for more information
		if([err code] == ASIConnectionFailureErrorType)
		{
            TheNetStatus = 1;  //网络不正常  //add 2012.8.20
            
			LOG_ERROR(@"网络请求出错: errcode=%d, errinfo=%@", [err code], [[err userInfo] objectForKey:NSUnderlyingErrorKey]);
		}
		else
		{
			LOG_ERROR(@"网络请求出错: errcode=%d, errinfo=%@", [err code], @"");
		}

		err = nil;
		
	}
    
    
    NSString* sErrHttp = [BussInterImplBase getHttpStatusDescByCode:iHttpCode];
    if ([PubFunction stringIsNullOrEmpty:sErrHttp])
    {
        sErrHttp = LOC_STR("wlqqsb");
    }
    err = [NSError errorWithDomain:sErrHttp code:iHttpCode userInfo:nil];
	
    
	[self notifyCallBack:err];
} 

//构建发送数据
-(NSMutableData*) MakeSendParam
{
	LOG_DEBUG(@"构造发送数据...");
	NSMutableData *requestData = [NSMutableData data];
								  
	NSString *strJson = @"";
	if (delgtPackData && [delgtPackData respondsToSelector:@selector(PackSendOutJsonString)] )
	{
		strJson = [delgtPackData PackSendOutJsonString];
	}
	
	
    //调试---------
#ifdef LOG_NETINFO    
    LOG_ERROR(@"发出请求数据：%@", strJson);
#else
    LOG_DEBUG(@"发出请求数据：%@", strJson);
#endif    
    
//	if (strJson && [strJson length] > 0)
	{
		[requestData appendData:[strJson dataUsingEncoding:NSUTF8StringEncoding]];
	}
	return requestData;
}

//构建发送数据
-(NSMutableData*) MakeSendBytesParam
{
	LOG_DEBUG(@"构造发送数据...");
	NSMutableData *requestData = [NSMutableData data];
    
	NSData *data = [NSData dataWithBytes:"1" length:1];
	if (delgtPackData && [delgtPackData respondsToSelector:@selector(PackSendOutByteData)] )
	{
		data = [delgtPackData PackSendOutByteData];
	}
	
    //调试---------
#ifdef LOG_NETINFO    
    LOG_DEBUG(@"发出字节数据：%d 字节", [data length]);
#else
    LOG_DEBUG(@"发出字节数据：%d 字节", [data length]);
#endif    
    
    //	if (strJson && [strJson length] > 0)
	{
		[requestData appendData:data];
	}
	return requestData;
}

//处理接收数据
-(void) doProcRecvData:(id) rcvData HttpCode:(int) httpCode
{
    //调试--------    
#ifdef LOG_NETINFO    
    LOG_ERROR(@"返回HttpCode：%d", httpCode);
    LOG_ERROR(@"返回数据：%@", rcvData);
#else
    LOG_DEBUG(@"返回HttpCode：%d", httpCode);
    LOG_DEBUG(@"返回数据：%@", rcvData);
#endif
    
	//处理前通知
	[self notifyPreCallBack:rcvData];
	
	//是否继续处理
	if (!bContinueProc)
	{
		return;
	}
	else
	{
		//数据处理
		NSError* err = nil;
//		if ( [ self respondsToSelector:@selector(ProcRecvData::)] )
		{
            id imp = self;
            
			if(![imp ProcRecvData:rcvData Error:&err])
			{
//				err = [NSError errorWithDomain:@"数据处理错误" code:NSFormattingError userInfo:nil];
			}
		}
		
		//处理后通知
		if (err)
		{
			[self notifyCallBack:err];
		}
		else
		{
			[self notifyCallBack:rcvData];
		}
		
	}
}

/*
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
    *err = nil;
    return YES;
}
*/

-(void)notifyPreCallBack:(id)arg
{
	if ( !callbackObj_preProc )
	{
		return;
	}
	else if ([callbackObj_preProc respondsToSelector:callbackFunc_preProc])
	{
		[callbackObj_preProc  performSelectorOnMainThread:callbackFunc_preProc withObject:arg waitUntilDone:NO];
		LOG_DEBUG(@"＝＝＝＝回调结束＝＝＝＝");
	}
}

-(void)notifyCallBack:(id)arg
{
	if ( !callbackObj )
	{
		return;
	}
	else if ([callbackObj respondsToSelector:callbackFunc])
	{
		[callbackObj  performSelectorOnMainThread:callbackFunc withObject:arg waitUntilDone:NO];
		
		LOG_DEBUG(@"＝＝＝＝回调结束＝＝＝＝");
	}
}

@end

#pragma mark -
#pragma mark 登录
@implementation BussLogin

@synthesize lgnUser;
@synthesize	retObj;
@synthesize	retFunc;
@synthesize sSrvDate;

-(void) Login:(NSString*) username Password:(NSString*) passwd RemPswd:(int)remPswd AutoLogin:(int)autoLogin ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	NSLog(@"登录用户：name=%@, pswd=%@", username, passwd);
	if (!self.lgnUser)
	{
		self.lgnUser = [[TLoginUserInfo new] autorelease];
	}
	
	self.lgnUser.sUserName = username;
	self.lgnUser.sPassword = passwd;
    self.lgnUser.iSavePasswd = remPswd;
    
	self.delgtPackData = self;
	self.retObj = target;
	self.retFunc = selector;
	iLoginStatus = 1;	//登录...
	
	NSString* url = [BussInterImplBase makeQueryURLWithCgi:@"loginByPhone"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(onLogined:)];
}

-(void) login91Note
{
    iLoginStatus = 2;	//登录..
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"common/log/login" UserSID:self.lgnUser.sSID param:nil];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:self ResponseSelector:@selector(onNoteLogined:)];
    
}

-(void) loginGetNickName
{
    iLoginStatus = 3;	//取nickname
    
    NSString *url = [NSString stringWithFormat:@"http://uap.91.com/user/%@?sid=%@",self.lgnUser.sUserID,self.lgnUser.sSID];
    
    //调试---------
#ifdef LOG_NETINFO
    LOG_ERROR(@"URL=%@", url);
#else 
    LOG_DEBUG(@"URL=%@", url);
#endif    

	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:retObj ResponseSelector:retFunc];
    
}


-(NSString*) AutoLogin:(id)target ResponseSelector:(SEL)selector
{
	TLoginUserInfo* user = [TLoginUserInfo new];
	@try
	{
		if ([AstroDBMng getLoginedUserCount] <= 0)
		{
#ifdef TARGET_IPHONE_SIMULATOR
	#if ACCESS_OUTER_SERVICE
			user.sUserName = CS_DEFAULTACCOUNT_USERNAME;
			user.sPassword = CS_DEFAULTACCOUNT_PASSWORD;
	#else
			user.sUserName = @"test200";
			user.sPassword = @"1";
	#endif
#else
			user.sUserName = CS_DEFAULTACCOUNT_USERNAME;
			user.sPassword = CS_DEFAULTACCOUNT_PASSWORD;
#endif
		}
		else
		{
			if (![AstroDBMng getLastLoginUser:user])
			{
				return LOC_STR("hqdrxxsb");
			}
		}
		
		[self Login:user.sUserName Password:user.sPassword RemPswd:1 AutoLogin:1 ResponseTarget:target ResponseSelector:selector];
		
		return nil;
	}
	@catch (NSException * e)
	{
		return nil;
	}
	@finally
	{
		[user release];
	}
	
	return nil;
}

-(void) dealloc
{
	self.lgnUser = nil;
	self.sSrvDate = nil;
	[super dealloc];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
	//LOG_DEBUG(@"返回数据：%@", rcvData);
    NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
	if(!self.lgnUser)
	{
		LOG_ERROR(@"登录：登录帐号信息异常");
		return NO;
	}
    
    //登录
	if (iLoginStatus == 1)
	{
		[self UnPackLoginJsonStr:objJson];
	}
	//用户初始化数据(请求服务端用户对应数据表)
	else if(iLoginStatus == 2)
	{
		//[self UnPackInitUserJsonStr:objJson];
        [self UnPackLogin91NoteJsonStr:objJson];
		
		//正确
		self.lgnUser.sLoginTime = [PubFunction getTimeStr1];
		self.lgnUser.iLoginType = ELoginType_OnLine;
    }
    else if ( iLoginStatus == 3 )
    {
        [self UnPackLoginGetNickNameJsonStr:objJson];
        
        //登录成功后的共通业务逻辑
        //[BizLogic procLoginSuccess:self.lgnUser];
	}
	return YES;
}


-(NSString*) PackSendOutJsonString
{
	NSMutableDictionary* jobjUser = [NSMutableDictionary dictionary];
	if ( !jobjUser )
	{
		return @"";
	}
	
	//登录
	if (iLoginStatus == 1)
	{
		[jobjUser setObject:lgnUser.sUserName forKey:@"username"];
		[jobjUser setObject:lgnUser.sPassword forKey:@"password"];
		[jobjUser setObject:[NSNumber numberWithInt:lgnUser.iAppID] forKey:@"appid"];
		[jobjUser setObject:lgnUser.sBlowfish forKey:@"blowfish"];
		
		NSString* strJson = [jobjUser JSONRepresentation];
		return strJson;
	}
	//登录91Note
	else //if(iLoginStatus == 2)
	{
		[jobjUser setObject:lgnUser.sUserName forKey:@"username"];
		[jobjUser setObject:CS_SOFT_ID forKey:@"vercode"];
	}

	NSString* strJson = [jobjUser JSONRepresentation];
	return strJson;
}

-(void) UnPackLoginJsonStr:(NSDictionary*) jsObj
{
	if ( !jsObj )
	{
		return;
	}
	
	int code = pickJsonIntValue(jsObj, @"code");
	if (code != 200)
	{
		LOG_ERROR(@"登录请求有错误. code=%d", code);
	}
	self.lgnUser.sUserID = pickJsonStrValue(jsObj, @"uid");
	self.lgnUser.sSID = pickJsonStrValue(jsObj, @"sid");
	self.lgnUser.sUAPID = pickJsonStrValue(jsObj, @"uapSid");
	self.lgnUser.sMsg = pickJsonStrValue(jsObj, @"msg");
	self.lgnUser.sSessionID = pickJsonStrValue(jsObj, @"sessionid");
}




-(void)UnPackLogin91NoteJsonStr:(NSDictionary*) jsObj
{
 	if ( !jsObj )
	{
		return;
	}
    
    //保存参数
    NSNumber *user_id = [jsObj objectForKey:@"user_id"];
    self.lgnUser.sNoteUserId = [user_id stringValue];
    self.lgnUser.sNoteMasterKey = [jsObj objectForKey:@"master_key"];
    self.lgnUser.sNoteIpLocation = [jsObj objectForKey:@"ip_location"];
}

-(void)UnPackLoginGetNickNameJsonStr:(NSDictionary*) jsObj
{
 	if ( !jsObj )
	{
		return;
	}
    
    //保存参数
    self.lgnUser.sNickName = [jsObj objectForKey:@"nickname"];
    
}


-(void) onLogined:(id)err
{
	if (err && [err isKindOfClass:[NSError class]])
	{
		LOG_ERROR(@"登录：请求sid失败");
		if ( retObj && [retObj respondsToSelector:retFunc])
		{
			[retObj  performSelector:retFunc withObject:err];
		}
		return;
	}
	
	//获取用户对应数据表
    TLoginUserInfo *userinfo = [AstroDBMng getLoginUserByUID:self.lgnUser.sUserID];
    if ( userinfo)
    {
        if ([userinfo.sNoteUserId intValue] > 1 && [userinfo.sNoteMasterKey length] == 16 )
        {
            //不再登录91note
            self.lgnUser.sNoteUserId = userinfo.sNoteUserId;
            self.lgnUser.sNoteMasterKey = userinfo.sNoteMasterKey;
            self.lgnUser.sNoteIpLocation = userinfo.sNoteIpLocation;
            
            //正确
            self.lgnUser.sLoginTime = [PubFunction getTimeStr1];
            self.lgnUser.iLoginType = ELoginType_OnLine;
        
            if ( userinfo.sNickName && [userinfo.sNickName length]> 0 )
            {
                self.lgnUser.sNickName = userinfo.sNickName;
            
                //登录成功后的共通业务逻辑
                [BizLogic procLoginSuccess:self.lgnUser];
            
                if ( retObj && [retObj respondsToSelector:retFunc])
                {
                    [retObj  performSelector:retFunc withObject:err];
                }
                return;
            }
            else {
                [self loginGetNickName];
                return;
            }
        }
    }
    
    [self login91Note];
}

-(void) onNoteLogined:(id)err
{
	if (err && [err isKindOfClass:[NSError class]])
	{
		LOG_ERROR(@"登录：请求sid失败");
		if ( retObj && [retObj respondsToSelector:retFunc])
		{
			[retObj  performSelector:retFunc withObject:err];
		}
		return;
	}
	
    if ( self.lgnUser.sNickName && [self.lgnUser.sNickName length]> 0 )
    {        
        //登录成功后的共通业务逻辑
        [BizLogic procLoginSuccess:self.lgnUser];
        
        if ( retObj && [retObj respondsToSelector:retFunc])
        {
            [retObj  performSelector:retFunc withObject:err];
        }
        return;
    }
    
    [self loginGetNickName];
}

@end

#pragma mark -
#pragma mark  家园E线登录
@implementation BussJYEXLogin
@synthesize appList;

-(void) Login:(NSString*) username Password:(NSString*) passwd RemPswd:(int)remPswd AutoLogin:(int)autoLogin ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
	NSLog(@"登录用户：name=%@, pswd=%@", username, passwd);
    SAFEFREE_OBJECT(self.appList);
	if (!self.lgnUser)
	{
        self.lgnUser = [[TJYEXLoginUserInfo new] autorelease];
	}
	self.lgnUser.sUserName = username;
	self.lgnUser.sPassword = passwd;
    self.lgnUser.iSavePasswd = remPswd;
	self.lgnUser.iAutoLogin = autoLogin;
    
	self.delgtPackData = self;
	self.retObj = target;
	self.retFunc = selector;
	iLoginStatus = 1;	//登录...
	
	NSString* url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=member&ac=login"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(onLogined:)];
}



-(void)dealloc
{
    SAFEFREE_OBJECT(self.appList);
    [super dealloc];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
    if ( iLoginStatus < 4 ) {
        return [super ProcRecvData:rcvData Error:err];
    }
    
    NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
	if(!self.lgnUser)
	{
		LOG_ERROR(@"登录：登录帐号信息异常");
		return NO;
	}
    
    
    
    if ( iLoginStatus == 4 ) {
        [self UnPackLoginJYEXLanmuListJsonStr:objJson];
    }
    else if( iLoginStatus == 5 )
    {
        [self UnPackLoginJYEXClassListJsonStr:objJson];
    }
    return YES;
}

-(NSString*) AutoLogin:(id)target ResponseSelector:(SEL)selector
{
	TLoginUserInfo* user = [TLoginUserInfo new];
	@try
	{
		if ( [AstroDBMng getLoginedUserCount] <= 0 || ![AstroDBMng getLastLoginUser:user])
		{
            NSString *s = @"{\"result\":true,\"msg\":\"login_false\"}";
            if ( target && [target respondsToSelector:selector] ) 
            {
                [target performSelector:selector withObject:s];
            }
            return nil;
		}

        if ( [user.sUserName length]>0 && [user.sPassword length]>0 ) {
		//if ( user.iAutoLogin ) {
            [self Login:user.sUserName Password:user.sPassword RemPswd:user.iSavePasswd AutoLogin:user.iAutoLogin ResponseTarget:target ResponseSelector:selector];
        }
        else
        {
            NSString *s = @"{\"result\":true,\"msg\":\"login_false\"}";
            if ( target && [target respondsToSelector:selector] ) 
            {
                [target performSelector:selector withObject:s];
            }
        }
		return nil;
	}
	@catch (NSException * e)
	{
		return nil;
	}
	@finally
	{
		[user release];
	}
	
	return nil;
}

-(NSString*) PackSendOutJsonString
{
	NSMutableDictionary* jobjUser = [NSMutableDictionary dictionary];
	if ( !jobjUser )
	{
		return @"";
	}
	
	//登录
    if ( 1 == iLoginStatus ) {
        [jobjUser setObject:lgnUser.sPassword forKey:@"password"];
        [jobjUser setObject:lgnUser.sUserName forKey:@"username"];
        
        
        //add 2014.6.30
        
        NetworkStatus netType = [[Global instance] getNetworkStatus];
        NSString *strNetwork = @"";
        if ( netType == kNotReachable ) strNetwork = @"NotReachable";
        else if ( netType == kReachableViaWWAN ) strNetwork = @"2G/3G";
        else if ( netType == kReachableViaWiFi ) strNetwork = @"WIFI";
        
        [jobjUser setObject:JYEX_APPID forKey:@"appid"];
        [jobjUser setObject:[CommonFunc getAppName] forKey:@"appname"];
        [jobjUser setObject:[CommonFunc getAppVersion] forKey:@"appver"];
        [jobjUser setObject:JYEX_APPSROUCE forKey:@"appsource"];
        [jobjUser setObject:[[UIDevice currentDevice] systemName] forKey:@"ostype"];
        [jobjUser setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
        [jobjUser setObject:[[UIDevice currentDevice] model] forKey:@"phonetype"];
        [jobjUser setObject:[_GLOBAL getTokenString] forKey:@"token"];
        [jobjUser setObject:strNetwork forKey:@"network"];
        
    
    }
    else if( 2 == iLoginStatus || 3 == iLoginStatus ) //获取用户详细信息
    {
        return @"";
    }
    		
    NSString* strJson = [jobjUser JSONRepresentation];
    NSString* para = [NSString stringWithFormat:@"para=%@", strJson];
    return para;
}

//***登录第1步解析(登录结果)
-(void) UnPackLoginJsonStr:(NSDictionary*) jsObj
{
	if ( !jsObj )
	{
		return;
	}
	NSString* result = nil;
    NSLog(@"%@\r\n", [jsObj description] );
    int iResult = pickJsonIntValue(jsObj, @"result");
	if ( iResult != 1 )
	{
		LOG_ERROR(@"登录请求有错误\r\n");
	}
    
    result = [pickJsonStrValue(jsObj, @"msg")  lowercaseString];
    if ( [result isEqualToString:@"login_false"] ) {
        LOG_ERROR(@"%@\r\n", @"登录失败" );
    }
    else if( [result isEqualToString:@"no_user"] ) {
        LOG_ERROR(@"%@\r\n", @"用户名不存在" );
    }
    self.lgnUser.sMsg = result;
    if ( [result isEqualToString:@"login_success"] ) {
        self.lgnUser.sUserID = pickJsonStrValue(jsObj, @"uid");
        self.lgnUser.iGroupID = pickJsonIntValue(jsObj, @"groupid");
        self.lgnUser.sSessionID = pickJsonStrValue(jsObj, @"sessionid");
        //2014.9.18
        self.lgnUser.sNoteUserId = pickJsonStrValue(jsObj, @"td_ip");
        
        //2015.5.25
        /*
        NSString *strLatestVersion = pickJsonStrValue(jsObj, @"latest_version");
        NSString *strCurVersion = [CommonFunc getAppVersion];
        if ([strLatestVersion compare:strCurVersion] == NSOrderedDescending) {
            [];
        }
        else {
            
        }*/
        
     
        //2014.9.26
        TJYEXLoginUserInfo *user = (TJYEXLoginUserInfo *)self.lgnUser;
        user.sAlbumIdPerson = @""; //2014.9.26
        user.sAlbumNamePerson = @"";
        user.sAlbumUidPerson = @"";
        user.sAlbumUsernamePerson = @"";
        user.sAlbumIdClass = @""; //2014.9.26
        user.sAlbumNameClass = @"";
        user.sAlbumUidClass = @"";
        user.sAlbumUsernameClass = @"";
        user.sAlbumIdSchool = @""; //2014.9.26
        user.sAlbumNameSchool = @"";
        user.sAlbumUidSchool = @"";
        user.sAlbumUsernameSchool = @"";

        
        id ob = pickJsonValue(jsObj, @"albumlist", nil);
        if ( ob && [ob isKindOfClass:[NSArray class]] ) {
            NSArray *arr = (NSArray*)ob;
            NSDictionary * dic = nil;
            for ( int i = 0; i < [arr count]; ++i ) {
                dic = [arr objectAtIndex:i];
                if ( dic ) {
                    user.sAlbumIdPerson = pickJsonStrValue(dic,@"albumid");;
                    user.sAlbumNamePerson = pickJsonStrValue(dic,@"albumname");
                    user.sAlbumUidPerson = pickJsonStrValue(dic, @"uid");
                    user.sAlbumUsernamePerson = pickJsonStrValue(dic, @"username");
                    break;
                }
            }
        }
        ob = pickJsonValue(jsObj, @"classalbumlist", nil);
        if ( ob && [ob isKindOfClass:[NSArray class]] ) {
            NSArray *arr = (NSArray*)ob;
            NSDictionary * dic = nil;
            for ( int i = 0; i < [arr count]; ++i ) {
                dic = [arr objectAtIndex:i];
                if ( dic ) {
                    user.sAlbumIdClass = pickJsonStrValue(dic,@"albumid");;
                    user.sAlbumNameClass = pickJsonStrValue(dic,@"albumname");
                    user.sAlbumUidClass = pickJsonStrValue(dic, @"uid");
                    user.sAlbumUsernameClass = pickJsonStrValue(dic, @"username");
                    break;
                }
            }
        }
        ob = pickJsonValue(jsObj, @"schoolalbumlist", nil);
        if ( ob && [ob isKindOfClass:[NSArray class]] ) {
            NSArray *arr = (NSArray*)ob;
            NSDictionary * dic = nil;
            for ( int i = 0; i < [arr count]; ++i ) {
                dic = [arr objectAtIndex:i];
                if ( dic ) {
                    user.sAlbumIdSchool = pickJsonStrValue(dic,@"albumid");;
                    user.sAlbumNameSchool = pickJsonStrValue(dic,@"albumname");
                    user.sAlbumUidSchool = pickJsonStrValue(dic, @"uid");
                    user.sAlbumUsernameSchool = pickJsonStrValue(dic, @"username");
                    break;
                }
            }
        }
        
    }
}


-(void) onLogined:(id)err
{
	if (err && [err isKindOfClass:[NSError class]])
	{
        //出现网络错误后进行本地验证,如果验证通过,则登录成功
        TJYEXLoginUserInfo *userinfo
        = [AstroDBMng getJYEXLoginUserByUserName:self.lgnUser.sUserName];
        if( userinfo && [userinfo.sPassword isEqualToString:self.lgnUser.sPassword] )
        {
            userinfo.iLoginType = ELoginType_OffLine;
            userinfo.sLoginTime = [PubFunction getTimeStr1];
            userinfo.iAutoLogin = self.lgnUser.iAutoLogin;
            userinfo.iSavePasswd = self.lgnUser.iSavePasswd;
            self.lgnUser = userinfo;
            [AstroDBMng replaceJYEXLoginUser:userinfo];
            //本地用户名,密码验证成功,发送一段登陆成功的json给回掉函数
            [BizLogic procJYEXLoginSuccess:self.lgnUser];
            NSString *s = @"{\"result\":true,\"msg\":\"login_success\"}";
            if ( retObj && [retObj respondsToSelector:retFunc] )
            {
                [retObj performSelector:retFunc withObject:s];
            }
            return;
        }
		LOG_ERROR(@"登录失败");
		if ( retObj && [retObj respondsToSelector:retFunc])
		{
			[retObj  performSelector:retFunc withObject:err];
		}
		return;
	}
	
    if ( [self.lgnUser.sMsg isEqualToString:@"login_success"] ) {
        ((TJYEXLoginUserInfo *)(self.lgnUser)).iLoginFlag = 1;
        //获取用户对应数据表
        TJYEXLoginUserInfo *userinfo
        = [AstroDBMng getJYEXLoginUserByUID:self.lgnUser.sUserID];
        if ( userinfo )
        {
            //正确
            self.lgnUser.sLoginTime = [PubFunction getTimeStr1];
            self.lgnUser.iLoginType = ELoginType_OnLine;
        }
        [BizLogic procJYEXLoginSuccess:self.lgnUser];
        [self getJYEXUserInfor];
    }
    else
    {
        LOG_ERROR(@"登录失败");
        TJYEXLoginUserInfo *userinfo
        = [AstroDBMng getJYEXLoginUserByUID:self.lgnUser.sUserID];
        if ( userinfo)
        {
            userinfo.iLoginFlag = 0;
            [AstroDBMng replaceJYEXLoginUser:userinfo];
        }
		if ( retObj && [retObj respondsToSelector:retFunc])
		{
			[retObj  performSelector:retFunc withObject:err];
		}
		return;
    }
}


//---------------------------------------------

//***登录第2步解析(获取用户属性信息)
-(void)UnPackLogin91NoteJsonStr:(NSDictionary*) jsObj
{
    [self UnPackLoginJYEXUserinforJsonStr:jsObj];
}

-(void)UnPackLoginJYEXUserinforJsonStr:(NSDictionary*) jsObj
{
    if ( !jsObj )
	{
		return;
	}
    NSLog(@"%@\r\n", [jsObj description]);
	self.lgnUser.sNickName = pickJsonStrValue(jsObj, @"nickname");
    self.lgnUser.sRealName = pickJsonStrValue(jsObj, @"realname");
    
    //家园e线新增的属性
    TJYEXLoginUserInfo *user = (TJYEXLoginUserInfo *)self.lgnUser;
    user.iSchoolType = pickJsonIntValue(jsObj, @"school_type", 0);
    user.sEmail = pickJsonStrValue(jsObj, @"email");
    user.sMobilephone = pickJsonStrValue(jsObj, @"mobile");
    user.sTelephone = pickJsonStrValue(jsObj, @"telephone");
    user.sAddress = pickJsonStrValue(jsObj, @"address");
}

-(void)getJYEXUserInfor
{
    iLoginStatus = 2;	//获取用户信息
	
	NSString* url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=member&ac=view"];

	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(getJYEXUserInforEnd:)];
}

-(void)getJYEXUserInforEnd:(id)err
{
    [AstroDBMng replaceJYEXLoginUser:((TJYEXLoginUserInfo*)self.lgnUser)];
    if (err && [err isKindOfClass:[NSError class]])
    {
        if ( retObj && [retObj respondsToSelector:retFunc])
        {
            [retObj  performSelector:retFunc withObject:err];
        }
        return;
    }
    [self getJYEXUserAppList];
    return;
}



//*** 登录第3步(获取用户的应用列表)
-(void)getJYEXUserAppList
{
    iLoginStatus = 3; //获取用户的应用列表
    
    SAFEFREE_OBJECT(self.appList);
    NSString* url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=app&ac=userapp"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(getJYEXUserAppListEnd:)];
}

-(void)getJYEXUserAppListEnd:(id)err
{
    if ( !err || ![err isKindOfClass:[NSError class]])
    {
        if ( self.appList ) {
            [BizLogic updateUserAppList:self.appList WithUserName:self.lgnUser.sUserName];
        }
        [self getJYEXLanmuList];
    }
    else
    {
        if ( retObj && [retObj respondsToSelector:retFunc])
        {
            [retObj  performSelector:retFunc withObject:err];
        }
    }
    return;
}

//***登录第3步解析(获取开通应用列表和未开通应用列表)
-(void)UnPackLoginJYEXUserAppListJsonStr:(NSDictionary*) jsObj
{
    if ( !jsObj )
	{
		return;
	}
    NSLog(@"%@\r\n", [jsObj description]);
    if ( !self.appList ) {
        self.appList = [[NSMutableArray alloc] init];
    }
    assert( self.appList );
    id ob = pickJsonValue(jsObj, @"userapp", nil);
    if ( ob && [ob isKindOfClass:[NSArray class]] ) {
        NSArray *arr = (NSArray*)ob;
        NSDictionary * dic = nil;
        for ( int i = 0; i < [arr count]; ++i ) {
            dic = [arr objectAtIndex:i];
            if ( dic ) {
                JYEXUserAppInfo* appInfo = [[JYEXUserAppInfo alloc] init];
                appInfo.sUserName = self.lgnUser.sUserName;
                appInfo.sAppName = (NSString*)[dic objectForKey:@"ywname"];
                appInfo.iAppID = [(NSNumber*)[dic objectForKey:@"id"] integerValue];
                appInfo.sAppCode = (NSString*)[dic objectForKey:@"ywcode"];
                appInfo.iAppType = USER_APP_TYPE_BOUGHT;
                [self.appList addObject:appInfo];
                SAFEFREE_OBJECT(appInfo);
            }
        }
    }
    
    ob = pickJsonValue(jsObj, @"otherapp", nil);
    if ( ob && [ob isKindOfClass:[NSArray class]] ) {
        NSArray *arr = (NSArray*)ob;
        NSDictionary * dic = nil;
        for ( int i = 0; i < [arr count]; ++i ) {
            dic = [arr objectAtIndex:i];
            if ( dic ) {
                JYEXUserAppInfo* appInfo = [[JYEXUserAppInfo alloc] init];
                appInfo.sUserName = self.lgnUser.sUserName;
                appInfo.sAppName = (NSString*)[dic objectForKey:@"ywname"];
                appInfo.iAppID = [(NSNumber*)[dic objectForKey:@"id"] integerValue];
                appInfo.sAppCode = (NSString*)[dic objectForKey:@"ywcode"];
                appInfo.iAppType = USER_APP_TYPE_NOMINATE;
                [self.appList addObject:appInfo];
                SAFEFREE_OBJECT(appInfo);
            }
        }
    }
}

//***登录第3步解析(获取开通应用列表和未开通应用列表)
-(void)UnPackLoginGetNickNameJsonStr:(NSDictionary*) jsObj
{
    [self UnPackLoginJYEXUserAppListJsonStr:jsObj];
    return;
}



//*** 登录第4步(获取用户的栏目列表)
-(void)getJYEXLanmuList
{
    iLoginStatus = 4; //获取用户的栏目列表
    
    NSString *s = [NSString stringWithFormat:@"mobile.php?mod=blog&ac=classlist&uid=%@", TheCurUser.sUserID];
    NSString* url = [BussInterImplBase makeQueryURLWithCgi:s];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(getJYEXLanmuListEnd:)];
}

//***登录第4步解析(获取栏目信息列表)
-(void)UnPackLoginJYEXLanmuListJsonStr:(NSDictionary*) jsObj
{
    if ( !jsObj )
	{
		return;
	}
    NSLog(@"%@\r\n", [jsObj description]);
    NSEnumerator *enumerator = [jsObj objectEnumerator];
    
    NSDictionary *dic = nil;
    TJYEXLanmu *lanmu = nil;
    NSMutableArray *arr = [NSMutableArray array];
    while (id obj = [enumerator nextObject] ) {
        if ( [obj isKindOfClass:[NSDictionary class]] ) {
            dic = obj;
            lanmu = [[TJYEXLanmu alloc] init];
            lanmu.sLanmuName = pickJsonStrValue(dic, @"classname");
            if (lanmu.sLanmuName ) {
                [arr addObject:lanmu];
            }
            [lanmu release];
        }
    }
    int i;
    if ( [arr count] ) {
        [BizLogic cleanLanmuList];
        i = [BizLogic insertLanmuListByUserName:arr];
    }
}

-(void)getJYEXLanmuListEnd:(id)err
{
    if (err && [err isKindOfClass:[NSError class]])
    {
        if ( retObj && [retObj respondsToSelector:retFunc])
        {
            [retObj  performSelector:retFunc withObject:err];
        }
        return;
    }
    [self getJYEXClassList];
}



//*** 登录第5步(获取班级信息列表)
-(void)getJYEXClassList
{
    iLoginStatus = 5; //获取用户的班级列表
    
    NSString* url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=friend&ac=classList"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(getJYEXClassListEnd:)];
}

-(void)getJYEXClassListEnd:(id)err
{
    if ( retObj && [retObj respondsToSelector:retFunc])
    {
        [retObj  performSelector:retFunc withObject:err];
    }
}

//*** 登录第5步解析(获取班级信息列表)
-(void)UnPackLoginJYEXClassListJsonStr:(NSDictionary*) jsObj
{
    if ( !jsObj )
	{
		return;
	}
    NSLog(@"%@\r\n", [jsObj description]);
    NSEnumerator *enumerator = [jsObj objectEnumerator];
    
    NSDictionary *dic = nil;
    TJYEXClass *classInfo = nil;
    NSMutableArray *arr = [NSMutableArray array];
    while ( dic = (NSDictionary *)[enumerator nextObject] ) {
        classInfo = [[TJYEXClass alloc] init];
        classInfo.sClassId = pickJsonStrValue(dic, @"uid");
        classInfo.sClassName = pickJsonStrValue(dic, @"username");
        [arr addObject:classInfo];
        [classInfo release];
    }
    int i;
    if ( [arr count] ) {
        [BizLogic cleanClassList];
        i = [BizLogic insertClassListByUserName:arr];
    }
}
@end



#pragma mark -
#pragma mark 家园E线在线更新
@implementation BussJYEXSoftUpdata
@synthesize retObj;
@synthesize retFunc;
-(void) getSoftInfoFromVersion:(NSString*)sSoftID ResponseTarget:(id) target ResponseSelector:(SEL) selector
{
    self.delgtPackData = self;
	self.retObj = target;
	self.retFunc = selector;
	NSString* url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", sSoftID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(getSoftInfoFromVersionEnd:)];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
    NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		//LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		//LOG_ERROR(@"登录：收到数据预处理错误");
		return NO;
	}
	
    [self UnPackLoginJYEXSoftUpdataJsonStr:objJson];
    return YES;
}

-(void)UnPackLoginJYEXSoftUpdataJsonStr:(NSDictionary*) jsObj
{
    if ( !jsObj )
	{
		return;
	}
    NSLog(@"%@\r\n", [jsObj description]);
    NSNumber *n = (NSNumber*) [jsObj objectForKey:@"resultCount"];
    if ( [n intValue] == 0  ) {
        return;
    }
    NSArray *array = (NSArray *)[jsObj objectForKey:@"results"];
    NSDictionary *dic = (NSDictionary *)[array objectAtIndex:0];
    NSString *strVersion = (NSString *)[dic objectForKey:@"version"];
    
    NSString *strLocalVer = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    NSString *strUrl = (NSString *)[dic objectForKey:@"trackViewUrl"];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"itms://"];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"HTTPS://" withString:@"itms://"];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"itms://"];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"HTTP://" withString:@"itms://"];
    
    TheGlobal.sUpdataSoftUrl = strUrl;
    
    NSComparisonResult compResult = [BussCheckVersion compareVersion:strVersion :strLocalVer];
    if ( NSOrderedDescending == compResult  ) {
        [TheGlobal setUpdataSoftFlag];
    }
    else
    {
        [TheGlobal resetUpdataSoftFlag];
    }
}

-(void)getSoftInfoFromVersionEnd:(id)err
{
    if ( retObj && [retObj respondsToSelector:retFunc])
    {
        [retObj  performSelector:retFunc withObject:err];
    }
}


-(NSString*) PackSendOutJsonString
{
	return @"";
}


@end


#pragma mark -
#pragma mark 家园E线 查询更新文章数
@implementation BussJYEXGetUpdateNumber

-(void)dealloc
{    
	[super dealloc];
}


-(void)getUpdateNumber:(int)dateline ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
 
    //NSString* param = [NSString stringWithFormat:@"mobile.php?mod=article_total&dateline=%d",dateline];
    NSString* param = [NSString stringWithFormat:@"mobile.php?mod=article_total_v5&dateline=%d",dateline];
    NSString* url = [BussInterImplBase makeQueryURLWithCgi:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}


-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 登出
@implementation BussLogout

@synthesize sSID;

-(void)dealloc
{
	self.sSID = nil;
	[super dealloc];
}

-(void) Logout:(NSString*)sessID ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	if ([PubFunction stringIsNullOrEmpty:sessID])
	{
		return;
	}
	
	self.sSID = sessID;
	
	NSString* url = [BussInterImplBase makeQueryURLWithCgiSID:@"logout" UserSID:self.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}


-(NSString*) PackSendOutJsonString
{
	NSMutableDictionary* obj = [NSMutableDictionary dictionary];
	if ( !obj )
		return @"";
	
	[obj setObject:CS_SOFT_ID forKey:@"vercode"];
	
	NSString* strJson = [obj JSONRepresentation];
	return strJson;
}


-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
	//LOG_DEBUG(@"返回数据：%@", rcvData);
	NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"登出：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		LOG_ERROR(@"登出：收到数据预处理错误");
		return NO;
	}
	

	//更新数据库
	TLoginUserInfo* user = [AstroDBMng getLoginUserBySID:self.sSID];
	if (user)
	{
		LOG_DEBUG(@"用户(name=%@, uid=%@)登出成功", user.sUserName, user.sUserID);
		user.sSID = @"";
		user.iLoginType = ELoginType_OffLine;
		[AstroDBMng replaceLoginUser:user];
	}
	
	if( [TheCurUser.sSID isEqualToString:self.sSID] )
	{
		TheCurUser.sSID = @"";
		TheCurUser.iLoginType = ELoginType_OffLine;
	}
	
	return YES;
}

@end

#pragma mark -
#pragma mark 验证session
@implementation BussCheckSession

@synthesize sSID;

-(void)dealloc
{
	self.sSID = nil;
	[super dealloc];
}


-(void) checkSession:(NSString*)sessID ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	if ([PubFunction stringIsNullOrEmpty:sessID])
	{
		return;
	}
	
	TLoginUserInfo* user = [AstroDBMng getLoginUserBySID:sessID];
	if (!user || [PubFunction stringIsNullOrEmpty:user.sSID])
	{
		return;
	}
	
	self.sSID = sessID;
	
	NSString* url;
#ifdef TARGET_IPHONE_SIMULATOR
	#if ACCESS_OUTER_SERVICE
		url = [NSString stringWithFormat:@"%@checksession?sid=%@", CS_CHECKSESSION_URLBASE_OUT, sessID];
	#else
		url = [NSString stringWithFormat:@"%@checksession?sid=%@", CS_CHECKSESSION_URLBASE_IN, sessID];
	#endif
#else
	url = [NSString stringWithFormat:@"%@checksession?sid=%@", CS_CHECKSESSION_URLBASE_OUT, sessID];
#endif

	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
	//LOG_DEBUG(@"返回数据：%@", rcvData);
	NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"验证SID：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		LOG_ERROR(@"验证SID：收到数据预处理错误");
		return NO;
	}
	
	return YES;
}


@end



#pragma mark -
#pragma mark 注册新用户
@implementation BussRegisterUser
@synthesize UserName, Password, NickName;

-(void)dealloc
{
	self.UserName = nil;
	self.Password = nil;
	self.NickName = nil;
	[super dealloc];
}

-(void) registerUser:(NSString*)userName Password:(NSString*)password Nickname:(NSString*)nickname RespTarget:(id)target RespSelector:(SEL)selector
{
	self.delgtPackData = self;
	self.UserName = userName;
	self.Password = password;
	self.NickName = nickname;
	
	NSString* url = @"";
	NSString* cginame = @"user";
#ifdef TARGET_IPHONE_SIMULATOR
	#if ACCESS_OUTER_SERVICE
		url = [CS_REG_URLBASE_OUT stringByAppendingString:cginame];
	#else
		url = [CS_REG_URLBASE_IN stringByAppendingString:cginame];
	#endif
#else
	url = [CS_REG_URLBASE_OUT stringByAppendingString:cginame];
#endif
	
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	
	NSMutableDictionary* jobjUser = [NSMutableDictionary dictionary];
	if ( jobjUser )
	{
		[jobjUser setObject:self.UserName forKey:@"username"];
		[jobjUser setObject:self.Password forKey:@"password"];
		[jobjUser setObject:self.NickName forKey:@"nickname"];
	}
	
	NSString* strJson = [jobjUser JSONRepresentation];
	return strJson;
}


-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err
{
	//LOG_DEBUG(@"注册请求返回数据：%@", rcvData);
	NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"注册：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"注册：收到数据预处理错误");
		return NO;
	}
	
	return YES;
}

@end


#pragma mark -
#pragma mark 流日/流月一句话运势
@implementation BussFlowYS

@synthesize dataIn;
@synthesize sReqDate;
@synthesize iYsType;

-(void) dealloc
{
	self.dataIn = nil;
	self.sReqDate = nil;
	
	[super dealloc];
}

-(void) reqFlowYS_Day:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iYsType = EYunshiTypeLiuri;
	[self DoHttpRequest:userGuid Date:date ResponseTarget:target ResponseSelector:selector];
}

-(void) reqFlowYS_Month:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iYsType = EYunshiTypeLiuyue;
	[self DoHttpRequest:userGuid Date:date ResponseTarget:target ResponseSelector:selector];
}

-(void) DoHttpRequest:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//打包
	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
	if ( jobjPara )
	{
		[jobjPara setObject:[BussFlowYS PackJsonObjofPeplInfo:self.dataIn.pepInfo] forKey:@"pepInfo"];
		[jobjPara setObject:[BussFlowYS PackJsonObjofDateInfo:self.dataIn.dateInfo] forKey:@"dateInfo"];
        
        
	}
	
	int bssID = [self getBussIDByYsType];
    [jobjPara setObject:LANGCODE forKey:@"langcode"];
	return [self WrapJsonStringWithBussID:bssID DictData:jobjPara];
}

-(int) getBussIDByYsType
{
	switch (self.iYsType)
	{
		case EYunshiTypeLiuri:			//流日
			return ASTRO_DZYS_GET_DAY_RESULT_EX;
			
		case EYunshiTypeLiuyue:			//流月
			return ASTRO_DZYS_GET_MONTH_RESULT_EX;
			
		default:
			break;
	}
	
	return 0;
}

+(NSDictionary*) PackJsonObjofPeplInfo:(TPeopleInfo*)pep
{
	if (!pep)
	{
		LOG_ERROR(@"发出命造参数构造失败。");
		return nil;
	}
	
	NSMutableDictionary* objPepInfo = [NSMutableDictionary dictionaryWithCapacity:0];
	if ( !objPepInfo )
	{
		LOG_ERROR(@"发出命造参数构造失败。");
		return nil;
	}
	
	[objPepInfo setObject:pep.sGuid forKey:@"dGuid"];
	[objPepInfo setObject:pep.sPersonName forKey:@"sPersonName"];
	[objPepInfo setObject:pep.sPersonTitle forKey:@"sPersonTitle"];
	[objPepInfo setObject:pep.sSex forKey:@"sSex"];
	[objPepInfo setObject:pep.sBirthplace forKey:@"sBirthplace"];
	[objPepInfo setObject:pep.sTimeZone forKey:@"sTimeZone"];
	[objPepInfo setObject:pep.sWdZone forKey:@"sWdZone"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iTimeZone] forKey:@"iTimeZone"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLongitude] forKey:@"iLongitude"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLongitude_ex] forKey:@"iLongitude_ex"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLatitude] forKey:@"iLatitude"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLatitude_ex] forKey:@"iLatitude_ex"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iDifRealTime] forKey:@"iDifRealTime"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.bIsHost] forKey:@"bIsHost"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.bIsDaZhong] forKey:@"iVerType"];
	[objPepInfo setObject:pep.sHeadImg forKey:@"sHeadPor"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.bLeap] forKey:@"bLeap"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iYear] forKey:@"iYear"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iMonth] forKey:@"iMonth"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iDay] forKey:@"iDay"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iHour] forKey:@"iHour"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iMinute] forKey:@"iMinute"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLlYear] forKey:@"iLlYear"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLlMonth] forKey:@"iLlMonth"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iLlDay] forKey:@"iLlDay"];
	[objPepInfo setObject:pep.sLlHour forKey:@"sLlHour"];
	[objPepInfo setObject:pep.sSaveUserInput forKey:@"sSaveUserInput"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.ipeopleId] forKey:@"ipeopleId"];
	[objPepInfo setObject:[NSNumber numberWithInt:pep.iGroupId] forKey:@"iGroupId"];
	
	return objPepInfo;

}

+(NSDictionary*) PackJsonObjofPeplInfoByGUID:(NSString*)userGUID
{
	TPeopleInfo* pep = nil;
	if ([TheCurPeople.sGuid compare:userGUID] == 0)
	{
		pep = TheCurPeople;
	}
	else
	{
		pep = [AstroDBMng getPeopleInfoBysGUID:userGUID];
	}

	return [BussFlowYS PackJsonObjofPeplInfo:pep];
}


+(NSDictionary*) PackJsonObjofDateInfo:(TDateInfo*)date
{
	NSMutableDictionary* objDate = [NSMutableDictionary dictionaryWithCapacity:0];
	if ( !objDate )
	{
		LOG_ERROR(@"发出日期参数构造失败。");
		return nil;
	}
	
	[objDate setObject:[NSNumber numberWithInt:date.year] forKey:@"year"];
	[objDate setObject:[NSNumber numberWithInt:date.month] forKey:@"month"];
	[objDate setObject:[NSNumber numberWithInt:date.day] forKey:@"day"];
	[objDate setObject:[NSNumber numberWithInt:date.hour] forKey:@"hour"];
	[objDate setObject:[NSNumber numberWithInt:date.minute] forKey:@"minute"];
	[objDate setObject:[NSNumber numberWithInt:date.isRunYue] forKey:@"isRunYue"];
	
	return objDate;
}


-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	//LOG_DEBUG(@"返回数据：%@", rcvData);
	NSDictionary* objJson = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&objJson HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"运势简评：收到数据预处理错误");
		return NO;
	}
	
	if (!objJson || *err)
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"运势简评：收到数据预处理错误");
		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:objJson];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
		LOG_ERROR(@"运势简评：收到数据预处理错误");
		return NO;
	}

	//保存数据
	[AstroDBMng replaceFlowYS:self.dataIn.pepInfo.sGuid YsType:self.iYsType Date:self.dataIn.dateInfo JsonData:sResponse];
	
	return YES;
}


+(BOOL) unpackFlowYSJson:(NSString*)sResponse DataOut:(TFlowYS*)data
{
	if ([PubFunction isObjNull:data])
	{
		return NO;
	}
	
	NSDictionary* objResp = [sResponse JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
	
	data.yunShi = [[TTITLE_EXP new] autorelease];
	data.yunShi.sTitle = pickJsonStrValue(objResp, @"sTitle");
	data.yunShi.sExplain = pickJsonStrValue(objResp, @"sExplain");
	
	return YES;
}

@end

#pragma mark -
#pragma mark 紫微运势
@implementation BussZiweiYunshi

@synthesize dataIn;
@synthesize sReqDate;
@synthesize iYsType;
@synthesize iLookFrom;

-(void) dealloc
{
	self.dataIn = nil;
	self.sReqDate = nil;
	
	[super dealloc];
}

//紫微今日运势
-(void) DoHttpRequestYunshi_Day:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iYsType = EYunshiTypeDay;
	self.iLookFrom = lkFr;
	self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
	[self DoHttpRequest:target ResponseSelector:selector];
}

//紫微本月运势
-(void) DoHttpRequestYunshi_Month:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iYsType = EYunshiTypeMonth;
	self.iLookFrom = lkFr;
	self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
	[self DoHttpRequest:target ResponseSelector:selector];
}

//紫微今年运势
-(void) DoHttpRequestYunshi_Year:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iYsType = EYunshiTypeYear;
	self.iLookFrom = lkFr;
	self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
	[self DoHttpRequest:target ResponseSelector:selector];
}

//财富趋势
-(void) DoHttpRequestMoneyFortune:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    self.iYsType = EMoneyFortune;
    self.iLookFrom = lkFr;
    self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
    [self DoHttpRequest:target ResponseSelector:selector];
}

-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(int) getBussIDByYsType
{
	switch (self.iYsType)
	{
		case EYunshiTypeDay:			//日
			return ASTRO_DZYS_GET_DAY_RESULT;
			
		case EYunshiTypeMonth:			//月
			return ASTRO_DZYS_GET_LIUYUE_RESULT;
			
		case EYunshiTypeYear:			//年
			return ASTRO_DZYS_GET_LIUNIAN_RESULT;
        
        case EMoneyFortune: //财富趋势
            return ASTRO_DZ_GET_CAIFU_RESULT;
		default:
			break;
	}
	
	return 0;
}

-(int) getConsumeItemByYsType
{
	switch (self.iYsType)
	{
		case EYunshiTypeDay:	//日
		case EYunshiTypeMonth:			//月
			return EConsumeItem_LiuriyueYs;
			
		case EYunshiTypeYear:			//年
			return EConsumeItem_LiunianYs;
			
		default:
			break;
	}
	
	return 0;
}


-(NSString*) PackSendOutJsonString
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//业务命令ID
	int bussID = [self getBussIDByYsType];
	[jObjRoot setObject:[NSNumber numberWithInt:bussID] forKey:@"comdcode"];
	
	//参数内容
	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
	if ( jobjPara )
	{
		[jobjPara setObject:[BussFlowYS PackJsonObjofPeplInfo:self.dataIn.pepInfo] forKey:@"pepInfo"];
		[jobjPara setObject:[BussFlowYS PackJsonObjofDateInfo:self.dataIn.dateInfo] forKey:@"dateInfo"];
	}
	[jObjRoot setObject:[jobjPara JSONRepresentation] forKey:@"paramcontent"];
	
    if ( self.iYsType != EMoneyFortune ) {
        
        //微博消费查看
        if (self.iLookFrom == EConsumeLookFrom_Blog)
        {
            int itemConsm = [self getConsumeItemByYsType];
            int ruldid = [BussConsume getRuleIDWithConsmItem:(EConsumeItem)itemConsm];
            if (ruldid > 0)
            {
                NSString* chkCode = [PubFunction makeCheckCode:ruldid];
                [jObjRoot setObject:chkCode forKey:@"chkcode"];
            }
        }
    }
    //转成字符串
    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
    
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
        if ( self.iYsType == EMoneyFortune ) {
            LOG_ERROR(@"龙易财富：收到数据预处理错误");
        }
        else
        {
            LOG_ERROR(@"紫微运势：收到数据预处理错误");
        }
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
        if ( self.iYsType == EMoneyFortune ) {
            LOG_ERROR(@"龙易财富：收到数据预处理错误");
        }
        else
        {
            LOG_ERROR(@"紫微运势：收到数据预处理错误");
        }

		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
        if ( self.iYsType == EMoneyFortune )
        {
            LOG_ERROR(@"龙易财富：收到数据预处理错误");
        }
        else
        {
            LOG_ERROR(@"运势：收到数据预处理错误");
        }
		
		return NO;
	}
	
	//TODO: 本地缓存
	[AstroDBMng replaceZwYs:self.dataIn.pepInfo.sGuid YsType:self.iYsType Date:self.dataIn.dateInfo JsonData:sResponse];
	
	return YES;
}

+(BOOL) unpackZwYsJson:(NSString*)sResponse DataOut:(TZWYS_FLOWYEAR_EXT*)data
{
	if (!data)
	{
		return NO;
	}
	
	NSDictionary* objResp = [sResponse JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
	
	// 农历以及对应公历时间标题--[例]农历2009【己丑】年 （公历 2009年2月4日 — 2010年2月12日）
	data.tZwYsExp = [[TDZYS_FLOWYEAR_EXP new] autorelease];
	data.tZwYsExp.sTimeTitle = pickJsonStrValue(objResp, @"sTimeTitle");
	
	// 简约命理信息
	NSDictionary* objdzFateInfo = [objResp objectForKey:@"dzFateInfo"];
	if(![PubFunction isObjNull:objdzFateInfo])
	{
		data.tZwYsExp.dzFateInfo = [[TDZYS_SIMPLE_FATE_INFO new] autorelease];
		data.tZwYsExp.dzFateInfo.sBzFate = pickJsonStrValue(objdzFateInfo, @"sBzFate");
		data.tZwYsExp.dzFateInfo.sBzFateExp = pickJsonStrValue(objdzFateInfo, @"sBzFateExp");
		data.tZwYsExp.dzFateInfo.sZwStar = pickJsonStrValue(objdzFateInfo, @"sZwStar");
		data.tZwYsExp.dzFateInfo.sZwStarExp = pickJsonStrValue(objdzFateInfo, @"sZwStarExp");
	}	
	
	// 下属各月或各天的吉凶指数
	id vecJxVal = [objResp objectForKey:@"vecChildJxValue"];
	if ( ![PubFunction isArrayEmpty:vecJxVal] )
	{
		data.tZwYsExp.vecChildJxValue = [NSMutableArray array];
		NSArray* aryChildJxValue = (NSArray*)vecJxVal;
		for (id obj in aryChildJxValue)
		{
			NSDictionary* objJxValue  = (NSDictionary*)obj;
			if ([PubFunction isObjNull:objJxValue])
			{
				continue;
			}
			
			TDZYS_EVERY_JX_VALUE *jxval = [[TDZYS_EVERY_JX_VALUE new] autorelease];
			[data.tZwYsExp.vecChildJxValue addObject:jxval];
			
			jxval.sDateTile    = pickJsonStrValue(objJxValue, @"sDateTile");
			jxval.sDateTileExp = pickJsonStrValue(objJxValue, @"sDateTileExp");
			jxval.iJxValue     = pickJsonIntValue(objJxValue, @"iJxValue");
		}

	}
	
	// 各项解释
	id vecYs = [objResp objectForKey:@"vecYunShiExp"];
	if (![PubFunction isArrayEmpty:vecYs])
	{
		data.tZwYsExp.vecYunShiExp = [NSMutableArray array];
		NSArray* aryYunShiExp = (NSArray*)vecYs;
		for (id obj in aryYunShiExp)
		{
			NSDictionary* objTTExp = (NSDictionary*)obj;
			if ([PubFunction isObjNull:objTTExp])
			{
				continue;
			}

			TTITLE_EXP *ttexp = [[TTITLE_EXP new] autorelease];
			[data.tZwYsExp.vecYunShiExp addObject:ttexp];
			
			ttexp.sTitle = pickJsonStrValue(objTTExp, @"sTitle");
			ttexp.sExplain = pickJsonStrValue(objTTExp, @"sExplain");
		}
	}
	
	// 各个宫吉凶指数
	NSDictionary* objPalace = [objResp objectForKey:@"palaceValue"];
	if(![PubFunction isObjNull:objPalace])
	{
		data.tZwYsExp.palaceValue = [[TPALACE_JXVALUE_FORMOBILE new] autorelease];
		data.tZwYsExp.palaceValue.iFlowCaiBoGValue = pickJsonIntValue(objPalace, @"iFlowCaiBoGValue", -1);
		data.tZwYsExp.palaceValue.iFlowFuDeGValue = pickJsonIntValue(objPalace, @"iFlowFuDeGValue", -1);
		data.tZwYsExp.palaceValue.iFlowFuMuGValue = pickJsonIntValue(objPalace, @"iFlowFuMuGValue", -1);
		data.tZwYsExp.palaceValue.iFlowFuQiGValue = pickJsonIntValue(objPalace, @"iFlowFuQiGValue", -1);
		data.tZwYsExp.palaceValue.iFlowGuanLuGValue = pickJsonIntValue(objPalace, @"iFlowGuanLuGValue", -1);
		data.tZwYsExp.palaceValue.iFlowJiErGValue = pickJsonIntValue(objPalace, @"iFlowJiErGValue", -1);
		data.tZwYsExp.palaceValue.iFlowMingGValue = pickJsonIntValue(objPalace, @"iFlowMingGValue", -1);
		data.tZwYsExp.palaceValue.iFlowPuYiGValue = pickJsonIntValue(objPalace, @"iFlowPuYiGValue", -1);
		data.tZwYsExp.palaceValue.iFlowQianYiGValue = pickJsonIntValue(objPalace, @"iFlowQianYiGValue", -1);
		data.tZwYsExp.palaceValue.iFlowTianZaiGValue = pickJsonIntValue(objPalace, @"iFlowTianZaiGValue", -1);
		data.tZwYsExp.palaceValue.iFlowXiongDiGValue = pickJsonIntValue(objPalace, @"iFlowXiongDiGValue", -1);
		data.tZwYsExp.palaceValue.iFlowZiNvGValue = pickJsonIntValue(objPalace, @"iFlowZiNvGValue", -1);
	}
	
	return YES;
}

+(BOOL) unpackLYSMJson:(NSString*)sResponse DataOut:(TLYSM_MONEYFORTUNE_EXT*)data
{
    if (!data)
	{
		return NO;
	}
	
	NSDictionary* objResp = [sResponse JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
    NSArray *array
    = (NSArray *)[objResp objectForKey:@"vecShiShenPower"];
    NSUInteger i;
    for ( i = 0; i < [array count]; ++i ) {
        data->inforMingLi[ i ]
        = [((NSNumber*)[array objectAtIndex:i]) floatValue];
    }
    
    array = (NSArray *)[objResp objectForKey:@"vecSiZhu"];
    data.vecShiZhu = [NSMutableArray array];
    for ( i = 0; i < [array count]; ++i ) {
        [data.vecShiZhu addObject:[array objectAtIndex:i]];
    }
    
    data.sMainStar = pickJsonStrValue(objResp, @"sZiWeiMainStar");
    data.sBzCaifuInfo = pickJsonStrValue(objResp, @"sBzCaifuInfo");
    
    data.sBzCaifuInfo = pickJsonStrValue(objResp, @"sBzCaifuInfo");
    data.sZwCaifuInfo = pickJsonStrValue(objResp, @"sZwCaifuInfo");
    data.sZwCBGExp = pickJsonStrValue(objResp, @"sZwCBGExp");
    
    data->iRichValue = pickJsonIntValue(objResp, @"iRichValue", 0);
    data->iGetMoneyPower = pickJsonIntValue(objResp, @"iGetMoneyPower", 0);
    data.sRichValueExp = pickJsonStrValue(objResp, @"sRichValueExp");
    
    data.sCaifuAttitude = pickJsonStrValue(objResp, @"sCaifuAttitude");
    
    data.sCaifuType = pickJsonStrValue(objResp, @"sCaifuType");
    
    data.vecUserCFValue = [NSMutableArray array];
    array = (NSArray*)[objResp objectForKey:@"vecUserCFValue"];
    
    for (i = 0;  i < [array count]; ++i ) {
        [data.vecUserCFValue addObject:[array objectAtIndex:i]];
    }
    data->iCurveBeginYear = pickJsonIntValue(objResp, @"iCurveBeginYear", 0);
    data.vecTrapForMoney = [NSMutableArray array];
    array = (NSArray*)[objResp objectForKey:@"vecTrapForMoney"];
    for ( i = 0; i < [array count]; ++i ) {
        [data.vecTrapForMoney addObject:[array objectAtIndex:i]];
    }
    
    NSDictionary *dic = (NSDictionary*)[objResp objectForKey:@"sEarnAndCoop"];
    data.sCooperateFromBiJie = pickJsonStrValue(dic, @"sCooperateFromBiJie");
    data.sShengXiaoGood = pickJsonStrValue(dic, @"sShengXiaoGood");
    data.sShengXiaoBad = pickJsonStrValue(dic, @"sShengXiaoBad");
    
    data.sQiuCaiSuggest = pickJsonStrValue(dic, @"sQiuCaiSuggest");
    data.sQiuCaiPossion = pickJsonStrValue(dic, @"sQiuCaiPossion");
    data.sLuckyColor = pickJsonStrValue(dic, @"sLuckyColor");
    
    return YES;
}
@end

//#pragma mark -
//#pragma mark 财富趋势
//@implementation BussMoneyFortune
//@synthesize dataIn;
//@synthesize sReqDate;
//
//-(void) dealloc
//{
//	self.dataIn = nil;
//	self.sReqDate = nil;
//	
//	[super dealloc];
//}
//
//-(void) DoHttpRequestMoneyFortune:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector
//{
//    self.dataIn = [[TYunShiParam new] autorelease];
//	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
//	self.dataIn.dateInfo = date;
//    [self DoHttpRequest:target ResponseSelector:selector];
//}
//
//-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector
//{
//    super.delgtPackData = self;
//	
//	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
//	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
//}
//
//-(NSString*) PackSendOutJsonString
//{
//	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
//	if ( !jObjRoot )
//		return @"";
//	
//	//请求时间
//	self.sReqDate = [PubFunction getTimeStr1];
//	
//	//业务命令ID
//	int bussID = ASTRO_DZ_GET_CAIFU_RESULT;
//	[jObjRoot setObject:[NSNumber numberWithInt:bussID] forKey:@"comdcode"];
//	
//	//参数内容
//	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
//	if ( jobjPara )
//	{
//		[jobjPara setObject:[BussFlowYS PackJsonObjofPeplInfo:self.dataIn.pepInfo] forKey:@"pepInfo"];
//		[jobjPara setObject:[BussFlowYS PackJsonObjofDateInfo:self.dataIn.dateInfo] forKey:@"dateInfo"];
//	}
//	[jObjRoot setObject:[jobjPara JSONRepresentation] forKey:@"paramcontent"];
//	
//	//微博消费查看
////	if (self.iLookFrom == EConsumeLookFrom_Blog)
////	{
////		int itemConsm = [self getConsumeItemByYsType];
////		int ruldid = [BussConsume getRuleIDWithConsmItem:(EConsumeItem)itemConsm];
////		if (ruldid > 0)
////		{
////			NSString* chkCode = [PubFunction makeCheckCode:ruldid];
////			[jObjRoot setObject:chkCode forKey:@"chkcode"];
////		}
////	}
//	
//	//转成字符串
////    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
//	NSString* strJson = [jObjRoot JSONRepresentation];
//	return strJson;
//}
//
//-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
//{
//	NSDictionary* jsobj = nil;
//	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
//	{
//		LOG_ERROR(@"龙易财富：收到数据预处理错误");
//		return NO;
//	}
//	
//	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
//	{
//		if (self.iHttpCode == 200)
//		{
//			*err = nil;
//			return YES;
//		}
//		
//		LOG_ERROR(@"龙易财富：收到数据预处理错误");
//		return NO;
//	}
//	
//	//解析
//	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
//	if ([PubFunction stringIsNullOrEmpty:sResponse])
//	{
//		LOG_ERROR(@"龙易财富：收到数据预处理错误");
//		return NO;
//	}
//	
//	//TODO: 本地缓存
////	[AstroDBMng replaceZwYs:self.dataIn.pepInfo.sGuid YsType:self.iYsType Date:self.dataIn.dateInfo JsonData:sResponse];
//	
//	return YES;
//}
//
//@end

#pragma mark -
#pragma mark 事业成长
@implementation BussShiYeYunshi

@synthesize dataIn;
@synthesize sReqDate;
//@synthesize iYsType;
//@synthesize iLookFrom;

-(void) dealloc
{
	self.dataIn = nil;
	self.sReqDate = nil;
	
	[super dealloc];
}

//事业成长
-(void) DoHttpRequestYunshi_Career:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.dataIn = [[TYunShiParam new] autorelease];
	self.dataIn.pepInfo = [AstroDBMng getPeopleInfoBysGUID:userGuid];
	self.dataIn.dateInfo = date;
	[self DoHttpRequest:target ResponseSelector:selector];
}


-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}


-(NSString*) PackSendOutJsonString
{
	NSMutableDictionary* jObjRoot = [NSMutableDictionary dictionary];
	if ( !jObjRoot )
		return @"";
	
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//业务命令ID
	int bussID = ASTRO_DZ_GET_SHIYE_RESULT;
	[jObjRoot setObject:[NSNumber numberWithInt:bussID] forKey:@"comdcode"];
	
	//参数内容
	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
	if ( jobjPara )
	{
		[jobjPara setObject:[BussFlowYS PackJsonObjofPeplInfo:self.dataIn.pepInfo] forKey:@"pepInfo"];
		[jobjPara setObject:[BussFlowYS PackJsonObjofDateInfo:self.dataIn.dateInfo] forKey:@"dateInfo"];
	}
	[jObjRoot setObject:[jobjPara JSONRepresentation] forKey:@"paramcontent"];
	
	
	//转成字符串
    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"事业成长：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"事业成长：收到数据预处理错误");
		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
		LOG_ERROR(@"事业成长：收到数据预处理错误");
		return NO;
	}
	
	//TODO: 本地缓存
	[AstroDBMng replaceZwYs:self.dataIn.pepInfo.sGuid YsType:EYunshiTypeCareer Date:self.dataIn.dateInfo JsonData:sResponse];
	
	return YES;
}

+(BOOL) unpackZwYsJson:(NSString*)sResponse DataOut:(TSYYS_EXT*)data
{
	if (!data)
	{
		return NO;
	}
	
	NSDictionary* objResp = [sResponse JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
	
	data.tSyYs = [[TSYYS new] autorelease];
	data.tSyYs.sBestCareerType = pickJsonStrValue(objResp, @"sBestCareerType");
    data.tSyYs.sBestWordReason = pickJsonStrValue(objResp, @"sBestWordReason");
    data.tSyYs.sBestWork = pickJsonStrValue(objResp, @"sBestWork");
    data.tSyYs.sBetterWork = pickJsonStrValue(objResp, @"sBetterWork");
    data.tSyYs.sBetterWorkReason = pickJsonStrValue(objResp, @"sBetterWorkReason");
    data.tSyYs.sShiYeZongPing = pickJsonStrValue(objResp, @"sShiYeZongPing");
    data.tSyYs.sWorkQianZhi = pickJsonStrValue(objResp, @"sWorkQianZhi");
    data.tSyYs.sZhuYiShiXiang = pickJsonStrValue(objResp, @"sZhuYiShiXiang");
    data.tSyYs.sZiWeiMainStar = pickJsonStrValue(objResp, @"sZiWeiMainStar");
    
    
	// shishen力量数值
	id vecArray1 = [objResp objectForKey:@"vecShiShenPower"];
	if ( ![PubFunction isArrayEmpty:vecArray1] )
	{
		data.tSyYs.vecShiShenPower = (NSMutableArray*)vecArray1;
	}
	
	// shishen力量数值
	id vecArray2 = [objResp objectForKey:@"vecSiZhu"];
	if ( ![PubFunction isArrayEmpty:vecArray2] )
	{
		data.tSyYs.vecSiZhu = (NSMutableArray*)vecArray2;
	}

    // shishen力量数值
	id vecArray3 = [objResp objectForKey:@"vecWorkBestYear"];
	if ( ![PubFunction isArrayEmpty:vecArray3] )
	{
		data.tSyYs.vecWorkBestYear = (NSMutableArray*)vecArray3;
	}
	
    // shishen力量数值
	id vecArray4 = [objResp objectForKey:@"vecWorkWorstYear"];
	if ( ![PubFunction isArrayEmpty:vecArray4] )
	{
		data.tSyYs.vecWorkWorstYear = (NSMutableArray*)vecArray4;
	}
    
	return YES;
}

@end
/*
#pragma mark -
#pragma mark 在线天气
@implementation BussWeather

@synthesize iBussID, sCityCode, sReqDate, dataOut;

-(void)dealloc
{
	self.sCityCode = nil;
	self.sReqDate = nil;
	self.dataOut = nil;
	
	[super dealloc];
}

-(void) DoRequestWeather:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	
	NSString *url = [self makeReqUrlByBussID];
	NSLog(@"%@", url);
	EHttpMethod hm = [self decideHttpMethod];
	[self HttpRequest:url Method:hm ResponseTarget:target ResponseSelector:selector];
}

-(void) ReqImWeatherFromCn:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = EWeaType_WeaCn_IM;
	self.sCityCode = cityCode;
	[self DoRequestWeather:target ResponseSelector:selector];
}

-(void) ReqWkWeatherFromCn:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = EWeaType_WeaCn;
	self.sCityCode = cityCode;
	[self DoRequestWeather:target ResponseSelector:selector];
}

-(void) ReqImWeatherFrom91:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = EWeaType_91Srv_IM;
	self.sCityCode = cityCode;
	[self DoRequestWeather:target ResponseSelector:selector];
}

-(void) ReqWkWeatherFrom91:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = EWeaType_91Srv;
	self.sCityCode = cityCode;
	[self DoRequestWeather:target ResponseSelector:selector];
}


-(NSString*) makeReqUrlByBussID
{
	switch (iBussID)
	{
		case EWeaType_WeaCn_IM:
			return [NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html", sCityCode];
			
		case EWeaType_WeaCn:
			return [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", sCityCode];
			
		case EWeaType_91Srv_IM:
		case EWeaType_91Srv:
			return @"http://api.weather.rj.91.com/getweatherjson";
			
		default:
			break;
	}
	
	return @"";
}

-(EHttpMethod) decideHttpMethod
{
	switch (iBussID)
	{
		case EWeaType_WeaCn_IM:
		case EWeaType_WeaCn:
			return HTTP_METHOD_NULL;
			
		case EWeaType_91Srv_IM:
		case EWeaType_91Srv:
			return HTTP_METHOD_POST;
			
		default:
			break;
	}
	
	return HTTP_METHOD_NULL;
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//打包
	switch (iBussID)
	{
		case EWeaType_WeaCn_IM:
		case EWeaType_WeaCn:
			return @"";
			
		case EWeaType_91Srv_IM:
			return [NSString stringWithFormat:@"{\"citycode\":\"%@\",\"option\":\"now\"}", sCityCode];
			
		case EWeaType_91Srv:
			return [NSString stringWithFormat:@"{\"citycode\":\"%@\",\"option\":\"all\"}", sCityCode];
			
		default:
			break;
	}
	
	return nil;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"天气：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || (err && ![PubFunction isObjNull:*err]) )
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"天气：收到数据预处理错误");
		return NO;
	}
	
//	//解析
//	if (iBussID == EWeaType_WeaCn_IM || iBussID == EWeaType_91Srv_IM)
//	{
//		if(!dataOut)
//		{
//			dataOut = [TIMWeather_Ext new];
//			//附上时间
//			((TIMWeather_Ext*)dataOut).sDataTime = self.sReqDate;
//		}
//	}
//	else if (iBussID == EWeaType_WeaCn || iBussID == EWeaType_91Srv)
//	{
//		if(!dataOut)
//		{
//			dataOut = [TWeekdayWeather_Ext new];
//		}
//		//附上时间
//		((TWeekdayWeather_Ext*)dataOut).sDataTime = self.sReqDate;
//	}
//	
//	if ([BussWeather unpackWeatherJson:iBussID JsonData:jsobj DataOut:dataOut])
	{	
		
		//TODO: 本地缓存
		//解析
		if (iBussID == EWeaType_WeaCn_IM || iBussID == EWeaType_91Srv_IM)
		{
			[AstroDBMng replaceImWeather:sCityCode Data:rcvData Time:self.sReqDate];
		}
		else if (iBussID == EWeaType_WeaCn || iBussID == EWeaType_91Srv)
		{
			[AstroDBMng replaceWkWeather:sCityCode Data:rcvData Time:self.sReqDate];
		}
	}
	
	return YES;
}

+(BOOL) unpackWeatherJson:(EWeatherBussType)dataType JsonData:(NSDictionary*)jsObjRoot DataOut:(id) dout
{
	if ([PubFunction isObjNull:dout])
	{
		return NO;
	}
	
	NSDictionary* weaInfo = [jsObjRoot objectForKey:@"weatherinfo"];
	if ([PubFunction isObjNull:weaInfo])
	{
		return NO;
	}
	
	
	if (dataType == EWeaType_WeaCn_IM || dataType == EWeaType_91Srv_IM)
	{
		TIMWeather_Ext* data = (TIMWeather_Ext*)dout;
		if ( !data )
		{
			return NO;
		}
		
		data.imWeather.city = pickJsonStrValue(weaInfo, @"city");
		data.imWeather.cityid = pickJsonStrValue(weaInfo, @"cityid");
		data.imWeather.temp = pickJsonStrValue(weaInfo, @"temp");
		data.imWeather.WD = pickJsonStrValue(weaInfo, @"WD");
		data.imWeather.WS = pickJsonStrValue(weaInfo, @"WS");
		data.imWeather.SD = pickJsonStrValue(weaInfo, @"SD");
		data.imWeather.WSE = pickJsonStrValue(weaInfo, @"WSE");
		data.imWeather.time = pickJsonStrValue(weaInfo, @"time");
		data.imWeather.isRadar = pickJsonStrValue(weaInfo, @"isRadar");
		data.imWeather.Radar = pickJsonStrValue(weaInfo, @"Radar");
		
		return YES;
	}
	else if (dataType == EWeaType_WeaCn || dataType == EWeaType_91Srv)
	{
		TWeekdayWeather_Ext* data = (TWeekdayWeather_Ext*)dout;
		if ( !data )
		{
			return NO;
		}
		
		data.wkWeather.city = pickJsonStrValue(weaInfo, @"city");
		data.wkWeather.city_en = pickJsonStrValue(weaInfo, @"city_en");
		data.wkWeather.date_y = pickJsonStrValue(weaInfo, @"date_y");
		data.wkWeather.date = pickJsonStrValue(weaInfo, @"date");
		data.wkWeather.week = pickJsonStrValue(weaInfo, @"week");
		data.wkWeather.fchh = pickJsonStrValue(weaInfo, @"fchh");
		data.wkWeather.cityid = pickJsonStrValue(weaInfo, @"cityid");
		data.wkWeather.temp1 = pickJsonStrValue(weaInfo, @"temp1");
		data.wkWeather.temp2 = pickJsonStrValue(weaInfo, @"temp2");
		data.wkWeather.temp3 = pickJsonStrValue(weaInfo, @"temp3");
		data.wkWeather.temp4 = pickJsonStrValue(weaInfo, @"temp4");
		data.wkWeather.temp5 = pickJsonStrValue(weaInfo, @"temp5");
		data.wkWeather.temp6 = pickJsonStrValue(weaInfo, @"temp6");
		data.wkWeather.tempF1 = pickJsonStrValue(weaInfo, @"tempF1");
		data.wkWeather.tempF2 = pickJsonStrValue(weaInfo, @"tempF2");
		data.wkWeather.tempF3 = pickJsonStrValue(weaInfo, @"tempF3");
		data.wkWeather.tempF4 = pickJsonStrValue(weaInfo, @"tempF4");
		data.wkWeather.tempF5 = pickJsonStrValue(weaInfo, @"tempF5");
		data.wkWeather.tempF6 = pickJsonStrValue(weaInfo, @"tempF6"); 
		data.wkWeather.weather1 = pickJsonStrValue(weaInfo, @"weather1");
		data.wkWeather.weather2 = pickJsonStrValue(weaInfo, @"weather2");
		data.wkWeather.weather3 = pickJsonStrValue(weaInfo, @"weather3");
		data.wkWeather.weather4 = pickJsonStrValue(weaInfo, @"weather4");
		data.wkWeather.weather5 = pickJsonStrValue(weaInfo, @"weather5");
		data.wkWeather.weather6 = pickJsonStrValue(weaInfo, @"weather6");
		data.wkWeather.img1 = pickJsonStrValue(weaInfo, @"img1");
		data.wkWeather.img2 = pickJsonStrValue(weaInfo, @"img2");
		data.wkWeather.img3 = pickJsonStrValue(weaInfo, @"img3");
		data.wkWeather.img4 = pickJsonStrValue(weaInfo, @"img4");
		data.wkWeather.img5 = pickJsonStrValue(weaInfo, @"img5");
		data.wkWeather.img6 = pickJsonStrValue(weaInfo, @"img6");		
		data.wkWeather.img7 = pickJsonStrValue(weaInfo, @"img7");
		data.wkWeather.img8 = pickJsonStrValue(weaInfo, @"img8");
		data.wkWeather.img9 = pickJsonStrValue(weaInfo, @"img9");
		data.wkWeather.img10 = pickJsonStrValue(weaInfo, @"img10");
		data.wkWeather.img11 = pickJsonStrValue(weaInfo, @"img11");
		data.wkWeather.img12 = pickJsonStrValue(weaInfo, @"img12");
		
		data.wkWeather.img_single = pickJsonStrValue(weaInfo, @"img_single");
		data.wkWeather.img_title1 = pickJsonStrValue(weaInfo, @"img_title1");
		data.wkWeather.img_title2 = pickJsonStrValue(weaInfo, @"img_title2");
		data.wkWeather.img_title3 = pickJsonStrValue(weaInfo, @"img_title3");
		data.wkWeather.img_title4 = pickJsonStrValue(weaInfo, @"img_title4");
		data.wkWeather.img_title5 = pickJsonStrValue(weaInfo, @"img_title5");		
		data.wkWeather.img_title6 = pickJsonStrValue(weaInfo, @"img_title6");
		data.wkWeather.img_title7 = pickJsonStrValue(weaInfo, @"img_title7");
		data.wkWeather.img_title8 = pickJsonStrValue(weaInfo, @"img_title8");
		data.wkWeather.img_title9 = pickJsonStrValue(weaInfo, @"img_title9");
		data.wkWeather.img_title10 = pickJsonStrValue(weaInfo, @"img_title10");
		data.wkWeather.img_title11 = pickJsonStrValue(weaInfo, @"img_title11");
		data.wkWeather.img_title12 = pickJsonStrValue(weaInfo, @"img_title12");
		data.wkWeather.img_title_single = pickJsonStrValue(weaInfo, @"img_title_single");
		
		data.wkWeather.wind1 = pickJsonStrValue(weaInfo, @"wind1");
		data.wkWeather.wind2 = pickJsonStrValue(weaInfo, @"wind2");
		data.wkWeather.wind3 = pickJsonStrValue(weaInfo, @"wind3");
		data.wkWeather.wind4 = pickJsonStrValue(weaInfo, @"wind4");
		data.wkWeather.wind5 = pickJsonStrValue(weaInfo, @"wind5");
		data.wkWeather.wind6 = pickJsonStrValue(weaInfo, @"wind6");		
		data.wkWeather.fx1 = pickJsonStrValue(weaInfo, @"fx1");
		data.wkWeather.fx2 = pickJsonStrValue(weaInfo, @"fx2");
		data.wkWeather.fl1 = pickJsonStrValue(weaInfo, @"fl1");
		data.wkWeather.fl2 = pickJsonStrValue(weaInfo, @"fl2");
		data.wkWeather.fl3 = pickJsonStrValue(weaInfo, @"fl3");
		data.wkWeather.fl4 = pickJsonStrValue(weaInfo, @"fl4");	
		data.wkWeather.fl5 = pickJsonStrValue(weaInfo, @"fl5");
		data.wkWeather.fl6 = pickJsonStrValue(weaInfo, @"fl6");		
		
		data.wkWeather.index = pickJsonStrValue(weaInfo, @"index");
		data.wkWeather.index_d = pickJsonStrValue(weaInfo, @"index_d");
		data.wkWeather.index48 = pickJsonStrValue(weaInfo, @"index48");
		data.wkWeather.index48_d = pickJsonStrValue(weaInfo, @"index48_d");
		data.wkWeather.index_uv = pickJsonStrValue(weaInfo, @"index_uv");
		data.wkWeather.index48_uv = pickJsonStrValue(weaInfo, @"index48_uv");	
		data.wkWeather.index_xc = pickJsonStrValue(weaInfo, @"index_xc");
		data.wkWeather.index_tr = pickJsonStrValue(weaInfo, @"index_tr");
		data.wkWeather.index_co = pickJsonStrValue(weaInfo, @"index_co");
		data.wkWeather.st1 = pickJsonStrValue(weaInfo, @"st1");
		data.wkWeather.st2 = pickJsonStrValue(weaInfo, @"st2");
		data.wkWeather.st3 = pickJsonStrValue(weaInfo, @"st3");	
		data.wkWeather.st4 = pickJsonStrValue(weaInfo, @"st4");
		data.wkWeather.st5 = pickJsonStrValue(weaInfo, @"st5");
		data.wkWeather.st6 = pickJsonStrValue(weaInfo, @"st6");
		data.wkWeather.index_cl = pickJsonStrValue(weaInfo, @"index_cl");
		data.wkWeather.index_ls = pickJsonStrValue(weaInfo, @"index_ls"); 	
		
		data.wkWeather.imgToday = data.wkWeather.img1;
		
		if ([data.wkWeather.img2 isEqual:@"99"])
			data.wkWeather.img2 = data.wkWeather.img1;
		if ([data.wkWeather.img4 isEqual:@"99"])
			data.wkWeather.img4 = data.wkWeather.img3;
		if ([data.wkWeather.img6 isEqual:@"99"])
			data.wkWeather.img6 = data.wkWeather.img5;
		if ([data.wkWeather.img8 isEqual:@"99"])
			data.wkWeather.img8 = data.wkWeather.img7;
		if ([data.wkWeather.img10 isEqual:@"99"])
			data.wkWeather.img10 = data.wkWeather.img9;
		if ([data.wkWeather.img12 isEqual:@"99"])
			data.wkWeather.img12 = data.wkWeather.img11;
		
		//NSInteger d0;
		NSInteger d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12;
		[self divide2temp:data.wkWeather.temp1: &d1: &d2];
		[self divide2temp:data.wkWeather.temp2: &d3: &d4];
		[self divide2temp:data.wkWeather.temp3: &d5: &d6];
		[self divide2temp:data.wkWeather.temp4: &d7: &d8];
		[self divide2temp:data.wkWeather.temp5: &d9: &d10];
		[self divide2temp:data.wkWeather.temp6: &d11: &d12];
		
		if (d1 < d2)
		{
			//const char* strTemp0 = [data.wkWeather.st1 UTF8String];
			//sscanf(strTemp0, "%d", &d0);
			
			//data.wkWeather.temp1 = [self combine2temp: d0: d1];
			data.wkWeather.temp1 = [self combine2temp: d2: d1];
			data.wkWeather.temp2 = [self combine2temp: d2: d3];
			data.wkWeather.temp3 = [self combine2temp: d4: d5];
			data.wkWeather.temp4 = [self combine2temp: d6: d7];
			data.wkWeather.temp5 = [self combine2temp: d8: d9];
			data.wkWeather.temp6 = [self combine2temp: d10: d11];
			
			data.wkWeather.weather1 = [self combine2weather: data.wkWeather.img_title1: data.wkWeather.img_title1];
			data.wkWeather.weather2 = [self combine2weather: data.wkWeather.img_title2: data.wkWeather.img_title3];
			data.wkWeather.weather3 = [self combine2weather: data.wkWeather.img_title4: data.wkWeather.img_title5];
			data.wkWeather.weather4 = [self combine2weather: data.wkWeather.img_title6: data.wkWeather.img_title7];
			data.wkWeather.weather5 = [self combine2weather: data.wkWeather.img_title8: data.wkWeather.img_title9];
			data.wkWeather.weather6 = [self combine2weather: data.wkWeather.img_title10: data.wkWeather.img_title11];
			
			data.wkWeather.img12 = data.wkWeather.img11;
			data.wkWeather.img11 = data.wkWeather.img10;
			data.wkWeather.img10 = data.wkWeather.img9;
			data.wkWeather.img9 = data.wkWeather.img8;
			data.wkWeather.img8 = data.wkWeather.img7;
			data.wkWeather.img7 = data.wkWeather.img6;
			data.wkWeather.img6 = data.wkWeather.img5;
			data.wkWeather.img5 = data.wkWeather.img4;
			data.wkWeather.img4 = data.wkWeather.img3;
			data.wkWeather.img3 = data.wkWeather.img2;
			data.wkWeather.img2 = data.wkWeather.img1;
			
			
			NSInteger y, m, d, y0, m0, d0;
			[PubFunction getToday:&y :&m :&d];
			sscanf([data.wkWeather.date_y UTF8String], "%d年%d月%d日", &y0, &m0, &d0);
			if ((y*10000+m*100+d) != (y0*10000+m0*100+d0))
			{
				data.wkWeather.temp1 = data.wkWeather.temp2;
				data.wkWeather.temp2 = data.wkWeather.temp3;
				data.wkWeather.temp3 = data.wkWeather.temp4;
				data.wkWeather.temp4 = data.wkWeather.temp5;
				data.wkWeather.temp5 = data.wkWeather.temp6;
				
				data.wkWeather.weather1 = data.wkWeather.weather2;
				data.wkWeather.weather2 = data.wkWeather.weather3;
				data.wkWeather.weather3 = data.wkWeather.weather4;
				data.wkWeather.weather4 = data.wkWeather.weather5;
				data.wkWeather.weather5 = data.wkWeather.weather6;
				
				data.wkWeather.img1 =  data.wkWeather.img3;
				data.wkWeather.img2 =  data.wkWeather.img4;
				data.wkWeather.img3 =  data.wkWeather.img5;
				data.wkWeather.img4 =  data.wkWeather.img6;
				data.wkWeather.img5 =  data.wkWeather.img7;
				data.wkWeather.img6 =  data.wkWeather.img8;
				data.wkWeather.img7 =  data.wkWeather.img9;
				data.wkWeather.img8 =  data.wkWeather.img10;
				data.wkWeather.img9 =  data.wkWeather.img11;
				data.wkWeather.img10 =  data.wkWeather.img12;
			}
		}
		else
		{
			data.wkWeather.temp1 = [self combine2temp: d1: d2];
			data.wkWeather.temp2 = [self combine2temp: d3: d4];
			data.wkWeather.temp3 = [self combine2temp: d5: d6];
			data.wkWeather.temp4 = [self combine2temp: d7: d8];
			data.wkWeather.temp5 = [self combine2temp: d9: d10];
			data.wkWeather.temp6 = [self combine2temp: d11: d12];
		}
		
		
		return YES;
	}
	
	return NO;
}

+(BOOL) unpackImWeatherJson:(NSString*)sResponse DataOut:(TIMWeather_Ext*)data
{
	NSDictionary* jsObj = [sResponse JSONValue];
	return [BussWeather unpackWeatherJson:EWeaType_WeaCn_IM JsonData:jsObj DataOut:data];
}

+(BOOL) unpackWkWeatherJson:(NSString*)sResponse DataOut:(TWeekdayWeather_Ext*)data
{
	NSDictionary* jsObj = [sResponse JSONValue];
	return [BussWeather unpackWeatherJson:EWeaType_WeaCn JsonData:jsObj DataOut:data];
}

@end
 */



#pragma mark -
#pragma mark 人格特质

@implementation BussCharacter
@synthesize sReqDate, sUserGuid;

-(void)dealloc
{
	self.sReqDate = nil;
	self.sUserGuid = nil;
	[super dealloc];
}

-(void) RequestCharacter:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	self.sUserGuid = sGuid;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//打包
	NSDictionary* jobjPara = [BussFlowYS PackJsonObjofPeplInfoByGUID:self.sUserGuid];
	return [self WrapJsonStringWithBussID:ASTRO_RENGETEZH_GET_RESULT DictData:jobjPara];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"人格特质：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"人格特质：收到数据预处理错误");
		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
		LOG_ERROR(@"人格特质：收到数据预处理错误");
		return NO;
	}
	
	//TODO: 本地缓存
	[AstroDBMng replacePepoCharacter:self.sUserGuid Data:sResponse Time:self.sReqDate];
	
	return YES;
}

+(BOOL) unpackJson:(NSString*)jsCharct DataOut:(TNatureResult*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objResp = [jsCharct JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
	
	dout.sZwFateInfo = pickJsonStrValue(objResp, @"sZwFateInfo");
	dout.sBzFateInfo = pickJsonStrValue(objResp, @"sBzFateInfo");

	NSDictionary* objMainResult = [objResp objectForKey:@"strMainResult"];
	if (![PubFunction isObjNull:objMainResult])
	{
		dout.strMainResult = [[TMainResult new] autorelease];
		dout.strMainResult.sMerit = pickJsonStrValue(objMainResult, @"sMerit");
		dout.strMainResult.sWeak = pickJsonStrValue(objMainResult, @"sWeak");
		dout.strMainResult.sAdvice = pickJsonStrValue(objMainResult, @"sAdvice");
	}
	
	NSDictionary* objNatureScore = [objResp objectForKey:@"strNatureScore"];
	if (![PubFunction isObjNull:objNatureScore])
	{
		dout.strNatureScore = [[TNatureScore new] autorelease];
		dout.strNatureScore.iWitScore = pickJsonIntValue(objNatureScore, @"iWitScore");
		dout.strNatureScore.iJustScore = pickJsonIntValue(objNatureScore, @"iJustScore");
		dout.strNatureScore.iKindScore = pickJsonIntValue(objNatureScore, @"iKindScore");
		dout.strNatureScore.iSteadyScore = pickJsonIntValue(objNatureScore, @"iSteadyScore");
		dout.strNatureScore.iContactScore = pickJsonIntValue(objNatureScore, @"iContactScore");
	}
	return YES;
}

@end

#pragma mark -
#pragma mark 爱情桃花

@implementation BussLoveFlower
@synthesize sReqDate, sUserGuid;

-(void)dealloc
{
	self.sReqDate = nil;
	self.sUserGuid = nil;
	[super dealloc];
}

-(void) RequestLove:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	self.sUserGuid = sGuid;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//打包
	NSDictionary* jobjPara = [BussFlowYS PackJsonObjofPeplInfoByGUID:self.sUserGuid];
	return [self WrapJsonStringWithBussID:ASTRO_DZ_LOVE_TAOHUA_RESULT DictData:jobjPara];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"爱情桃花：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"爱情桃花：收到数据预处理错误");
		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
		LOG_ERROR(@"爱情桃花：收到数据预处理错误");
		return NO;
	}
	
	//TODO: 本地缓存
	[AstroDBMng replaceLoveFlower:self.sUserGuid Data:sResponse Time:self.sReqDate];
	
	return YES;
}

+(BOOL) unpackLoveJson:(NSString*)jsResp DataOut:(TLoveTaoHuaResult*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objData = [jsResp JSONValue];
	if ([PubFunction isObjNull:objData])
	{
		return NO;
	}
	
	//恋爱观
	dout.lagResult = pickJsonStrValue(objData, @"lagResult");
	//命局桃花
	NSArray* aryMingJuTaoHua = [objData objectForKey:@"vecMingJuTaoHua"];
	if( ![PubFunction isArrayEmpty:aryMingJuTaoHua] )
	{
		dout.vecMingJuTaoHua = [NSMutableArray array];
		for(id obj in aryMingJuTaoHua)
		{
			NSDictionary* jObjMG = (NSDictionary*)obj;
			
			TMingJuTaoHua* item = [[TMingJuTaoHua new] autorelease];
			[dout.vecMingJuTaoHua addObject:item];
			
			item.iNum = pickJsonIntValue(jObjMG, @"iNum");
			item.sTaoHua = pickJsonStrValue(jObjMG, @"sTaoHua");
			item.sMean = pickJsonStrValue(jObjMG, @"sMean");
		}
	}
	
	//行运桃花
	NSArray* aryXingYunTaoHua = [objData objectForKey:@"vecXingYunTaoHua"];
	if( ![PubFunction isArrayEmpty:aryXingYunTaoHua] )
	{
		dout.vecXingYunTaoHua = [NSMutableArray array];
		for(id obj in aryXingYunTaoHua)
		{
			NSDictionary* jObjXYTH = (NSDictionary*)obj;

			TXingYunTaoHua* item = [[TXingYunTaoHua new] autorelease];
			[dout.vecXingYunTaoHua addObject:item];
			
			//year
			NSArray* aryYear = [jObjXYTH objectForKey:@"veciYear"];
			if (![PubFunction isArrayEmpty:aryYear])
			{
				item.veciYear = [NSMutableArray array];
				for (id objYear in aryYear)
				{
					[item.veciYear addObject:objYear];
				}
			}
			
			//taohua
			NSArray* aryTaoHua = [jObjXYTH objectForKey:@"vecsTaoHua"];
			if (![PubFunction isArrayEmpty:aryTaoHua])
			{
				item.vecsTaoHua = [NSMutableArray array];
				for (id objTH in aryTaoHua)
				{
					[item.vecsTaoHua addObject:objTH];
				}
			}
		}
	}
	
	dout.sXiangPei = pickJsonStrValue(objData, @"sXiangPei");
	dout.sBuHe = pickJsonStrValue(objData, @"sBuHe");
	dout.sPeiOuSrc = pickJsonStrValue(objData, @"sPeiOuSrc");
	dout.sPeiOuRel = pickJsonStrValue(objData, @"sPeiOuRel");
	dout.sPeiOulooks = pickJsonStrValue(objData, @"sPeiOulooks");
	dout.sPeiOuPos = pickJsonStrValue(objData, @"sPeiOuPos");
	dout.sSynAna = pickJsonStrValue(objData, @"sSynAna");
	dout.sMarryTime = pickJsonStrValue(objData, @"sMarryTime");
	
	NSArray* aryMarryWang = [objData objectForKey:@"veciMarryWang"];
	if(![PubFunction isArrayEmpty:aryMarryWang])
	{
		dout.veciMarryWang = [NSMutableArray array];
		for (id obj in aryMarryWang)
		{
			[dout.veciMarryWang addObject:obj];
		}
	}
	
	dout.sMainStar = pickJsonStrValue(objData, @"sMainStar");
	dout.sFuQiStar = pickJsonStrValue(objData, @"sFuQiStar");
	
	NSArray* aryZhu = [objData objectForKey:@"vecZhu"];
	if (![PubFunction isArrayEmpty:aryZhu])
	{
		dout.vecZhu = [NSMutableArray array];
		for (id obj in aryZhu)
		{
			NSDictionary* jobjZhu = (NSDictionary*)obj;
			
			TBZMODEL_ZHU* item = [[TBZMODEL_ZHU new] autorelease];
			[dout.vecZhu addObject:item];
			
			item.sGan = pickJsonStrValue(jobjZhu, @"sGan");
			item.sGanShishen = pickJsonStrValue(jobjZhu, @"sGanShishen");
			item.sNaYin = pickJsonStrValue(jobjZhu, @"sNaYin");
			item.sZhi = pickJsonStrValue(jobjZhu, @"sZhi");
			
			NSArray* arysCGShiShen = [jobjZhu objectForKey:@"vecsCGShiShen"];
			if (![PubFunction isArrayEmpty:arysCGShiShen])
			{
				item.vecsCGShiShen = [NSMutableArray array];
				for (id obj in arysCGShiShen)
				{
					[item.vecsCGShiShen addObject:obj];
				}
			}
			
			NSArray* arysCangGan = [jobjZhu objectForKey:@"vecsCangGan"];
			if (![PubFunction isArrayEmpty:arysCangGan])
			{
				item.vecsCangGan = [NSMutableArray array];
				for (id obj in arysCangGan)
				{
					[item.vecsCangGan addObject:obj];
				}
			}
		}
	}
	
	
	return YES;
}

@end



#pragma mark -
#pragma mark 姓名分析

@implementation BussNameParse 

@synthesize sReqDate, sUserGuid, iBussID;

-(void)dealloc
{
	self.sReqDate = nil;
	self.sUserGuid = nil;
	[super dealloc];
}

-(void) RequestNameParse:(id)target ResponseSelector:(SEL)selector
{
	super.delgtPackData = self;
	
	NSString *url = [BussInterImplBase makeQueryURLWithSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) RequestNameParsePlate:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = ASTRO_NAME_GET_TEST_PLATE;
	self.sUserGuid = sGuid;
	[self RequestNameParse:target ResponseSelector:selector];
}

-(void) RequestNameParseExplain:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iBussID = ASTRO_NAME_GET_TEST_RESULT;
	self.sUserGuid = sGuid;
	[self RequestNameParse:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//打包
	if (iBussID == ASTRO_NAME_GET_TEST_PLATE)
	{
		return [self PackSendOutJsonString_Plate];
	}
	else if(iBussID == ASTRO_NAME_GET_TEST_RESULT)
	{
		return [self PackSendOutJsonString_Plate];
	}
	else
	{
		return @"";
	}
}

-(NSString*) PackSendOutJsonString_Plate
{
	//打包
	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
	if (![PubFunction isObjNull:jobjPara])
	{
		NSArray* aryName = [TheCurPeople.sPersonName componentsSeparatedByString:@"-"];
		if ([aryName count] == 2)
		{
			//姓
			NSString* sXing = [aryName objectAtIndex:0];
			[jobjPara setObject:sXing forKey:@"sFamilyName"];
			//名
			NSString* sMing = [aryName objectAtIndex:1];
			[jobjPara setObject:sMing forKey:@"sSecondName"];
		}
	}
	
	return [self WrapJsonStringWithBussID:iBussID DictData:jobjPara];
}

-(NSString*) PackSendOutJsonString_Explain
{
	NSDictionary* jobjPara = [BussFlowYS PackJsonObjofPeplInfoByGUID:self.sUserGuid];
	return [self WrapJsonStringWithBussID:iBussID DictData:jobjPara];
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"姓名分析：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"姓名分析：收到数据预处理错误");
		return NO;
	}
	
	//解析
	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
	if ([PubFunction stringIsNullOrEmpty:sResponse])
	{
		LOG_ERROR(@"姓名分析：收到数据预处理错误");
		return NO;
	}
	
	//TODO: 本地缓存
	if (iBussID == ASTRO_NAME_GET_TEST_PLATE)
	{
		[AstroDBMng replaceNameParsePlate:self.sUserGuid Data:sResponse Time:self.sReqDate];
	}
	else if (iBussID == ASTRO_NAME_GET_TEST_RESULT)
	{
		[AstroDBMng replaceNameParseExplain:self.sUserGuid Data:sResponse Time:self.sReqDate];
	}
	
	return YES;
}

+(BOOL) unpackNameParsePlateJson:(NSString*)jsResp DataOut:(TNT_PLATE_INFO*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objResp = [jsResp JSONValue];
	if ([PubFunction isObjNull:objResp])
	{
		return NO;
	}
	
	//姓名
	NSDictionary* objKxname = [objResp objectForKey:@"pep_kxname"];
	if (![PubFunction isObjNull:objKxname])
	{
		dout.pep_kxname = [[TPEP_KXNAME new] autorelease];
		
		// 姓
		NSArray* aryFamilyName = [objKxname objectForKey:@"chrKxFamilyName"];
		if (![PubFunction isArrayEmpty:aryFamilyName])
		{	
			dout.pep_kxname.aryChrKxFamilyName = [NSMutableArray array];
			
			for (id obj in aryFamilyName)
			{
				TCHARACTER* item = [TCHARACTER new];
				[BussNameParse unpackCharacter:obj DataOut:item];
				[dout.pep_kxname.aryChrKxFamilyName addObject:item];
				[item release];
			}
		}
		// 名
		NSArray* arySecondName = [objKxname objectForKey:@"chrKxSecondName"];
		if (![PubFunction isArrayEmpty:arySecondName])
		{	
			dout.pep_kxname.aryChrKxSecondName = [NSMutableArray array];
			 
			for (id obj in arySecondName)
			{
				TCHARACTER* item = [TCHARACTER new];
				[BussNameParse unpackCharacter:obj DataOut:item];
				[dout.pep_kxname.aryChrKxSecondName addObject:item];
				[item release];
			}
		}
	}
	
	//五行
	NSDictionary* objFivePattern = [objResp objectForKey:@"five_pattern_nums"];
	if (![PubFunction isObjNull:objFivePattern])
	{
		dout.five_pattern_nums = [[TFIVE_PATTERN_NUMS new] autorelease];
		// 天格
		dout.five_pattern_nums.iTianPatternNum = pickJsonIntValue(objFivePattern, @"iTianPatternNum", -1);
		// 地格
		dout.five_pattern_nums.iDiPatternNum = pickJsonIntValue(objFivePattern, @"iDiPatternNum", -1);
		// 人格
		dout.five_pattern_nums.iRenPatternNum = pickJsonIntValue(objFivePattern, @"iRenPatternNum", -1);
		// 外格
		dout.five_pattern_nums.iWaiPatternNum = pickJsonIntValue(objFivePattern, @"iWaiPatternNum", -1);
		// 总格
		dout.five_pattern_nums.iZongPatternNum = pickJsonIntValue(objFivePattern, @"iZongPatternNum", -1);
		//天格的五行
		dout.five_pattern_nums.sTianPatternFiveE = pickJsonStrValue(objFivePattern, @"sTianPatternFiveE");
		//地格的五行
		dout.five_pattern_nums.sDiPatternFiveE = pickJsonStrValue(objFivePattern, @"sDiPatternFiveE");
		//人格的五行
		dout.five_pattern_nums.sRenPatternFiveE = pickJsonStrValue(objFivePattern, @"sRenPatternFiveE");
		//外格的五行
		dout.five_pattern_nums.sWaiPatternFiveE = pickJsonStrValue(objFivePattern, @"sWaiPatternFiveE");
		//总格的五行
		dout.five_pattern_nums.sZongPatternFiveE = pickJsonStrValue(objFivePattern, @"sZongPatternFiveE");
	}

	return YES;
	
}

+(BOOL) unpackCharacter:(NSDictionary*)jsObj DataOut:(TCHARACTER*)dout
{
	if( [PubFunction isObjNull:jsObj] || [PubFunction isObjNull:dout])
	{
		return NO;
	}
	
	// 简体字
	dout.sCharacter = pickJsonStrValue(jsObj, @"sCharacter");
	// 繁体字
	dout.sTraditChar = pickJsonStrValue(jsObj, @"sTraditChar");
	// 拼音
	dout.sPhonetic = pickJsonStrValue(jsObj, @"sPhonetic");
	// 五行
	dout.sFiveElement = pickJsonStrValue(jsObj, @"sFiveElement");
	// 凶吉
	dout.sGoodAndBad = pickJsonStrValue(jsObj, @"sGoodAndBad");
	// 笔画数
	dout.iWordCount = pickJsonIntValue(jsObj, @"iWordCount", -1);
	// 笔画数-简体笔画
	dout.iWordCountJt = pickJsonIntValue(jsObj, @"iWordCountJt", -1);
	// 声调
	dout.sTone = pickJsonStrValue(jsObj, @"sTone");
	// 是否为常用字(常用字为1，非常用字为0)
	dout.iUseFrequency = pickJsonIntValue(jsObj, @"iUseFrequency", -1);
	// 是否为贬义词性的字（非贬义的为1，贬义的为0）
	dout.iWordKind = pickJsonIntValue(jsObj, @"iWordKind", -1);
	//字的释义
	dout.sWordMean = pickJsonStrValue(jsObj, @"sWordMean");
	//字的读音（包括拼音和声调）
	dout.sPronunciation = pickJsonStrValue(jsObj, @"sPronunciation");
	//公司取名字义
	dout.sSimpleWordMean = pickJsonStrValue(jsObj, @"sSimpleWordMean");
	
	return YES;
}

+(BOOL) unpackNameParseExplainJson:(NSString*)jsResp DataOut:(TNT_EXPLAIN_INFO*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objData = [jsResp JSONValue];
	if ([PubFunction isObjNull:objData])
	{
		return NO;
	}
	
	
	dout.dNameScore = pickJsonDoubleValue(objData, @"dNameScore");
	dout.iThScore   = pickJsonIntValue(objData, @"iThScore");		//桃花指数
	dout.strNameComments = pickJsonStrValue(objData, @"strNameComments");
	
	NSMutableArray* aryJV = [objData objectForKey:@"vecFivePatternExp"];
	if (![PubFunction isArrayEmpty:aryJV])
	{	
		dout.vecFivePatternExp = [NSMutableArray array];
		for (id obj in aryJV)
		{
			TTITLE_EXP* item = [TTITLE_EXP new];
			[BussNameParse unpackNameTitleExp:obj DataOut:item];
			[dout.vecFivePatternExp addObject:item];
			[item release];
		}
	}
	
	aryJV = nil;
	aryJV = [objData objectForKey:@"vecThreeTalentExp"];
	if (![PubFunction isArrayEmpty:aryJV])
	{	
		dout.vecThreeTalentExp = [NSMutableArray array];
		for (id obj in aryJV)
		{
			TTITLE_EXP* item = [TTITLE_EXP new];
			[BussNameParse unpackNameTitleExp:obj DataOut:item];
			[dout.vecThreeTalentExp addObject:item];
			[item release];
		}
	}
	
	
	aryJV = nil;
	aryJV = [objData objectForKey:@"vecMathHintExp"];
	if (![PubFunction isArrayEmpty:aryJV])
	{	
		dout.vecMathHintExp = [NSMutableArray array];
		for (id obj in aryJV)
		{
			TTITLE_EXP* item = [TTITLE_EXP new];
			[BussNameParse unpackNameTitleExp:obj DataOut:item];
			[dout.vecMathHintExp addObject:item];
			[item release];
		}
	}
	
	aryJV = nil;
	aryJV = [objData objectForKey:@"vecFiveElementsExp"];
	if (![PubFunction isArrayEmpty:aryJV])
	{	
		dout.vecFiveElementsExp = [NSMutableArray array];
		for (id obj in aryJV)
		{
			TTITLE_EXP* item = [TTITLE_EXP new];
			[BussNameParse unpackNameTitleExp:obj DataOut:item];
			[dout.vecFiveElementsExp addObject:item];
			[item release];
		}
	}
	
	return YES;
}

+(BOOL) unpackNameTitleExp:(NSDictionary*)jsObj DataOut:(TTITLE_EXP*) dout
{
	if( [PubFunction isObjNull:jsObj] || [PubFunction isObjNull:dout])
	{
		return NO;
	}
	dout.sTitle = pickJsonStrValue(jsObj, @"sTitle");
	dout.sExplain = pickJsonStrValue(jsObj, @"sExplain");

	return YES;
}

@end

#pragma mark -
#pragma mark 姓名分析－易心测试

@implementation BussNameYxTest

@synthesize sReqDate;
@synthesize sUserGuid;
@synthesize tYxParam;
@synthesize iLookFrom;

-(void) dealloc
{
	self.sReqDate = nil;
	self.sUserGuid = nil;
	self.tYxParam = nil;
	[super dealloc];
}

-(void) RequestNameYxTestInfo:(NSString*)sGuid Name:(TNameYxParam*)param LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.sUserGuid = sGuid;
	self.tYxParam = param;
	self.iLookFrom = lkFr;
	super.delgtPackData = self;
	
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"nametestds" UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(int) getConsumeItemByNameParamType
{
	if ([self.tYxParam.sConsumeItem isEqualToString:@"all"] || [self.tYxParam.sConsumeItem isEqualToString:@"综合"] || [self.tYxParam.sConsumeItem isEqualToString:@"綜合"])
	{
		return EConsumeItem_NameParseAll;
	}
	else if ([self.tYxParam.sConsumeItem isEqualToString:@"事业"] ||
             [self.tYxParam.sConsumeItem isEqualToString:@"事業"])
	{
		return EConsumeItem_NameParseWork;
	}
	else if ([self.tYxParam.sConsumeItem isEqualToString:@"健康"])
	{
		return EConsumeItem_NameParseHealth;
	}
    
	else if ([self.tYxParam.sConsumeItem isEqualToString:@"婚姻"])
	{
		return EConsumeItem_NameParseMarry;
	}
	else if ([self.tYxParam.sConsumeItem isEqualToString:@"命运特点"] ||
             [self.tYxParam.sConsumeItem isEqualToString:@"命運特點"])
	{
		return EConsumeItem_NameParseFateChar;
	}
	else
	{
		return 0;
	}
}


-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	if (!self.tYxParam)
	{
		return @"";
	}
	
	//JSON OBJECT
	NSMutableDictionary *jObjRoot = [NSMutableDictionary dictionary];
	if(!jObjRoot)
	{
		return @"";
	}
	[jObjRoot setObject:self.tYxParam.pepName.sFamilyName forKey:@"sFamilyName"];
	[jObjRoot setObject:self.tYxParam.pepName.sSecondName forKey:@"sSecondName"];
	[jObjRoot setObject:self.tYxParam.sSex forKey:@"sSex"];
	[jObjRoot setObject:self.tYxParam.sConsumeItem forKey:@"soption"];	//综合：“all； 性格：“性格”； 事业：“事业”； 健康：“健康”；婚姻：“婚姻”；命运特点：“命运特点”
	
	if (self.iLookFrom == EConsumeLookFrom_Blog)
	{
		int itemConsm = [self getConsumeItemByNameParamType];
		int ruldid = [BussConsume getRuleIDWithConsmItem:(EConsumeItem)itemConsm];
		if (ruldid > 0)
		{
			NSString* chkCode = [PubFunction makeCheckCode:ruldid];
			[jObjRoot setObject:chkCode forKey:@"chkcode"];
		}
	}
	
	//转成字符串
    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"姓名分析-易心测试：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"姓名分析-易心测试：收到数据预处理错误");
		return NO;
		
	}
	
	//TODO: 本地缓存
	//易心姓名测试的接口，返回的数据格式与其他不一样。直接写入数据库
	[AstroDBMng replaceNameTest:self.sUserGuid Name:self.tYxParam Data:rcvData Time:self.sReqDate];
	
	return YES;
}


+(BOOL) unpackNameYxTestInfoJson:(NSString*)jsResp DataOut:(TNameYxTestInfo*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objData = nil;
	//JSON
	id obj = [jsResp JSONValue];
	if (!obj)
	{
		return NO;
	}
	
	if ([PubFunction isArrayObj:obj])
	{
		if ([obj count] < 1)
		{
			return NO;
		}
		else
		{
			objData = [obj objectAtIndex:0];
		}
	}
	else if(![PubFunction isObjNull:obj])
	{
		objData = obj;
	}
	
	if (!objData)
	{
		return NO;
	}
	
	
	// 性格评述
	dout.sXgResult = pickJsonStrValue(objData, @"sXgResult");
	// 事业评述
	dout.sSyResult = pickJsonStrValue(objData, @"sSyResult");
	// 健康评述
	dout.sHyResult = pickJsonStrValue(objData, @"sHyResult");
	// 婚姻评述
	dout.sJkResult = pickJsonStrValue(objData, @"sJkResult");
	// 命运评述
	dout.sTdResult = pickJsonStrValue(objData, @"sTdResult");
	
	return YES;
}

@end





#pragma mark -
#pragma mark 姓名匹配

@implementation BussNameMatch

@synthesize sReqDate;
@synthesize tNameInfo;
@synthesize iLookFrom;

-(void) dealloc
{
	self.sReqDate = nil;
	self.tNameInfo = nil;
	[super dealloc];
}

-(void) ReqNameMatch:(TNAME_PD_PARAM*)nameInfo LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.delgtPackData = self;
	self.tNameInfo = nameInfo;
	self.iLookFrom = lkFr;
	
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"nametestpd" UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//JSON OBJECT
	NSMutableDictionary *jObjRoot = [NSMutableDictionary dictionary];
	if(!jObjRoot)
	{
		return @"";
	}
	[jObjRoot setObject:tNameInfo.sManMing forKey:@"sManMing"];
	[jObjRoot setObject:tNameInfo.sManXin forKey:@"sManXin"];
	[jObjRoot setObject:tNameInfo.sWomanMing forKey:@"sWomanMing"];
	[jObjRoot setObject:tNameInfo.sWomanXin forKey:@"sWomanXin"];
	if (self.iLookFrom == EConsumeLookFrom_Blog)
	{
		int ruldid = [BussConsume getRuleIDWithConsmItem:EConsumeItem_NameMatch];
		if (ruldid > 0)
		{
			NSString* chkCode = [PubFunction makeCheckCode:ruldid];
			[jObjRoot setObject:chkCode forKey:@"chkcode"];
		}
	}
	
	//转成字符串
    [jObjRoot setObject:LANGCODE forKey:@"langcode"];
	NSString* strJson = [jObjRoot JSONRepresentation];
	return strJson;
	
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"姓名匹配：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"姓名匹配：收到数据预处理错误");
		return NO;
		
	}
	
	//TODO: 本地缓存
	//姓名匹配的接口，返回的数据格式与其他不一样。直接写入数据库
	[AstroDBMng replaceNameMatch:TheCurPeople.sGuid Name:self.tNameInfo Data:rcvData Time:self.sReqDate];


	return YES;
}

+(BOOL) unpackNameMatchJson:(NSString*)jsResp DataOut:(TNAME_PD_RESULT*) dout
{
	if (!dout)
	{
		return NO;
	}
	
	NSDictionary* objData = [jsResp JSONValue];
	if ([PubFunction isObjNull:objData])
	{
		return NO;
	}
	
	//解析
	dout.xgnum = pickJsonIntValue(objData, @"xgnum", 1);
	dout.yfnum = pickJsonIntValue(objData, @"yfnum", 1);
	dout.qdnum = pickJsonIntValue(objData, @"qdnum", 1);
	dout.zsnum = pickJsonIntValue(objData, @"zsnum", 1);
	dout.manxg = pickJsonStrValue(objData, @"manxg");
	dout.womanxg = pickJsonStrValue(objData, @"womanxg");
	dout.manyf = pickJsonStrValue(objData, @"manyf");
	dout.womanyf = pickJsonStrValue(objData, @"womanyf");
	dout.manfd = pickJsonStrValue(objData, @"manfd");
	dout.womanfd = pickJsonStrValue(objData, @"womanfd");
	dout.manwt = pickJsonStrValue(objData, @"manwt");
	dout.womanwt = pickJsonStrValue(objData, @"womanwt");
	dout.manjy = pickJsonStrValue(objData, @"manjy");
	dout.womanjy = pickJsonStrValue(objData, @"womanjy");
	dout.zsstr = pickJsonStrValue(objData, @"zsstr");
	
	return YES;
}

@end


#pragma mark -
#pragma mark 消费项目


@implementation BussConsume

@synthesize iCusmType;
@synthesize iCusmItem;
@synthesize sReqDate;
@synthesize sFuncFlag;

-(void)dealloc
{
	self.sReqDate = nil;
	self.sFuncFlag = nil;
	[super dealloc];
}


//查询余额及产品金额
-(void) requestNameParsePrice:(EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = item;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [self getNameParseFuncFlagByCusmItem];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestNameMatchPrice:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_NameMatch;
	self.iCusmType = EConsumeBussType_GetPrice;
	NSString* sName1 = [PubFunction replaceStr:strName1 :@"-" :@""];
	NSString* sName2 = [PubFunction replaceStr:strName2 :@"-" :@""];
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%@", sName1, sName2];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestLiuriyueYsPrice:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_LiuriyueYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestProLiuriyueYsPrice:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_ProLiuriyueYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestLiunianYsPrice:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_LiunianYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestProLiunianYsPrice:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_ProLiunianYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//add 2012.9.4
-(void) requestFortuneYsPrice:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_FortuneYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) requestCareerYsPrice:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_CareerYs;
	self.iCusmType = EConsumeBussType_GetPrice;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}


//查询是否已消费
-(void) checkNameParsePayed: (EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = item;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [self getNameParseFuncFlagByCusmItem];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkNameMatchPayed:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_NameMatch;
	self.iCusmType = EConsumeBussType_CheckPayed;
	NSString* sName1 = [PubFunction replaceStr:strName1 :@"-" :@""];
	NSString* sName2 = [PubFunction replaceStr:strName2 :@"-" :@""];
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%@", sName1, sName2];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkLiuriyuePayed:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_LiuriyueYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
						 TheCurPeople.sSex,
						 TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
						 year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkProLiuriyuePayed:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
{
	self.iCusmItem = EConsumeItem_ProLiuriyueYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkLiunianPayed:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
{
	self.iCusmItem = EConsumeItem_LiunianYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkProLiunianPayed:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
{
	self.iCusmItem = EConsumeItem_ProLiunianYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//add 2012.9.4
-(void) checkFortunePayed:(id)target ResponseSelector:(SEL)selector;
{
	self.iCusmItem = EConsumeItem_FortuneYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) checkCareerPayed:(id)target ResponseSelector:(SEL)selector;
{
	self.iCusmItem = EConsumeItem_CareerYs;
	self.iCusmType = EConsumeBussType_CheckPayed;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//积分消费
-(void) payNameParseConsume:(EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = item;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [self getNameParseFuncFlagByCusmItem];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payNameMatchConsume:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_NameMatch;
	self.iCusmType = EConsumeBussType_Pay;
	NSString* sName1 = [PubFunction replaceStr:strName1 :@"-" :@""];
	NSString* sName2 = [PubFunction replaceStr:strName2 :@"-" :@""];
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%@", sName1, sName2];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payLiuriyueConsume:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_LiuriyueYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payProLiuriyueConsume:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_ProLiuriyueYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d|%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year, month];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payLiunianConsume:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_LiunianYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payProLiunianConsume:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_ProLiunianYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d|%d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay,
					  year];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//add 2012.9.4
-(void) payFortuneConsume:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_FortuneYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(void) payCareerConsume:(id)target ResponseSelector:(SEL)selector
{
	self.iCusmItem = EConsumeItem_CareerYs;
	self.iCusmType = EConsumeBussType_Pay;
	self.sFuncFlag = [NSString stringWithFormat:@"%@|%d%02d%02d", 
					  TheCurPeople.sSex,
					  TheCurPeople.iYear, TheCurPeople.iMonth, TheCurPeople.iDay];
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:[self getCGIWithCusmType]  UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}


-(NSString*) getCGIWithCusmType
{
	switch (iCusmType)
	{
		case EConsumeBussType_GetPrice:
			return @"getProductPrice";
			
		case EConsumeBussType_CheckPayed:
			return @"findScoreDetail";
			
		case EConsumeBussType_Pay:
			return @"syncChangeScore";
			
		default:
			return @"";
	}
	
	return @"";
}

-(NSString*) getNameParseFuncFlagByCusmItem
{
	//custominfo
	NSString* sName = [PubFunction replaceStr:TheCurPeople.sPersonName :@"-" :@""];
	switch (iCusmItem)
	{
		case EConsumeItem_NameParseAll:			//姓名分析(综合)	
		{
			return [NSString stringWithFormat:@"%@|%@", sName, TheCurPeople.sSex]; 
		}
			break;
			
		case EConsumeItem_NameParseWork:			//姓名分析(事业)	
		{
			return [NSString stringWithFormat:@"%@|%@|事业", sName, TheCurPeople.sSex]; 
		}
			break;
			
		case EConsumeItem_NameParseHealth:		//姓名分析(健康)	
		{
			return [NSString stringWithFormat:@"%@|%@|健康", sName, TheCurPeople.sSex]; 
		}
			break;
			
		case EConsumeItem_NameParseMarry:		//姓名分析(婚姻)	
		{
			return [NSString stringWithFormat:@"%@|%@|婚姻", sName, TheCurPeople.sSex]; 
		}
			break;
			
		case EConsumeItem_NameParseFateChar:		//姓名分析(命运特点)
		{
			return [NSString stringWithFormat:@"%@|%@|命运特点", sName, TheCurPeople.sSex]; 
		}
			break;
            
        case EConsumeItem_LiunianYs:
        case EConsumeItem_LiuriyueYs:
        case EConsumeItem_NameMatch:
        case EConsumeItem_ProLiunianYs:
        case EConsumeItem_ProLiuriyueYs:
        case EConsumeItem_CareerYs:
        case EConsumeItem_FortuneYs:
            break;
	}
	
	return nil;
}


-(NSString*) PackSendOutJsonString
{						 
	//请求时间
	self.sReqDate = [PubFunction getTimeStr1];
	
	//JSON
	NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
	if (![PubFunction isObjNull:jobjPara])
	{
		//ruleID
		int ruleID = [BussConsume getRuleIDWithConsmItem:self.iCusmItem];
		[jobjPara setObject:[NSNumber numberWithInt:ruleID] forKey:@"RuleId"];
		
		//custominfo
		[jobjPara setObject:self.sFuncFlag forKey:@"CustomInfo"];
		
		//转成JSON字符串
        [jobjPara setObject:LANGCODE forKey:@"langcode"];
		NSString* strJson = [jobjPara JSONRepresentation];
		return strJson;
	}
	
	return @"";
}

+(int)getRuleIDWithConsmItem:(EConsumeItem)cusmItem
{
	switch (cusmItem)
	{
		case EConsumeItem_NameParseAll:			//姓名分析(综合)	
			return ASTRO_CUMS_NAMEPARSE_ALL;
			
		case EConsumeItem_NameParseWork:			//姓名分析(事业)	
			return ASTRO_CUMS_NAMEPARSE_WORK;
			
		case EConsumeItem_NameParseHealth:		//姓名分析(健康)	
			return ASTRO_CUMS_NAMEPARSE_HEALTH;
			
		case EConsumeItem_NameParseMarry:		//姓名分析(婚姻)	
			return ASTRO_CUMS_NAMEPARSE_MARRY;
			
		case EConsumeItem_NameParseFateChar:		//姓名分析(命运特点)
			return ASTRO_CUMS_NAMEPARSE_FATECHAR;
			
		case EConsumeItem_NameMatch:				//姓名匹配		
			return ASTRO_CUMS_NAMEMATCH;
			
		case EConsumeItem_LiuriyueYs:			//流月流日运势	
			return ASTRO_CUMS_LIURIYUE;
			
		case EConsumeItem_LiunianYs:				//流年运势		
			return ASTRO_CUMS_LIUNIAN;
			
		case EConsumeItem_ProLiuriyueYs:			//专业版流月流日运势
			return ASTRO_CUMS_PRO_LIURIYUE;
			
		case EConsumeItem_ProLiunianYs:			//专业版流年运势	
			return ASTRO_CUMS_PRO_LIUNIAN;
        
        case EConsumeItem_FortuneYs:   //财富运势
            return ASTRO_CUMS_FORTUNE;
        
        case EConsumeItem_CareerYs:  //事业成长
            return ASTRO_CUMS_CAREER;
			
		default:
			break;
	}
	
	return 0;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"消费：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}

		LOG_ERROR(@"消费：收到数据预处理错误");
		return NO;
	}
	
	return YES;
}

+(BOOL)unpackGetPriceResult:(NSString*)jsRep Result:(TProductInfo*)prdInf
{
	if (!jsRep)
	{
		LOG_ERROR(@"数据为空");
		return YES;
	}
	
	NSDictionary* jObjRoot = [NSDictionary dictionary];
	if (!jObjRoot)
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	jObjRoot = [jsRep JSONValue];
	
	if ([PubFunction isObjNull:jObjRoot])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
    
    //看响应码是否为200
    int code = pickJsonIntValue(jObjRoot,@"code");
    if ( code != 200 ) 
    {
        LOG_ERROR(@"返回错误代码.code=%d",code);
        return NO;
    }
	
	//解析
	prdInf.fFreeMoneyBalance = pickJsonFloatValue(jObjRoot, @"fFreeMoneyBalance");
	prdInf.fMoneyBalance = pickJsonFloatValue(jObjRoot, @"fMoneyBalance");
    
    id val = [jObjRoot objectForKey:@"fTotalMoneyBalance"];
    if (!val || [val isKindOfClass:[NSNull class]]) {
        LOG_ERROR(@"fTotalMoneyBalance 不存在");
        return NO;
    }
	prdInf.fTotalMoneyBalance = pickJsonFloatValue(jObjRoot, @"fTotalMoneyBalance");
    
	prdInf.fProductMoney = pickJsonFloatValue(jObjRoot, @"fProductMoney");
	prdInf.fOriginMoney = pickJsonFloatValue(jObjRoot, @"fOriginMoney");
	prdInf.bEnough = pickJsonBOOLValue(jObjRoot, @"bEnough");
	prdInf.fNeedMoney = pickJsonFloatValue(jObjRoot, @"fNeedMoney");
	
	return YES;
}

+(BOOL)unpackCheckPayedResult:(NSString*)jsRep Result:(TCheckPayResult*)pChkPayResult
{
	if (!jsRep)
	{
		LOG_ERROR(@"数据为空");
		return YES;
	}
	
	NSDictionary* jObjRoot = [NSDictionary dictionary];
	if (!jObjRoot)
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	jObjRoot = [jsRep JSONValue];
	
	if ([PubFunction isObjNull:jObjRoot])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	//解析
	pChkPayResult.httpCode = pickJsonIntValue(jObjRoot, @"code");
	pChkPayResult.sMsg = pickJsonStrValue(jObjRoot, @"msg");
	pChkPayResult.respVal = pickJsonIntValue(jObjRoot, @"return");
	
	return YES;
}

+(BOOL)unpackPayResult:(NSString*)jsRep Result:(TPayResult*)payResult
{
	if (!jsRep)
	{
		LOG_ERROR(@"数据为空");
		return YES;
	}
	
	NSDictionary* jObjRoot = [NSDictionary dictionary];
	if (!jObjRoot)
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	jObjRoot = [jsRep JSONValue];
	
	if ([PubFunction isObjNull:jObjRoot])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	//解析
	payResult.httpCode = pickJsonIntValue(jObjRoot, @"code");
	payResult.sMsg = pickJsonStrValue(jObjRoot, @"msg");
	
	return YES;
}

@end


#pragma mark -
#pragma mark 同步下载
@implementation BussSyncDownLoad

@synthesize	sSyncDate;
@synthesize iSrvMaxVer;
@synthesize aryShoudHandleSrvPep;

-(void)dealloc
{
	self.sSyncDate = nil;
	[self.aryShoudHandleSrvPep removeAllObjects];
	self.aryShoudHandleSrvPep = nil;
	
	[super dealloc];
}

-(void) StartSyncDownLoad:(id)target :(SEL)selector
{
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"downloaddata" UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//JSON打包
-(NSString*) PackSendOutJsonString
{
	@try
	{
		NSMutableDictionary* jobjRoot = [NSMutableDictionary dictionary];
		if (!jobjRoot)
		{
			return nil;
		}
		
		[jobjRoot setObject:@"UapDl_PepList" forKey:@"option"];
		[jobjRoot setObject:@"1.0" forKey:@"vercode"];
		
		//参数
		NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
		if ( jobjPara )
		{
			int nLocalSynLogVer = [AstroDBMng getLocalSyncVer];
			[jobjPara setObject:[NSNumber numberWithInt:nLocalSynLogVer] forKey:@"iVersion"];
			[jobjPara setObject:[NSNumber numberWithInt:0] forKey:@"iVerType"];
			[jobjPara setObject:TheCurUser.sSrvTbName forKey:@"szTabname"];
		}
		[jobjRoot setObject:jobjPara forKey:@"param"];
		
		//转成JSON字符串
         [jobjRoot setObject:LANGCODE forKey:@"langcode"];
		NSString* strJson = [jobjRoot JSONRepresentation];
		return strJson;
		
	}
	@catch (NSException * e)
	{
		return nil;
	}
	
	return nil;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		if (self.iHttpCode == 204 || self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		LOG_ERROR(@"同步下载：收到数据预处理错误");
	}
	
	if (!jsobj )
	{
		return YES;
		
	}
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		LOG_ERROR(@"同步下载：收到数据预处理错误");
		return NO;
	}
	
	//TODO:处理同步下载数据
	//服务端的列表
	NSMutableArray* arySrvPeps = nil;
	if (![BussSyncDownLoad unpackSyncDownLoadPeopleList:rcvData PepList:arySrvPeps] || [PubFunction isObjNull:arySrvPeps])
	{
		LOG_ERROR(@"同步下载：解析JSON数据错误");
		return NO;
	}
	
	//数据合并
	self.iSrvMaxVer = [self getMaxVerFromSrvPepList:arySrvPeps];
	self.aryShoudHandleSrvPep = [self mergeLocalPeplBySrvList:arySrvPeps];
	
	return YES;
}

+(BOOL)unpackSyncDownLoadPeopleList:(NSString*)jsRep PepList:(NSMutableArray*&)arySrvPeps
{
	if (!jsRep)
	{
		LOG_ERROR(@"数据为空");
		return YES;
	}
	
	NSMutableArray* jAryRoot = [NSMutableArray array];
	if (!jAryRoot)
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	jAryRoot = [jsRep JSONValue];
	
	if (![PubFunction isArrayObj:jAryRoot])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	//解析
	if ([PubFunction isObjNull:arySrvPeps])
	{
		arySrvPeps = [NSMutableArray array];		
	}
	if ([PubFunction isObjNull:arySrvPeps])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	for (id obj in jAryRoot)
	{
		TPeopleInfo* pep = [TPeopleInfo new];
		[arySrvPeps addObject:pep];
		[pep release];
		
		NSDictionary* objPep = (NSDictionary*)obj;
		pep.sGuid = pickJsonStrValue(objPep, @"dGuid");					//: "79111B26-E040-3EEF-2265-6DB68F0A6C0C",
		pep.sPersonName = pickJsonStrValue(objPep, @"sPersonName");		//: "9ec4-60df552f",
        pep.sPersonTitle = pickJsonStrValue(objPep, @"sPersonTitle");	//: "597358eb",
        pep.sSex = pickJsonStrValue(objPep, @"sSex");					//: "5973",
        pep.sBirthplace = pickJsonStrValue(objPep, @"sBirthplace");		//: "5426|A|53174eac|5e024e2d5fc3",
        pep.sTimeZone = pickJsonStrValue(objPep, @"sTimeZone");			//: "",
        pep.iLongitude = pickJsonIntValue(objPep, @"iLongitude", -1);			//: "116",
        pep.iLongitude_ex = pickJsonIntValue(objPep, @"iLongitude_ex", -1);		//: "27",
        pep.iDifRealTime = pickJsonIntValue(objPep, @"iDifRealTime", -1);		//: "0",
        pep.bLeap = pickJsonIntValue(objPep, @"bLeap", -1);						//: "0",
        pep.iYear = pickJsonIntValue(objPep, @"iYear", -1);						//: "1990",
        pep.iMonth = pickJsonIntValue(objPep, @"iMonth", -1);			//: "10",
        pep.iDay = pickJsonIntValue(objPep, @"iDay", -1);			//: "13",
        pep.iHour = pickJsonIntValue(objPep, @"iHour", -1);			//: "23",
        pep.iMinute = pickJsonIntValue(objPep, @"iMinute", -1);		//: "-1",
        pep.iLlYear = pickJsonIntValue(objPep, @"iLlYear", -1);		//: "1990",
        pep.iLlMonth = pickJsonIntValue(objPep, @"iLlMonth", -1);		//: "8",
        pep.iLlDay = pickJsonIntValue(objPep, @"iLlDay", -1);			//: "25",
        pep.sLlHour = pickJsonStrValue(objPep, @"sLlHour");					//: "5b50",
        pep.sSaveUserInput = pickJsonStrValue(objPep, @"sSaveUserInput");	//: "",
        pep.iDataOpt = pickJsonIntValue(objPep, @"iDelFlag");				//: "2",
        pep.iVersion = pickJsonIntValue(objPep, @"iVersion", -1);			//: "1286",
        pep.bIsHost = pickJsonIntValue(objPep, @"bIsHost");					//: "0",
        pep.sHeadImg = pickJsonStrValue(objPep, @"sHeadPor");				//: "",
		pep.iGroupId = pickJsonIntValue(objPep, @"iGroupId");				//: "0",
		pep.sWdZone = pickJsonStrValue(objPep, @"sWdZone");					//: "",
        pep.iTimeZone = pickJsonIntValue(objPep, @"iTimeZone", -8);			//: "-8",
        pep.iLatitude = pickJsonIntValue(objPep, @"iLatitude", -1);			//: "39",
        pep.iLatitude_ex = pickJsonIntValue(objPep, @"iLatitude_ex", -1);		//: "55"
	}
	
	return YES;
}

-(int) getMaxVerFromSrvPepList:(NSArray*)arySrvPep
{
	if ( !arySrvPep )
	{
		return 0;
	}
	
	int maxver = 0;
	for (id obj in arySrvPep)
	{
		TPeopleInfo* pep = (TPeopleInfo*)obj;
		if (pep.iVersion > maxver)
		{
			maxver = pep.iVersion;
		}
	}
	
	return maxver;
}

-(NSMutableArray*)mergeLocalPeplBySrvList:(NSMutableArray*)aryServ
{
	NSMutableArray* aryLocal = [AstroDBMng getAllPeopleInfoList];
	NSMutableArray* aryMerge = nil;
	//服务端没有数据时，直接返回
	if ([PubFunction isArrayEmpty:aryServ])
	{
		return nil;
	}
	
	//遍历服务端数据
	aryMerge = [NSMutableArray array];
	for (int i = 0; i < [aryServ count]; i++)
	{
		TPeopleInfo* pepSrv = [aryServ objectAtIndex:i];
		
		//查找本地数据
		BOOL bFindInLocal = NO;
		TPeopleInfo* pepLocal = nil;
		for (int j = 0; j < [aryLocal count]; j++)
		{
			pepLocal = [aryLocal objectAtIndex:j];
			if ([pepSrv.sGuid isEqualToString:pepLocal.sGuid])
			{
				bFindInLocal = YES;
				break;
			}
		}
		
		//本地存在
		if (bFindInLocal)
		{
			//服务端删除时
			if (pepSrv.iDataOpt == EPEPL_OPT_DEL)
			{
				//删除本地的
				pepLocal.bSynced = 1;
				pepLocal.iDataOpt = EPEPL_OPT_DEL;
				pepLocal.itmpOptFlag = EPEPL_OPT_DEL;
				[aryMerge addObject:pepLocal];
//				[AstroDBMng clearPopleBysGUID:pepLocal.sGuid];
			}
			//服务端不是删除时，以服务端数据为准
			else
			{
				//本地数据以服务端数据覆盖，且不必上传
				pepSrv.sUid = TheCurUser.sUserID;
				pepSrv.bSynced = 1;
				pepSrv.iDataOpt = EPEPL_OPT_MOD;
				pepSrv.itmpOptFlag = EPEPL_OPT_MOD;
				[aryMerge addObject:pepSrv];
//				[AstroDBMng updatePeopleInfo:pepSrv];
			}
			
		}
		//本地不存在
		else
		{
			//服务端不是删除的，本地要新增
			if (pepSrv.iDataOpt != EPEPL_OPT_DEL)
			{
				//服务端数据新增到本地列表，且后面不必同步上传
				pepSrv.sUid = TheCurUser.sUserID;
				pepSrv.bSynced = 1;
				pepSrv.iDataOpt = EPEPL_OPT_ADD;
				pepSrv.itmpOptFlag = EPEPL_OPT_ADD;
				[aryMerge addObject:pepSrv];
//				[AstroDBMng addNewPeople:pepSrv];
			}
			//服务端是删除，本地又不存在，则不管它
			else
			{
				continue;
			}

		}
	}
	
	//遍历
	
	return aryMerge;
}

@end


#pragma mark -
#pragma mark 同步上传
@implementation BussSyncUpLoad

@synthesize	sSyncDate;

-(void)dealloc
{
	self.sSyncDate = nil;
	[super dealloc];
}

-(void) StartSyncUpLoad:(id)target :(SEL)selector
{
	self.delgtPackData = self;
	NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"uploaddata" UserSID:TheCurUser.sSID];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//JSON
-(NSString*) PackSendOutJsonString
{
	@try
	{
		NSMutableDictionary* jobjRoot = [NSMutableDictionary dictionary];
		if (!jobjRoot)
		{
			return nil;
		}
		
		[jobjRoot setObject:@"UapUl_PepList" forKey:@"option"];
		[jobjRoot setObject:@"2.0" forKey:@"vercode"];
		
		//数据表
		NSMutableDictionary* jobjPara = [NSMutableDictionary dictionary];
		if ( jobjPara )
		{
			[jobjPara setObject:TheCurUser.sSrvTbName forKey:@"szTabname"];
		}
		[jobjRoot setObject:jobjPara forKey:@"param"];
		
		//命造列表数据
		NSMutableArray* jobjData = [NSMutableArray array];
		if (jobjData)
		{
			//人员列表
			NSArray* aryPep = [AstroDBMng getBeSyncdPeopleInfoList];
			for(int i = 0; aryPep != nil && i < [aryPep count]; i ++)
			{
				NSMutableDictionary* jobjPep = [NSMutableDictionary dictionary];
				TPeopleInfo* pep = (TPeopleInfo*)[aryPep objectAtIndex:i];
				if (!jobjPep || !pep)
				{
					continue;
				}
                
                //对一些参数进行处理
                if ( pep.iLatitude == 0 ) pep.iLatitude = 39;
                if ( pep.iLatitude_ex == 0 ) pep.iLatitude_ex = 55;
                if ( pep.iLongitude == 0 ) pep.iLongitude = 116;
                if ( pep.iLongitude_ex == 0 ) pep.iLongitude_ex = 27;
                if ( pep.iTimeZone == 0 ) pep.iTimeZone = -8;
                if ( ![pep.sTimeZone isEqualToString:@"E"] && ![pep.sTimeZone isEqualToString:@"W"] ) pep.sTimeZone = @"E";
                if ( ![pep.sWdZone isEqualToString:@"N"] && ![pep.sWdZone isEqualToString:@"S"] ) pep.sWdZone = @"N";
				
				//人员参数
				[jobjPep setObject:[NSNumber numberWithInt:pep.bIsHost] forKey:@"bIsHost"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.bLeap] forKey:@"bLeap"];
				[jobjPep setObject:pep.sGuid forKey:@"dGuid"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iDay] forKey:@"iDay"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iDataOpt] forKey:@"iDelFlag"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iDifRealTime] forKey:@"iDifRealTime"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iGroupId] forKey:@"iGroupId"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iHour] forKey:@"iHour"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLatitude] forKey:@"iLatitude"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLatitude_ex] forKey:@"iLatitude_ex"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLlDay] forKey:@"iLlDay"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLlMonth] forKey:@"iLlMonth"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLlYear] forKey:@"iLlYear"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLongitude] forKey:@"iLongitude"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iLongitude_ex] forKey:@"iLongitude_ex"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iMinute] forKey:@"iMinute"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iMonth] forKey:@"iMonth"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iTimeZone] forKey:@"iTimeZone"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iVersion] forKey:@"iVersion"];
				[jobjPep setObject:[NSNumber numberWithInt:pep.iYear] forKey:@"iYear"];
				[jobjPep setObject:pep.sBirthplace forKey:@"sBirthplace"];
				[jobjPep setObject:pep.sHeadImg forKey:@"sHeadPor"];
				[jobjPep setObject:pep.sLlHour forKey:@"sLlHour"];
				[jobjPep setObject:pep.sPersonName forKey:@"sPersonName"];
				[jobjPep setObject:pep.sPersonTitle forKey:@"sPersonTitle"];
				[jobjPep setObject:pep.sSaveUserInput forKey:@"sSaveUserInput"];
				[jobjPep setObject:pep.sSex forKey:@"sSex"];
				[jobjPep setObject:pep.sTimeZone forKey:@"sTimeZone"];
				[jobjPep setObject:pep.sWdZone forKey:@"sWdZone"];
				
				[jobjData addObject:jobjPep];
			}
		}
		[jobjRoot setObject:jobjData forKey:@"data"];
		
		//转成JSON字符串
        [jobjRoot setObject:LANGCODE forKey:@"langcode"];
		NSString* strJson = [jobjRoot JSONRepresentation];
		return strJson;
	}
	@catch (NSException * e)
	{
		return nil;
	}
	
	return nil;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"同步下载：收到数据预处理错误");
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		else
		{
			return NO;
		}
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		LOG_ERROR(@"同步下载：收到数据预处理错误");
		return NO;
	}
	
	return YES;
}


@end


#pragma mark -
#pragma mark 同步下载
@implementation BussSync

@synthesize	sSyncDate;
@synthesize synLogin;
@synthesize synDown;
@synthesize synUp;	
@synthesize retvObj;	
@synthesize retvFunc;
@synthesize isBeginTransct;
@synthesize isEndTransct;	
@synthesize sHostPepGUID;
@synthesize iCurStep;
@synthesize iCurProg;		


-(id)init
{
	self = [super init];
	if (self)
	{
		self.sSyncDate = @"";
		self.synLogin = nil;
		self.synDown = nil;
		self.synUp = nil;
		self.retvObj = nil;
		self.retvFunc = nil;
		self.sHostPepGUID = @"";
	}
	return self;
}

-(void)dealloc
{
	self.sSyncDate = nil;
	[synLogin destroyBussReqObj];
	self.synLogin = nil;
	[synDown destroyBussReqObj];
	self.synDown = nil;
	[synUp destroyBussReqObj];
	self.synUp = nil;
	self.retvObj = nil;
	self.retvFunc = nil;
	self.sHostPepGUID = nil;
	
	[self dbRollback];
	
	[super dealloc];
}

//开始同步下载
-(void) StartSync:(id)target :(SEL)selector
{
	self.retvObj = target;
	self.retvFunc = selector;
	self.iCurStep = ECurSynStep_PreLogin;
	
	if ([TheCurUser isDefaultUser])
	{
		[self notifyUICallBack:0 Msg:LOC_STR("qxdrhztb") Type:EPRMPTMSG_INFO IsStop:YES];
		return;
	}
//	else if([PubFunction stringIsNullOrEmpty:TheCurUser.sSID])
//	{
//		[self notifyUICallBack:0 Msg:@"请先登录后再同步" Type:EPRMPTMSG_INFO IsStop:YES];
//		return;
//	}

	[self notifyUICallBack:0 Msg:LOC_STR("st_kstb") Type:EPRMPTMSG_INFO IsStop:NO];
	@try
	{
		if([PubFunction stringIsNullOrEmpty:TheCurUser.sSID])
		{
			[self notifyUICallBack:0 Msg:LOC_STR("drzh") Type:EPRMPTMSG_INFO IsStop:NO];
			[self InvokeRelogin];
			return;
		}
		else
		{
			self.iCurStep = ECurSynStep_SynDown;
			[self notifyUICallBack:5 Msg:LOC_STR("xzmzsj") Type:EPRMPTMSG_INFO IsStop:NO];
			self.isBeginTransct = [[AstroDBMng getDbUserLocal] beginTransaction];
			[self InvokeSyncDown];
		}
		
		
	}
	@catch (NSException * e)
	{
		[self dbRollback];
		[self notifyUICallBack:5 Msg:LOC_STR("xzmzsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		
		return;
	}
	@finally
	{
		
	}
}

-(void) InvokeSyncDown
{
	BussSyncDownLoad* syndwn = [BussSyncDownLoad new];
	[synDown destroyBussReqObj];
	self.synDown = syndwn;
	[syndwn release];
	
	[self.synDown StartSyncDownLoad:self :@selector(onRetriveSyncDownLoad:)];
}

-(void) InvokeSyncUp
{
	BussSyncUpLoad* synup = [BussSyncUpLoad new];
	[synUp destroyBussReqObj];
	self.synUp = synup;
	[synup release];
	
	[self.synUp StartSyncUpLoad:self :@selector(onRetriveSyncUpLoad:)];
}

-(void) InvokeRelogin
{
	//先登录
	if (!self.synLogin)
	{
		[synLogin destroyBussReqObj];
        BussLogin *login = [BussLogin new];
		self.synLogin = login;
        [login release];
	}
	[self.synLogin AutoLogin:self ResponseSelector:@selector(onRetriveRelogin:)];
}

//同步下载返回
-(void)onRetriveSyncDownLoad:(id)err
{
	//错误时，通知并返回
	if (![PubFunction isObjNull:err] && [err isKindOfClass:[NSError class]])
	{
		if (self.synDown.iHttpCode == 401)
		{
			//超时重登录
			NSLog(@"同步前，超时重登录");
			[self notifyUICallBack:25 Msg:LOC_STR("zhcdr") Type:EPRMPTMSG_INFO IsStop:NO];
			[self InvokeRelogin];
			return;
		}
		else
		{
			[self dbRollback];
			[self notifyUICallBack:25 Msg:LOC_STR("jxmzsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		}

		return;
	}
	
	
	//成功
	[self notifyUICallBack:30 Msg:LOC_STR("gxbdsj") Type:EPRMPTMSG_INFO IsStop:NO];
	TPeopleInfo* pepHost = [TPeopleInfo new];
	@try
	{
		//先保存本地HOST
		if( [AstroDBMng getHostPeopleInfo:pepHost] )
		{
			self.sHostPepGUID = pepHost.sGuid;
		}
		
		//下载的数据更新到本地数据库
		[self updateLocalDbBySrv];
		
		//更新主人设置
		[self updateHostPeople];
		
		//上传前要更新所以待上传记录的版本到最新版本号
		[self updateShouldSynPeopleVersionToLast];

	}
	@catch (NSException * e)
	{
		[self dbRollback];
		[self notifyUICallBack:40 Msg:LOC_STR("gxbdsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		return;
	}
	@finally
	{
		[pepHost release];
	}
	
	//同步上传
	[self notifyUICallBack:50 Msg:LOC_STR("scmzsj") Type:EPRMPTMSG_INFO IsStop:NO];
	@try
	{
		int nAllSyn = [AstroDBMng getBeSyncdPeopleCount];
		if (nAllSyn < 1)
		{
			//更新版本号、标识等
			[self updateSyncedResult];
			//保存数据
			[self dbCommit];
			//返回
			[self notifyUICallBack:100 Msg:@"同步完成" Type:EPRMPTMSG_INFO IsStop:YES];
			return;
		}
		else
		{
			self.iCurStep = ECurSynStep_SynUp;
			[self InvokeSyncUp];
		}
	}
	@catch (NSException * e)
	{
		[self dbRollback];
		[self notifyUICallBack:55 Msg:LOC_STR("scmzsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		return;
	}
	@finally
	{
		
	}
}

//同步上传返回
-(void)onRetriveSyncUpLoad:(id)err
{
	//错误时，通知并返回
	if (![PubFunction isObjNull:err] && [err isKindOfClass:[NSError class]])
	{
		if (self.synUp.iHttpCode == 401)
		{
			//超时重登录
			NSLog(@"同步前，超时重登录");
			[self notifyUICallBack:75 Msg:LOC_STR("zhcdr") Type:EPRMPTMSG_INFO IsStop:NO];
			[self InvokeRelogin];
			return;
		}
		else
		{
			[self dbRollback];
			[self notifyUICallBack:75 Msg:LOC_STR("scmzsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
			return;
		}
	}
	[self notifyUICallBack:75 Msg:LOC_STR("scmzsjwc") Type:EPRMPTMSG_INFO IsStop:NO];
	
	//成功
	[self notifyUICallBack:85 Msg:@"更新本地同步信息..." Type:EPRMPTMSG_INFO IsStop:NO];
	@try
	{
		//更新版本号、标识等
		[self updateSyncedResult];
		//保存数据
		[self dbCommit];
		[self notifyUICallBack:95 Msg:@"更新本地同步信息..." Type:EPRMPTMSG_INFO IsStop:NO];
	}
	@catch (NSException * e)
	{
		[self dbRollback];
		[self notifyUICallBack:95 Msg:LOC_STR("gxbdtbxxsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		return;
	}
	@finally
	{
	}
	
	[self notifyUICallBack:100 Msg:@"同步完成!" Type:EPRMPTMSG_INFO IsStop:YES];
	
}

//重登录
-(void)onRetriveRelogin:(id)err
{
	//错误时，通知并返回
	if (![PubFunction isObjNull:err] && [err isKindOfClass:[NSError class]])
	{
		[self dbRollback];
		[self notifyUICallBack:self.iCurProg Msg:LOC_STR("scmzsjsb") Type:EPRMPTMSG_ERROR IsStop:YES];
		return;
	}
	
	//
	[synLogin destroyBussReqObj];
	self.synLogin = nil;
	
	//否则，继续
	if (!self.isBeginTransct)
	{
		self.isBeginTransct = [[AstroDBMng getDbUserLocal] beginTransaction];
	}
	
	switch (self.iCurStep)
	{
		case ECurSynStep_PreLogin:
		case ECurSynStep_SynDown:
		{
			self.iCurStep = ECurSynStep_SynDown;
			[self notifyUICallBack:self.iCurProg Msg:LOC_STR("xzmzsj") Type:EPRMPTMSG_INFO IsStop:NO];
			[self InvokeSyncDown];
		}
			break;
			
		case ECurSynStep_SynUp:
		{
			self.iCurStep = ECurSynStep_SynUp;
			[self notifyUICallBack:self.iCurProg Msg:LOC_STR("scmzsj") Type:EPRMPTMSG_INFO IsStop:NO];
			[self InvokeSyncUp];
		}
			break;
			
		default:
			break;
	}
	
}


-(void) updateSyncedResult
{
	//更新同步版本
	if (self.synDown && self.synDown.aryShoudHandleSrvPep && [self.synDown.aryShoudHandleSrvPep count] > 0)
	{
		int oldver = [AstroDBMng getLocalSyncVer];
		if (oldver < self.synDown.iSrvMaxVer)
		{
			[AstroDBMng setLocalSynVer:self.synDown.iSrvMaxVer];
		}
	}
	//更新同步标识
	[AstroDBMng setAllPeopleSynced];
}


-(void)updateLocalDbBySrv
{
	for (int i = 0; self.synDown.aryShoudHandleSrvPep && i<[self.synDown.aryShoudHandleSrvPep count]; i++)
	{
		TPeopleInfo* pep = (TPeopleInfo*) [self.synDown.aryShoudHandleSrvPep objectAtIndex:i];
		
		switch (pep.itmpOptFlag)
		{
			case EPEPL_OPT_DEL:
				[AstroDBMng synUpdatePeopleInfo:pep];
				break;
				
			case EPEPL_OPT_MOD:
			{
				//本地数据
				TPeopleInfo* pepLocal = [AstroDBMng getPeopleInfoBysGUID:pep.sGuid];
				if (!pepLocal)
				{
					[AstroDBMng synUpdatePeopleInfo:pep];
					break;
				}
				//服务端没修改，且本地有修改时，以本地为准;
				int lastSynVer = [AstroDBMng getLocalSyncVer];
				if (pep.iVersion <= lastSynVer && pepLocal.iVersion > lastSynVer)
				{
					pepLocal.bSynced = 0;
					[AstroDBMng synUpdatePeopleInfo:pepLocal];
				}
				//否则，以服务端为准;
				else
				{
					[AstroDBMng synUpdatePeopleInfo:pep];
				}
			}
				break;
				
			case EPEPL_OPT_ADD:
                pep.iDataOpt = EPEPL_OPT_MOD; //add 2012.9.24
				[AstroDBMng synAddNewPeople:pep];
				break;
				
			default:
				break;
		}
	}
}

-(void)updateShouldSynPeopleVersionToLast
{
    if (self.synDown && self.synDown.aryShoudHandleSrvPep && [self.synDown.aryShoudHandleSrvPep count] > 0) //add 2012.8.20
    {
        NSMutableArray* aryShoudSyn = [AstroDBMng getBeSyncdPeopleInfoList];
        for (int i = 0; aryShoudSyn && (i < [aryShoudSyn count]); i++)
        {
            TPeopleInfo* pep = [aryShoudSyn objectAtIndex:i];
            pep.iVersion = self.synDown.iSrvMaxVer + 1;
            //[AstroDBMng updatePeopleInfo:pep];   //comment 2012.8.20
            [AstroDBMng synUpdatePeopleInfo:pep];   //2012.8.20，直接更新就可以了
        }
    }
}

//更新主人设置
-(void) updateHostPeople
{
	NSMutableArray* aryHostPep = [AstroDBMng getHostPeopleList];
	//
	if ([PubFunction isArrayEmpty:aryHostPep])
	{
		//设置第1个非删除命造为主人
		int nRet = 0;
		TPeopleInfo* pepFirst = [AstroDBMng getFirstUnDelPeople];
		if (pepFirst)
		{
			pepFirst.bIsHost = 1;
			pepFirst.bSynced = 0;
            pepFirst.iDataOpt = EPEPL_OPT_MOD;  //ADD 2012.9.24
			nRet = [AstroDBMng synUpdatePeopleInfo:pepFirst];
		}
		
		//如果还错误，没办法了。返回。
		if (nRet < 1)
		{
			LOG_ERROR(@"设置主命造出错");
			return;
		}
	}
	//
	else if([aryHostPep count] == 1)
	{
		return;
	}
	//
	else if([aryHostPep count] > 1)
	{
		//多个命造时，第1个非本地原来的主人的记录为主人
		
		//查找保留的那个
		TPeopleInfo* pepHoldHost = nil;
		BOOL isOldNoHost = [PubFunction stringIsNullOrEmpty:self.sHostPepGUID];
		//原本没有主人时，取第1个为主人
		if (isOldNoHost)
		{
			pepHoldHost = [aryHostPep objectAtIndex:0];
		}
		//原本有主人时，取第1个其他人为主人
		else
		{
			for (int i = 0; i < [aryHostPep count]; i++)
			{
				TPeopleInfo* pep = [aryHostPep objectAtIndex:i];
				if ( ![pep.sGuid isEqualToString:self.sHostPepGUID])
				{
					pepHoldHost = pep;
					break;
				}
				
			}
		}
		
		//未找到，出错，返回
		if (!pepHoldHost)
		{
			LOG_ERROR(@"设置主命造出错");
			return;
		}
		//找到了，则将其他的设置为非主命造
		else
		{		
			for (int i = 0; i < [aryHostPep count]; i++)
			{
				TPeopleInfo* pep = [aryHostPep objectAtIndex:i];
				if ( [pep.sGuid isEqualToString:pepHoldHost.sGuid])
				{
					continue;
				}
				
				pep.bIsHost = 0;
				pep.bSynced = 0;
				[AstroDBMng synUpdatePeopleInfo:pep];
			}
			
			//新的主人
			self.sHostPepGUID = pepHoldHost.sGuid;
		}
	}
	
	return;
}


//同步进度提示数据
-(NSDictionary*)makeSyncProgressInfo:(int)iPercent Msg:(NSString*)sMsg Type:(int)iType IsStop:(BOOL)bStop
{
	NSMutableDictionary* proInf = [NSMutableDictionary dictionary];
	//提示消息内容
	[proInf setObject:sMsg forKey:@"msg"];
	//消息类型
	[proInf setObject:[NSNumber numberWithInt:iType] forKey:@"iType"];
	//同步进度
	[proInf setObject:[NSNumber numberWithInt:iPercent] forKey:@"iPercent"];
	//是否终止
	if(iPercent >= 100)
		bStop = YES;
	[proInf setObject:[NSNumber numberWithBool:bStop] forKey:@"isStop"];
	
	return proInf;
}

-(void)notifyUICallBack:(int)iPercent Msg:(NSString*)sMsg Type:(int)iType IsStop:(BOOL)bStop
{
	self.iCurProg = iPercent;
	
	if ( self.retvObj && [self.retvObj respondsToSelector:self.retvFunc])
	{
		NSDictionary* noteinfo = [self makeSyncProgressInfo:iPercent Msg:sMsg Type:iType IsStop:bStop];
		[self.retvObj performSelectorOnMainThread:self.retvFunc withObject:noteinfo waitUntilDone:NO];
	}
}

-(void)dbRollback
{
	if (isBeginTransct && !isEndTransct)
	{
		self.isEndTransct = [[AstroDBMng getDbUserLocal] rollbackTransaction];
	}
}

-(void)dbCommit
{
	if (isBeginTransct && !isEndTransct)
	{
		self.isEndTransct = [[AstroDBMng getDbUserLocal] commitTransaction];
	}
}

@end



#pragma mark -
#pragma mark 检查新版本
@implementation BussCheckVersion

@synthesize sCheckDate;

-(void)dealloc
{
	self.sCheckDate = nil;
	[super dealloc];
}

-(void)checkNewVersion:(id)target :(SEL)selector
{
	self.delgtPackData = self;
	self.sCheckDate = [PubFunction getTodayStr];
	NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"getverinfo"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//
-(NSString*) PackSendOutJsonString
{
	NSString *strJson = [NSString stringWithFormat: @"{\"iSoftware\":\"%@\"}", CS_SOFT_ID];
	return strJson;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSMutableArray* jsAryObj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsAryObj HttpStatus:self.iHttpCode Error:err] )
	{
		if (self.iHttpCode == 200)
		{
			*err = nil;
			return YES;
		}
		
		LOG_ERROR(@"检查新版本：收到数据预处理错误");
		return NO;
	}
	
	if ([PubFunction isObjNull:jsAryObj] || ![PubFunction isObjNull:*err])
	{
		LOG_ERROR(@"检查新版本：收到数据预处理错误");
		return NO;
	}
	
	//TODO: 保存数据
	[AstroDBMng replaceVerCheckResult:rcvData];
	
	return YES;
}

+(BOOL) unpackJsonCheckVersion:(NSString*)sJson :(TCheckVersionResult*)dout
{
	if (!dout)
	{
		return NO;
	}
	
	if ([PubFunction stringIsNullOrEmpty:sJson])
	{
		LOG_ERROR(@"版本检查:JSON数据为空");
		return NO;
	}
	NSMutableArray *objAryVerInf = [sJson JSONValue]; 
	if (!objAryVerInf )
	{
		LOG_ERROR(@"JSON数据为空");
		return nil;
	}
	if (![PubFunction isArrayObj:objAryVerInf])
	{
		LOG_ERROR(@"JSON数据结构出错");
		return NO;
	}
	if ([objAryVerInf count] < 1)
	{
		LOG_ERROR(@"JSON数据为空");
		return NO;
	}
	
	NSDictionary* objVerInf = [objAryVerInf objectAtIndex:0];
	
	dout.sVerCode = [objVerInf objectForKey:@"sVerCode"]; 
	dout.sDownURL = [objVerInf	objectForKey:@"sDownUrl"]; 
	return YES;
}


// 比较版本大小，value1>value2
+(NSComparisonResult) compareVersion:(NSString *)value1 :(NSString *)value2
{
	value1 = [[value1 stringByReplacingOccurrencesOfString:@"V" withString:@""] stringByReplacingOccurrencesOfString:@"v" withString:@""];
	value2 = [[value2 stringByReplacingOccurrencesOfString:@"V" withString:@""] stringByReplacingOccurrencesOfString:@"v" withString:@""];
	
    NSArray *value1Array = [value1 componentsSeparatedByString:@"."];
    NSArray *value2Array = [value2 componentsSeparatedByString:@"."];
    
    NSComparisonResult compareResult;
    for (NSInteger i=0; i<[value1Array count]; i++)
    {
        if ([value2Array count]>=i+1)
        {
            NSString *oneWord1 = [value1Array objectAtIndex:i];
            NSString *oneWord2 = [value2Array objectAtIndex:i];
            NSInteger intValue1 = [oneWord1 intValue];
            NSInteger intValue2 = [oneWord2 intValue];
            if (intValue1 > intValue2)
            {
                compareResult = NSOrderedDescending;
                break;
            }
            else if (intValue1 < intValue2)
            {
                compareResult = NSOrderedAscending;
                break;
            }
            else
                compareResult = NSOrderedSame;
        }
    }
    if (compareResult == NSOrderedSame)
    {
        if ([value1Array count]>[value2Array count])
            return NSOrderedDescending;
        else if ([value1Array count]==[value2Array count])
            return NSOrderedSame;
        else if ([value1Array count]<[value2Array count])
            return NSOrderedAscending;
    }
    return compareResult;
}


@end


#pragma mark -
#pragma mark 悬赏、建议
@implementation BussSuggest

@synthesize iBussType;
@synthesize sReqTime;
@synthesize sSuggest;
@synthesize sSendQuestNO;
@synthesize sendObj;
@synthesize sendFunc;
@synthesize getAnsObj;
@synthesize getAnsFunc;

-(void)dealloc
{
	self.sReqTime = nil;
	self.sSuggest = nil;
	self.sSendQuestNO = nil;
	self.sendObj = nil;
	self.sendFunc = nil;
	self.getAnsObj = nil;
	self.getAnsFunc = nil;
	
	[super dealloc];
}

//发送建议
-(void)sendSuggest:(NSString*)sAsk :(id)target :(SEL)selector
{
	self.delgtPackData = self;
	self.iBussType = ESuggestType_Send;
	self.sReqTime = [PubFunction getTimeStr1];
	self.sSuggest = sAsk;
	NSString *url = [NSString stringWithFormat:@"%@%@", CS_ADVICE_BASE_URL, CS_ADVICE_FUNC_SEND];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

//取得回复
-(void)reqSuggestAnswer:(id)target :(SEL)selector
{
	self.delgtPackData = self;
	self.iBussType = ESuggestType_Get;
	self.sReqTime = [PubFunction getTimeStr1];
	NSString *url = [NSString stringWithFormat:@"%@%@", CS_ADVICE_BASE_URL, CS_ADVICE_FUNC_GET];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	if (self.iBussType == ESuggestType_Send)
	{
		return [self PackSuggestSendJsonString];
		
	}
	if (self.iBussType == ESuggestType_Get)
	{
		return [self PackSuggestGetAnswerJsonString];
	}
	else
	{
		return @"";
	}

}

-(NSString*) PackSuggestSendJsonString
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];	
	
	[dict setObject:XUANSHANG_ID forKey:@"productid"];
	[dict setObject:@"iPhone算命" forKey:@"product"];
	NSMutableString* sTemp = [NSMutableString stringWithString:@"1111"];
    //[NSMutableString stringWithString:[PubFunction replaceStr:[UIDevice uniqueDeviceIdWithBase64Encode] :@"-" :@""]];
	[dict setObject:[sTemp lowercaseString] forKey:@"localid"];
	sTemp = [NSMutableString stringWithString:[PubFunction replaceStr:[PubFunction newUUID] :@"-" :@""]];
	self.sSendQuestNO = [sTemp lowercaseString];
	[dict setObject:self.sSendQuestNO forKey:@"questno"];
	[dict setObject:self.sSuggest forKey:@"quest"];
	[dict setObject:[[UIDevice currentDevice] model] forKey:@"type"];
	[dict setObject:[[UIDevice currentDevice] systemName] forKey:@"os"];
	[dict setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
	[dict setObject:version forKey:@"app_version"];
    
	[dict setObject:LANGCODE forKey:@"langcode"];
	NSString* json = [dict JSONRepresentation];
	return json;
}

-(NSString*) PackSuggestGetAnswerJsonString
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];	
	
	[dict setObject:XUANSHANG_ID forKey:@"productid"];
	NSMutableString* sTemp = [NSMutableString stringWithString:@"1111"];
    //[NSMutableString stringWithString:[PubFunction replaceStr:[UIDevice uniqueDeviceIdWithBase64Encode] :@"-" :@""]];
	[dict setObject:[sTemp lowercaseString] forKey:@"localid"];
	
	NSMutableArray* aryQues = [NSMutableArray array];
	[dict setObject:aryQues forKey:@"vecquestno"];
	
	//所有未回复问题
	NSArray* aryQuesNO = [AstroDBMng getUnanswerQuestions];
	for (id sQuesNo in aryQuesNO)
	{
		NSMutableDictionary* dctQues = [NSMutableDictionary dictionary];
		[dctQues setObject:sQuesNo forKey:@"questno"];
		[aryQues addObject:dctQues];
	}
    
	[dict setObject:LANGCODE forKey:@"langcode"];
	NSString* json = [dict JSONRepresentation];
	return json;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	if (self.iBussType == ESuggestType_Send)
	{
		BOOL bRes = [self procSendResult:err];
		return bRes;
	}
	else if (self.iBussType == ESuggestType_Get)
	{
		return [self procAnswerResult:rcvData Error:err];
	}
	else
	{
		return NO;
	}
}

-(BOOL)procSendResult:(NSError**)err
{
	if (self.iHttpCode == 200)
	{
		LOG_ERROR(@"提交建议成功");
		
		//保存数据
		[AstroDBMng addNewQuestion:self.sSuggest QuestNO:self.sSendQuestNO Time:self.sReqTime];
		return YES;
	}
	else
	{
		NSString* errHttp = [BussInterImplBase getHttpStatusDescByCode:self.iHttpCode];
		*err = [NSError errorWithDomain:errHttp code:NSFormattingError userInfo:nil];
		
		LOG_ERROR(@"提交建议失败：errcode=%d, errstr=%@", [*err code], [*err localizedFailureReason]);
		return NO;
	}
}

-(BOOL) procAnswerResult:(id)rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		if (self.iHttpCode == 200)
		{
			LOG_ERROR(@"没有新回复内容,此时也算成功.");
			*err = nil;
			return YES;
		}
		else
		{
			return NO;
		}
	}
	
	if ([PubFunction isObjNull:jsobj] || ![PubFunction isObjNull:*err])
	{
		LOG_ERROR(@"获取建议回复失败");
		return NO;
	}
	
	//解析
	NSMutableArray* aryAns = [NSMutableArray array];
	[self unpackJsonGetAnswer:jsobj :aryAns];
	
	//保存数据
	for (id obj in aryAns)
	{
		TBussSuggestAnswer* objAns = (TBussSuggestAnswer*)obj;
		//未回复时，不加入答案表
		if (objAns.flag != 1)
		{
			continue;
		}
		
		[AstroDBMng addNewAnswer:objAns.sQuesNO Answer:objAns.sAnswer Time:objAns.sAnsTime];
	}
	[AstroDBMng updateQuestionFlagByAnswerTable];
	
	return YES;
}

-(BOOL) unpackJsonGetAnswer:(NSDictionary*)jObjRoot :(NSMutableArray*)aryAns
{
	if (!jObjRoot || !aryAns)
	{
		LOG_ERROR(@"数据为空");
		return YES;
	}
	
	NSMutableArray* jAryAns = [jObjRoot objectForKey:@"vecanswer"];
	if (![PubFunction isArrayObj:jAryAns])
	{
		LOG_ERROR(@"返回数据解析出错:");
		return NO;
	}
	
	for (id jAns in jAryAns)
	{
		TBussSuggestAnswer* objAns = [TBussSuggestAnswer new];
		[aryAns addObject:objAns];
		[objAns release];
		
		objAns.sQuesNO = [jAns objectForKey:@"questno"];
		NSTimeInterval tmIntv = [[jAns objectForKey:@"ask_time"] longLongValue]; 
		objAns.sAskTime = [PubFunction dateStringFromTimeIntervalSince1970:tmIntv];
		
		NSString* sTmp = [jAns objectForKey:@"answer"];
		if (![PubFunction isObjNull:sTmp])
		{
			objAns.sAnswer = sTmp;
		}
		sTmp = [jAns objectForKey:@"answer_time"];
		if (![PubFunction isObjNull:sTmp])
		{
			tmIntv = [sTmp longLongValue];
			objAns.sAnsTime = [PubFunction dateStringFromTimeIntervalSince1970:tmIntv];
		}
		objAns.flag = [[jAns objectForKey:@"flag"] intValue];
	}
	
	return YES;
}
	

@end

@implementation BussAppInfo
@synthesize dbAppList;

- (void) dealloc
{
    self.dbAppList = nil;
    [super dealloc];
    
}
                

//获取本地已经下载的软件列表
- (AppInfoList*) getAppInfoCacheList
{
    NSString* js = [AstroDBMng getUserCfg:@"app_info_list" Cond:@"" Default:@""];
    if ([PubFunction stringIsNullOrEmpty:js])
        return nil;
    
    self.dbAppList =  [self unpackAppInfoList:js];
    
    return dbAppList;
}

//获取网络软件列表 异步
- (void)updateAppInfoCacheList:(id)target :(SEL)selector
{
    if (dbAppList==nil || dbAppList.appVersion<=1)
        updateSts = BS_DOWNLOAD;
    else
        updateSts = BS_CHECK;
    
    cbFun = selector;
    cbObj = target;
    self.delgtPackData = self;
    //NSString *url = [NSString stringWithFormat:@"%@?sid=%@", CS_URL_UPDATE_APPINFO, TheCurUser.sSID];
	[self HttpRequest:CS_URL_UPDATE_APPINFO Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(requestCallback:)];
}

- (NSString*) PackSendOutJsonString
{
    int ver = 1;
    if (updateSts==BS_CHECK)
        ver = dbAppList.appVersion;
    
#ifdef APPSTORE_VERSION
    int bkFlag = 0;  //越狱标志
#else
    int bkFlag = 1;
#endif
    
    return [NSString stringWithFormat:@"{\"nAppId\":\"%@\",\"nAppVersoin\":%d, \"nSoftVersoin\":0, \"nBreakFlag\":%d}",
            XUANSHANG_ID, ver, bkFlag];
    
   //  return [NSString stringWithFormat:@"{\"nAppId\":\"%@\",\"nAppVersoin\":%d, \"nSoftVersoin\":0, \"nBreakFlag\":0}", @"8032", ver];

    //黄历天气8032 8062

}

- (void) requestCallback :(id)result
{
    NSString* curJs = nil; 
        
    if (updateSts==BS_CHECK)
    {
        if ([result isKindOfClass:[NSError class]])
        {
            [cbObj performSelector:cbFun withObject:nil withObject:nil];
            return;
        }
        
        curJs = (NSString*)result;
        NSLog(@"result:httpcode=%d %@",iHttpCode,curJs);
        
        if ( iHttpCode==206 ) 
        {
            //206是丢失备份数据，需重新下载。
            updateSts = BS_DOWNLOAD;
            [self HttpRequest:CS_URL_UPDATE_APPINFO Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(requestCallback:)];
            return;
        }
        if (iHttpCode==204 || [PubFunction stringIsNullOrEmpty:curJs])
        {
            [cbObj performSelector:cbFun withObject:nil withObject:nil];
            return;  
        }
        
        if (iHttpCode!=200 || result==nil)
        {
            [cbObj performSelector:cbFun withObject:nil withObject:LOC_STR("hqtjrjlbsb")];
            return;
        }
       
        int curVersion = 0;
        
        if (![self getCurVerion:curJs :&curVersion])
        {
            [cbObj performSelector:cbFun withObject:nil withObject:LOC_STR("hqtjrjlbsb")];
            return;
        }
        
        if (curVersion==dbAppList.appVersion)
        {
           [cbObj performSelector:cbFun withObject:nil withObject:nil];
            return;
        }
        
        //重新下载所有软件列表
        updateSts = BS_DOWNLOAD;
        [self HttpRequest:CS_URL_UPDATE_APPINFO Method:HTTP_METHOD_POST ResponseTarget:self ResponseSelector:@selector(requestCallback:)];
        
        return;
    }
    
    if ([result isKindOfClass:[NSError class]])
    {
        [cbObj performSelector:cbFun withObject:nil withObject:((NSError*)result).domain];
        return;
    }
    
    curJs = (NSString*)result;
    NSLog(@"result:httpcode=%d %@",iHttpCode,curJs);
    
    if (iHttpCode==204 || [PubFunction stringIsNullOrEmpty:curJs])
    {
        [cbObj performSelector:cbFun withObject:nil withObject:LOC_STR("hqtjrjlbwk")];
        return;  
    }
    
    if (iHttpCode!=200 || result==nil)
    {
        [cbObj performSelector:cbFun withObject:nil withObject:LOC_STR("hqtjrjlbsb")];
        return;
    }
    
    AppInfoList *curList = [self unpackAppInfoList:curJs];
    
    if (curList==nil)
    {
        [cbObj performSelector:cbFun withObject:nil withObject:LOC_STR("hqtjrjlbwk")];
        return; 
    }
    //下载图标
    NSArray* infos = curList.aryAppInfo;
    for (AppInfo* info in infos)
    {
        if (![PubFunction stringIsNullOrEmpty:info.icoPath])
            [UIImage saveToWebCache:info.icoPath]; // 下载图标文件
    }
    
    [AstroDBMng setUserCfg:@"app_info_list" Cond:@"" Val:curJs];
    self.dbAppList = curList;
    [cbObj performSelector:cbFun withObject:dbAppList withObject:@"reload"];
    return;
   
}

- (AppInfoList*) unpackAppInfoList:(NSString*)js
{
    NSDictionary *nodes = [js JSONValue]; 		
    if (nodes == nil)
        return nil;
    
    AppInfoList* appList = [[AppInfoList new] autorelease];
    
    appList.baseHost = [nodes objectForKey:@"nBaseHost"]; 
    appList.appVersion = [[nodes objectForKey:@"nAppVersoin"] intValue];
    NSDictionary* appInfos = [nodes objectForKey:@"arrSoftInfo"];
    if (appInfos == nil)
        return nil;
    
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSDictionary* info in appInfos)
    {
        AppInfo *item = [AppInfo new];
        @try 
        {
            item.softID = [[info objectForKey:@"nSoftId"] intValue]; 
            item.softVersion = [[info objectForKey:@"nSoftVersoin"] intValue]; 
            
            item.appID = [[info objectForKey:@"nAppId"] intValue]; 
            item.appVersion = [[info objectForKey:@"nAppVersoin"] intValue]; 
            item.appName = [info objectForKey:@"sAppName"]; 
            
            item.typeName = [info objectForKey:@"sTypeName"]; 
            item.typeSort = [[info objectForKey:@"nTypeSort"] intValue]; 
            item.softIdVersion = [[info objectForKey:@"nSoftIdVersion"] intValue]; 
            item.softSort = [[info objectForKey:@"nSoftSort"] intValue]; 
            item.optFlag = [[info objectForKey:@"nOptFlag"] intValue]; 
            item.previewPathFlag = [[info objectForKey:@"nPreviewPathFlag"] intValue]; 
            item.icoPathFlag = [[info objectForKey:@"nIcoPathFlag"] intValue]; 
            item.softInfoId = [[info objectForKey:@"nSoftInfoId"] intValue]; 
            item.softVersion1 = [[info objectForKey:@"sSoftversion"] intValue]; 
            item.softInfoVersion = [[info objectForKey:@"nSoftInfoversion"] intValue]; 
            item.softName = [info objectForKey:@"sSoftName"]; 
            item.company = [info objectForKey:@"sScompany"]; 
            item.bundleIdentifier = [info objectForKey:@"bundleIdentifier"];
            item.previewPath = [info objectForKey:@"sPreviewPath"]; 
            item.packageName = [info objectForKey:@"sPackageName"]; 
            NSString* icoPath = [info objectForKey:@"sIcoPath"];
            if ([PubFunction stringIsNullOrEmpty:icoPath])
                item.icoPath = @"";
            else
                item.icoPath = [NSString stringWithFormat:@"%@%@", appList.baseHost, icoPath];
            
            item.description = [info objectForKey:@"sDsescribe"]; 
            item.license = [info objectForKey:@"sLicense"]; 
            item.softUrl = [info objectForKey:@"sSoftUrl"]; 
            item.rating = [NSNumber numberWithFloat: [[info objectForKey:@"fRating"] floatValue]]; 
            
            //optFlag标志： 0：增加  1：修改  2：删除
            if ( item.optFlag == 0 ) { //添加
                //APPSTORE_VERSION 过滤掉91软件,越狱版本不过滤  //2012.9.25
//#ifndef APPSTORE_VERSION            
                //[items addObject:item];
//#else
                if ( [item.typeName isEqualToString:@"91软件系列"] ||
                     [item.typeName isEqualToString:@"91軟件系列"] )
                    [items addObject:item];
//#endif   
            }
            else if ( item.optFlag == 1 ) { //更新
                for (int ii=0;ii<[items count];ii++) {
                    AppInfo *olditem = [items objectAtIndex:ii];
                    if ( olditem.softID == item.softID && [olditem.softName isEqualToString:item.softName] )
                    {
                        //代替原来的
                        [items replaceObjectAtIndex:ii withObject:item];
                        break;
                    }
                }
            }
            else { //删除
                for (int ii=0;ii<[items count];ii++) {
                    AppInfo *olditem = [items objectAtIndex:ii];
                    if ( olditem.softID == item.softID && [olditem.softName isEqualToString:item.softName] )
                    {
                        //删除原来的
                        [items removeObjectAtIndex:ii];
                        break;
                    }
                }                
            }
            
        }
        @catch (NSException *exception) 
        {
             LOG_ERROR(@"Getapplist fault: %@", [exception description]);
        }
        @finally 
        {
            [item release];
        }
    }

    [items sortUsingSelector:@selector(compare:)];
    appList.aryAppInfo = items;
    return appList;
}

- (BOOL) getCurVerion:(NSString*)js :(int*)curVersion
{
    NSDictionary *nodes = [js JSONValue]; 		
    if (nodes == nil)
        return NO;
    
     NSString* version = [nodes objectForKey:@"nAppVersoin"];
    
    if ([PubFunction stringIsNullOrEmpty:version])
        return NO;
    
    *curVersion = [version intValue];
    return YES;
}

@end


#pragma mark -
#pragma mark 签到换积分

@implementation BussQianDao
@synthesize sReqDate;

-(void)dealloc
{
	self.sReqDate = nil;
	[super dealloc];
}

-(void) RequestQiandao:(NSString *)strDate ResponseTarget :(id)target ResponseSelector:(SEL)selector
{
    
    self.sReqDate = strDate;
    self.delgtPackData = self;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSID:@"checkForScore" UserSID:TheCurUser.sSID];
	//LOG_DEBUG(@"URL=%@", url);
    
    //调试
    //LOG_ERROR(url);
    
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    
    NSString *sSource = [NSString stringWithFormat:@"%@|%@|%@|%@", 
                         XUANSHANG_ID, TheCurUser.sUserID, self.sReqDate, @"8q3jkasdf2390890232134adfk9012as"];
    NSString *chkCode = [PubFunction getMd5Value: sSource];
    NSString* jsonRequest = [NSString stringWithFormat:@"{\"iSoftware\":\"%@\",\"UserId\":\"%@\",\"ChkCode\":\"%@\"}", 
                             XUANSHANG_ID, TheCurUser.sUserID, chkCode];
    
    //调试
    //LOG_ERROR(jsonRequest);
    
    return jsonRequest;
}


-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"签到换积分：收到数据预处理错误");
		return NO;
	}
    
	
    if( jsobj )
    {
        int code = [((NSNumber*) [jsobj objectForKey:@"code"]) intValue];
        NSString *content = nil;
        if ( code == 200 ) {
            content = (NSString *) [jsobj objectForKey:@"msg"];
            int sor = [((NSNumber*) [jsobj objectForKey:@"return"]) intValue];
            content = [NSString stringWithFormat:@"%@:%d\r\n", content, sor];
            LOG_ERROR(@"%@",content);
            return YES;
        }
        
        if( 500 == code )
        {
            content = (NSString *) [jsobj objectForKey:@"msg"];
            LOG_ERROR(@"%@",content);
            return YES;
        }
        
        content = (NSString *) [jsobj objectForKey:@"msg"];
        LOG_ERROR(@"%@",content);
        return NO;
    }
    //	if ([PubFunction isObjNull:jsobj] /*|| ![PubFunction isObjNull:*err]*/)
    //	{
    //		if (self.iHttpCode == 200)
    //		{
    //			*err = nil;
    //			return YES;
    //		}
    //		
    //		LOG_ERROR(@"签到换积分：收到数据预处理错误");
    //		return NO;
    //	}
    //	
    //	//解析
    //	NSString* sResponse = [BussInterImplBase pickResponBufFromRecvJsObj:jsobj];
    //	if ([PubFunction stringIsNullOrEmpty:sResponse])
    //	{
    //		LOG_ERROR(@"签到换积分：收到数据预处理错误");
    //		return NO;
    //	}
	
	//TODO: 本地缓存
	//[AstroDBMng replaceLoveFlower:self.sUserGuid Data:sResponse Time:self.sReqDate];
	
	return NO;
}


@end


//add 2012.8.20
#pragma mark -
#pragma mark 获取服务器时间

@implementation BussServerDateTime

-(void)dealloc
{
	[super dealloc];
}

-(void) RequestServerDateTimeWithResponseTarget :(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"getServerDateTime"];
	//LOG_DEBUG(@"URL=%@", url);
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
	NSString *strJson = [NSString stringWithFormat: @"{\"iSoftware\":\"%@\"}", XUANSHANG_ID];
	return strJson;
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"获取服务器时间：收到数据预处理错误");
		return NO;
	}
	
    //返回数据：{"sysdate":"2012-08-21 18:03:10"}
    if( jsobj )
    {
        NSString *content = (NSString *) [jsobj objectForKey:@"sysdate"];
        if ( content ) return YES;
    }
    
	return NO;
}


@end


//------以下为91note-----------------------
#pragma mark -
#pragma mark 登录91简报业务服务

@implementation BussLogin91Note

-(void)dealloc
{
	[super dealloc];
}

-(void) Login91Note :(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"common/log/login" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err
{
	NSDictionary* jsobj = nil;
	if ( ![BussInterImplBase prepareUnpackRecvData:rcvData ToJsonObj:&jsobj HttpStatus:self.iHttpCode Error:err] )
	{
		LOG_ERROR(@"登录91简报：收到数据预处理错误");
		return NO;
	}
	
    //可以做其它的一下参数检测，如果不存在，返回失败,一般情况下可以不检测
    
    //返回数据：{"user_id":xxx,"master_key":"xxx","ip_location":"xxx"}
    if( jsobj )
    {
        NSString *content = (NSString *) [jsobj objectForKey:@"master_key"];
        if ( content ) return YES;
    }
	return NO;
}

-(BOOL)unpackJsonForResult:(NSString*)jsRep Result:(TBussStatus *)sts
{
    NSDictionary *nodes = [jsRep JSONValue]; 		
    if (nodes == nil)
        return NO;
    
    sts.rtnData = nodes;
    
    //保存参数
    TheCurUser.sNoteUserId = [nodes objectForKey:@"user_id"]; 
    TheCurUser.sNoteMasterKey = [nodes objectForKey:@"master_key"];
    TheCurUser.sNoteIpLocation = [nodes objectForKey:@"ip_location"];
    
    return YES;
}

@end

#pragma mark -
#pragma mark 注销91简报业务服务

@implementation BussLogout91Note

-(void)dealloc
{
	[super dealloc];
}

-(void) Logout91Note :(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"common/log/logout" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}



@end


#pragma mark -
#pragma mark 获取用户信息

@implementation BussGetUserInfo

-(void)dealloc
{
	[super dealloc];
}

-(void) GetUserInfo :(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/user/getUserInfo" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    NSString *strJson = [NSString stringWithFormat: @"{\"username\":\"%@\"}", TheCurUser.sUserName];
	return strJson;
}

@end


#pragma mark -
#pragma mark -下载文件夹列表

@implementation BussDownDir

-(void)dealloc
{
	[super dealloc];
}


-(void) DownDir:(NSString *)strGuid from:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector;
{
    super.delgtPackData = self;
    
    NSString *param= @"";
    if ( strGuid && [strGuid length]>0 )
        param = [param stringByAppendingFormat:@"&belong_to=%@",strGuid];
    
    if ( from >= 0 && to > 0 ) 
        param = [param stringByAppendingFormat:@"&from=%d&to=%d",from,to];
    else if (from > 0 )
        param = [param stringByAppendingFormat:@"&from=%d",from];
    else if (to > 0 )
        param = [param stringByAppendingFormat:@"&to=%d",to];
    
    if ( size > 0 )
        param = [param stringByAppendingFormat:@"&size=%d",size];
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/dir/downDir" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}


@end


#pragma mark -
#pragma mark 上传文件夹列表

@implementation BussUploadDir
@synthesize cateInfo;

-(void)dealloc
{
    self.cateInfo = nil;
    
	[super dealloc];
}


-(void) UploadDir:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.cateInfo = param;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/dir/upDir" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nCreateVerID] forKey:@"create_ver"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nCurrVerID] forKey:@"curr_ver"];
    [dict setObject:cateInfo.tHead.strCreateTime forKey:@"create_time"];
    [dict setObject:cateInfo.tHead.strCreateTime forKey:@"modify_time"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nDelState] forKey:@"delete_state"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nEditState] forKey:@"edit_state"];
    
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nConflictState] forKey:@"conflict_state"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nSyncState] forKey:@"sync_state"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.tHead.nNeedUpload] forKey:@"need_upload"];
    
    //Key
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:cateInfo.strCatalogBelongToGuid forKey:@"belong_to"];
    [dict setObject:cateInfo.strCatalogIdGuid forKey:@"id"];
    
    //文件夹信息
    [dict setObject:cateInfo.strCatalogPaht1Guid forKey:@"guid_path1"];
    [dict setObject:cateInfo.strCatalogPaht2Guid forKey:@"guid_path2"];
    [dict setObject:cateInfo.strCatalogPaht3Guid forKey:@"guid_path3"];
    [dict setObject:cateInfo.strCatalogPaht4Guid forKey:@"guid_path4"];
    [dict setObject:cateInfo.strCatalogPaht5Guid forKey:@"guid_path5"];
    [dict setObject:cateInfo.strCatalogPaht6Guid forKey:@"guid_path6"];
    [dict setObject:cateInfo.strCatalogName forKey:@"name"];
    
    [dict setObject:[NSNumber numberWithInt:cateInfo.nEncryptFlag] forKey:@"encrypt_flag"];
    [dict setObject:cateInfo.strVerifyData forKey:@"verify_data"];
    
    [dict setObject:[NSNumber numberWithInt:cateInfo.nOrder] forKey:@"order"];//noteinfo.nOwnerId
    [dict setObject:[NSNumber numberWithInt:cateInfo.nCatalogIcon] forKey:@"icon_id"]; //noteinfo.nFromId
    [dict setObject:[NSNumber numberWithInt:cateInfo.nCatalogColor] forKey:@"color"];
    [dict setObject:[NSNumber numberWithInt:cateInfo.nMobileFlag] forKey:@"mobile_flag"];
     		
	NSString* strJson = [dict JSONRepresentation];
	return strJson;
}

@end

#pragma mark -
#pragma mark 获取最新笔记信息
@implementation BussGetLatestNote

-(void)dealloc
{
	[super dealloc];
}


-(void) GetLatestNote:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *param=@"";
    if ( from >=0 && to >0 )
        param = [param stringByAppendingFormat:@"&from=%d&to=%d",from,to];
    else if ( from > 0 )
        param = [param stringByAppendingFormat:@"&from=%d",from];
    else if ( to > 0 )
        param = [param stringByAppendingFormat:@"&to=%d",to];
    
    if ( size > 0 )
        param = [param stringByAppendingFormat:@"&size=%d",size];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"web/noteSelect/getLatestNotes" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end

#pragma mark -
#pragma mark 下载笔记列表信息
@implementation BussDownNoteList

-(void)dealloc
{
	[super dealloc];
}


-(void) DownNoteList:(NSString *)strGuid from:(int)from to:(int)to size:(int)size ResponseTarget: (id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *param=@"";
    
    if ( strGuid && [strGuid length]>0 )
        param = [param stringByAppendingFormat:@"&belong_to=%@",strGuid];
    
    if ( from >=0 && to >0 )
        param = [param stringByAppendingFormat:@"&from=%d&to=%d",from,to];
    else if ( from > 0 )
        param = [param stringByAppendingFormat:@"&from=%d",from];
    else if ( to > 0 )
        param = [param stringByAppendingFormat:@"&to=%d",to];
    
    if ( size > 0 )
        param = [param stringByAppendingFormat:@"&size=%d",size];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/note/downNote" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 下载笔记信息
@implementation BussDownNote

-(void)dealloc
{
	[super dealloc];
}


-(void) DownNote:(NSString *)strNoteGuid user_id:(int)user_id currentver:(int)curr_ver ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *param=@"";
    
    param = [param stringByAppendingFormat:@"&id=%@",strNoteGuid];
    param = [param stringByAppendingFormat:@"&user_id=%@",TheCurUser.sNoteUserId];
    if ( curr_ver >= 0 )
        param = [param stringByAppendingFormat:@"&curr_ver=%d",curr_ver];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/note/getNote" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end

#pragma mark -
#pragma mark 上传笔记信息
@implementation BussUploadNote
@synthesize noteinfo;

-(void)dealloc
{
    self.noteinfo = nil;
    
	[super dealloc];
}


-(void) UploadNote:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.noteinfo = param;
    
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/note/upNote" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
   	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
   
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nCreateVerID] forKey:@"create_ver"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nCurrVerID] forKey:@"curr_ver"];
    [dict setObject:noteinfo.tHead.strCreateTime forKey:@"create_time"];
    [dict setObject:noteinfo.tHead.strModTime forKey:@"modify_time"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nDelState] forKey:@"delete_state"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nEditState] forKey:@"edit_state"];
    
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nConflictState] forKey:@"conflict_state"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nSyncState] forKey:@"sync_state"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.tHead.nNeedUpload] forKey:@"need_upload"];
    
    //Key
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:noteinfo.strCatalogIdGuid forKey:@"belong_to"];
    [dict setObject:noteinfo.strNoteIdGuid forKey:@"id"];
     
    //笔记信息
    [dict setObject:noteinfo.strNoteTitle forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.nNoteType] forKey:@"note_type"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.nNoteSize] forKey:@"note_size"];
    
    [dict setObject:noteinfo.strFilePath forKey:@"note_addr"];
    [dict setObject:noteinfo.strNoteSrc forKey:@"note_src"];
    [dict setObject:noteinfo.strFirstItemGuid forKey:@"first_item"];
    [dict setObject:noteinfo.strFileExt forKey:@"file_ext"];
    
    
    [dict setObject:[NSNumber numberWithInt:noteinfo.nEncryptFlag] forKey:@"encrypt_flag"];
    [dict setObject:TheCurUser.sNoteUserId forKey:@"owner_id"];//noteinfo.nOwnerId
    [dict setObject:TheCurUser.sNoteUserId forKey:@"from_id"]; //noteinfo.nFromId
    [dict setObject:[NSNumber numberWithInt:noteinfo.nStarLevel] forKey:@"star_level"];
    
    [dict setObject:noteinfo.strExpiredDate forKey:@"expired_date"];
    [dict setObject:noteinfo.strFinishDate forKey:@"finish_date"];
    [dict setObject:[NSNumber numberWithInt:noteinfo.nFinishState] forKey:@"finish_state"];
	
	NSString* strJson = [dict JSONRepresentation];
	return strJson;

}

@end

#pragma mark -
#pragma mark 上传家园e线笔记
@implementation BussUploadJYEXNote
@synthesize noteinfo;

-(void)dealloc
{
    self.noteinfo = nil;
    
	[super dealloc];
}


-(void) UploadNote:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.noteinfo = param;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=blog&ac=add"];
    [self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
   	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    //公共头
//    [dict setObject:@"IOS" forKey:@"client_type"];

	
//    subject  —— 日志标题
//    savealbumid —— 0
//    newalbum —— 直接用'请输入相册名称'
//    view_albumid —— none
//    message —— 日志内容
//    classid —— 日志类型：公告、教学日志、家园配合、宝宝作品、点点滴滴、教学方法与分享、专题讨论与分享、平安接送
//    tag —— 日志标签
//    friend —— 0表示全部人可以看、1表示好友可以看、3只有自己看
//    isSendsms —— 是否发送消息给好友，1-发送、0-不发送
//    synspaceid —— 需要同步到的用户信息，格式：用户UID#用户名
    NSString *tempStr = [noteinfo.strNoteTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:tempStr forKey:@"subject"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"savealbumid"];
    tempStr = [[NSString stringWithUTF8String:"请输入相册名称"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [dict setObject:tempStr forKey:@"newalbum"];
    [dict setObject:[NSNull null] forKey:@"view_albumid"];
    

    NSString *strEditFileName = [CommonFunc getItemPath:noteinfo.strFirstItemGuid fileExt:@"html"];
    NSString *strEditAllHTML = [NSString stringWithContentsOfFile:strEditFileName encoding:NSUTF8StringEncoding error:nil]; 
    NSLog(@"%@", strEditAllHTML);
    NSString *strHTMLBody = [CommonFunc getHTMLFileBody:strEditFileName ];
    NSArray *arrNoteXItem = [AstroDBMng getNote2ItemList:noteinfo.strNoteIdGuid includeDelete:YES];
    if ( arrNoteXItem ) {
        TNoteXItem *curNoteXitem;
        TItemInfo *curItemInfo;
        NSString *filename;
        for (int i = 0; i < [arrNoteXItem count]; ++i ) {
            curNoteXitem = [arrNoteXItem objectAtIndex:i];
            curItemInfo = [AstroDBMng getItem:curNoteXitem.strItemIdGuid];
            if ( curItemInfo && [curItemInfo.strItemIdGuid isEqualToString:noteinfo.strFirstItemGuid]) {
                continue;
            }
            filename  = [NSString stringWithFormat:@"%@.%@", curItemInfo.strItemIdGuid, curItemInfo.strItemExt];
            strHTMLBody = [strHTMLBody stringByReplacingOccurrencesOfString:filename withString: curItemInfo.strServerPath];
        }
    }
    NSLog(@"%@", strHTMLBody);

    strHTMLBody = [strHTMLBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    strHTMLBody = [strHTMLBody stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strHTMLBody = [strHTMLBody stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    //strHTMLBody = [strHTMLBody stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    NSLog(@"%@\r\n", strHTMLBody);
    //[dict setObject:strEditAllHTML forKey:@"message"];
    //tempStr = [strEditAllHTML stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    tempStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                        NULL,
                                                        (CFStringRef)strHTMLBody,
                                                        NULL,
                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                        kCFStringEncodingUTF8 );
    NSLog(@"%@\r\n", tempStr);
    [dict setObject:tempStr forKey:@"message"];
    

    tempStr =  [noteinfo.strNoteClassId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:tempStr  forKey:@"classid"]; 
    
    tempStr =  @"日志标签";;
    [dict setObject:tempStr forKey:@"tag"];
    
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"friend"];
    
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"isSendsms"];
    NSString *syn = @"";
    NSMutableArray *classStrArray = [NSMutableArray array];
    tempStr = @"班级公告,班级空间,班级论坛,教学日志,宝宝作品,班级随手拍,我爱分享,今日作业,黑板报,班级空间,精彩瞬间";
    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    if ( noteinfo.strNoteClassId &&
        !([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] )
        && ([tempStr rangeOfString:noteinfo.strNoteClassId].location != NSNotFound)) {
        NSArray *classArray = [BizLogic getClassList];
        if ( classArray && [classArray count] ) {
            for( TJYEXClass *classInfo in classArray ){
                syn = [NSString stringWithFormat:@"%@#%@", classInfo.sClassId, classInfo.sClassName];
                NSString *ss = [syn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [classStrArray addObject:ss];
            }
        }
    }
    
    if ( [classStrArray count] == 0 ) { //syn.length == 0 ) {
        //syn = [NSString stringWithFormat:@"%@#%@", TheCurUser.sUserID, TheCurUser.sUserName];
        //syn = @"";
        //[classStrArray addObject:syn];
    }
    else {
        [dict setObject:classStrArray forKey:@"synspaceid"];
    }
    
	NSString* strJson = [dict JSONRepresentation];
    NSString* para = [NSString stringWithFormat:@"para=%@", strJson];
    NSLog(@"%@\r\n", para);
//    //para = [para stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding/*NSUTF8StringEncoding*/];
//    para = (NSString *)CFURLCreateStringByAddingPercentEscapes(
//                                                        NULL,
//                                                        (CFStringRef)para,
//                                                        NULL,
//                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                        kCFStringEncodingUTF8 );
//
//    NSLog(@"%@\r\n", para);
	return para;
    
}

@end

#pragma mark -
#pragma mark 通过标题查找笔记
@implementation BussSearchNoteList

-(void)dealloc
{
	[super dealloc];
}


-(void) SearchNoteList:(NSString *)strTitle ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *param = [NSString stringWithFormat:@"&title=%@",strTitle];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/note/upNote" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 获取笔记的所有项(笔记、笔记项关联表、item表)
@implementation BussGetNoteAll
@synthesize strNoteGuid;
@synthesize from;
@synthesize nNeedNote;

-(void)dealloc
{
    strNoteGuid = nil;
    
	[super dealloc];
}


-(void) GetNoteAll:(NSString *)strNoteGuid1 from:(int)from1 neednote:(int)nNeedNote1 ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    self.strNoteGuid = strNoteGuid1;
    self.from = from1;
    self.nNeedNote = nNeedNote1;
    
    //NSString *param=@"";
    /*
    param = [param stringByAppendingFormat:@"&note_id=%@",strNoteGuid];
    param = [param stringByAppendingFormat:@"&user_id=%@",TheCurUser.sNoteUserId];
    param = [param stringByAppendingFormat:@"&from=%d",from];
    param = [param stringByAppendingFormat:@"&need_note=%d",nNeedNote];
    */
    //param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/noteall/getNoteAll" UserSID:TheCurUser.sSID param:nil];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
   	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:strNoteGuid forKey:@"note_id"];
    [dict setObject:[NSNumber numberWithInt:from] forKey:@"from"];
    [dict setObject:[NSNumber numberWithInt:nNeedNote] forKey:@"need_note"];
    
	NSString* strJson = [dict JSONRepresentation];
	return strJson;
}

@end



//--------------------------------NoteXItem部分------------------------------------

#pragma mark -
#pragma mark 获取笔记的笔记与笔记项关联列表
@implementation BussDownNoteXItems

-(void)dealloc
{
	[super dealloc];
}


-(void) DownNoteXItems:(NSString *)strNoteGuid from:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    NSString *param=@"";
    param = [param stringByAppendingFormat:@"&id=%@",strNoteGuid];
    if ( from >=0 && to >0 )
        param = [param stringByAppendingFormat:@"&from=%d&to=%d",from,to];
    else if ( from > 0 )
        param = [param stringByAppendingFormat:@"&from=%d",from];
    else if ( to > 0 )
        param = [param stringByAppendingFormat:@"&to=%d",to];
    
    if ( size > 0 )
        param = [param stringByAppendingFormat:@"&size=%d",size];    
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/noteItem/getNoteXItemsInNote" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 上传笔记与笔记项关联信息
@implementation BussUploadNoteXItems
@synthesize noteXItem;

-(void)dealloc
{
    self.noteXItem = nil;
    
	[super dealloc];
}


-(void) UploadNoteXItems:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.noteXItem = param;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/noteItem/upNoteXItem" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];	
      
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nCreateVerID] forKey:@"create_ver"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nCurrVerID] forKey:@"curr_ver"];
    [dict setObject:noteXItem.tHead.strCreateTime forKey:@"create_time"];
    [dict setObject:noteXItem.tHead.strModTime forKey:@"modify_time"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nDelState] forKey:@"delete_state"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nEditState] forKey:@"edit_state"];
    
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nConflictState] forKey:@"conflict_state"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nSyncState] forKey:@"sync_state"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.tHead.nNeedUpload] forKey:@"need_upload"];
    
    //Key
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:noteXItem.strCatalogBelongToGuid forKey:@"belong_to"];
    [dict setObject:noteXItem.strNoteIdGuid forKey:@"id_first"];
    [dict setObject:noteXItem.strItemIdGuid forKey:@"id_second"];
    
    //笔记项信息
    [dict setObject:TheCurUser.sNoteUserId forKey:@"item_user_id"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.nItemVer] forKey:@"item_ver"];
    [dict setObject:[NSNumber numberWithInt:noteXItem.nItemOrder] forKey:@"item_order"];
	
	NSString* strJson = [dict JSONRepresentation];
	return strJson;
    
}

@end


#pragma mark -
#pragma mark 获取笔记项信息
@implementation BussDownItem

-(void)dealloc
{
	[super dealloc];
}


-(void)DownItem:(NSString *)strItemGuid user_id:(int)user_id current_ver:(int)curr_ver ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSString *param = [NSString stringWithFormat:@"&user_id=%@",TheCurUser.sNoteUserId];
    param = [param stringByAppendingFormat:@"&id=%@",strItemGuid];
    if ( curr_ver >= 0 )
        param = [param stringByAppendingFormat:@"&curr_ver=%d",curr_ver];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/item/getItem" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end

#pragma mark -
#pragma mark 上载笔记项信息
@implementation BussUploadItem
@synthesize iteminfo;


-(void)dealloc
{
    self.iteminfo = nil;
    
	[super dealloc];
}


-(void)UploadItem:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.iteminfo = param;
    
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/item/upItem" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];	
    
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nCreateVerID] forKey:@"create_ver"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nCurrVerID] forKey:@"curr_ver"];
    [dict setObject:self.iteminfo.tHead.strCreateTime forKey:@"create_time"];
    [dict setObject:self.iteminfo.tHead.strModTime forKey:@"modify_time"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nDelState] forKey:@"delete_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nEditState] forKey:@"edit_state"];
    
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nConflictState] forKey:@"conflict_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nSyncState] forKey:@"sync_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nNeedUpload] forKey:@"need_upload"];
    
    //Key
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:self.iteminfo.strNoteIdGuid forKey:@"belong_to"];
    [dict setObject:self.iteminfo.strItemIdGuid forKey:@"id"];
    
    //笔记项信息
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.nItemType] forKey:@"item_type"];
    [dict setObject:self.iteminfo.strItemExt forKey:@"file_ext"];
    [dict setObject:TheCurUser.sNoteUserId forKey:@"create_user_id"];//self.iteminfo.nCreatorID
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.nEncryptFlag] forKey:@"encrypt_flag"];
    [dict setObject:self.iteminfo.strItemTitle forKey:@"title"];
 
    
    //文件校验
    [dict setObject:[CommonFunc getStreamTypeByExt:self.iteminfo.strItemExt] forKey:@"stream_type"]; //文件流类型（用于下载时头部设置流类型）
    
    NSString *strFilename = [CommonFunc getItemPath:self.iteminfo.strItemIdGuid fileExt:self.iteminfo.strItemExt];
    if ( [CommonFunc isImageFile:self.iteminfo.strItemExt] ) {
        NSString *strFileNameSrc = [CommonFunc getItemPathAddSrc:self.iteminfo.strItemIdGuid fileExt:self.iteminfo.strItemExt];
        if ([CommonFunc isFileExisted:strFileNameSrc] ) strFilename = strFileNameSrc;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:strFilename];
    if ( [data length] == 0 )
    {
        data = [NSData dataWithBytes:"0" length:1];
    }
    
    [dict setObject:[NSNumber numberWithInt:[data length]] forKey:@"file_size"];
    
    unsigned char result[16];	
	CC_MD5([data bytes], [data length], result );
	NSString *md5str =[[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3], 			
             result[4], result[5], result[6], result[7],			
             result[8], result[9], result[10], result[11],			
             result[12], result[13], result[14], result[15]			
             ] lowercaseString]; 
    [dict setObject:md5str forKey:@"md5"];	//文件的md5校验码
	
	NSString* strJson = [dict JSONRepresentation];
	return strJson;
}

@end


#pragma mark -
#pragma mark 下载笔记项文件
@implementation BussDownItemFile

-(void)dealloc
{
	[super dealloc];
}


-(void)DownItemFile:(NSString *)strID filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSString *param = [NSString stringWithFormat:@"&user_id=%@",TheCurUser.sNoteUserId];
    param = [param stringByAppendingFormat:@"&id=%@",strID];
    //if (offset > 0 ) 
    //    param = [param stringByAppendingFormat:@"&offset=%d",offset];
    //if (end > 0 ) 
    //    param = [param stringByAppendingFormat:@"&end=%d",end];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/item/downItemFile" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest_DownloadFile:url Method:HTTP_METHOD_GET filename:strFilename contenttype:strContentType ResponseTarget:target ResponseSelector:selector ];

}


-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 上传笔记项数据包
@implementation BussUploadItemFile
@synthesize strItemGuid;
@synthesize strExt;
@synthesize rs;
@synthesize re;

-(void)dealloc
{
    self.strItemGuid = nil;
    self.strExt = nil;
    
	[super dealloc];
}


-(void)UploadItemFile:(id)param_ ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.strItemGuid = [param_ objectForKey:@"itemguid"];
    self.strExt = [param_ objectForKey:@"itemext"];
    self.rs = [[param_ objectForKey:@"rs"] intValue];
    self.re = [[param_ objectForKey:@"re"] intValue];
    
    NSString *param = [NSString stringWithFormat:@"&user_id=%@",TheCurUser.sNoteUserId];
    param = [param stringByAppendingFormat:@"&id=%@.%@",strItemGuid,strExt];
    if (rs >= 0 ) 
        param = [param stringByAppendingFormat:@"&rs=%d",rs];
    if (re >= 0  ) 
        param = [param stringByAppendingFormat:@"&re=%d",re];
    
    param = [param stringByAppendingString:@"&client_type=IOS"];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/item/upItemFile" UserSID:TheCurUser.sSID param:param];
	[self HttpRequest_uploadFile:url Method:HTTP_METHOD_POST contenttype:[CommonFunc getStreamTypeByExt:strExt] ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

-(NSData*) PackSendOutByteData
{
    NSString *strFilename = [CommonFunc getItemPath:strItemGuid fileExt:strExt];
    if ( [CommonFunc isImageFile:strExt] ) {
        NSString *strFileNameSrc = [CommonFunc getItemPathAddSrc:strItemGuid fileExt:strExt];
        if ([CommonFunc isFileExisted:strFileNameSrc] ) strFilename = strFileNameSrc;
    }
    //NSLog(@"upload file:%@",strFilename);
    
    /*
    NSData *data = [NSData dataWithContentsOfFile:strFilename];
    if ( [data length] > 0 )
    {
        NSRange range;
        range.location = rs;
        range.length = re-rs+1;
        NSData *uploaddata = [data subdataWithRange:range];
        return uploaddata;
    }
    else 
    {
        data = [NSData dataWithBytes:"0" length:1];
        return data;
    }*/
    
    long long size = [CommonFunc GetFileSize:strFilename];
    int intsize = (int)size;
    NSLog(@"upload file:%@ size=%d start=%d end=%d bytes=%d",strFilename,intsize,rs,re,re-rs+1);
    
    if ( size > 0 ) { 
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:strFilename];
        [fileHandle seekToFileOffset:rs];
        NSData *data = [fileHandle readDataOfLength:re-rs+1]; 
        return data;
    }
    else {
        NSData *data = [NSData dataWithBytes:"0" length:1];
        return data; 
    }
}

@end

#pragma mark -
#pragma mark 家园E线 上传日子附件
@implementation BussJYEXUploadItemFile

-(void)UploadItemFile:(id)param_ ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.strItemGuid = [param_ objectForKey:@"itemguid"];
    self.strExt = [param_ objectForKey:@"itemext"];
    self.rs = [[param_ objectForKey:@"rs"] intValue];
    self.re = [[param_ objectForKey:@"re"] intValue];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=blog&ac=uploadAttachment"];
	//[self HttpRequest_uploadFile:url Method:HTTP_METHOD_POST contenttype:[CommonFunc getStreamTypeByExt:strExt] ResponseTarget:target ResponseSelector:selector];
    [self HttpRequest_uploadJYEXFile:url Method:HTTP_METHOD_POST contenttype:[CommonFunc getStreamTypeByExt:strExt] FileName:self.strItemGuid FileExt:self.strExt ResponseTarget:target ResponseSelector:selector];
}

-(NSData*) PackSendOutByteData
{    
    NSString *strFilename = [CommonFunc getItemPath:strItemGuid fileExt:strExt];
    if ( [CommonFunc isImageFile:strExt] ) {
        NSString *strFileNameSrc = [CommonFunc getItemPathAddSrc:strItemGuid fileExt:strExt];
        //NSString *strFileNameSrc = [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], strItemGuid, strExt];
        if ([CommonFunc isFileExisted:strFileNameSrc] ) strFilename = strFileNameSrc;
    }
    NSLog(@"upload file:%@",strFilename);
    
    long long size = [CommonFunc GetFileSize:strFilename];
    int intsize = (int)size;
    rs = 0;
    re = (int)size - 1;
    NSLog(@"upload file:%@ size=%d start=%d end=%d bytes=%d",strFilename,intsize,rs,re,re-rs+1);
    
    if ( size > 0 ) { 
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:strFilename];
        [fileHandle seekToFileOffset:rs];
        NSData *data = [fileHandle readDataOfLength:re-rs+1]; 
        return data;
    }
    else {
        NSData *data = [NSData dataWithBytes:"0" length:1];
        return data; 
    }
}

@end

#pragma mark -
#pragma mark 上传笔记项完成
@implementation BussUploadItemFileFinish
@synthesize iteminfo;

-(void)dealloc
{
    self.iteminfo = nil;
    
	[super dealloc];
}


-(void)UploadItemFileFinish:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.iteminfo = param;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgiSIDWithParam:@"sync/item/upItemOk" UserSID:TheCurUser.sSID param:@"&client_type=IOS"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];	
       
    //公共头
    [dict setObject:@"IOS" forKey:@"client_type"];
    
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nCreateVerID] forKey:@"create_ver"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nCurrVerID] forKey:@"curr_ver"];
    [dict setObject:self.iteminfo.tHead.strCreateTime forKey:@"create_time"];
    [dict setObject:self.iteminfo.tHead.strCreateTime forKey:@"modify_time"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nDelState] forKey:@"delete_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nEditState] forKey:@"edit_state"];
    
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nConflictState] forKey:@"conflict_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nSyncState] forKey:@"sync_state"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.tHead.nNeedUpload] forKey:@"need_upload"];
    
    //Key
    [dict setObject:TheCurUser.sNoteUserId forKey:@"user_id"];
    [dict setObject:self.iteminfo.strNoteIdGuid forKey:@"belong_to"];
    [dict setObject:self.iteminfo.strItemIdGuid forKey:@"id"];
    
    //笔记项信息
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.nItemType] forKey:@"item_type"];
    [dict setObject:self.iteminfo.strItemExt forKey:@"file_ext"];
    [dict setObject:TheCurUser.sNoteUserId forKey:@"create_user_id"];//self.iteminfo.nCreatorID
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.nEncryptFlag] forKey:@"encrypt_flag"];
    [dict setObject:self.iteminfo.strItemTitle forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:self.iteminfo.nItemSize] forKey:@"file_size"];
	
	NSString* strJson = [dict JSONRepresentation];
	return strJson;

}

@end


#pragma mark -
#pragma mark 查询相册列表

@implementation BussJYEXQueryAlbumList

-(void) QueryAlbumList:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    
    NSString *cgi = [NSString stringWithFormat:@"mobile.php?mod=album&ac=getuserallalbum&uid=%@",TheCurUser.sUserID];
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:cgi];
    [self HttpRequest:url Method:HTTP_METHOD_GET ResponseTarget:target ResponseSelector:selector];
    
}

-(NSString*) PackSendOutJsonString
{

	return @"";
    
}


@end


#pragma mark -
#pragma mark 上传图片到相册

@implementation BussJYEXUploadPhoto


-(void) uploadPhoto:(NSString *)strAlbumId title:(NSString *)strTitle albumname:(NSString *)strAlbumName itemguid:(NSString *)strItemGuid uid:(NSString *)strUid username:(NSString *)strUsername ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    NSString *albumid = strAlbumId;
    NSString *albumname = strAlbumName;
    NSString *uid = strUid;
    NSString *username = strUsername;
    
    //2014.9.23
    TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
    
    //使用日志id
    if ([strAlbumId isEqual:@"0"] && [strAlbumName isEqualToString:@"日志相册"]) {
        if ( [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] ) {
            albumid = u.sAlbumIdSchool;
            albumname = u.sAlbumNameSchool;
            uid = u.sAlbumUidSchool;
            username = u.sAlbumUsernameSchool;
        }
        else if ( [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher]) {
            albumid = u.sAlbumIdClass;
            albumname = u.sAlbumNameClass;
            uid = u.sAlbumUidClass;
            username = u.sAlbumUsernameClass;
        }
        else {
            albumid = u.sAlbumIdPerson;
            albumname = u.sAlbumNamePerson;
            uid = u.sAlbumUidPerson;
            username = u.sAlbumUsernamePerson;
        }
    }
    
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:albumid,@"value",@"albumid",@"key",@"data",@"type",nil];
    [arr addObject:dic1];
    
    
    //NSString *strDate = [CommonFunc getCurrentDate];//2014.9.18
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:strTitle,@"value",@"title",@"key",@"data",@"type",nil];
    [arr addObject:dic2];
    
    
    NSString *imagePathSrc = [CommonFunc getItemPathAddSrc:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:imagePathSrc,@"value",@"Filedata",@"key",@"file",@"type",nil];
    [arr addObject:dic3];
    
    //add 2014.9.29
    NSDictionary *dic33 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"value",@"img_come",@"key",@"data",@"type",nil];
    [arr addObject:dic33]; //0-pc 1-android 2-ios 3-通道服务器
    
    
    //如果是老师和园长身份，发送到通道服务器。2018.9.23
    NSString *url;
    /*
    if ( ([u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] || [u isInfantsSchoolTeacher] || [u isMiddleSchoolTeacher]) && TheCurUser.sNoteUserId && [TheCurUser.sNoteUserId length]>0) {
        //其他域
        NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"value",@"isczda",@"key",@"data",@"type",nil];
        [arr addObject:dic4];
        NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:albumname ,@"value",@"albumname",@"key",@"data",@"type",nil];
        [arr addObject:dic5];
        NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"value",@"src_addr",@"key",@"data",@"type",nil];
        [arr addObject:dic6];
        NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"value",@"src_path",@"key",@"data",@"type",nil];
        [arr addObject:dic7];
        NSDictionary *dic8 = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"value",@"uid",@"key",@"data",@"type",nil];
        [arr addObject:dic8];
        NSDictionary *dic9 = [NSDictionary dictionaryWithObjectsAndKeys:username,@"value",@"realname",@"key",@"data",@"type",nil];
        [arr addObject:dic9];
        
        if ([CS_URL_BASE isEqualToString:@"http://www.jyex.cn/"] ||
            [CS_URL_BASE isEqualToString:@"http://61.144.88.98:6805/"])
            url = [NSString stringWithFormat:@"http://%@/index.php?mod=upload&ac=uploadpic",TheCurUser.sNoteUserId]; //td_ip
        else
            url = [NSString stringWithFormat:@"http://%@/tdserver/index.php?mod=upload&ac=uploadpic",TheCurUser.sNoteUserId]; //td_ip
    }
    else 
    */
    {
        url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=album&ac=uploadpic"];
    }
    
    NSLog(@"upload photo:photo size=%lld",[CommonFunc GetFileSize:imagePathSrc]);
    NSLog(@"upload photo:%@",[arr description]);
    
    [self HttpRequest_uploadFormData:url Method:HTTP_METHOD_POST data:arr ResponseTarget:target ResponseSelector:selector];
    
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end


#pragma mark -
#pragma mark 创建相册

@implementation BussJYEXCreateAlbum
@synthesize m_strAlbum;
@synthesize m_spaceid;
-(void) dealloc
{
    self.m_strAlbum = nil;
    self.m_spaceid = nil;
    
    [super dealloc];
}

-(void) CreateAlbum:(NSString *)strAlbumName space:(NSNumber *)spaceid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.m_strAlbum = strAlbumName;
    self.m_spaceid = spaceid;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=album&ac=createalbum"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *str = [m_strAlbum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [dict setObject:str forKey:@"albumname"];
    [dict setObject:m_spaceid forKey:@"spacetype"];
    [dict setObject:@"" forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"friend"];
    [dict setObject:@"" forKey:@"target_name"];
    [dict setObject:@"" forKey:@"password"];
	
	NSString* strJson = [dict JSONRepresentation];
    
    NSString* para = [NSString stringWithFormat:@"para=%@", strJson];
    
    NSLog(@"%@",para);
    
    return para;
    
}

@end




#pragma mark -
#pragma mark 注册

@implementation BussJYEXRegister

@synthesize m_strUser;
@synthesize m_strPassword;
@synthesize m_strNickname;
@synthesize m_strRealname;
@synthesize m_strEmail;

-(void) dealloc
{
    self.m_strUser = nil;
    self.m_strPassword = nil;
    self.m_strNickname = nil;
    self.m_strRealname = nil;
    self.m_strEmail = nil;
    
    [super dealloc];
}

-(void)RegisterUser:(NSString *)strUser password:(NSString *)strPassword nickname:(NSString *)strNickname readlname:(NSString *)strRealname email:(NSString *)strEmail ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.m_strUser = strUser;
    self.m_strPassword = strPassword;
    self.m_strNickname = strNickname;
    self.m_strRealname = strRealname;
    self.m_strEmail = strEmail;
    
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=member&ac=register"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *str = [m_strUser stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"username"];
    
    str = [m_strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"password"];
    
    str = [m_strNickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"nickname"];
    
    str = [m_strRealname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"realname"];
    
    str = [m_strEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"email"];
    
	NSString* strJson = [dict JSONRepresentation];
    
    NSString* para = [NSString stringWithFormat:@"para=%@", strJson];
    
    NSLog(@"%@",para);
    
    return para;
}


@end

#pragma mark -
#pragma mark 修改用户资料，包括密码

@implementation BussJYEXUpdateUserInfo

@synthesize m_strUid;
@synthesize m_strUserName;
@synthesize m_strOldPassword;
@synthesize m_strNewPassword;
@synthesize m_strNickname;
@synthesize m_strRealname;
@synthesize m_strEmail;
@synthesize m_strMobile;

-(void) dealloc
{
    self.m_strUid = nil;
    self.m_strUserName = nil;
    self.m_strOldPassword = nil;
    self.m_strNewPassword = nil;
    self.m_strNickname = nil;
    self.m_strRealname = nil;
    self.m_strEmail = nil;
    self.m_strMobile = nil;
    
    [super dealloc];
}


-(void)UpdateUserInfo:(NSString *)strUid username:(NSString *)strUserName oldpassword:(NSString *)strOldPassword newpassword:(NSString *)strNewPassword nickname:(NSString *)strNickname readlname:(NSString *)strRealname email:(NSString *)strEmail mobile:(NSString *)strMobile ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    self.m_strUid = strUid;
    self.m_strUserName = strUserName;
    self.m_strOldPassword = strOldPassword;
    self.m_strNewPassword = strNewPassword;
    self.m_strNickname = strNickname;
    self.m_strRealname = strRealname;
    self.m_strEmail = strEmail;
    self.m_strMobile = strMobile;
    
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=member&ac=mod"];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}


-(NSString*) PackSendOutJsonString
{
 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:m_strUid forKey:@"uid"];
    
    NSString *str = [m_strUserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"username"];
    
    str = [m_strOldPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"oldpassword"];
    
    str = [m_strNewPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"password"];
    
    str = [m_strNickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"nickname"];
    
    str = [m_strRealname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"realname"];
    
    str = [m_strEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"email"];
    
    str = [m_strMobile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:str forKey:@"mobile"];
    
	NSString* strJson = [dict JSONRepresentation];
    
    NSString* para = [NSString stringWithFormat:@"para=%@", strJson];
    
    NSLog(@"%@",para);
    
    return para;
}


@end



#pragma mark -
#pragma mark 获取图片列表

@implementation BussJYEXGetAlbumPics


-(void) dealloc
{
    [super dealloc];
}


-(void) GetAlbumPics:(NSString *)strAlbumID ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSString *str = [NSString stringWithFormat:@"mobile.php?mod=album&ac=piclist&albumid=%@",strAlbumID];
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:str];
	[self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end



#pragma mark -
#pragma mark 下载文件

@implementation BussDownloadFile

-(void)dealloc
{
	[super dealloc];
}


-(void)DownloadFile:(NSString *)strMyUrl filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSLog(@"url:%@",strMyUrl);

	[self HttpRequest_DownloadFile:strMyUrl Method:HTTP_METHOD_GET filename:strFilename contenttype:strContentType ResponseTarget:target ResponseSelector:selector ];
    
}


-(NSString*) PackSendOutJsonString
{
    return @"";
}


@end



//--------------------------------下载头像部分------------------------------

#pragma mark -
#pragma mark 查询用户头像更新时间

@implementation BussQueryAvatar

-(void) QueryAvatar:(NSString *)strUserid ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSString *url = [BussInterImplBase makeQueryURLWithCgi:@"mobile.php?mod=member&ac=avartar_uptime&size=small"];
    [self HttpRequest:url Method:HTTP_METHOD_POST ResponseTarget:target ResponseSelector:selector];
    
}

-(NSString*) PackSendOutJsonString
{
    return @"";
}

@end

#pragma mark -
#pragma mark 获取用户头像

@implementation BussGetAvatar

-(void)GetAvatar:(NSString *)strUserid filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector
{
    super.delgtPackData = self;
    
    NSString *strCGI = [NSString stringWithFormat:@"uc_server/avatar.php?uid=%@&size=small",strUserid];

    NSString *url = [BussInterImplBase makeQueryURLWithCgi:strCGI];
    
    //调试---------
#ifdef LOG_NETINFO
    LOG_ERROR(@"URL=%@", url);
#else
    LOG_DEBUG(@"URL=%@", url);
#endif
    
    
    [self HttpRequest_DownloadFile:url Method:HTTP_METHOD_GET filename:strFilename contenttype:strContentType ResponseTarget:target ResponseSelector:selector ];
    
}


-(NSString*) PackSendOutJsonString
{
    return @"";
}


@end




