#ifndef CRYPTOPP_MISC_H
#define CRYPTOPP_MISC_H

#include "config.h"
#include <ASSERT.h>
#include <memory.h>
#include <algorithm>
#include"stdafx.h"

inline unsigned int min(unsigned int a,unsigned int b)
{
	return a>b?b:a;
}

inline unsigned int CountWords(const word *X, unsigned int N)
{
	while (N && X[N-1]==0)
		N--;
	return N;
}

inline void SetWords(word *r, word a, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] = a;
}

inline void CopyWords(word *r, const word *a, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] = a[i];
}

inline void XorWords(word *r, const word *a, const word *b, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] = a[i] ^ b[i];
}

inline void XorWords(word *r, const word *a, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] ^= a[i];
}

inline void AndWords(word *r, const word *a, const word *b, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] = a[i] & b[i];
}

inline void AndWords(word *r, const word *a, unsigned int n)
{
	for (unsigned int i=0; i<n; i++)
		r[i] &= a[i];
}

inline word ShiftWordsLeftByBits(word *r, unsigned int n, unsigned int shiftBits)
{
	ASSERT (shiftBits<WORD_BITS);
	word u, carry=0;
	if (shiftBits)
		for (unsigned int i=0; i<n; i++)
		{
			u = r[i];
			r[i] = (u << shiftBits) | carry;
			carry = u >> (WORD_BITS-shiftBits);
		}
	return carry;
}

inline word ShiftWordsRightByBits(word *r, unsigned int n, unsigned int shiftBits)
{
	ASSERT (shiftBits<WORD_BITS);
	word u, carry=0;
	if (shiftBits)
		for (int i=n-1; i>=0; i--)
		{
			u = r[i];
			r[i] = (u >> shiftBits) | carry;
			carry = u << (WORD_BITS-shiftBits);
		}
	return carry;
}

inline void ShiftWordsLeftByWords(word *r, unsigned int n, unsigned int shiftWords)
{
	if (n && shiftWords)
	{
		for (unsigned i=n-1; i>=shiftWords; i--)
			r[i] = r[i-shiftWords];
		SetWords(r, 0,min(n,shiftWords));
	}
}

inline void ShiftWordsRightByWords(word *r, unsigned int n, unsigned int shiftWords)
{
	if (n && shiftWords)
	{
		for (unsigned i=0; i<n-shiftWords; i++)
			r[i] = r[i+shiftWords];
		SetWords(r+n-shiftWords, 0, min(n, shiftWords));
	}
}

inline unsigned int bitsToBytes(unsigned int bitCount)
{
	return ((bitCount+7)/(8));
}

inline unsigned int bytesToWords(unsigned int byteCount)
{
	return ((byteCount+WORD_SIZE-1)/WORD_SIZE);
}

inline unsigned int bitsToWords(unsigned int bitCount)
{
	return ((bitCount+WORD_BITS-1)/(WORD_BITS));
}

void xorbuf(byte *buf, const byte *mask, unsigned int count);
void xorbuf(byte *output, const byte *input, const byte *mask, unsigned int count);

template <class T> inline T rotl(T x, unsigned int y)
{
	return ((x<<y) | (x>>(sizeof(T)*8-y)));
}

template <class T> inline T rotr(T x, unsigned int y)
{
	return ((x>>y) | (x<<(sizeof(T)*8-y)));
}

#if defined(_MSC_VER) || defined(__BCPLUSPLUS__)

#include <stdlib.h>
#define FAST_ROTATE

template<> inline unsigned short rotl<unsigned short>(unsigned short x, unsigned int y)
{
	return (unsigned short)((x<<y) | (x>>(16-y)));
}

template<> inline unsigned short rotr<unsigned short>(unsigned short x, unsigned int y)
{
	return (unsigned short)((x>>y) | (x<<(16-y)));
}

template<> inline unsigned long rotl<unsigned long>(unsigned long x, unsigned int y)
{
	return _lrotl(x, y);
}

template<> inline unsigned long rotr<unsigned long>(unsigned long x, unsigned int y)
{
	return _lrotr(x, y);
}
#endif // defined(_MSC_VER) || defined(__BCPLUSPLUS__)

inline word16 byteReverse(word16 value)
{
	return rotl(value, 8U);
}

inline word32 byteReverse(word32 value)
{
#ifdef FAST_ROTATE
	// 5 instructions with rotate instruction, 9 without
	return (rotr(value, 8U) & 0xff00ff00) | (rotl(value, 8U) & 0x00ff00ff);
#else
	// 6 instructions with rotate instruction, 8 without
	value = ((value & 0xFF00FF00) >> 8) | ((value & 0x00FF00FF) << 8);
	return rotl(value, 16U);
#endif
}

#ifdef WORD64_AVAILABLE
inline word64 byteReverse(word64 value)
{
	value = ((value & W64LIT(0xFF00FF00FF00FF00)) >> 8) | ((value & W64LIT(0x00FF00FF00FF00FF)) << 8);
	value = ((value & W64LIT(0xFFFF0000FFFF0000)) >> 16) | ((value & W64LIT(0x0000FFFF0000FFFF)) << 16);
	return rotl(value, 32U);
}
#endif

template <class T> void byteReverse(T *out, const T *in, unsigned int byteCount)
{
	ASSERT(byteCount%sizeof(T) == 0);
	byteCount /= sizeof(T);
	for (unsigned i=0; i<byteCount; i++)
		out[i] = byteReverse(in[i]);
}

#ifdef _MSC_VER
#define GETBYTE(x, y) (((byte *)&(x))[y])
#else
#define GETBYTE(x, y) (unsigned int)(((x)>>(8*(y)))&255)
#endif

unsigned int Parity(unsigned long);
unsigned int BytePrecision(unsigned long);
unsigned int BitPrecision(unsigned long);
unsigned long Crop(unsigned long, int size);

// ********************************************************

#ifdef SECALLOC_DEFAULT
#define SecAlloc(type, number) (new type[(number)])
#define SecFree(ptr, number) if (!ptr) return; memset((ptr), 0, (number)*sizeof(*(ptr))); delete [] (ptr);
#else
#define SecAlloc(type, number) (new type[(number)])
#define SecFree(ptr, number) (if (ptr) delete [] (ptr);)
#endif

struct SecBlockword
{
	SecBlockword(unsigned int size=0)
		: size(size) {ptr = SecAlloc(word, size);}
	SecBlockword(const SecBlockword &t)
		: size(t.size) {ptr = SecAlloc(word, size); CopyFrom(t);}
	SecBlockword(const word *t, unsigned int size)
		: size(size) {ptr = SecAlloc(word, size); memcpy(ptr, t, size*sizeof(word));}
	~SecBlockword()
		{SecFree(ptr, size);}

#if defined(__GNUC__) || defined(__BCPLUSPLUS__)
	operator const void *() const
		{return ptr;}
	operator void *()
		{return ptr;}
#endif

	operator const word *() const
		{return ptr;}
	operator word *()
		{return ptr;}

#ifndef _MSC_VER
	friend word *operator +(SecBlockword& blk,unsigned int offset)
		{return blk.ptr+offset;}
	const word *operator +(unsigned int offset) const
		{return ptr+offset;}
	word& operator[](unsigned int index)
		{ASSERT(index<size); return ptr[index];}
	const word& operator[](unsigned int index) const
		{ASSERT(index<size); return ptr[index];}
#endif
	
	void SetValue(int value,int from,int to)
	{
		if(from>to)
			return;
		for(int index = from;index<=to;index++)
		{
			ptr[index] = value;
		}
	};
	
	void SetIndex(int index,word value)
	{ASSERT(index<size);ptr[index] = value;}
	
	word GetIndex(int index) const
	{ASSERT(index<size);return ptr[index];}

	const word* Begin() const
		{return ptr;}
	word* Begin()
		{return ptr;}
	const word* End() const
		{return ptr+size;}
	word* End()
		{return ptr+size;}

	void CopyFrom(const SecBlockword &t)
	{
		New(t.size);
		memcpy(ptr, t.ptr, size*sizeof(word));
	}

	SecBlockword& operator=(const SecBlockword &t)
	{
		CopyFrom(t);
		return *this;
	}

	bool operator==(const SecBlockword &t) const
	{
		return size == t.size && memcmp(ptr, t.ptr, size*sizeof(word)) == 0;
	}

	void New(unsigned int newSize)
	{
		if (newSize != size)
		{
			word *newPtr = SecAlloc(word, newSize);
			ASSERT(newPtr);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}

	void CleanNew(unsigned int newSize)
	{
		if (newSize != size)
		{
			word *newPtr = SecAlloc(word, newSize);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
		memset(ptr, 0, size*sizeof(word));
	}

	void Grow(unsigned int newSize)
	{
		if (newSize > size)
		{
			word *newPtr = SecAlloc(word, newSize);
			memcpy(newPtr, ptr, size*sizeof(word));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}

	void CleanGrow(unsigned int newSize)
	{
		if (newSize > size)
		{
			word *newPtr = SecAlloc(word, newSize);
			memcpy(newPtr, ptr, size*sizeof(word));
			memset(newPtr+size, 0, (newSize-size)*sizeof(word));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}

	void Resize(unsigned int newSize)
	{
		if (newSize != size)
		{
			word *newPtr = SecAlloc(word, newSize);
			memcpy(newPtr, ptr, STDMIN(newSize, size)*sizeof(word));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	void swap(unsigned int&A,unsigned int&B)
	{unsigned int C = A;A = B;B = C;}
	void swap(word* &A,word* &B)
	{word *C = A;A = B;B = C;}
	void swap(SecBlockword &b)
	{	
		swap(size, b.size);
		swap(ptr, b.ptr);
	}


	unsigned int size;
	word *ptr;
};



//typedef SecBlock<byte> SecByteBlock;
typedef SecBlockword SecWordBlock;
inline void swap(SecBlockword &a, SecBlockword &b)
{
	a.swap(b);
}

/////////////////////////////////////////////////////////////////////////////



struct SecBlockbyte
{
	SecBlockbyte(unsigned int size=0)
	: size(size) {ptr = SecAlloc(byte, size);}
	SecBlockbyte(const SecBlockbyte &t)
	: size(t.size) {ptr = SecAlloc(byte, size); CopyFrom(t);}
	SecBlockbyte(const byte *t, unsigned int size)
	: size(size) {ptr = SecAlloc(byte, size); memcpy(ptr, t, size*sizeof(byte));}
	~SecBlockbyte()
	{SecFree(ptr, size);}
	
#if defined(__GNUC__) || defined(__BCPLUSPLUS__)
	operator const void *() const
	{return ptr;}
	operator void *()
	{return ptr;}
#endif
	
	operator const byte *() const
	{return ptr;}
	operator byte *()
	{return ptr;}
	
#ifndef _MSC_VER
	byte *operator +(unsigned int offset)
	{return ptr+offset;}
	const byte *operator +(unsigned int offset) const
	{return ptr+offset;}
	byte& operator[](unsigned int index)
	{ASSERT(index<size); return ptr[index];}
	const byte& operator[](unsigned int index) const
	{ASSERT(index<size); return ptr[index];}
#endif
	
	
	void SetValue(int value,int from,int to)
	{
		if(from>to)
			return;
		for(int index = from;index<=to;index++)
		{
			ptr[index] = value;
		}
	};
	
	void SetIndex(int index,byte value)
	{ASSERT(index<size);ptr[index] = value;}
	
	byte GetIndex(int index) const
	{ASSERT(index<size);return ptr[index];}
	
	const byte* Begin() const
	{return ptr;}
	byte* Begin()
	{return ptr;}
	const byte* End() const
	{return ptr+size;}
	byte* End()
	{return ptr+size;}
	
	void CopyFrom(const SecBlockbyte &t)
	{
		New(t.size);
		memcpy(ptr, t.ptr, size*sizeof(byte));
	}
	
	SecBlockbyte& operator=(const SecBlockbyte &t)
	{
		CopyFrom(t);
		return *this;
	}
	
	bool operator==(const SecBlockbyte &t) const
	{
		return size == t.size && memcmp(ptr, t.ptr, size*sizeof(byte)) == 0;
	}
	
	void New(unsigned int newSize)
	{
		if (newSize != size)
		{
			byte *newPtr = SecAlloc(byte, newSize);
			ASSERT(newPtr);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void CleanNew(unsigned int newSize)
	{
		if (newSize != size)
		{
			byte *newPtr = SecAlloc(byte, newSize);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
		memset(ptr, 0, size*sizeof(byte));
	}
	
	void Grow(unsigned int newSize)
	{
		if (newSize > size)
		{
			byte *newPtr = SecAlloc(byte, newSize);
			memcpy(newPtr, ptr, size*sizeof(byte));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void CleanGrow(unsigned int newSize)
	{
		if (newSize > size)
		{
			byte *newPtr = SecAlloc(byte, newSize);
			memcpy(newPtr, ptr, size*sizeof(byte));
			memset(newPtr+size, 0, (newSize-size)*sizeof(byte));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void Resize(unsigned int newSize)
	{
		if (newSize != size)
		{
			byte *newPtr = SecAlloc(byte, newSize);
			memcpy(newPtr, ptr, STDMIN(newSize, size)*sizeof(byte));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	void swap(unsigned int&A,unsigned int&B)
	{unsigned int C = A;A = B;B = C;}
	void swap(byte* &A,byte* &B)
	{byte *C = A;A = B;B = C;}
	void swap(SecBlockbyte &b)
	{	
		swap(size, b.size);
		swap(ptr, b.ptr);
	}
	
	
	unsigned int size;
	byte *ptr;
};



//typedef SecBlock<byte> SecByteBlock;
typedef SecBlockbyte SecByteBlock;
inline void swap(SecBlockbyte &a, SecBlockbyte &b)
{
	a.swap(b);
}


//////////////////////////////////////////////////////////////////

struct SecBlockword32
{
	SecBlockword32(unsigned int size=0)
	: size(size) {ptr = SecAlloc(word32, size);}
	SecBlockword32(const SecBlockword32 &t)
	: size(t.size) {ptr = SecAlloc(word32, size); CopyFrom(t);}
	SecBlockword32(const word32 *t, unsigned int size)
	: size(size) {ptr = SecAlloc(word32, size); memcpy(ptr, t, size*sizeof(word32));}
	~SecBlockword32()
	{SecFree(ptr, size);}
	
#if defined(__GNUC__) || defined(__BCPLUSPLUS__)
	operator const void *() const
	{return ptr;}
	operator void *()
	{return ptr;}
#endif
	
	operator const word32 *() const
	{return ptr;}
	operator word32 *()
	{return ptr;}
	
#ifndef _MSC_VER
	word32 *operator +(unsigned int offset)
	{return ptr+offset;}
	const word32 *operator +(unsigned int offset) const
	{return ptr+offset;}
	word32& operator[](unsigned int index)
	{ASSERT(index<size); return ptr[index];}
	const word32& operator[](unsigned int index) const
	{ASSERT(index<size); return ptr[index];}
#endif
	
	
	void SetValue(int value,int from,int to)
	{
		if(from>to)
			return;
		for(int index = from;index<=to;index++)
		{
			ptr[index] = value;
		}
	};
	
	void SetIndex(int index,word32 value)
	{ASSERT(index<size);ptr[index] = value;}
	
	word32 GetIndex(int index) const
	{ASSERT(index<size);return ptr[index];}
	
	const word32* Begin() const
	{return ptr;}
	word32* Begin()
	{return ptr;}
	const word32* End() const
	{return ptr+size;}
	word32* End()
	{return ptr+size;}
	
	void CopyFrom(const SecBlockword32 &t)
	{
		New(t.size);
		memcpy(ptr, t.ptr, size*sizeof(word32));
	}
	
	SecBlockword32& operator=(const SecBlockword32 &t)
	{
		CopyFrom(t);
		return *this;
	}
	
	bool operator==(const SecBlockword32 &t) const
	{
		return size == t.size && memcmp(ptr, t.ptr, size*sizeof(word32)) == 0;
	}
	
	void New(unsigned int newSize)
	{
		if (newSize != size)
		{
			word32 *newPtr = SecAlloc(word32, newSize);
			ASSERT(newPtr);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void CleanNew(unsigned int newSize)
	{
		if (newSize != size)
		{
			word32 *newPtr = SecAlloc(word32, newSize);
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
		memset(ptr, 0, size*sizeof(word32));
	}
	
	void Grow(unsigned int newSize)
	{
		if (newSize > size)
		{
			word32 *newPtr = SecAlloc(word32, newSize);
			memcpy(newPtr, ptr, size*sizeof(word32));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void CleanGrow(unsigned int newSize)
	{
		if (newSize > size)
		{
			word32 *newPtr = SecAlloc(word32, newSize);
			memcpy(newPtr, ptr, size*sizeof(word32));
			memset(newPtr+size, 0, (newSize-size)*sizeof(word32));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	
	void Resize(unsigned int newSize)
	{
		if (newSize != size)
		{
			word32 *newPtr = SecAlloc(word32, newSize);
			memcpy(newPtr, ptr, STDMIN(newSize, size)*sizeof(word32));
			SecFree(ptr, size);
			ptr = newPtr;
			size = newSize;
		}
	}
	void swap(unsigned int&A,unsigned int&B)
	{unsigned int C = A;A = B;B = C;}
	void swap(word32* &A,word32* &B)
	{word32 *C = A;A = B;B = C;}
	void swap(SecBlockword32 &b)
	{	
		swap(size, b.size);
		swap(ptr, b.ptr);
	}
	
	
	unsigned int size;
	word32 *ptr;
};



//typedef SecBlock<byte> SecByteBlock;
typedef SecBlockword32 SecWordBlock32;
inline void swap(SecBlockword32 &a, SecBlockword32 &b)
{
	a.swap(b);
}














#endif // MISC_H
