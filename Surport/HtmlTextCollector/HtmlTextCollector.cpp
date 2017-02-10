/*
 *  CHtmlTextCollector.cpp
 *  NoteBook
 *
 *  Created by nd on 11-5-27.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include "stddef.h"
#include "string.h"
#include "stdlib.h"
#include "HtmlTextCollector.h"

CHtmlTextCollector::CHtmlTextCollector(const char *htmlString)
: m_strHtml(htmlString),
  m_strText(NULL)
{
	
}
CHtmlTextCollector::~CHtmlTextCollector()
{
	if (m_strText)
	{
		free(m_strText);
		m_strText;
	}
}

// szContent: 填入的需要检测的文本内容
// iOverCount: 跨越的字节数
// bNeedFree: 返回的字符串是否需要显示调用_FreeForCheck释放
// 返回值: 替换掉的字符串
char *CHtmlTextCollector::_CheckAndTransform(char *szContent, int &iOverCount, bool &bNeedFree)
{
	bNeedFree = false;
	
	if (NULL == szContent)
	{
		iOverCount = 0;
		return NULL;
	}
	
	int iContentLength = 0;
	if (0 == (iContentLength = strlen(szContent)))
	{
		iOverCount = 0;
		return "";
	}
	
	// 找出可以转义的字符
	char *szResult = NULL;
	int iIndex = 0;
	while (iIndex < iContentLength)
	{		
		 ++ iIndex;
		
		if (';' == szContent[iIndex])
			break;
	}
	// 说明没有找到可以转义的字符，直接将传入的szContent传出，并给iOverCount赋值iContentLength
	if (iIndex == iContentLength)
	{
		iOverCount = iContentLength;
		return szContent;
	}
	
	// 将可以进行转换的字符串扣取出来
	int iTransformLength = (iIndex + 2) * sizeof(char);
	char *szTransform = (char *)malloc(iTransformLength);
	memset(szTransform, 0, iTransformLength);
	memcpy(szTransform, szContent, (iIndex + 1) * sizeof(char));
	// 对iOverCount赋值
	iOverCount = iIndex + 1;
	// 对其进行匹配转换
	if (0 == strcmp(szTransform, "&nbsp;"))
		szResult = " ";
	else if (0 == strcmp(szTransform, "&ensp;"))
		szResult = " ";
	else if (0 == strcmp(szTransform, "&emsp;"))
		szResult = "　";
	else if (0 == strcmp(szTransform, "&lt;"))
		szResult = "<";
	else if (0 == strcmp(szTransform, "&gt;"))
		szResult = ">";	
	else if (0 == strcmp(szTransform, "&amp;"))
		szResult = "&";	
	else if (0 == strcmp(szTransform, "&quot;"))
		szResult = "\"";	
	else if (0 == strcmp(szTransform, "&copy;"))
		szResult = "©";
	else if (0 == strcmp(szTransform, "&reg;"))
		szResult = "®";
	else if (0 == strcmp(szTransform, "&times;"))
		szResult = "×";
	else if (0 == strcmp(szTransform, "&divide;"))
		szResult = "÷";
	else 
	{
		bNeedFree = true;
		szResult = (char *)malloc(iTransformLength);
		memcpy(szResult, szTransform, iTransformLength);
	}
	
	// 释放掉中间参数
	free(szTransform);
	
	return szResult;
}

char *CHtmlTextCollector::_FreeForCheck(char *szTransform)
{
	if (szTransform)
		free(szTransform);
}

char *CHtmlTextCollector::GetTextInHtml()
{
	if (!m_strHtml)
		return NULL;
	
	int iLength = 0;
	if (0 == (iLength = strlen(m_strHtml)))
		return "";
	
	bool bAvaliable = true;
	int iIndex = 0;
	char chIndex = 0;
	
	// 先遍历得到文本的总长度
	int iTextLength = 0;
	while (iIndex < iLength)
	{
		chIndex = m_strHtml[iIndex];
		if ('<' == chIndex)
			bAvaliable = false;
		else if ('>' == chIndex)
			bAvaliable = true;
		else if (bAvaliable)
		{
			++ iTextLength;
		}
		++ iIndex;
	}
	
	// 为文本分配空间并赋空值
	iTextLength = (iTextLength + 1) * sizeof(char);
	char *szText = (char *)malloc(iTextLength);
	char *szTextOrigin = szText;
	memset(szText, 0, iTextLength);
	if (szText)
	{
		// 开始提取文本
		iIndex = 0;
		bAvaliable = true;
		chIndex = 0;
		int iTextIndex = 0;
		
		while (iIndex < iLength)
		{
			chIndex = m_strHtml[iIndex];
			if ('<' == chIndex)
				bAvaliable = false;
			else if ('>' == chIndex)
				bAvaliable = true;
			else if (bAvaliable)
			{
				szText[iTextIndex] = chIndex;
				++ iTextIndex;
			}
			++ iIndex;
		}
	}
	// 去掉前面所有的换行符
	iIndex = 0;
	while (iIndex < (iTextLength - 1))
	{
		if ((0x0d == szText[iIndex]) && (0x0a == szText[iIndex + 1]))
			iIndex += 2;
		else if (0x20 == szText[iIndex])
			iIndex += 1;
		else
			break;

	}
	if (iIndex >= iTextLength)
	{
		// 清理掉中间变量
		free (szTextOrigin);
		return "";
	}
	szText += iIndex;
	
	iTextLength = strlen(szText);
	if (NULL != m_strText)
		free(m_strText);
	// 为已经获取到的文本替换掉特殊转换字符
	m_strText = (char *)malloc(iTextLength);
	memset(m_strText, 0, iTextLength);
	if (m_strText)
	{
		iIndex = 0;
		int iIndexDst = 0;
		
		while (iIndex < iTextLength)
		{
			chIndex = szText[iIndex];
			if ('&' == chIndex)
			{
				int iOverCount = 0;
				bool bNeedFree = false;
				char *szTransform = _CheckAndTransform((szText + iIndex), iOverCount, bNeedFree);
				if (szTransform)
				{
					// 计算转换得到的字符串长度
					int iTransformLength = strlen(szTransform);
					
					// 设置转换的字符串
					memcpy((m_strText + iIndexDst), szTransform, iTransformLength * sizeof(char));
					
					// 递增索引
					iIndex += iOverCount;
					iIndexDst += iTransformLength;
					
					// 清理掉转换得到的字符串
					if (bNeedFree)
						_FreeForCheck(szTransform);					
				}
				else 
				{
					++ iIndex;
				}
			}
			else
			{
				m_strText[iIndexDst] = chIndex;
				
				++ iIndex;
				++ iIndexDst;
			}

		}
	}
	
	// 清理掉中间变量
	free (szTextOrigin);
	
	return m_strText;
}
