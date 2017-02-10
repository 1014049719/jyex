//
//  Categorys.h
//  NoteBook
//
//  Created by wangsc on 10-9-28.
//  Copyright 2010 ND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyStruct.h"

@interface NSString (UnicodeStringConvert)

+ (id)stringWithUnistring:(unistring)wstrSrc;
- (id)initWithUnistring:(unistring)wstrSrc;
- (unistring)getUnistring;

@end
