//
//  BussData.m
//  Astro
//
//  Created by root on 11-11-18.
//  Copyright 2011 ND SOFT. All rights reserved.
//

#import "BussDataDef.h"
#import "BussDataTypeDef.h"
#import "SBJSON.h"
#import "NetConstDefine.h"
#import "logging.h"
#import "PubFunction.h"
#import "POAPinyin.h"
#import "CommonDefine.h"


#pragma mark -
#pragma mark 宏定义
//
#define InstantiateMutableArray(aryObj, initNum)	\
{	\
	if (!aryObj)	\
	{	\
		aryObj = [[NSMutableArray alloc] initWithCapacity:(initNum)];	\
	}	\
	[aryObj removeAllObjects];	\
}

#define ReleaseMutableArray(aryObj)		\
{	\
	if(aryObj)	\
	{	\
		[aryObj removeAllObjects];	\
		[aryObj release];	\
		aryObj = nil;	\
	}	\
}

#pragma mark -
#pragma mark 结构定义


@implementation TBussStatus
@synthesize iCode;
@synthesize sInfo;
@synthesize rtnData;
@synthesize srcParam;

- (void) dealloc
{
	self.sInfo = nil;
	self.rtnData = nil;
    self.srcParam = nil;
	[super dealloc];
}

@end


//登录用户
@implementation TLoginUserInfo

@synthesize  sUserName, sPassword, sUserID, sNickName, sRealName, sUAPID, sSID, sSessionID, sLoginTime, sBlowfish, sMsg;
@synthesize sSrvTbName;
@synthesize  iLoginType,iGroupID,iAppID,iSavePasswd,iAutoLogin;
@synthesize  sNoteUserId;
@synthesize  sNoteMasterKey;
@synthesize  sNoteIpLocation;


-(id) init
{
	self = [super init];
	if (self)
	{
		self.iAppID = [CS_SOFT_ID intValue];
		self.iAutoLogin = 1;
		
		self.sUserName = @"";
		self.sPassword = @"";
		self.sUserID = @"";
		self.sNickName = @"";
		self.sRealName = @"";
		self.sUAPID = @"";
		self.sSID = @"";
		self.sSessionID = @""; 
		self.sLoginTime = @"";
		self.sBlowfish = @"";
		self.sSrvTbName = @"";
		self.sMsg = @"";
        
        self.sNoteUserId = @"";
        self.sNoteMasterKey = @"";
        self.sNoteIpLocation = @"";
	}
	
	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    TLoginUserInfo* newObj = [[[self class] allocWithZone:zone] init];

	newObj.sUserName = [NSMutableString stringWithString:self.sUserName];
	newObj.sPassword = [NSMutableString stringWithString:self.sPassword];
	newObj.sUserID = [NSMutableString stringWithString:self.sUserID];
	newObj.sNickName = [NSMutableString stringWithString:self.sNickName];
	newObj.sRealName = [NSMutableString stringWithString:self.sRealName];
	newObj.sUAPID = [NSMutableString stringWithString:self.sUAPID];
	newObj.sSID = [NSMutableString stringWithString:self.sSID];
	newObj.sSessionID = [NSMutableString stringWithString:self.sSessionID]; 
	newObj.sLoginTime = [NSMutableString stringWithString:self.sLoginTime];
	newObj.iLoginType  = self.iLoginType;
	newObj.iGroupID = self.iGroupID;
	newObj.iAppID = self.iAppID;
	newObj.sBlowfish = [NSMutableString stringWithString:self.sBlowfish];
	newObj.iSavePasswd = self.iSavePasswd;
	newObj.iAutoLogin = self.iAutoLogin;
	newObj.sSrvTbName = [NSMutableString stringWithString:self.sSrvTbName];
	newObj.sMsg = [NSMutableString stringWithString:self.sMsg];
    
    newObj.sNoteUserId = [NSMutableString stringWithString:self.sNoteUserId];
	newObj.sNoteMasterKey = [NSMutableString stringWithString:self.sNoteMasterKey];
	newObj.sNoteIpLocation = [NSMutableString stringWithString:self.sNoteIpLocation];
	
	return newObj;
}

- (BOOL) isDefaultUser
{
	return  ( [sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] && [sPassword isEqualToString: CS_DEFAULTACCOUNT_PASSWORD]);
}

- (BOOL) isLogined
{
	return (iLoginType==ELoginType_OnLine && sSID!=nil && [sSID length]>0);
}

-(void)dealloc
{
	self.sUserName = nil;
	self.sPassword = nil;
	self.sUserID = nil;
	self.sNickName = nil;
	self.sRealName = nil;
	self.sUAPID = nil;
	self.sSID = nil;
	self.sSessionID = nil; 
	self.sLoginTime = nil;
	self.sBlowfish = nil;
	self.sSrvTbName = nil;
	self.sMsg = nil;
    
    self.sNoteUserId = nil;
    self.sNoteMasterKey = nil;
    self.sNoteIpLocation = nil;
	
	[super dealloc];
}


@end

//家园E线
@implementation TJYEXLoginUserInfo
@synthesize sEmail;
@synthesize sMobilephone;
@synthesize sTelephone;
@synthesize sAddress;
@synthesize iLoginFlag, iSchoolType;
@synthesize sAlbumIdPerson; //2014.9.26
@synthesize sAlbumNamePerson;
@synthesize sAlbumUidPerson;
@synthesize sAlbumUsernamePerson;
@synthesize sAlbumIdClass; //2014.9.26
@synthesize sAlbumNameClass;
@synthesize sAlbumUidClass;
@synthesize sAlbumUsernameClass;
@synthesize sAlbumIdSchool; //2014.9.26
@synthesize sAlbumNameSchool;
@synthesize sAlbumUidSchool;
@synthesize sAlbumUsernameSchool;

-(id) init
{
	self = [super init];
	if (self)
	{
        self.sEmail = @"";
        self.sMobilephone = @"";
        self.sTelephone = @"";
        self.sAddress = @"";
        self.iLoginFlag = 0;
        self.iSchoolType = 0;
        
        self.sAlbumIdPerson = @""; //2014.9.26
        self.sAlbumNamePerson = @"";
        self.sAlbumUidPerson = @"";
        self.sAlbumUsernamePerson = @"";
        self.sAlbumIdClass = @""; //2014.9.26
        self.sAlbumNameClass = @"";
        self.sAlbumUidClass = @"";
        self.sAlbumUsernameClass = @"";
        self.sAlbumIdSchool = @""; //2014.9.26
        self.sAlbumNameSchool = @"";
        self.sAlbumUidSchool = @"";
        self.sAlbumUsernameSchool = @"";
    }
    return self;
}

- (BOOL) isLogined
{
	return (iLoginType==ELoginType_OnLine && iLoginFlag == 1 );
}

-(id)copyWithZone:(NSZone *)zone
{
    TJYEXLoginUserInfo* newObj = [super copyWithZone:zone];
    
	newObj.sEmail = [NSMutableString stringWithString:self.sEmail];
	newObj.sMobilephone = [NSMutableString stringWithString:self.sMobilephone];
	newObj.sTelephone = [NSMutableString stringWithString:self.sTelephone];
	newObj.sAddress = [NSMutableString stringWithString:self.sAddress];
    newObj.iLoginFlag = self.iLoginFlag;
    newObj.iSchoolType = self.iSchoolType;
    
    newObj.sAlbumIdPerson = [NSMutableString stringWithString:self.sAlbumIdPerson]; //2014.9.26
    newObj.sAlbumNamePerson = [NSMutableString stringWithString:self.sAlbumNamePerson];
    newObj.sAlbumUidPerson = [NSMutableString stringWithString:self.sAlbumUidPerson];
    newObj.sAlbumUsernamePerson = [NSMutableString stringWithString:self.sAlbumUsernamePerson];
    newObj.sAlbumIdClass = [NSMutableString stringWithString:self.sAlbumIdClass]; //2014.9.26
    newObj.sAlbumNameClass = [NSMutableString stringWithString:self.sAlbumNameClass];
    newObj.sAlbumUidClass = [NSMutableString stringWithString:self.sAlbumUidClass];
    newObj.sAlbumUsernameClass = [NSMutableString stringWithString:self.sAlbumUsernameClass];
    newObj.sAlbumIdSchool = [NSMutableString stringWithString:self.sAlbumIdSchool]; //2014.9.26
    newObj.sAlbumNameSchool = [NSMutableString stringWithString:self.sAlbumNameSchool];
    newObj.sAlbumUidSchool = [NSMutableString stringWithString:self.sAlbumUidSchool];
    newObj.sAlbumUsernameSchool = [NSMutableString stringWithString:self.sAlbumUsernameSchool];
    
	return newObj;
}

-(void)dealloc
{
    self.sEmail = nil;
    self.sMobilephone = nil;
    self.sTelephone = nil;
    self.sAddress = nil;
    
    self.sAlbumIdPerson = nil; //2014.9.26
    self.sAlbumNamePerson = nil;
    self.sAlbumUidPerson = nil;
    self.sAlbumUsernamePerson = nil;
    self.sAlbumIdClass = nil; //2014.9.26
    self.sAlbumNameClass = nil;
    self.sAlbumUidClass = nil;
    self.sAlbumUsernameClass = nil;
    self.sAlbumIdSchool = nil; //2014.9.26
    self.sAlbumNameSchool = nil;
    self.sAlbumUidSchool = nil;
    self.sAlbumUsernameSchool = nil;
    
    [super dealloc];
}

-(BOOL)isMiddleSchoolTeacher
{
    return ( (1 == self.iSchoolType) && (self.iGroupID == 22));
}
-(BOOL)isMiddleSchoolParent
{
    return ( (1 == self.iSchoolType) && (self.iGroupID == 31) );
}
-(BOOL)isMiddleSchoolMaster
{
    return ( (1 == self.iSchoolType) && (self.iGroupID == 21 || self.iGroupID == 34 || self.iGroupID == 35) );
}

-(BOOL)isInfantsSchoolParent
{
    return ( (0 == self.iSchoolType) && (self.iGroupID == 31) );
}
-(BOOL)isInfantsSchoolTeacher
{
    return ( (0 == self.iSchoolType) && (self.iGroupID == 22) );
}
-(BOOL)isInfantsSchoolMaster
{
    return ( (0 == self.iSchoolType) && (self.iGroupID == 21  || self.iGroupID == 34 || self.iGroupID == 35) );
}

-(BOOL)isCommonMember
{
    return ( self.iGroupID == 33 || self.iGroupID == 30);
}



@end

#pragma mark TJYEXLanmu
@implementation TJYEXLanmu
@synthesize sLanmuName;

-(id) init
{
    self.sLanmuName = @"";
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    TJYEXLanmu* newObj = [[[self class] allocWithZone:zone] init];
    
	newObj.sLanmuName = [NSMutableString stringWithString:self.sLanmuName];
	return newObj;
}

-(void) dealloc
{
    self.sLanmuName = nil;
    
    [super dealloc];
}
@end

#pragma mark TJYEXClass
@implementation TJYEXClass
@synthesize sClassId;
@synthesize sClassName;

-(id) init
{
    self.sClassId = @"";
    self.sClassName = @"";
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    TJYEXClass* newObj = [[[self class] allocWithZone:zone] init];
    
    newObj.sClassId = [NSMutableString stringWithString:self.sClassId];
	newObj.sClassName = [NSMutableString stringWithString:self.sClassName];
	return newObj;
}

-(void) dealloc
{
    self.sClassId = nil;
    self.sClassName = nil;
    
    [super dealloc];
}
@end

// 人员信息
@implementation TPeopleInfo
@synthesize ipeopleId;
@synthesize iGroupId;
@synthesize sGuid;
@synthesize sPersonName;
@synthesize sPersonTitle;
@synthesize bIsHost;
@synthesize bIsDaZhong;
@synthesize sHeadImg;
@synthesize sSex;
@synthesize sBirthplace;
@synthesize sTimeZone;
@synthesize sWdZone;  
@synthesize iTimeZone;      
@synthesize iLongitude;		
@synthesize iLongitude_ex;	
@synthesize iLatitude;     
@synthesize iLatitude_ex; 
@synthesize iDifRealTime;
@synthesize bLeap;
@synthesize iYear;
@synthesize iMonth;
@synthesize iDay;
@synthesize iHour;
@synthesize iMinute;
@synthesize iLlYear;
@synthesize iLlMonth;
@synthesize iLlDay;
@synthesize sLlHour;
@synthesize sSaveUserInput;
@synthesize iDataOpt;
@synthesize iVersion;	
@synthesize sUid;
@synthesize bSynced;
@synthesize itmpOptFlag;
@synthesize py;

//构造相关
- (id) init						//对象初始化
{
	self = [super init];
	if (self)
	{
		//地理位置初始为北京的
		self.ipeopleId = -1;
		self.sTimeZone = @"E";
		self.sWdZone = @"N";  
		self.iTimeZone = -8;
		self.iLongitude = 116; 
		self.iLongitude_ex = 27;
		self.iLatitude = 39;
		self.iLatitude_ex = 55;
		self.sBirthplace = @"否|A|北京|市中心";
		self.iYear = 2000;
		self.iMonth = 1;
		self.iDay = 1;
		self.iHour = 0;
		self.iMinute = 0;
		self.iLlYear = 1999;
		self.iLlMonth = 11;
		self.iLlDay = 25;
		self.sHeadImg = @"000-1.png";
        self.py = nil;
	}
	
	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    TPeopleInfo* newObj = [[[self class] allocWithZone:zone] init];
	
	newObj.ipeopleId = self.ipeopleId;
	newObj.iGroupId = self.iGroupId;
	newObj.sGuid = [NSMutableString stringWithString:self.sGuid];
	newObj.sPersonName = [NSMutableString stringWithString:self.sPersonName];
	newObj.sPersonTitle = [NSMutableString stringWithString:self.sPersonTitle];
	newObj.bIsHost = self.bIsHost;
	newObj.bIsDaZhong = self.bIsDaZhong;
	newObj.sHeadImg = [NSMutableString stringWithString:self.sHeadImg];
	newObj.sSex = [NSMutableString stringWithString:self.sSex];
	newObj.sBirthplace = [NSMutableString stringWithString:self.sBirthplace];
	newObj.sTimeZone = [NSMutableString stringWithString:self.sTimeZone];
	newObj.sWdZone = [NSMutableString stringWithString:self.sWdZone];
	newObj.iTimeZone = self.iTimeZone;
	newObj.iLongitude = self.iLongitude;
	newObj.iLongitude_ex = self.iLongitude_ex;
	newObj.iLatitude = self.iLatitude;
	newObj.iLatitude_ex = self.iLatitude_ex;
	newObj.iDifRealTime = self.iDifRealTime;
	newObj.bLeap = self.bLeap;
	newObj.iYear = self.iYear;
	newObj.iMonth = self.iMonth;
	newObj.iDay = self.iDay;
	newObj.iHour = self.iHour;
	newObj.iMinute = self.iMinute;
	newObj.iLlYear = self.iLlYear;
	newObj.iLlMonth = self.iLlMonth;
	newObj.iLlDay = self.iLlDay;
	newObj.sLlHour = [NSMutableString stringWithString:self.sLlHour];
	newObj.sSaveUserInput = [NSMutableString stringWithString:self.sSaveUserInput];
	newObj.iDataOpt = self.iDataOpt;
	newObj.iVersion = self.iVersion;
	newObj.sUid = [NSMutableString stringWithString:self.sUid];
	newObj.bSynced = self.bSynced;
	newObj.itmpOptFlag = self.itmpOptFlag;
    newObj.py = py;
	
    return newObj;
}

-(BOOL) isEqualToPeople:(TPeopleInfo*)other
{
	if (!self || !other)
	{
		return NO;
	}
	
	if (self.ipeopleId == other.ipeopleId
		&& self.iGroupId == other.iGroupId
		&& [self.sGuid isEqualToString:other.sGuid]
		&& [self.sPersonName isEqualToString:other.sPersonName]
		&& [self.sPersonTitle isEqualToString:other.sPersonTitle]
		&& self.bIsHost == other.bIsHost
		&& self.bIsDaZhong == other.bIsDaZhong
		&& [self.sHeadImg isEqualToString:other.sHeadImg]
		&& [self.sSex isEqualToString:other.sSex]
		&& [self.sBirthplace isEqualToString:other.sBirthplace]
		&& [self.sTimeZone isEqualToString:other.sTimeZone]
		&& [self.sWdZone isEqualToString:other.sWdZone]
		&& self.iTimeZone == other.iTimeZone
		&& self.iLongitude == other.iLongitude
		&& self.iLongitude_ex == other.iLongitude_ex
		&& self.iLatitude == other.iLatitude
		&& self.iLatitude_ex == other.iLatitude_ex
		&& self.iDifRealTime == other.iDifRealTime
		&& self.bLeap == other.bLeap
		&& self.iYear == other.iYear
		&& self.iMonth == other.iMonth
		&& self.iDay == other.iDay
		&& self.iHour == other.iHour
		&& self.iMinute == other.iMinute
		&& self.iLlYear == other.iLlYear
		&& self.iLlMonth == other.iLlMonth
		&& self.iLlDay == other.iLlDay
		&& [self.sLlHour isEqualToString:other.sLlHour]
		&& [self.sSaveUserInput isEqualToString:other.sSaveUserInput]
		&& self.iDataOpt == other.iDataOpt
		&& self.iVersion == other.iVersion
		&& [self.sUid isEqualToString:other.sUid]
		&& self.bSynced == other.bSynced
		&& self.itmpOptFlag == other.itmpOptFlag)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (NSComparisonResult)compareByName:(id)inObject
{
    TPeopleInfo* other = (TPeopleInfo*)inObject;
    
    if (py==nil)
    {
        NSString* name = [PubFunction replaceStr:sPersonName :@"-" :@""];
        self.py = [POAPinyin quickConvert:name];
    }
    
    if (other.py==nil)
    {
        NSString* name = [PubFunction replaceStr:other.sPersonName :@"-" :@""];
        other.py = [POAPinyin quickConvert:name];
    }
    
    return ([py compare:other.py]);
   
    /*
    NSString* name1 = [PubFunction replaceStr:self.sPersonName :@"-" :@""];
    NSString* name2 = [PubFunction replaceStr:other.sPersonName :@"-" :@""];
    NSString* cur1 = nil;
    NSString* cur2 = nil;
    NSRange rg;
    rg.length = 1;
    int i=0;
    
    do 
    {
        rg.location = i; //check i in rang;
        cur1 = [name1 substringWithRange:rg];
        cur2 = [name2 substringWithRange:rg];
        
        if (cur1!=nil && cur2!=nil)
        {
           if ([cur1 compare:cur2]!=NSOrderedSame)
           {
               cur1 = [POAPinyin quickConvert:cur1];
               cur2 = [POAPinyin quickConvert:cur2];
               NSComparisonResult result = [cur1 compare:cur2];
               if (result!=NSOrderedSame)
                   return result;
           }
        }
        else if (cur1==nil && cur2==nil)
            return NSOrderedSame;
        else if (cur1==nil)
            return NSOrderedAscending; 
        else
            return NSOrderedDescending;
    
        i++;
        
    } while (YES);
    
    
    return  NSOrderedSame;
     */
}

-(BOOL) isDemo
{
	return (self.iDataOpt == EPEPL_OPT_DEMO);
}

-(BOOL) isHost
{
	return (self.bIsHost == 1);
}

-(void) dealloc
{
	self.sGuid = nil;
	self.sPersonName = nil;
	self.sPersonTitle = nil;
	self.sHeadImg = nil;	//000-1.png	//[NSString stringWithFormat:@"%@",@"000-1.png"];
	self.sSex = nil;
	self.sBirthplace = nil;
	self.sTimeZone = nil;
	self.sWdZone = nil;
	self.sLlHour = nil;
	self.sSaveUserInput = nil;
	self.sUid = nil;
    self.py = nil;
	
	[super dealloc];
}

@end


// 定义日期数据结构
@implementation TDateInfo
@synthesize  year;
@synthesize  month;
@synthesize  day;
@synthesize  hour;
@synthesize  minute;
@synthesize  isRunYue;


-(void)dealloc
{
	[super dealloc];
}

//今日
+(TDateInfo*) getTodayDateInfo
{
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
	
	TDateInfo* todayInfo = [[TDateInfo new] autorelease];
	todayInfo.year = [comps year];
	todayInfo.month = [comps month];
	todayInfo.day = [comps day];
	return todayInfo;
}

+ (TDateInfo*) dateinfoFromDate:(NSDate*)dt
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dt];
	
	TDateInfo* todayInfo = [[TDateInfo new] autorelease];
	todayInfo.year = [comps year];
	todayInfo.month = [comps month];
	todayInfo.day = [comps day];
	return todayInfo;
}

+ (TDateInfo*) dateinfoDayToNow:(int)d
{
	NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval)(d*24*3600)];
	return [TDateInfo dateinfoFromDate: dt];
}

+ (TDateInfo*) dateinfoMonthToNow:(int)m
{
	TDateInfo* dateInfo = [TDateInfo getTodayDateInfo];
	
	int yy = dateInfo.year;
	int mm = dateInfo.month;
	
	yy += m/12;
	mm += m%12;
	
	if (mm>12)
	{
		yy += 1;
		mm -= 12;
	}
	else if (mm<1)
	{
		yy -= 1;
		mm += 12;
	}
	
	dateInfo.year = yy;
    
    if (mm!=dateInfo.month)
    {
        dateInfo.month = mm;
        int maxDay = [PubFunction maxMonthDay:yy :mm];
        if (dateInfo.day > maxDay)
            dateInfo.day = maxDay;
    }
    
	return dateInfo;
}

+ (TDateInfo*) dateinfoMonthToSpecificMonth:(int)m date:(NSDate*)dt
{
	TDateInfo* dateInfo = [TDateInfo dateinfoFromDate: dt];
	
	int yy = dateInfo.year;
	int mm = dateInfo.month;
	
	yy += m/12;
	mm += m%12;
	
	if (mm>12)
	{
		yy += 1;
		mm -= 12;
	}
	else if (mm<1)
	{
		yy -= 1;
		mm += 12;
	}
	
	dateInfo.year = yy;
    
    if (mm!=dateInfo.month)
    {
        dateInfo.month = mm;
        int maxDay = [PubFunction maxMonthDay:yy :mm];
        if (dateInfo.day > maxDay)
            dateInfo.day = maxDay;
    }
    
	return dateInfo;
}


+ (TDateInfo*) dateinfoYearToNow:(int)y
{
	TDateInfo* dateInfo = [TDateInfo getTodayDateInfo];
	dateInfo.year += y;
    
    if (y > 1)
    {
        int maxDay = [PubFunction maxMonthDay:dateInfo.year :dateInfo.month];
        if (dateInfo.day > maxDay)
            dateInfo.day = maxDay;
    }
    
	return dateInfo;
}


+ (TDateInfo*) dateinfoYearToSpecificYear:(int)y date:(NSDate*)dt
{
	TDateInfo* dateInfo = [TDateInfo dateinfoFromDate: dt];

    dateInfo.year += y;
        
    if (y != 0)
    {
        int maxDay = [PubFunction maxMonthDay:dateInfo.year :dateInfo.month];
        if (dateInfo.day > maxDay)
            dateInfo.day = maxDay;
    }
        
    return dateInfo;
}

@end


// 大众运势-查询参数
@implementation TYunShiParam
@synthesize pepInfo;
@synthesize dateInfo;


-(void) dealloc
{
	self.pepInfo = nil;		// 人员信息
	self.dateInfo = nil;	// 所求的日期
	
	[super dealloc];
}

@end


// 解释
@implementation TTITLE_EXP 
@synthesize sTitle;
@synthesize sExplain;


-(void)dealloc
{
	self.sTitle = nil;
	self.sExplain = nil;
	
	[super dealloc];
}

@end

//流日/流月运势简评
@implementation TFlowYS
@synthesize  sDataTime, yunShi;


-(void) dealloc
{
	self.sDataTime = nil;
	self.yunShi = nil;
	
	[super dealloc];
}
@end


// 大众版--简约命理信息
@implementation TDZYS_SIMPLE_FATE_INFO
@synthesize sBzFate;
@synthesize sBzFateExp;
@synthesize sZwStar;
@synthesize sZwStarExp;


-(void)dealloc
{
	self.sBzFate = nil;
	self.sBzFateExp = nil;	
	self.sZwStar = nil;	
	self.sZwStarExp = nil;	
	
	[super dealloc];
}

@end


// 大众版--每个年、月、日的吉凶指数结构体(一般用于绘制吉凶趋势图标)
@implementation TDZYS_EVERY_JX_VALUE
@synthesize sDateTile;
@synthesize sDateTileExp;
@synthesize iJxValue;


-(void)dealloc
{
	self.sDateTile    = nil;
	self.sDateTileExp = nil;
	
	[super dealloc];
}


@end


// 十二宫的吉凶情况--手机运势使用
@implementation TPALACE_JXVALUE_FORMOBILE
@synthesize iFlowMingGValue;
@synthesize iFlowFuMuGValue;
@synthesize iFlowFuDeGValue;
@synthesize iFlowTianZaiGValue;
@synthesize iFlowGuanLuGValue;
@synthesize iFlowPuYiGValue;
@synthesize iFlowQianYiGValue;
@synthesize iFlowJiErGValue;
@synthesize iFlowCaiBoGValue;
@synthesize iFlowZiNvGValue;
@synthesize iFlowFuQiGValue;
@synthesize iFlowXiongDiGValue;

//=====构造相关=====//
//对象初始化
- (id) init
{
	self = [super init];
	if (self)
	{
		iFlowMingGValue = -1;	
		iFlowFuMuGValue = -1;	
		iFlowFuDeGValue = -1;	
		iFlowTianZaiGValue = -1;	
		iFlowGuanLuGValue = -1;	
		iFlowPuYiGValue = -1;	
		iFlowQianYiGValue = -1;	
		iFlowJiErGValue = -1;	
		iFlowCaiBoGValue = -1;	
		iFlowZiNvGValue = -1;	
		iFlowFuQiGValue = -1;	
		iFlowXiongDiGValue = -1;	
	}
	
	return self;
}

@end


// 大众版--流年信息(流年流月流日通用)
@implementation TDZYS_FLOWYEAR_EXP
@synthesize sTimeTitle;
@synthesize dzFateInfo;
@synthesize vecChildJxValue;
@synthesize vecYunShiExp;
@synthesize palaceValue;


-(void) dealloc
{
	self.sTimeTitle = nil;
	self.dzFateInfo = nil;
	self.palaceValue = nil;
	self.vecChildJxValue = nil;
	self.vecYunShiExp = nil;
	
	[super dealloc];
}
@end


// 流年信息扩展
@implementation TZWYS_FLOWYEAR_EXT
@synthesize  sDataTime;
@synthesize  tZwYsExp;

-(void) dealloc
{
	self.sDataTime = nil;
	self.tZwYsExp = nil;
	[super dealloc];
}

@end

@implementation TLYSM_MONEYFORTUNE_EXT
@synthesize sDataTime;
@synthesize vecShiZhu;
@synthesize sMainStar;
@synthesize sBzCaifuInfo;
@synthesize sZwCaifuInfo;
@synthesize sZwCBGExp;
@synthesize sRichValueExp;
@synthesize sCaifuAttitude;
@synthesize sCaifuType;
@synthesize vecUserCFValue;
@synthesize vecTrapForMoney;
@synthesize sCooperateFromBiJie;
@synthesize sShengXiaoGood;
@synthesize sShengXiaoBad;
@synthesize sQiuCaiSuggest;
@synthesize sQiuCaiPossion;
@synthesize sLuckyColor;

-(void) dealloc
{
	self.sDataTime = nil;
	self.vecShiZhu = nil;
    self.sMainStar = nil;
    self.sBzCaifuInfo = nil;
    self.sZwCaifuInfo = nil;
    self.sZwCBGExp = nil;
    self.sRichValueExp = nil;
    self.sCaifuAttitude = nil;
    self.sCaifuType = nil;
    self.vecUserCFValue = nil;
    self.vecTrapForMoney = nil;
    self.sCooperateFromBiJie = nil;
    self.sShengXiaoGood = nil;
    self.sShengXiaoBad = nil;
    self.sQiuCaiSuggest = nil;
    self.sQiuCaiPossion = nil;
    self.sLuckyColor = nil;
    
    
	[super dealloc];
}
@end

//事业成长实现  2012.8.16--------------
//事业成长信息
@implementation TSYYS
@synthesize sBestCareerType;
@synthesize sBestWordReason;
@synthesize sBestWork;
@synthesize sBetterWork;
@synthesize sBetterWorkReason;
@synthesize sShiYeZongPing;
@synthesize sWorkQianZhi;
@synthesize sZhuYiShiXiang;
@synthesize sZiWeiMainStar;
@synthesize vecShiShenPower;
@synthesize vecSiZhu;
@synthesize vecWorkBestYear;
@synthesize vecWorkWorstYear;

-(void) dealloc
{
	self.sBestCareerType = nil;
	self.sBestWordReason = nil;
	self.sBestWork = nil;
    self.sBetterWork = nil;
	self.sBetterWorkReason = nil;
	self.sShiYeZongPing = nil;
    self.sWorkQianZhi = nil;
	self.sZhuYiShiXiang = nil;
	self.sZiWeiMainStar = nil;
	self.vecShiShenPower = nil;
	self.vecSiZhu = nil;
    self.vecWorkBestYear = nil;
	self.vecWorkWorstYear = nil;

	[super dealloc];
}

@end

// 流年信息扩展
@implementation TSYYS_EXT
@synthesize sDataTime;
@synthesize tSyYs;

-(void) dealloc
{
	self.sDataTime = nil;
	self.tSyYs = nil;
    
	[super dealloc];
}

@end


//事业成长相关结构  2012.8.16--------------
// 主要结果
@implementation TMainResult
@synthesize sMerit;	
@synthesize sWeak;	
@synthesize sAdvice;


-(void) dealloc
{
	sMerit = nil;		//优点
	sWeak = nil;		//缺点
	sAdvice = nil;		//建议
	[super dealloc];
}
@end


// 性格五类行分数
@implementation  TNatureScore
@synthesize iWitScore;	
@synthesize iJustScore;	
@synthesize iKindScore;	
@synthesize iSteadyScore;	
@synthesize iContactScore;

@end


// 人格特质结果
@implementation TNatureResult
@synthesize strMainResult;  
@synthesize strNatureScore;
@synthesize sZwFateInfo;		
@synthesize sBzFateInfo;		


-(void) dealloc
{
	self.sZwFateInfo = nil;
	self.sBzFateInfo = nil;
	self.strMainResult = nil;
	self.strNatureScore = nil;
	
	[super dealloc];
}

@end

 
//命局桃花
@implementation TMingJuTaoHua
@synthesize sTaoHua;
@synthesize iNum;
@synthesize sMean;


-(void) dealloc
{
	self.sTaoHua = nil;
	self.sMean = nil;
	[super dealloc];
}

@end


//行运中的桃花
@implementation TXingYunTaoHua
@synthesize veciYear;
@synthesize vecsTaoHua;


-(void) dealloc
{
	[self.veciYear removeAllObjects];
	self.veciYear = nil;
	
	[self.vecsTaoHua removeAllObjects];
	self.vecsTaoHua = nil;

	[super dealloc];
}

@end


@implementation TBZMODEL_ZHU 
@synthesize sGan;				
@synthesize sZhi;				
@synthesize vecsCangGan;
@synthesize sGanShishen;		
@synthesize vecsCGShiShen;
@synthesize sWangShuai;
@synthesize sNaYin;


-(void) dealloc
{
	self.sGan = nil;;		
	self.sZhi = nil;;		
	self.sGanShishen = nil;;
	self.sWangShuai = nil;;
	self.sNaYin = nil;;
	self.vecsCangGan = nil;
	self.vecsCGShiShen = nil;
	
	[super dealloc];
}

@end


//爱情桃花结果结构体
@implementation TLoveTaoHuaResult
@synthesize lagResult;
@synthesize vecMingJuTaoHua;
@synthesize vecXingYunTaoHua;
@synthesize sXiangPei;
@synthesize sBuHe;
@synthesize sPeiOuSrc;
@synthesize sPeiOuPos;
@synthesize sPeiOulooks;
@synthesize sPeiOuRel;
@synthesize sSynAna;
@synthesize sMarryTime;
@synthesize veciMarryWang;
@synthesize veciMarryRuo;
@synthesize sMainStar;
@synthesize sFuQiStar;
@synthesize vecZhu;


-(void) dealloc
{
	[self.vecMingJuTaoHua removeAllObjects];
	[self.vecXingYunTaoHua removeAllObjects];
	[self.veciMarryWang removeAllObjects];
	[self.veciMarryRuo removeAllObjects];
	[self.vecZhu removeAllObjects];
	
	
	self.lagResult = nil;
	self.vecMingJuTaoHua = nil;
	self.vecXingYunTaoHua = nil;
	self.sXiangPei = nil;
	self.sBuHe = nil;
	self.sPeiOuSrc = nil;
	self.sPeiOuPos = nil;
	self.sPeiOulooks = nil;
	self.sPeiOuRel = nil;
	self.sSynAna = nil;
	self.sMarryTime = nil;
	self.veciMarryWang = nil;
	self.veciMarryRuo = nil;
	self.sMainStar = nil;
	self.sFuQiStar = nil;
	self.vecZhu = nil;

	[super dealloc];
}

@end


// 姓名
@implementation TPEP_NAME
@synthesize sFamilyName;
@synthesize sSecondName;


+ (TPEP_NAME*) pepnameFromString:(NSString*)name
{
	TPEP_NAME* n = [[TPEP_NAME new] autorelease];
	NSRange rg = [name rangeOfString:@"-"];
	
	if (rg.location==NSNotFound)
	{
		n.sFamilyName = @"";
		n.sSecondName = name;
	}
	else 
	{
		n.sFamilyName = [name substringToIndex:rg.location];
		n.sSecondName = [name substringFromIndex:rg.location+1];
	}
	
	return n;
}

-(void) dealloc
{
	self.sFamilyName = nil;
	self.sSecondName = nil;
	[super dealloc];
}

@end


// 字
@implementation TCHARACTER 
@synthesize sCharacter;
@synthesize sTraditChar;
@synthesize sPhonetic;
@synthesize sFiveElement;
@synthesize sGoodAndBad;
@synthesize iWordCount;
@synthesize iWordCountJt;
@synthesize sTone;
@synthesize iUseFrequency;
@synthesize iWordKind;
@synthesize sWordMean;
@synthesize sPronunciation;
@synthesize sSimpleWordMean;

//=====构造相关=====//
//对象初始化
- (id) init
{
	self = [super init];
	if (self)
	{
		iWordCount = -1;
		iWordCountJt = -1;
		iUseFrequency = -1;
		iWordKind = -1;
	}
	
	return self;
}

-(void)dealloc
{
	self.sCharacter = nil;
	self.sTraditChar = nil;
	self.sPhonetic = nil;
	self.sFiveElement = nil;
	self.sGoodAndBad = nil;
	self.sTone = nil;
	self.sWordMean = nil;
	self.sPronunciation = nil;
	self.sSimpleWordMean = nil;
	
	[super dealloc];
}

@end


// 姓名康熙词典对应内容
@implementation TPEP_KXNAME
@synthesize aryChrKxFamilyName;
@synthesize aryChrKxSecondName;

-(void)dealloc
{
	[self.aryChrKxFamilyName removeAllObjects];
	[self.aryChrKxSecondName removeAllObjects];
	
	self.aryChrKxFamilyName = nil;
	self.aryChrKxSecondName = nil;
	[super dealloc];
}


@end


@implementation TFIVE_PATTERN_NUMS
@synthesize iTianPatternNum;
@synthesize iDiPatternNum;
@synthesize iRenPatternNum;
@synthesize iWaiPatternNum;
@synthesize iZongPatternNum;
@synthesize sTianPatternFiveE;
@synthesize sDiPatternFiveE;
@synthesize sRenPatternFiveE;
@synthesize sWaiPatternFiveE;
@synthesize sZongPatternFiveE;

//=====构造相关=====//
//对象初始化
- (id) init
{
	self = [super init];
	if (self)
	{
		iTianPatternNum = -1;
		iDiPatternNum = -1;
		iRenPatternNum = -1;
		iWaiPatternNum = -1;
		iZongPatternNum = -1;
	}
	
	return self;
}

-(void)dealloc
{
	self.sTianPatternFiveE = nil;
	self.sDiPatternFiveE = nil;
	self.sRenPatternFiveE = nil;
	self.sWaiPatternFiveE = nil;
	self.sZongPatternFiveE = nil;

	[super dealloc];
}


@end


@implementation TNT_PLATE_INFO

@synthesize pep_kxname;
@synthesize five_pattern_nums;

-(void)dealloc
{
	self.pep_kxname = nil;
	self.five_pattern_nums = nil;
	
	[super dealloc];
}


@end


@implementation TNT_EXPLAIN_INFO
@synthesize vecFivePatternExp;
@synthesize vecThreeTalentExp;
@synthesize vecMathHintExp;
@synthesize vecFiveElementsExp;
@synthesize strNameComments;
@synthesize dNameScore;
@synthesize iThScore;


-(void)dealloc
{
	[self.vecFivePatternExp removeAllObjects];
	[self.vecThreeTalentExp removeAllObjects];
	[self.vecMathHintExp removeAllObjects];
	[self.vecFiveElementsExp removeAllObjects];

	self.vecFivePatternExp = nil;
	self.vecThreeTalentExp = nil;
	self.vecMathHintExp = nil;
	self.vecFiveElementsExp = nil;
	self.strNameComments = nil;
	
	[super dealloc];
}

@end


// 姓名易心测试信息
@implementation TNameYxTestInfo
@synthesize sXgResult;
@synthesize sSyResult;
@synthesize sHyResult;
@synthesize sJkResult;
@synthesize sTdResult;


-(void)dealloc
{
	self.sXgResult = nil;
	self.sSyResult = nil;
	self.sHyResult = nil;
	self.sJkResult = nil;
	self.sTdResult = nil;
	
	[super dealloc];
}

@end


// 姓名易心传入参数格式
@implementation TNameYxParam
@synthesize pepName;
@synthesize sSex;
@synthesize sConsumeItem;


-(void)dealloc
{
	self.pepName = nil;
	self.sSex = nil;
	self.sConsumeItem = nil;
	
	[super dealloc];
}

@end


// 姓名易心测试信息
@implementation TNAME_PD_RESULT
@synthesize xgnum;
@synthesize yfnum;
@synthesize qdnum;
@synthesize zsnum;
@synthesize manxg;
@synthesize womanxg;
@synthesize manyf;
@synthesize womanyf;
@synthesize manfd;
@synthesize womanfd;
@synthesize manwt;
@synthesize womanwt;
@synthesize manjy;
@synthesize womanjy;
@synthesize zsstr;

//=====构造相关=====//
//对象初始化
- (id) init
{
	self = [super init];
	if (self)
	{
		xgnum = 1;
		yfnum = 1;
		qdnum = 1;
		zsnum = 1;
	}
	
	return self;
}

-(void)dealloc
{
	self.manxg = nil;
	self.womanxg = nil;
	self.manyf = nil;
	self.womanyf = nil;
	self.manfd = nil;
	self.womanfd = nil;
	self.manwt = nil;
	self.womanwt = nil;
	self.manjy = nil;
	self.womanjy = nil;
	self.zsstr = nil;
	
	[super dealloc];
}

@end


// 姓名易心传入参数格式
@implementation TNAME_PD_PARAM
@synthesize sManXin;
@synthesize sManMing;
@synthesize sWomanXin;
@synthesize sWomanMing;


-(void)dealloc
{
	self.sManXin = nil;
	self.sManMing = nil;
	self.sWomanXin = nil;
	self.sWomanMing = nil;
	
	[super dealloc];
}


@end


#pragma mark -
#pragma mark 余额、价格
@implementation TProductInfo

@synthesize sUserName;
@synthesize sRuleId;
@synthesize fFreeMoneyBalance;
@synthesize fMoneyBalance;	
@synthesize fTotalMoneyBalance;
@synthesize fProductMoney;
@synthesize fOriginMoney;
@synthesize bEnough;	
@synthesize fNeedMoney;	

-(void) dealloc
{
	self.sUserName = nil;
	self.sRuleId = nil;
	
	[super dealloc];
}

@end



#pragma mark -
#pragma mark 检查支付结果
@implementation TCheckPayResult

@synthesize httpCode;
@synthesize respVal;
@synthesize sMsg;

-(void)dealloc
{
	self.sMsg = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark 支付结果
@implementation TPayResult

@synthesize httpCode;
@synthesize sMsg;

-(void)dealloc
{
	self.sMsg = nil;
	
	[super dealloc];
}


@end




#pragma mark -
#pragma mark 检查新版本
@implementation TCheckVersionResult

@synthesize sVerCode;
@synthesize sDownURL;

-(void)dealloc
{
	self.sVerCode = nil;
	self.sDownURL = nil;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 悬赏&建议——回复
@implementation TBussSuggestAnswer

@synthesize sQuesNO;
@synthesize sAnswer;
@synthesize sAskTime;
@synthesize sAnsTime;
@synthesize flag;	


-(void)dealloc
{
	self.sQuesNO = nil;
	self.sAnswer = nil;
	self.sAskTime = nil;
	self.sAnsTime = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark 软件推荐表
// 推荐软件信息
@implementation AppInfo
@synthesize softID, softVersion;
@synthesize appID, appVersion;
@synthesize appName;
@synthesize typeName;
@synthesize typeSort;
@synthesize softIdVersion, softSort, optFlag, previewPathFlag, icoPathFlag;
@synthesize softInfoId, softVersion1, softInfoVersion;
@synthesize softName, company, previewPath, packageName, icoPath, description, license, softUrl, bundleIdentifier;
@synthesize rating;


-(void) dealloc {
	self.appName = nil;
    self.typeName = nil;
	self.softName = nil;
	self.company = nil;
	self.previewPath = nil;
	self.packageName = nil;
	self.icoPath = nil;
	self.description = nil;
	self.license = nil;
	self.softUrl = nil;
	self.rating = nil;
    
   	[super dealloc];
}

- (NSComparisonResult)compare:(id)inObject
{
    AppInfo* other = (AppInfo*)inObject;
   
    if (self.softSort < other.softSort) 
        return NSOrderedAscending;
    else if (self.softSort > other.softSort)
        return NSOrderedDescending;
    else if (self.rating < other.rating)
        return NSOrderedAscending;
    else if (self.rating > other.rating)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


@end 

@implementation AppInfoList
@synthesize appVersion;
@synthesize baseHost;
@synthesize aryAppInfo;


-(void) dealloc {
    
	self.baseHost = nil;
	self.aryAppInfo = nil;
    
   	[super dealloc];
}



@end

@implementation WeatherNow
@synthesize nowweather, nowimg, temp, sd, wd, ws, uv, sysdate;

- (void) dealloc
{
    self.nowweather = nil;
    self.nowimg = nil;
    self.temp = nil;
    self.sd = nil;
    self.wd = nil;
    self.ws = nil;
    self.uv = nil;
    self.sysdate = nil;
 
    [super dealloc];
}

@end



@implementation WeatherDay
@synthesize ddate, dayweather, dayimg, nightweather, nightimg, hightemp, lowtemp;

- (void) dealloc
{
    self.ddate = nil; 
    self.dayweather = nil;
    self.dayimg = nil;
    self.nightweather = nil;
    self.nightimg = nil;
    self.hightemp = nil;
    self.lowtemp = nil;
    
    [super dealloc];
}

@end

@implementation WeatherWeek
@synthesize sysdate, vecDay;

- (void) dealloc
{
    self.sysdate = nil; 
    [self.vecDay removeAllObjects];
    self.vecDay = nil;
    
    [super dealloc];
}

@end


/*
@implementation WeatherWeek
@synthesize city, city_en, date_y, date, week, fchh, cityid;
@synthesize temp1, temp2, temp3, temp4, temp5, temp6;
@synthesize weather1, weather2, weather3, weather4, weather5, weather6;
@synthesize img_title1, img_title2, img_title3, img_title4, img_title5, img_title6;
@synthesize img_title7, img_title8,  img_title9,  img_title10,  img_title11, img_title12;
@synthesize img1, img2, img3, img4, img5, img6, img7, img8, img9, img10, img11, img12;
@synthesize wind1, wind2, wind3, wind4, wind5, wind6; 
@synthesize index_uv, sour;

- (void) dealloc
{
    self.city = nil;
	self.city_en = nil;
	self.date_y = nil;
	self.date = nil;
	self.week = nil;
	self.fchh = nil;
	self.cityid = nil;
	
	self.temp1 = nil;
	self.temp2 = nil;
	self.temp3 = nil;
	self.temp4 = nil;
	self.temp5 = nil;
	self.temp6 = nil;
	
	self.weather1 = nil;
	self.weather2 = nil;
	self.weather3 = nil;
	self.weather4 = nil;
	self.weather5 = nil;
	self.weather6 = nil;
	
	self.img1 = nil;
	self.img2 = nil;
	self.img3 = nil;
	self.img4 = nil;
	self.img5 = nil;
	self.img6 = nil;
	self.img7 = nil;
	self.img8 = nil;
	self.img9 = nil;
	self.img10 = nil;
	self.img11 = nil;
	self.img12 = nil;
	
	self.img_title1 = nil;
	self.img_title2 = nil;
	self.img_title3 = nil;
	self.img_title4 = nil;
	self.img_title5 = nil;
	self.img_title6 = nil;
	self.img_title7 = nil;
	self.img_title8 = nil;
	self.img_title9 = nil;
	self.img_title10 = nil;
	self.img_title11 = nil;
	self.img_title12 = nil;
	
	self.wind1 = nil;
	self.wind2 = nil;
	self.wind3 = nil;
	self.wind4 = nil;
	self.wind5 = nil;
	self.wind6 = nil;

	self.index_uv = nil;
    self.sour = nil;
	
    [super dealloc];
}

@end
*/
 
@implementation WeatherAlarm
@synthesize weatherno,weather, grade, color, content, bz, fy, fbtime, imgurl, sysdate;

- (void) dealloc
{
    self.weatherno = nil;
    self.weather = nil;
    self.grade = nil;
    self.color = nil;
    self.content  = nil; 
    self.bz = nil; 
    self.fy = nil;
    self.fbtime = nil;
    self.imgurl = nil;
    self.sysdate = nil;
    
    [super dealloc];
}

@end

@implementation WeatherInfo
@synthesize rTs;
@synthesize sCityCode;
@synthesize sDate;
@synthesize now;
@synthesize week;
@synthesize alarm;

+ (WeatherInfo*) weatherWithJson:(NSString*)json
{
    NSLog(@"%@",json);
    
    NSDictionary *nodes = [json JSONValue]; 		
    if (nodes == nil)
        return nil;
    
     WeatherInfo* info = [[WeatherInfo new] autorelease];
   
    @try 
    {
        NSDictionary* it = [nodes objectForKey:@"now"];
        if (it!=nil)
        {
            WeatherNow* wtNow = [[WeatherNow new] autorelease];
            wtNow.nowweather   = [it objectForKey:@"nowweather"];
            if ( wtNow.nowweather == nil ) return nil;   //老接口是没有这个域名的。
            wtNow.nowimg = [it objectForKey:@"nowimg"];
            wtNow.temp   = [it objectForKey:@"temp"];
            wtNow.sd     = [it objectForKey:@"sd"];
            wtNow.wd     = [it objectForKey:@"wd"];
            wtNow.ws     = [it objectForKey:@"ws"];
            wtNow.uv    = [it objectForKey:@"uv"];
            wtNow.sysdate   = [it objectForKey:@"sysdate"];
            
            info.now = wtNow;
        }
       
        NSDictionary*weatherinfo = [nodes objectForKey:@"weatherinfo"];
        if ( weatherinfo != nil )
        {
            WeatherWeek* wtWeek = [[WeatherWeek new] autorelease];
            
            wtWeek.sysdate = [weatherinfo objectForKey:@"sysdate"];
            
            NSArray* aryWeather = [weatherinfo objectForKey:@"weather"];
            if (![PubFunction isArrayEmpty:aryWeather])
            {
                wtWeek.vecDay = [NSMutableArray array];
                for (id objWeather in aryWeather)
                {
                    WeatherDay* objDay = [WeatherDay new];
                    [wtWeek.vecDay addObject:objDay];
                    [objDay release];
                    
                    objDay.ddate = [objWeather objectForKey:@"ddate"];
                    objDay.dayweather = [objWeather objectForKey:@"dayweather"];
                    objDay.dayimg = [objWeather objectForKey:@"dayimg"];
                    objDay.nightweather = [objWeather objectForKey:@"nightweather"];
                    objDay.nightimg = [objWeather objectForKey:@"nightimg"];
                    objDay.hightemp = [objWeather objectForKey:@"hightemp"];
                    objDay.lowtemp = [objWeather objectForKey:@"lowtemp"];
                }
            }
            
            info.week = wtWeek;
        }
        
        
        it = [nodes objectForKey:@"tqyj"];
        if (it!=nil)
        {
            WeatherAlarm* wtAlarm = [[WeatherAlarm new] autorelease];
            wtAlarm.weatherno = [it objectForKey:@"weatherno"];
            wtAlarm.weather = [it objectForKey:@"weather"];
            wtAlarm.grade = [it objectForKey:@"grade"];
            wtAlarm.color = [it objectForKey:@"color"];
            wtAlarm.content  = [it objectForKey:@"content"]; 
            wtAlarm.bz = [it objectForKey:@"bz"]; 
            wtAlarm.fy = [it objectForKey:@"fy"];
            wtAlarm.fbtime = [it objectForKey:@"fbtime"];
            wtAlarm.imgurl = [it objectForKey:@"imgurl"];
            wtAlarm.sysdate = [it objectForKey:@"sysdate"];
            
            info.alarm = wtAlarm;
        }
    }
    
    @catch (NSException * e)
	{
		LOG_ERROR(@"解析天气出错");
		return nil;
	}
    
    return info;
}

/*
 
 appList.baseHost = [nodes objectForKey:@"nBaseHost"]; 
 appList.appVersion = [[nodes objectForKey:@"nAppVersoin"] intValue];
 NSDictionary* appInfos = [nodes objectForKey:@"arrSoftInfo"];
 if (appInfos == nil)
 return nil;
 
 NSMutableArray* items = [NSMutableArray array];
 */


- (void) dealloc
{
    self.sCityCode = nil;
    self.sDate = nil;
    self.rTs = 0;
    
    self.now = nil;
    self.week = nil;
    self.alarm = nil;
    
    [super dealloc];
}

@end

//查询用户余额和产品价格
@implementation UserAndPriceInfo
@synthesize fFreeMoneyBalance;
@synthesize fMoneyBalance;
@synthesize fTotalMoneyBalance;
@synthesize fProductMoney;
@synthesize fOriginMoney;
@synthesize bEnough;
@synthesize fNeedMoney;
    

+ (UserAndPriceInfo*) userAndPriceWithJson:(NSString*)json
{
    
    NSDictionary *nodes = [json JSONValue]; 		
    if (nodes == nil)
        return nil;
    
    UserAndPriceInfo* info = [[UserAndPriceInfo new] autorelease];
    
    @try 
    {
        info.fFreeMoneyBalance   = [[nodes objectForKey:@"fFreeMoneyBalance"] floatValue];
        info.fMoneyBalance       = [[nodes objectForKey:@"fMoneyBalance"] floatValue];
        info.fTotalMoneyBalance  = [[nodes objectForKey:@"fTotalMoneyBalance"] floatValue];
        info.fProductMoney       = [[nodes objectForKey:@"fProductMoney"] floatValue];
        info.fOriginMoney        = [[nodes objectForKey:@"fOriginMoney"] floatValue];
        info.bEnough             = [[nodes objectForKey:@"bEnough"] floatValue];
        info.fNeedMoney          = [[nodes objectForKey:@"fNeedMoney"] floatValue];
     }
    
    @catch (NSException * e)
	{
		LOG_ERROR(@"解析用户余额和产品价格出错");
		return nil;
	}
    
    return info;
}


- (void) dealloc
{
    
    [super dealloc];
}

@end

@implementation JYEXUserAppInfo

@synthesize sUserName;
@synthesize sAppCode;
@synthesize sAppName;
@synthesize iAppID;
@synthesize iAppType;

-(id)init
{
    self = [super init];
    if ( self ) {
        self.sUserName = @"";
        self.sAppCode = @"";
        self.sAppName = @"";
        self.iAppID = 0;
        self.iAppType = 0;
    }
    return self;
}

-(void)dealloc
{
    self.sUserName = nil;
    self.sAppCode = nil;
    self.sAppName = nil;
    
    [super dealloc];
}
@end

