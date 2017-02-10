//
//  CfgMgr.m
//  NoteBook
//
//  Created by wangsc on 10-9-20.
//  Copyright 2010 ND. All rights reserved.
//

#import "CfgMgr.h"

#import "DbMngDataDef.h"

#import "ComCustomConstantDef.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "BussComdIDDef.h"

@implementation AstroDBMng (ForcfgMgr)


+ (BOOL)getCfg_cfgMgr:(NSString *)strKey name:(NSString*)strName value:(NSString *&)strValue
{
    @try
	{
		NSString* sql = [NSString stringWithFormat:@"SELECT * FROM tb_config_info WHERE sKey='%@' AND sName='%@';",strKey,strName];
		CppSQLite3Query query = [[AstroDBMng getDb91Note] execQuery:sql];
		if ( !query.Eof()) 
		{ 
            strValue = [NSString stringWithUTF8String:query.GetStringField("BData","")]; 
            return YES;
		}
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"查询配置失败失败!");
		return NO;
	}
	return NO;
}

+ (int)setCfg_cfgMgr:(NSString *)strKey name:(NSString*)strName value:(NSString *&)strValue
{        
    @try
	{
		NSString* sql = @"replace into tb_config_info"
						 "( [sKey],"
						 "[sName], "
						 "[BData] )"
						 "values(?,?,?);";
		
		DbItem *db = [AstroDBMng getDb91Note];
		CppSQLite3Statement stmt;
		if (![db pepareStatement:sql Statement:&stmt])
		{
			LOG_ERROR(@"更新配置信息表出错");
			return -1;
		}
		
		int i = 1;
		stmt.Bind(i++, [strKey UTF8String]);
		stmt.Bind(i++, [strName UTF8String]);
		stmt.Bind(i++, [strValue UTF8String]);
		
		return [db commitStatement:&stmt];
	}
	@catch (NSException * e)
	{
		LOG_ERROR(@"更新配置信息表出错");
		return -1;
	}
	return -1; 
}

@end