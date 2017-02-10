#ifndef _CALENDAR_H
#define _CALENDAR_H


#include <string>
#include <math.h>
#include "DateTypeDef.h"

// 日期类
class  Calendar
{
public:
    
    static void InitCalendarLoc(int isFT);
    
	// date与1900年相差的天数
	static long LDaysFrom1900(const DateInfo& date);

	// 农历y年的总天数
	static int LYearDays(int y);

	// 传回农历 y年闰月的天数
	static int LeapDays(int y);

	// 传回农历 y年闰哪个月 1-12 , 没闰传回 0
	static int LeapMonth(int y);

	// 传回农历 y年m月的总天数
	static int MonthDays(int y,int m);

	// 输入阳历日期，返回阴历日期
	static DateInfo Lunar(const DateInfo& date);

	// 输入阳历日期，返回星期几
	static const char* DayOfWeek(DateInfo  date);

	// 输入阳历日期，返回星期几
	static const char* DayOfWeekZhou(DateInfo  date);

	//输入阳历日期，返回星期几
	static int DayOfWeekFlag(DateInfo  date);

	// 输入阴历日期,得到表示农历的信息
	static LunarInfo GetLunarInfo (const DateInfo&  date );

	// 输入阳历日期,得到表示农历的信息
	static LunarInfo GetLunarInfoByYanLi (const DateInfo&  date );

	// 传回国历 y年某m+1月的天数
	static int SolarDays(int y,int m);

	// 判断公历年是否闰年
	static bool IsLeapYear(int year);

	// 获取某个时间的时辰
	static std::string GetLunarTime(int hour); 

	// 获取农历干支日
	static std::string GetLlGZDay(DateInfo  date); 

     // 获取农历干支月【注意：此处获取的是具体某天所在月的月干支】
    static std::string GetLlGZMonth(const DateInfo&  date);

	// 获取农历干支月【注意：此处获取的是某个农历月总的月干支，有时候农历月份相同，但是该月下的某日的月干支和本处所求的月干支可能不一样，具体情况请自己研究万年历】
	static std::string GetLlGZMonth_GanZhi(const DateInfo&  date);

	// 获取农历干支时
	static std::string GetLlGZHour(const std::string& l_day_tg,const std::string& l_hour_dz);

	// 农历转公历日期
	static DateInfo GetGlDate(const DateInfo&  nldate);

	// 将压缩的阴历字符还原
	static std::string H2B(const std::string& strHex);

	// 输入农历的年月信息，返回这个月有多少天。
	static int MonthDaysFun(int y, int m, bool bIsRun = false);

	// 输入农历年，获取农历年中那个闰月的天数（如果存在闰月的话）
	static int LeapDaysFun(int year);

	// 从农历获取公历的具体实现方法
	static DateInfo GetGlDateFun(const DateInfo& nldate);

	// 获取农历信息
	static bool GetLunarFromDay(int year, int month, int day,int & lunarYear, int &lunarMonth, int &lunarDay, bool &isLeapMonth);

	// 取某日期到年初的天数，不考虑 1582 年 10 月的特殊情况
	static int GetDayFromYearBegin(int year, int month, int day);

	// 取本月天数，不考虑 1582 年 10 月的特殊情况
	static int GetMonthDays(int year, int month);

    // 返回某公历是否闰年，自动判断 Julian 还是 Gregorian，支持公元前
	static bool GetIsLeapYear(int year);

    // 根据公历日期判断当时历法
	static int GetCalendarType(int year, int month, int day);

	// 获得某公历年内的第 N 个节气距年初的天数，1-24，对应小寒到冬至
	static double GetJieQiDayTimeFromYear(int year, int n);

	// 获得某公历日的等效标准日数
	static int GetEquStandardDays(int year, int month, int day);

	// 获得某公历年月日的农历日数和该日月相以及日月食类型和时刻
	static double GetLunarMoon(int year, int month, int day, int &eclipseType, int &moonPhase, double &theTime);

	// 获得某公历年月日的农历月数
	static double GetLunarMonth(int year, int month, int day);

	// 某角度计算函数，移植自中国日历类
	static double GetAng(double X, double T, double C1, double T0, double T2, double T3);

	// 获得一大于零的数的小数部分
	static double GetTail(double x);

	// 获取自公元前 850 年开始的农历闰月数
	static int GetLeapNum(int year);

	// 获取闰月所在的那个月
	static int GetLeapMonth(int year);

	// 小数的求余数
	static double GetRemain(double X, double W);

	// 公历日期加一天后的公立日期
	static DateInfo AddOneDay(const DateInfo& l_date);

	// 根据公历年月日获得某公历年的天干地支，以立春为年分界，0-59 对应 甲子到癸亥
	static int GetGanZhiFromYear(int year, int month, int day, int hour, int& NLYear);

    // 获得某公/农历年的天干地支，0-59 对应 甲子到癸亥
	static int GetGanZhiFromYear(int year);

    // 获得某公历月的天干地支，需要日是因为月以节气分界。0-59 对应 甲子到癸亥
	static int GetGanZhiFromMonth(int year, int month, int day, int hour);

	// 调整年和月记录，因为年月的天干地支计算是以立春和各个节气为分界的
	static void AdjustByJieQi(int &year, int &month, int &day);

	// 将干支拆分成天干地支，0-59 转换成 0-9 0-11
	static bool ExtractGanZhi(int ganzhi, int &gan, int &zhi);

	// 将天干地支组合成干支，0-9 0-11 转换成 0-59
	static int CombineGanZhi(int gan, int zhi);

	// 获取到公元原点的基本天数
	static int GetBasicDays(int year, int month, int day);

	// 获取到公元原点的闰年总天数
	static int GetLeapDays(int year, int month, int day);

	// 获得距公元元年 1 月 0 日的绝对天数
	static int GetAllDays(int year, int month, int day);

	// 获得某公历日的天干地支，0-59 对应 甲子到癸亥
	static int GetGanZhiFromDay(int year, int month, int day, int hour);

	// 获得某公历时的天干地支，0-59 对应 甲子到癸亥
	static int GetGanZhiFromHour(int year, int month, int day, int hour);

	// 获取天干的序号
	static int GetTianGanIndex(const std::string& sTianGan);

	// 获取地址的序号
	static int GetDiZhiIndex(const std::string& sDiZhi);

	// 不考虑立春节气的影响，取一年的年干支(用于紫微排盘)
	static LunarInfo GetYearGanZhi_NoCase_LiChun(int iNlYear);

	// 不考虑立春节气的影响，取年干的索引(用户紫微快速排盘)
	static int GetYearGanIndex_NoCase_LiChun(int iNlYear);

	// 由农历的时间求出公历的时间（时间范围：公历1900年1月31日~公历2050年1月22日）
	// （时间范围：农历1900年1月1日~农历2049年12月29）
	static DateInfo GetGlDateEx(const DateInfo& nlDate);

	// 日期在公历1900年1月31日~2049年12月31日的  公历转农历方法
	static DateInfo LunarEx(const DateInfo& glDate);

private:
	static int   lunarInfo[];//
	static int    solarMonth[];
	//static char    sSolarTerm[];
	//static int   dTermInfo[];
	//static char    sFtv[];
	static int     NlYearDaysList[];
	static int     GlYearDaysList[];

};


#endif

