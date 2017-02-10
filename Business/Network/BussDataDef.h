//
//  BussData.h
//  Astro
//
//  Created by root on 11-11-18.
//  Copyright 2011 ND SOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDef.h"


#pragma mark -
#pragma mark 网络数据结构

//操作响应状态
@interface TBussStatus : NSObject
{
	int iCode;
	NSString* sInfo;
	id rtnData;
    id srcParam;  //2015.1.27
}

@property (nonatomic, assign) int iCode;
@property (nonatomic, retain) NSString* sInfo;
@property (nonatomic, retain) id rtnData;
@property (nonatomic, retain) id srcParam;

@end



//登录用户
@interface TLoginUserInfo : NSObject <NSCopying>
{
@public
	enum ELoginType
	{
		ELoginType_NULL = 0,
		ELoginType_OffLine,		//脱机登录
		ELoginType_OnLine		//联机登录
	};
	
	NSString* sUserName;
	NSString* sPassword;
	NSString* sUserID;
	NSString* sNickName;
	NSString* sRealName;
	NSString* sUAPID;
	NSString* sSID;
	NSString* sSessionID; 
	NSString* sLoginTime;
	int iLoginType;
	int iGroupID;
	int iAppID;
	NSString* sBlowfish;
	
	int iSavePasswd;
	int iAutoLogin;
	
	NSString* sSrvTbName;		//
	NSString* sMsg;
    
    //登录91简报业务的参数
    NSString *sNoteUserId;
    NSString *sNoteMasterKey;
    NSString *sNoteIpLocation;

}
@property(nonatomic, retain) NSString* sUserName;
@property(nonatomic, retain) NSString* sPassword;
@property(nonatomic, retain) NSString* sUserID;
@property(nonatomic, retain) NSString* sNickName;
@property(nonatomic, retain) NSString* sRealName;
@property(nonatomic, retain) NSString* sUAPID;
@property(nonatomic, retain) NSString* sSID;
@property(nonatomic, retain) NSString* sSessionID;
@property(nonatomic, retain) NSString* sLoginTime;
@property(nonatomic, retain) NSString* sBlowfish;
@property(nonatomic, retain) NSString* sSrvTbName;
@property(nonatomic, retain) NSString* sMsg;
@property(nonatomic)	int iLoginType;
@property(nonatomic)	int iGroupID;
@property(nonatomic)	int iAppID;
@property(nonatomic)	int iSavePasswd;
@property(nonatomic)	int iAutoLogin;
@property(nonatomic, retain) NSString *sNoteUserId;
@property(nonatomic, retain) NSString *sNoteMasterKey;
@property(nonatomic, retain) NSString *sNoteIpLocation;


- (BOOL) isDefaultUser;
- (BOOL) isLogined;

@end

@interface TJYEXLoginUserInfo : TLoginUserInfo {
    NSString *sEmail;
    NSString *sMobilephone;
    NSString *sTelephone;
    NSString *sAddress;
    int iLoginFlag;
    int iSchoolType;
    
    NSString *sAlbumIdPerson; //2014.9.26
    NSString *sAlbumNamePerson;
    NSString *sAlbumUidPerson;
    NSString *sAlbumUsernamePerson;
    NSString *sAlbumIdClass; //2014.9.26
    NSString *sAlbumNameClass;
    NSString *sAlbumUidClass;
    NSString *sAlbumUsernameClass;
    NSString *sAlbumIdSchool; //2014.9.26
    NSString *sAlbumNameSchool;
    NSString *sAlbumUidSchool;
    NSString *sAlbumUsernameSchool;
}
@property(nonatomic, retain) NSString* sEmail;
@property(nonatomic, retain) NSString* sMobilephone;
@property(nonatomic, retain) NSString* sTelephone;
@property(nonatomic, retain) NSString* sAddress;
@property(nonatomic, assign)	int iLoginFlag;
@property(nonatomic, assign)	int iSchoolType;
@property(nonatomic, retain) NSString *sAlbumIdPerson; //2014.9.26
@property(nonatomic, retain) NSString *sAlbumNamePerson;
@property(nonatomic, retain) NSString *sAlbumUidPerson;
@property(nonatomic, retain) NSString *sAlbumUsernamePerson;
@property(nonatomic, retain) NSString *sAlbumIdClass; //2014.9.26
@property(nonatomic, retain) NSString *sAlbumNameClass;
@property(nonatomic, retain) NSString *sAlbumUidClass;
@property(nonatomic, retain) NSString *sAlbumUsernameClass;
@property(nonatomic, retain) NSString *sAlbumIdSchool; //2014.9.26
@property(nonatomic, retain) NSString *sAlbumNameSchool;
@property(nonatomic, retain) NSString *sAlbumUidSchool;
@property(nonatomic, retain) NSString *sAlbumUsernameSchool;

-(BOOL)isMiddleSchoolTeacher;
-(BOOL)isMiddleSchoolParent;
-(BOOL)isMiddleSchoolMaster;
-(BOOL)isInfantsSchoolParent;
-(BOOL)isInfantsSchoolTeacher;
-(BOOL)isInfantsSchoolMaster;
-(BOOL)isCommonMember;

@end

//栏目列表
@interface TJYEXLanmu : NSObject <NSCopying> {
@private
    NSString *sLanmuName;
}
@property(nonatomic, retain) NSString* sLanmuName;
@end

//班级列表
@interface TJYEXClass : NSObject <NSCopying> {
@private
    NSString *sClassId;
    NSString *sClassName;
}
@property(nonatomic, retain) NSString* sClassId;
@property(nonatomic, retain) NSString* sClassName;
@end
// 人员信息
enum EPeplOptFlag
{
	EPEPL_OPT_ADD,	//增加：0
	EPEPL_OPT_MOD,	//修改：1
	EPEPL_OPT_DEL,	//删除：2
	
	EPEPL_OPT_DEMO = 10,		//用于演示的数据;不同步、不删除，可修改
	EPEPL_OPT_END	//空
};

@interface TPeopleInfo : NSObject <NSCopying>
{
@public
	int ipeopleId;
	//组Id
	int iGroupId;
	// 编号
	NSString* sGuid;
	// 人员姓名
	NSString* sPersonName;
	// 人员称谓
	NSString* sPersonTitle;
	//标记是否是主人
	int bIsHost;
	//标记是否是大众还是专业
	int bIsDaZhong;
	//头像标记
	NSString* sHeadImg;
	// 人员性别
	NSString* sSex;
	// 出生地区
	NSString* sBirthplace;
	// 所在经度区
	NSString* sTimeZone;//东区(东经)为"E", 西区(西经)为"W"
	// 所在纬度区
	NSString* sWdZone;   //纬度--北纬 为"N"，南纬 为"S"
	// 精确时区
	int iTimeZone;      // 取值范围：-12~12
	// 经纬度
	int iLongitude;		//经度（单位：度）
	int iLongitude_ex;	//经度（单位：分）
	int iLatitude;     // 纬度（度）
	int iLatitude_ex;  // 纬度（分）
	// 与真太阳时的差
	int iDifRealTime;
	// 是否闰月
	int bLeap;
	// 公历年
	int iYear;
	// 公历月
	int iMonth;
	// 公历日
	int iDay;
	// 出生时
	int iHour;
	// 出生分
	int iMinute;
	// 农历年
	int iLlYear;
	// 农历月
	int iLlMonth;
	// 农历日
	int iLlDay;
	// 时辰
	NSString*  sLlHour;
	// 保存用户输入日期信息
	NSString*  sSaveUserInput;
	//数据操作标志
	int iDataOpt;	//参见EPeplOptFlag定义
	//数据同步版本标记
	int iVersion;	
	
	/////自定义数据/////
	//所属帐号
	NSString* sUid;
	//是否同步了
	int bSynced;	//1－已同步; 0－未同步;
	
	//内存属性（不存数据表）
	int itmpOptFlag;	//参见EPeplOptFlag定义
    
    NSString* py;
	
}
@property(nonatomic)int ipeopleId;
@property(nonatomic)int iGroupId;
@property(nonatomic, retain)NSString* sGuid;
@property(nonatomic, retain)NSString* sPersonName;
@property(nonatomic, retain)NSString* sPersonTitle;
@property(nonatomic)int bIsHost;
@property(nonatomic)int bIsDaZhong;
@property(nonatomic, retain)NSString* sHeadImg;
@property(nonatomic, retain)NSString* sSex;
@property(nonatomic, retain)NSString* sBirthplace;
@property(nonatomic, retain)NSString* sTimeZone;
@property(nonatomic, retain)NSString* sWdZone;  
@property(nonatomic)int iTimeZone;      
@property(nonatomic)int iLongitude;		
@property(nonatomic)int iLongitude_ex;	
@property(nonatomic)int iLatitude;     
@property(nonatomic)int iLatitude_ex; 
@property(nonatomic)int iDifRealTime;
@property(nonatomic)int bLeap;
@property(nonatomic)int iYear;
@property(nonatomic)int iMonth;
@property(nonatomic)int iDay;
@property(nonatomic)int iHour;
@property(nonatomic)int iMinute;
@property(nonatomic)int iLlYear;
@property(nonatomic)int iLlMonth;
@property(nonatomic)int iLlDay;
@property(nonatomic, retain)NSString*  sLlHour;
@property(nonatomic, retain)NSString*  sSaveUserInput;
@property(nonatomic)int iDataOpt;
@property(nonatomic)int iVersion;	
@property(nonatomic, retain)NSString* sUid;
@property(nonatomic)int bSynced;
@property(nonatomic)int itmpOptFlag;
@property(nonatomic, retain) NSString* py;

-(BOOL) isEqualToPeople:(TPeopleInfo*)other;
-(BOOL) isDemo;
-(BOOL) isHost;
- (NSComparisonResult)compareByName:(id)inObject;

@end

// 定义日期数据结构
@interface TDateInfo : NSObject
{
@public
	// 年
	int  year;
	// 月
	int  month;
	// 日
	int  day;
	// 时
	int hour;
	//分
	int minute;
	// 是否闰月
	int isRunYue;
}
@property(nonatomic)int  year;
@property(nonatomic)int  month;
@property(nonatomic)int  day;
@property(nonatomic)int hour;
@property(nonatomic)int minute;
@property(nonatomic)int isRunYue;

+ (TDateInfo*) getTodayDateInfo;
+ (TDateInfo*) dateinfoFromDate:(NSDate*)dt;
+ (TDateInfo*) dateinfoDayToNow:(int)d;
+ (TDateInfo*) dateinfoMonthToNow:(int)m;
+ (TDateInfo*) dateinfoMonthToSpecificMonth:(int)m date:(NSDate*)dt;  //add 2012.8.20
+ (TDateInfo*) dateinfoYearToNow:(int)y;
+ (TDateInfo*) dateinfoYearToSpecificYear:(int)y date:(NSDate*)dt;  //add 2012.8.20

@end


// 大众运势-查询参数
@interface TYunShiParam : NSObject
{
@public
	TPeopleInfo* pepInfo;			// 人员信息
	TDateInfo*   dateInfo;			// 所求的日期
}
@property(nonatomic, retain)TPeopleInfo* pepInfo;
@property(nonatomic, retain)TDateInfo*   dateInfo;


@end


// 解释
@interface TTITLE_EXP : NSObject
{
@public
	// 标题
	NSString* sTitle;
	// 解释
	NSString* sExplain;
}
@property(nonatomic, retain)NSString* sTitle;
@property(nonatomic, retain)NSString* sExplain;

@end

//流日/流月运势简评
@interface TFlowYS : NSObject
{
@public
	NSString* sDataTime;		//流势数据的时间
	// 解释
	TTITLE_EXP* yunShi;			//流势
}
@property(nonatomic, retain) NSString* sDataTime;
@property(nonatomic, retain) TTITLE_EXP* yunShi;	
@end


// 大众版--简约命理信息
@interface TDZYS_SIMPLE_FATE_INFO : NSObject
{
@public
	// 八字运程
	NSString* sBzFate;
	
	// 八字运程解释
	NSString* sBzFateExp;
	
	// 当值紫微主星
	NSString* sZwStar;
	
	// 主星与宫位情况解释
	NSString* sZwStarExp;
	
}
@property(nonatomic, retain)NSString* sBzFate;
@property(nonatomic, retain)NSString* sBzFateExp;
@property(nonatomic, retain)NSString* sZwStar;
@property(nonatomic, retain)NSString* sZwStarExp;

@end


// 大众版--每个年、月、日的吉凶指数结构体(一般用于绘制吉凶趋势图标)
@interface TDZYS_EVERY_JX_VALUE : NSObject
{
@public
	// 时间标题，如“11月”(放的是农历时间)
	NSString* sDateTile;
	
	// 时间标题，如“(公历1.4-2.3)” (放的是sDateTile对应的公历时间段，可看做为sDateTile的扩展)
	NSString* sDateTileExp;
	
	// 吉凶数值 ，取值为 0~100
	int iJxValue;
	
}
@property(nonatomic, retain)NSString* sDateTile;
@property(nonatomic, retain)NSString* sDateTileExp;
@property(nonatomic)int iJxValue;

@end



// 十二宫的吉凶情况--手机运势使用
@interface TPALACE_JXVALUE_FORMOBILE : NSObject
{
@public
	int iFlowMingGValue;	//流年命宫的吉凶指数;
	int iFlowFuMuGValue;	//流年父母宫的吉凶指数;
	int iFlowFuDeGValue;	//流年福德宫的吉凶指数;
	int iFlowTianZaiGValue;	//流年田宅宫的吉凶指数;
	int iFlowGuanLuGValue;	//流年官禄宫的吉凶指数;
	int iFlowPuYiGValue;	//流年仆役宫的吉凶指数;
	int iFlowQianYiGValue;	//流年迁移宫的吉凶指数;
	int iFlowJiErGValue;	//流年疾厄宫的吉凶指数;
	int iFlowCaiBoGValue;	//流年财帛宫的吉凶指数;
	int iFlowZiNvGValue;	//流年子女宫的吉凶指数;
	int iFlowFuQiGValue;	//流年夫妻宫的吉凶指数;
	int iFlowXiongDiGValue;	//流年兄弟宫的吉凶指数;
	
}
@property(nonatomic)int iFlowMingGValue;
@property(nonatomic)int iFlowFuMuGValue;

@property(nonatomic)int iFlowFuDeGValue;
@property(nonatomic)int iFlowTianZaiGValue;
@property(nonatomic)int iFlowGuanLuGValue;
@property(nonatomic)int iFlowPuYiGValue;
@property(nonatomic)int iFlowQianYiGValue;
@property(nonatomic)int iFlowJiErGValue;
@property(nonatomic)int iFlowCaiBoGValue;
@property(nonatomic)int iFlowZiNvGValue;
@property(nonatomic)int iFlowFuQiGValue;
@property(nonatomic)int iFlowXiongDiGValue;

@end


// 大众版--流年信息(流年流月流日通用)
@interface TDZYS_FLOWYEAR_EXP : NSObject
{
@public
	// 农历以及对应公历时间标题--[例]农历2009【己丑】年 （公历 2009年2月4日 — 2010年2月12日）
	NSString* sTimeTitle;
	
	// 简约命理信息
	TDZYS_SIMPLE_FATE_INFO* dzFateInfo;
	
	// 下属各月或各天的吉凶指数
	NSMutableArray* vecChildJxValue;
	
	// 各项解释
	NSMutableArray* vecYunShiExp;
	
	// 各个宫吉凶指数
	TPALACE_JXVALUE_FORMOBILE* palaceValue;
	
}
@property(nonatomic, retain)NSString* sTimeTitle;
@property(nonatomic, retain)TDZYS_SIMPLE_FATE_INFO* dzFateInfo;
@property(nonatomic, retain)NSMutableArray* vecChildJxValue;
@property(nonatomic, retain)NSMutableArray* vecYunShiExp;
@property(nonatomic, retain)TPALACE_JXVALUE_FORMOBILE* palaceValue;

@end

// 流年信息扩展
@interface TZWYS_FLOWYEAR_EXT : NSObject
{
@public
	NSString* sDataTime;		//运势数据的时间
	
	TDZYS_FLOWYEAR_EXP*	tZwYsExp;	//大众版--流年信息(流年流月流日通用)
}
@property(nonatomic, retain) NSString* sDataTime;
@property(nonatomic, retain) TDZYS_FLOWYEAR_EXP*	tZwYsExp;
@end

//财富趋势信息扩展
@interface TLYSM_MONEYFORTUNE_EXT : NSObject
{
@public
	NSString* sDataTime;		//运势数据的时间
	
    float inforMingLi[5];
    NSMutableArray *vecShiZhu;      //八字命盘的四柱信息
    NSString *sMainStar;    //财富主星
    NSString *sBzCaifuInfo;     //八字财富信息
    
    //紫薇财帛宫信息
    NSString *sZwCaifuInfo;
    NSString *sZwCBGExp;
    
    //财富指数
    int iRichValue;     //财富指数
    int iGetMoneyPower; //抓钱能力
    NSString *sRichValueExp;
    
    //财富观念
    NSString *sCaifuAttitude;
    
    //财富类型
    NSString *sCaifuType;
    
    //财运趋势
    int iCurveBeginYear;
    NSMutableArray *vecUserCFValue;
    NSMutableArray *vecTrapForMoney;
    
    //求财与合作
    NSString *sCooperateFromBiJie;
    NSString *sShengXiaoGood;
    NSString *sShengXiaoBad;
    
    //求财建议
    NSString *sQiuCaiSuggest;
    NSString *sQiuCaiPossion;
    NSString *sLuckyColor;
}
@property(nonatomic, retain) NSString* sDataTime;
@property(nonatomic, retain) NSMutableArray *vecShiZhu;
@property(nonatomic, retain) NSString *sMainStar;
@property(nonatomic, retain) NSString *sBzCaifuInfo;
@property(nonatomic, retain) NSString *sZwCaifuInfo;
@property(nonatomic, retain) NSString *sZwCBGExp;
@property(nonatomic, retain) NSString *sRichValueExp;
@property(nonatomic, retain) NSString *sCaifuAttitude;
@property(nonatomic, retain) NSString *sCaifuType;
@property(nonatomic, retain) NSMutableArray *vecUserCFValue;
@property(nonatomic, retain) NSMutableArray *vecTrapForMoney;
@property(nonatomic, retain) NSString *sCooperateFromBiJie;
@property(nonatomic, retain) NSString *sShengXiaoGood;
@property(nonatomic, retain) NSString *sShengXiaoBad;
@property(nonatomic, retain) NSString *sQiuCaiSuggest;
@property(nonatomic, retain) NSString *sQiuCaiPossion;
@property(nonatomic, retain) NSString *sLuckyColor;
@end

//事业成长相关结构  2012.8.16--------------
//事业成长信息
@interface TSYYS : NSObject
{
@public
    //适合发展的方向
    NSString* sBestCareerType;
    //补充说明为何是最合适的职业
    NSString* sBestWordReason;
    //最适合的职业
    NSString* sBestWork;
    //其次适合的职业
    NSString* sBetterWork;
    //补充说明为何是其次适合的职业
    NSString* sBetterWorkReason;
    //事业总评
    NSString* sShiYeZongPing;
    //工作潜质
    NSString* sWorkQianZhi;
    //事业的建议，注意事项
    NSString* sZhuYiShiXiang;
    //官禄宫紫微主星
    NSString* sZiWeiMainStar;
    //十神力量数值（用来绘制十神雷达图)
    NSMutableArray* vecShiShenPower;
    //命主的四柱列表，依次是：年干支，月干支，日干支，时干支
    NSMutableArray* vecSiZhu;
    //事业比较顺利的年份列表（20~55岁跨度）
    NSMutableArray* vecWorkBestYear;
    //事业比较波折的年份列表（20~55岁跨度）
    NSMutableArray* vecWorkWorstYear;
}
@property(nonatomic, retain)NSString* sBestCareerType;
@property(nonatomic, retain)NSString* sBestWordReason;
@property(nonatomic, retain)NSString* sBestWork;
@property(nonatomic, retain)NSString* sBetterWork;
@property(nonatomic, retain)NSString* sBetterWorkReason;
@property(nonatomic, retain)NSString* sShiYeZongPing;
@property(nonatomic, retain)NSString* sWorkQianZhi;
@property(nonatomic, retain)NSString* sZhuYiShiXiang;
@property(nonatomic, retain)NSString* sZiWeiMainStar;
@property(nonatomic, retain)NSMutableArray* vecShiShenPower;
@property(nonatomic, retain)NSMutableArray* vecSiZhu;
@property(nonatomic, retain)NSMutableArray* vecWorkBestYear;
@property(nonatomic, retain)NSMutableArray* vecWorkWorstYear;

@end

// 事业成长扩展
@interface TSYYS_EXT : NSObject
{
@public
	NSString* sDataTime;   //运势数据的时间
	
	TSYYS*	tSyYs;	//事业成长
}
@property(nonatomic, retain) NSString* sDataTime;
@property(nonatomic, retain) TSYYS*	tSyYs;
@end
//事业成长相关结构  2012.8.16--------------




// 主要结果
@interface TMainResult : NSObject
{
@public
	NSString*   sMerit;		//优点
	NSString*   sWeak;		//缺点
	NSString*   sAdvice;		//建议	
}
@property(nonatomic, retain)NSString*   sMerit;	
@property(nonatomic, retain)NSString*   sWeak;	
@property(nonatomic, retain)NSString*   sAdvice;

@end

// 性格五类行分数
@interface  TNatureScore : NSObject
{
@public
	int			  iWitScore;	//智慧
	int			  iJustScore;	//正义
	int			  iKindScore;	//仁慈
	int			  iSteadyScore;	//稳重
	int			  iContactScore;//交际
}
@property(nonatomic)int			  iWitScore;	
@property(nonatomic)int			  iJustScore;	
@property(nonatomic)int			  iKindScore;	
@property(nonatomic)int			  iSteadyScore;	
@property(nonatomic)int			  iContactScore;

@end

// 人格特质结果
@interface TNatureResult : NSObject
{
@public
	TMainResult* strMainResult;             //主要结果（优缺点、建议）
	TNatureScore* strNatureScore;			  //五类行分数
	NSString* sZwFateInfo;			  //紫薇命理信息
	NSString* sBzFateInfo;			  //八字命理信息
}
@property(nonatomic, retain)TMainResult* strMainResult;  
@property(nonatomic, retain)TNatureScore* strNatureScore;
@property(nonatomic, retain)NSString* sZwFateInfo;		
@property(nonatomic, retain)NSString* sBzFateInfo;		

@end

//命局桃花
@interface TMingJuTaoHua : NSObject
{
@public
	NSString* sTaoHua;
	int iNum;
	NSString* sMean;
}
@property(nonatomic, retain)NSString* sTaoHua;
@property(nonatomic)int iNum;
@property(nonatomic, retain)NSString* sMean;

@end


//行运中的桃花
@interface TXingYunTaoHua : NSObject
{
@public
	NSMutableArray* veciYear;
	NSMutableArray* vecsTaoHua;
}
@property(nonatomic, retain)NSMutableArray* veciYear;
@property(nonatomic, retain)NSMutableArray* vecsTaoHua;

@end


@interface TBZMODEL_ZHU : NSObject
{
@public
	NSString* sGan;					//天干
	NSString* sZhi;					//地支
	NSMutableArray* vecsCangGan;		//藏干
	NSString* sGanShishen;				//天干十神
	NSMutableArray* vecsCGShiShen;	//藏干十神
	NSString* sWangShuai;
	NSString* sNaYin;
}
@property(nonatomic, retain)NSString* sGan;				
@property(nonatomic, retain)NSString* sZhi;				
@property(nonatomic, retain)NSMutableArray* vecsCangGan;
@property(nonatomic, retain)NSString* sGanShishen;		
@property(nonatomic, retain)NSMutableArray* vecsCGShiShen;
@property(nonatomic, retain)NSString* sWangShuai;
@property(nonatomic, retain)NSString* sNaYin;

@end


//爱情桃花结果结构体
@interface TLoveTaoHuaResult : NSObject
{
@public
	//内容页面
	
	//恋爱观
	NSString* lagResult;
	//命局桃花
	NSMutableArray* vecMingJuTaoHua;
	//行运桃花
	NSMutableArray* vecXingYunTaoHua;
	//相配生肖
	NSString* sXiangPei;
	//不合生肖
	NSString* sBuHe;
	//配偶来历
	NSString* sPeiOuSrc;
	//配偶位置
	NSString* sPeiOuPos;
	//配偶相貌
	NSString* sPeiOulooks;
	//配偶与家人关系
	NSString* sPeiOuRel;
	//综合分析
	NSString* sSynAna;
	
	//结婚时间段
	NSString* sMarryTime;
	//结婚旺的年份
	NSMutableArray* veciMarryWang;
	//结婚弱的年份
	NSMutableArray* veciMarryRuo;
	
	//侧边页面
	
	//紫微主星
	NSString* sMainStar;
	//紫微夫妻宫主星
	NSString* sFuQiStar;
	//八字命盘
	NSMutableArray* vecZhu;
}
@property(nonatomic, retain)NSString* lagResult;
@property(nonatomic, retain)NSMutableArray* vecMingJuTaoHua;
@property(nonatomic, retain)NSMutableArray* vecXingYunTaoHua;
@property(nonatomic, retain)NSString* sXiangPei;
@property(nonatomic, retain)NSString* sBuHe;
@property(nonatomic, retain)NSString* sPeiOuSrc;
@property(nonatomic, retain)NSString* sPeiOuPos;
@property(nonatomic, retain)NSString* sPeiOulooks;
@property(nonatomic, retain)NSString* sPeiOuRel;
@property(nonatomic, retain)NSString* sSynAna;
@property(nonatomic, retain)NSString* sMarryTime;
@property(nonatomic, retain)NSMutableArray* veciMarryWang;
@property(nonatomic, retain)NSMutableArray* veciMarryRuo;
@property(nonatomic, retain)NSString* sMainStar;
@property(nonatomic, retain)NSString* sFuQiStar;
@property(nonatomic, retain)NSMutableArray* vecZhu;

@end


// 姓名
@interface TPEP_NAME : NSObject
{
@public
	// 姓
	NSString* sFamilyName;
	// 名
	NSString* sSecondName;
}
@property(nonatomic, retain)NSString* sFamilyName;
@property(nonatomic, retain)NSString* sSecondName;

+ (TPEP_NAME*) pepnameFromString:(NSString*)name;

@end


//////////////////////////////////////////////////////////////////////////////
//    姓名测试共同数据定义
//////////////////////////////////////////////////////////////////////////////
// 字
@interface TCHARACTER : NSObject
{	
@public
	NSString* sCharacter;
	// 繁体字
	NSString* sTraditChar;
	// 拼音
	NSString* sPhonetic;
	// 五行
	NSString* sFiveElement;
	// 凶吉
	NSString* sGoodAndBad;
	// 笔画数-康熙笔画
	int iWordCount;
	// 笔画数-简体笔画
	int iWordCountJt;
	// 声调
	NSString* sTone;
	// 是否为常用字(常用字为1，非常用字为0)
	int iUseFrequency;
	// 是否为贬义词性的字（非贬义的为1，贬义的为0）
	int iWordKind;
	//字的释义
	NSString* sWordMean;
	//字的读音（包括拼音和声调）
	NSString* sPronunciation;
	//公司取名字义
	NSString*  sSimpleWordMean;
}
@property(nonatomic, retain)NSString* sCharacter;
@property(nonatomic, retain)NSString* sTraditChar;
@property(nonatomic, retain)NSString* sPhonetic;
@property(nonatomic, retain)NSString* sFiveElement;
@property(nonatomic, retain)NSString* sGoodAndBad;
@property(nonatomic)int iWordCount;
@property(nonatomic)int iWordCountJt;
@property(nonatomic, retain)NSString* sTone;
@property(nonatomic)int iUseFrequency;
@property(nonatomic)int iWordKind;
@property(nonatomic, retain)NSString* sWordMean;
@property(nonatomic, retain)NSString* sPronunciation;
@property(nonatomic, retain)NSString*  sSimpleWordMean;

@end


// 姓名康熙词典对应内容
@interface TPEP_KXNAME : NSObject 
{
@public
	// 姓
	NSMutableArray* aryChrKxFamilyName;
	// 名
	NSMutableArray* aryChrKxSecondName;
}
@property(nonatomic, retain)NSMutableArray* aryChrKxFamilyName;
@property(nonatomic, retain)NSMutableArray* aryChrKxSecondName;

@end


@interface TFIVE_PATTERN_NUMS : NSObject
{
@public
	// 天格
	int iTianPatternNum;
	// 地格
	int iDiPatternNum;
	// 人格
	int iRenPatternNum;
	// 外格
	int iWaiPatternNum;
	// 总格
	int iZongPatternNum;
	//天格的五行
	NSString* sTianPatternFiveE;
	//地格的五行
	NSString* sDiPatternFiveE;
	//人格的五行
	NSString* sRenPatternFiveE;
	//外格的五行
	NSString* sWaiPatternFiveE;
	//总格的五行
	NSString* sZongPatternFiveE;
}
@property(nonatomic)int iTianPatternNum;
@property(nonatomic)int iDiPatternNum;
@property(nonatomic)int iRenPatternNum;
@property(nonatomic)int iWaiPatternNum;
@property(nonatomic)int iZongPatternNum;
@property(nonatomic, retain)NSString* sTianPatternFiveE;
@property(nonatomic, retain)NSString* sDiPatternFiveE;
@property(nonatomic, retain)NSString* sRenPatternFiveE;
@property(nonatomic, retain)NSString* sWaiPatternFiveE;
@property(nonatomic, retain)NSString* sZongPatternFiveE;

@end



@interface TNT_PLATE_INFO : NSObject 
{
@public
	TPEP_KXNAME* pep_kxname;
	TFIVE_PATTERN_NUMS* five_pattern_nums;
}
@property(nonatomic, retain)TPEP_KXNAME* pep_kxname;
@property(nonatomic, retain)TFIVE_PATTERN_NUMS* five_pattern_nums;
@end


@interface TNT_EXPLAIN_INFO : NSObject
{
@public
	NSMutableArray* vecFivePatternExp;
	NSMutableArray* vecThreeTalentExp;
	NSMutableArray* vecMathHintExp;
	NSMutableArray* vecFiveElementsExp;
	NSString* strNameComments;
	double dNameScore;
	int    iThScore;
}
@property(nonatomic, retain)NSMutableArray* vecFivePatternExp;
@property(nonatomic, retain)NSMutableArray* vecThreeTalentExp;
@property(nonatomic, retain)NSMutableArray* vecMathHintExp;
@property(nonatomic, retain)NSMutableArray* vecFiveElementsExp;
@property(nonatomic, retain)NSString* strNameComments;
@property(nonatomic)double dNameScore;
@property(nonatomic)int    iThScore;

@end


// 姓名易心测试信息
enum EConsumeItem	//消费项目
{
	EConsumeItem_NameParseAll,			//姓名分析(综合)	
	EConsumeItem_NameParseWork,			//姓名分析(事业)	
	EConsumeItem_NameParseHealth,		//姓名分析(健康)	
	EConsumeItem_NameParseMarry,		//姓名分析(婚姻)	
	EConsumeItem_NameParseFateChar,		//姓名分析(命运特点)
	EConsumeItem_NameMatch,				//姓名匹配		
	EConsumeItem_LiuriyueYs,			//流月流日运势	
	EConsumeItem_LiunianYs,				//流年运势		
	EConsumeItem_ProLiuriyueYs,			//专业版流月流日运势
	EConsumeItem_ProLiunianYs,			//专业版流年运势	
    EConsumeItem_FortuneYs,			    //财富运势	
    EConsumeItem_CareerYs			    //事业成长	
};


@interface TNameYxTestInfo : NSObject
{
	// 性格评述
	NSString* sXgResult;
	// 事业评述
	NSString* sSyResult;
	// 健康评述
	NSString* sHyResult;
	// 婚姻评述
	NSString* sJkResult;
	// 命运评述
	NSString* sTdResult;
}
@property(nonatomic, retain)NSString* sXgResult;
@property(nonatomic, retain)NSString* sSyResult;
@property(nonatomic, retain)NSString* sHyResult;
@property(nonatomic, retain)NSString* sJkResult;
@property(nonatomic, retain)NSString* sTdResult;

@end

// 姓名易心传入参数格式

@interface TNameYxParam : NSObject
{
	// 姓名
	TPEP_NAME* pepName;
	// 性别
	NSString* sSex;
	// 消费项目
	NSString* sConsumeItem;	//综合：“all”； 性格：“性格”； 事业：“事业”； 健康：“健康”；婚姻：“婚姻”；命运特点：“命运特点”
}
@property(nonatomic, retain)TPEP_NAME* pepName;
@property(nonatomic, retain)NSString* sSex;
@property(nonatomic, retain)NSString* sConsumeItem;

@end


// 姓名易心测试信息
@interface TNAME_PD_RESULT : NSObject
{
	int xgnum;//性格指数
	int yfnum;//缘份指数
	int qdnum;//缺点关注指数
	int zsnum;//综合指数
	NSString* manxg;//男方性格
	NSString* womanxg;//女方性格
	NSString* manyf;//男方缘份匹配描述
	NSString* womanyf;//女方缘份匹配描述
	NSString* manfd;//男方相处时的互动关系
	NSString* womanfd;//女方相处时的互动关系
	NSString* manwt;//男方相处时的主要问题
	NSString* womanwt;//女方相处时的主要问题
	NSString* manjy;//男方相处时的建议指导
	NSString* womanjy;//女方相处时的建议指导
	NSString* zsstr;//综合评论
}
@property(nonatomic)int xgnum;
@property(nonatomic)int yfnum;
@property(nonatomic)int qdnum;
@property(nonatomic)int zsnum;
@property(nonatomic, retain)NSString* manxg;
@property(nonatomic, retain)NSString* womanxg;
@property(nonatomic, retain)NSString* manyf;
@property(nonatomic, retain)NSString* womanyf;
@property(nonatomic, retain)NSString* manfd;
@property(nonatomic, retain)NSString* womanfd;
@property(nonatomic, retain)NSString* manwt;
@property(nonatomic, retain)NSString* womanwt;
@property(nonatomic, retain)NSString* manjy;
@property(nonatomic, retain)NSString* womanjy;
@property(nonatomic, retain)NSString* zsstr;

@end

// 姓名易心传入参数格式
@interface TNAME_PD_PARAM : NSObject
{
	// 男姓
	NSString* sManXin;
	// 男名
	NSString* sManMing;
	// 女姓
	NSString* sWomanXin;
	// 女名
	NSString* sWomanMing;
}
@property(nonatomic, retain)NSString* sManXin;
@property(nonatomic, retain)NSString* sManMing;
@property(nonatomic, retain)NSString* sWomanXin;
@property(nonatomic, retain)NSString* sWomanMing;
@end



#pragma mark -
#pragma mark 余额和价格
@interface TProductInfo : NSObject
{
	NSString*	sUserName;			// 登录帐号
	float		fFreeMoneyBalance;	// 赠送币
	float		fMoneyBalance;		// 金币
	float		fTotalMoneyBalance;	// 总余额
	NSString*	sRuleId;			// 产品ID
	float		fProductMoney;		// 产品现价
	float		fOriginMoney;		// 产品原价
	BOOL		bEnough;			//余额足够
	float		fNeedMoney;			//需充值金额
}
@property(nonatomic, retain) NSString*	sUserName;
@property(nonatomic, retain) NSString*	sRuleId;
@property(nonatomic) float		fFreeMoneyBalance;
@property(nonatomic) float		fMoneyBalance;	
@property(nonatomic) float		fTotalMoneyBalance;
@property(nonatomic) float		fProductMoney;
@property(nonatomic) float		fOriginMoney;
@property(nonatomic) BOOL		bEnough;	
@property(nonatomic) float		fNeedMoney;	

@end

#pragma mark -
#pragma mark 检查支付结果
@interface TCheckPayResult : NSObject
{
	int httpCode;	//http code
	int respVal;	//1:已消费; 0：未消费
	NSString* sMsg;	//结果描述
}
@property(nonatomic) int httpCode;
@property(nonatomic) int respVal;
@property(nonatomic, retain) NSString* sMsg;

@end


#pragma mark -
#pragma mark 支付结果
@interface TPayResult : NSObject
{
	int httpCode;		//http code
	NSString* sMsg;		//结果描述
}
@property(nonatomic) int httpCode;
@property(nonatomic, retain) NSString* sMsg;


@end


#pragma mark -
#pragma mark 检查新版本
@interface TCheckVersionResult : NSObject
{
	NSString* sVerCode;		//版本代码
	NSString* sDownURL;		//下载链接
}

@property(nonatomic, retain) NSString* sVerCode;	
@property(nonatomic, retain) NSString* sDownURL;	

@end


#pragma mark -
#pragma mark 悬赏&建议——回复
@interface TBussSuggestAnswer : NSObject
{
	NSString* sQuesNO;	//问题
	NSString* sAnswer;	//回复
	NSString* sAskTime;	//提问时间
	NSString* sAnsTime;	//回复时间
	int		flag;		//0：未回答; 1：已回答
}
@property(nonatomic, retain) NSString* sQuesNO;
@property(nonatomic, retain) NSString* sAnswer;
@property(nonatomic, retain) NSString* sAskTime;
@property(nonatomic, retain) NSString* sAnsTime;
@property(nonatomic, assign) int flag;	

@end


#pragma mark -
#pragma mark 软件推荐信息
// 推荐软件信息
@interface AppInfo : NSObject
{
	NSInteger softID, softVersion;
    NSInteger appID, appVersion;
	NSString *appName;
    
    NSString *typeName;
    NSInteger typeSort;
    
    NSInteger softIdVersion, softSort, optFlag, previewPathFlag, icoPathFlag;
    
	NSInteger softInfoId, softVersion1, softInfoVersion;
	NSString *softName, *company, *previewPath, *packageName, *icoPath, *description, *license, *softUrl, *bundleIdentifier;
    NSNumber* rating;
    
}

@property(nonatomic, assign) NSInteger softID, softVersion;
@property(nonatomic, assign) NSInteger appID, appVersion;

@property(nonatomic, retain) NSString *appName;
@property(nonatomic, retain) NSString *typeName;
@property(nonatomic, assign) NSInteger typeSort;

@property(nonatomic, assign) NSInteger softIdVersion, softSort, optFlag, previewPathFlag, icoPathFlag;
@property(nonatomic, assign) NSInteger softInfoId, softVersion1, softInfoVersion;
@property(nonatomic, retain) NSString *softName, *company, *previewPath, *packageName, *icoPath, *description, *license, *softUrl, *bundleIdentifier;

@property(nonatomic, retain) NSNumber* rating;

@end


#pragma mark -
#pragma mark 软件推荐表内容
// 推荐软件信息


@interface AppInfoList : NSObject
{
    int  appVersion;
    NSString*  baseHost;
    NSMutableArray *aryAppInfo;
}

@property (nonatomic, assign) int appVersion;
@property (nonatomic, retain)  NSString*  baseHost;
@property (nonatomic, retain)   NSMutableArray *aryAppInfo;


@end


/*
@interface WeatherNow : NSObject
{
    NSString  *city, *cityid, *temp, *WD, *WS, *SD, *WSE, *time;
}

@property (nonatomic,retain)  NSString *city, *cityid, *temp, *WD, *WS, *SD, *WSE, *time;

@end
*/

//update 2012.8.27
@interface WeatherNow : NSObject
{
    NSString  *nowweather, *nowimg, *temp, *sd, *wd, *ws, *uv, *sysdate;
}

@property (nonatomic,retain)  NSString *nowweather, *nowimg, *temp, *sd, *wd, *ws, *uv, *sysdate;

@end

//update 2012.8.27
/*
@interface WeatherWeek : NSObject
{
    NSString *city, *city_en, *date_y, *date, *week, *fchh, *cityid;
    NSString *temp1, *temp2, *temp3, *temp4, *temp5, *temp6;
    NSString *weather1, *weather2, *weather3, *weather4, *weather5, *weather6;
    NSString *img_title1, *img_title2, *img_title3, *img_title4, *img_title5, *img_title6;
    NSString *img_title7, *img_title8, *img_title9, *img_title10, *img_title11, *img_title12;
    NSString *img1, *img2, *img3, *img4, *img5, *img6, *img7, *img8, *img9, *img10, *img11, *img12;
    NSString *wind1, *wind2, *wind3, *wind4, *wind5, *wind6; 
    NSString *index_uv, *sour;
 

}

@property (nonatomic, retain) NSString *city, *city_en, *date_y, *date, *week, *fchh, *cityid;
@property (nonatomic, retain) NSString *temp1, *temp2, *temp3, *temp4, *temp5, *temp6;
@property (nonatomic, retain) NSString *weather1, *weather2, *weather3, *weather4, *weather5, *weather6;
@property (nonatomic, retain) NSString *img_title1, *img_title2, *img_title3, *img_title4, *img_title5, *img_title6;
@property (nonatomic, retain) NSString *img_title7, *img_title8, *img_title9, *img_title10, *img_title11, *img_title12;
@property (nonatomic, retain) NSString *img1, *img2, *img3, *img4, *img5, *img6, *img7, *img8, *img9, *img10, *img11, *img12;
@property (nonatomic, retain) NSString *wind1, *wind2, *wind3, *wind4, *wind5, *wind6; 
@property (nonatomic, retain) NSString *index_uv, *sour;

@end
*/
@interface WeatherDay : NSObject
{
    NSString *ddate, *dayweather, *dayimg, *nightweather, *nightimg, *hightemp, *lowtemp;
}

@property (nonatomic, retain) NSString *ddate, *dayweather, *dayimg, *nightweather, *nightimg, *hightemp, *lowtemp;

@end

@interface WeatherWeek : NSObject
{
    NSString *sysdate;
    NSMutableArray* vecDay;
}

@property (nonatomic, retain) NSString *sysdate;
@property (nonatomic, retain) NSMutableArray* vecDay;

@end


/*
@interface WeatherAlarm : NSObject
{
    NSString *weather, *grade, *color, *content, *bz, *fy, *fbtime, *imgurl;
}

@property (nonatomic,retain) NSString *weather, *grade, *color, *content, *bz, *fy, *fbtime, *imgurl;

@end
*/

@interface WeatherAlarm : NSObject
{
    NSString *weatherno,*weather, *grade, *color, *content, *bz, *fy, *fbtime, *imgurl, *sysdate;
}

@property (nonatomic,retain) NSString *weatherno,*weather, *grade, *color, *content, *bz, *fy, *fbtime, *imgurl, *sysdate;

@end
 
@interface WeatherInfo : NSObject
{

    NSString* sCityCode;
    NSString* sDate;
    NSTimeInterval rTs;
   
    WeatherNow* now;
    WeatherWeek* week;    
    WeatherAlarm* alarm;
}

@property (nonatomic, assign)  NSTimeInterval rTs;
@property (nonatomic, retain) NSString* sCityCode;
@property (nonatomic, retain) NSString* sDate;

@property (nonatomic, retain) WeatherNow* now;
@property (nonatomic, retain) WeatherWeek* week;
@property (nonatomic, retain) WeatherAlarm* alarm;

+ (WeatherInfo*) weatherWithJson:(NSString*)json;

@end

//账号余额和产品价格
@interface UserAndPriceInfo : NSObject
{
    CGFloat fFreeMoneyBalance;
	CGFloat fMoneyBalance;
	CGFloat fTotalMoneyBalance;
    CGFloat fProductMoney;
    CGFloat fOriginMoney;
    BOOL bEnough;
    CGFloat fNeedMoney;
}

@property (nonatomic, assign) CGFloat fFreeMoneyBalance;
@property (nonatomic, assign) CGFloat fMoneyBalance;
@property (nonatomic, assign) CGFloat fTotalMoneyBalance;
@property (nonatomic, assign) CGFloat fProductMoney;
@property (nonatomic, assign) CGFloat fOriginMoney;
@property (nonatomic, assign) BOOL bEnough;
@property (nonatomic, assign) CGFloat fNeedMoney;

+ (UserAndPriceInfo*) userAndPriceWithJson:(NSString*)json;

@end

typedef enum {
    USER_APP_TYPE_BOUGHT,       //以开通应用
    USER_APP_TYPE_NOMINATE   //推荐应用
}UserAppType;

@interface JYEXUserAppInfo : NSObject {
@private
    NSString *sUserName;
    NSString *sAppCode;
    NSString *sAppName;
    int iAppID;
    int iAppType;
}

@property (nonatomic, retain)  NSString *sUserName;
@property (nonatomic, retain)  NSString *sAppCode;
@property (nonatomic, retain)  NSString *sAppName;
@property (nonatomic, assign)  int iAppID;
@property (nonatomic, assign)  int iAppType;
@end

