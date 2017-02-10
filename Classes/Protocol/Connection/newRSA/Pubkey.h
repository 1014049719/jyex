/*
 *  Pubkey.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */


#ifndef _PUB_KEY_H_
#define _PUB_KEY_H_

#include "Cryptlib.h"
#include "misc.h"
#include <string.h>
#include"BaseFunction.h"




class PaddingScheme
	{
	public:
		virtual ~PaddingScheme() {}
		
		virtual unsigned int MaxUnpaddedLength(unsigned int paddedLength) const =0;
		
		virtual void Pad(RandomNumberGenerator &rng, const byte *raw, unsigned int inputLength, byte *padded, unsigned int paddedLength) const =0;
		// returns length of raw
		virtual unsigned int Unpad(const byte *padded, unsigned int paddedLength, byte *raw) const =0;
	};

class PKCS_EncryptionPaddingScheme : public PaddingScheme
	{
	public:
		unsigned int MaxUnpaddedLength(unsigned int paddedLength) const
		{
			return paddedLength/8 > 10 ? paddedLength/8-2 : 0;
		}
		void Pad(RandomNumberGenerator &rng, const byte *input, unsigned int inputLen, byte *pkcsBlock, unsigned int pkcsBlockLen) const
		{
			ASSERT (inputLen <= MaxUnpaddedLength(pkcsBlockLen));
			
			// convert from bit length to byte length
			if (pkcsBlockLen % 8 != 0)
			{
				pkcsBlock[0] = 0;
				pkcsBlock++;
			}
			pkcsBlockLen /= 8;
			
			pkcsBlock[0] = 2;  // block type 2
			
			// pad with non-zero random bytes
			for (unsigned i = 1; i < pkcsBlockLen-inputLen-1; i++)
				pkcsBlock[i] = (byte)rng.GetShort(1, 0xff);
			
			pkcsBlock[pkcsBlockLen-inputLen-1] = 0;     // separator
			memcpy(pkcsBlock+pkcsBlockLen-inputLen, input, inputLen);
		}
		
		unsigned int Unpad(const byte *pkcsBlock, unsigned int pkcsBlockLen, byte *output) const
		{
			unsigned int maxOutputLen = MaxUnpaddedLength(pkcsBlockLen);
			
			// convert from bit length to byte length
			if (pkcsBlockLen % 8 != 0)
			{
				if (pkcsBlock[0] != 0)
					return 0;
				pkcsBlock++;
			}
			pkcsBlockLen /= 8;
			
			// Require block type 2.
			if (pkcsBlock[0] != 2)
				return 0;
			
			// skip past the padding until we find the seperator
			unsigned i=1;
			while (i<pkcsBlockLen && pkcsBlock[i++]) { // null body
			}
			ASSERT(i==pkcsBlockLen || pkcsBlock[i-1]==0);
			
			unsigned int outputLen = pkcsBlockLen - i;
			if (outputLen > maxOutputLen)
				return 0;
			
			memcpy (output, pkcsBlock+i, outputLen);
			return outputLen;
		}
	};



//class InvertableRSAFunction;






class PublicKeyBaseTemplateInvertableRSAFunction
{
public:
		PublicKeyBaseTemplateInvertableRSAFunction(const InvertableRSAFunction& fn) : f(fn) {}
		PublicKeyBaseTemplateInvertableRSAFunction(BufferedTransformation& bt) : f(bt) {}
		
		//
		void SetRSAFunction(BufferedTransformation& bt){f = bt;}
		void SetRSAFunction(InvertableRSAFunction& fn){f = fn;}
	
		void DEREncode(BufferedTransformation& bt) const {f.DEREncode(bt);}
		
		const InvertableRSAFunction & GetTrapdoorFunction() const {return f;}
	
		
		
protected:
		// a hack to avoid having to write constructors for non-concrete derived classes
			// should never be called
		PublicKeyBaseTemplateInvertableRSAFunction() : f(*(InvertableRSAFunction*)0) {ASSERT(false);}
		InvertableRSAFunction f;
		virtual unsigned int PaddedBlockBitLength() const =0;
		unsigned int PaddedBlockByteLength() const {return bitsToBytes(PaddedBlockBitLength());}
		
		
};


class PublicKeyBaseTemplateRSAFunction
	{
	public:
		PublicKeyBaseTemplateRSAFunction(const RSAFunction& fn) : f(fn) {}
		PublicKeyBaseTemplateRSAFunction(BufferedTransformation& bt) : f(bt) {}
		
		//
		void SetRSAFunction(BufferedTransformation& bt){f = bt;}
		void SetRSAFunction(RSAFunction& fn){f = fn;}
		
		void DEREncode(BufferedTransformation& bt) const {f.DEREncode(bt);}
		
		const RSAFunction & GetTrapdoorFunction() const {return f;}
		
		
		
	protected:
		// a hack to avoid having to write constructors for non-concrete derived classes
		// should never be called
		PublicKeyBaseTemplateRSAFunction() : f(*(RSAFunction*)0) {ASSERT(false);}
		RSAFunction f;
		virtual unsigned int PaddedBlockBitLength() const =0;
		unsigned int PaddedBlockByteLength() const {return bitsToBytes(PaddedBlockBitLength());}
		
		
	};



class ENCryptoSystemBaseTemplate : virtual public PK_FixedLengthCryptoSystem, virtual public PublicKeyBaseTemplateRSAFunction
{
public:
	unsigned int MaxPlainTextLength() const 
	{
		return pad.MaxUnpaddedLength(PaddedBlockBitLength());
	}
	
	unsigned int CipherTextLength() const
	{
		return f.MaxImage().ByteCount();
	}
	
	PKCS_EncryptionPaddingScheme pad;
	
protected:
	ENCryptoSystemBaseTemplate() {}
	unsigned int PaddedBlockBitLength() const
	{
		return f.MaxPreimage().BitCount()-1;
	}
};

class DECryptoSystemBaseTemplate : virtual public PK_FixedLengthCryptoSystem, virtual public PublicKeyBaseTemplateInvertableRSAFunction
{
public:
	unsigned int MaxPlainTextLength() const 
	{
		return pad.MaxUnpaddedLength(PaddedBlockBitLength());
	}
	
	unsigned int CipherTextLength() const
	{
		return f.MaxImage().ByteCount();
	}
	
	PKCS_EncryptionPaddingScheme pad;
	
protected:
	DECryptoSystemBaseTemplate() {}
	unsigned int PaddedBlockBitLength() const
	{
		return f.MaxPreimage().BitCount()-1;
	}
};



class DecryptorTemplate : public PK_FixedLengthDecryptor, public DECryptoSystemBaseTemplate
{
public:
	~DecryptorTemplate() {}
	unsigned int Decrypt(const byte *cipherText, byte *plainText)
	{
		SecByteBlock paddedBlock(PaddedBlockByteLength());
		f.CalculateInverse(Integer(cipherText, CipherTextLength())).Encode(paddedBlock, paddedBlock.size);
		return pad.Unpad(paddedBlock, PaddedBlockBitLength(), plainText);
	}
	
protected:
	DecryptorTemplate() {}
};



class EncryptorTemplate : public PK_FixedLengthEncryptor, public ENCryptoSystemBaseTemplate
{
public:
	~EncryptorTemplate() {}
	void Encrypt(RandomNumberGenerator &rng, const byte *plainText, unsigned int plainTextLength, byte *cipherText)
	{
		ASSERT(plainTextLength <= MaxPlainTextLength());
		
		SecByteBlock paddedBlock(PaddedBlockByteLength());
		pad.Pad(rng, plainText, plainTextLength, paddedBlock, PaddedBlockBitLength());
		f.ApplyFunction(Integer(paddedBlock, paddedBlock.size)).Encode(cipherText, CipherTextLength());
	};
	
protected:
	EncryptorTemplate() {}
};


#endif


