/*
 *  Randpool.cpp
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Randpool.h"
#include "stdafx.h"
#include "Modes.h"

typedef MDC<MD5> RandomPoolCipher;

RandomPool::RandomPool(unsigned int poolSize)
: pool(poolSize), key(RandomPoolCipher::KEYLENGTH)
{
	ASSERT(poolSize > key.size);
	
	addPos=0;
	getPos=poolSize;
	memset(pool, 0, poolSize);
	memset(key, 0, key.size);
}

void RandomPool::Stir()
{
	//  add these lines to be compatible with PGP's randpool.c
	//  byteReverse((word32 *)pool.ptr, (word32 *)pool.ptr, pool.size);
	for (int i=0; i<2; i++)
	{
		RandomPoolCipher cipher(key);
		CFBEncryption cfb(cipher, pool+pool.size-cipher.BlockSize());
		cfb.ProcessString(pool, pool.size);
		memcpy(key, pool, key.size);
	}
	//  byteReverse((word32 *)pool.ptr, (word32 *)pool.ptr, pool.size);
	
	addPos = 0;
	getPos = key.size;
}

void RandomPool::Put(byte inByte)
{
	if (addPos == pool.size)
		Stir();
	
	pool[addPos++] ^= inByte;
	getPos = pool.size; // Force stir on get
}

void RandomPool::Put(const byte *inString, unsigned int length)
{
	unsigned t;
	
	while (length > (t = pool.size - addPos))
	{
		xorbuf(pool+addPos, inString, t);
		inString += t;
		length -= t;
		Stir();
	}
	
	if (length)
	{
		xorbuf(pool+addPos, inString, length);
		addPos += length;
		getPos = pool.size; // Force stir on get
	}
}

unsigned int RandomPool::Get(byte &outByte)
{
	if (getPos == pool.size)
		Stir();
	
	outByte = pool[getPos++];
	return 1;
}

unsigned int RandomPool::Get(byte *outString, unsigned int getMax)
{
	unsigned t;
	unsigned int length = getMax;
	
	while (length > (t = pool.size - getPos))
	{
		memcpy(outString, pool+getPos, t);
		outString += t;
		length -= t;
		Stir();
	}
	
	if (length)
	{
		memcpy(outString, pool+getPos, length);
		getPos += length;
	}
	return getMax;
}

unsigned int RandomPool::Peek(byte &outByte) const
{
	if (getPos == pool.size)
		const_cast<RandomPool *>(this)->Stir();
	
	outByte = pool[getPos];
	return 1;
}

MD5::MD5()
{
	Init();
}

void MD5::Init()
{
//	countLo = countHi = 0;
//	
//	digest[0] = 0x67452301L;
//	digest[1] = 0xefcdab89L;
//	digest[2] = 0x98badcfeL;
//	digest[3] = 0x10325476L;
}

void MD5::HashBlock(const word32 *input)
{
//#ifdef IS_LITTLE_ENDIAN
//	Transform(digest, input);
//#else
//	byteReverse(data.ptr, input, (unsigned int)DATASIZE);
//	Transform(digest, data);
//#endif
}

void MD5::PadLastBlock(unsigned int lastBlockSize, byte padFirst)
{
//	unsigned int num = (unsigned int)(countLo >> 3) & (blockSize-1);
//	ASSERT(num < blockSize);
//	((byte *)data.ptr)[num++]=padFirst;
//	if (num <= lastBlockSize)
//		memset((byte *)data.ptr+num, 0, lastBlockSize-num);
//	else
//	{
//		memset((byte *)data.ptr+num, 0, blockSize-num);
//		HashBlock(data);
//		memset(data, 0, lastBlockSize);
//	}
}

void MD5::Final (byte *hash)
{
//	PadLastBlock(56);
//	CorrectEndianess(data, data, 56);
//	
//	data[14] = countLo;
//	data[15] = countHi;
//	
//	Transform(digest, data);
//	CorrectEndianess(digest, digest, DIGESTSIZE);
//	memcpy(hash, digest, DIGESTSIZE);
//	
//	Init();		// reinit for next use
}

void MD5::Transform (word32 *digest, const word32 *X)
{
	// #define	F(x,y,z)	((x & y)  |  (~x & z))
#define F(x,y,z)    (z ^ (x & (y^z)))
	// #define	G(x,y,z)	((x & z)  |  (y & ~z))
#define G(x,y,z)    (y ^ (z & (x^y)))
#define	H(x,y,z)	(x ^ y ^ z)
#define	I(x,y,z)	(y  ^  (x | ~z))
	
	
#define Subround(f,a,b,c,d,k,s,t)			\
{											\
a += (k + t + f(b,c,d));				\
a = rotl(word32(a), (unsigned int)(s));	\
a += b;									\
}
	
	unsigned long A,B,C,D;
	
	A=digest[0];
	B=digest[1];
	C=digest[2];
	D=digest[3];
	
	/* Round 0 */
	Subround(F,A,B,C,D,X[ 0], 7,0xd76aa478);
	Subround(F,D,A,B,C,X[ 1],12,0xe8c7b756);
	Subround(F,C,D,A,B,X[ 2],17,0x242070db);
	Subround(F,B,C,D,A,X[ 3],22,0xc1bdceee);
	Subround(F,A,B,C,D,X[ 4], 7,0xf57c0faf);
	Subround(F,D,A,B,C,X[ 5],12,0x4787c62a);
	Subround(F,C,D,A,B,X[ 6],17,0xa8304613);
	Subround(F,B,C,D,A,X[ 7],22,0xfd469501);
	Subround(F,A,B,C,D,X[ 8], 7,0x698098d8);
	Subround(F,D,A,B,C,X[ 9],12,0x8b44f7af);
	Subround(F,C,D,A,B,X[10],17,0xffff5bb1);
	Subround(F,B,C,D,A,X[11],22,0x895cd7be);
	Subround(F,A,B,C,D,X[12], 7,0x6b901122);
	Subround(F,D,A,B,C,X[13],12,0xfd987193);
	Subround(F,C,D,A,B,X[14],17,0xa679438e);
	Subround(F,B,C,D,A,X[15],22,0x49b40821);
	/* Round 1 */
	Subround(G,A,B,C,D,X[ 1], 5,0xf61e2562);
	Subround(G,D,A,B,C,X[ 6], 9,0xc040b340);
	Subround(G,C,D,A,B,X[11],14,0x265e5a51);
	Subround(G,B,C,D,A,X[ 0],20,0xe9b6c7aa);
	Subround(G,A,B,C,D,X[ 5], 5,0xd62f105d);
	Subround(G,D,A,B,C,X[10], 9,0x02441453);
	Subround(G,C,D,A,B,X[15],14,0xd8a1e681);
	Subround(G,B,C,D,A,X[ 4],20,0xe7d3fbc8);
	Subround(G,A,B,C,D,X[ 9], 5,0x21e1cde6);
	Subround(G,D,A,B,C,X[14], 9,0xc33707d6);
	Subround(G,C,D,A,B,X[ 3],14,0xf4d50d87);
	Subround(G,B,C,D,A,X[ 8],20,0x455a14ed);
	Subround(G,A,B,C,D,X[13], 5,0xa9e3e905);
	Subround(G,D,A,B,C,X[ 2], 9,0xfcefa3f8);
	Subround(G,C,D,A,B,X[ 7],14,0x676f02d9);
	Subround(G,B,C,D,A,X[12],20,0x8d2a4c8a);
	/* Round 2 */
	Subround(H,A,B,C,D,X[ 5], 4,0xfffa3942);
	Subround(H,D,A,B,C,X[ 8],11,0x8771f681);
	Subround(H,C,D,A,B,X[11],16,0x6d9d6122);
	Subround(H,B,C,D,A,X[14],23,0xfde5380c);
	Subround(H,A,B,C,D,X[ 1], 4,0xa4beea44);
	Subround(H,D,A,B,C,X[ 4],11,0x4bdecfa9);
	Subround(H,C,D,A,B,X[ 7],16,0xf6bb4b60);
	Subround(H,B,C,D,A,X[10],23,0xbebfbc70);
	Subround(H,A,B,C,D,X[13], 4,0x289b7ec6);
	Subround(H,D,A,B,C,X[ 0],11,0xeaa127fa);
	Subround(H,C,D,A,B,X[ 3],16,0xd4ef3085);
	Subround(H,B,C,D,A,X[ 6],23,0x04881d05);
	Subround(H,A,B,C,D,X[ 9], 4,0xd9d4d039);
	Subround(H,D,A,B,C,X[12],11,0xe6db99e5);
	Subround(H,C,D,A,B,X[15],16,0x1fa27cf8);
	Subround(H,B,C,D,A,X[ 2],23,0xc4ac5665);
	/* Round 3 */
	Subround(I,A,B,C,D,X[ 0], 6,0xf4292244);
	Subround(I,D,A,B,C,X[ 7],10,0x432aff97);
	Subround(I,C,D,A,B,X[14],15,0xab9423a7);
	Subround(I,B,C,D,A,X[ 5],21,0xfc93a039);
	Subround(I,A,B,C,D,X[12], 6,0x655b59c3);
	Subround(I,D,A,B,C,X[ 3],10,0x8f0ccc92);
	Subround(I,C,D,A,B,X[10],15,0xffeff47d);
	Subround(I,B,C,D,A,X[ 1],21,0x85845dd1);
	Subround(I,A,B,C,D,X[ 8], 6,0x6fa87e4f);
	Subround(I,D,A,B,C,X[15],10,0xfe2ce6e0);
	Subround(I,C,D,A,B,X[ 6],15,0xa3014314);
	Subround(I,B,C,D,A,X[13],21,0x4e0811a1);
	Subround(I,A,B,C,D,X[ 4], 6,0xf7537e82);
	Subround(I,D,A,B,C,X[11],10,0xbd3af235);
	Subround(I,C,D,A,B,X[ 2],15,0x2ad7d2bb);
	Subround(I,B,C,D,A,X[ 9],21,0xeb86d391);
	
	digest[0]+=A;
	digest[1]+=B;
	digest[2]+=C;
	digest[3]+=D;
}