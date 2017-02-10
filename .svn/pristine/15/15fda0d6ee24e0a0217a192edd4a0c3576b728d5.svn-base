//
//  DbMngDataDef.mm
//  Astro
//
//  Created by root on 11-12-6.
//  Copyright 2011 洋基科技. All rights reserved.
//

#import "DbMngDataDef.h"
#import "DateTypeDef.h"
#import "Calendar.h"


#pragma mark 本地数据表结构

#pragma mark 天气城市设置

@implementation TCityWeather

@synthesize sCityCode;	
@synthesize sCityName;	
@synthesize iSort;			

-(void)dealloc
{
	self.sCityCode = nil;		
	self.sCityName = nil;
	[super dealloc];
}

@end




#pragma mark -
#pragma mark 黄历信息-本地
@implementation THuangLi

@synthesize HuangTS, HuangJS, HuangY, HuangJ, HuangC;

-(void)dealloc
{
	self.HuangTS = nil;
	self.HuangJS = nil;
	self.HuangY = nil;
	self.HuangJ = nil;
	self.HuangC = nil;
	[super dealloc];
}


@end


#pragma mark -
#pragma mark 黄历查询结果
@implementation THuangLiSearchResult

@synthesize tDate;	
@synthesize	strYi;
@synthesize	strJi;
@synthesize	strChong;

-(void)dealloc
{
	self.tDate = nil;
	self.strYi = nil;
	self.strJi = nil;
	self.strChong = nil;
	[super dealloc];
}

//根据查询结果中的日期，返回相应公历、农历的显示字符串
+(NSString*) getResultGlDateDesc:(TDateInfo*) date
{
	if (!date)
	{
		return @"";
	}
	
	return [NSString stringWithFormat: @"%d.%d.%d", date.year, date.month, date.day];
}

+(NSString*) getResultNlDateDesc:(TDateInfo*) date
{
	if (!date)
	{
		return @"";
	}
	
	DateInfo info(date.year, date.month, date.day); 
	LunarInfo lunar = Calendar::GetLunarInfoByYanLi(info); 		
	NSString *strNongLi = [NSString stringWithFormat:@"星期%@ %@月%@ %@月 %@日 %@", 
						[NSString stringWithCString:Calendar::DayOfWeekZhou(info) encoding: NSUTF8StringEncoding],
						[NSString stringWithCString: lunar.monthname.c_str() encoding:NSUTF8StringEncoding],
						[NSString stringWithCString: lunar.dayname.c_str() encoding:NSUTF8StringEncoding],
						[NSString stringWithCString: Calendar::GetLlGZMonth(Calendar::Lunar(info)).c_str() encoding:NSUTF8StringEncoding],  
						[NSString stringWithCString: Calendar::GetLlGZDay(info).c_str() encoding:NSUTF8StringEncoding],
						[NSString stringWithCString: lunar.shenxiao.c_str() encoding:NSUTF8StringEncoding]						 
						];
	
	return strNongLi;
}

@end



#pragma mark -
#pragma mark 用户本地缓存数据
@implementation TUserLocalData

@synthesize sGroupKey, sGroupItem, sItemCode, sItemValue, sItemNote, sItemText;
@synthesize iID, iItemNo;

-(void)dealloc
{
	self.sGroupKey = nil;
	self.sGroupItem = nil;
	self.sItemCode = nil;
	self.sItemValue = nil;
	self.sItemNote = nil;
	self.sItemText = nil;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 天气城市管理

@implementation TCityData

@synthesize iType;
@synthesize sID;
@synthesize sName;

-(void)dealloc
{
	self.iType = ECityType_None;
	self.sID = nil;
	self.sName = nil;
	
	[super dealloc];
}

@end

@implementation TCityDataDetail

@synthesize datCity;
@synthesize datProv;

-(void)dealloc
{
	self.datCity = nil;
	self.datProv = nil;
	
	[super dealloc];
}

@end



#pragma mark -
#pragma mark 速配业务数据结构定义

#pragma mark -
#pragma mark 星座匹配
@implementation TXingZuoMatch

@synthesize sManXingzuo;	
@synthesize sWomanXingzuo;
@synthesize iScore;				
@synthesize sPropotion;	
@synthesize sExplain;		
@synthesize sAttention;	


-(void)dealloc
{
	self.sManXingzuo = nil;
	self.sWomanXingzuo = nil;
	self.sPropotion = nil;
	self.sExplain = nil;
	self.sAttention = nil;

	[super dealloc];
	
}
@end


#pragma mark -
#pragma mark 生肖匹配
@implementation TShengxiaoMatch

@synthesize iLevel;					
@synthesize sTitle;		
@synthesize sContent;			


-(void)dealloc
{
	self.sTitle = nil;
	self.sContent = nil;
	
	[super dealloc];
	
}

@end


#pragma mark -
#pragma mark 生日匹配
@implementation TBirthdayMatch

@synthesize nLevel;				
@synthesize strExplain;	
@synthesize strManBirthExp;
@synthesize strWomanBirthExp;

-(void)dealloc
{
	self.strExplain = nil;
	self.strManBirthExp = nil;
	self.strWomanBirthExp = nil;
	
	[super dealloc];
	
}

@end


#pragma mark -
#pragma mark 号码测试-手机号

@implementation TTelephoneJiXiong

@synthesize strPctemp;	
@synthesize strTelResult;	

-(void)dealloc
{
	self.strPctemp = nil;
	self.strTelResult = nil;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 抽签和掷杯
@implementation TCastLots

@synthesize iRandNum;		
@synthesize sNumber;		
@synthesize sStandOrFall;	
@synthesize sStory;			
@synthesize sPoetry;		
@synthesize sParaphrase;	
@synthesize sResult;		
@synthesize sParticularStory;

-(void) dealloc
{
	self.sNumber = nil;		
	self.sStandOrFall = nil;	
	self.sStory = nil;			
	self.sPoetry = nil;		
	self.sParaphrase = nil;	
	self.sResult = nil;		
	self.sParticularStory = nil;

	[super dealloc];
}

@end


#pragma mark -
#pragma mark 周公解禁
@implementation TParseDream

@synthesize sSort;	
@synthesize sDream;		
@synthesize sResult;

-(void) dealloc
{
	self.sSort = nil;	
	self.sDream = nil;		
	self.sResult = nil;
	
	[super dealloc];
}

@end



#pragma mark -
#pragma mark 悬赏&建议
@implementation TSuggestItem

@synthesize sQuestNO;
@synthesize sQuestion;	
@synthesize sAskTime;
@synthesize iFlag;

-(void)dealloc
{
	self.sQuestNO = nil;
	self.sQuestion = nil;
	self.sAskTime = nil;
	self.iFlag = 0;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 悬赏&建议-回复
@implementation TAnswerItem

@synthesize sQuestNO;
@synthesize sAnswer;	
@synthesize sAnsTime;

-(void)dealloc
{
	self.sQuestNO = nil;
	self.sAnswer = nil;
	self.sAnsTime = nil;
	
	[super dealloc];
}

@end



#pragma mark -
#pragma mark 悬赏&建议－问题&回复
@implementation TQuestionAnswer

@synthesize itemQuest;
@synthesize aryAnswer;	

-(void)dealloc
{
	self.itemQuest = nil;
	
	if(self.aryAnswer)
	{
		[self.aryAnswer removeAllObjects];
	}
	self.aryAnswer = nil;
	
	[super dealloc];
}

@end


//add 2012.10.23
//notebook 结构
//共通结构头, 每个需要同步的结构，如NOTE、ITEM内部都会包含一个此结构
#pragma mark -
#pragma mark 共通结构头
@implementation TRecHead

@synthesize nUserID;
@synthesize nCurrVerID;
@synthesize nCreateVerID;

@synthesize strCreateTime;
@synthesize strModTime;

@synthesize nDelState;
@synthesize nEditState;
@synthesize nConflictState;
@synthesize nSyncState;
@synthesize nNeedUpload;

-(void)dealloc
{
	self.strCreateTime = nil;
	self.strModTime = nil;
	
	[super dealloc];
}

@end



#pragma mark -
#pragma mark 目录信息表
@implementation TCateInfo

@synthesize tHead;
@synthesize strCatalogIdGuid;
@synthesize strCatalogBelongToGuid;
@synthesize strCatalogPaht1Guid;
@synthesize strCatalogPaht2Guid;
@synthesize strCatalogPaht3Guid;
@synthesize strCatalogPaht4Guid;
@synthesize strCatalogPaht5Guid;
@synthesize strCatalogPaht6Guid;

@synthesize nOrder;
@synthesize strCatalogName;

@synthesize nEncryptFlag;
@synthesize strVerifyData;

@synthesize nCatalogType;
@synthesize nCatalogColor;
@synthesize nCatalogIcon;
@synthesize nMobileFlag;
@synthesize nNoteCount;

@synthesize nIsRoot;
@synthesize nSyncFlag;

@synthesize nCurdayNoteCount;

-(void)dealloc
{
    self.tHead = nil;
    self.strCatalogIdGuid = nil;
    self.strCatalogBelongToGuid = nil;
    self.strCatalogPaht1Guid = nil;
    self.strCatalogPaht2Guid = nil;
    self.strCatalogPaht3Guid = nil;
    self.strCatalogPaht4Guid = nil;
    self.strCatalogPaht5Guid = nil;
    self.strCatalogPaht6Guid = nil;
    self.strCatalogName = nil;
    self.strVerifyData = nil;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 笔记信息表
@implementation TNoteInfo

@synthesize tHead;
@synthesize strCatalogIdGuid;
@synthesize strNoteIdGuid;
@synthesize strNoteTitle; 
@synthesize nNoteType;
@synthesize nNoteSize;

@synthesize strFilePath;
@synthesize strFileExt;
@synthesize strEditLocation;
@synthesize strNoteSrc;

@synthesize strFirstItemGuid;
@synthesize nShareMode;
@synthesize nEncryptFlag;

@synthesize nNeedDownlord;
@synthesize nOwnerId;
@synthesize nFromId; 

@synthesize nStarLevel;
@synthesize strExpiredDate;
@synthesize strFinishDate;
@synthesize	nFinishState;

@synthesize strContent;

@synthesize nFailTimes;
@synthesize strNoteClassId;
@synthesize nFriend;
@synthesize nSendSMS;
@synthesize strJYEXTag;

-(void)dealloc
{
    self.tHead = nil;
    self.strCatalogIdGuid = nil;
    self.strNoteIdGuid = nil;
    self.strNoteTitle = nil;
    
    self.strFilePath = nil;
    self.strFileExt = nil;
    self.strEditLocation = nil;
    self.strNoteSrc = nil;
    
    self.strFirstItemGuid = nil;
 
    self.strExpiredDate = nil;
    self.strFinishDate = nil;
    
    self.strContent = nil;
	self.strNoteClassId = nil;
    self.strJYEXTag = nil;
	[super dealloc];
}

@end

//项目信息表
#pragma mark -
#pragma mark 项目信息表
@implementation TItemInfo

@synthesize tHead;

@synthesize strItemIdGuid;
@synthesize nCreatorID;
@synthesize nItemType;
@synthesize strItemExt;
@synthesize nItemSize; 
@synthesize nEncryptFlag;
@synthesize strItemTitle;
@synthesize strNoteIdGuid;
@synthesize nUploadSize;
@synthesize strServerPath;

-(void)dealloc
{
    self.tHead = nil;    
    self.strItemIdGuid = nil;
    self.strNoteIdGuid = nil;
    self.strItemExt = nil;
    self.strItemTitle = nil;
	self.strServerPath = nil;
	[super dealloc];
}

@end

#pragma mark -
#pragma mark 笔记和项目关联表
@implementation TNoteXItem

@synthesize tHead;
@synthesize strNoteIdGuid;
@synthesize strItemIdGuid;
@synthesize nCreatorID;
@synthesize strCatalogBelongToGuid;
@synthesize nItemVer;
@synthesize nNeedDownlord; 
@synthesize nItemOrder; 

-(void)dealloc
{
    self.tHead = nil;
    self.strNoteIdGuid = nil;
    self.strItemIdGuid = nil;
    self.strCatalogBelongToGuid = nil;
	
	[super dealloc];
}

@end


#pragma mark -
#pragma mark 文件夹版本信息表
@implementation TCatalogVersionInfo

@synthesize nUserID;
@synthesize strCatalogBelongToGuid;
@synthesize strTableName;
@synthesize nMaxVer;

-(void)dealloc
{
    self.nUserID = nil;
    self.strCatalogBelongToGuid = nil;
    self.strTableName = nil;
    self.nMaxVer = nil;
	
	[super dealloc];
}

@end



