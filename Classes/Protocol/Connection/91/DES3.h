/*
 *  DES3.h
 *  des
 *
 *  Created by jiangwei she on 09-8-20.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef DES3_H_
#define DES3_H_



#if defined __cplusplus
extern "C"
{
#endif

typedef enum _DES3_MODE
{
	DES_ECB = 0,				//电码本模式，每8个字节进行独立加密跟解密
	DES_CBC						//密码连接模式，每8个字节加密后跟前8个字节进行异或操作，防止相同字节串，生成相同的密文
}DES_MODE;
	
	
typedef enum _PAD_MODE
{
	PAD_ISO_1 = 0,				//不够的字节数全部补0，用这种填充模式的明文最好经过base64或其它编码
	PAD_ISO_2,					//不够的字节数中的第一个字节补0x80,剩余的字节补0，用这种填充模式的明文最好经过base64或其它编码
	PAD_PKCS_7					//不够的字节数补的值为：8-填充的字节数
}PAD_MODE;
	
	
typedef enum _DES3_METHOD {
	DES3_3KEY_ENCRYPT = 0,		//DES3加密,3个KEY的三重DES加密
	DES3_3KEY_DECRYPT,			//DES3解密，3个KEY的三重DES解密
	
	DES3_2KEY_ENCRYPT,			//DES3加密，2个KEY的三重DES加密
	DES3_2KEY_DECRYPT,			//DES3解密，2个KEY的三重DES解密
	
	DES_1KEY_ENCRYPT,			//单重DES加密
	DES_1KEY_DECRYPT			//单重DES解密
} DES_METHOD;
	

	
	
	
	
	
/**
 **	描述：设置DES3的参数信息
 **		【pKey】------ 密钥(如果是3个key的DES3,需要24个字节密钥；如果是2个key的DES3,则需要16个字节的密钥;如果是单重DES,则需要8个字节的密钥)
 **		【method】---- 加密或是解密
 **		【pad】------- 填充不够字节的模式
 **		【mode】------ DES3的模式
 **
 **/
extern void SetDES3Param(unsigned char* pKey,DES_METHOD method,PAD_MODE pad ,DES_MODE mode);
	
	
	
	
	
/**
 **	描述：加密跟解密的函数
 **	参数：	【pINSrc】  输入的明文/密文	
 **			【length】  输入的明文/密文长度
 **			【pOutSrc】 输出的密文/明文
 **			【outLength】输出的密文/明文长度
 **
 **/
extern void Run_Des(unsigned char* pINSrc,int length,unsigned char* pOutSrc,int *outLength);
	
	
	
	

#if defined __cplusplus
}
#endif

#endif