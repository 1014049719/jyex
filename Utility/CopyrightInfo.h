//
//  CopyrightInfo.h
//  Astro
//
//  Created by root on 12-2-22.
//  Copyright 2012 洋基科技. All rights reserved.
//

#import <Foundation/Foundation.h>


enum ELanguageType
{
	ELANG_OTHER,	//其他
	ELANG_JT,	//简体中文
	ELANG_FT	//繁体中文
};

@interface CopyrightInfo : NSObject

//文件名
+(NSString*) resourceFileName;
+(NSString*) resourcePathOfCopyright;
+(NSString*) getCopyrightInfo;

@end
