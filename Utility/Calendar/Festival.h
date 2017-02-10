/************************************************************************************
* 
*  @file 
*  @brief
*  节假日方法实现头文件
*  <b>文件名</b>      : Festival.h
*  @n@n<b>版权所有</b>: 网龙天晴程序部应用软件开发组
*  @n@n<b>作  者</b>  : 檀杨挺
*  @n@n<b>创建时间</b>: 2010-11-24 11:58:52
*  @n@n<b>文件描述</b>: 
*  @version		版本	修改者		  时间		  描述@n
*  @n		        檀杨挺        2010-11-25 
* 
************************************************************************************/

#ifndef _FESTIVAL_H
#define _FESTIVAL_H

#include <string>
#include <math.h>
#include "DateTypeDef.h"
#include "Calendar.h"
#include "StringHelper.h"

typedef std::vector<std::string>  FtvList;

class Festival
{
public:
	
	// 由日期得到当天为哪些节日
	static int DateOfFestival(const DateInfo& l_date, FtvList& vecGlFtv, FtvList& vecNlFtv, FtvList& vecJqFtv, bool bGLDate = true);
	static int DateOfFestival2(const DateInfo& l_date, FtvList& vecGlFtv, FtvList& vecNlFtv, FtvList& vecJqFtv, bool bGLDate = true);

	// 输入公历年月，返回这个月几天
	static int GetGlMonthDays(int y,int m);
	
	static int DateOfBetweenFestival(int y, int m, int d, string& ymd1, string& ftv1, string& ymd2, string& ftv2);

private:
	static int DateOfFestivalForType(const int nType, const DateInfo& l_date, FtvList& vecGlFtv, FtvList& vecNlFtv, FtvList& vecJqFtv, bool bGLDate);
	
};

#endif