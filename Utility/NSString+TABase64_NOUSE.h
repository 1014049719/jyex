//
//  NSStringBase64.h
//  TQAP_Common_Basic
//
//  Created by chenyan on 12-3-15.
//  Copyright (c) 2012年 TQND. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Base64)

- (NSString*) encodeBase64;

- (NSString*) decodeBase64;

- (const void*) decodeBytes;

+ (NSString*) stringWithEncodeBytes:(void*)pData 
                                len:(NSUInteger)length;

@end
