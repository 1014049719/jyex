//
//  BussMng.h
//  Astro
//
//  Created by liuyfmac on 11-12-22.
//  Copyright 2011 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussInterImpl.h"

//加入影响业务的接口
enum
{
	BMLogin=1, //登录
	BMValidLogin, //如果为无效用户折弹出登入界面，否则自动登录
	BMUiLogin, //弹出登录界面登录
	BMRegister, //注册 可不加
//	BMZTQ, //天气 可不加
//	BMXXTQ, //详细天气 实时天气 周天气
	BMLRYS,
	BMLYYS,
	BMZWYS_DAY, //运势
	BMZWYS_MONTH, //运势
	BMZWYS_YEAR, //运势
    BMMONEYFORTUNE, //财富趋势
	BMRG, //人格
	BMAQTH, //爱情桃花
	BMMZFX, //名字分析
	BMMZCS, //名字分析消费
	BMPP, //匹配
	BMConsumeCheck,
	BMConsumeRequest,
	BMConsumePay,
	BMGetQa,
	BMSndQa,
    BMQianDao,//签到
    BMSYYS,   //事业成长  2012.8.16
    BMServerDateTime, //服务器时间 2012.8.20
    //-------------以下为定义的业务--------
    BMLogin91Note,    //登录
    BMLogout91Note,   //注销
    BMGetUserInfo,    //获取用户信息
    
    BMDownDir,        //下载文件夹
    BMUploadDir,      //上传文件夹
    
    BMGetLatestNote,   //获取最新笔记信息
    BMDownNoteList,    //下载笔记列表信息
    BMDownNote,        //根据笔记ID下载笔记信息
    BMUploadNote,      //上传笔记信息
    BMSearchNoteList,  //通过标题查找笔记
    
    BMGetNoteAll,      //获取笔记、笔记所有关联项、所有所有item项
    
    BMDownNoteXItems,  //获取笔记的笔记与笔记项关联列表
    BMUploadNoteXItems, //上传笔记与笔记项关联信息
    
    BMDownItem,       //获取笔记项信息
    BMUploadItem,     //上载笔记项信息
    BMDownItemFile,   //下载笔记项文件
    BMUploadItemFile, //上传笔记项数据包
    BMUploadItemFileFinish, //上传笔记项完成
    
    //-------------家园E线------------------------------
    BMJYEXAutoLogin,    //自动登陆
    BMJYEXUploadItemFile,
    BMJYEXJYEXNote,
    BMJYEXUpdataSoft,
    BMJYEXGetUpdateNumber,
    BMJYEXQueryAlbumList,  //查询相册列表
    BMJYEXUploadPhoto,     //上传相片
    BMJYEXCreateAlbum,      //创建相册
    BMJYEXRegister,         //注册
    BMJYEXUpdateUserInfo,   //更改用户资料
    BMJYEXGetAlbumPics,     //获取相册照片
    BMJYEXDownloadFile,     //下载文件
    
    BMQueryAvatar,       //查询头像是否存在
    BMGetAvatar,         //下载头像

};


enum 
{
	CSM_NAME_PARSE = 1,  //名字分析
	CSM_NAME_MATCH = 2,
	CSM_LRYYS = 3,
	CSM_LRYYS_PRO = 4,
	CSM_LNYS = 5,
	CSM_LNYS_PRO = 6,   
    CSM_FORTUNE_YS = 7,  //财富运势
    CSM_CAREER_YS = 8, //事业成长
};

@interface CSMParam : NSObject
{
	NSString* title;
	NSString* str1;
	NSString* str2;
	EConsumeItem item;
	int type, y, m;
    int lr_or_ly; //由于流月与流日共用网络接口，用此变量区分 0:流日  1：流月
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* str1;
@property (nonatomic, retain) NSString* str2;
@property (nonatomic, assign) EConsumeItem item;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) int m;
@property (nonatomic, assign) int lr_or_ly;

@end


@interface TParamRegister : NSObject
{
	NSString* user;
	NSString* pswd;
	NSString* nick;
}

@property (nonatomic, retain) NSString* user;
@property (nonatomic, retain) NSString* pswd;
@property (nonatomic, retain) NSString* nick;

@end


@interface TParamLogin : NSObject
{
	NSString* user;
	NSString* pswd;
	BOOL	remPswd;
    BOOL   autoLogin;
}

@property (nonatomic, retain) NSString* user;
@property (nonatomic, retain) NSString* pswd;
@property (nonatomic, assign) BOOL	remPswd;
@property (nonatomic, assign) BOOL	autoLogin;

@end

@interface TParamZwys : NSObject
{
	TDateInfo* dateInfo;
	EConsumeLookFrom lookFrom;
}

@property (nonatomic,retain) TDateInfo* dateInfo;
@property (nonatomic,assign) EConsumeLookFrom lookFrom;
+ (TParamZwys*) param:(TDateInfo *)dateInfo;

@end

@interface TParamNameMatch : NSObject
{
	TNAME_PD_PARAM* pd;
	EConsumeLookFrom lookFrom;
}
@property (nonatomic, retain) TNAME_PD_PARAM* pd;
@property (nonatomic, assign) EConsumeLookFrom lookFrom;

+ (TParamNameMatch*) param :(TNAME_PD_PARAM*) pd;
@end




@interface TMZFX_FREE : NSObject 
{
	TNT_PLATE_INFO* plate;
	TNT_EXPLAIN_INFO* explain;
}

@property(nonatomic, retain) TNT_PLATE_INFO* plate;
@property(nonatomic, retain) TNT_EXPLAIN_INFO* explain;

@end



@interface BussMng : NSObject 
{
	
	int type;
	int step;
	id param;
	
	id	callbackObj;
	SEL callbackSel;
	id	imp;
	BOOL didLogin;
	
	
	enum 
	{
		STEP_LOGIN = 1,
		STEP_UILOGIN = 2,
		STEP_RELOGIN = 3,
		
		STEP_BUSS1 = 11,
		STEP_BUSS2 = 12,
		STEP_BUSS3 = 13,
		STEP_BUSS4 = 14,
		STEP_BUSS5 = 15,
	};
}

@property (nonatomic, retain) id imp;
@property (nonatomic, retain) id param;

+ (id) loadWithType:(int)type;
+ (id) loadWithType:(int)type :(id)p;
+ (BussMng*) bussWithType:(int)type;

//运势免费时间限
+(BOOL)isFreeDayYS:(TDateInfo*)dateInf;
+(BOOL)isFreeMonthYS:(TDateInfo*)dateInf;
+(BOOL)isFreeYearYS:(TDateInfo*)dateInf;

//运势免费时间限(用服务端时间)
+(BOOL)isFreeDayYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate;
+(BOOL)isFreeMonthYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate;
+(BOOL)isFreeYearYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate;


- (void) request:(id)obj :(SEL)sel :(id)p;
- (void) bussRequest;

//请求对象销毁、释放
-(void)cancelBussRequest;
+(void)cancelBussRequest:(BussMng*)buss, ...; //慎用：因为参数列表到nil参数时，可能没有遍历到列表末尾

@end
