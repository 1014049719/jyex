//
//  Categorys.mm
//  NoteBook
//
//  Created by wangsc on 10-9-28.
//  Copyright 2010 ND. All rights reserved.
//

#import "Categorys.h"
#import "CommonDefine.h"

@implementation NSString (UnicodeStringConvert)

+ (id)stringWithUnistring:(unistring)wstrSrc
{
    NSString *ret = [NSString stringWithCharacters:wstrSrc.c_str() length:wstrSrc.length()];
    return ret;
}

- (id)initWithUnistring:(unistring)wstrSrc
{
    NSString *ret = [[NSString alloc] initWithCharacters:wstrSrc.c_str() length:wstrSrc.length()];
    return ret;
}

- (unistring)getUnistring
{
    int nLen = [self length] + 1;
    unichar * pBuf = new unichar[nLen];
    ZeroMemory(pBuf, sizeof(unichar) * nLen);
    [self getCharacters:pBuf];
    unistring strRet = pBuf;
    delete [] pBuf;
    return strRet;
}

@end