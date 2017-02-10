//
//  GlobalVar.h
//  Astro
//
//  Created by root on 11-11-28.
//  Copyright 2011 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBMng.h"


@interface GlobalVar : NSObject 
{
	AstroDBMng* dbMngSet;		//数据库管理
	TLoginUserInfo*	curUser;	//当前登录用户
	TPeopleInfo* curPeople;		//当前命造
	NSFileHandle*	hLogFile;		//日志文件
    
    NSString*  createPeopleGuid;  //新建命造的SGuid，用于切换命造,@""表示没有新创建  2012.8.13
    
    int  nNetStatus;         //网络状态. 0:正常  1:不正常
    
    NSMutableArray *navTitleStack;
    //NSString *curNavTitle;
    NSString *lastNavTitle;
    BOOL bNeedUpdataSoft;
    NSString *sUpdataSoftUrl;
    NSString *sUpdateDate;  //提醒日期
    
}
@property(nonatomic, retain) AstroDBMng* dbMngSet;
@property(nonatomic, retain) TLoginUserInfo*	curUser;
@property(nonatomic, retain) TPeopleInfo* curPeople;
@property(nonatomic, retain) NSFileHandle*	hLogFile;	
@property(nonatomic, retain) NSString*	createPeopleGuid;
@property(nonatomic) int nNetStatus;
//@property(nonatomic, retain) NSString* curNavTitle;
@property(nonatomic, retain) NSString* lastNavTitle;
@property(nonatomic, copy) NSString *sUpdataSoftUrl;
@property(nonatomic, copy) NSString *sUpdateDate;

+ (GlobalVar *) getInstance;
+ (void) ReleaseInstance;

-(void) initGlobalVar;
-(void) initCurAccount;
-(void) initCurPeople;
-(void) setNavTitle:(NSString *)strNavTitle;
-(NSString *) getNavTitle;
-(void) popNavTitle;
-(void) brushNavTitle;
-(void) setUpdataSoftFlag;
-(void) resetUpdataSoftFlag;
-(BOOL) getUpdataSoftFlag;
-(NSString *)getUpdateDate;

@end

#define TheGlobal		[GlobalVar getInstance]
#define TheDbMng		TheGlobal.dbMngSet
#define TheCurUser		TheGlobal.curUser
#define TheCurPeople	TheGlobal.curPeople
#define TheDbMngDict	TheDbMng.dctDbItem
#define TheLogFile		TheGlobal.hLogFile
#define TheCreatePeopleGuid TheGlobal.createPeopleGuid
#define TheNetStatus    TheGlobal.nNetStatus


