//
//  DischargeMgr.h
//  NoteBook
//
//  Created by wangsc on 10-9-25.
//  Copyright 2010 ND. All rights reserved.
//

#include "MyStruct.h"
#include "MBBaseStruct.h"
#include "ObjMgr.h"

@interface DischargeMgr : NSObject 
{

}

+ (void)checkDischargeInfo;

+ (BOOL)isTodayRecorded;
+ (BOOL)insertToday;
+ (BOOL)addFlows:(int) bytes;
+ (uint64_t)getDishargeSince:(NSString *)date;
+ (NSString *)getLastUpdateDay;

+ (int)getMaxDisCharge;
+ (BOOL)setMaxDisCharge:(int)maxCharge;
+ (int)getClearDay;
+ (BOOL)setClearDay:(int)clearDay;
+ (BOOL)getGPRSFlag;
+ (BOOL)setGPRSFlag:(BOOL)flag;
+ (BOOL)isCardActive;
+ (BOOL)insertACardInfo;

@end
