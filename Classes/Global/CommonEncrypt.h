//
//  Common.h
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "Common.h"
#import "EncryptMD5.h"


#define RSA_KEY_BASE64 \
@"MIICfjCCAeegAwIBAgIBATANBgkqhkiG9w0BAQUFADBxMQswCQYDVQQGEwJDTjER\
MA8GA1UECBMIU09GVFdBUkUxDzANBgNVBAcTBkZVWkhPVTELMAkGA1UEChMCTkQx\
CzAJBgNVBAsTAllSMQwwCgYDVQQDEwNNaXIxFjAUBgkqhkiG9w0BCQEWBzFAMi5j\
b20wHhcNMTIwMjAyMDIwNTM5WhcNMTMwMjAxMDIwNTM5WjBgMQswCQYDVQQGEwJD\
TjERMA8GA1UECBMIU09GVFdBUkUxCzAJBgNVBAoTAk5EMQswCQYDVQQLEwJZUjEM\
MAoGA1UEAxMDTWlyMRYwFAYJKoZIhvcNAQkBFgcxQDIuY29tMFwwDQYJKoZIhvcN\
AQEBBQADSwAwSAJBALLcKmozjJETHLuTEHPhR7aSSG5e0q7rMN4rS2xHA6fGn2D5\
KsZKFRk12BRYrLZH5icQzX4S+615taZIGvoHX+kCAwEAAaN7MHkwCQYDVR0TBAIw\
ADAsBglghkgBhvhCAQ0EHxYdT3BlblNTTCBHZW5lcmF0ZWQgQ2VydGlmaWNhdGUw\
HQYDVR0OBBYEFD/2+FxfOpwcSnEOaL6rRY9fQuYvMB8GA1UdIwQYMBaAFIXbaARO\
zgtT+Mur0SeHrtebESD3MA0GCSqGSIb3DQEBBQUAA4GBAMyHuNTiQZa1AzWooZyR\
l8D/AE0TTZyfi1mxSs+/6HTtCLtxPnUcDrgMZE7Y6Pz6wkBQ2FMnFfyjHY1DHf6F\
4dqGldnglVCBLs8oUlbA7zcHWtrXn09S2m+rwMOB5Pl0x/5WAY6EwZAKvqEg+UDS\
YARxM2r9PSgPno5tcym9pGlR"


@interface CommonFunc (ForEncrypt)
{
    
}

// 加解密对外接口函数
+ (BOOL)encrypt_Tea:(const unsigned char*)pszSrcBuf len:(int)nInLen buf:(unsigned char*)pszDesBuf outLen:(int*)nOutLen key:(unsigned char*)pszKey;
+ (BOOL)decrypt_Tea:(const unsigned char*)pszSrcBuf len:(int)nInLen buf:(unsigned char*)pszDesBuf outLen:(int*)nOutLen key:(unsigned char*)pszKey;
// 密码正确性的验证字段 产生 和 验证
+ (BOOL)createCheckBlock:(unsigned char*)pCheckBuf len:(int)nLen;
+ (BOOL)VerifyCheckBlock:(unsigned char*)pCheckBuf len:(int)nLen;


+ (SecKeyRef) getPublicKey: (NSString*) rsaKeyBase64;
+ (NSString*) rsaEncryptString: (NSString*) rsaKeyBase64 :(NSString*) string;


@end

