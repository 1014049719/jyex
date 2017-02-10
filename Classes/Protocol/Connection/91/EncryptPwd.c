/*
 *  EncryptPwd.c
 *  des
 *
 *  Created by jiangwei she on 09-8-31.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "EncryptPwd.h"
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"Des91Priv.h"



#define DES_KEY ("n7=7=7d")




char* Transcode(char* Str)
{
	const char Hexcode[]={"0123456789ABCDEF"};
	int lenth = strlen(Str);	
	if (Str == NULL)
	{
		return NULL;
	}
	char *pszStr = (char*)malloc(lenth*3+1);
	memset(pszStr, 0, lenth*3+1);
	
	for(int i = 0,j = 0;i < lenth; i++,j++)
	{
		unsigned char c = (unsigned char)Str[i];
		if ((c >= 'a' && c <= 'z')||(c >= 'A' && c <= 'Z')||(c >= '0' && c <= '9'))
		{
			pszStr[j]=c;
		}
		else
		{
			pszStr[j++]= '%';
			pszStr[j++]= Hexcode[c/16];              
			pszStr[j]= Hexcode[c%16];
		}
	}
	
	return pszStr;
}



void Run_PadPwd(char* pPwd,char*outStr)
{
	if(NULL == pPwd || NULL == outStr)
	{
		return;
	}
	int length = strlen(pPwd);
	for(int i = 0,j=0;j<length;i+=2,j++)
	{
		outStr[i] = pPwd[j];
	}
}


char* Decode(char* pstr)
{
	int length = strlen(pstr);
	char* pBuf = (char*)malloc(length);
	memset(pBuf, 0, length);
	for(int i = 0,j = 0;i<length;i++,j++)
	{
		if('%' == pstr[i])
		{
			pBuf[j] = pstr[i++]<<4 | pstr[i];
		}
		else
		{
			pBuf[j] = pstr[i];
		}
	}
	return pBuf;
}


char* Encode(char* pstr,int length)
{
	const char HexCode[] = {"0123456789ABCDEF"};
	char *pstrResult = (char*)malloc(length*3+1);
	unsigned char c;
	memset(pstrResult, 0, length*3+1);
	if(NULL == pstr)
		return NULL;
	
	for(int i = 0,j = 0;i<length;i++,j++)
	{
		c = (unsigned char)pstr[i];
		if(c>='a' && c<='z')
		{
			pstrResult[j] = c;
		}
		else if(c>='A' && c<='Z')
		{
			pstrResult[j] = c;
		}
		else if(c>='0' && c<='9')
		{
			pstrResult[j] = c;
		}
		else
		{
			pstrResult[j++] = '%';
			pstrResult[j++] = HexCode[c/16];
			pstrResult[j] = HexCode[c%16];
		}
	}
	return pstrResult;
}


char* EncryptPwd(char* pPwd)
{
	int length = strlen(pPwd);
	char* pPadStr = (char*)malloc(length*sizeof(char)*2+1);
	unsigned char*pResult = NULL;
	int tm = 0;
	memset(pPadStr, 0, length*sizeof(char)*2+1);
	Run_PadPwd(pPwd, pPadStr);
	pResult = (unsigned char*)malloc(length*2+8);
	memset(pResult, 0, length*2+8);
	
	
	//91通行证非标准的算法
	DesPriv_SetKey(DES_KEY);
	DesPriv_Encrypt(pPadStr, length*2, (char*)pResult, &tm);
	
	free(pPadStr);
	char* pEncode = Encode((char*)pResult, tm);
	char* ptrans = Transcode(pEncode);
	free(pResult);
	free(pEncode);
	return ptrans;
	
}