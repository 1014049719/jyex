//
//  DischargeMgr.m
//  NoteBook
//
//  Created by wangsc on 10-9-25.
//  Copyright 2010 ND. All rights reserved.
//

#import "DischargeMgr.h"
#import "Global.h"
#import "DBObject.h"

@implementation DischargeMgr

+ (void)checkDischargeInfo
{
    if (![self isTodayRecorded])
    {
        [self insertToday];
    }

    if (![self isCardActive])
    {
        [self insertACardInfo];
    }
}

+ (BOOL)isTodayRecorded
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"select * from tb_charge_info where day = '%@';", [CommonFunc getCurrentDate]];
    try
    {
        CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
        if (!query.eof())
        {
            query.finalize();
            return YES;
        }
    }
    catch (CppSQLite3Exception e) 
    {
        MLOG(@"SQL: %s\n Exception:%s", [sql UTF8String], e.errorMessage());
        return NO;
    }
	return NO;
}

+ (BOOL)insertToday
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"insert into tb_charge_info (day,flow,imsi) values('%@',0,'%@');",[CommonFunc getCurrentDate],[Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet > 0)
    {
        return YES;
    }
	return NO;
}

+ (BOOL)addFlows:(int) bytes
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"update tb_charge_info set flow = flow + %d where day = '%@' and imsi = '%@';",
                      bytes,[Global GetCurrentDate],[Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet <= 0)
    {
        MLOG(@"addFlows failed;");
        return NO;
    }
    
	return YES;
}

+ (uint64_t)getDishargeSince:(NSString *)date
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return 0;
    }
    
    uint64_t ret = 0;
	NSString * sql = nil;
	if([date isEqualToString:[CommonFunc getCurrentDate]])
	{
		sql = [NSString stringWithFormat:@"select sum(flow) from tb_charge_info where day = date('%@') and imsi = '%@';",[Global GetCurrentDate],[Global getIMSI]];
	}
    else
	{
		sql = [NSString stringWithFormat:@"select sum(flow) from tb_charge_info where (day > date('%@') and day <= date('%@')) and imsi = '%@';",date,[Global GetCurrentDate],[Global getIMSI]];
	}
    
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return ret;
    }
    
    ret = query.getIntField(0, 0.0f);
    query.finalize();
    return ret;
}

+ (NSString *)getLastUpdateDay
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return nil;
    }
    
    NSString * ret = nil;
	NSString * sql = [NSString stringWithFormat:@"select max(day) from tb_charge_info where imsi = '%@'", [Global getIMSI]];
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return ret;
    }
    
    ret = [NSString stringWithUTF8String:query.getStringField(0, "")];
    query.finalize();
    return ret;
}

+ (int)getMaxDisCharge
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return 0;
    }
    
    int ret = nil;
	NSString * sql = [NSString stringWithFormat:@"select max_discharge from tb_card_info where imsi = '%@';",[Global getIMSI]];
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return -1;
    }
    
    ret = query.getIntField(0, -1);
    query.finalize();
    return ret;
}

+ (BOOL)setMaxDisCharge:(int)maxCharge
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"update tb_card_info set max_discharge = %d where imsi = '%@';", maxCharge, [Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet >= 0)
    {
        return YES;
    }
	return NO;
}

+ (int)getClearDay
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return 0;
    }
    
    int ret;
	NSString * sql = [NSString stringWithFormat:@"select clear_day from tb_card_info where imsi = '%@';",[Global getIMSI]];
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return 0;
    }
    
    ret = query.getIntField(0, 0);
    query.finalize();
    return ret;
}

+ (BOOL)setClearDay:(int)clearDay
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"update tb_card_info set clear_day = %d where imsi = '%@';", clearDay, [Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet >= 0)
    {
        return YES;
    }
	return NO;
}

+ (BOOL)getGPRSFlag
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    BOOL  ret = YES;
	NSString * sql = [NSString stringWithFormat:@"select gprs_flag from tb_card_info where imsi = '%@';",[Global getIMSI]];
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return nil;
    }
    
    ret = query.getIntField(0, 1);
    query.finalize();
	return ret;
}

+ (BOOL)setGPRSFlag:(BOOL)flag
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"update tb_card_info set gprs_flag = %d where imsi = '%@';",flag,[Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet >= 0)
    {
        return YES;
    }
	return NO;
}

+ (BOOL)isCardActive
{
    NSString * sql = [NSString stringWithFormat:@"select * from tb_card_info where imsi = '%@';",[Global getIMSI]];
    CppSQLite3Query query = [[DBObject shareDB] execQuery:[sql UTF8String]];
    if (query.eof())
    {
        return NO;
    }
    query.finalize();
    return YES;
}

+ (BOOL)insertACardInfo
{
    if (![[DBObject shareDB] isOpen])
    {
        MLOG(@"数据库未连接");
        return NO;
    }
    
    NSString * sql = [NSString stringWithFormat:@"insert into tb_card_info(imsi,max_discharge,clear_day,gprs_flag) values('%@',15,1,1);",
					  [Global getIMSI]];
    int nRet = [[DBObject shareDB] execDML:[sql UTF8String]];
    if (nRet >= 0)
    {
        return YES;
    }
	return NO;
}

@end
