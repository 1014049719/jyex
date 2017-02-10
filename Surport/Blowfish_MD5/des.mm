////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright(c) 1999-2009, TQ Digital Entertainment, All Rights Reserved
// Author:
// $Id: $
// $HeadURL: $
// Description：
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <assert.h>
#include "Blowfish_MD5.h"
#ifdef UNICODE
#define MYMEMCPY wmemcpy
#else
#define MYMEMCPY memcpy
#endif

typedef BYTE BYTE;

void encrypt(BYTE* rcpbuf, BYTE* buf, BYTE* key, int key_flag);
void decrypt(BYTE* rcpbuf, BYTE* buf, BYTE* key, int key_flag);

void fctf(BYTE* out_array, BYTE* in_array, BYTE* key);
void select(BYTE* out_array, BYTE* in_array, int sel_array[][4][16]);
void keygen(BYTE* key);
void shift(BYTE* array, int iteration);
void permut(BYTE* out_array, BYTE* in_array, int* sel_array);
int  bittest(BYTE* array, int bitno);
void bitset(BYTE* array, int bitno);

void myxor(BYTE * a, BYTE * b, int lg);
int  TCHAR2hex(int n);
BYTE hex2TCHAR(int n);

/* Initial permutation */
int ip[65] =
{
    58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17,  9, 1, 59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7,0
};

/* Key Permutation */
int p1[57] =
{
    57, 49, 41, 33, 25, 17,  9,  1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27, 19, 11,  3, 60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,  7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29, 21, 13,  5, 28, 20, 12,  4,0
};

/* Key Shifts per Round */
int tshift[16] = {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};

/* Key Compression Permutation */
int p2[49] =
{
    14, 17, 11, 24,  1,  5,  3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8, 16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32,0
};

/* 16 Key Variations */
BYTE keyn[16][7];

/* Expansion Permutation */
int expand[49] =
{
    32,  1,  2,  3,  4,  5,  4,  5,  6,  7,  8,  9,
    8,   9, 10, 11, 12, 13, 12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21, 20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29, 28, 29, 30, 31, 32,  1,0
};

/* S-Boxes */
int sel[8][4][16] =
{
    14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
    0,  15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
    4,   1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
    15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13,
    15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
    3,  13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
    0,  14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
    13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9,
    10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
    13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
    13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
    1,  10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12,
    7,  13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
    13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
    10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
    3,  15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14,
    2,  12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
    14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
    4,   2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
    11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3,
    12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
    10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
    9,  14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
    4,   3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13,
    4,  11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
    13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
    1,   4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
    6,  11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12,
    13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
    1,  15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
    7,  11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
    2,   1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
};

/* P-box Permutation */
int perm[33] =
{
    16, 7, 20, 21, 29, 12, 28, 17,  1, 15, 23, 26,  5, 18, 31, 10,
    2,  8, 24, 14, 32, 27,  3,  9, 19, 13, 30,  6, 22, 11,  4, 25,0
};

/* Final Permutation is the inverse of the initial one */
int ip_1[65] =
{
    40, 8, 48, 16, 56, 24, 64, 32, 39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30, 37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28, 35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26, 33, 1, 41,  9, 49, 17, 57, 25,0
};

// ---------------------------------------------------------------------------------------------
// DES Encrypt
// ---------------------------------------------------------------------------------------------
void DESencrypt(const char* BuffIn, char* BuffOut, const char* DESkey)
{
    int byte;

    BYTE Out[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE In[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE Key[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    for (byte = 0; byte < 8; byte++)
    {
        In[byte]  = BuffIn[byte];
        Key[byte] = DESkey[byte];
    }

    encrypt(Out, In, Key, 0);

    for (byte = 0; byte < 8; byte++)
    {
        BuffOut[byte] = Out[byte];
    }

    return;
}

// ---------------------------------------------------------------------------------------------
// DES Decrypt
// ---------------------------------------------------------------------------------------------
void DESdecrypt(const char* BuffIn, char* BuffOut, const char* DESkey)
{
    int byte;

    BYTE Out[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    BYTE In[8]  = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE Key[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    for (byte = 0; byte < 8; byte++)
    {
        In[byte]  = BuffIn[byte];
        Key[byte] = DESkey[byte];
    }

    decrypt(Out, In, Key, 0);

    for (byte = 0; byte < 8; byte++)
    {
        BuffOut[byte] = Out[byte];
    }

    return;
}

// ---------------------------------------------------------------------------------------------
// DES Encrypt
// ---------------------------------------------------------------------------------------------
int DesEncrypt(const char* BuffIn, char* BuffOut, const char* DESkey, int iLen)
{
    int byte, i;

    BYTE Out[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE In[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE Key[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    assert(iLen >= 8 && iLen % 8 == 0);

    if ((iLen < 8) || (iLen % 8 != 0))
    {
        return 0;
    }

    for (i = 0; i < iLen / 8; i++)
    {
        for (byte = 0; byte < 8; byte++)
        {
            In[byte] = BuffIn[i * 8 + byte];

            if (i == 0)
            {
                Key[byte] = DESkey[byte];
            }
        }

        encrypt(Out, In, Key, 0);

        for (byte = 0; byte < 8; byte++)
        {
            BuffOut[i * 8 + byte] = Out[byte];
        }
    }

    return 1;
}

// ---------------------------------------------------------------------------------------------
// DES Decrypt
// ---------------------------------------------------------------------------------------------
int DesDecrypt(const char* BuffIn, char* BuffOut, const char* DESkey, int iLen)
{
    int byte, i;

    BYTE Out[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    BYTE In[8]  = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    BYTE Key[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    assert(iLen >= 8 && iLen % 8 == 0);

    if ((iLen < 8) || (iLen % 8 != 0))
    {
        return 0;
    }

    for (i = 0; i < iLen / 8; i++)
    {
        for (byte = 0; byte < 8; byte++)
        {
            In[byte] = BuffIn[i * 8 + byte];

            if (i == 0)
            {
                Key[byte] = DESkey[byte];
            }
        }

        decrypt(Out, In, Key, 0);

        for (byte = 0; byte < 8; byte++)
        {
            BuffOut[i * 8 + byte] = Out[byte];
        }
    }

    return 1;
}

// ---------------------------------------------------------------------------------------------

/*************************** ENCRYPTION / DECRYPTION *****************/

void encrypt(BYTE* rcpbuf, BYTE* buf, BYTE* key, int key_flag)
{
    BYTE base[8], nbase[8], * ln, * rn, * ln_1, * rn_1;
    int  iter;

    if (!key_flag)
    {
        keygen(key);                /* GENERATE 16 KEY VARIATIONS K1-K16 */
    }

    memset(base, 0x00, 8);
    permut(base, buf, ip);            /* INITIAL PERMUTATION 'IP' */

    ln   = nbase;
    rn   = nbase + 4;
    ln_1 = base;
    rn_1 = base + 4;

    for (iter = 0; iter < 16; iter++)
    {
        memcpy(ln, rn_1, 4);          /* Ln = Rn-1 */
        fctf(rn, rn_1, keyn[iter]);   /* F(Rn-1,Kn) */
        myxor(rn, ln_1, 4);             /* Rn = Ln-1 + F(Rn-1,Kn) */
        memcpy(base, nbase, 8);
    }

    memcpy(base + 4, nbase, 4);         /* SWAP LEFT & RIGHT */
    memcpy(base, nbase + 4, 4);

    memset(rcpbuf, 0x00, 8);
    permut(rcpbuf, base, ip_1);       /* OUTPUT PERMUTATION 'IP-1' */

    return;
}

void decrypt(BYTE* rcpbuf, BYTE* buf, BYTE* key, int key_flag)
{
    BYTE base[8], nbase[8], * ln, * rn, * ln_1, * rn_1;
    int  iter;

    if (!key_flag)
    {
        keygen(key);                /* GENERATE 16 KEY VARIATIONS K1-K16 */
    }

    memset(base, 0x00, 8);
    permut(base, buf, ip);            /* INVERSE PERMUTATION 'IP' */

    memcpy(nbase, base, 8);           /* SWAP LEFT & RIGHT */
    memcpy(base + 4, nbase, 4);
    memcpy(base, nbase + 4, 4);

    ln   = base;
    rn   = base + 4;
    ln_1 = nbase;
    rn_1 = nbase + 4;

    for (iter = 15; iter >= 0; iter--)
    {
        memcpy(rn_1, ln, 4);          /* Rn-1 = Ln */
        fctf(ln_1, ln, keyn[iter]);   /* F(Ln,Kn) */
        myxor(ln_1, rn, 4);             /* Ln-1 = Rn + F(Ln,Kn) */
        memcpy(base, nbase, 8);
    }

    memset(rcpbuf, 0x00, 8);
    permut(rcpbuf, base, ip_1);       /* PERMUTATION 'IP-1' */

    return;
}

/* FUNCTION 'F' AS DEFINED IN STANDARD */
void fctf(BYTE* out_array, BYTE* in_array, BYTE* key)
{
    BYTE base[8], nbase[8];

    memset(base, 0x00, 6);
    permut(base, in_array, expand);       /* EXPANSION OF 32 INTO 48 BITS */
    myxor(base, key, 6);                    /* XOR WITH Kn */
    select(nbase, base, sel);             /* SELECT ONLY 32 BITS OUT OF 48 */
    memset(out_array, 0x00, 4);
    permut(out_array, nbase, perm);       /* APPLY FINAL PERMUTATION 'PERM'*/

    return;
}

/* SELECTION FUNCTION */
void select(BYTE* out_array, BYTE* in_array, int sel_array[][4][16])
{
    int b, bn, i, j, bs, exponent, val4;

    memset(out_array, 0x00, 4);

    for (b = 0; b < 8; b++)
    {
        bn = (b * 6) + 1;                           /* Bit offset = byte offset x 6 */
        i  = 0;

        if (bittest(in_array, bn + 5))
        {
            i = 1;                              /* GET Ith COLUMN */
        }

        if (bittest(in_array, bn))
        {
            i += 2;
        }

        j        = 0;
        exponent = 8;                   /* GET Jth COLUMN */

        for (bs = 1; bs < 5; bs++)
        {
            if (bittest(in_array, bn + bs))
            {
                j += exponent;
            }

            exponent >>= 1;
        }

        val4 = sel_array[b][i][j];

        if ((b & 1) == 0)
        {
            val4 <<= 4;                         /* PUT IN HIGH NIBBLE IF EVEN */
        }

        out_array[b >> 1] |= val4;                /* LOAD NIBBLE AT OFFSET */
    }

    return;
}

/* GENERATION OF THE 16 KEY VARIATIONS */
void keygen(BYTE* key)
{
    BYTE bkey[7];
    int  iter;

    memset(keyn, 0x00, 7 * 16);
    memset(bkey, 0x00, 7);
    permut(bkey, key, p1);                    /* PERMUTATION NU 1 */

    for (iter = 0; iter < 16; iter++)
    {
        shift(bkey, iter);                   /* SHIFT ACCORDING TO TABLE 'TSHIFT' */
        permut(keyn[iter], bkey, p2);         /* GENERATE KEY ORDER iter */
    }

    return;
}

/* SHIFT SCHEME OF 1 OR 2 BITS LEFT */
void shift(BYTE* array, int iteration)
{
    int i, j;

    union
    {
        BYTE     s[4];
        long int li;
    }    us;
    BYTE c[7], d[7];

    for (i = 6, j = 0; i >= 0; j++, i--)
    {
        /* REVERSE ARRAY */
        c[j] = array[i];
    }

    memcpy(us.s, c + 3, 4);
    us.s[0] = (us.s[0] & 0xf0) | (us.s[3] >> 4);
    us.li <<= tshift[iteration];                    /* SHIFT 'C' PART */

    memcpy(d + 3, us.s, 4);                             /* STORE RESULT */

    memcpy(us.s, c, 4);
    us.s[3] &= 0x0f;
    us.li  <<= tshift[iteration];                   /* SHIFT 'D' PART */
    us.s[0] |= us.s[3] >> 4;

    memcpy(d, us.s, 3);
    d[3] = (d[3] & 0xf0) | (us.s[3] & 0x0f);

    for (i = 6, j = 0; i >= 0; j++, i--)
    {
        /* REVERSE ARRAY BACK */
        array[j] = d[i];
    }

    return;
}

/* GENERAL PERMUTATION ROUTINE */
void permut(BYTE* out_array, BYTE* in_array, int* sel_array)
{
    int i;

    for (i = 1; *sel_array; i++)
    {
        if (bittest(in_array, *sel_array++))
        {
            bitset(out_array, i);
        }
    }

    return;
}

/* TEST BIT IN 'ARRAY' AT BIT OFFSET 'BITNO' */
int bittest(BYTE* array, int bitno)
{
    --bitno;
    return (*(array + (bitno >> 3)) >> (7 - (bitno & 7))) & 1;
}

/* SET BIT IN 'ARRAY' AT BIT OFFSET 'BITNO' */
void bitset(BYTE* array, int bitno)
{
    --bitno;
    *(array + (bitno >> 3)) |= 0x80 >> (bitno & 7);

    return;
}

/* XOR 'B' INTO 'A' ON LENGTH 'LG' */
void myxor(BYTE * a, BYTE * b, int lg)
{
    for (; lg--;)
    {
        *a++ ^= *b++;
    }

    return;
}

int TCHAR2hex(int n)  /* convert integer nibble into TCHAR */
{
    if ((n >= 'A') && (n <= 'F'))
    {
        return n - 'A' + 10;
    }

    if ((n >= 'a') && (n <= 'f'))
    {
        return n - 'a' + 10;
    }

    return n - '0';
}

BYTE hex2TCHAR(int n)    /* convert hex nibble into integer */
{
    if ((n >= 10) && (n <= 16))
    {
        return (BYTE)(n - 10 + 'A');
    }

    return (BYTE)(n + '0');
}

