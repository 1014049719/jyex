//
//  DbMngDataDef.h
//  Astro
//
//  Created by root on 11-12-6.
//  Copyright 2011 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussDataDef.h"


//修改了笔记数据的消息通知
#define NOTIFICATION_UPDATE_NOTE @"Notification_Update_Note"
//同步结束
#define NOTIFICATION_SYNC_FINISH @"Notification_Sync_Finish"
//更新笔记星级
#define NOTIFICATION_UPDATE_NOTE_STAR @"Notification_Update_Star"

//更新了栏目消息数
#define NOTIFICATION_UPDATE_LANMU_MSGNUM @"Notification_Update_Lanmu_Msgnum"

//登录成功
#define NOTIFICATION_LOGIN_SUCCESS @"Notification_Login_Success"

//更新上传日志数目
#define NOTIFICATION_UPDATE_UPLOADNUM @"Notification_Update_Uploadnum"

//刷新页面内容
#define NOTIFICATION_REFRESH_CONTENT @"Notification_refresh_content"

//更新头像的消息通知
#define NOTIFICATION_UPDATE_AVATAR @"NOTIFICATION_UPDATE_AVATAR"


enum EDataBaseType
{
	EDbTypeNull	=	0,
	EDbTypeCustom1,			//custom 1
	EDbTypeCustom2,			//custom 2
	EDbTypeCustom3,			//custom 3
	EDbTypeAstroCommon,		//各用户共有数据
	EDbTypeUserLocal,		//用户私有数据
    EDbType91Note           //91笔记
};




#pragma mark 本地数据表结构 

#pragma mark 天气城市设置
@interface TCityWeather : NSObject
{
@public
	NSString* sCityCode;		//城市代码
	NSString* sCityName;		//城市
	int iSort;					//顺序
}
@property(nonatomic, retain)NSString* sCityCode;	
@property(nonatomic, retain)NSString* sCityName;	
@property(nonatomic)int iSort;				
		

@end
 

#pragma mark -
#pragma mark 黄历信息-本地
@interface THuangLi : NSObject
{ 
	NSString *HuangTS;		//胎神占方
	NSString *HuangJS;		//吉神宜趋
	NSString *HuangY;		//宜
	NSString *HuangJ;		//忌
	NSString *HuangC;		//凶神宜忌
} 

@property (nonatomic, retain) NSString *HuangTS;
@property (nonatomic, retain) NSString *HuangJS;
@property (nonatomic, retain) NSString *HuangY;
@property (nonatomic, retain) NSString *HuangJ;
@property (nonatomic, retain) NSString *HuangC;

@end


#pragma mark -
#pragma mark 黄历查询结果
enum ESearchHuangLiOption
{
	ESearchHuangLi_Yi=1,	//宜
	ESearchHuangLi_Ji	//忌
};

@interface THuangLiSearchResult : NSObject
{
	TDateInfo*	tDate;		//找到匹配项的相应日期（公历）
	NSString*	strYi;		//宜
	NSString*	strJi;		//忌
	NSString*	strChong;	//冲
}
@property (nonatomic, retain) TDateInfo* tDate;	
@property (nonatomic, retain) NSString*	strYi;
@property (nonatomic, retain) NSString*	strJi;
@property (nonatomic, retain) NSString*	strChong;

//根据查询结果中的日期，返回相应公历、农历的显示字符串
+(NSString*) getResultGlDateDesc:(TDateInfo*) date;
+(NSString*) getResultNlDateDesc:(TDateInfo*) date;

@end


#pragma mark -
#pragma mark 用户本地缓存数据
@interface TUserLocalData : NSObject
{ 
	int iID;				//id
	NSString *sGroupKey;	//数据主类型
	NSString *sGroupItem;	//子类型
	int iItemNo;			//子类型-编号
	NSString *sItemCode;	//编码
	NSString *sItemValue;	//值
	NSString* sItemNote;	//注释
	NSString* sItemText;	//文本内容
} 

@property (nonatomic, retain) NSString *sGroupKey;
@property (nonatomic, retain) NSString *sGroupItem;
@property (nonatomic, retain) NSString *sItemCode;
@property (nonatomic, retain) NSString *sItemValue;
@property (nonatomic, retain) NSString *sItemNote;
@property (nonatomic, retain) NSString *sItemText;
@property (nonatomic) int iID;
@property (nonatomic) int iItemNo;

@end


#pragma mark -
#pragma mark 天气城市管理
enum ECityDataType
{
	ECityType_None,	
	ECityType_Prov,	//省份
	ECityType_Area,	//地区
	ECityType_City,	//城市
};

@interface TCityData : NSObject
{
	enum ECityDataType	iType;	//数据类型
	NSString* sID;		//代码
	NSString* sName;	//名称
}
@property(nonatomic) enum ECityDataType	iType;
@property(nonatomic, retain)NSString* sID;
@property(nonatomic, retain)NSString* sName;


@end

@interface TCityDataDetail : NSObject
{
	TCityData* datCity;
	TCityData* datProv;
}
@property(nonatomic, retain) TCityData* datCity;
@property(nonatomic, retain) TCityData* datProv;

@end



#pragma mark -
#pragma mark localdata表 本地缓存信息定义
//主类型
#define LDGT_SYSTEM		@"system"		//系统
#define LDGT_USER		@"user"			//用户
#define	LDGT_YUNSHI		@"yunshi"		//运势
#define LDGT_HUANGLI	@"huangli"		//黄历
#define LDGT_WEATHER	@"weather"		//天气
#define LDGT_CHARACTER	@"character"	//人格特质
#define LDGT_LOVEFLOWER @"loveflower"	//爱情桃花
#define LDGT_NAMEPARSE	@"nameparse"	//姓名分析
#define LDGT_NAMEMATCH	@"namematch"	//姓名匹配
#define LDGT_NAMETEST	@"nametest"		//姓名测试
#define LDGT_BLOG		@"blog"			//微博
#define LDGT_BLOGSHARE	@"blogshare"	//微博分享
#define LDGT_SYNVER		@"synver"		//同步

//子类型

//系统
//用户
//运势
//#define LDGT_YUNSHI_LIURI			@"liuri"		//一句话流日运势
//#define LDGT_YUNSHI_TODAY			@"today"		//今日运势
//#define LDGT_YUNSHI_THISMONTH		@"thismonth"	//本月运势
//#define LDGT_YUNSHI_THISYEAR		@"thisyear"		//今年运势

//黄历
//天气
#define LDGT_WEATHER_IM				@"immed"		//即时天气
#define LDGT_WEATHER_WEEK			@"week"			//周天气

//姓名分析
#define LDGT_NAMEPARSE_PLATE		@"plate"		//排盘
#define LDGT_NAMEPARSE_EXPLAIN		@"explain"		//分析

//姓名测试
#define LDGT_NAMETEST_ALL			@"综合"			//综合
#define LDGT_NAMETEST_XG			@"性格"			//性格
#define LDGT_NAMETEST_SY			@"事业"			//事业
#define LDGT_NAMETEST_JK			@"健康"			//健康
#define LDGT_NAMETEST_HY			@"婚姻"			//婚姻
#define LDGT_NAMETEST_MYTD			@"命运特点"		//命运特点

#pragma mark -
#pragma mark 运势缓存表信息定义
//运势类型
enum EYunshiType
{
	EYunshiTypeNone = 0,		//无
	
	EYunshiTypeLiuri = 1,		//流日
	EYunshiTypeLiuyue,			//流月
	EYunshiTypeLiunian,			//流年
	
	EYunshiTypeDay = 8,			//日
	EYunshiTypeMonth,			//月
	EYunshiTypeYear,			//年
    
    EMoneyFortune,      //财富
    EYunshiTypeCareer,          //事业成长
};


#pragma mark -
#pragma mark 速配业务数据结构定义

#pragma mark -
#pragma mark 星座匹配
@interface TXingZuoMatch : NSObject
{
	NSString* sManXingzuo;		//男方星座
	NSString* sWomanXingzuo;	//女方星座
	int iScore;					//得分
	NSString* sPropotion;		//比值
	NSString* sExplain;			//解释
	NSString* sAttention;		//注意点
}
@property(nonatomic, retain) NSString* sManXingzuo;	
@property(nonatomic, retain) NSString* sWomanXingzuo;
@property(nonatomic, retain) NSString* sPropotion;	
@property(nonatomic, retain) NSString* sExplain;		
@property(nonatomic, retain) NSString* sAttention;	
@property(nonatomic) int iScore;				

@end


#pragma mark -
#pragma mark 生肖匹配
@interface TShengxiaoMatch : NSObject
{
	int iLevel;					//匹配度
	NSString* sTitle;			//匹配项
	NSString* sContent;			//内容
}
@property(nonatomic, retain) NSString* sTitle;		
@property(nonatomic, retain) NSString* sContent;			
@property(nonatomic) int iLevel;					

@end


#pragma mark -
#pragma mark 生日匹配

@interface TBirthdayMatch : NSObject
{

	int nLevel;					// 匹配的结果星级
	NSString* strExplain;		// 匹配结果的解释
	NSString* strManBirthExp;	// 男性生日密码的解释
	NSString* strWomanBirthExp;	// 女性生日密码的解释
}
@property(nonatomic) int nLevel;				
@property(nonatomic, retain) NSString* strExplain;	
@property(nonatomic, retain) NSString* strManBirthExp;
@property(nonatomic, retain) NSString* strWomanBirthExp;

@end


#pragma mark -
#pragma mark 号码测试-手机号

@interface TTelephoneJiXiong : NSObject
{
	NSString*  strPctemp;	
	NSString*  strTelResult;	
}
@property(nonatomic, retain) NSString* strPctemp;	
@property(nonatomic, retain) NSString* strTelResult;	

@end



#pragma mark -
#pragma mark 抽签和掷杯
enum ERollCupResult
{
	ERollCup_None,	//无
	ERollCup_SB,	//圣杯
	ERollCup_XB,	//笑杯
	ERollCup_YB		//阴杯
};


@interface TCastLots : NSObject
{
	NSInteger	iRandNum;		//签号
	NSString* 	sNumber;		//签号
	NSString* 	sStandOrFall;	//上、中、下签
	NSString*	sStory;			//典故TITLE
	NSString*	sPoetry;		//诗文
	NSString*	sParaphrase;	//卦相
	NSString*	sResult;			//解签
	NSString*	sParticularStory;	//典故
}

@property(nonatomic) NSInteger	iRandNum;		
@property(nonatomic, retain) NSString* 	sNumber;		
@property(nonatomic, retain) NSString* 	sStandOrFall;	
@property(nonatomic, retain) NSString*	sStory;			
@property(nonatomic, retain) NSString*	sPoetry;		
@property(nonatomic, retain) NSString*	sParaphrase;	
@property(nonatomic, retain) NSString*	sResult;		
@property(nonatomic, retain) NSString*	sParticularStory;

@end


#pragma mark -
#pragma mark 周公解梦
@interface TParseDream : NSObject
{
	NSString*	sSort;	//分类
	NSString*	sDream;	//梦境
	NSString*	sResult; //解梦
}

@property(nonatomic, retain) NSString*	sSort;	
@property(nonatomic, retain) NSString*	sDream;		
@property(nonatomic, retain) NSString*	sResult;

@end


#pragma mark -
#pragma mark 悬赏&建议-问题
@interface TSuggestItem : NSObject
{
	NSString*	sQuestNO;	//问题GUID
	NSString*	sQuestion;	//问题内容
	NSString*	sAskTime;	//提问时间
	int		iFlag;			//0:未回答 1：已回答
}

@property(nonatomic, retain) NSString*	sQuestNO;
@property(nonatomic, retain) NSString*	sQuestion;	
@property(nonatomic, retain) NSString*	sAskTime;
@property(nonatomic, assign) int iFlag;

@end


#pragma mark -
#pragma mark 悬赏&建议-回复
@interface TAnswerItem : NSObject
{
	NSString*	sQuestNO;	//问题GUID
	NSString*	sAnswer;	//回复内容
	NSString*	sAnsTime;	//回复时间
}

@property(nonatomic, retain) NSString*	sQuestNO;
@property(nonatomic, retain) NSString*	sAnswer;	
@property(nonatomic, retain) NSString*	sAnsTime;

@end


#pragma mark -
#pragma mark 悬赏&建议－问题&回复
@interface TQuestionAnswer : NSObject
{
	TSuggestItem* itemQuest;	//问题
	NSMutableArray* aryAnswer;	//回复
}

@property(nonatomic, retain) TSuggestItem* itemQuest;
@property(nonatomic, retain) NSMutableArray* aryAnswer;	

@end

//-----------------------------------------------------------
//add 2012.10.23
//NoteBook的结构
//同步活动状态
enum EM_SYNC_STATUS
{
    SS_NONE,
    SS_DOWN_CATE,           //下载目录
    SS_DOWN_NEWEST,         //下载最新
    SS_DOWN_BY_DIR,         //文件夹同步
    SS_DOWN_SINGEL_NOTE,    //单条笔记
    SS_DOWN_SEARCH,         //下载搜索结果

    SS_UPLOAD_NOTE_LIST,    //上传
};

// 共享类型
typedef enum tagShareType
{
    SHARE_CATE_TO_USER = 0,             // 共享文件夹给用户
    SHARE_CATE_TO_GROUP,                // 共享文件夹给群组
    SHARE_NOTE_TO_USER,                 // 共享笔记给用户
    SHARE_NOTE_TO_GROUP,                // 共享笔记给群组
} ENUM_SHARE_TYPE;

// 共享权限
typedef enum tagShareRights
{
    SHARE_READONLY = 0,                 // 只读
    SHARE_WRITE,                       // 可写
} ENUM_SHARE_RIGHTS;

// Note类型
typedef enum tagNOTE_TYPE
{
    NOTE_PIC = 0,                       // 图形note
    NOTE_WEB,                           // 网页note
    NOTE_CUST_DRAW,                     // 随手画类型
    NOTE_CUST_WRITE,                    // 随手写类型
    NOTE_FLASH,                         // FLASH类型
    NOTE_VIDEO,                         // 视频类型
    NOTE_AUDIO,                         // 音频类型
    NOTE_CATE,                          // 目录类型
    NOTE_WORD,	
    NOTE_EXCEL,
    NOTE_PDF,
    NOTE_EXE,
    NOTE_TXT,
    NOTE_RTF,
    NOTE_POWERPOINT,
    NOTE_COMPRESS,
    NOTE_CHM,
    NOTE_VISIO,
    NOTE_UNKNOWN = 49 ,                      // 未知类型
}ENUM_NOTE_TYPE, EM_NOTE_TYPE;

//Note Item类型定义
typedef enum tagITEM_TYPE
{
    NI_NOTEINFO = 50,                   // NOTE信息
    NI_HTML,                            // HTML文本 .htm .html
    NI_TEXT,                            // Text类型文本  txt
    NI_PIC,                             // 图片类型  jpg
    NI_FLASH,                           // Flash文件 swf
    NI_VIDEO ,                           // 视频 wmv
    NI_AUDIO,                            //wav
    NI_WORD,                              //doc
    NI_EXCEL,                             //xls
    NI_PDF,                               //pdf
    NI_EXE,                               //exe
    NI_TXT,                               //
    NI_RTF,                               //RTF
    NI_POWERPOINT,                       //ppt
    NI_COMPRESS,                         //rar
    NI_CHM,                              //chm
    NI_VISIO,                            //vsd
    NI_CSS,                             // 样式表 .css
    NI_JS,                              // JavaScript .js
    NI_UNKNOWN = 99,                    // 未知类型 
    NI_INKDATA							//随手画数据文件
}ENUM_ITEM_TYPE;


typedef enum
{
    TT_CREATED,                         // 创建时间
    TT_MODIFIED                         // 最近修改时间
}EM_TIME_TYPE;


typedef enum tagTIME_DIRECT             // 时间的比较方向
{
    TD_SINCE,                           // since
    TD_BEFORE                           // before
}EM_TIME_DIRECT;

typedef enum EM_TIME                    // 比较时间的坐标
{
    ET_TODAY,                           // Today
    ET_YESTERDAY,                       // Yesterday
    ET_THIS_WEEK,                       // This Week
    ET_LAST_WEEK,                       // Last Week
    ET_THIS_MONTH,                      // This Month
    ET_LAST_MONTH,                      // Lath Month
    ET_THIS_YEAR,                       // This Year
    ET_LAST_YEAR                        // Lath Year
}EM_TIME_COORD;

// 全文搜索模式
typedef enum tagSEARCH_TYPE
{
    ST_CONTENT,                         // 搜索内容
    ST_TITLE,                           // 搜索标题
    ST_DATE,                            // 搜索日期
    ST_ALL,                             // 全部类型
} EM_SEARCH_TYPE;

typedef enum tagREMARK_TYPE
{
    RT_REMARK = 0,                      // 批注
    RT_SRC_IMG,							// 图片ITEM原图
} EM_REMARK_TYPE;


typedef enum tagCONFLICT_POLICY         // 冲突处理策略
{
    CP_USE_LOCAL = 0,                   // 强制使用本地文件
    CP_USE_SERVER,                      // 强制使用服务器文件
    CP_USE_NEWER                        // 使用较新的文件
} EM_CONFLICT_POLICY;


enum CHANGE_PAGE
{
	NO_CHANGE=0,
	PRE_PAGE,
	NEXT_PAGE,
	MORE_ITEM,	//显示“更多”的ITEM
};


// 删除状态 (delete_state)
typedef enum tagDELETE_STATE
{
    DELETESTATE_NODELETE = 0,                   //没有删除(正常状态)
    DELETESTATE_DELETE,                         // 已经删除
    DELETESTATE_IN_TRASH                      // 被放入回收站
}EM_DELETE_STATE;

//编辑状态
typedef enum tagEDIT_STATE
{
    EDITSTATE_NOEDIT = 0,               //没有编辑
    EDITSTATE_EDITED,                    //已经编辑（需同步）
    EDITSTATE_UPLOAD_FAILURE,            //上传失败
    
}EM_EDIT_STATE;

//冲突状态
typedef enum tagCONFLICT_STATE
{
    CONFLICTSTATE_NOCONFLICT = 0,               //正常，没有冲突
    CONFLICTSTATE_CONFLICT                      //冲突
    
}EM_CONFLICT_STATE;

//同步状态 (客户端没有用到)
typedef enum tagSYNC_STATE  
{
    SYNCSTATE_NOSYNC = 0,               //正常，没在同步
    SYNCSTATE_SYNCING                   //正在同步
    
}EM_SYNC_STATE;

//是否需要上传(客户端没有用到) 
typedef enum tagNEED_UPLOAD   
{
    DoNotUpload = 0,                    // 不上传
    CanUpload = 1,                      // 可以上传（根据父文件夹来决定）
    MustUpload = 2,                     // 必须上传
} EM_NEED_UPLOAD;

//加密标识
typedef enum tagENCRYPT_FLAG            // 加密标识
{
    EF_NOT_ENCRYPTED = 0,               // 未加密
    EF_NORMAL_ENCRYPTED,                // 弱加密
    EF_HIGH_ENCRYPTED                   // 强加密
} EM_ENCRYPT_FLAG;

//目录图标
typedef enum tagCATALOG_ICON
{
    ICON_DEFAULT=1001,       //默认
    ICON_WORK = 1002,        //工作
    ICON_TODOLIST = 1003,    //to-do list
    ICON_AFFLATUS = 1004,    //灵感
    ICON_PERSONAL = 1005     //个人笔记
} EM_CATALOG_ICON;

//目录颜色
typedef enum tagCATALOG_COLOR
{
    COLOR_1 =2001,      //褐色
    COLOR_2 = 2002,     //紫色
    COLOR_3 = 2003,     //浅蓝色
    COLOR_4 = 2004,    //蓝色
    COLOR_5 = 2005     //深蓝色
} EM_CATALOG_COLOR;

//目录的手机标志(mobile_flag)  //手机标志 1 手机未整理 2 购物 3 TO DOLIST 4 灵感 5 随便 6工作 7日志手机用户自己创建统一使用1000
typedef enum tagMOBILE_FLAG
{
    MOBILEFLAG_1=1,
    MOBILEFLAG_2=2,
    MOBILEFLAG_3=3,
    MOBILEFLAG_4=4,
    MOBILEFLAG_5=5,
    MOBILEFLAG_6=6,
    MOBILEFLAG_7=7,
    MOBILEFLAG_USER_CREATE=1000
} EM_MOBILE_FLAG;


//目录是否需要同步标志 (客户端自己用)
typedef enum tagSYNC_FLAG  
{
    SYNCFLAG_NEED = 0,               //需要同步
    SYNCFLAG_NONEED                  //不需要同步
    
}EM_SYNC_FLAG;

//是否需要下载标志(客户端自己使用，needownlord字段)
typedef enum tagDOWNLOAD_FLAG  
{
    DOWNLOAD_NONEED = 0,               //不需要同步
    DOWNLOAD_NEED                      //需要同步
    
}EM_DOWNLOAD_FLAG;



//共通结构头, 每个需要同步的结构，如NOTE、ITEM内部都会包含一个此结构
#pragma mark -
#pragma mark 共通结构头
@interface TRecHead : NSObject
{
    int   nUserID;                   // 用户编号
    int   nCurrVerID;                 // 当前版本号 (服务端给)
    int   nCreateVerID;              // 创建版本号  (服务端给)
    
    NSString*  strCreateTime;           // 创建时间
    NSString*  strModTime;              // 修改时间
    
    int     nDelState;                  // 删除状态
    int     nEditState;                 // 编辑状态
    int     nConflictState;             // 冲突状态
    int     nSyncState;                 // 同步状态(本地不用)
    int     nNeedUpload;                // 是否上传(本地不用)
};

@property (nonatomic,assign) int  nUserID;
@property (nonatomic,assign) int  nCurrVerID;
@property (nonatomic,assign) int   nCreateVerID;

@property (nonatomic,retain) NSString*  strCreateTime;
@property (nonatomic,retain) NSString*  strModTime;

@property (nonatomic,assign) int     nDelState;
@property (nonatomic,assign) int     nEditState;
@property (nonatomic,assign) int     nConflictState;
@property (nonatomic,assign) int     nSyncState;
@property (nonatomic,assign) int     nNeedUpload;

@end

//  目录信息表
#pragma mark -
#pragma mark 目录信息表
@interface TCateInfo : NSObject
{
    TRecHead* tHead;    //记录头
    NSString* strCatalogIdGuid;   // 目录编号;
    NSString* strCatalogBelongToGuid;  //当前目录上一级目录
    NSString* strCatalogPaht1Guid; //第一级目录位置
    NSString* strCatalogPaht2Guid; //第二级目录位置
    NSString* strCatalogPaht3Guid; //第三级目录位置
    NSString* strCatalogPaht4Guid; //第四级目录位置
    NSString* strCatalogPaht5Guid; //第五级目录位置
    NSString* strCatalogPaht6Guid; //第六级目录位置
 
    int  nOrder;                     // 排列位置(越小越靠前)
    NSString* strCatalogName;        // 目录名称
    
    int	 nEncryptFlag;			// 加密标识(是否加密)
	NSString* strVerifyData;		// 验证密码
    
    int  nCatalogType;   //目录类型  (以下为新增的)
    int  nCatalogColor;   //目录颜色
    int  nCatalogIcon;   //目录图标
    int  nMobileFlag;    //手机目录标志
    int  nNoteCount;     //笔记数量
    
    int  nIsRoot;        // 是否是根目录 （服务端没有，这个还需要吗）
    
    int  nSyncFlag;      //该目录是否需要同步(本地保存的标志，不上传到服务端) //add 2012.11.8
    
    //数据库中没有的。
    int  nCurdayNoteCount;  //当前有更新的记录数  //add 2012.11.20
    
}

@property (nonatomic,retain) TRecHead* tHead;
@property (nonatomic,retain) NSString* strCatalogIdGuid;
@property (nonatomic,retain) NSString* strCatalogBelongToGuid;
@property (nonatomic,retain) NSString* strCatalogPaht1Guid;
@property (nonatomic,retain) NSString* strCatalogPaht2Guid;
@property (nonatomic,retain) NSString* strCatalogPaht3Guid;
@property (nonatomic,retain) NSString* strCatalogPaht4Guid;
@property (nonatomic,retain) NSString* strCatalogPaht5Guid;
@property (nonatomic,retain) NSString* strCatalogPaht6Guid;

@property (nonatomic,assign) int  nOrder;
@property (nonatomic,retain) NSString* strCatalogName;

@property (nonatomic,assign) int	 nEncryptFlag;
@property (nonatomic,retain) NSString* strVerifyData;

@property (nonatomic,assign) int  nCatalogType;
@property (nonatomic,assign) int  nCatalogColor;
@property (nonatomic,assign) int  nCatalogIcon;
@property (nonatomic,assign) int  nMobileFlag;
@property (nonatomic,assign) int  nNoteCount;

@property (nonatomic,assign) int  nIsRoot;
@property (nonatomic,assign) int  nSyncFlag;

@property (nonatomic,assign) int  nCurdayNoteCount;

@end

//笔记信息表
#pragma mark -
#pragma mark 笔记信息表
@interface TNoteInfo : NSObject
{
    TRecHead* tHead;    //记录头
    NSString* strCatalogIdGuid;   // 目录编号(笔记存放的目录);
    NSString* strNoteIdGuid;   //笔记编号

    NSString* strNoteTitle;              // NOTE的名称    
    int   nNoteType;                     // NOTE的类型  0:照片  1:日志 2014.4.8
    int   nNoteSize;                     // NOTE包含的所有ITEM总长度，不包含自身
    
    NSString* strFilePath;               //文件保存路径
    NSString* strFileExt;                //文件扩展名
    NSString* strEditLocation;           //2014.4.8， 保存上传失败返回的错误信息.
    NSString* strNoteSrc;                //2014.4.8 ，上传照片时，保持相册的id。
    
    NSString* strFirstItemGuid;              //第一条item(当NOTE自身含有文件时，此GUID对应存储实际文件内容的ITEM)。
    
    int  nShareMode;                 // 共享模式，0不共享，1共享给好友，2共享给所有人（备用）
    int	 nEncryptFlag;				// 加密标识(是否加密)
    
    int  nNeedDownlord;             //是否下载 
    int  nOwnerId;
    int  nFromId; 
    
    //新增星星级别、到期日期、完成状态、完成日期等属性
    int		nStarLevel;					//星星级别
    NSString* strExpiredDate;			//到期日期
    NSString* strFinishDate;			//完成日期
    int		nFinishState;				//完成状态 0： 表示未完成 1：表示已完成
    
    
    //本地保存的内容域
    NSString* strContent;  //存放部分内容，用于显示
    
    int nFailTimes;
    NSString *strNoteClassId;
    int nFriend;
    int nSendSMS;
    NSString *strJYEXTag;         //2014.10.15  ,上传照片时，保存用户名
}

@property (nonatomic,retain) TRecHead* tHead;
@property (nonatomic,retain) NSString* strCatalogIdGuid;
@property (nonatomic,retain) NSString* strNoteIdGuid;
@property (nonatomic,retain) NSString* strNoteTitle; 
@property (nonatomic,assign) int   nNoteType;
@property (nonatomic,assign) int   nNoteSize;

@property (nonatomic,retain) NSString* strFilePath;
@property (nonatomic,retain) NSString* strFileExt;
@property (nonatomic,retain) NSString* strEditLocation;
@property (nonatomic,retain) NSString* strNoteSrc;

@property (nonatomic,retain) NSString* strFirstItemGuid;
@property (nonatomic,assign) int  nShareMode;
@property (nonatomic,assign) int	 nEncryptFlag;

@property (nonatomic,assign) int  nNeedDownlord;
@property (nonatomic,assign) int  nOwnerId;
@property (nonatomic,assign) int  nFromId; 

@property (nonatomic,assign) int		nStarLevel;
@property (nonatomic,retain) NSString* strExpiredDate;
@property (nonatomic,retain) NSString* strFinishDate;
@property (nonatomic,assign) int		nFinishState;
@property (nonatomic,retain) NSString* strContent;

@property (nonatomic,assign) int	nFailTimes;
@property (nonatomic,retain) NSString* strNoteClassId;
@property (nonatomic,assign) int	nFriend;
@property (nonatomic,assign) int	nSendSMS;
@property (nonatomic,retain) NSString* strJYEXTag;
@end


//项目信息表
#pragma mark -
#pragma mark 项目信息表
@interface TItemInfo : NSObject
{
    TRecHead* tHead;    //记录头
    
    NSString* strItemIdGuid; //项目编号
    NSString* strNoteIdGuid; //所属笔记编号
    int nCreatorID;         //ITEM创建者编号,备用
    int nItemType;          //ITEM的类型
    NSString* strItemExt;   //ITEM的扩展名
    int nItemSize;          //项目大小 
    int	nEncryptFlag;	    //加密标识
    NSString* strItemTitle;  //文件名
    
    int nUploadSize;     //已上传的字节数
    NSString *strServerPath;    //在服务器上的存储路径
}

@property (nonatomic,retain) TRecHead* tHead;

@property (nonatomic,retain) NSString* strItemIdGuid;
@property (nonatomic,retain) NSString* strNoteIdGuid;
@property (nonatomic,assign) int nCreatorID;
@property (nonatomic,assign) int nItemType;
@property (nonatomic,retain) NSString* strItemExt;
@property (nonatomic,assign) int nItemSize; 
@property (nonatomic,assign) int	nEncryptFlag;
@property (nonatomic,retain) NSString* strItemTitle;
@property (nonatomic,assign ) int nUploadSize;
@property (nonatomic,retain) NSString* strServerPath;

@end


//笔记和项目关联表
#pragma mark -
#pragma mark 笔记和项目关联表
@interface TNoteXItem : NSObject
{
    TRecHead* tHead;    //记录头
    NSString* strNoteIdGuid; //笔记编号
    NSString* strItemIdGuid; //项目编号
    int nCreatorID;         //ITEM创建者编号
    NSString* strCatalogBelongToGuid;  //所属目录
    int nItemVer;
    int nNeedDownlord; 
    int nItemOrder; 
}

@property (nonatomic,retain) TRecHead* tHead;
@property (nonatomic,retain) NSString* strNoteIdGuid;
@property (nonatomic,retain) NSString* strItemIdGuid;
@property (nonatomic,assign) int nCreatorID;
@property (nonatomic,retain) NSString* strCatalogBelongToGuid;
@property (nonatomic,assign) int nItemVer;
@property (nonatomic,assign) int nNeedDownlord; 
@property (nonatomic,assign) int nItemOrder; 

@end


//文件夹版本信息表
#pragma mark -
#pragma mark 文件夹版本信息表,用来存放笔记信息的最大版本号，用来获取目录下笔记列表的时候使用
@interface TCatalogVersionInfo : NSObject
{
    int nUserID;    //用户ID
    NSString* strCatalogBelongToGuid;  //目录
    NSString* strTableName;  //表名
    int nMaxVer;
}

@property (nonatomic,assign) int nUserID;
@property (nonatomic,retain) NSString* strCatalogBelongToGuid;
@property (nonatomic,retain) NSString* strTableName;
@property (nonatomic,assign) int nMaxVer;

@end

#pragma mark -
#pragma mark 家园e线班级信息

