/*
 *  DES3.c
 *  des
 *
 *  Created by jiangwei she on 09-8-20.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "DES3.h"
#include "d3des.h"
#include<stdio.h>
#include<string.h>


typedef struct _DES3_PARAM
{
	unsigned char* pKey;
	DES_METHOD method;
	PAD_MODE pad;
	DES_MODE desMode;
}DES3_PARAM;

static DES3_PARAM me;


#pragma mark private_function

/**
 **	描述：对不足明文的填充
 **
 **/
static void Run_Pad(unsigned char* pINSrc,int length,unsigned char* pOutSrc,int* outLength)
{
	int res = length&0x00000007;
	*outLength = length + 8-res;
//	if(res == 0)
//	{
//		*outLength = length;
//	}
//	else
//	{
//		*outLength = length + 8-res;
//	}
	if(NULL == pINSrc || NULL == pOutSrc)
	{
		return ;
	}
	memcpy(pOutSrc, pINSrc, length);
	switch (me.pad) {
		case PAD_ISO_1:
			memset(pOutSrc+length, 0, 8-res);
			break;
		case PAD_ISO_2:
			memset(pOutSrc+length, 0x80, 1);
			memset(pOutSrc+length+1, 0, 7-res);
			break;
		case PAD_PKCS_7:
			memset(pOutSrc+length, 8-res, 8-res);
			break;
		default:
			break;
	}
	
	return ;
}


/**
 **	描述：按照PKCS_7,去掉填充的字节数
 **
 **/
static int PAD_PKCS_7_Count(unsigned char* pINSrc,int length)
{
	int nCount = pINSrc[length-1]&0XFF;
	for(int i = 0;i<nCount;i++)
	{
		if(nCount != pINSrc[length-1-i])
		{
			nCount = 0;
			break;
		}
	}
	return nCount;
}



/**
 **	描述：按照PAD_ISO_1,去掉填充的字节数
 **
 **/
static int PAD_ISO_1_Count(unsigned char* pINSrc,int length)
{
	int nCount = 0;
	int i = 0;
	while(pINSrc[length-1-i] == 0)
	{
		nCount++;
		i++;
		if(i >= length)
			break;
	}
	return nCount;
}



/**
 **	描述：按照PAD_ISO_2,去掉填充的字节数
 **
 **/
static int PAD_ISO_2_Count(unsigned char* pINSrc,int length)
{
	int nCount = 0;
	int i = 0;
	while(pINSrc[length-i-1] == 0)
	{
		nCount++;
		i++;
		if(pINSrc[length-i-1] == 0x80)
		{
			nCount++;
			break;
		}
		if(i>=length)
			break;
	}
	return nCount;
}



/**
 **	描述：获取填充的字节数
 **
 **/
static int DESPadCount(unsigned char* pINSrc,int length)
{
	int count = 0;
	if(NULL == pINSrc)
		return -1;
	
	switch (me.pad) {
		case PAD_ISO_1:
			count = PAD_ISO_1_Count(pINSrc, length);
			break;
		case PAD_ISO_2:
			count = PAD_ISO_2_Count(pINSrc, length);
			break;
		case PAD_PKCS_7:
			count = PAD_PKCS_7_Count(pINSrc, length);
			break;
		default:
			break;
	}
	return count;
}



/**
 **
 **	描述：DES3的加密函数
 **
 **/
static void Run_DesEncrypt(unsigned char* pINSrc,int length,unsigned char* pOutSrc,int *outLength)
{
	int count = length/8;
	unsigned char inBuf[8] = {0};
	unsigned char outBuf[8] = {0};
	unsigned char mixBuf[8] = {0};
	*outLength = length;
	
	for(int i = 0;i<count;i++)
	{
		memset(inBuf, 0, 8);
		memset(outBuf, 0, 8);
		memcpy(inBuf, &pINSrc[i*8], 8);
		
		if(me.desMode == DES_CBC)       
		{
			for(int j = 0;j<8;j++)
			{
				inBuf[j] = inBuf[j]^mixBuf[j];
			}
			
			if(me.method == DES_1KEY_ENCRYPT)
			{
				des(inBuf, outBuf);
			}
			else
			{
				Ddes(inBuf, outBuf);
			}
			
			memcpy(mixBuf, outBuf, 8);
		}
		else if(me.desMode == DES_ECB)
		{
			if(me.method == DES_1KEY_ENCRYPT)
			{
				des(inBuf, outBuf);
			}
			else
			{
				Ddes(inBuf, outBuf);
			}
		}
		memcpy(&pOutSrc[i*8], outBuf, 8);
	}

	return ;
}



/**
 **
 **	描述：DES的解密函数
 **
 **/
static void Run_DesDecrypt(unsigned char* pINSrc,int length,unsigned char* pOutSrc,int *outLength)
{
	int count = length/8;
	unsigned char inBuf[8] = {0};
	unsigned char outBuf[8] = {0};
	unsigned char mixBuf[8] = {0};
	*outLength = length;
	
	for(int i = 0;i<count;i++)
	{
		memset(inBuf, 0, 8);
		memset(outBuf, 0, 8);
		memcpy(inBuf, &pINSrc[i*8], 8);

		if(me.method == DES_1KEY_ENCRYPT)
		{
			des(inBuf, outBuf);
		}
		else
		{
			Ddes(inBuf, outBuf);
		}
		
		if(me.desMode == DES_CBC)
		{
			for(int j = 0;j<8;j++)
			{
				outBuf[j] = outBuf[j] ^ mixBuf[j];
			}
			memcpy(mixBuf, inBuf, 8);
		}
		else
		{
			;
		}
		
		memcpy(&pOutSrc[i*8], outBuf, 8);
	}
	
	return ;
}



#pragma mark public_function
/**
 **	描述：设置DES3的参数信息
 **		【pKey】------ 密钥(采用三个不同的密钥，因此需要24个字节)
 **		【method】---- 加密或是解密
 **		【pad】------- 填充不够字节的模式，默认为PAD_PKCS_7
 **		【mode】------ DES3的模式，默认为DES3_CBC
 **
 **/
void SetDES3Param(unsigned char* pKey,DES_METHOD method,PAD_MODE pad ,DES_MODE mode)
{
	me.pKey = pKey;
	me.method = method;
	me.pad = pad;
	me.desMode = mode;
	switch (method) {
		case DES3_3KEY_ENCRYPT:
			des3key(pKey, EN0);
			break;
		case DES3_3KEY_DECRYPT:
			des3key(pKey, DE1);
			break;
		case DES3_2KEY_ENCRYPT:
			des2key(pKey, EN0);
			break;
		case DES3_2KEY_DECRYPT:
			des2key(pKey, DE1);
			break;
		case DES_1KEY_ENCRYPT:
			deskey(pKey, EN0);
			break;
		case DES_1KEY_DECRYPT:
			deskey(pKey, DE1);
			break;
		default:
			break;
	}
	return;
	
}



/**
 **	描述：加密跟解密的函数
 **	参数：	【pINSrc】  输入的明文/密文	
 **			【length】  输入的明文/密文长度
 **			【pOutSrc】 输出的密文/明文
 **			【outLength】输出的密文/明文长度
 **
 **/
void Run_Des(unsigned char* pINSrc,int length,unsigned char* pOutSrc,int *outLength)
{
	if(NULL == pINSrc || NULL == pOutSrc)
	{
		return;
	}
	if(me.method == DES3_3KEY_ENCRYPT || me.method == DES3_2KEY_ENCRYPT || me.method == DES_1KEY_ENCRYPT)
	{
		Run_Pad(pINSrc, length, pOutSrc, outLength);
		Run_DesEncrypt(pOutSrc, *outLength, pOutSrc, outLength);
	}
	else
	{
		int nCount = 0;
		Run_DesDecrypt(pINSrc, length, pOutSrc, outLength);
		nCount = DESPadCount(pOutSrc, length);
		*outLength = length - nCount;
	}
	return ;
}