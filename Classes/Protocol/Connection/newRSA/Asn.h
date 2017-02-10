/*
 *  Asn.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef _ASN_H_
#define _ASN_H_

#include "Cryptlib.h"
#include "Hex.h"


enum ASNTag {INTEGER=0x02, BIT_STRING=0x03, SEQUENCE=0x10};
enum ASNIdFlag {CONSTRUCTED = 0x20};

unsigned int DERLengthEncode(unsigned int length, byte *output);
unsigned int DERLengthEncode(unsigned int length, BufferedTransformation &);
bool BERLengthDecode(BufferedTransformation &bt, unsigned int &length);

#define BERDecodeError() throw BERDecodeErr()

class BERDecodeErr
	{
	};


class BERSequenceDecoder : public BufferedTransformation
	{
	public:
		BERSequenceDecoder(BufferedTransformation &inQueue);
		~BERSequenceDecoder();
		
		void Put(byte) {}
		void Put(const byte *, unsigned int) {}
		
		unsigned long MaxRetrieveable()
		{return inQueue.MaxRetrieveable();}
		unsigned int Get(byte &outByte)
		{return inQueue.Get(outByte);}
		unsigned int Get(byte *outString, unsigned int getMax)
		{return inQueue.Get(outString, getMax);}
		unsigned int Peek(byte &outByte) const
		{return inQueue.Peek(outByte);}
		
	private:
		BufferedTransformation &inQueue;
		bool definiteLength;
		unsigned int length;
	};



class DERSequenceEncoder : public ByteQueue
	{
	public:
		DERSequenceEncoder(BufferedTransformation &outQueue);
		~DERSequenceEncoder();
	private:
		BufferedTransformation &outQueue;
	};




#endif