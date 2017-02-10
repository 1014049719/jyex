////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 1999-2009, TQ Digital Entertainment, All Rights Reserved
// Author:
// $Id: $
// $HeadURL: $
// Description：
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///
// Blowfish.h Header File
//
//    BLOWFISH ENCRYPTION ALGORITHM
//
//    Encryption and Decryption of Byte Strings using the Blowfish Encryption Algorithm.
//    Blowfish is a block cipher that encrypts data in 8-byte blocks. The algorithm consists
//    of two parts: a key-expansion part and a data-ancryption part. Key expansion converts a
//    variable key of at least 1 and at most 56 bytes into several subkey arrays totaling
//    4168 bytes. Blowfish has 16 rounds. Each round consists of a key-dependent permutation,
//    and a key and data-dependent substitution. All operations are XORs and additions on 32-bit words.
//    The only additional operations are four indexed array data lookups per round.
//    Blowfish uses a large number of subkeys. These keys must be precomputed before any data
//    encryption or decryption. The P-array consists of 18 32-bit subkeys: P0, P1,...,P17.
//    There are also four 32-bit S-boxes with 256 entries each: S0,0, S0,1,...,S0,255;
//    S1,0, S1,1,...,S1,255; S2,0, S2,1,...,S2,255; S3,0, S3,1,...,S3,255;
//
//    The Electronic Code Book (ECB), Cipher Block Chaining (CBC) and Cipher Feedback modes
//    are used:
//
//    In ECB mode if the same block is encrypted twice with the same key, the resulting
//    ciphertext blocks are the same.
//
//    In CBC Mode a ciphertext block is obtained by first xoring the
//    plaintext block with the previous ciphertext block, and encrypting the resulting value.
//
//    In CFB mode a ciphertext block is obtained by encrypting the previous ciphertext block
//    and xoring the resulting value with the plaintext
//
//    The previous ciphertext block is usually stored in an Initialization Vector (IV).
//    An Initialization Vector of zero is commonly used for the first block, though other
//    arrangements are also in use.

/*
   http://www.counterpane.com/vectors.txt
   Test vectors by Eric Young.  These tests all assume Blowfish with 16
   rounds.

   All data is shown as a hex string with 012345 loading as
   data[0]=0x01;
   data[1]=0x23;
   data[2]=0x45;
   ecb test data (taken from the DES validation tests)

   key bytes               clear bytes             cipher bytes
   0000000000000000        0000000000000000        4EF997456198DD78
   FFFFFFFFFFFFFFFF        FFFFFFFFFFFFFFFF        51866FD5B85ECB8A
   3000000000000000        1000000000000001        7D856F9A613063F2  ???
   1111111111111111        1111111111111111        2466DD878B963C9D
   0123456789ABCDEF        1111111111111111        61F9C3802281B096
   1111111111111111        0123456789ABCDEF        7D0CC630AFDA1EC7
   0000000000000000        0000000000000000        4EF997456198DD78
   FEDCBA9876543210        0123456789ABCDEF        0ACEAB0FC6A0A28D
   7CA110454A1A6E57        01A1D6D039776742        59C68245EB05282B
   0131D9619DC1376E        5CD54CA83DEF57DA        B1B8CC0B250F09A0
   07A1133E4A0B2686        0248D43806F67172        1730E5778BEA1DA4
   3849674C2602319E        51454B582DDF440A        A25E7856CF2651EB
   04B915BA43FEB5B6        42FD443059577FA2        353882B109CE8F1A
   0113B970FD34F2CE        059B5E0851CF143A        48F4D0884C379918
   0170F175468FB5E6        0756D8E0774761D2        432193B78951FC98
   43297FAD38E373FE        762514B829BF486A        13F04154D69D1AE5
   07A7137045DA2A16        3BDD119049372802        2EEDDA93FFD39C79
   04689104C2FD3B2F        26955F6835AF609A        D887E0393C2DA6E3
   37D06BB516CB7546        164D5E404F275232        5F99D04F5B163969
   1F08260D1AC2465E        6B056E18759F5CCA        4A057A3B24D3977B
   584023641ABA6176        004BD6EF09176062        452031C1E4FADA8E
   025816164629B007        480D39006EE762F2        7555AE39F59B87BD
   49793EBC79B3258F        437540C8698F3CFA        53C55F9CB49FC019
   4FB05E1515AB73A7        072D43A077075292        7A8E7BFA937E89A3
   49E95D6D4CA229BF        02FE55778117F12A        CF9C5D7A4986ADB5
   018310DC409B26D6        1D9D5C5018F728C2        D1ABB290658BC778
   1C587F1C13924FEF        305532286D6F295A        55CB3774D13EF201
   0101010101010101        0123456789ABCDEF        FA34EC4847B268B2
   1F1F1F1F0E0E0E0E        0123456789ABCDEF        A790795108EA3CAE
   E0FEE0FEF1FEF1FE        0123456789ABCDEF        C39E072D9FAC631D
   0000000000000000        FFFFFFFFFFFFFFFF        014933E0CDAFF6E4
   FFFFFFFFFFFFFFFF        0000000000000000        F21E9A77B71C49BC
   0123456789ABCDEF        0000000000000000        245946885754369A
   FEDCBA9876543210        FFFFFFFFFFFFFFFF        6B5C5A9C5D9E0A5A

   set_key test data
   data[8]= FEDCBA9876543210
   c=F9AD597C49DB005E k[ 1]=F0
   c=E91D21C1D961A6D6 k[ 2]=F0E1
   c=E9C2B70A1BC65CF3 k[ 3]=F0E1D2
   c=BE1E639408640F05 k[ 4]=F0E1D2C3
   c=B39E44481BDB1E6E k[ 5]=F0E1D2C3B4
   c=9457AA83B1928C0D k[ 6]=F0E1D2C3B4A5
   c=8BB77032F960629D k[ 7]=F0E1D2C3B4A596
   c=E87A244E2CC85E82 k[ 8]=F0E1D2C3B4A59687
   c=15750E7A4F4EC577 k[ 9]=F0E1D2C3B4A5968778
   c=122BA70B3AB64AE0 k[10]=F0E1D2C3B4A596877869
   c=3A833C9AFFC537F6 k[11]=F0E1D2C3B4A5968778695A
   c=9409DA87A90F6BF2 k[12]=F0E1D2C3B4A5968778695A4B
   c=884F80625060B8B4 k[13]=F0E1D2C3B4A5968778695A4B3C
   c=1F85031C19E11968 k[14]=F0E1D2C3B4A5968778695A4B3C2D
   c=79D9373A714CA34F k[15]=F0E1D2C3B4A5968778695A4B3C2D1E ???
   c=93142887EE3BE15C k[16]=F0E1D2C3B4A5968778695A4B3C2D1E0F
   c=03429E838CE2D14B k[17]=F0E1D2C3B4A5968778695A4B3C2D1E0F00
   c=A4299E27469FF67B k[18]=F0E1D2C3B4A5968778695A4B3C2D1E0F0011
   c=AFD5AED1C1BC96A8 k[19]=F0E1D2C3B4A5968778695A4B3C2D1E0F001122
   c=10851C0E3858DA9F k[20]=F0E1D2C3B4A5968778695A4B3C2D1E0F00112233
   c=E6F51ED79B9DB21F k[21]=F0E1D2C3B4A5968778695A4B3C2D1E0F0011223344
   c=64A6E14AFD36B46F k[22]=F0E1D2C3B4A5968778695A4B3C2D1E0F001122334455
   c=80C7D7D45A5479AD k[23]=F0E1D2C3B4A5968778695A4B3C2D1E0F00112233445566
   c=05044B62FA52D080 k[24]=F0E1D2C3B4A5968778695A4B3C2D1E0F0011223344556677

   chaining mode test data
   key[16]   = 0123456789ABCDEFF0E1D2C3B4A59687
   iv[8]     = FEDCBA9876543210
   data[29]  = "7654321 Now is the time for " (includes trailing '\0')
   data[29]  = 37363534333231204E6F77206973207468652074696D6520666F722000
   cbc cipher text
   cipher[32]= 6B77B4D63006DEE605B156E27403979358DEB9E7154616D959F1652BD5FF92CC
   cfb64 cipher text cipher[29]=
   E73214A2822139CAF26ECF6D2EB9E76E3DA3DE04D1517200519D57A6C3
   ofb64 cipher text cipher[29]=
   E73214A2822139CA62B343CC5B65587310DD908D0C241B2263C2CF80DA

 */

#ifndef __BLOWFISH_H__
#define __BLOWFISH_H__

#import <CoreFoundation/CoreFoundation.h>
#include <string>

using namespace std;

typedef unsigned char BYTE;
typedef unsigned char UCHAR;
typedef uint32_t DWORD;
typedef uint32_t UINT;
typedef uint32_t ULONG;

//Block Structure
struct SBlock
{
    //Constructors
         SBlock(unsigned int l = 0, unsigned int r = 0):m_uil(l),
         m_uir(r)
    {
    }

    //Copy Constructor
    SBlock(const SBlock &roBlock):m_uil(roBlock.m_uil),
        m_uir(roBlock.m_uir)
    {
    }
    SBlock& operator ^= (SBlock & b){
        m_uil ^= b.m_uil;
        m_uir ^= b.m_uir;
        return *this;
    }
    unsigned int m_uil, m_uir;
};

class CBlowFish
{
public:
    enum {
        ECB = 0, CBC = 1, CFB = 2
    };

    //Constructor - Initialize the P and S boxes for a given Key
    CBlowFish(BYTE * ucKey, size_t n, const SBlock& roChain = SBlock(0UL, 0UL));

    //Resetting the chaining block
    void ResetChain()
    {
        m_oChain = m_oChain0;
    }

    // Encrypt/Decrypt Buffer in Place
    void Encrypt(BYTE* buf, size_t n, int iMode = ECB);
    void Decrypt(BYTE* buf, size_t n, int iMode = ECB);

    // Encrypt/Decrypt from Input Buffer to Output Buffer
    void Encrypt(const BYTE* in, BYTE* out, size_t n, int iMode = ECB);
    void Decrypt(const BYTE* in, BYTE* out, size_t n, int iMode = ECB);

//Private Functions
private:
    unsigned int F(unsigned int ui);
    void         Encrypt(SBlock&);
    void         Decrypt(SBlock&);

private:
    //The Initialization Vector, by default {0, 0}
    SBlock       m_oChain0;
    SBlock       m_oChain;
    unsigned int m_auiP[18];
    unsigned int m_auiS[4][256];
    static const unsigned int scm_auiInitP[18];
    static const unsigned int scm_auiInitS[4][256];
};

//Extract low order byte
inline BYTE ToByte(unsigned int ui)
{
    return (BYTE)(ui & 0xff);
}

//Function F
inline unsigned int CBlowFish::F(unsigned int ui)
{
    return ((m_auiS[0][Byte(ui >> 24)] + m_auiS[1][Byte(ui >> 16)]) ^ m_auiS[2][Byte(ui >> 8)]) + m_auiS[3][Byte(ui)];
}

#endif // __BLOWFISH_H__

// MD5Checksum.h: interface for the MD5Checksum class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MD5CHECKSUM_H__2BC7928E_4C15_11D3_B2EE_A4A60E20D2C3__INCLUDED_)
#define AFX_MD5CHECKSUM_H__2BC7928E_4C15_11D3_B2EE_A4A60E20D2C3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/****************************************************************************************
   This software is derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm.
   Incorporation of this statement is a condition of use; please see the RSA
   Data Security Inc copyright notice below:-

   Copyright (C) 1990-2, RSA Data Security, Inc. Created 1990. All
   rights reserved.

   RSA Data Security, Inc. makes no representations concerning either
   the merchantability of this software or the suitability of this
   software for any particular purpose. It is provided "as is"
   without express or implied warranty of any kind.

   These notices must be retained in any copies of any part of this
   documentation and/or software.

   Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
   rights reserved.
   License to copy and use this software is granted provided that it
   is identified as the "RSA Data Security, Inc. MD5 Message-Digest
   Algorithm" in all material mentioning or referencing this software
   or this function.
   License is also granted to make and use derivative works provided
   that such works are identified as "derived from the RSA Data
   Security, Inc. MD5 Message-Digest Algorithm" in all material
   mentioning or referencing the derived work.
   RSA Data Security, Inc. makes no representations concerning either
   the merchantability of this software or the suitability of this
   software for any particular purpose. It is provided "as is"
   without express or implied warranty of any kind.

   These notices must be retained in any copies of any part of this
   documentation and/or software.
 *****************************************************************************************/

/****************************************************************************************
   This implementation of the RSA MD5 Algorithm was written by Langfine Ltd.

   Langfine Ltd makes no representations concerning either
   the merchantability of this software or the suitability of this
   software for any particular purpose. It is provided "as is"
   without express or implied warranty of any kind.

   In addition to the above, Langfine make no warrant or assurances regarding the
   accuracy of this implementation of the MD5 checksum algorithm nor any assurances regarding
   its suitability for any purposes.

   This implementation may be used freely provided that Langfine is credited
   in a copyright or similar notices (eg, RSA MD5 Algorithm implemented by Langfine
   Ltd.) and provided that the RSA Data Security notices are complied with.

   Langfine may be contacted at mail@langfine.com
 */

/*****************************************************************************************
   CLASS:			CMD5Checksum
   DESCRIPTION:	Implements the "RSA Data Security, Inc. MD5 Message-Digest Algorithm".
   NOTES:			Calculates the RSA MD5 checksum for a file or congiguous array of data.

   Below are extracts from a memo on The MD5 Message-Digest Algorithm by R. Rivest of MIT
   Laboratory for Computer Science and RSA Data Security, Inc., April 1992.

   1. Executive Summary
   This document describes the MD5 message-digest algorithm. The
   algorithm takes as input a message of arbitrary length and produces
   as output a 128-bit "fingerprint" or "message digest" of the input.
   It is conjectured that it is computationally infeasible to produce
   two messages having the same message digest, or to produce any
   message having a given prespecified target message digest. The MD5
   algorithm is intended for digital signature applications, where a
   large file must be "compressed" in a secure manner before being
   encrypted with a private (secret) key under a public-key cryptosystem
   such as RSA.

   The MD5 algorithm is designed to be quite fast on 32-bit machines. In
   addition, the MD5 algorithm does not require any large substitution
   tables; the algorithm can be coded quite compactly.
   The MD5 algorithm is an extension of the MD4 message-digest algorithm
   1,2]. MD5 is slightly slower than MD4, but is more "conservative" in
   design. MD5 was designed because it was felt that MD4 was perhaps
   being adopted for use more quickly than justified by the existing
   critical review; because MD4 was designed to be exceptionally fast,
   it is "at the edge" in terms of risking successful cryptanalytic
   attack. MD5 backs off a bit, giving up a little in speed for a much
   greater likelihood of ultimate security. It incorporates some
   suggestions made by various reviewers, and contains additional
   optimizations. The MD5 algorithm is being placed in the public domain
   for review and possible adoption as a standard.


   2. Terminology and Notation
   In this document a "word" is a 32-bit quantity and a "byte" is an
   eight-bit quantity. A sequence of bits can be interpreted in a
   natural manner as a sequence of bytes, where each consecutive group
   of eight bits is interpreted as a byte with the high-order (most
   significant) bit of each byte listed first. Similarly, a sequence of
   bytes can be interpreted as a sequence of 32-bit words, where each
   consecutive group of four bytes is interpreted as a word with the
   low-order (least significant) byte given first.
   Let x_i denote "x sub i". If the subscript is an expression, we
   surround it in braces, as in x_{i+1}. Similarly, we use ^ for
   superscripts (exponentiation), so that x^i denotes x to the i-th   power.
   Let the symbol "+" denote addition of words (i.e., modulo-2^32
   addition). Let X <<< s denote the 32-bit value obtained by circularly
   shifting (rotating) X left by s bit positions. Let not(X) denote the
   bit-wise complement of X, and let X v Y denote the bit-wise OR of X
   and Y. Let X xor Y denote the bit-wise XOR of X and Y, and let XY
   denote the bit-wise AND of X and Y.


   3. MD5 Algorithm Description
   We begin by supposing that we have a b-bit message as input, and that
   we wish to find its message digest. Here b is an arbitrary
   nonnegative integer; b may be zero, it need not be a multiple of
   eight, and it may be arbitrarily large. We imagine the bits of the
   message written down as follows:          m_0 m_1 ... m_{b-1}
   The following five steps are performed to compute the message digest
   of the message.

   3.1 Step 1. Append Padding Bits
   The message is "padded" (extended) so that its length (in bits) is
   congruent to 448, modulo 512. That is, the message is extended so
   that it is just 64 bits shy of being a multiple of 512 bits long.
   Padding is always performed, even if the length of the message is
   already congruent to 448, modulo 512.
   Padding is performed as follows: a single "1" bit is appended to the
   message, and then "0" bits are appended so that the length in bits of
   the padded message becomes congruent to 448, modulo 512. In all, at
   least one bit and at most 512 bits are appended.

   3.2 Step 2. Append Length
   A 64-bit representation of b (the length of the message before the
   padding bits were added) is appended to the result of the previous
   step. In the unlikely event that b is greater than 2^64, then only
   the low-order 64 bits of b are used. (These bits are appended as two
   32-bit words and appended low-order word first in accordance with the
   previous conventions.)
   At this point the resulting message (after padding with bits and with
   b) has a length that is an exact multiple of 512 bits. Equivalently,
   this message has a length that is an exact multiple of 16 (32-bit)
   words. Let M[0 ... N-1] denote the words of the resulting message,
   where N is a multiple of 16.

   3.3 Step 3. Initialize MD Buffer
   A four-word buffer (A,B,C,D) is used to compute the message digest.
   Here each of A, B, C, D is a 32-bit register. These registers are
   initialized to the following values in hexadecimal, low-order bytes   first):
   word A: 01 23 45 67          word B: 89 ab cd ef
   word C: fe dc ba 98          word D: 76 54 32 10

   3.4 Step 4. Process Message in 16-Word Blocks
   We first define four auxiliary functions that each take as input
   three 32-bit words and produce as output one 32-bit word.
   F(X,Y,Z) = XY v not(X) Z          G(X,Y,Z) = XZ v Y not(Z)
   H(X,Y,Z) = X xor Y xor Z          I(X,Y,Z) = Y xor (X v not(Z))
   In each bit position F acts as a conditional: if X then Y else Z.
   The function F could have been defined using + instead of v since XY
   and not(X)Z will never have 1's in the same bit position.) It is
   interesting to note that if the bits of X, Y, and Z are independent
   and unbiased, the each bit of F(X,Y,Z) will be independent and   unbiased.
   The functions G, H, and I are similar to the function F, in that they
   act in "bitwise parallel" to produce their output from the bits of X,
   Y, and Z, in such a manner that if the corresponding bits of X, Y,
   and Z are independent and unbiased, then each bit of G(X,Y,Z),
   H(X,Y,Z), and I(X,Y,Z) will be independent and unbiased. Note that
   the function H is the bit-wise "xor" or "parity" function of its   inputs.
   This step uses a 64-element table T[1 ... 64] constructed from the
   sine function. Let T[i] denote the i-th element of the table, which
   is equal to the integer part of 4294967296 times abs(sin(i)), where i
   is in radians. The elements of the table are given in the appendix.
   Do the following:

   //Process each 16-word block.
   For i = 0 to N/16-1 do     // Copy block i into X.
   For j = 0 to 15 do
   Set X[j] to M[i*16+j].
   end //of loop on j

   // Save A as AA, B as BB, C as CC, and D as DD.
   AA = A     BB = B
   CC = C     DD = D

   // Round 1.
   // Let [abcd k s i] denote the operation
   // a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s).
   // Do the following 16 operations.
   [ABCD  0  7  1]  [DABC  1 12  2]  [CDAB  2 17  3]  [BCDA  3 22  4]
   [ABCD  4  7  5]  [DABC  5 12  6]  [CDAB  6 17  7]  [BCDA  7 22  8]
   [ABCD  8  7  9]  [DABC  9 12 10]  [CDAB 10 17 11]  [BCDA 11 22 12]
   [ABCD 12  7 13]  [DABC 13 12 14]  [CDAB 14 17 15]  [BCDA 15 22 16]

   // Round 2.
   // Let [abcd k s i] denote the operation
   // a = b + ((a + G(b,c,d) + X[k] + T[i]) <<< s).
   // Do the following 16 operations.
   [ABCD  1  5 17]  [DABC  6  9 18]  [CDAB 11 14 19]  [BCDA  0 20 20]
   [ABCD  5  5 21]  [DABC 10  9 22]  [CDAB 15 14 23]  [BCDA  4 20 24]
   [ABCD  9  5 25]  [DABC 14  9 26]  [CDAB  3 14 27]  [BCDA  8 20 28]
   [ABCD 13  5 29]  [DABC  2  9 30]  [CDAB  7 14 31]  [BCDA 12 20 32]

   // Round 3.
   // Let [abcd k s t] denote the operation
   // a = b + ((a + H(b,c,d) + X[k] + T[i]) <<< s).
   // Do the following 16 operations.
   [ABCD  5  4 33]  [DABC  8 11 34]  [CDAB 11 16 35]  [BCDA 14 23 36]
   [ABCD  1  4 37]  [DABC  4 11 38]  [CDAB  7 16 39]  [BCDA 10 23 40]
   [ABCD 13  4 41]  [DABC  0 11 42]  [CDAB  3 16 43]  [BCDA  6 23 44]
   [ABCD  9  4 45]  [DABC 12 11 46]  [CDAB 15 16 47]  [BCDA  2 23 48]

   // Round 4.
   // Let [abcd k s t] denote the operation
   // a = b + ((a + I(b,c,d) + X[k] + T[i]) <<< s).
   // Do the following 16 operations.
   [ABCD  0  6 49]  [DABC  7 10 50]  [CDAB 14 15 51]  [BCDA  5 21 52]
   [ABCD 12  6 53]  [DABC  3 10 54]  [CDAB 10 15 55]  [BCDA  1 21 56]
   [ABCD  8  6 57]  [DABC 15 10 58]  [CDAB  6 15 59]  [BCDA 13 21 60]
   [ABCD  4  6 61]  [DABC 11 10 62]  [CDAB  2 15 63]  [BCDA  9 21 64]

   // Then perform the following additions. (That is increment each
   //   of the four registers by the value it had before this block
   //   was started.)
   A = A + AA     B = B + BB     C = C + CC  D = D + DD

   end // of loop on i

   3.5 Step 5. Output
   The message digest produced as output is A, B, C, D. That is, we
   begin with the low-order byte of A, and end with the high-order byte of D.
   This completes the description of MD5.

   Summary
   The MD5 message-digest algorithm is simple to implement, and provides
   a "fingerprint" or message digest of a message of arbitrary length.
   It is conjectured that the difficulty of coming up with two messages
   having the same message digest is on the order of 2^64 operations,
   and that the difficulty of coming up with any message having a given
   message digest is on the order of 2^128 operations. The MD5 algorithm
   has been carefully scrutinized for weaknesses. It is, however, a
   relatively new algorithm and further security analysis is of course
   justified, as is the case with any new proposal of this sort.


   5. Differences Between MD4 and MD5
   The following are the differences between MD4 and MD5:
   1.   A fourth round has been added.
   2.   Each step now has a unique additive constant.
   3.   The function g in round 2 was changed from (XY v XZ v YZ) to
   (XZ v Y not(Z)) to make g less symmetric.
   4.   Each step now adds in the result of the previous step.  This
   promotes a faster "avalanche effect".
   5.   The order in which input words are accessed in rounds 2 and
   3 is changed, to make these patterns less like each other.
   6.   The shift amounts in each round have been approximately
   optimized, to yield a faster "avalanche effect." The shifts in
   different rounds are distinct.

   References
   [1] Rivest, R., "The MD4 Message Digest Algorithm", RFC 1320, MIT and
   RSA Data Security, Inc., April 1992.
   [2] Rivest, R., "The MD4 message digest algorithm", in A.J.  Menezes
   and S.A. Vanstone, editors, Advances in Cryptology - CRYPTO '90
   Proceedings, pages 303-311, Springer-Verlag, 1991.
   [3] CCITT Recommendation X.509 (1988), "The Directory -
   Authentication Framework."APPENDIX A - Reference Implementation


   The level of security discussed in this memo is considered to be
   sufficient for implementing very high security hybrid digital-
   signature schemes based on MD5 and a public-key cryptosystem.
   Author's Address
   Ronald L. Rivest   Massachusetts Institute of Technology
   Laboratory for Computer Science   NE43-324   545 Technology Square
   Cambridge, MA  02139-1986   Phone: (617) 253-5880
   EMail: rivest@theory.lcs.mit.edu


*****************************************************************************************/
class CMD5Checksum
{
public:
    //interface functions for the RSA MD5 calculation
    static string GetMD5(BYTE* pBuf, UINT nLength);
//    static string GetMD5(CFile& File);
//    static string GetMD5(const string& strFilePath);

protected:
    //constructor/destructor
    CMD5Checksum();
    virtual ~CMD5Checksum() {};

    //RSA MD5 implementation
    void         Transform(BYTE Block[64]); //BYTE Block[64]
    void         Update(BYTE* Input, ULONG nInputLen);
    string      Final();
    inline DWORD RotateLeft(DWORD x, int n);
    inline void  FF(DWORD& A, DWORD B, DWORD C, DWORD D, DWORD X, DWORD S, DWORD T);
    inline void  GG(DWORD& A, DWORD B, DWORD C, DWORD D, DWORD X, DWORD S, DWORD T);
    inline void  HH(DWORD& A, DWORD B, DWORD C, DWORD D, DWORD X, DWORD S, DWORD T);
    inline void  II(DWORD& A, DWORD B, DWORD C, DWORD D, DWORD X, DWORD S, DWORD T);

    //utility functions
    void DWordToByte(BYTE* Output, DWORD* Input, UINT nLength);
    void ByteToDWord(DWORD* Output, BYTE* Input, UINT nLength);

private:
    BYTE  m_lpszBuffer[64];         //input buffer
    ULONG m_nCount[2];          //number of bits, modulo 2^64 (lsb first)
    ULONG m_lMD5[4];            //MD5 checksum
};

#endif // !defined(AFX_MD5CHECKSUM_H__2BC7928E_4C15_11D3_B2EE_A4A60E20D2C3__INCLUDED_)

#ifndef __DES_H__
#define __DES_H__

#ifdef __cplusplus
extern "C" {
#endif
/************************************************************************************************
   函数功能：固定长度DES加密算法，输入输出密钥都为固定长度8
   输入参数：
   BuffIn 输入待加密数据，固定长度为8
   DESKey：加密的密钥，固定长度为8
   输出参数：
   BuffOut：输出加密后的密文，固定长度为8
   返回值：无
************************************************************************************************/
void DESencrypt(const char* BuffIn, char* BuffOut, const char* DESkey);

/************************************************************************************************
   函数功能：固定长度DES解密算法，输入输出密钥都为固定长度8
   输入参数：
   BuffIn 输入待解密数据，固定长度为8
   DESKey：解密的密钥，固定长度为8
   输出参数：
   BuffOut：输出解密后的明文，固定长度为8
   返回值：无
************************************************************************************************/
void DESdecrypt(const char* BuffIn, char* BuffOut, const char* DESkey);

/************************************************************************************************
   函数功能：不定长DES加密算法
   输入参数：
   BuffIn 输入待加密数据缓存
   DESKey：加密的密钥，固定长度为8
   iLen 输入待加密数据长度，长度需要为8的整数倍
   输出参数：
   BuffOut：输出加密后的密文，容量必须与输入容量一样
   返回值：1加密成功 0 加密失败
************************************************************************************************/
int DesEncrypt(const char* BuffIn, char* BuffOut, const char* DESkey, int iLen);

/************************************************************************************************
   函数功能：不定长DES解密算法
   输入参数：
   BuffIn 输入待解密数据缓存
   DESKey：解密的密钥，固定长度为8
   iLen 输入待解密数据长度,长度需要为8的整数倍
   输出参数：
   BuffOut：输出解密后的明文，容量必须与输入容量一样
   返回值：1解密成功 0 解密失败
************************************************************************************************/
int DesDecrypt(const char* BuffIn, char* BuffOut, const char* DESkey, int iLen);

#ifdef __cplusplus
}
#endif

#endif      //__DES_H__
