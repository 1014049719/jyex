/************************************************************************************
 * 
 *  @file 
 *  @brief             字符串操作辅助函数声明头文件
 * 
 *  <b>文件名</b>      : StringHelper.h
 *  @n@n<b>版权所有</b>: 网龙天晴程序部应用软件开发组
 *  @n@n<b>作  者</b>  : 李学锋
 *  @n@n<b>创建时间</b>: 2010-1-5 13:51:00
 *  @n@n<b>文件描述</b>: 
 *  @version		版本	修改者		  时间		  描述@n
 *  @version                陈希          2011-03-08  增加C++ 标准库字符串格式化StringFormat()
 *  @n		        李学锋        2010-02-25 
 * 
************************************************************************************/
#ifndef _STRING_HELPER_H_
#define _STRING_HELPER_H_

#ifdef WIN32
#pragma warning(disable:4018)
#pragma warning(disable:4996)
#pragma warning(disable:4267)
#pragma warning(disable:4244)
#endif

#include <vector>
#include <string>
#include <cstdarg>	// C++ 标准库字符串格式化。Add By 陈希，2011.3.8

using namespace std;


class StringHelper
{
public:

    // trim指示是否保留空串，默认为保留。tok可以为任意多个字符
	static void Tokenize(vector<string>& vecResult,const string& src, string tok,bool trim=false, string null_subst="") ;

	// delimit为一个字符，严格分割
	static void Split(vector<string>& vecResult,const string& src, string delimit, string null_subst="") ;

	// 替换字符串 12212  12-》21  ==》 22211
	static string& ReplaceAll(string& str,const string& old_value,const string& new_value);    
   
	// 替换字符串 12212  12-》21  ==》 21221
	static string& ReplaceAllDistinct(string& str,const string& old_value,const string& new_value);

	// 连接字符串
	static string Connect(const vector<string>& vecSrcStrs,const string& tok);

	// 去掉重复子串
	static string& RemoveRepeatSubStr(string& str,const string& tok);

	// C++ 标准库字符串格式化。Add By 陈希，2011.3.8
	static std::string StringFormat(const char* fmt, ...);
	static void StringFormat(std::string& destStr, const char* fmt, ...);

	// C++ 标准库字符串子串替换。Add By 陈希，2011.3.9
	static void StringReplace(std::string &destStr, const char* oldStr, const char* newStr);
};



#endif // end of defined _STRING_HELPER_H


