//
//  Common.h
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DbMngDataDef.h"


@interface CommonFunc : NSObject
{
    
}

+ (NSString*)createGUIDStr;

+ (NSString*)getNoteTypeName:(ENUM_NOTE_TYPE)noteType;
+ (NSString*)getItemTypeExt:(ENUM_ITEM_TYPE)itemType;
+ (NSString*)getStreamTypeByExt:(NSString *)strExt;


//+ (GUID)createGUID;
//+ (string)guidToString:(GUID)guid;
//+ (NSString*)guidToNSString:(GUID)guid;
//+ (GUID)stringToGUID:(string)str;
//+ (GUID)nsstringToGUID:(NSString*)str;
//+ (string)transSqliteStr:(string)strSrc;
//+ (string)transSqliteStrW:(unistring)strSrc;
//+ (NSString *) checkSQLValueForField:(NSString *)strValue;

//+ (string)intToStr:(int)num;
//+ (string)i2a:(int)num;
//+ (string)ul2a:(unsigned long)ulnum;

//+ (string)unicodeToUTF8:(unistring)unicodeString;
//+ (void)utf8ToUnicode:(string)strUTF8 buffer:(unichar*)szBuf;
//+ (unistring)utf8ToUnicode:(string)strUTF8;

//+ (unsigned int)getUnicodeLength:(unsigned char *)p;


+ (NSString *)osVersionString;
//+ (NSString *)platformString;
//+ (NSString *)deviceUniqueIDString;

//获取应用程序版本号
+(NSString *)getAppVersion;
//获取应用名称
+(NSString *)getAppName;


//家园E线
+(NSString*)getAppAddressWithAppCode:(NSString*)sAppCode;
//资源图片
+(NSString*)getResourceNameWithAppCode:(NSString*)appCode;

+(int)getBtnTagWithCode:(NSString*)sCode;
+(NSString *)getAppCodeWithBtnTag:(int)tag;

@end


