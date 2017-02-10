/************************************************************************************
 * 
 *  @file 
 *  @brief              字符串操作辅助函数实现文件
 * 
 *  <b>文件名</b>      : StringHelper.cpp
 *  @n@n<b>版权所有</b>: 网龙天晴程序部应用软件开发组
 *  @n@n<b>作  者</b>  : 李学锋
 *  @n@n<b>创建时间</b>: 2010-1-5 13:50:58
 *  @n@n<b>文件描述</b>: 
 *  @version		版本	修改者		  时间		  描述@n
 *  @version                陈希          2011-03-08  增加C++ 标准库字符串格式化StringFormat()
 *  @n		        李学锋        2010-02-25 
 * 
************************************************************************************/
#include "StringHelper.h"
#include <algorithm>

#ifndef  WIN32
#define  _vsnprintf vsnprintf
#endif

typedef basic_string<char>::size_type S_T; 
static const S_T npos = -1; 


//trim指示是否保留空串，默认为保留。tok可以为任意多个字符
void StringHelper::Tokenize(vector<string>& vecResult,const string& src, string tok,           
						     bool trim, string null_subst) 
{ 
	if( src.empty() || tok.empty() ) 
		return; 
	S_T pre_index = 0, index = 0, len = 0; 
	while( (index = src.find_first_of(tok, pre_index)) !=npos ) 
	{ 
		if( (len = index-pre_index)!=0 ) 
			vecResult.push_back(src.substr(pre_index, len)); 
		else if(trim==false) 
			vecResult.push_back(null_subst); 
		pre_index = index+1; 
	} 
	string endstr = src.substr(pre_index); 
	if( trim==false ) vecResult.push_back( endstr.empty()?null_subst:endstr ); 
	else if( !endstr.empty() ) 
		vecResult.push_back(endstr); 
} 

//delimit为一个字符，严格分割
void StringHelper::Split(vector<string>& vecResult,const string& src, string delimit, string null_subst) 
{ 
	if( src.empty() || delimit.empty() ) 
		return ;    
	S_T deli_len = delimit.size(); 
	long index = npos, last_search_position = 0; 
	while( (index=src.find(delimit,     
		last_search_position))!=npos ) 
	{ 
		if(index==last_search_position) 
			vecResult.push_back(null_subst); 
		else 
			vecResult.push_back( src.substr(last_search_position, index-   
			last_search_position) ); 
		last_search_position = index + deli_len; 
	} 
	string last_one = src.substr(last_search_position); 
	vecResult.push_back( last_one.empty()? null_subst:last_one ); 
}   


// 替换字符串 12212  12-》21  ==》 22211
string& StringHelper::ReplaceAll(string& str,const string& old_value,const string& new_value)
{
	while(true)
	{      
		string::size_type   pos(0);      
		if((pos=str.find(old_value))!=string::npos )      
			str.replace(pos,old_value.length(),new_value);      
		else
			break;      
	}      
	return str;  
}

// 替换字符串 12212  12-》21  ==》 21221
string& StringHelper::ReplaceAllDistinct(string& str,const string& old_value,const string& new_value)
{
	for(string::size_type pos(0);pos!=string::npos;pos+=new_value.length()) 
	{      
		if((pos=str.find(old_value,pos))!=string::npos )      
			str.replace(pos,old_value.length(),new_value);      
		else  
			break;      
	}      
	return str;   
}

// 连接字符串
string StringHelper::Connect(const vector<string>& vecSrcStrs,const string& tok)
{
	string sDesStr = "";

	if (vecSrcStrs.empty())
	{
		return sDesStr;
	}

	for ( int i = 0; i < (int)vecSrcStrs.size(); i++)
	{
		sDesStr += vecSrcStrs[i];
		sDesStr += tok;
	}
	sDesStr = sDesStr.substr(0,sDesStr.length() - tok.length());
	return sDesStr;
}

// 去掉重复子串
string& StringHelper::RemoveRepeatSubStr(string& str,const string& tok)
{
	vector<string> vecSubStrs;
	Tokenize(vecSubStrs,str,tok);
    std::sort(vecSubStrs.begin(),vecSubStrs.end());
	vecSubStrs.erase(unique(vecSubStrs.begin(),vecSubStrs.end()),vecSubStrs.end());
	str = Connect(vecSubStrs,tok);
	return str;
}


/************************************************************************************
* @brief C++ 标准库字符串格式化
* 
* @n<b>函数名称</b>        : StringFormat
* @n@param const char * fmt: 格式化字符串
* @param   ...             : 参数
* @return                   
* @see                      
* @n<b>作者</b>            :陈希
* @n<b>创建时间</b>        : 2011-3-8 17:25:18
* @version	修改者        时间        描述@n
* @n		陈希          2011-03-08 
************************************************************************************/
std::string StringHelper::StringFormat( const char* fmt, ... )
{
	va_list argptr;
	va_start(argptr, fmt);

	int   bufsize = _vsnprintf(NULL, 0, fmt, argptr) + 2;
	char* buf     = new char[bufsize];

	_vsnprintf(buf, bufsize, fmt, argptr);

	std::string str(buf);
	delete[] buf;
	va_end(argptr);

	return str;
}

void StringHelper::StringFormat( std::string& destStr, const char* fmt, ... )
{
	va_list argptr;
	va_start(argptr, fmt);

	int   bufsize = _vsnprintf(NULL, 0, fmt, argptr) + 2;
	char* buf     = new char[bufsize];

	_vsnprintf(buf, bufsize, fmt, argptr);
	destStr = buf;
	delete[] buf;
	va_end(argptr);
}

/************************************************************************************
 * @brief C++ 标准库字符串子串替换
 * 
 * @n<b>函数名称</b>            : StringReplace
 * @n@param std                 ::string & destStr: 进行操作的字符串
 * @param   const char *  oldStr: 需替换的原有字符串
 * @param   const char *  newStr: 用以替换的字符串
 * @see                          
 * @n<b>作者</b>                :陈希
 * @n<b>创建时间</b>            : 2011-3-9 9:43:16
 * @version	修改者        时间        描述@n
 * @n		陈希          2011-03-09 
 ************************************************************************************/
void StringHelper::StringReplace( std::string &destStr, const char* oldStr, const char* newStr )
{
	size_t OldStrLen  = strlen(oldStr);
	size_t NewStrLen  = strlen(newStr);
	size_t pos        = std::string::npos;
	size_t StartIndex = 0;

	while((pos = destStr.find(oldStr, StartIndex)) != std::string::npos)
	{
		destStr.replace(pos, OldStrLen, newStr);
		StartIndex = pos + NewStrLen;
	}
}