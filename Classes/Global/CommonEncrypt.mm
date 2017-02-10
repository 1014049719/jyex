//
//  Common.mm
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "CommonEncrypt.h"
#import "Constant.h"
#import "CommonDefine.h"
#import "PFunctions.h"
#import "Global.h"



void Tran2LittleEndian(int* p, int i)
{
    while (i >= 0)
    {
        *(p + i) = ntohl(*(p + i));
        i--;
    }
    
}

// 加解密实现函数
bool _Encrypt_Tea(int* v, int n, int* k)
{
	if (n <= 1)
	{
		return false;
	}
	unsigned int z/*=v[n-1]*/, y=v[0], sum=0,  e,    DELTA=0x9e3779b9 ;
	int p, q ;
	z = v[n-1];
	q = 6+52/n ;
	while ( q-- > 0 )
	{
		sum += DELTA ;
		e = sum >> 2&3 ;
		for ( p = 0 ; p < n-1 ; p++ )
		{
			y = v[p+1];
			z = v[p] += (z>>5^y<<2)+(y>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
		}
        
		y = v[0] ;
		z = v[n-1] += (z>>5^y<<2)+(y>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
	}
	return true;
    
}

bool _Decrypt_Tea(int *v, int n, int *k)
{
	if (n <= 1)
	{
		return false;
	}
	unsigned int z, y=v[0], sum=0,  e,    DELTA=0x9e3779b9 ;
	int p, q ;
	q = 6+52/n ;
	sum = q*DELTA ;
	while (sum != 0) {
		e = sum>>2 & 3 ;
		for (p = n-1 ; p > 0 ; p-- ){
			z = v[p-1],
            y = v[p] -= (z>>5^y<<2)+(y>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
		}
		z = v[n-1] ;
		y = v[0] -= (z>>5^y<<2)+(y>>3^z<<4)^(sum^y)+(k[p&3^e]^z);
		sum -= DELTA ;
	}
	return true;
}



@implementation CommonFunc  (ForEncrypt)

// 加解密对外接口函数
+ (BOOL)encrypt_Tea:(const unsigned char*)pszSrcBuf len:(int)nInLen buf:(unsigned char*)pszDesBuf outLen:(int*)nOutLen key:(unsigned char*)pszKey
{
    if (NULL == pszSrcBuf || NULL == pszDesBuf || NULL == pszKey)
    {
        return NO;
    }
    
    // nOutLen的长度要加上自身4个字节长度
    if (*nOutLen < ((nInLen + 4 - 1) / 4 + 1) * 4)
    {
        return NO;
    }
    
    // 不足4位的补零
    *nOutLen = ((nInLen - 1 + 4) / 4 + 1) * 4;
    
    ZeroMemory(pszDesBuf, *nOutLen);
    // 将要加密的数据拷贝出来
    memcpy(pszDesBuf + 4, pszSrcBuf, nInLen);
    
    int* pTobeEncrypt = (int *)pszDesBuf;
    *pTobeEncrypt = nInLen;
    int* pKey = (int *)pszKey;
    
    // 将输入字符的转换为网络字节，指针从 0基址 开始
    Tran2LittleEndian(pTobeEncrypt,  *nOutLen / 4 - 1);
    Tran2LittleEndian(pKey, (128 / 8) / (sizeof(int) / sizeof(char)) - 1);
    
    // 加密运算
    if (!_Encrypt_Tea(pTobeEncrypt, *nOutLen / 4, pKey))
    {
        return NO;
    }
    
    Tran2LittleEndian(pTobeEncrypt,  *nOutLen / 4 - 1);
    Tran2LittleEndian(pKey, (128 / 8) / (sizeof(int) / sizeof(char)) - 1);
    
    return YES;
}

+ (BOOL)decrypt_Tea:(const unsigned char*)pszSrcBuf len:(int)nInLen buf:(unsigned char*)pszDesBuf outLen:(int*)nOutLen key:(unsigned char*)pszKey
{
    // 输入的数据长度应该是4字节的倍数,
    // 输入字符接收解密字符要求不比(加密字符 - 4)短,即去除掉4字节的长度位，以可能的最大数据来接收
    if ((nInLen & 0x03) != 0 && *nOutLen < nInLen - 4)
    {
        return NO;
    }
    
    if (NULL == pszSrcBuf || NULL == pszDesBuf || NULL == pszKey)
    {
        return NO;
    }
    
    unsigned char* pszTempBuf = new unsigned char[nInLen];
    memcpy(pszTempBuf, pszSrcBuf, nInLen);
    int* pTobeDecrypt   = (int *)pszTempBuf;
    int* pKey           = (int *)pszKey;
    
    // 将输入字符的转换为网络字节，指针从 0基址 开始
    Tran2LittleEndian(pTobeDecrypt, nInLen / 4 - 1);
    Tran2LittleEndian(pKey, (128 / 8) / (sizeof(int) / sizeof(char)) - 1);
    
    if (!_Decrypt_Tea(pTobeDecrypt, nInLen / 4, pKey))
    {
        SAFE_DELETE_ARRAY(pszTempBuf);
        return NO;
    }
    
    // 将字符从网络顺序转换为主机顺序，指针从 0基址 开始
    Tran2LittleEndian(pTobeDecrypt, nInLen / 4 - 1);
    Tran2LittleEndian(pKey, (128 / 8) / (sizeof(int) / sizeof(char)) - 1);
    
    
    // 前4个字节标识实际长度（不包括本身）
    if (*nOutLen < *pTobeDecrypt || 0 > *pTobeDecrypt)
    {
        memcpy(pszDesBuf, pTobeDecrypt + 1, 8);
        SAFE_DELETE_ARRAY(pszTempBuf);
        return NO;
    }
    *nOutLen = *pTobeDecrypt;
    memcpy(pszDesBuf, pTobeDecrypt + 1, *nOutLen);
    
    SAFE_DELETE_ARRAY(pszTempBuf);
    return YES;
}

// 密码正确性的验证字段 产生 和 验证
+ (BOOL)createCheckBlock:(unsigned char*)pCheckBuf len:(int)nLen
{
    if (nLen < 8)
    {
        return NO;
    }
    
    srand( (unsigned)time( NULL ) );
    
    int nRand = rand();
    
    // 前4个字节存储产生MD5的源数据
    memcpy(pCheckBuf, &nRand, sizeof(int));
    // 后4个字节存储产生的MD5 校验码的前2个字节(被扩展成ANSI形式，两个字节代表一个字节信息)
    unsigned char szMd5Result[32];
    MD5_GetMD5a((char *)&nRand, sizeof(int), (char *)szMd5Result);
    memcpy(pCheckBuf + 4, szMd5Result, 4);
    
    return YES;
}

+ (BOOL)VerifyCheckBlock:(unsigned char*)pCheckBuf len:(int)nLen
{
    if (nLen != 8)
    {
        return NO;
    }
    
    unsigned char szMd5Result[32];
    // 通过输入字符的前4个字节，取得16字节的MD5校验码
    MD5_GetMD5a((char *)pCheckBuf, nLen / 2, (char *)szMd5Result);
    
    // 取MD5校验码的前4个字节，与输入字符的后4个字节进行对比，如果相同，说明解密的结果是正确的
    if (0 != memcmp(pCheckBuf + 4, szMd5Result, 4))
    {
        return NO;
    }
    return YES;
}



#pragma mark -
#pragma mark rsa

SecKeyRef _public_key=nil;
+ (SecKeyRef) getPublicKey: (NSString*) rsaKeyBase64{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
	if(_public_key == nil){
		NSData *certificateData = [NSData dataWithBase64EncodedString:rsaKeyBase64];  
		
		SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
		SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
		SecTrustRef myTrust;
		OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
		SecTrustResultType trustResult;
		if (status == noErr) {
			status = SecTrustEvaluate(myTrust, &trustResult);
		}
		_public_key = SecTrustCopyPublicKey(myTrust);
		CFRelease(myCertificate);
		CFRelease(myPolicy);
		CFRelease(myTrust);
	}
	return _public_key;
}

+ (NSString*) rsaEncryptString: (NSString*) rsaKeyBase64 :(NSString*) string
{
	SecKeyRef key = [CommonFunc getPublicKey: rsaKeyBase64];
	size_t cipherBufferSize = SecKeyGetBlockSize(key);
	uint8_t *cipherBuffer = (uint8_t *)malloc(cipherBufferSize * sizeof(uint8_t));
	NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
	size_t blockSize = cipherBufferSize - 11;
	size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
	NSMutableData *encryptedData = [[[NSMutableData alloc] init] autorelease];
	for (int i=0; i<blockCount; i++) {
		int bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
		NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
		OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
										[buffer length], cipherBuffer, &cipherBufferSize);
		if (status == noErr){
			NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
			[encryptedData appendData:encryptedBytes];
			[encryptedBytes release];
		}else{
			if (cipherBuffer) free(cipherBuffer);
			return nil;
		}
	}
	if (cipherBuffer) free(cipherBuffer);
	//  NSLog(@"Encrypted text (%d bytes): %@", [encryptedData length], [encryptedData description]);
	//  NSLog(@"Encrypted text base64: %@", [Base64 encode:encryptedData]);
	
    NSString *newStr = [encryptedData base64Encoding];
	return newStr;
}



@end


