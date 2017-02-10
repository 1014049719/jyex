/*
 *  EncryptKey.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-26.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef ENCRYPT_KEY_H
#define ENCRYPT_KEY_H
#include "Integer.h"
#include "Randpool.h"
#include "Rsa.h" 
#include<string.h>
#include<time.h>


#define  OPREATOR_TYPE_NOTE		(2)
#define  VERSION_INFO			(1)

class CEncryptKEY 
{
	public:
		CEncryptKEY();
		~CEncryptKEY();
		/**
		 * 用公钥加密手机的key(RSA算法)
		 */
		////////////////////////////////////////////////加密////////////////////////////////////////////////////////
		
		
		static unsigned char* encryptPubKeyRSA(const unsigned char* key,unsigned int &nLenOfResultData) 
		{
			const  char s_N[] = "06F1F32AC8DCE8A63C0EB97EAEAB2123767685414FF6B7A53DE8EBB2AA2FB3D1DDE5235C973EB40E64489FC17C64F82FE35B81E536936C35ECD83EE5BFC99EC3H";
			const   char s_E[] = "DB02C1B9H";
			Integer N(s_N);   //对模N进行初始化
			Integer E(s_E);    //对公钥E进行初始化
			RSAES_PKCS1v15_Encryptor pub(N, E);
			RandomPool randPool;
			srand(time(NULL));
			int nNum = rand();
			
			randPool.Put((const unsigned char *)&nNum, 4);
			
			
			byte btEncryTextOutBuf[1024];
			memset(btEncryTextOutBuf, 0, sizeof(btEncryTextOutBuf)); 
			///////////////////////////////////////////////////////////////////////////////////////加密
			
			pub.Encrypt(randPool,key, 24,btEncryTextOutBuf); 
			nLenOfResultData = pub.CipherTextLength();//密文长度
			
			unsigned char* resultData = new unsigned char[nLenOfResultData];
			memset(resultData, 0, nLenOfResultData);
			memcpy(resultData,btEncryTextOutBuf,nLenOfResultData);
			return resultData;
			
		}
		
};











#endif
