/*
 *  DataStruct.h
 *  pass91
 *
 *  Created by Zhaolin He on 09-9-2.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef MYSTRUCT_H_
#define MYSTRUCT_H_

#if _MSC_VER > 1000
#pragma once
#endif

#include <stdio.h>
#include <memory.h>
#include <stddef.h>
#include "RetCode.h"

#include <iostream>
#include <vector>
#include <list>
#include <string>

///////////////////////////////////////////////////////////////////

typedef unsigned short unichar;
typedef std::basic_string<unichar> unistring;

//////////////////////////////////////////////////////////////////////////////////////////
//操作函数定义
#if defined __cplusplus
extern "C"
{
#endif
	extern int wcslen_m(const char *str);
    extern int wcscpy_m(char* dest, const char *src);
    extern char* itoa(int value, char* result, int base);
    extern void ultoa(unsigned long value, char* str, int radix);

#if defined __cplusplus
}
#endif
/////////////////////////////////////////////////////////////////////////////////////////



#endif //MYSTRUCT_H_