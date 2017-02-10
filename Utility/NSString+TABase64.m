//
//  NSString+TABase64.m
//  TQAP_Common_Basic
//
//  Created by chenyan on 12-3-15.
//  Copyright (c) 2012年 TQND. All rights reserved.
//

#import "NSString+TABase64.h"
#import "TAGTMBase64Ex.h"

@implementation NSString(TABase64)


- (NSString*)encodeBase64{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [TAGTMBase64Ex encodeData:data]; 
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String; 
}

- (NSString*)decodeBase64{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [TAGTMBase64Ex decodeData:data]; 
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String; 
}

- (const void*)decodeBytes{
    NSData * data = nil;
//#if 0
//	data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
//	data = [TAGTMBase64Ex decodeData:data];
//#else
    
	data = [TAGTMBase64Ex decodeBytes:[self UTF8String] length:[self length]];
//#endif
	return data.bytes; 
}

+ (NSString*)stringWithEncodeBytes:(void*)pData 
                               len:(NSUInteger)length{
    NSData * data = nil;
//#if 1
	data = [TAGTMBase64Ex encodeBytes:pData length:length];
//#else
//	data = [TAGTMBase64Ex encodeData:[NSData dataWithBytes:pData length:length]]; 
//#endif
	NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String;
}
@end
