/*
 *  Hex.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _HEX_H_
#define _HEX_H_
#include "Cryptlib.h"
#include "misc.h"
#include <algorithm>


class ByteQueueNode;

class ByteQueue : public BufferedTransformation
	{
	public:
		ByteQueue(unsigned int nodeSize=256);
		ByteQueue(const ByteQueue &copy);
		~ByteQueue();
		
		// how many bytes currently stored
		unsigned long CurrentSize() const;
		unsigned long MaxRetrieveable()
		{return CurrentSize();}
		
		void Put(byte inByte);
		void Put(const byte *inString, unsigned int length);
		
		// both functions returns the number of bytes actually retrived
		unsigned int Get(byte &outByte);
		unsigned int Get(byte *outString, unsigned int getMax);
		
		unsigned int Peek(byte &outByte) const;
		
		void CopyTo(BufferedTransformation &target) const;
		void CopyTo(byte *target) const;
		
		ByteQueue & operator=(const ByteQueue &rhs);
		bool operator==(const ByteQueue &rhs) const;
		byte operator[](unsigned long i) const;
		
	private:
		void CopyFrom(const ByteQueue &copy);
		void Destroy();
		
		unsigned int nodeSize;
		ByteQueueNode *head, *tail;
	};



















#endif