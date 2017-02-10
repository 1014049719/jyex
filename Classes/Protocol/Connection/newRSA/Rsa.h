/*
 *  Rsa.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _RSA_H_
#define _RSA_H_


#include "pubkey.h"
#include "integer.h"

#include"BaseFunction.h"



class RSAPrivateKeyTemplate : public DecryptorTemplate
	{
	public:
		RSAPrivateKeyTemplate(const Integer &n, const Integer &e, const Integer &d,
							  const Integer &p, const Integer &q, const Integer &dp, const Integer &dq, const Integer &u)
		: PublicKeyBaseTemplateInvertableRSAFunction(InvertableRSAFunction(n, e, d, p, q, dp, dq, u)) {}
		
		RSAPrivateKeyTemplate(const Integer &n, const Integer &e, const Integer &d)
		: PublicKeyBaseTemplateInvertableRSAFunction(InvertableRSAFunction(n, e, d)) {}
		
//		RSAPrivateKeyTemplate(RandomNumberGenerator &rng, unsigned int keybits, const Integer &eStart=1256377279)
//		: PublicKeyBaseTemplateInvertableRSAFunction(InvertableRSAFunction(rng, keybits, eStart)) {}
		
		RSAPrivateKeyTemplate(BufferedTransformation &bt)
		: PublicKeyBaseTemplateInvertableRSAFunction(bt) {}
	};



class RSAPublicKeyTemplate : public EncryptorTemplate
	{
	public:
		RSAPublicKeyTemplate(const Integer &n, const Integer &e)
		: PublicKeyBaseTemplateRSAFunction(RSAFunction(n, e)) {}
		
		RSAPublicKeyTemplate(const RSAPrivateKeyTemplate &priv)
		: PublicKeyBaseTemplateRSAFunction(priv.GetTrapdoorFunction()) {}
		
		RSAPublicKeyTemplate(BufferedTransformation &bt)
		: PublicKeyBaseTemplateRSAFunction(bt) {}
	};



typedef RSAPrivateKeyTemplate	RSAES_PKCS1v15_Decryptor;
typedef RSAPublicKeyTemplate  RSAES_PKCS1v15_Encryptor;



#endif

