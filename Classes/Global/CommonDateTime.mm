//
//  Common.mm
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "CommonDateTime.h"


@implementation CommonFunc (ForDateTime)


+ (NSString*)getCurrentTime
{
    NSDate *now = [NSDate date];
	
	NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
	[forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[forMatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	
	NSString* strDate = [forMatter  stringFromDate:now];
    [forMatter release];
	return  strDate;
}

/*
+ (void)getCurrentTimeA:(char*)pBuf
{
    string strTime = [[self getCurrentTime] UTF8String];
    strcpy(pBuf, strTime.c_str());
}

+ (void)getCurrentTimeW:(unichar*)pBuf
{
    string strTime = [[self getCurrentTime] UTF8String];
    unistring wstrTime = [self utf8ToUnicode:strTime];
    wcscpy_m((char*)pBuf, (const char*)wstrTime.c_str());
}
*/

+ (NSString*)getCurrentDate
{
    NSDate *now = [NSDate date];
	
	NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
	[forMatter setDateFormat:@"yyyy-MM-dd"];
    [forMatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	
	NSString* strDate = [forMatter  stringFromDate:now];
	[forMatter release];
	return  strDate;
}


+(NSDate *)get1970Date {
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setYear:1970];
	[comps setMonth:1];
	[comps setDay:1];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];	
	return [calendar dateFromComponents:comps];
}

+(NSDate *)dateFromIntervalSince1970:(NSTimeInterval)interval {
	NSDate *date1970 = [CommonFunc get1970Date];
	return [date1970 dateByAddingTimeInterval:interval];
}

+(NSString *) getTimeString:(NSDate *)date format:(NSString *)strFormat {
	NSString *format = strFormat;
	if (nil == format) {
		format = @"yyyy-MM-dd HH:mm:ss";
	}
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	return [formatter stringFromDate:date];
}

+(NSString *)getTimeString:(NSTimeInterval)interval withFormat:(NSString *)strFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];//[CommonFunc dateFromIntervalSince1970:interval];
    NSString *format = strFormat;
	if (nil == format) {
		format = @"yyyy-MM-dd HH:mm:ss";
	}
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	return [formatter stringFromDate:date];
}

@end


