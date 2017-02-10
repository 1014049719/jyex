/*
 *  CHtmlTextCollector.h
 *  NoteBook
 *
 *  Created by nd on 11-5-27.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */

class CHtmlTextCollector
{
public:
	CHtmlTextCollector(const char *htmlString);
	virtual ~CHtmlTextCollector();
	
	char *GetTextInHtml();
	
	
protected:
	// szContent: 填入的需要检测的文本内容
	// iOverCount: 跨越的字节数
	// bNeedFree: 返回的字符串是否需要显示调用_FreeForCheck释放
	// 返回值: 替换掉的字符串
	char *_CheckAndTransform(char *szContent, int &iOverCount, bool &bNeedFree);
	char *_FreeForCheck(char *szTransform);
							 
private:
	
	const char *m_strHtml;	
	char *m_strText;
};