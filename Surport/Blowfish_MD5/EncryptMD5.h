﻿/********************************************************************
   文件名称:    EncryptMD5.h
   创建时间:	2008/10/30
   作者:		张国鹏
   说明:		对Blowfish、Des、MD5算法的静态库封装
 *********************************************************************/

#ifndef _ENCRYPTMD5_H_20081030_
#define _ENCRYPTMD5_H_20081030_

typedef unsigned char BYTE;
typedef unsigned char UCHAR;
typedef uint32_t DWORD;
typedef uint32_t UINT;
typedef uint32_t ULONG;

//////////////////////////////////////////////////////////////////////////
//1.Blowfish 加/解密
//////////////////////////////////////////////////////////////////////////

/************************************************************************************************
   函数功能：无符号字符转换为长度为2的16进制字符
   输入参数：
   ch: 无符号字符
   输出参数：
   szHex：16进制字符
   返回值：无
************************************************************************************************/
void Char2Hex(BYTE ch, char* szHex);

/************************************************************************************************
   函数功能：长度为2的16进制字符转换为无符号字符
   输入参数：
   szHex：16进制字符
   输出参数：
   ch: 无符号字符
   返回值：无
************************************************************************************************/
void Hex2Char(char* szHex, BYTE& rch);

/************************************************************************************************
   函数功能：无符号字符串转换为16进制字符串
   输入参数：
   pucCharStr: 无符号字符串
   iSize：字符串长度
   输出参数：
   pszHexStr：16进制字符串
   返回值：无
************************************************************************************************/
void CharStr2HexStr(BYTE* pucCharStr, char* pszHexStr, int iSize);

/************************************************************************************************
   函数功能：16进制字符串转换为无符号字符串
   输入参数：
   pszHexStr：16进制字符串
   iSize：字符串长度
   输出参数：
   pucCharStr: 无符号字符串
   返回值：无
************************************************************************************************/
void HexStr2CharStr(char* pszHexStr, BYTE* pucCharStr, int iSize);

// Encrypt/Decrypt Buffer in Place
/************************************************************************************************
   函数功能：Blowfish加密算法
   输入参数：
   ucKey:	加密的密钥
   nKey：	密钥长度
   buf:	待加密数据
   nBuf:	待加密数据长度
   iMode：	加密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
   iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
   输出参数：
   buf：	加密后的数据仍然放在buf中
   返回值：无
************************************************************************************************/
void BF_Encrypt1(char* ucKey, unsigned int nKey, char* buf, unsigned int nBuf, int iMode, int iStrMode);

/************************************************************************************************
   函数功能：Blowfish解密算法
   输入参数：
   ucKey:	解密的密钥
   nKey：	密钥长度
   buf:	待解密数据
   nBuf:	待解密数据长度
   iMode：	解密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
   iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
   输出参数：
   buf：	解密后的数据仍然放在buf中
   返回值：无
************************************************************************************************/
void BF_Decrypt1(char* ucKey, unsigned int nKey, char* buf, unsigned int nBuf, int iMode, int iStrMode);

// Encrypt/Decrypt from Input Buffer to Output Buffer
/************************************************************************************************
   函数功能：Blowfish加密算法
   输入参数：
   ucKey:	加密的密钥
   nKey：	密钥长度
   inBuf:	待加密数据
   nBuf:	待加密数据长度
   iMode：	加密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
   iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
   输出参数：
   outBuf：加密后的数据放在这里
   返回值：无
************************************************************************************************/
void BF_Encrypt2(char* ucKey, unsigned int nKey, char* inBuf, char* outBuf, unsigned int nBuf, int iMode, int iStrMode);

/************************************************************************************************
   函数功能：Blowfish解密算法
   输入参数：
   ucKey:	解密的密钥
   nKey：	密钥长度
   inBuf:	待解密数据
   nBuf:	待解密数据长度
   iMode：	解密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
   iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
   输出参数：
   outBuf：解密后的数据放在这里
   返回值：无
************************************************************************************************/
void BF_Decrypt2(char* ucKey, unsigned int nKey, char* inBuf, char* outBuf, unsigned int nBuf, int iMode, int iStrMode);

//////////////////////////////////////////////////////////////////////////
//2.Des 加/解密
//////////////////////////////////////////////////////////////////////////
/************************************************************************************************
   函数功能：固定长度DES加密算法，输入输出密钥都为固定长度8
   输入参数：
   BuffIn 输入待加密数据，固定长度为8
   DESKey：加密的密钥，固定长度为8
   输出参数：
   BuffOut：输出加密后的密文，固定长度为8
   返回值：无
************************************************************************************************/
void DES_Encrypt1(char* BuffIn, char* BuffOut, char* DESkey);

/************************************************************************************************
   函数功能：固定长度DES解密算法，输入输出密钥都为固定长度8
   输入参数：
   BuffIn 输入待解密数据，固定长度为8
   DESKey：解密的密钥，固定长度为8
   输出参数：
   BuffOut：输出解密后的明文，固定长度为8
   返回值：无
************************************************************************************************/
void DES_Decrypt1(char* BuffIn, char* BuffOut, char* DESkey);

/************************************************************************************************
   函数功能：不定长DES加密算法
   输入参数：
   BuffIn 输入待加密数据缓存
   DESKey：加密的密钥，固定长度为8
   iLen 输入待加密数据长度，长度需要为8的整数倍
   输出参数：
   BuffOut：输出加密后的密文，容量必须与输入容量一样
   返回值：1加密成功 0 加密失败
************************************************************************************************/
int DES_Encrypt2(char* BuffIn, char* BuffOut, char* DESkey, int iLen);

/************************************************************************************************
   函数功能：不定长DES解密算法
   输入参数：
   BuffIn 输入待解密数据缓存
   DESKey：解密的密钥，固定长度为8
   iLen 输入待解密数据长度,长度需要为8的整数倍
   输出参数：
   BuffOut：输出解密后的明文，容量必须与输入容量一样
   返回值：1解密成功 0 解密失败
************************************************************************************************/
int DES_Decrypt3(char* BuffIn, char* BuffOut, char* DESkey, int iLen);

//////////////////////////////////////////////////////////////////////////
//3.MD5 检验
//////////////////////////////////////////////////////////////////////////
/************************************************************************************************
   函数功能：对pBuf中的内容进行MD5检验，返回检验码
   输入参数：
   pBuf  :	待检验内容
   nLength :	待检验内容长度
   输出参数：
   pOutBuf：MD5检验码
   返回值：无
************************************************************************************************/
void MD5_GetMD5a(char* pBuf, unsigned int nLength, char* pOutBuf);

/************************************************************************************************
   函数功能：计算UNICODE下的传入的字符串的长度
   输入参数：
   StrSrc  :	UNICODE下TCHAR
   输出参数：
   pOutBuf：MD5检验码
   返回值：无
************************************************************************************************/
int GetStrLength(char* StrSrc);


#endif      //_ENCRYPTMD5_H_20081030_