/********************************************************************
 * 文件名称:    EncryptMD5.cpp
 * 创建时间:	2008/10/30
 * 作者:		张国鹏
 * 说明:		对Blowfish、Des、MD5算法的封装
 *********************************************************************/

#include "EncryptMD5.h"
#include "Blowfish_MD5.h"
#include <assert.h>
#define MYMEMCPY memcpy
//////////////////////////////////////////////////////////////////////////
//1.Blowfish 加/解密
//////////////////////////////////////////////////////////////////////////

/************************************************************************************************
*  函数功能：无符号字符转换为长度为2的16进制字符
*  输入参数：
*  ch: 无符号字符
*  输出参数：
*  szHex：二字节16进制字符
*  返回值：无
************************************************************************************************/
void Char2Hex(BYTE ch, char* szHex)
{
    BYTE byte[2];

    byte[0] = ch / 16;
    byte[1] = ch % 16;

    for (int i = 0; i < 2; i++)
    {
        if ((byte[i] >= 0) && (byte[i] <= 9))
        {
            szHex[i] = '0' + byte[i];
        }
        else
        {
            szHex[i] = 'A' + byte[i] - 10;
        }
    }

    szHex[2] = 0;
}

/************************************************************************************************
*  函数功能：长度为2的16进制字符转换为无符号字符
*  输入参数：
*  szHex：二字节16进制字符
*  输出参数：
*  ch: 无符号字符
*  返回值：无
************************************************************************************************/
void Hex2Char(char* szHex, BYTE& rch)
{
    rch = 0;

    for (int i = 0; i < 2; i++)
    {
        if ((*(szHex + i) >= '0') && (*(szHex + i) <= '9'))
        {
            rch = (rch << 4) + (*(szHex + i) - '0');
        }
        else if (*(szHex + i) >= 'A' && *(szHex + i) <= 'F')
        {
            rch = (rch << 4) + (*(szHex + i) - 'A' + 10);
        }
        else
        {
            break;
        }
    }
}

/************************************************************************************************
*  函数功能：无符号二进制字符转换为16进制字符串
*  输入参数：
*  pucCharStr: 无符号字符串
*  iSize：pucCharStr字符串长度
*  输出参数：
*  pszHexStr：16进制字符串，总长度应该是2*iSize
*  返回值：无
************************************************************************************************/
void CharStr2HexStr(BYTE* pucCharStr, char* pszHexStr, int iSize)
{
    int  i;
    char szHex[3];

    pszHexStr[0] = 0;

    for (i = 0; i < iSize; i++)
    {
        Char2Hex(pucCharStr[i], szHex);
        strcat(pszHexStr, szHex);
    }
}

/************************************************************************************************
*  函数功能：16进制字符串转换为无符号字符串
*  输入参数：
*  pszHexStr：16进制字符串
*  iSize：字符串长度
*  输出参数：
*  pucCharStr: 无符号字符串
*  返回值：无
************************************************************************************************/
void HexStr2CharStr(char* pszHexStr, BYTE* pucCharStr, int iSize)
{
    int  i;
    BYTE ch;

    for (i = 0; i < iSize; i++)
    {
        Hex2Char(pszHexStr + 2 * i, ch);
        pucCharStr[i] = ch;
    }
}

/************************************************************************************************
*  函数功能：Blowfish加密算法
*  输入参数：
*  ucKey:	加密的密钥
*  nKey：	密钥长度
*  buf:	待加密数据
*  nBuf:	待加密数据长度
*  iMode：	加密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
*  iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
*  输出参数：
*  buf：	加密后的数据仍然放在buf中
*  返回值：无
************************************************************************************************/
void BF_Encrypt1(char* ucKey, unsigned int nKey, char* buf, unsigned int nBuf, int iMode, int iStrMode)
{
    if (iStrMode == 0)
    {
        CBlowFish bfObj((BYTE*)ucKey, nKey);

        bfObj.Encrypt((BYTE*)buf, nBuf, iMode);
    }
    else if (iStrMode == 1)
    {
        BYTE* paucKey        = new BYTE[nKey / 2 + 1];
        BYTE* paucPlainText  = new BYTE[nBuf / 2 + 1];
        BYTE* paucCipherText = new BYTE[nBuf / 2 + 1];
        memset(paucKey, 0, nKey / 2 + 1);
        memset(paucPlainText, 0, nBuf / 2 + 1);
        memset(paucCipherText, 0, nBuf / 2 + 1);

        HexStr2CharStr(ucKey, paucKey, nKey / 2);
        HexStr2CharStr(buf, paucPlainText, nBuf / 2);

        CBlowFish oBlowFish(paucKey, nKey / 2);

        oBlowFish.Encrypt(paucPlainText, paucCipherText, nBuf / 2, iMode);

#ifdef UNICODE

#else
#endif
        memset(buf, 0, nBuf);
        CharStr2HexStr(paucCipherText, buf, nBuf / 2);

        delete paucKey;
        delete paucPlainText;
        delete paucCipherText;
    }
}

/************************************************************************************************
*  函数功能：Blowfish解密算法
*  输入参数：
*  ucKey:	解密的密钥
*  nKey：	密钥长度
*  buf:	待解密数据
*  nBuf:	待解密数据长度
*  iMode：	解密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
*  iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
*  输出参数：
*  buf：	解密后的数据仍然放在buf中
*  返回值：无
************************************************************************************************/
void BF_Decrypt1(char* ucKey, unsigned int nKey, char* buf, unsigned int nBuf, int iMode, int iStrMode)
{
    if (iStrMode == 0)
    {
        CBlowFish bfObj((BYTE*)ucKey, nKey);

        bfObj.Decrypt((BYTE*)buf, nBuf, iMode);
    }
    else if (iStrMode == 1)
    {
        BYTE* paucKey        = new BYTE[nKey / 2 + 1];
        BYTE* paucPlainText  = new BYTE[nBuf / 2 + 1];
        BYTE* paucCipherText = new BYTE[nBuf / 2 + 1];
        memset(paucKey, 0, nKey / 2 + 1);
        memset(paucPlainText, 0, nBuf / 2 + 1);
        memset(paucCipherText, 0, nBuf / 2 + 1);

        HexStr2CharStr(ucKey, paucKey, nKey / 2);
        HexStr2CharStr(buf, paucPlainText, nBuf / 2);

        CBlowFish bfObj((BYTE*)paucKey, nKey / 2);

        bfObj.Decrypt((BYTE*)paucPlainText, nBuf / 2, iMode);

        memset(buf, 0, nBuf);
        CharStr2HexStr(paucCipherText, buf, nBuf / 2);

        delete paucKey;
        delete paucPlainText;
        delete paucCipherText;
    }
}

/************************************************************************************************
*  函数功能：Blowfish加密算法
*  输入参数：
*  ucKey:	加密的密钥
*  nKey：	密钥长度
*  inBuf:	待加密数据
*  nBuf:	待加密数据长度
*  iMode：	加密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
*  iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
*  输出参数：
*  outBuf：加密后的数据放在这里
*  返回值：无
************************************************************************************************/
void BF_Encrypt2(char* ucKey, unsigned int nKey, char* inBuf, char* outBuf, unsigned int nBuf, int iMode, int iStrMode)
{
    if (iStrMode == 0)
    {
        CBlowFish bfObj((BYTE*)ucKey, nKey);

        bfObj.Encrypt((BYTE*)inBuf, (BYTE*)outBuf, nBuf, iMode);
    }
    else if (iStrMode == 1)
    {
        BYTE* paucKey        = new BYTE[nKey / 2 + 1];
        BYTE* paucPlainText  = new BYTE[nBuf / 2 + 1];
        BYTE* paucCipherText = new BYTE[nBuf / 2 + 1];
        memset(paucKey, 0, nKey / 2 + 1);
        memset(paucPlainText, 0, nBuf / 2 + 1);
        memset(paucCipherText, 0, nBuf / 2 + 1);

        HexStr2CharStr(ucKey, paucKey, nKey / 2);
        HexStr2CharStr(inBuf, paucPlainText, nBuf / 2);

        CBlowFish bfObj((BYTE*)paucKey, nKey / 2);

        bfObj.Encrypt((BYTE*)paucPlainText, (BYTE*)paucCipherText, nBuf / 2, iMode);

        memset(outBuf, 0, nBuf);
        CharStr2HexStr(paucCipherText, outBuf, nBuf / 2);

        delete paucKey;
        delete paucPlainText;
        delete paucCipherText;
    }
}

/************************************************************************************************
*  函数功能：Blowfish解密算法
*  输入参数：
*  ucKey:	解密的密钥
*  nKey：	密钥长度
*  inBuf:	待解密数据
*  nBuf:	待解密数据长度
*  iMode：	解密模式： 0, 为ECB模式；1, 为CBC模式；2, 为CFB模式；
*  iStrMode: 0，输入的参数为BCD编码的字符串；1， 输入的参数为16进制字符串
*  输出参数：
*  outBuf：解密后的数据放在这里
*  返回值：无
************************************************************************************************/
void BF_Decrypt2(char* ucKey, unsigned int nKey, char* inBuf, char* outBuf, unsigned int nBuf, int iMode, int iStrMode)
{
    if (iStrMode == 0)
    {
        CBlowFish bfObj((BYTE*)ucKey, nKey);

        bfObj.Decrypt((BYTE*)inBuf, (BYTE*)outBuf, nBuf, iMode);
    }
    else if (iStrMode == 1)
    {
        BYTE* paucKey        = new BYTE[nKey / 2 + 1];
        BYTE* paucPlainText  = new BYTE[nBuf / 2 + 1];
        BYTE* paucCipherText = new BYTE[nBuf / 2 + 1];
        memset(paucKey, 0, nKey / 2 + 1);
        memset(paucPlainText, 0, nBuf / 2 + 1);
        memset(paucCipherText, 0, nBuf / 2 + 1);

        HexStr2CharStr(ucKey, paucKey, nKey / 2);
        HexStr2CharStr(inBuf, paucPlainText, nBuf / 2);

        CBlowFish bfObj((BYTE*)paucKey, nKey / 2);

        bfObj.Decrypt((BYTE*)paucPlainText, (BYTE*)paucCipherText, nBuf / 2, iMode);

        memset(outBuf, 0, nBuf);
        CharStr2HexStr(paucCipherText, outBuf, nBuf / 2);

        delete paucKey;
        delete paucPlainText;
        delete paucCipherText;
    }
}

//////////////////////////////////////////////////////////////////////////
//2.Des 加/解密
//////////////////////////////////////////////////////////////////////////
/************************************************************************************************
*  函数功能：固定长度DES加密算法，输入输出密钥都为固定长度8
*  输入参数：
*  BuffIn 输入待加密数据，固定长度为8
*  DESKey：加密的密钥，固定长度为8
*  输出参数：
*  BuffOut：输出加密后的密文，固定长度为8
*  返回值：无
************************************************************************************************/
void DES_Encrypt1(char* BuffIn, char* BuffOut, char* DESkey)
{
    DESencrypt(BuffIn, BuffOut, DESkey);
}

/************************************************************************************************
*  函数功能：固定长度DES解密算法，输入输出密钥都为固定长度8
*  输入参数：
*  BuffIn 输入待解密数据，固定长度为8
*  DESKey：解密的密钥，固定长度为8
*  输出参数：
*  BuffOut：输出解密后的明文，固定长度为8
*  返回值：无
************************************************************************************************/
void DES_Decrypt1(char* BuffIn, char* BuffOut, char* DESkey)
{
    DESdecrypt(BuffIn, BuffOut, DESkey);
}

/************************************************************************************************
*  函数功能：不定长DES加密算法
*  输入参数：
*  BuffIn 输入待加密数据缓存
*  DESKey：加密的密钥，固定长度为8
*  iLen 输入待加密数据长度，长度需要为8的整数倍
*  输出参数：
*  BuffOut：输出加密后的密文，容量必须与输入容量一样
*  返回值：1加密成功 0 加密失败
************************************************************************************************/
int DES_Encrypt2(char* BuffIn, char* BuffOut, char* DESkey, int iLen)
{
    return DesEncrypt(BuffIn, BuffOut, DESkey, iLen);
}

/************************************************************************************************
*  函数功能：不定长DES解密算法
*  输入参数：
*  BuffIn 输入待解密数据缓存
*  DESKey：解密的密钥，固定长度为8
*  iLen 输入待解密数据长度,长度需要为8的整数倍
*  输出参数：
*  BuffOut：输出解密后的明文，容量必须与输入容量一样
*  返回值：1解密成功 0 解密失败
************************************************************************************************/
int DES_Decrypt3(char* BuffIn, char* BuffOut, char* DESkey, int iLen)
{
    return DesDecrypt(BuffIn, BuffOut, DESkey, iLen);
}

//////////////////////////////////////////////////////////////////////////
//3.MD5 检验
//////////////////////////////////////////////////////////////////////////
/************************************************************************************************
*  函数功能：对pBuf中的内容进行MD5检验，返回检验码
*  输入参数：
*  pBuf  :	待检验内容
*  nLength :	待检验内容长度
*  输出参数：
*  pOutBuf：MD5检验码
*  返回值：无
*  修改后nLength已可以不用了，因为计算是在函数内自动计算的；
************************************************************************************************/
void MD5_GetMD5a(char* pBuf, unsigned int nLength, char* pOutBuf)
{
    string strMD5 = "";

    strMD5   = CMD5Checksum::GetMD5((BYTE*)pBuf, nLength);
    *pOutBuf = 0;
    memcpy(pOutBuf, strMD5.c_str(), strMD5.length());
}

/************************************************************************************
* @brief
*
* 对wchar_t类型的求长度；在UNICODE环境下，CString中文字符是两个字节
* @n<b>函数名称</b>             : GetStrLength
* @n@param const CString StrSrc :
* @return  int 字符串的长度
* @see
* @n<b>作者</b>                 :
* @n<b>创建时间</b>             : 2009-3-24 20:00:44
* @version	修改者        时间        描述@n
* @n			             2009-03-24
************************************************************************************/
int GetStrLength(char* StrSrc)
{
    int l_iRetVal = 0;

    l_iRetVal = strlen(StrSrc);
    return l_iRetVal;
}

