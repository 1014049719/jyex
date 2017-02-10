/*
 *  Modes.cpp
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Modes.h"
#include "stdafx.h"

CipherMode::CipherMode(const BlockTransformation &c, const byte *IV)
: cipher(c),
S(cipher.BlockSize()),
reg(IV, S),
buffer(S)
{
}

FeedBackMode::FeedBackMode(const BlockTransformation &cipher, const byte *IV, int fbs)
: CipherMode(cipher, IV), FBS(fbs ? fbs : S)
{
	cipher.ProcessBlock(reg, buffer);
	counter = 0;
}

void FeedBackMode::DoFeedBack()
{
	for (int i=0; i<(S-FBS); i++)
	{
		//reg[i] = reg[FBS+i];
		reg.SetIndex(i,reg.GetIndex(FBS+i));
	}
		
	//memcpy(reg+S-FBS, buffer, FBS);
	for(int j = 0;j<FBS;j++)
	{
		reg.SetIndex(S-FBS+j,buffer.GetIndex(j));
	}
	cipher.ProcessBlock(reg, buffer);
	counter = 0;
}

void CFBEncryption::ProcessString(byte *outString, const byte *inString, unsigned int length)
{
	while(length--)
		*outString++ = CFBEncryption::ProcessByte(*inString++);
}

void CFBEncryption::ProcessString(byte *inoutString, unsigned int length)
{
	while(length--)
		*inoutString++ = CFBEncryption::ProcessByte(*inoutString);
}

void CFBDecryption::ProcessString(byte *outString, const byte *inString, unsigned int length)
{
	while(length--)
		*outString++ = CFBDecryption::ProcessByte(*inString++);
}

void CFBDecryption::ProcessString(byte *inoutString, unsigned int length)
{
	while(length--)
		*inoutString++ = CFBDecryption::ProcessByte(*inoutString);
}

void OFB::ProcessString(byte *outString, const byte *inString, unsigned int length)
{
	while(length--)
		*outString++ = *inString++ ^ OFB::GetByte();
}

void OFB::ProcessString(byte *inoutString, unsigned int length)
{
	while(length--)
		*inoutString++ ^= OFB::GetByte();
}

CounterMode::CounterMode(const BlockTransformation &cipher, const byte *IVin)
: CipherMode(cipher, IVin), IV(IVin, S)
{
	cipher.ProcessBlock(reg, buffer);
	size=0;
}

void CounterMode::ProcessString(byte *outString, const byte *inString, unsigned int length)
{
	while(length--)
		*outString++ = *inString++ ^ CounterMode::GetByte();
}

void CounterMode::ProcessString(byte *inoutString, unsigned int length)
{
	while(length--)
		*inoutString++ ^= CounterMode::GetByte();
}

void CounterMode::Seek(unsigned long position)
{
	unsigned long blockIndex = position / S;
	
	// set register to IV+blockIndex
	int carry=0;
	for (int i=S-1; i>=0; i--)
	{
		//int sum = IV[i] + byte(blockIndex) + carry;
		int sum = IV.GetIndex(i) + byte(blockIndex) + carry;
		//reg[i] = (byte) sum;
		reg.SetIndex(i,(byte)sum);
		carry = sum >> 8;
		blockIndex >>= 8;
	}
	
	cipher.ProcessBlock(reg, buffer);
	size = int(position % S);
}

void CounterMode::IncrementCounter()
{
	for (int i=S-1, carry=1; i>=0 && carry; i--)
	{
		//carry=!++reg[i];
		int value = reg.GetIndex(i);
		value++;
		reg.SetIndex(i,value);
		carry = !value;
	}
    	
	
	cipher.ProcessBlock(reg, buffer);
	size=0;
}

void PGP_CFBEncryption::Sync()
{
	if (counter)
	{
		for (int i=0; i<counter; i++)
		{
			buffer.SetIndex(S-counter+i,buffer.GetIndex(i));
		}
		//	buffer[S-counter+i] = buffer[i];
		//memcpy(buffer, reg+counter, S-counter);
		for(int j = 0;j<S-counter;j++)
		{
			buffer.SetIndex(j,reg.GetIndex(counter+j));
		}
		counter = 0;
	}
}

// this is exactly the same function as above
void PGP_CFBDecryption::Sync()
{
	if (counter)
	{
		for (int i=0; i<counter; i++)
		{
			buffer.SetIndex(S-counter+i,buffer.GetIndex(i));
		}
		//memcpy(buffer, reg+counter, S-counter);
		for(int j = 0;j<S-counter;j++)
		{
			buffer.SetIndex(j,reg.GetIndex(counter+j));
		}
		counter = 0;
	}
}

