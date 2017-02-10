

//#include "stdafx.h"

#include "Just4CallDesYxy.h"





void DesCharOfYxy(bool isEncrypt, char* key, char* sou, char** des)
{
	//char* des;
	
	char szInputPlaintext[1024] = {0};
	char szInputCiphertext[1024] = {0};
	char szInputCiphertextInHex[2048] = {0};
	char szCiphertextInBit[8196] = {0};
	
	int temp = strlen(sou);
	
	yxyDES2_InitializeKey(key);
	if (isEncrypt)
	{
		memset(szInputPlaintext,0,1024);
		memcpy(szInputPlaintext, sou, temp);
		
		yxyDES2_EncryptAnyLength(szInputPlaintext,temp);
		temp = temp % 8 == 0 ? temp : ((temp >> 3 ) + 1)  << 3;
		memcpy(szInputCiphertext,yxyDES2_GetCiphertextAnyLength(),temp);
		yxyDES2_Bytes2Bits(szInputCiphertext,szCiphertextInBit,temp << 3);
		yxyDES2_Bits2Hex(szInputCiphertextInHex,szCiphertextInBit,temp << 3);
		szInputCiphertextInHex[temp << 1] = 0;
		
		*des = szInputCiphertextInHex;
		//return szInputCiphertextInHex;
	}
	else
	{
		memset(szInputCiphertextInHex,0,1024);
		
		memcpy(szInputCiphertextInHex, sou, temp);
		
		yxyDES2_Hex2Bits(szInputCiphertextInHex,szCiphertextInBit,temp << 2);
		yxyDES2_Bits2Bytes(szInputCiphertext,szCiphertextInBit,temp << 2);
		yxyDES2_DecryptAnyLength(szInputCiphertext,temp >> 1);
		
		char *charDes = yxyDES2_GetPlaintextAnyLength();
	    *des = charDes;
		//return charDes;
	}
}

int testxx(void)
{
	return 99;
}







