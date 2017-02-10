//
//  BussInterImpl.h
//  Astro
//
//  Created by root on 11-11-22.
//  Copyright 2011 ND SOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussDataDef.h"
#import "NetConstDefine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "BussIntfWeather.h"
#import "DbMngDataDef.h"


#pragma mark 全局函数
//不支持NSDictionary和NSArray
id pickJsonValue(NSDictionary* jObj, NSString* jsKey, id defVal);
BOOL pickJsonBOOLValue(NSDictionary* jObj, NSString* jsKey, BOOL defVal = NO);
int pickJsonIntValue(NSDictionary* jObj, NSString* jsKey, int defVal = 0);
float pickJsonFloatValue(NSDictionary* jObj, NSString* jsKey, float defVal = 0.0);
double pickJsonDoubleValue(NSDictionary* jObj, NSString* jsKey, double defVal = 0.0);
NSString* pickJsonStrValue(NSDictionary* jObj, NSString* jsKey, NSString* defVal = @"");

#pragma mark -
#pragma mark 数据JSON转换处理协议
@protocol BussSendDataPack
//构造发送JSON串数据
@required
-(NSString*) PackSendOutJsonString;
@optional
-(NSData*) PackSendOutByteData;

@end


#pragma mark -
#pragma mark 业务结束处理协议
@protocol BussRecvDataProc
@required
//接收数据处理
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;
@end

#pragma mark -
#pragma mark 业务请求基础
@interface BussInterImplBase : NSObject 
{
@public
	ASIHTTPRequest* objASIHttpReqt;
	NSString* strURL;	//连接地址
	EHttpMethod eHttpMethod;	//连接方式
	int iHttpCode;	//HTTP状态码
	
	//构造发送数据
	id<NSObject, BussSendDataPack>	delgtPackData;
	
	//请求回调函数
	//数据处理前回调
	BOOL bContinueProc;		//处理前回调后是否继续处理：
	NSObject* callbackObj_preProc;
	SEL callbackFunc_preProc;	
	
	//数据处理结束回调
	NSObject* callbackObj;
	SEL callbackFunc;
}

@property(retain) ASIHTTPRequest* objASIHttpReqt;
@property(nonatomic, retain) NSString* strURL;
@property(nonatomic) EHttpMethod eHttpMethod;
@property(nonatomic, readonly) int iHttpCode;
@property(retain) id<NSObject, BussSendDataPack>	delgtPackData;
@property(retain) NSObject* callbackObj;
@property(nonatomic, assign) SEL callbackFunc;
@property(retain) NSObject* callbackObj_preProc;
@property(nonatomic, assign) SEL callbackFunc_preProc;	
@property(nonatomic) BOOL bContinueProc;

#pragma mark -
+ (id) InstantiateBussInter:(NSString*)url Method:(EHttpMethod)method;
+ (id) InstantiateBussInter:(NSString*)url Method:(EHttpMethod)method ResponseTarget:(id) target ResponseSelector:(SEL) selector;
- (id) init;
- (NSString*) WrapJsonStringWithBussID:(int) bussID DictData:(NSDictionary*)innerData;
- (NSString*) WrapJsonStringWithBussID:(int) bussID AryData:(NSArray*)innerData;
-(NSString*) WrapJsonStringWithOption:(NSString*)option DictData:(NSDictionary*)innerData;
-(NSString*) WrapJsonStringWithOption:(NSString*)option AryData:(NSArray*)innerData;

#pragma mark -
+(BOOL) prepareUnpackRecvData:(id) rcvData ToJsonObj:(id*)retJsObj HttpStatus:(int)statusCode Error:(NSError**)err;
+(NSString*) getHttpStatusDescByCode:(int)httpCode;
+(NSString*) pickResponBufFromRecvJsObj:(NSDictionary*)jsObj;
+ (BOOL) IsErrMsgJson:(id) objJson HttpStatus:(int)statusCode Error:(NSError**) err;
+ (NSString*) getQueryBaseURL;
+(NSString*) makeQueryURLWithCgi:(NSString*) cgiName;
+(NSString*) makeQueryURLWithCgiSID:(NSString*)cgiName UserSID:(NSString*)sSID;
+(NSString*) makeQueryURLWithCgiSIDWithParam:(NSString*)cgiName UserSID:(NSString*)sSID param:(NSString *)strParam; //add 2012.11.28
+(NSString*) makeQueryURLWithSID:(NSString*)sSID;

//通用的处理接收数据
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;
//通用的解包函数（解为dictionary)
-(BOOL)unpackJsonForResult:(NSString*)jsRep Result:(TBussStatus *)sts;


#pragma mark -
//对象释放
-(void) cancelHttpRequest;
-(void) destroyBussReqObj;

@end


#pragma mark -
//私有方法
@interface BussInterImplBase (Private)
-(ASIHTTPRequest*) InitRequestWhithHeader;
-(ASIHTTPRequest*) InitRequestWhithHeader:(NSString *)strContentTypeValue;
-(ASIFormDataRequest*) InitJYEXRequestWhithHeader:(NSString *)strContentTypeValue;
-(ASIFormDataRequest*) InitFormRequestWithHeader;

//请求
- (void) HttpRequest;
- (void) HttpRequest:(NSString*)url Method:(EHttpMethod)method ResponseTarget:(id) target ResponseSelector:(SEL) selector;
-(void)HttpRequest_DownloadFile:(NSString*)url Method:(EHttpMethod)method filename:(NSString *)strFilename contenttype:(NSString *)strContentTypeValue ResponseTarget:(id) target ResponseSelector:(SEL) selector;
-(void)HttpRequest_uploadFile:(NSString*)url Method:(EHttpMethod)method contenttype:(NSString *)strContentTypeValue ResponseTarget:(id) target ResponseSelector:(SEL) selector;

//HTTP方法
-(NSString*) HttpMethodString;
//异步请求
-(void) DoASyncRequest;
-(void) DoASyncRequest_DownloadFile:(NSString *)strFilename contenttype:(NSString *)strContentTypeValue;
-(void) DoASyncRequest_uploadFile:(NSString *)strContentTypeValue;
-(void) DoASyncRequest_uploadJYEXFile:(NSString *)strContentTypeValue FileName:(NSString*)strFileName FileExt:(NSString*)strExt;
-(void) DoASyncRequest_uploadFormData:(NSArray *)arrFormData;


//同步请求
-(void) DoSyncRequest;
//构造发送数据
-(NSMutableData*) MakeSendParam;
//构建发送数据
-(NSMutableData*) MakeSendBytesParam;

//处理接收数据
-(void) doProcRecvData:(id)rcvData HttpCode:(int) httpCode;


-(void)notifyPreCallBack:(id)arg;
-(void)notifyCallBack:(id)arg;

@end


#pragma mark -
#pragma mark 登录
@interface BussLogin : BussInterImplBase <BussSendDataPack>
{
	TLoginUserInfo* lgnUser;
	id	retObj;
	SEL	retFunc;
	int	iLoginStatus;	//登录状态：0-初始; 1－登录; 2－inituser
	NSString* sSrvDate;	
}
@property(nonatomic, retain)TLoginUserInfo* lgnUser;
@property(nonatomic, assign)id	retObj;
@property(nonatomic, assign)SEL	retFunc;
@property(nonatomic, retain)NSString* sSrvDate;	

-(void) Login:(NSString*) username Password:(NSString*) passwd RemPswd:(int)remPswd AutoLogin:(int)autoLogin ResponseTarget:(id) target ResponseSelector:(SEL) selector;
-(NSString*) AutoLogin:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;
-(void) UnPackLoginJsonStr:(NSDictionary*) jsObj;
//-(void) UnPackInitUserJsonStr:(NSDictionary*) jsObj;
-(void)UnPackLogin91NoteJsonStr:(NSDictionary*) jsObj;
-(void)UnPackLoginGetNickNameJsonStr:(NSDictionary*) jsObj;
-(void) login91Note;
-(void) onLogined:(id)err;
@end

//家园E线
#pragma mark -
#pragma mark 家园E线登陆
@interface BussJYEXLogin : BussLogin
{
    NSMutableArray *appList;
}
@property(nonatomic, retain)NSMutableArray* appList;

-(void)getJYEXUserInfor;
-(void)getJYEXUserInforEnd:(id)err;
-(void)UnPackLoginJYEXUserinforJsonStr:(NSDictionary*) jsObj;

-(void)getJYEXUserAppList;
-(void)getJYEXUserAppListEnd:(id)err;
-(void)UnPackLoginJYEXUserAppListJsonStr:(NSDictionary*) jsObj;

-(void)getJYEXLanmuList;
-(void)getJYEXLanmuListEnd:(id)err;
-(void)UnPackLoginJYEXLanmuListJsonStr:(NSDictionary*) jsObj;

-(void)getJYEXClassList;
-(void)getJYEXClassListEnd:(id)err;
-(void)UnPackLoginJYEXClassListJsonStr:(NSDictionary*) jsObj;
@end

#pragma mark -
#pragma mark 家园E线 在线更新
@interface BussJYEXSoftUpdata : BussInterImplBase <BussSendDataPack>
{
    id	retObj;
	SEL	retFunc;
}
@property(nonatomic, assign)id	retObj;
@property(nonatomic, assign)SEL	retFunc;

-(void) getSoftInfoFromVersion:(NSString*)sSoftID ResponseTarget:(id) target ResponseSelector:(SEL) selector;
//-(void)getSoftInfoFromVersion;
-(void)getSoftInfoFromVersionEnd:(id)err;
-(void)UnPackLoginJYEXSoftUpdataJsonStr:(NSDictionary*) jsObj;
@end

#pragma mark -
#pragma mark 家园E线 查询更新文章数
@interface BussJYEXGetUpdateNumber : BussInterImplBase <BussSendDataPack>
{
 
}

-(void) getUpdateNumber:(int)dateline ResponseTarget:(id) target ResponseSelector:(SEL) selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 登出
@interface BussLogout: BussInterImplBase <BussSendDataPack>
{
	NSString* sSID;		//sid
}
@property(nonatomic, retain) NSString* sSID;

-(void) Logout:(NSString*)sessID ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;

@end

#pragma mark -
#pragma mark 验证session
@interface BussCheckSession : BussInterImplBase
{
	NSString* sSID;		//sid
}
@property(nonatomic, retain) NSString* sSID;

-(void) checkSession:(NSString*)sessID ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;

@end


#pragma mark -
#pragma mark 注册新用户
@interface BussRegisterUser : BussInterImplBase <BussSendDataPack>
{
	NSString* UserName;
	NSString* Password;
	NSString* NickName;
}
@property(nonatomic, retain)NSString* UserName;
@property(nonatomic, retain)NSString* Password;
@property(nonatomic, retain)NSString* NickName;

-(void) registerUser:(NSString*)userName Password:(NSString*)password Nickname:(NSString*)nickname RespTarget:(id)target RespSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**) err;

@end


#pragma mark -
#pragma mark 流日/流月一句话运势
@interface BussFlowYS : BussInterImplBase <BussSendDataPack>
{
	TYunShiParam*	dataIn;		//输入参数
	NSString*		sReqDate;	//请求日期
	EYunshiType		iYsType;	//类型
}

@property(nonatomic, retain) TYunShiParam*	dataIn;
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic) EYunshiType iYsType;

//流日运势
-(void) reqFlowYS_Day:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//流月运势
-(void) reqFlowYS_Month:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(void) DoHttpRequest:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector;
+(NSDictionary*) PackJsonObjofPeplInfo:(TPeopleInfo*)pep;
+(NSDictionary*) PackJsonObjofPeplInfoByGUID:(NSString*)userGUID;
+(NSDictionary*) PackJsonObjofDateInfo:(TDateInfo*)date;

-(NSString*) PackSendOutJsonString;
-(int) getBussIDByYsType;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

+(BOOL) unpackFlowYSJson:(NSString*)sResponse DataOut:(TFlowYS*)data;
@end


#pragma mark -
#pragma mark 紫微运势

//消费查看类型
enum EConsumeLookFrom
{
	EConsumeLookFrom_Buy,	//购买消费查看
	EConsumeLookFrom_Blog	//微博分享免费查看
};

@interface BussZiweiYunshi : BussInterImplBase <BussSendDataPack>
{
	TYunShiParam*	dataIn;			//输入参数
	NSString*		sReqDate;		//请求日期
	EYunshiType		iYsType;		//类型
	EConsumeLookFrom iLookFrom;		//消费查看类型
}

@property(nonatomic, retain) TYunShiParam*	dataIn;
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic) EYunshiType iYsType;
@property(nonatomic) EConsumeLookFrom iLookFrom;

//紫微今日运势
-(void) DoHttpRequestYunshi_Day:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//紫微本月运势
-(void) DoHttpRequestYunshi_Month:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//紫微今年运势
-(void) DoHttpRequestYunshi_Year:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) DoHttpRequestMoneyFortune:(NSString*)userGuid Date:(TDateInfo*)date LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//
-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector;
-(int) getBussIDByYsType;
-(int) getConsumeItemByYsType;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackZwYsJson:(NSString*)sResponse DataOut:(TZWYS_FLOWYEAR_EXT*)data;
+(BOOL) unpackLYSMJson:(NSString*)sResponse DataOut:(TLYSM_MONEYFORTUNE_EXT*)data;
@end

//#pragma mark -
//#pragma mark 财富趋势
//@interface BussMoneyFortune : BussInterImplBase <BussSendDataPack>
//{
//    TYunShiParam*	dataIn;			//输入参数
//	NSString*		sReqDate;		//请求日期
//}
//@property(nonatomic, retain) TYunShiParam*	dataIn;
//@property(nonatomic, retain) NSString* sReqDate;
//
////紫微今日运势
//-(void) DoHttpRequestMoneyFortune:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//
//-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector;
//@end


#pragma mark -
#pragma mark 事业成长


@interface BussShiYeYunshi : BussInterImplBase <BussSendDataPack>
{
	TYunShiParam*	dataIn;			//输入参数
	NSString*		sReqDate;		//请求日期
	//EYunshiType		iYsType;		//类型
	//EConsumeLookFrom iLookFrom;		//消费查看类型
}

@property(nonatomic, retain) TYunShiParam*	dataIn;
@property(nonatomic, retain) NSString* sReqDate;
//@property(nonatomic) EYunshiType iYsType;
//@property(nonatomic) EConsumeLookFrom iLookFrom;

//紫微事业成长
-(void) DoHttpRequestYunshi_Career:(NSString*)userGuid Date:(TDateInfo*)date ResponseTarget:(id)target ResponseSelector:(SEL)selector;

//
-(void) DoHttpRequest:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackZwYsJson:(NSString*)sResponse DataOut:(TSYYS_EXT*)data;

@end

/*
#pragma mark -
#pragma mark 在线天气
enum EWeatherBussType
{
	EWeaType_WeaCn_IM,	//中国天气网，即时天气
	EWeaType_WeaCn,		//中国天气网，一周天气
	EWeaType_91Srv_IM,	//91天气，即时天气
	EWeaType_91Srv		//91天气，一周天气
};

@interface BussWeather : BussInterImplBase <BussSendDataPack>
{
	EWeatherBussType  iBussID;	//业务种类
	NSString*		sCityCode;  //城市代码
	NSString*		sReqDate;	//请求日期
	id dataOut;		//收到数据
}

@property(nonatomic) EWeatherBussType iBussID;
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sCityCode;
@property(nonatomic, retain) id dataOut;

-(void) DoRequestWeather:(id)target ResponseSelector:(SEL)selector;
//从中国天气网取即时天气
-(void) ReqImWeatherFromCn:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//从中国天气网取6天天气
-(void) ReqWkWeatherFromCn:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//从91服务端取即时天气
-(void) ReqImWeatherFrom91:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//从91服务端取周天气
-(void) ReqWkWeatherFrom91:(NSString*)cityCode ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(NSString*) makeReqUrlByBussID;
-(EHttpMethod) decideHttpMethod;

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackWeatherJson:(EWeatherBussType)dataType JsonData:(NSDictionary*)jsObjRoot DataOut:(id) dout;
+(BOOL) unpackImWeatherJson:(NSString*)sResponse DataOut:(TIMWeather_Ext*)data;
+(BOOL) unpackWkWeatherJson:(NSString*)sResponse DataOut:(TWeekdayWeather_Ext*)data;

+(void)divide2temp:(NSString*)temp:(NSInteger*)d1:(NSInteger*)d2; 
+(NSString*)combine2temp:(NSInteger)d1: (NSInteger) d2; 
+(NSString*)combine2weather:(NSString*)s1: (NSString*) s2;

@end
*/

#pragma mark -
#pragma mark 人格特质

@interface BussCharacter : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
	NSString*	sUserGuid;	//用户GUID
}
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sUserGuid;

-(void) RequestCharacter:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackJson:(NSString*)jsCharct DataOut:(TNatureResult*) dout;

@end


#pragma mark -
#pragma mark 爱情桃花

@interface BussLoveFlower : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
	NSString*	sUserGuid;	//用户GUID
}
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sUserGuid;

-(void) RequestLove:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackLoveJson:(NSString*)jsResp DataOut:(TLoveTaoHuaResult*) dout;

@end

#pragma mark -
#pragma mark 姓名分析
@interface BussNameParse : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
	NSString*	sUserGuid;	//用户GUID
	int iBussID;			//业务类型
}
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sUserGuid;
@property(nonatomic) int iBussID;

-(void) RequestNameParse:(id)target ResponseSelector:(SEL)selector;
//姓名排盘
-(void) RequestNameParsePlate:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//姓名解释
-(void) RequestNameParseExplain:(NSString*)sGuid ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(NSString*) PackSendOutJsonString_Plate;
-(NSString*) PackSendOutJsonString_Explain;

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

+(BOOL) unpackNameParsePlateJson:(NSString*)jsResp DataOut:(TNT_PLATE_INFO*) dout;
+(BOOL) unpackNameParseExplainJson:(NSString*)jsResp DataOut:(TNT_EXPLAIN_INFO*) dout;

+(BOOL) unpackCharacter:(NSDictionary*)jsObj DataOut:(TCHARACTER*)dout;
+(BOOL) unpackNameTitleExp:(NSDictionary*) jsObj DataOut:(TTITLE_EXP*) dout;


@end


#pragma mark -
#pragma mark 姓名分析－易心测试

@interface BussNameYxTest : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
	NSString*	sUserGuid;	//用户GUID
	TNameYxParam* tYxParam;	//参数
	EConsumeLookFrom iLookFrom;		//消费查看类型
}
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sUserGuid;
@property(nonatomic, retain) TNameYxParam* tYxParam;
@property(nonatomic) EConsumeLookFrom iLookFrom;

-(void) RequestNameYxTestInfo:(NSString*)sGuid Name:(TNameYxParam*)param LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

+(BOOL) unpackNameYxTestInfoJson:(NSString*)jsResp DataOut:(TNameYxTestInfo*) dout;

@end


#pragma mark -
#pragma mark 姓名匹配

@interface BussNameMatch : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
	TNAME_PD_PARAM* tNameInfo;	//匹配姓名
	EConsumeLookFrom iLookFrom;		//消费查看类型
}
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain)TNAME_PD_PARAM* tNameInfo;
@property(nonatomic) EConsumeLookFrom iLookFrom;

-(void) ReqNameMatch:(TNAME_PD_PARAM*)nameInfo LookFrom:(EConsumeLookFrom)lkFr ResponseTarget:(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackNameMatchJson:(NSString*)jsResp DataOut:(TNAME_PD_RESULT*) dout;

@end


#pragma mark -
#pragma mark 消费项目

enum EConsumeBussType
{
	EConsumeBussType_GetPrice,		//查询帐号余额及产品金额
	EConsumeBussType_CheckPayed,	//是否已经付费
	EConsumeBussType_Pay,			//消费
};

@interface BussConsume : BussInterImplBase <BussSendDataPack>
{
	EConsumeBussType iCusmType;	//业务类型
	EConsumeItem	iCusmItem;	//消费项目
	NSString*		sReqDate;	//请求日期
	NSString*		sFuncFlag;	//功能标识
}

@property(nonatomic) EConsumeBussType iCusmType;	
@property(nonatomic) EConsumeItem	iCusmItem;
@property(nonatomic, retain) NSString* sReqDate;
@property(nonatomic, retain) NSString* sFuncFlag;

//查询余额及产品金额
-(void) requestNameParsePrice:(EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) requestNameMatchPrice:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) requestLiuriyueYsPrice:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) requestProLiuriyueYsPrice:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) requestLiunianYsPrice:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) requestProLiunianYsPrice:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
//add 2012.9.4
-(void) requestFortuneYsPrice:(id)target ResponseSelector:(SEL)selector;
-(void) requestCareerYsPrice:(id)target ResponseSelector:(SEL)selector;

//查询是否已消费
-(void) checkNameParsePayed: (EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkNameMatchPayed:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkLiuriyuePayed:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkProLiuriyuePayed:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkLiunianPayed:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkProLiunianPayed:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) checkFortunePayed:(id)target ResponseSelector:(SEL)selector;
-(void) checkCareerPayed:(id)target ResponseSelector:(SEL)selector;

//积分消费
-(void) payNameParseConsume:(EConsumeItem)item ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payNameMatchConsume:(NSString*)strName1 Woman:(NSString*)strName2 ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payLiuriyueConsume:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payProLiuriyueConsume:(int)year Month:(int)month ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payLiunianConsume:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payProLiunianConsume:(int)year ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(void) payFortuneConsume:(id)target ResponseSelector:(SEL)selector;
-(void) payCareerConsume:(id)target ResponseSelector:(SEL)selector;

//请求
-(NSString*) getCGIWithCusmType;
-(NSString*) getNameParseFuncFlagByCusmItem;
+(int)getRuleIDWithConsmItem:(EConsumeItem)cusmItem;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

//JSON解析
+(BOOL)unpackGetPriceResult:(NSString*)jsRep Result:(TProductInfo*)prdInf;
+(BOOL)unpackCheckPayedResult:(NSString*)jsRep Result:(TCheckPayResult*)pChkPayResult;
+(BOOL)unpackPayResult:(NSString*)jsRep Result:(TPayResult*)payResult;


@end

#pragma mark -
#pragma mark 同步下载
@interface BussSyncDownLoad : BussInterImplBase <BussSendDataPack>
{
	NSString*		sSyncDate;	//同步日期
	int  iSrvMaxVer;	//下载数据中最大版本
	NSMutableArray* aryShoudHandleSrvPep;	//需要写库的服务端用户信息
}
@property(nonatomic, retain) NSString*	sSyncDate;
@property(nonatomic, assign) int  iSrvMaxVer;
@property(nonatomic, retain) NSMutableArray* aryShoudHandleSrvPep;

//开始同步下载
-(void) StartSyncDownLoad:(id)target :(SEL)selector;
//
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL)unpackSyncDownLoadPeopleList:(NSString*)jsRep PepList:(NSMutableArray*&)arySrvPeps;
-(int) getMaxVerFromSrvPepList:(NSArray*)arySrvPep;
-(NSMutableArray*)mergeLocalPeplBySrvList:(NSMutableArray*)aryServ;

@end


#pragma mark -
#pragma mark 同步上传
@interface BussSyncUpLoad : BussInterImplBase <BussSendDataPack>
{
	NSString*		sSyncDate;	//同步日期
}
@property(nonatomic, retain) NSString*	sSyncDate;

//开始同步上传
-(void) StartSyncUpLoad:(id)target :(SEL)selector;

//
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

@end



#pragma mark -
#pragma mark 同步下载
//提示类型
enum EPromptMsgType
{
	EPRMPTMSG_INFO,			//提示
	EPRMPTMSG_ERROR			//错误
};

//状态
enum ECurSynStep
{
	ECurSynStep_PreLogin,	//预登录
	ECurSynStep_SynDown,	//下载
	ECurSynStep_SynUp		//上传
};

@interface BussSync : BussInterImplBase
{
	NSString*		sSyncDate;	//同步日期
	BussLogin*	synLogin;	//重登录
	BussSyncDownLoad*	synDown;	//同步下载
	BussSyncUpLoad*		synUp;		//同步上传
	BOOL isBeginTransct;		//事务开始
	BOOL isEndTransct;			//事务结束
	
	NSString* sHostPepGUID;		//同步前本地主人
	
	int iCurProg;			//当前进度
	ECurSynStep iCurStep;	//当前步骤
	
	id retvObj;		
	SEL retvFunc;
}
@property(nonatomic, retain) NSString*	sSyncDate;
@property(nonatomic, retain) BussLogin*	synLogin;
@property(nonatomic, retain) BussSyncDownLoad* synDown;
@property(nonatomic, retain) BussSyncUpLoad* synUp;	
@property(nonatomic, assign) id retvObj;	
@property(nonatomic, assign) SEL retvFunc;
@property(nonatomic, assign) BOOL isBeginTransct;
@property(nonatomic, assign) BOOL isEndTransct;	
@property(nonatomic, retain) NSString* sHostPepGUID;
@property(nonatomic, assign) int iCurProg;		
@property(nonatomic, assign) ECurSynStep iCurStep;

//开始同步下载
-(void) StartSync:(id)target :(SEL)selector;
-(void) InvokeSyncDown;
-(void) InvokeSyncUp;
-(void) InvokeRelogin;

//同步下载返回
-(void)onRetriveSyncDownLoad:(id)err;
//同步上传返回
-(void)onRetriveSyncUpLoad:(id)err;
//重登录
-(void)onRetriveRelogin:(id)err;
//
-(void)updateLocalDbBySrv;
-(void)updateShouldSynPeopleVersionToLast;
-(void) updateHostPeople;
-(void) updateSyncedResult;

//同步进度提示数据
-(NSDictionary*)makeSyncProgressInfo:(int)iPercent Msg:(NSString*)sMsg Type:(int)iType IsStop:(BOOL)bStop;
-(void)notifyUICallBack:(int)iPercent Msg:(NSString*)sMsg Type:(int)iType IsStop:(BOOL)bStop;
-(void)dbRollback;
-(void)dbCommit;

@end


#pragma mark -
#pragma mark 检查新版本
@interface BussCheckVersion : BussInterImplBase <BussSendDataPack>
{
	NSString*	sCheckDate;	//日期
}
@property(nonatomic, retain) NSString*	sCheckDate;

//
-(void)checkNewVersion:(id)target :(SEL)selector;

//
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
+(BOOL) unpackJsonCheckVersion:(NSString*)sJson :(TCheckVersionResult*)dout;
+(NSComparisonResult) compareVersion:(NSString *)value1 :(NSString *)value2;


@end


#pragma mark -
#pragma mark 悬赏、建议
enum EBussSuggestType
{
	ESuggestType_Send,		//提交
	ESuggestType_Get		//取得回复
};

@interface BussSuggest : BussInterImplBase <BussSendDataPack>
{
	NSString* sReqTime;		//请求时间
	NSString* sSuggest;		//建议内容
	NSString* sSendQuestNO;	//建议GUID
	
	EBussSuggestType iBussType;		//业务类型
	
	//发出
	id sendObj;
	SEL sendFunc;
	
	//回复
	id getAnsObj;
	id getAnsFunc;
}

@property(nonatomic, retain) NSString* sReqTime;
@property(nonatomic, retain) NSString* sSuggest;
@property(nonatomic, retain) NSString* sSendQuestNO;
@property(nonatomic, assign) EBussSuggestType iBussType;
@property(nonatomic, assign) id sendObj;
@property(nonatomic, assign) SEL sendFunc;
@property(nonatomic, assign) id getAnsObj;
@property(nonatomic, assign) id getAnsFunc;


//发送建议
-(void)sendSuggest:(NSString*)sAsk :(id)target :(SEL)selector;

//取得回复
-(void)reqSuggestAnswer:(id)target :(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(NSString*) PackSuggestSendJsonString;
-(NSString*) PackSuggestGetAnswerJsonString;

-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;
-(BOOL) procSendResult:(NSError**)err;
-(BOOL) procAnswerResult:(id)rcvData Error:(NSError**)err;
-(BOOL) unpackJsonGetAnswer:(NSDictionary*)jObjRoot :(NSMutableArray*)aryAns;


@end


#pragma mark -
#pragma mark 推荐软件列表
enum
{
    BS_READY = 0,
    BS_CHECK,
    BS_DOWNLOAD,
};

@interface BussAppInfo : BussInterImplBase <BussSendDataPack>
{
    id cbObj;
    SEL cbFun;
    
    int dbAppVersion;
    int updateSts;
    AppInfoList* dbAppList;
}

@property (nonatomic, retain) AppInfoList* dbAppList;

//获取本地已经下载的软件列表
- (AppInfoList*) getAppInfoCacheList;

//获取网络软件列表 异步
- (void)updateAppInfoCacheList:(id)target :(SEL)selector;

- (NSString*) PackSendOutJsonString;

- (AppInfoList*) unpackAppInfoList:(NSString*)js;
- (BOOL) getCurVerion:(NSString*)js :(int*)curVersion;


@end


#pragma mark -
#pragma mark 签到换取积分

@interface BussQianDao : BussInterImplBase <BussSendDataPack>
{
	NSString*	sReqDate;	//请求日期
}

@property (nonatomic,retain) NSString* sReqDate;

-(void) RequestQiandao:(NSString *)strDate ResponseTarget :(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

@end

#pragma mark -
#pragma mark 获取服务器时间

@interface BussServerDateTime : BussInterImplBase <BussSendDataPack>
{
}

-(void) RequestServerDateTimeWithResponseTarget :(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL) ProcRecvData:(id) rcvData Error:(NSError**)err;

@end




//---------------------------------用户部分---------------------------------

#pragma mark -
#pragma mark 登录91简报业务服务

@interface BussLogin91Note : BussInterImplBase <BussSendDataPack>
{
}

-(void) Login91Note :(id)target ResponseSelector:(SEL)selector;

-(NSString*) PackSendOutJsonString;
-(BOOL)ProcRecvData:(id) rcvData Error:(NSError**)err;
-(BOOL)unpackJsonForResult:(NSString*)jsRep Result:(TBussStatus*)sts;

@end

#pragma mark -
#pragma mark 注销91简报业务服务

@interface BussLogout91Note : BussInterImplBase <BussSendDataPack>
{
}

-(void) Logout91Note :(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 获取用户信息

@interface BussGetUserInfo : BussInterImplBase <BussSendDataPack>
{
}

-(void) GetUserInfo :(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


//-----------------文件夹部分-------------------------------------------------------------
#pragma mark -
#pragma mark 下载文件夹列表

@interface BussDownDir : BussInterImplBase <BussSendDataPack>
{
}

-(void) DownDir:(NSString *)strGuid from:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 上传文件夹列表

@interface BussUploadDir : BussInterImplBase <BussSendDataPack>
{
    TCateInfo *cateInfo;
}
@property (nonatomic,retain) TCateInfo *cateInfo;

-(void) UploadDir:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

//-----------------------------笔记信息部分------------------------------------------------------

#pragma mark -
#pragma mark 获取最新笔记信息

@interface BussGetLatestNote : BussInterImplBase <BussSendDataPack>
{
}

-(void) GetLatestNote:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 下载笔记列表信息

@interface BussDownNoteList : BussInterImplBase <BussSendDataPack>
{
}

-(void) DownNoteList:(NSString *)strGuid from:(int)from to:(int)to size:(int)size ResponseTarget: (id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 下载笔记信息

@interface BussDownNote : BussInterImplBase <BussSendDataPack>
{
}

-(void) DownNote:(NSString *)strNoteGuid user_id:(int)user_id currentver:(int)curr_ver ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 上传笔记信息

@interface BussUploadNote : BussInterImplBase <BussSendDataPack>
{
    TNoteInfo *noteinfo;
}
@property (nonatomic,retain) TNoteInfo *noteinfo;


-(void) UploadNote:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 家园E线,上传日志
@interface BussUploadJYEXNote : BussInterImplBase <BussSendDataPack>
{
    TNoteInfo *noteinfo;
}
@property (nonatomic,retain) TNoteInfo *noteinfo;


-(void) UploadNote:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;
@end

#pragma mark -
#pragma mark 通过标题查找笔记

@interface BussSearchNoteList : BussInterImplBase <BussSendDataPack>
{
}

-(void) SearchNoteList:(NSString *)strTitle ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


//add 2012.2.18
#pragma mark -
#pragma mark 获取笔记的所有项(笔记、笔记项关联表、item不表)

@interface BussGetNoteAll : BussInterImplBase <BussSendDataPack>
{
    NSString *strNoteGuid;
    int from;
    int nNeedNote;
}
@property (nonatomic,retain) NSString *strNoteGuid;
@property (nonatomic,assign) int from;
@property (nonatomic,assign) int nNeedNote;

-(void) GetNoteAll:(NSString *)strNoteGuid from:(int)from neednote:(int)nNeedNote ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


//--------------------------------NoteXItem部分------------------------------------

#pragma mark -
#pragma mark 获取笔记的笔记与笔记项关联列表

@interface BussDownNoteXItems : BussInterImplBase <BussSendDataPack>
{
}

-(void) DownNoteXItems:(NSString *)strNoteGuid from:(int)from to:(int)to size:(int)size ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 上传笔记与笔记项关联信息

@interface BussUploadNoteXItems : BussInterImplBase <BussSendDataPack>
{
    TNoteXItem *noteXItem;
}
@property (nonatomic,retain) TNoteXItem *noteXItem;

-(void) UploadNoteXItems:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


//--------------------------------笔记项部分------------------------------

#pragma mark -
#pragma mark 获取笔记项信息

@interface BussDownItem : BussInterImplBase <BussSendDataPack>
{
}

-(void) DownItem:(NSString *)strItemGuid user_id:(int)user_id current_ver:(int)curr_ver ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 上载笔记项信息

@interface BussUploadItem : BussInterImplBase <BussSendDataPack>
{
    TItemInfo *iteminfo;
}
@property (nonatomic,retain) TItemInfo *iteminfo;


-(void)UploadItem:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 下载笔记项文件

@interface BussDownItemFile : BussInterImplBase <BussSendDataPack>
{
}

-(void)DownItemFile:(NSString *)strID filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 上传笔记项数据包

@interface BussUploadItemFile : BussInterImplBase <BussSendDataPack>
{
    NSString *strItemGuid;
    NSString *strExt;
    int rs;
    int re;
}
@property (nonatomic,retain) NSString *strItemGuid;
@property (nonatomic,retain) NSString *strExt;
@property (nonatomic,assign) int rs;
@property (nonatomic,assign) int re;

-(void)UploadItemFile:(id)param_ ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

@interface BussJYEXUploadItemFile : BussUploadItemFile {

}
@end

#pragma mark -
#pragma mark 上传笔记项完成

@interface BussUploadItemFileFinish : BussInterImplBase <BussSendDataPack>
{
    TItemInfo *iteminfo;
}
@property (nonatomic,retain) TItemInfo *iteminfo;

-(void) UploadItemFileFinish:(id)param ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end



#pragma mark -
#pragma mark 查询相册列表

@interface BussJYEXQueryAlbumList : BussInterImplBase <BussSendDataPack>
{
}

-(void) QueryAlbumList:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 上传图片到相册

@interface BussJYEXUploadPhoto : BussInterImplBase <BussSendDataPack>
{
}

-(void) uploadPhoto:(NSString *)strAlbumId title:(NSString *)strTitle albumname:(NSString *)strAlbumName itemguid:(NSString *)strItemGuid uid:(NSString *)strUid username:(NSString *)strUsername ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 创建相册

@interface BussJYEXCreateAlbum : BussInterImplBase <BussSendDataPack>
{
    NSString *m_strAlbum;
    NSNumber *m_spaceid;
}
@property(nonatomic,retain) NSString *m_strAlbum;
@property(nonatomic,retain) NSNumber *m_spaceid;

-(void) CreateAlbum:(NSString *)strAlbumName space:(NSNumber *)spaceid ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 注册

@interface BussJYEXRegister : BussInterImplBase <BussSendDataPack>
{
    NSString *m_strUser;
    NSString *m_strPassword;
    NSString *m_strNickname;
    NSString *m_strRealname;
    NSString *m_strEmail;
}

@property(nonatomic,retain) NSString *m_strUser;
@property(nonatomic,retain) NSString *m_strPassword;
@property(nonatomic,retain) NSString *m_strNickname;
@property(nonatomic,retain) NSString *m_strRealname;
@property(nonatomic,retain) NSString *m_strEmail;

-(void)RegisterUser:(NSString *)strUser password:(NSString *)strPassword nickname:(NSString *)strNickname readlname:(NSString *)strRealname email:(NSString *)strEmail ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 修改用户资料，包括密码

@interface BussJYEXUpdateUserInfo : BussInterImplBase <BussSendDataPack>
{
    NSString *m_strUid;
    NSString *m_strUserName;
    NSString *m_strOldPassword;
    NSString *m_strNewPassword;
    NSString *m_strNickname;
    NSString *m_strRealname;
    NSString *m_strEmail;
    NSString *m_strMobile;
}

@property(nonatomic,retain) NSString *m_strUid;
@property(nonatomic,retain) NSString *m_strUserName;
@property(nonatomic,retain) NSString *m_strOldPassword;
@property(nonatomic,retain) NSString *m_strNewPassword;
@property(nonatomic,retain) NSString *m_strNickname;
@property(nonatomic,retain) NSString *m_strRealname;
@property(nonatomic,retain) NSString *m_strEmail;
@property(nonatomic,retain) NSString *m_strMobile;

-(void)UpdateUserInfo:(NSString *)strUid username:(NSString *)strUserName oldpassword:(NSString *)strOldPassword newpassword:(NSString *)strNewPassword nickname:(NSString *)strNickname readlname:(NSString *)strRealname email:(NSString *)strEmail mobile:(NSString *)strMobile ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;


@end


#pragma mark -
#pragma mark 获取图片列表

@interface BussJYEXGetAlbumPics : BussInterImplBase <BussSendDataPack>
{
  
}


-(void) GetAlbumPics:(NSString *)strAlbumID ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


#pragma mark -
#pragma mark 下载文件

@interface BussDownloadFile : BussInterImplBase <BussSendDataPack>
{
}

-(void)DownloadFile:(NSString *)strUrl filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end


//--------------------------------下载头像部分------------------------------

#pragma mark -
#pragma mark 查询用户头像更新时间

@interface BussQueryAvatar : BussInterImplBase <BussSendDataPack>
{
}

-(void) QueryAvatar:(NSString *)strUserid ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end

#pragma mark -
#pragma mark 获取用户头像

@interface BussGetAvatar : BussInterImplBase <BussSendDataPack>
{
}


-(void)GetAvatar:(NSString *)strUserid filename:(NSString *)strFilename contenttype:(NSString *)strContentType ResponseTarget:(id)target ResponseSelector:(SEL)selector;
-(NSString*) PackSendOutJsonString;

@end





