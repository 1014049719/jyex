/************************************************************************************
 *
 *  @file
 *  @brief              日期数据类型定义头文件
 *
 *  <b>文件名</b>      : DateTypeDef.h
 *  @n@n<b>版权所有</b>: 网龙天晴程序部应用软件开发组
 *  @n@n<b>作  者</b>  : 李学锋
 *  @n@n<b>创建时间</b>: 2010-1-5 13:51:05
 *  @n@n<b>文件描述</b>:
 *  @version		版本	修改者		  时间		  描述@n
 *  @n		        李学锋        2010-02-25
 *
************************************************************************************/
#ifndef _DATE_TYPE_DEF_H_
#define _DATE_TYPE_DEF_H_
 
#include <stdio.h>
#include <string> 

#ifndef interface
#define  interface struct
#endif


interface IAstroData
{
	virtual ~IAstroData(){}
};

// 定义日期数据结构
struct DateInfo : public IAstroData
{
	DateInfo()
	{
		year     = 0;
		month    = 0;
		day      = 0;
		hour     = 0;
		minute   = 0;
		isRunYue = false;
	}
	
	DateInfo(int y, int m, int d)
	{
		year     = y;
		month    = m;
		day      = d;
		hour     = 0;
		minute   = 0;
		isRunYue = false;
	}

	// 年
	int  year;
	// 月
	int  month;
	// 日
	int  day;
	// 时
	int hour;
	//分
	int minute;
	// 是否闰月
	bool isRunYue;

	//重载=
	DateInfo& operator = (const DateInfo& l_temp)
	{
		this->year = l_temp.year;
		this->month = l_temp.month;
		this->day = l_temp.day;
		this->hour = l_temp.hour;
		this->minute = l_temp.minute;
		this->isRunYue = l_temp.isRunYue;
		return *this;
	}
	bool operator ==(const DateInfo& l_temp)
	{
		if ( this == &l_temp)
		{
			return true;
		}
		if((isRunYue != l_temp.isRunYue) || 
			(hour != l_temp.hour)        || 
			(minute != l_temp.minute)    || 
			(day != l_temp.day)          || 
			(month != l_temp.month)      || 
			(year != l_temp.year))
		{		
			return false;
		}
		return true;
	}
	bool operator !=(const DateInfo& l_temp)
	{
		return !(*this == l_temp);
	}
};

// 定义农历信息数据结构
typedef struct LunarInfo 
{
	// 天干
	std::string tiangan;
	// 地支
	std::string dizhi;
	// 生肖
	std::string shenxiao;
	// 日
	std::string dayname;
	// 月
	std::string monthname;
	// 是否闰月
	bool isLeepMonth;

//	LunarInfo(const Json::Value &jsValue)
//	{
//		tiangan     = jsValue["tiangan"].asString();
//		dizhi    = jsValue["dizhi"].asString();
//		shenxiao      = jsValue["shenxiao"].asString();
//		dayname     = jsValue["dayname"].asString();
//		monthname   = jsValue["monthname"].asString();
//		isLeepMonth = jsValue["isLeepMonth"].asBool();
//	}
//	// ת��ΪJson
//	Json::Value ToJsonValue()
//	{
//		Json::Value jsValue;
//		jsValue["tiangan"] = tiangan;
//		jsValue["dizhi"] = dizhi;
//		jsValue["shenxiao"] = shenxiao;
//		jsValue["dayname"] = dayname;
//		jsValue["monthname"] = monthname;
//		jsValue["isLeepMonth"] = isLeepMonth;
//		return jsValue;
//	}

 
	// 构造函数
	LunarInfo():tiangan(""),dizhi(""),shenxiao(""),
		dayname(""),monthname(""),isLeepMonth(false)
	{

	}
	// 拷贝构造函数
	LunarInfo(const LunarInfo& l_lunar)
	{
		tiangan = l_lunar.tiangan;
		dizhi = l_lunar.dizhi;
		shenxiao = l_lunar.shenxiao;
		dayname = l_lunar.dayname;
		monthname = l_lunar.monthname;
		isLeepMonth = l_lunar.isLeepMonth;
	}
}LunarInfo;

#endif // end of defined _DATE_TYPE_DEF_H_
