/*
 *  MyStruct.cpp
 *  pass91
 *
 *  Created by Zhaolin He on 09-9-2.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "MyStruct.h"

int wcslen_m(const char *str){
	if(str==NULL) return 0;
	char* p = (char *)str;
	while(!(*p == 0 &&*(p+1) == 0)) p += 2;
	return (int)(p-str)/2;
}

int wcscpy_m(char* dest, const char *src)
{
    if(dest == NULL || src == NULL)
    {
        return 0;
    }
    
    char* pSrc = (char *)src;
    char* pDest = dest;
    while (*pSrc != 0 || *(pSrc+1) != 0) {
        *pDest = *pSrc;
        *(pDest + 1) = *(pSrc + 1);
        pDest += 2;
        pSrc += 2;
    }
    *pDest = 0;
    *(pDest + 1) = 0;
    return (int)(pSrc - dest) / 2;
}

char* itoa(int value, char* result, int base) {
    // check that the base if valid
    if (base < 2 || base > 36) { *result = '\0'; return result; }
	
    char* ptr = result, *ptr1 = result, tmp_char;
    int tmp_value;
	
    do {
        tmp_value = value;
        value /= base;
        *ptr++ = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz" [35 + (tmp_value - value * base)];
    } while ( value );
	
    // Apply negative sign
    if (tmp_value < 0) *ptr++ = '-';
    *ptr-- = '\0';
    while(ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr--= *ptr1;
        *ptr1++ = tmp_char;
    }
    return result;
}


#define NUMBER_OF_DIGITS 32

void ultoa(unsigned long value, char* string, int radix)
{
    unsigned char index;
    char buffer[NUMBER_OF_DIGITS];  /* space for NUMBER_OF_DIGITS + '\0' */
    
    index = NUMBER_OF_DIGITS;
    
    do {
        buffer[--index] = '0' + (value % radix);
        if ( buffer[index] > '9') buffer[index] += 'A' - ':'; /* continue with A, B,... */
        value /= radix;
    } while (value != 0);
    
    do {
        *string++ = buffer[index++];
    } while ( index < NUMBER_OF_DIGITS );
    
    *string = 0;  /* string terminator */
}
