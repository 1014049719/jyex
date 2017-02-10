/*
 *  algebra.h
 *  newRSA
 *
 *  Created by jiangwei she on 09-8-25.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef ALGEBRA_H_
#define ALGEBRA_H_

#include "Integer.h"

class AbstractGroup
	{
	public:
		//typedef Integer Element;
		
		virtual ~AbstractGroup() {}
		
		virtual bool Equal(const Integer &a, const Integer &b) const =0;
		virtual Integer Zero() const =0;
		virtual Integer Add(const Integer &a, const Integer &b) const =0;
		virtual Integer Inverse(const Integer &a) const =0;
		
		virtual Integer Double(const Integer &a) const;
		virtual Integer Subtract(const Integer &a, const Integer &b) const;
		virtual Integer& Accumulate(Integer &a, const Integer &b) const;
		virtual Integer& Reduce(Integer &a, const Integer &b) const;
		
		virtual Integer IntMultiply(const Integer &a, const Integer &e) const;
		//virtual Integer CascadeIntMultiply(const Integer &x, const Integer &e1, const Integer &y, const Integer &e2) const;
	};

class AbstractRing : public AbstractGroup
{
public:	
	virtual bool IsUnit(const Integer &a) const =0;
	virtual Integer One() const =0;
	virtual Integer Multiply(const Integer &a, const Integer &b) const =0;
	virtual Integer MultiplicativeInverse(const Integer &a) const =0;
	
	virtual Integer Square(const Integer &a) const;
	virtual Integer Divide(const Integer &a, const Integer &b) const;
	
	virtual Integer Exponentiate(const Integer &a, const Integer &e) const;
	virtual Integer CascadeExponentiate(const Integer &x, const Integer &e1, const Integer &y, const Integer &e2) const;
};




class AbstractEuclideanDomain : public AbstractRing
{
public:
	typedef Integer Element;
	
	virtual void DivisionAlgorithm(Element &r, Element &q, const Element &a, const Element &d) const =0;
	
	virtual Element Mod(const Element &a, const Element &b) const;
	virtual Element Gcd(const Element &a, const Element &b) const;
};



//
class MultiplicativeGroup : public AbstractGroup
{
public:
	typedef AbstractRing Ring;
	
	MultiplicativeGroup(const Ring &m_ring)
	: m_ring(m_ring) {}
	
	const Ring & GetRing() const
	{return m_ring;}
	
	bool Equal(const Integer &a, const Integer &b) const
	{return m_ring.Equal(a, b);}
	
	Integer Zero() const
	{return m_ring.One();}
	
	Integer Add(const Integer &a, const Integer &b) const
	{return m_ring.Multiply(a, b);}
	
	Integer& Accumulate(Integer &a, const Integer &b) const
	{return a = m_ring.Multiply(a, b);}
	
	Integer Inverse(const Integer &a) const
	{return m_ring.MultiplicativeInverse(a);}
	
	Integer Subtract(const Integer &a, const Integer &b) const
	{return m_ring.Divide(a, b);}
	
	Integer& Reduce(Integer &a, const Integer &b) const
	{return a = m_ring.Divide(a, b);}
	
	Integer Double(const Integer &a) const
	{return m_ring.Square(a);}
	
protected:
	const Ring &m_ring;
};






class EuclideanDomainOf : public AbstractEuclideanDomain
{
public:
	typedef Integer Element;
	
	EuclideanDomainOf() {}
	
	bool Equal(const Element &a, const Element &b) const
	{return a==b;}
	
	Element Zero() const
	{return Element::Zero();}
	
	Element Add(const Element &a, const Element &b) const
	{return a+b;}
	
	Element& Accumulate(Element &a, const Element &b) const
	{return a+=b;}
	
	Element Inverse(const Element &a) const
	{return -a;}
	
	Element Subtract(const Element &a, const Element &b) const
	{return a-b;}
	
	Element& Reduce(Element &a, const Element &b) const
	{return a-=b;}
	
	Element Double(const Element &a) const
	{return a.Doubled();}
	
	Element One() const
	{return Element::One();}
	
	Element Multiply(const Element &a, const Element &b) const
	{return a*b;}
	
	Element Square(const Element &a) const
	{return a.Squared();}
	
	bool IsUnit(const Element &a) const
	{return a.IsUnit();}
	
	Element MultiplicativeInverse(const Element &a) const
	{return a.MultiplicativeInverse();}
	
	Element Divide(const Element &a, const Element &b) const
	{return a/b;}
	
	Element Mod(const Element &a, const Element &b) const
	{return a%b;}
	
	void DivisionAlgorithm(Element &r, Element &q, const Element &a, const Element &d) const
	{Element::Divide(r, q, a, d);}
};
















#endif
