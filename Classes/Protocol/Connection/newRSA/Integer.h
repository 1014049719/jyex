/*
 *  Integer.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-24.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef _INTEGER_H_
#define _INTEGER_H_

#include "cryptlib.h"
#include "misc.h"

#include <iosfwd>


class Integer
{
public:
	
	
	class DivideByZero
	{
		
	};
	
	///
	class RandomNumberNotFound
	{
	};
	
	///
	enum Signedness {
		///
		UNSIGNED, 
		///
	SIGNED};
	
	///
	enum RandomNumberType {
		///
		ANY, 
		///
	PRIME};
	
	
	
	
	
	Integer(const char *str);
	Integer();
	Integer(const Integer& t);
	Integer(signed long value);
	Integer(word value, unsigned int length);
	Integer(const byte *encodedInteger, unsigned int byteCount, Signedness s=UNSIGNED);
	Integer(BufferedTransformation &bt);
	Integer(const byte *BEREncodedInteger);
	Integer(RandomNumberGenerator &rng, unsigned int bitcount);
	
	
	Integer(RandomNumberGenerator &rng, const Integer &min, const Integer &max, RandomNumberType rnType=ANY, const Integer &equiv=Zero(), const Integer &mod=One());

	
	
	void swap(Integer &a);
	
	Integer		operator+() const {return *this;}
	///
	Integer		operator-() const;
	void Negate();
	friend Integer operator*(const Integer &a, const Integer &b);
	friend Integer operator-(const Integer &a, const Integer &b);
	Integer& operator+=(const Integer& t);
	Integer&  operator-=(const Integer& t);
	bool		operator!() const;
	Integer&  operator=(const Integer& t);
	Integer&  operator*=(const Integer& t)  {return *this = *this*t;}
	Integer&	operator++();
	///
	Integer&	operator--();
	///
	Integer		operator++(int) {Integer temp = *this; ++*this; return temp;}
	///
	Integer		operator--(int) {Integer temp = *this; --*this; return temp;}
	Integer&  operator<<=(unsigned int);
	///
	Integer&  operator>>=(unsigned int);
	
	Integer operator>>(unsigned int n) const	{return Integer(*this)>>=n;}
	///
	Integer operator<<(unsigned int n) const	{return Integer(*this)<<=n;}
	
	///
	Integer&  operator%=(const Integer& t)  {return *this = *this%t;}
	
	
	///
	friend Integer operator+(const Integer &a, const Integer &b);
	friend bool operator==(const Integer& a, const Integer& b) {return (a.Compare(b)==0);}
	///
	friend bool operator!=(const Integer& a, const Integer& b) {return (a.Compare(b)!=0);}
	///
	friend bool operator> (const Integer& a, const Integer& b) {return (a.Compare(b)> 0);}
	///
	friend bool operator>=(const Integer& a, const Integer& b) {return (a.Compare(b)>=0);}
	///
	friend bool operator< (const Integer& a, const Integer& b) {return (a.Compare(b)< 0);}
	///
	friend bool operator<=(const Integer& a, const Integer& b) {return (a.Compare(b)<=0);}
	
	///
	friend Integer operator/(const Integer &a, const Integer &b);
	
	///
	friend word    operator%(const Integer &a, word b);
	
	
	
	friend Integer operator%(const Integer &a, const Integer &b);
	Integer Doubled() const {return *this + *this;}
	///
	Integer Squared() const {return *this * (*this);}
	Integer SquareRoot() const;
	
	bool IsUnit() const;
	bool IsSquare() const;
	
	Integer MultiplicativeInverse() const;
	
	static Integer Gcd(const Integer &a, const Integer &n);
	
	
	friend Integer a_exp_b_mod_c(const Integer &x, const Integer& e, const Integer& m);
	
	
	void Randomize(RandomNumberGenerator &rng, unsigned int bitcount);
	///
	void Randomize(RandomNumberGenerator &rng, const Integer &min, const Integer &max);
	bool Randomize(RandomNumberGenerator &rng, const Integer &min, const Integer &max, RandomNumberType rnType, const Integer &equiv=Zero(), const Integer &mod=One());

	
	
	
	
	int Compare(const Integer& a) const;
	unsigned int WordCount() const;
	
	/// return the n-th bit, n=0 being the least significant bit
	bool GetBit(unsigned int n) const;
	/// return the n-th byte
	byte GetByte(unsigned int n) const;
	
	
	/// set the n-th bit to value
	void SetBit(unsigned int n, bool value=1);
	/// set the n-th byte to value
	void SetByte(unsigned int n, byte value);
	
	
	bool IsNegative() const	{return sign == NEGATIVE;}
	///
	bool NotNegative() const {return sign == POSITIVE;}
	///
	bool IsPositive() const	{return sign == POSITIVE && !!*this;}
	///
	bool IsEven() const	{return GetBit(0) == 0;}
	///
	bool IsOdd() const	{return GetBit(0) == 1;}
	
	
	unsigned int Encode(byte *output, unsigned int outputLen, Signedness signedness=UNSIGNED) const;
	void Decode(const byte *input, unsigned int inputLen, Signedness s);
	
	
	void BERDecode(const byte *input);
	///
	void BERDecode(BufferedTransformation &bt);
	
	
	signed long ConvertToLong() const;
	
	unsigned int MinEncodedSize(Signedness signedness) const;
	
	unsigned int DEREncode(byte *output) const;
	/// encode using DER, put result into a BufferedTransformation object
	unsigned int DEREncode(BufferedTransformation &bt) const;
	
	
	Integer InverseMod(const Integer &n) const;
	
	word InverseMod(word n) const;
	
	
	Integer AbsoluteValue() const;
	
	unsigned int BitCount() const;
	
	unsigned int ByteCount() const;
	
	
	static void Divide(Integer &r, Integer &q, const Integer &a, const Integer &d);
	
	
	static const Integer& Zero();
	static const Integer& One();
	static Integer Power2(unsigned int e);
private:
	
	friend class ModularArithmetic;
	friend class MontgomeryRepresentation;
	friend class HalfMontgomeryRepresentation;
	
	int PositiveCompare(const Integer &t) const;
	friend void PositiveAdd(Integer &sum, const Integer &a, const Integer &b);
	friend void PositiveSubtract(Integer &diff, const Integer &a, const Integer &b);
	friend void PositiveMultiply(Integer &product, const Integer &a, const Integer &b);
	friend void PositiveDivide(Integer &remainder, Integer &quotient, const Integer &dividend, const Integer &divisor);
	
	enum Sign {POSITIVE=0, NEGATIVE=1};
	void swap(Integer::Sign&a,Integer::Sign&b);
	SecWordBlock reg;
	Sign sign;
};

inline void swap(Integer &a, Integer &b)
{
	a.swap(b);
}






#endif
