//
//  CfgMgr.h
//  NoteBook
//
//  Created by wangsc on 10-9-20.
//  Copyright 2010 ND. All rights reserved.
//
#import "DBMng.h"

#pragma mark -
#pragma mark 数据库管理-cfgMgr
@interface AstroDBMng (ForcfgMgr)

+ (BOOL)getCfg_cfgMgr:(NSString *)strKey name:(NSString*)strName value:(NSString *&)strValue;
+ (int)setCfg_cfgMgr:(NSString *)strKey name:(NSString*)strName value:(NSString *&)strValue;


@end

