//
//  DBController.h
//  SparkEnglish
//  对cppsqlite3的简单封装，适当时提供多个不同的单例来对不同数据库的访问
//  Created by huanghb on 11-1-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CppSQLite3.h"
#import "DbConstDefine.h"
#import "DbMngDataDef.h"
#import "CommonDef.h"
#import "BussInterImpl.h"

#pragma mark -
#pragma mark 数据库对象封装


#define GUID_ZERO @"00000000-0000-0000-0000-000000000000"

#define isGuidNull(p) (p==nil || [p isEqualToString:GUID_ZERO])



@interface DbItem: NSObject
{
	NSString*	fDBFileName;	//数据库文件名称
	CppSQLite3DB*	fCppSqlite3DB;		//c++数据库对象
	EDataBaseType	iDbTypeID;			//数据库类型
	BOOL bUpdatedWhenLoading;		//初次加载时是否升级过了
}

@property(nonatomic, retain) NSString*          fDBFileName;
@property(nonatomic, assign) CppSQLite3DB*      fCppSqlite3DB;
@property(nonatomic, assign) EDataBaseType      iDbTypeID;
@property(nonatomic, assign) BOOL               bUpdatedWhenLoading;

//- (BOOL) openWithName: (NSString *) dbFileNameWithFullPath;
//- (BOOL) openWithName: (NSString *) dbFileNameWithFullPath  DbKey:(NSString *) dbKey;
- (BOOL) openWithType: (EDataBaseType) dbType;
//- (BOOL) openWithType: (EDataBaseType) dbType DbKey:(NSString*) key;
- (BOOL) isOpen;
- (BOOL) close;

- (BOOL) setKey: (NSString *) key;
- (BOOL) resetKey: (NSString *) key;

- (NSString*) getDbFileShortName;
//- (NSString *) getDBFileName;

///执行查询语句，返回动态记录集
- (CppSQLite3Query) execQuery: (NSString *) sql;
//执行SQL语句
- (int) execDML: (NSString *) sql;
//执行返回单个数值的查询语句
- (int) execScalar: (NSString *) sql;
//以下函数用于事务处理
- (BOOL) beginTransaction;
- (BOOL) commitTransaction;
- (BOOL) rollbackTransaction;

- (BOOL) pepareStatement:(NSString*) sql Statement:(CppSQLite3Statement*) stmt;
- (int) commitStatement:(CppSQLite3Statement*) stmt;

@end



@interface AstroDBMng : NSObject
{
	NSMutableDictionary* dctDbItem;		//数据库对象集合
}

@property(nonatomic, retain) NSMutableDictionary* dctDbItem;

-(id) init;

#pragma mark -
//数据库管理
+(AstroDBMng *) getAstroDbMng;

//+(void)moveDbFile_1_1;
//系统数据库
+(DbItem *) getDbCustom1;
+(DbItem *) getDbCustom2;
+(DbItem *) getDbCustom3;
+(DbItem *) getDbAstroCommon;
//用户数据库
+(DbItem *) getDbUserLocal;

//91Note数据库
+(DbItem *) getDb91Note;


#pragma mark -
-(DbItem*) getDbInstace:(EDataBaseType) typeID;


//升级数据库
+(BOOL) updateDatabase;
+(BOOL) UpdateCommonDataTable;
+(void) initCommonDb_V1;

+(BOOL) UpdateUserDataTable;
+(void) initUserLocalDb_V1;
+(void) updateUserLocalDb_1_2;

+(BOOL) create91NoteTables;
//91note数据库升级(从1.2.5到1.3.0)
+(BOOL)check91NoteTables_V125_To_V130;

@end

#define gDbCustom1		[AstroDBMng getDbCustom1]
#define gDbCustom2		[AstroDBMng getDbCustom2]
#define gDbAstroCommon	[AstroDBMng getDbAstroCommon]
#define gDbUserLocal	[AstroDBMng getDbUserLocal]
#define gDb91Note       [AstroDBMng getDb91Note]

#pragma mark -
#pragma mark 数据库管理-Utility
@interface AstroDBMng (Utility)
+ (NSString *) getResourceInfo: (NSString *) resourceInfo;
+ (NSString *) getErrorInfo: (NSString *) errorInfo;
+ (NSString *) getErrorInfoWhenOperateDB : (NSString *) dbName : (NSString *) errorInfo;
+ (NSString *) getErrorInfoWhenAtomOperate : (NSString *) tableName : (NSString *) errorInfo;
+ (NSString *) getResourceInfo_int : (NSString *) resourceInfo : (int) paramInt;
+ (int) getIntFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName : (int) nullValue;
+ (int) getIntFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName;
+ (long) getLongFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName : (long) nullValue;
+ (long) getLongFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName;
+ (NSString *) getStringFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName : (NSString *) nullValue;
+ (NSString *) getStringFromCppSqlite3Query : (CppSQLite3Query) query : (NSString *) fieldName;
+ (NSString *) getStringFromChar : (const char *) sou;


+(int) getDbVersion:(EDataBaseType)dbType;
+(BOOL) setDbVersion:(EDataBaseType)dbType Vers:(int)newVer Desc:(NSString*)sDesc;

@end



#pragma mark -
#pragma mark 数据库管理-CUSTOM1
@interface AstroDBMng (ForCustom1)
+(BOOL) loadDbCustom1;


/////////黄历、黄历查询////////////
#pragma mark -
#pragma mark 黄历
//宜忌冲
+ (BOOL) getHuangli_YJC:(NSString*)nlMonthDZ NLDay:(NSString*)nlDayGZ HL:(THuangLi *)huangli;	//参数：农历月干支，干支，返回：宜忌冲
+ (BOOL) getHuangli_YJC:(int)yr Month:(int)mon Day:(int)day HL:(THuangLi *)huangli;	//参数：新历年，月，日，返回：宜忌冲
//取得所有黄道吉日选项
+ (NSArray*) getHuangliAllItem;
//黄历名词解释
+ (BOOL) getHuangDesc: (NSString*)type : (NSString*) name : (NSString*&) orig : (NSString*&)desc;
// 彭祖百忌
+ (NSString*) getPZBJ: (int) nYear : (int) nMonth : (int) nDay;
//节气
+ (NSString*) getJQ: (int) nYear : (int) nMonth : (int) nDay;
//节日
+ (NSString*) getJR: (int) nYear : (int) nMonth : (int) nDay;
//生肖
+ (NSString*) getSX: (int) nYear : (int) nMonth : (int) nDay;
//星座
+ (NSString*) getXZ: (int) nYear : (int) nMonth : (int) nDay;
//冲
+ (NSString*) getC: (int) nYear : (int) nMonth : (int) nDay;

/////////黄历查询////////////
#pragma mark -
#pragma mark 黄历查询
//宜、忌
+(BOOL) getHuangli_YJ:(NSString*)nlMonthDZ nLDay:(NSString*)dayGZ HLYi:(NSString*&)strYi HLJi:(NSString*&)strJi;
+(void) getHuangli_YJ:(int)nYear Month:(int)nMonth Day:(int)nDay HLYi:(NSString*&)strYi HLJi:(NSString*&)strJi;

//宜、忌查询
+(NSArray*) findHuangli_YJ:(int)nYear Month:(int)nMonth Flag:(ESearchHuangLiOption)optHL Item:(NSString*)itemHL;
+(NSString*) getstrYJForFindHuangli:(ESearchHuangLiOption)optHL;
//结婚典礼查询
+(NSArray*) findHuangli_Marry:(int)nYear Month:(int)nMonth SX1:(NSString*)manSX SX2:(NSString*)womanSX;
//黄历选项查询
+(NSArray*) findHuangli_Other:(NSString*)itemHL;

#pragma mark -
#pragma mark 流日吉时
+(NSArray*)getFlowDayJS:(NSDate*)date;

/////////天气城市管理////////////
#pragma mark -
#pragma mark 天气城市管理
+(NSArray*) getAllProvince;		//所有省
+(NSArray*) getAllAreasOfProv:(NSString*)provCode;	//指定省的所有地区
+(NSArray*) getAllCitysOfArea:(NSString*)areaCode;	//指定地区的所有城市
+(NSArray*) getAllCityByPinyin:(NSString*)pinyin;	//根据输入拼音搜索城市
+(NSString*) getCityNameByCityCode:(NSString*)cityCode;	//根据城市代码获得城市名
+(NSArray*) getCityCodeByCityName:(NSString*)sCityName;		//根据城市名称返回城市代码
+(NSString*) getProvNameByCityCode:(NSString*)cityCode;	//根据城市代码返回省份
+(NSString*) getProvCodeByCityCode:(NSString*)cityCode;	//根据城市代码返回省份代码
+(NSArray*) getCityDataByCityName:(NSString*)sCityName;		//根据城市名称返回城市代码、省份

#pragma mark -
#pragma mark 速配
//星座速配
+(TXingZuoMatch*) getXingzuoMatch:(NSString*)manXZ :(NSString*)womanXZ;
//生肖速配
+(TShengxiaoMatch*) getShengxiaoMatch:(NSString*)manSX :(NSString*)womanSX;
//生肖特点
+(NSString*) getShengxiaoCharaInfo:(NSString*)sx;
//生日速配
+(TBirthdayMatch*) getBrithdayMatch:(TDateInfo*)manGlBirthday :(TDateInfo*)womanGlBirthday;

@end


#pragma mark -
#pragma mark 数据库管理-CUSTOM2
@interface AstroDBMng (ForCustom2)
+(BOOL) loadDbCustom2;


#pragma mark -
#pragma mark 抽签和掷杯
//抽签
+(int) getCastLotsNumber;
//签文解释
+(TCastLots*) getCastLotsDetailByNumber:(int)nNum;
//掷杯
+(ERollCupResult) RollCup;


#pragma mark -
#pragma mark 周公解禁
+(NSArray*) getDreamGroupNames;
+(NSArray*) getDreamItemsByGroupName:(NSString*)sGroupName;
+(TParseDream*) getDreamParseResult:(NSString*)sDreamContent;
+(NSArray*) searchDreamGroupNames:(NSString*)sInput;
@end


#pragma mark -
#pragma mark 数据库管理-CUSTOM3
@interface AstroDBMng (ForCustom3)
+(BOOL) loadDbCustom3;

@end


#pragma mark -
#pragma mark 数据库管理-ASTROCOMMON
@interface AstroDBMng (AstroCommon)

+(BOOL) loadDbAstroCommon;
//最后登录的帐号
+(BOOL) getLastLoginUser:(TLoginUserInfo*) user;
+(TLoginUserInfo*) getLoginUserBySID:(NSString*)sSID;
+(TLoginUserInfo*) getLoginUserByUID:(NSString*)sUserID;
//更新帐号
+(int) replaceLoginUser:(TLoginUserInfo*) user;
//帐号列表
+(NSMutableArray* ) getLoginUserList;
//本地登录过的帐号数
+(int) getLoginedUserCount;
//查询结果转为数据结构
+(void) pickAccountFromQuery:(TLoginUserInfo*) user Query:(CppSQLite3Query*)query;
//删除账户
+(BOOL) deleteLoginUserByUserName:(NSString*)sUserName;

//家园E线
//最后登录的帐号
+(TJYEXLoginUserInfo*) getJYEXLoginUserByUID:(NSString*)sUserID;
//
+(TJYEXLoginUserInfo*) getJYEXLoginUserByUserName:(NSString*)sUserName;
//更新账号
+(int) replaceJYEXLoginUser:(TJYEXLoginUserInfo*) user;
//查询用户信息结果转为数据结构
+(void) pickJYEXAccountFromQuery:(TJYEXLoginUserInfo*) user Query:(CppSQLite3Query*)query;

//自定义数据
+(NSString*) getSystemCfg:(NSString*)sKey Cond:(NSString*)sCondition Default:(NSString*)sDefValue;
+(BOOL) setSystemCfg:(NSString*)sKey Cond:(NSString*)sCondition Value:(NSString*)sValue;

@end

#pragma mark-
#pragma mark 家园E线用户应用表
@interface AstroDBMng (AppList)
+(BOOL) deleteJYEXAppListByUserName:(NSString *)sUserName;
+(NSArray*) getAppListByUserName:(NSString *)sUserName AppType:(UserAppType)appType;
+(JYEXUserAppInfo*)getAppListByUserName:(NSString *)sUserName AppCode:(NSString *)appCode;

+(int) insertAppListByUserName:(NSString *)sUserName AppList:(NSArray*)appList;
+(BOOL) pickAppInfoFromQuery:(JYEXUserAppInfo*) appInfo Query:(CppSQLite3Query*)query;
+(BOOL) pickLanmuInfoFromQuery:(TJYEXLanmu*) lanmuInfo Query:(CppSQLite3Query*)query;
+(NSArray*) getLanmuList;
+(BOOL) cleanLanmuList;
+(int) insertLanmuListByUserName:(NSArray*)lanmuList;

+(BOOL) pickClassInfoFromQuery:(TJYEXClass*) classInfo Query:(CppSQLite3Query*)query;
+(NSArray*) getClassList;
+(BOOL) cleanClassList;
+(int) insertClassListByUserName:(NSArray*)classList;
@end

#pragma mark -
#pragma mark 数据库管理-USERLOCAL
@interface AstroDBMng (ForUserLocal)

+(BOOL) loadDbUserLocal;	//打开
+(BOOL) loadDbUserLocal:(NSString*) userName;
+(BOOL) CloseDbUserLocal;	//关闭

//创建并加载缺省帐号（guest）数据
+(BOOL) loadDefaultUserData;
//切换缺省帐号到登录帐号
//+(BOOL) switchDefaultUserToRegUser:(NSString*) regUserName;
//切换帐号(非缺省帐号)
+(BOOL) switchUserDB:(NSString*)sNewUser;

#pragma mark -
///////////命造相关/////////////
//主命造
+(BOOL) getHostPeopleInfo:(TPeopleInfo*)pep;
+(int)	setHostPeople:(NSString*) sGuid Host:(BOOL)bHost;
//演示命造
+(TPeopleInfo*) getDemoPeople;
//命造
+(TPeopleInfo*) getPeopleInfoBysGUID:(NSString*) sGuid;
+(TPeopleInfo*) getPeopleInfoByGUID:(GUID&) guid;
+(BOOL) pickPeopleFromQuery:(TPeopleInfo*) pep Query:(CppSQLite3Query*)query;
//命造列表
+(NSMutableArray*) getBeShownPeopleInfoList;	//可显示的命造列表：排除已经删除的数据
//更新命造
+(int) updatePeopleInfo:(TPeopleInfo*) pepInfo;
//删除命造
+(BOOL) removePopleInfoBysGUID:(NSString*) sGuid;
+(BOOL) clearPopleBysGUID:(NSString*) sGuid;
//增加新的命造
+(BOOL) addNewPeople:(TPeopleInfo*) pepInfo;

//用于命造列表同步时的相关操作
+(NSMutableArray*) getBeSyncdPeopleInfoList;	//将要同步的命造列表：不包括演示数据
+(int) getBeSyncdPeopleCount;
+(NSMutableArray*) getAllPeopleInfoList;	//全部非演示命造
+(int) getAllPeopleInfoCount;
+(NSMutableArray*) getAllRealPeopleList;	//全部非演示的可显示命造：不包括演示数据和已删除的数据
+(int) getAllRealPeopleCount;
+(BOOL) setPeolpeSynced:(NSString*)sGuid SynFlag:(int)iSynced;
+(BOOL) setAllPeopleSynced;
+(int) synUpdatePeopleInfo:(TPeopleInfo*) pepInfo;
+(BOOL) synRemovePopleInfoBysGUID:(NSString*) sGuid;
+(BOOL) synAddNewPeople:(TPeopleInfo*) pepInfo;
+(NSMutableArray*) getHostPeopleList;
+(TPeopleInfo*) getFirstUnDelPeople;

#pragma mark -
//自定义数据
+(NSString*) getUserCfg:(NSString*)sItem Cond:(NSString*)sCondition Default:(NSString*)sDefVal;
+(BOOL) setUserCfg:(NSString*)sItem Cond:(NSString*)sCondition Val:(NSString*)sValue;

//同步日志标识
+(int) getLocalSyncVer;
+(void) setLocalSynVer:(int)iNewVer;

#pragma mark -
//微博分享标识
+(BOOL) hasBlogSharedToday;
+(void) setBlogSharedFlag;
//微博内容
+(NSString*) getBlogContent;
+(BOOL) updateBlogContent:(NSString*)sContent;
+(BOOL) removeBlogContent;

#pragma mark -
//皮肤
+(NSString*) getSkinImage;
+(BOOL) getShowOldbak;
+(BOOL) setShowOldbak:(BOOL)isShow;


#pragma mark -
////////本地请求数据缓存相关/////////////
+(BOOL) pickLocalDataFromQuery:(TUserLocalData*)localData Query:(CppSQLite3Query*)query;
+(NSString*) makePeplSumInfoByGUID:(NSString*)sGUID;
+(NSString*) makePeplSumInfoByObj:(TPeopleInfo*)pepl;

#pragma mark -
/////////////运势///////////////
//流日/流月运势简评
+(BOOL) getFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TFlowYS*)tYunshi;
+(BOOL) removeFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date;
+(int) replaceFlowYS:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date JsonData:(NSString*)jsLrYs;
+(BOOL) pickFlowYSFromQuery:(TFlowYS*)tYunshi Query:(CppSQLite3Query*)query;
//紫微运势
+(BOOL) getZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) getZwYs_Day:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) getZwYs_Month:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) getZwYs_Year:(NSString*)userGuid Date:(TDateInfo*)date YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) removeZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date;
+(int) replaceZwYs:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date JsonData:(NSString*)jstrZwYs;
+(BOOL) pickZwJsFromQuery:(TZWYS_FLOWYEAR_EXT*)ZwYs Query:(CppSQLite3Query*)query;

+(BOOL) getLYSMMoney:(NSString*)userGuid Date:(TDateInfo*)date YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs;
//财富趋势
+(BOOL) getLYSMMoney:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs;
+(BOOL) pickSMMoneyFromQuery:(TLYSM_MONEYFORTUNE_EXT*)ZwYs Query:(CppSQLite3Query*)query;

//事业成长  add 2012.8.16
+(BOOL) getYs_Career:(NSString*)userGuid Date:(TDateInfo*)date YS:(TSYYS_EXT*)SyYs;
+(BOOL) pickSyYsFromQuery:(TSYYS_EXT*)SyYs Query:(CppSQLite3Query*)query;
//事业成长的替换和删除用紫微运势的

//本地是否有缓存运势
+(BOOL) hasSavedYunshi:(NSString*)userGuid YsType:(EYunshiType)type Date:(TDateInfo*)date;

#pragma mark -
#pragma mark 天气信息
///////////天气相关/////////////
+ (WeatherInfo*) getWeatherInfo:(NSString*)citycode 
                           Date:(NSString*)date;

+ (BOOL) replaceWeatherInfo:(NSString*)cityCode 
                       Date:(NSString*)date 
                       Json:(NSString*)json 
                  TimeStamp:(NSTimeInterval)ts;

#pragma mark -
#pragma mark 天气城市设置
//默认城市设置
+(TCityWeather*) getCityWeatherData:(NSString*)cityCode;
+(TCityWeather*) getDefaultCityData;
+(BOOL) addCity:(NSString*)cityID Name:(NSString*)cityName Order:(int)order;
+(BOOL) removeCity:(NSString*) cityID;
+(BOOL) setDispOrderByCode:(NSString*) citycode Order:(int)order;
+(NSArray*) getAllCityByOrder;
+ (int) getCityNum;

#pragma mark -
#pragma mark 人格特质
+(BOOL) getPeopleCharacter:(NSString*)userGuid OutData:(TNatureResult*) datout;
+(BOOL) pickPeopleCharacter:(TNatureResult*)data Query:(CppSQLite3Query*)query;
+(BOOL) replacePepoCharacter:(NSString*)userGuid Data:(NSString*)jsCharct Time:(NSString*) sTime;
+(BOOL) removePeopleCharacter:(NSString*)userGuid;
+(BOOL) hasSavedPeopleCharacter:(NSString*)userGuid;

#pragma mark -
#pragma mark 爱情桃花
+(BOOL) getLoveFlower:(NSString*)userGuid OutData:(TLoveTaoHuaResult*) datout;
+(BOOL) pickLoveFlower:(TLoveTaoHuaResult*)data Query:(CppSQLite3Query*)query;
+(BOOL) replaceLoveFlower:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime;
+(BOOL) removeLoveFlower:(NSString*)userGuid;
+(BOOL) hasSavedLoveFlower:(NSString*)userGuid;

#pragma mark -
#pragma mark 姓名分析
+(BOOL) getNameParsePlate:(NSString*)userGuid OutData:(TNT_PLATE_INFO*) datout;
+(BOOL) getNameParseExplain:(NSString*)userGuid OutData:(TNT_EXPLAIN_INFO*) datout;

+(BOOL) pickNameParsePlate:(TNT_PLATE_INFO*)data Query:(CppSQLite3Query*)query;
+(BOOL) pickNameParseExplain:(TNT_EXPLAIN_INFO*)data Query:(CppSQLite3Query*)query;

+(BOOL) replaceNameParsePlate:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime;
+(BOOL) replaceNameParseExplain:(NSString*)userGuid Data:(NSString*)jsResp Time:(NSString*) sTime;

+(int) removeNameParsePlate:(NSString*)userGuid;
+(int) removeNameParseExplain:(NSString*)userGuid;

+(BOOL) hasSavedNameParsePlate:(NSString*)userGuid;
+(BOOL) hasSavedNameParseExplain:(NSString*)userGuid;


#pragma mark -
#pragma mark 姓名测试
+(BOOL) getNameTest:(NSString*)userGuid Name:(TNameYxParam*)param OutData:(TNameYxTestInfo*) datout;
+(BOOL) pickNameTest:(TNameYxTestInfo*)data Query:(CppSQLite3Query*)query;
+(BOOL) replaceNameTest:(NSString*)userGuid Name:(TNameYxParam*)param Data:(NSString*)jsResp Time:(NSString*) sTime;
+(int) removeNameTest:(NSString*)userGuid Name:(TNameYxParam*)param;
+(BOOL) hasSavedNameTest:(NSString*)userGuid Name:(TNameYxParam*)param;

#pragma mark -
#pragma mark 姓名匹配
+(BOOL) getNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param OutData:(TNAME_PD_RESULT*) datout;
+(BOOL) pickNameMatch:(TNAME_PD_RESULT*)data Query:(CppSQLite3Query*)query;
+(BOOL) replaceNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param Data:(NSString*)jsResp Time:(NSString*) sTime;
+(int) removeNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param;
+(BOOL) hasSavedNameMatch:(NSString*)userGuid Name:(TNAME_PD_PARAM*)param;


#pragma mark -
#pragma mark 检查新版本
//是否有新版本
+(BOOL) hasNewVersion;
//
+(BOOL)getVerCheckResult:(TCheckVersionResult**)dataOut;
+(BOOL)replaceVerCheckResult:(NSString*)jsResp;
+(BOOL)removeVerCheckResult;
+(BOOL) hasSavedVerCheckResult;


#pragma mark -
#pragma mark 悬赏&建议
//增加新问题
+(BOOL)addNewQuestion:(NSString*)sQuestion QuestNO:(NSString*)sQuestNO Time:(NSString*)sAskTime;
//更新问题标识
+(BOOL)updateQuestionFlagByAnswerTable;
+(BOOL)updateQuestionFlag:(NSString*)sQuestNO Flag:(int)flag;
//取得所有问题（按时间排序）(TQuestionAnswer)
+(NSArray*)getAllQuestions;
//取得所有未回复问题GUID
+(NSArray*)getUnanswerQuestions;

#pragma mark -
#pragma mark 悬赏&建议-回复
//增加新的问题回复
+(BOOL)addNewAnswer:(NSString*)sQuestNO Answer:(NSString*)sAns Time:(NSString*)sAnsTime;
//取得某问题的所有回复
+(NSArray*)getSuggestAnswers:(NSString*)sQuestNO;
@end


#pragma mark -
#pragma mark 数据管理－生日速配&号码测试
@interface AstroDBMng (ForSolidData)

#pragma mark -
#pragma mark 生日速配
+(TBirthdayMatch*) GetBirthDayQuickMathResult:(TDateInfo*)manGlDate Woman:(TDateInfo*)womanGlDate;
+(int) ChangeDateToBirthCode:(TDateInfo*)glDate;



#pragma mark -
#pragma mark 号码测试

//测试手机号码的吉凶
+(TTelephoneJiXiong*) GetTelePhoneJiXResult:(NSString*)strTelNumber;
//测试QQ号码的吉凶结果
+(TTITLE_EXP*) GetQqNumberTestRes:(NSString*)strQQNumber;
+(int) CountNumber:(NSString*)strTemp;
//获取车牌号码的吉凶解释
+(NSString*) GetCarLicensePlateResult:(NSString*)strProvince CityLetter:(NSString*)strCityLetter Number:(NSString*)strNumber;
+(int) changeProvinceToNum:(NSString*)strProvince;

@end


#pragma mark -
#pragma mark 数据库管理－演示命造专用

@interface AstroDBMng (ForDemoPeople)

//流势
+(BOOL) getDemoFlowYSDay:(NSString*)userGuid YS:(TFlowYS*)tYunshi;
+(BOOL) getDemoFlowYSMonth:(NSString*)userGuid YS:(TFlowYS*)tYunshi;
//紫微运势
+(BOOL) getDemoZwYsDay:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) getDemoZwYsMonth:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
+(BOOL) getDemoZwYsYear:(NSString*)userGuid YS:(TZWYS_FLOWYEAR_EXT*)ZwYs;
//财富趋势
+(BOOL) getDemoLYSMMoney:(NSString*)userGuid YS:(TLYSM_MONEYFORTUNE_EXT*)ZwYs;
//事业成长
+(BOOL) getDemoYsCareer:(NSString*)userGuid YS:(TSYYS_EXT*)SyYs;
@end








