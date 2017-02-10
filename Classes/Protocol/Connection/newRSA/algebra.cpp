/*
 *  algebra.cpp
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "algebra.h"
#include "stdafx.h"
#include "Integer.h"
#include <vector>



Integer AbstractGroup::Double(const Integer &a) const
{
	return Add(a, a);
}

Integer AbstractGroup::Subtract(const Integer &a, const Integer &b) const
{
	return Add(a, Inverse(b));
}

Integer& AbstractGroup::Accumulate(Integer &a, const Integer &b) const
{
	return a = Add(a, b);
}

Integer& AbstractGroup::Reduce(Integer &a, const Integer &b) const
{
	return a = Subtract(a, b);
}

Integer AbstractRing::Square(const Integer &a) const
{
	return Multiply(a, a);
}

Integer AbstractRing::Divide(const Integer &a, const Integer &b) const
{
	return Multiply(a, MultiplicativeInverse(b));
}

Integer AbstractEuclideanDomain::Mod(const Integer &a, const Integer &b) const
{
	Integer r, q;
	DivisionAlgorithm(r, q, a, b);
	return r;
}

Integer AbstractEuclideanDomain::Gcd(const Integer &a, const Integer &b) const
{
	Integer g[3]={b, a};
	unsigned int i0=0, i1=1, i2=2;
	
	while (!Equal(g[i1], Zero()))
	{
		g[i2] = Mod(g[i0], g[i1]);
		unsigned int t = i0; i0 = i1; i1 = i2; i2 = t;
	}
	
	return g[i0];
}













Integer AbstractGroup::IntMultiply(const Integer &base, const Integer &exponent) const
{
	Integer result;
	//SimultaneousMultiplication(&result, *this, base, &exponent, &exponent+1);
	return result;
}

//Integer AbstractGroup::CascadeIntMultiply(const Integer &x, 
//														  const Integer &e1, const Integer &y, const Integer &e2) const
//{
//	const unsigned expLen = max(e1.BitCount(), e2.BitCount());
//	if (expLen==0)
//		return Zero();
//	
//	const unsigned w = (expLen <= 46 ? 1 : (expLen <= 260 ? 2 : 3));
//	const unsigned tableSize = 1<<w;
//	std::vector<Integer> powerTable(tableSize << w);
//	
//	powerTable[1] = x;
//	powerTable[tableSize] = y;
//	if (w==1)
//		powerTable[3] = Add(x,y);
//	else
//	{
//		powerTable[2] = Double(x);
//		powerTable[2*tableSize] = Double(y);
//		
//		unsigned i, j;
//		
//		for (i=3; i<tableSize; i+=2)
//			powerTable[i] = Add(powerTable[i-2], powerTable[2]);
//		for (i=1; i<tableSize; i+=2)
//			for (j=i+tableSize; j<(tableSize<<w); j+=tableSize)
//				powerTable[j] = Add(powerTable[j-tableSize], y);
//		
//		for (i=3*tableSize; i<(tableSize<<w); i+=2*tableSize)
//			powerTable[i] = Add(powerTable[i-2*tableSize], powerTable[2*tableSize]);
//		for (i=tableSize; i<(tableSize<<w); i+=2*tableSize)
//			for (j=i+2; j<i+tableSize; j+=2)
//				powerTable[j] = Add(powerTable[j-1], x);
//	}
//	
//	Integer result;
//	unsigned power1 = 0, power2 = 0, prevPosition = expLen-1;
//	bool firstTime = true;
//	
//	for (int i = expLen-1; i>=0; i--)
//	{
//		power1 = 2*power1 + e1.GetBit(i);
//		power2 = 2*power2 + e2.GetBit(i);
//		
//		if (i==0 || 2*power1 >= tableSize || 2*power2 >= tableSize)
//		{
//			unsigned squaresBefore = prevPosition-i;
//			unsigned squaresAfter = 0;
//			prevPosition = i;
//			while ((power1 || power2) && power1%2 == 0 && power2%2==0)
//			{
//				power1 /= 2;
//				power2 /= 2;
//				squaresBefore--;
//				squaresAfter++;
//			}
//			if (firstTime)
//			{
//				result = powerTable[(power2<<w) + power1];
//				firstTime = false;
//			}
//			else
//			{
//				while (squaresBefore--)
//					result = Double(result);
//				if (power1 || power2)
//					Accumulate(result, powerTable[(power2<<w) + power1]);
//			}
//			while (squaresAfter--)
//				result = Double(result);
//			power1 = power2 = 0;
//		}
//	}
//	return result;
//}

//Integer GeneralCascadeMultiplication(const AbstractGroup &group, Iterator begin, Iterator end)
//{
//	if (end-begin == 1)
//		return group.IntMultiply((*begin).second, (*begin).first);
//	else if (end-begin == 2)
//		return group.CascadeIntMultiply((*begin).second, (*begin).first, (*(begin+1)).second, (*(begin+1)).first);
//	else
//	{
//		Integer q, r;
//		Iterator last = end;
//		--last;
//		
//		std::make_heap(begin, end);
//		std::pop_heap(begin, end);
//		
//		while (!!(*begin).first)
//		{
//			// (*last).first is largest exponent, (*begin).first is next largest
//			Integer::Divide(r, q, (*last).first, (*begin).first);
//			
//			if (q == Integer::One())
//				group.Accumulate((*begin).second, (*last).second);	// avoid overhead of GeneralizedMultiplication()
//			else
//				group.Accumulate((*begin).second, group.IntMultiply((*last).second, q));
//			
//			(*last).first = r;
//			
//			std::push_heap(begin, end);
//			std::pop_heap(begin, end);
//		}
//		
//		return group.IntMultiply((*last).second, (*last).first);
//	}
//}



class WindowSlider
{
public:
	bool FindFirstWindow(const AbstractGroup &group, 
						 const Integer &expIn)
	{
		exp = &expIn;
		expLen = expIn.BitCount();
		windowSize = expLen <= 17 ? 1 : (expLen <= 24 ? 2 : (expLen <= 70 ? 3 : (expLen <= 197 ? 4 : (expLen <= 539 ? 5 : (expLen <= 1434 ? 6 : 7)))));
		//buckets.resize(1<<(windowSize-1), group.Zero());  //sjw
		int nCount = 1<<windowSize - 1;
		Integer it = group.Zero();
		for(int i = 0;i<nCount;i++)
		{
			buckets[size] = it;
			size++;
		}

	//	buckets.push_back(group.Zero());
		windowEnd = 0;
		return FindNextWindow();
	}
	bool FindNextWindow()
	{
		windowBegin = windowEnd;
		if (windowBegin >= expLen)
			return false;
		const Integer &e = *exp;
		while (!e.GetBit(windowBegin))
			windowBegin++;
		windowEnd = windowBegin+windowSize;
		nextBucket = 0;
		for (unsigned int i=windowBegin+1; i<windowEnd; i++)
		{
			nextBucket |= e.GetBit(i) << (i-windowBegin-1);
			//size++;
		}
			
		ASSERT(nextBucket < buckets.size());
		return true;
	}
	
	
	
	Integer buckets[20];
	const Integer *exp;
	int size;
	unsigned int expLen, windowSize, windowBegin, windowEnd, nextBucket;
};



template <class Iterator, class ConstIterator>
void SimultaneousMultiplication(Iterator result, 
								const AbstractGroup &group,
								const Integer &base,
								ConstIterator expBegin,
								ConstIterator expEnd)
{
	unsigned int expCount = std::distance(expBegin, expEnd);
	
	//std::vector<WindowSlider> exponents(expCount);
	WindowSlider* exponents = new WindowSlider[expCount];
	unsigned int i;
	
	bool notDone = false;
	for (i=0; i<expCount; i++)
		notDone = exponents[i].FindFirstWindow(group, *expBegin++) || notDone;
	
	unsigned int expBitPosition = 0;
	Integer g = base;
	while (notDone)
	{
		notDone = false;
		for (i=0; i<expCount; i++)
		{
			if (expBitPosition < exponents[i].expLen && expBitPosition == exponents[i].windowBegin)
			{
				//int index = exponents[i].nextBucket;
				Integer &bucket = exponents[i].buckets[exponents[i].nextBucket];
				group.Accumulate(bucket, g);
				exponents[i].FindNextWindow();
			}
			notDone = notDone || exponents[i].windowBegin < exponents[i].expLen;
		}
		
		if (notDone)
		{
			g = group.Double(g);
			expBitPosition++;
		}
	}
	
	for (i=0; i<expCount; i++)
	{
		Integer &r = *result++;
		Integer* buckets = exponents[i].buckets;
		r = buckets[exponents[i].size-1];
		if (exponents[i].size > 1)
		{
			for (int j = exponents[i].size-2; j >= 1; j--)
			{
				Integer t1 = buckets[j];
				Integer t2 = buckets[j+1];
				
				group.Accumulate(buckets[j], buckets[j+1]);
				group.Accumulate(r, buckets[j]);
			}
			group.Accumulate(buckets[0], buckets[1]);
			r = group.Add(group.Double(r), buckets[0]);
		}
	}
	
	delete []exponents;
}




template <class Iterator, class ConstIterator>
void SimultaneousExponentiation(Iterator result, 
								const AbstractRing &ring, 
								const Integer &base,
								ConstIterator expBegin,
								ConstIterator expEnd)
{
	MultiplicativeGroup mg(ring);
	SimultaneousMultiplication(result, mg, base, expBegin, expEnd);
	return ;
}



Integer AbstractRing::Exponentiate(const Integer &base, 
												   const Integer &exponent) const
{
	Integer result;
	SimultaneousExponentiation(&result, *this, base, &exponent, &exponent+1);  //sjw for debug
	return result;
}

Integer AbstractRing::CascadeExponentiate(const Integer &x,
														  const Integer &e1,
														  const Integer &y,
														  const Integer &e2) const
{
	//return MultiplicativeGroup(*this).CascadeIntMultiply(x, e1, y, e2);
}

//Integer GeneralCascadeExponentiation(const AbstractRing&ring, 
//																			  Iterator begin, 
//																			  Iterator end)
//{
//	MultiplicativeGroup<AbstractRing<Element> > mg(ring);
//	return GeneralCascadeMultiplication<Element>(mg, begin, end);
//}
//


