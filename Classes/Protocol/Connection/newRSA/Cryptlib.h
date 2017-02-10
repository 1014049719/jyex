/*
 *  Cryptlib.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _CRYPT_LIB_H_
#define _CRYPT_LIB_H_
#include "config.h"
//#include <string>
#include <exception>



enum CipherDir {
	///
	ENCRYPTION, 
	///
DECRYPTION};


/// abstract base class for block ciphers

/** All classes derived from BlockTransformation are block ciphers
 in ECB mode (for example the DESEncryption class), which are stateless.
 These classes should not be used directly, but only in combination with
 a mode class (see \Ref{CipherMode}).
 
 Note: BlockTransformation objects may assume that pointers to input and
 output blocks are aligned on 32-bit word boundaries.
 */
class BlockTransformation
	{
	public:
		///
		virtual ~BlockTransformation() {}
		
		/// encrypt or decrypt one block in place
		//* Precondition: size of inoutBlock == BlockSize().
		virtual void ProcessBlock(byte *inoutBlock) const =0;
		
		/// encrypt or decrypt one block, may assume inBlock != outBlock
		//* Precondition: size of inBlock and outBlock == BlockSize().
		virtual void ProcessBlock(const byte *inBlock, byte *outBlock) const =0;
		
		/// block size of the cipher in bytes
		virtual unsigned int BlockSize() const =0;
	};


/// abstract base class for stream ciphers

class StreamCipher
	{
	public:
		///
		virtual ~StreamCipher() {}
		
		/// encrypt or decrypt one byte
		virtual byte ProcessByte(byte input) =0;
		
		/// encrypt or decrypt an array of bytes of specified length in place
		virtual void ProcessString(byte *inoutString, unsigned int length);
		/// encrypt or decrypt an array of bytes of specified length, may assume inString != outString
		virtual void ProcessString(byte *outString, const byte *inString, unsigned int length);
	};

///	abstract base class for random access stream ciphers

class RandomAccessStreamCipher : public virtual StreamCipher
{
public:
	///
	virtual ~RandomAccessStreamCipher() {}
	/*/ specify that the next byte to be processed is at absolute position n
	 in the plaintext/ciphertext stream */
	virtual void Seek(unsigned long n) =0;
};




class RandomNumberGenerator
	{
	public:
		///
		virtual ~RandomNumberGenerator() {}
		
		/// generate new random byte and return it
		virtual byte GetByte() =0;
		
		/// generate new random bit and return it
		/** Default implementation is to call GetByte() and return its parity. */
		virtual unsigned int GetBit();
		
		/// generate a random 32 bit word in the range min to max, inclusive
		virtual word32 GetLong(word32 a=0, word32 b=0xffffffffL);
		/// generate a random 16 bit word in the range min to max, inclusive
		virtual word16 GetShort(word16 a=0, word16 b=0xffff)
		{return (word16)GetLong(a, b);}
		
		/// generate random array of bytes
		//* Default implementation is to call GetByte size times.
		virtual void GetBlock(byte *output, unsigned int size);
	};


/** BufferedTransformation is a generalization of \Ref{BlockTransformation},
 \Ref{StreamCipher}, and \Ref{HashModule}.
 
 A buffered transformation is an object that takes a stream of bytes 
 as input (this may be done in stages), does some computation on them, and
 then places the result into an internal buffer for later retrieval.  Any
 partial result already in the output buffer is not modified by further
 input.
 
 Computation is generally done as soon as possible, but some buffering
 on the input may be done for performance reasons.
 */
class BufferedTransformation
	{
	public:
		///
		virtual ~BufferedTransformation() {}
		
		//@Man: INPUT
		//@{
		/// input a byte for processing
		virtual void Put(byte inByte) =0;
		/// input multiple bytes
		virtual void Put(const byte *inString, unsigned int length) =0;
		/// signal that no more input is available
		virtual void InputFinished() {}
		
		/// input a 16-bit word, big-endian or little-endian depending on highFirst
		void PutShort(word16 value, bool highFirst=true);
		/// input a 32-bit word
		void PutLong(word32 value, bool highFirst=true);
		//@}
		
		//@Man: RETRIEVAL
		//@{
		/// returns number of bytes that is currently ready for retrieval
		/** All	retrieval functions return the actual number of bytes
		 retrieved, which is the lesser of the request number and
		 MaxRetrieveable(). */
		virtual unsigned long MaxRetrieveable() =0;
		
		/// try to retrieve a single byte
		virtual unsigned int Get(byte &outByte) =0;
		/// try to retrieve multiple bytes
		virtual unsigned int Get(byte *outString, unsigned int getMax) =0;
		
		/// try to retrieve a 16-bit word, big-endian or little-endian depending on highFirst
		int GetShort(word16 &value, bool highFirst=true);
		/// try to retrieve a 32-bit word
		int GetLong(word32 &value, bool highFirst=true);
		
		/// move all of the buffered output to target as input
		virtual void TransferTo(BufferedTransformation &target);
		/// same as above but only transfer up to transferMax bytes
		virtual unsigned int TransferTo(BufferedTransformation &target, unsigned int transferMax);
		
		/// peek at the next byte without removing it from the output buffer
		virtual unsigned int Peek(byte &outByte) const =0;
		
		/// discard some bytes from the output buffer
		unsigned int Skip(unsigned int skipMax);
		//@}
		
		//@Man: ATTACHMENT
		//@{
		/** Some BufferedTransformation objects (e.g. \Ref{Filter} objects)
		 allow other BufferedTransformation objects to be attached.  When
		 this is done, the first object instead of buffering its output,
		 sents that output to the attached object as input.  See the
		 documentation for the \Ref{Filter} class for the details.
		 */
		///
		virtual bool Attachable() {return false;}
		///
		virtual void Detach(BufferedTransformation *p = 0) {}	// NULL is undefined at this point
		///
		virtual void Attach(BufferedTransformation *) {}
		/// call InputFinished() for all attached objects
		virtual void Close() {InputFinished();}
		//@}
	};

/// abstract base class for public-key encryptors and decryptors

/** This class provides an interface common to encryptors and decryptors
 for querying their plaintext and ciphertext lengths.
 */
class PK_CryptoSystem
	{
	public:
		///
		virtual ~PK_CryptoSystem() {}
		
		/// maximum length of plaintext for a given ciphertext length
		//* This function returns 0 if cipherTextLength is not valid (too long or too short).
		virtual unsigned int MaxPlainTextLength(unsigned int cipherTextLength) const =0;
		
		/// calculate length of ciphertext given length of plaintext
		//* This function returns 0 if plainTextLength is not valid (too long).
		virtual unsigned int CipherTextLength(unsigned int plainTextLength) const =0;
	};

///	abstract base class for public-key encryptors

/** An encryptor is also a public encryption key.  It contains both the
 key and the algorithm to perform the encryption.
 */
class PK_Encryptor : public virtual PK_CryptoSystem
{
public:
	/// encrypt a byte string
	/** Preconditions:
	 \begin{itemize} 
	 \item CipherTextLength(plainTextLength) != 0 (i.e., plainText isn't too long)
	 \item size of cipherText == CipherTextLength(plainTextLength)
	 \end{itemize}
	 */
	virtual void Encrypt(RandomNumberGenerator &rng, const byte *plainText, unsigned int plainTextLength, byte *cipherText) =0;
};

///	abstract base class for public-key decryptors

/** An decryptor is also a private decryption key.  It contains both the
 key and the algorithm to perform the decryption.
 */
class PK_Decryptor : public virtual PK_CryptoSystem
{
public:
	/// decrypt a byte string, and return the length of plaintext
	/** Precondition: size of plainText == MaxPlainTextLength(cipherTextLength)
	 bytes.  
	 
	 The function returns the actual length of the plaintext, or 0
	 if decryption fails.
	 */
	virtual unsigned int Decrypt(const byte *cipherText, unsigned int cipherTextLength, byte *plainText) =0;
};

/// abstract base class for encryptors and decryptors with fixed length ciphertext

/** A simplified interface (as embodied in this
 class and its subclasses) is provided for crypto systems (such
 as RSA) whose ciphertext length depend only on the key, not on the length
 of the plaintext.  The maximum plaintext length also depend only on
 the key.
 */
class PK_FixedLengthCryptoSystem : public virtual PK_CryptoSystem
{
public:
	///
	virtual unsigned int MaxPlainTextLength() const =0;
	///
	virtual unsigned int CipherTextLength() const =0;
	
	unsigned int MaxPlainTextLength(unsigned int cipherTextLength) const;
	unsigned int CipherTextLength(unsigned int plainTextLength) const;
};

/// abstract base class for encryptors with fixed length ciphertext

class PK_FixedLengthEncryptor : public virtual PK_Encryptor, public virtual PK_FixedLengthCryptoSystem
{
};

/// abstract base class for decryptors with fixed length ciphertext

class PK_FixedLengthDecryptor : public virtual PK_Decryptor, public virtual PK_FixedLengthCryptoSystem
{
public:
	/// decrypt a byte string, and return the length of plaintext
	/** Preconditions:
	 \begin{itemize} 
	 \item length of cipherText == CipherTextLength()
	 \item size of plainText == MaxPlainTextLength()
	 \end{itemize}
	 
	 The function returns the actual length of the plaintext, or 0
	 if decryption fails.
	 */
	virtual unsigned int Decrypt(const byte *cipherText, byte *plainText) =0;
	
	unsigned int Decrypt(const byte *cipherText, unsigned int cipherTextLength, byte *plainText);
};

#endif
