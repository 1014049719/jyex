//
//  GlobalVar.m
//  Astro
//
//  Created by root on 11-11-28.
//  Copyright 2011 洋基科技. All rights reserved.
//


#import "CommonDirectory.h"
#import "CommonDateTime.h"

#import "GlobalVar.h"
#import "PubFunction.h"
#import "NoteMgr.h"
#import "PFunctions.h"



static GlobalVar* globalVar = nil;			//全局变量

@implementation GlobalVar

@synthesize dbMngSet;
@synthesize curUser;
@synthesize curPeople;
@synthesize hLogFile;
@synthesize createPeopleGuid;
@synthesize nNetStatus;
@synthesize lastNavTitle;
@synthesize sUpdataSoftUrl;
@synthesize sUpdateDate;
//@synthesize curNavTitle;

#pragma mark -
//数据库
+ (GlobalVar *) getInstance
{
	if (nil == globalVar) 
	{
		globalVar = [[GlobalVar alloc] init];
	}
	return globalVar;
}

+ (void) ReleaseInstance
{
	if (globalVar)
	{
		[globalVar release];
		globalVar = nil;
	}
}

#pragma mark -

-(id)init
{
	self = [super init];
	if(self)
	{
	}
	
	return self;
}

-(void)dealloc
{
	self.dbMngSet = nil;
	self.curUser = nil;
	self.curPeople = nil;
	
	if (self.hLogFile)
	{
		[self.hLogFile closeFile];
	}
	self.hLogFile = nil;
    
    self.createPeopleGuid = nil;  //add 2012.8.13
    self.lastNavTitle = nil;
    
    SAFEFREE_OBJECT(self->navTitleStack);
    
    self.sUpdataSoftUrl = nil;
    self.sUpdateDate = nil;
    
    //self.curNavTitle = nil;
    
	[super dealloc];
}


-(void) initGlobalVar
{
    self.createPeopleGuid = @"";
    self.nNetStatus = 0;  //正常
    self.lastNavTitle = @"首页";
    self->navTitleStack = [[NSMutableArray alloc] init];
    self->bNeedUpdataSoft = NO;
    //self.curNavTitle = @"首页";
}

//初始化当前帐号
-(void) initCurAccount
{
	//最后一次登录帐号
	TLoginUserInfo *lgnuser = [[TLoginUserInfo new] autorelease];
	[AstroDBMng getLastLoginUser :lgnuser];
	self.curUser = lgnuser;
	
	if ([PubFunction stringIsNullOrEmpty:curUser.sUserName] )
	{
        NSString *strUserName = [PFunctions getUserName];
        if ( strUserName && [strUserName length]> 0 ) 
        {
            self.curUser.sUserName = strUserName;
            self.curUser.sNickName = @"";
            self.curUser.sPassword = @"";
            self.curUser.iSavePasswd = 0;
        }
        else 
        {
		//如果从未登录过，赋值为缺省帐号
#ifdef TARGET_IPHONE_SIMULATOR
	#if ACCESS_OUTER_SERVICE
            self.curUser.sUserName = CS_DEFAULTACCOUNT_USERNAME;
            self.curUser.sPassword = CS_DEFAULTACCOUNT_PASSWORD;
	#else
            self.curUser.sUserName = CS_DEFAULTACCOUNT_USERNAME;
            self.curUser.sPassword = CS_DEFAULTACCOUNT_PASSWORD;
	#endif
#else
            self.curUser.sUserName = CS_DEFAULTACCOUNT_USERNAME;
            self.curUser.sPassword = CS_DEFAULTACCOUNT_PASSWORD;
#endif
        }
	}
	self.curUser.iLoginType = ELoginType_NULL;
	self.curUser.sSID = @"";
	self.curUser.sSessionID = @"";
	self.curUser.sSrvTbName = @"";
}

//初始化当前帐号当前命造
-(void) initCurPeople
{
	//当前帐号的主命造
	TPeopleInfo *pep = [[TPeopleInfo new] autorelease];
	if ([AstroDBMng getHostPeopleInfo:pep])
	{
		self.curPeople = pep;
	}
	else 
	{
		self.curPeople = [AstroDBMng getDemoPeople];
	}
}

-(void) setNavTitle:(NSString *)strNavTitle
{
    if ( [self->navTitleStack count] ) {
        self.lastNavTitle
        = [self->navTitleStack objectAtIndex:self->navTitleStack.count - 1 ];
    }
    [self->navTitleStack addObject:strNavTitle];
    
    //self.curNavTitle = strNavTitle;
}

-(void) popNavTitle
{
    if ( [self->navTitleStack count] ) {
        [self->navTitleStack removeObjectAtIndex:(self->navTitleStack.count - 1)];
    }
    self.lastNavTitle = nil;
    if ( [self->navTitleStack count] ) {
        self.lastNavTitle
        = [self->navTitleStack objectAtIndex:self->navTitleStack.count - 1 ];
    }
}

-(void) brushNavTitle
{
    if ( [self->navTitleStack count] ) {
        self.lastNavTitle
        = [self->navTitleStack objectAtIndex:self->navTitleStack.count - 1 ];
    }
    else
    {
        self.lastNavTitle = @"首页";
    }
}

-(NSString *) getNavTitle
{
    return self.lastNavTitle;
}

-(void) setUpdataSoftFlag
{
    self->bNeedUpdataSoft = YES;
    self.sUpdateDate = [CommonFunc getCurrentDate];
}



-(void) resetUpdataSoftFlag
{
    self->bNeedUpdataSoft = NO;
    self.sUpdateDate = [CommonFunc getCurrentDate];
}

-(BOOL) getUpdataSoftFlag
{
    return self->bNeedUpdataSoft;
}

-(NSString *)getUpdateDate
{
    return self.sUpdateDate;
}


@end
