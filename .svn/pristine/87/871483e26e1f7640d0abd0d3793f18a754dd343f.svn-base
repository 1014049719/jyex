/*
 *  BaseFunction.cpp
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-26.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include"BaseFunction.h"

#include "stdafx.h"
#include "Asn.h"
#include "Hex.h"
#include "Nbtheory.h"
#include "Modarith.h"





RSAFunction::RSAFunction(BufferedTransformation &bt)
{
	BERSequenceDecoder seq(bt);
	n.BERDecode(seq);
	e.BERDecode(seq);
}

void RSAFunction::DEREncode(BufferedTransformation &bt) const
{
	DERSequenceEncoder seq(bt);
	n.DEREncode(seq);
	e.DEREncode(seq);
}

Integer RSAFunction::ApplyFunction(const Integer &x) const
{
	return a_exp_b_mod_c(x, e, n);
}



// *****************************************************************************
InvertableRSAFunction::InvertableRSAFunction(const Integer &n, const Integer &e, const Integer &d,
											 const Integer &p, const Integer &q, const Integer &dp, const Integer &dq, const Integer &u)
: RSAFunction(n, e), d(d), p(p), q(q), dp(dp), dq(dq), u(u)
{
	ASSERT(p*q==n);
	ASSERT(d*e%LCM(p-1, q-1)==1);
	ASSERT(dp==d%(p-1));
	ASSERT(dq==d%(q-1));
	ASSERT(u*q%p==1);
}

InvertableRSAFunction::InvertableRSAFunction(BufferedTransformation &bt)
{
	BERSequenceDecoder seq(bt);
	
	Integer version(seq);
	if (!!version)  // make sure version is 0
		BERDecodeError();
	
	n.BERDecode(seq);
	e.BERDecode(seq);
	d.BERDecode(seq);
	p.BERDecode(seq);
	q.BERDecode(seq);
	dp.BERDecode(seq);
	dq.BERDecode(seq);
	u.BERDecode(seq);
}

InvertableRSAFunction::InvertableRSAFunction(const Integer &n_temp, 
											 const Integer &e_temp,
											 const Integer &d_temp)
{
	if (n_temp.IsEven() || e_temp.IsEven() | d_temp.IsEven())
		ASSERT("InvertibleRSAFunction: input is not a valid RSA private key");
	
	n = n_temp;
	e = e_temp;
	d = d_temp;
	
	Integer r = --(d_temp*e_temp);
	unsigned int s = 0;
	while (r.IsEven())
	{
		r >>= 1;
		s++;
	}
	
	ModularArithmetic modn(n_temp);
	for (Integer i = 2; ; ++i)
	{
		Integer a = modn.Exponentiate(i, r);
		if (a == 1)
			continue;
		Integer b;
		unsigned int j = 0;
		while (a != n-1)
		{
			b = modn.Square(a);
			if (b == 1)
			{
				p = GCD(a-1, n_temp);
				q = n_temp/p;
				dp = d % (p-1);
				dq = d % (q-1);
				u = q.InverseMod(p);
				return;
			}
			if (++j == s)
				ASSERT("InvertibleRSAFunction: input is not a valid RSA private key");
			a = b;
		}
	}
}

void InvertableRSAFunction::DEREncode(BufferedTransformation &bt) const
{
	DERSequenceEncoder seq(bt);
	
	const byte version[] = {INTEGER, 1, 0};
	seq.Put(version, sizeof(version));
	n.DEREncode(seq);
	e.DEREncode(seq);
	d.DEREncode(seq);
	p.DEREncode(seq);
	q.DEREncode(seq);
	dp.DEREncode(seq);
	dq.DEREncode(seq);
	u.DEREncode(seq);
}

Integer InvertableRSAFunction::CalculateInverse(const Integer &x) const 
{
	// here we follow the notation of PKCS #1 and let u=q inverse mod p
	// but in ModRoot, u=p inverse mod q, so we reverse the order of p and q
	return ModularRoot(x, dq, dp, q, p, u);
}