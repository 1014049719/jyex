/*
 *  BaseFunction.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-26.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */


#ifndef BASE_FUNCTION_H_
#define BASE_FUNCTION_H_
#include"Integer.h"

class TrapdoorFunction
	{
	public:
		TrapdoorFunction(){}
		virtual ~TrapdoorFunction() {}
		
		virtual Integer ApplyFunction(const Integer &x) const =0;
		virtual Integer MaxPreimage() const =0;
		virtual Integer MaxImage() const =0;
	};

class InvertableTrapdoorFunction : virtual public TrapdoorFunction
{
public:
	virtual Integer CalculateInverse(const Integer &x) const =0;
};

class RSAFunction : virtual public TrapdoorFunction
{
public:
	RSAFunction(const Integer &n, const Integer &e) : n(n), e(e) {}
	RSAFunction(BufferedTransformation &bt);
	void DEREncode(BufferedTransformation &bt) const;
	
	Integer ApplyFunction(const Integer &x) const;
	Integer MaxPreimage() const {return n-1;}
	Integer MaxImage() const {return n-1;}
	
	const Integer& GetModulus() const {return n;}
	const Integer& GetExponent() const {return e;}
	
protected:
	RSAFunction() {}	// to be used only by InvertableRSAFunction
	Integer n, e;	// these are only modified in constructors
};

class InvertableRSAFunction : public RSAFunction, public InvertableTrapdoorFunction
{
public:
	InvertableRSAFunction(const Integer &n, const Integer &e, const Integer &d,
						  const Integer &p, const Integer &q, const Integer &dp, const Integer &dq, const Integer &u);
	
	InvertableRSAFunction(const Integer &n, const Integer &e, const Integer &d);
	
	// generate a random private key
	InvertableRSAFunction(BufferedTransformation &bt);
	void DEREncode(BufferedTransformation &bt) const;
	
	Integer CalculateInverse(const Integer &x) const;
	
	const Integer& GetPrime1() const {return p;}
	const Integer& GetPrime2() const {return q;}
	const Integer& GetDecryptionExponent() const {return d;}
	const Integer& GetdP() const {return dp;}
	const Integer& GetdQ() const {return dq;}
	const Integer& GetU() const {return u;}
	
protected:
	Integer d, p, q, dp, dq, u;
};


#endif