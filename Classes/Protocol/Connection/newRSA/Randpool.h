/*
 *  Randpool.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef RANDPOOL_H_
#define RANDPOOL_H_
#include "config.h"
#include "Cryptlib.h"
#include "Misc.h"


class RandomPool : public RandomNumberGenerator,
public BufferedTransformation
{
public:
	// poolSize must be greater than 16
	RandomPool(unsigned int poolSize=384);
	
	// interface for BufferedTransformation
	void Put(byte inByte);
	void Put(const byte *inString, unsigned int length);
	unsigned int Get(byte &outByte);
	unsigned int Get(byte *outString, unsigned int getMax);
	unsigned int Peek(byte &outByte) const;
	
	// return 0 to prevent infinite loops
	unsigned long MaxRetrieveable() {return 0;}
	
	// interface for RandomNumberGenerator
	byte GetByte()
	{byte b; RandomPool::Get(b); return b;}
	void GetBlock(byte *output, unsigned int size)
	{Get(output, size);}
	
	// help compiler disambiguate
	word16 GetShort(word16 min=0, word16 max=0xffff)
	{return RandomNumberGenerator::GetShort(min, max);}
	word32 GetLong(word32 min=0, word32 max=0xffffffffL)
	{return RandomNumberGenerator::GetLong(min, max);}
	
protected:
	void Stir();
	
private:
	SecByteBlock pool, key;
	unsigned int addPos, getPos;
};

template <class T> class MDC : public BlockTransformation
	{
	public:
		MDC(const byte *userKey)
		: key(KEYLENGTH/4)
		{
			T::CorrectEndianess(key, (word32 *)userKey, KEYLENGTH);
		}
		
		void ProcessBlock(byte *inoutBlock) const
		{
			T::CorrectEndianess((word32 *)inoutBlock, (word32 *)inoutBlock, BLOCKSIZE);
			T::Transform((word32 *)inoutBlock, key);
			T::CorrectEndianess((word32 *)inoutBlock, (word32 *)inoutBlock, BLOCKSIZE);
		}
		
		void ProcessBlock(const byte *inBlock, byte *outBlock) const
		{
			T::CorrectEndianess((word32 *)outBlock, (word32 *)inBlock, BLOCKSIZE);
			T::Transform((word32 *)outBlock, key);
			T::CorrectEndianess((word32 *)outBlock, (word32 *)outBlock, BLOCKSIZE);
		}
		
		unsigned int BlockSize() const {return BLOCKSIZE;}
		
#ifdef __BCPLUSPLUS__
		static const unsigned int KEYLENGTH=T::DATASIZE;
		static const unsigned int BLOCKSIZE=T::DIGESTSIZE;
#else
		enum {KEYLENGTH=T::DATASIZE, BLOCKSIZE=T::DIGESTSIZE};
#endif
		
	private:
		SecBlockword32 key;
	};

class MD5
	{
	public:
		MD5();
		void Final(byte *hash);
		unsigned int DigestSize() const {return DIGESTSIZE;}
		
		static void CorrectEndianess(word32 *out, const word32 *in, unsigned int byteCount)
		{
			ASSERT(out && in);
#ifndef IS_LITTLE_ENDIAN
			byteReverse(out, in, byteCount);
#else
			if (in!=out)
				memcpy(out, in, byteCount);
#endif
		}
		
		static void Transform(word32 *digest, const word32 *data);
		void PadLastBlock(unsigned int lastBlockSize, byte padFirst=0x80);
		enum {DIGESTSIZE = 16, DATASIZE = 64};
		
	private:
		void Init();
		void HashBlock(const word32 *input);
		unsigned int blockSize;
		word32 countLo, countHi;
		SecBlockword32 data;			    // Data buffer
		SecBlockword32  digest;			// Message digest
	};




#endif
