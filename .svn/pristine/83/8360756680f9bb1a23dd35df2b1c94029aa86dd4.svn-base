//
//  Common.mm
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "Common.h"
#import "Constant.h"
#import "CommonDefine.h"

@implementation CommonFunc


+ (NSString*)createGUIDStr
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef stringGUID = CFUUIDCreateString(NULL,theUUID);
	CFRelease(theUUID);
	return [(NSString *) stringGUID autorelease];
}


+ (NSString*)getNoteTypeName:(ENUM_NOTE_TYPE)noteType
{
    switch (noteType) 
    {
        case NOTE_PIC:
            return [NSString stringWithString:_(@"Picture")];
            break;
        case NOTE_WEB:
            return [NSString stringWithString:_(@"Web page")];
        case NOTE_CUST_DRAW:
            return [NSString stringWithString:_(@"Easy draw")];
        case NOTE_CUST_WRITE:
            return [NSString stringWithString:_(@"Easy write")];
        case NOTE_VIDEO:
            return [NSString stringWithString:_(@"Video")];
        case NOTE_AUDIO:
            return [NSString stringWithString:_(@"音频")];
        case NOTE_CATE:
            return [NSString stringWithString:_(@"Catalog")];
        case NOTE_FLASH:
            return [NSString stringWithString:_(@"Flash")];
        case NOTE_WORD:
            return @"WORD";
        case NOTE_EXCEL:
            return @"Excel";
        case NOTE_EXE:
            return @"EXE";
        case NOTE_TXT:
            return @"TXT";
        case NOTE_POWERPOINT:
            return @"PowerPoint";
        case NOTE_COMPRESS:
            return @"压缩文件";
        case NOTE_CHM:
            return @"CHM";
        case NOTE_VISIO:
            return @"Visio";
        default:
            return @"未知类型";
    }
}


+ (NSString*)getItemTypeExt:(ENUM_ITEM_TYPE)itemType
{
    switch (itemType) 
    {
        case NI_NOTEINFO:return @"html";
        case NI_HTML:return @"html";                          // HTML文本 .htm .html
        case NI_TEXT:return @"txt";                            // Text类型文本  txt
        case NI_PIC:return @"jpg";                            // 图片类型  jpg
        case NI_FLASH:return @"swf";                           // Flash文件 swf
        case NI_VIDEO:return @"wmv";                           // 视频 wmv
        case NI_AUDIO:return @"wav";                            //wav
        case NI_WORD:return @"doc";                             //doc
        case NI_EXCEL:return @"xls";                            //xls
        case NI_PDF:return @"pdf";                               //pdf
        case NI_EXE:return @"exe";                               //exe
        case NI_TXT:return @"txt";                               //
        case NI_RTF:return @"rtf";                              //RTF
        case NI_POWERPOINT:return @"ppt";                       //ppt
        case NI_COMPRESS:return @"rar";                         //rar
        case NI_CHM:return @"chm";                              //chm
        case NI_VISIO:return @"vsd";                            //vsd
        case NI_CSS:return @"css";                             // 样式表 .css
        case NI_JS:return @"js";                              // JavaScript .js
        case NI_UNKNOWN:return @"unk";                    // 未知类型 
        case NI_INKDATA:return @"jpg";						//随手画数据文件
        default:return @"htm";
    }
}

+ (NSString*)getStreamTypeByExt:(NSString *)strExt
{
    if ( [strExt isEqualToString:@"html"] ) return @"text/html";
    if ( [strExt isEqualToString:@"htm"] ) return @"text/html";
    if ( [strExt isEqualToString:@"jpg"] ) return @"image/jpeg"; 
    if ( [strExt isEqualToString:@"gif"] ) return @"image/gif"; 
    if ( [strExt isEqualToString:@"png"] ) return @"image/png"; 
    if ( [strExt isEqualToString:@"wav"] ) return @"audio/x-wav"; 
    return @"application/octet-stream";
}



/*
+ (GUID)createGUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef stringGUID = CFUUIDCreateString(NULL,theUUID);
	CFRelease(theUUID);
    std::string strGUID = [((NSString *)stringGUID) UTF8String];
	return [self stringToGUID:strGUID];
}

+ (string)guidToString:(GUID)guid
{
    char	szGuid[38];
	sprintf(szGuid, "%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X",
            guid.Data1, guid.Data2, guid.Data3,
            guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3],
            guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]);
	szGuid[36] = 0;
	return string(szGuid);
}

+ (NSString*)guidToNSString:(GUID)guid
{
    string strTmp = [self guidToString:guid];
    NSString *strRet = [NSString stringWithUTF8String:strTmp.c_str()];
    return strRet;
}

+ (GUID)stringToGUID:(string)str
{
    if (str.empty())
        return GUID_NULL;
    
    GUID guid;
    int data1;
	int data2;
	int data3;
	int data4[8];
	sscanf(str.c_str(), "%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",  
           &data1, &data2, &data3,
           &data4[0], &data4[1], &data4[2], &data4[3], &data4[4], &data4[5], &data4[6], &data4[7]);
    
	guid.Data1 = data1;
	guid.Data2 = data2;
	guid.Data3 = data3;
	guid.Data4[0] = static_cast<unsigned char>(data4[0]);
	guid.Data4[1] = static_cast<unsigned char>(data4[1]);
	guid.Data4[2] = static_cast<unsigned char>(data4[2]);
	guid.Data4[3] = static_cast<unsigned char>(data4[3]);
	guid.Data4[4] = static_cast<unsigned char>(data4[4]);
	guid.Data4[5] = static_cast<unsigned char>(data4[5]);
	guid.Data4[6] = static_cast<unsigned char>(data4[6]);
	guid.Data4[7] = static_cast<unsigned char>(data4[7]);
    
    return guid;
}

+ (GUID)nsstringToGUID:(NSString*)str
{
    return [self stringToGUID:[str UTF8String]];
}
*/
 
/*
+ (string)transSqliteStr:(string)strSrc
{
    struct STRING_REPLACE {
        string strOld;
        string strNew;
    };
    
    const struct STRING_REPLACE str_replace[] = {
        { "'",  "''" },    // 字符 '
    };
    
    string strDst = strSrc;
    for (int i = 0; i < sizeof(str_replace) / sizeof(STRING_REPLACE); ++i)
    {
        // 其实可以不用这种二重循环 但算法写起来比较麻烦
        size_t iPos = -1;
        size_t iPosFindBegin= 0;
        do
        {
            iPos = strDst.find(str_replace[i].strOld.c_str(), iPosFindBegin);
            if (string::npos == iPos)
            {
                break;
            }
            strDst.replace(iPos, str_replace[i].strOld.length(), str_replace[i].strNew);
            iPosFindBegin = iPos +  str_replace[i].strNew.length();
        }while (iPos != string::npos);
    }
    
    return strDst;
}

+ (string)transSqliteStrW:(unistring)strSrc
{
    if (strSrc.size() <= 0)
        return string("");
    string strTmp = [self unicodeToUTF8:strSrc];
    return [self transSqliteStr:strTmp];
}

 +(NSString *) checkSQLValueForField:(NSString *)strValue
 {
    NSString *strReturn = nil;
    if (strValue) {
        strReturn = [strValue stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    return strReturn;
 }
 
 
+ (string)intToStr:(int)num
{
    if( num == 0 )
		return "0" ;
    
	string str = "";
    
	int num_ =  num > 0 ? num : -1 * num;
    
	while( num_ )
	{
		str = (char)(num_ % 10 + 48) + str;
		num_ = num_ / 10 ;
	}
    
	if( num < 0 )
		str = "-" + str;
    
	return  str;
}

+ (string)i2a:(int)num
{
    char	chTemp[20];
	memset((void *)chTemp, 0x00, sizeof(chTemp));
	itoa(num, chTemp, 10);
	return string(chTemp);
}

+ (string)ul2a:(unsigned long)ulnum
{
    char	chTemp[20];
	memset((void *)chTemp, 0x00, sizeof(chTemp));
	ultoa(ulnum, chTemp, 10);
	return string(chTemp);
}

+ (string)unicodeToUTF8:(unistring)unicodeString
{
    if (unicodeString.empty() || unicodeString.size() <= 0)
        return "";
    
    NSString *tmpStr = [[NSString alloc] initWithCharacters:unicodeString.c_str() length:unicodeString.length()];
	const char* szResult = [tmpStr UTF8String];
	if (!szResult || 0 == strlen(szResult)) {
		[tmpStr release];
		return "";
	}
    string strResult = szResult;
    [tmpStr release];
    return strResult;
}

+ (void)utf8ToUnicode:(string)strUTF8 buffer:(unichar*)szBuf;
{
    NSString *tmpStr = [[NSString alloc] initWithCString:strUTF8.c_str() encoding:NSUTF8StringEncoding];
    [tmpStr getCharacters:szBuf];
}

+ (unistring)utf8ToUnicode:(string)strUTF8
{
    if (strUTF8.empty())
    {
        unistring strResult;
        return strResult;
    }
        
    NSString *tmpStr = [[NSString alloc] initWithCString:strUTF8.c_str() encoding:NSUTF8StringEncoding];
    int nLen = [tmpStr length] + 1;
    unichar * pBuf = new unichar[nLen];
    ZeroMemory(pBuf, nLen * sizeof(unichar));
    [tmpStr getCharacters:pBuf];
    unistring strResult = pBuf;
    
    delete [] pBuf;
    pBuf = NULL;
    [tmpStr release];
    return strResult;
}

+ (unsigned int)getUnicodeLength:(unsigned char *)data {
    if (data == nil) {
        return 0;
    }
    
    int pos = 0;
    while (1)
    {
        unsigned char b1 = data[pos];
        unsigned char b2 = data[pos + 1];
        // 双字节 当遇到 00时表示结束
        if ((b1 == 0) && (b2 == 0))
        {
            break;
        }
        pos += 2;
    }
    return pos;
}



+ (void)showStopSycAlert:(id)delegate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
                                                     message:_(@"Synchronizing note, want to stop?") 
                                                    delegate:delegate
                                           cancelButtonTitle:_(@"Yes") 
                                           otherButtonTitles:_(@"Cancel"),nil];
    alert.tag = 51;
    [alert show];
    [alert release];
}

+ (void)showSyncingAlert:(id)delegate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
                                                     message:_(@"Synchronizing note, try later.") 
                                                    delegate:delegate
                                           cancelButtonTitle:_(@"Yes") 
                                           otherButtonTitles:nil];
    [alert show];
    [alert release];
}
*/ 

/*
+ (void)stopSync
{
    EM_SYNC_STATUS syncStatus = [Global getSyncStatus];
    switch (syncStatus) 
    {
        case SS_UPLOAD_NOTE_LIST:
            {
                [[MBListener defaultListener] stop];
                return;
            }
            break;
        case SS_DOWN_CATE:
        case SS_DOWN_BY_DIR:
        case SS_DOWN_NEWEST:
        case SS_DOWN_SEARCH:
        case SS_DOWN_SINGEL_NOTE:
            {
                [[MBSynManager defaultManager] stop];
                return;
            }
        default:
            {
                [[MBSynManager defaultManager] stop];
                return;
            }
            break;
    }
}
*/

// add by xupb


#pragma mark -
#pragma mark publicfunc
// 获取系统版本字符串
+ (NSString *)osVersionString {
    return [[UIDevice currentDevice] systemVersion];
}


//获取应用程序版本号
+(NSString *)getAppVersion
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@.%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    
    return appVersion;
}

//获取应用名称
+(NSString *)getAppName
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    return strAppName;
}



/*
+ (NSString *) platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = (char *)malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    return results;
}
+ (NSString *)deviceUniqueIDString {
    
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = (char *)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
*/


+(NSString*)getAppAddressWithAppCode:(NSString*)sAppCode
{
    if ( !sAppCode ) {
        return nil;
    }
    NSString *s = [sAppCode uppercaseString];
    if ( [s isEqualToString:LM_QQHK] )  //亲情会客
    {
        return nil;
    }
    else if( [s isEqualToString:LM_PAJS] ) //平安接送
    {
        return @"mobile.php?mod=space&ac=pajs";
    }
    else if( [s isEqualToString:LM_GRKJ] ) //个人空间
    {
        return @"mobile.php?mod=space&ac=person_class";
    }
    else if( [s isEqualToString:LM_BJKJ] ) //班级空间
    {
        return @"mobile.php?mod=space&ac=intoclass";
    }
    else if( [s isEqualToString:LM_CZDA] ) //成长档案
    {
        return nil;
    }
    //else if( [s isEqualToString:@"YEZJZX"] ) //父母学堂
    //{
    //    return nil;
    //}
    else if( [s isEqualToString:LM_CZGS] ) //成长故事
    {
        return @"mobile.php?mod=czgs&ac=list&jyex_mobile=1";
    }
    else if( [s isEqualToString:LM_FMXT] ) //父母学堂
    {
        return @"mobile.php?mod=yezx&ac=list&jyex_mobile=1";
    }
    else if( [s isEqualToString:LM_PM] ) //消息
    {
        return @"mobile.php?mod=pm&ac=viewlist";
    }
    return nil;
}

//资源图片
+(NSString*)getResourceNameWithAppCode:(NSString*)appCode
{
    NSString *s = [appCode uppercaseString];
    if ( [s isEqualToString:LM_QQHK] )  //亲情会客
    {
        return @"app_image_qqhk.png";
    }
    else if( [s isEqualToString:LM_PAJS] ) //平安接送
    {
        return @"app_image_pajs.png";
    }
    else if( [s isEqualToString:LM_GRKJ] ) //个人空间
    {
        return @"app_image_grkj.png";
    }
    else if( [s isEqualToString:LM_BJKJ] ) //班级空间
    {
        return @"app_image_grkj.png";
    }
    else if( [s isEqualToString:LM_CZDA] ) //成长档案
    {
        return @"app_image_czda.png";
    }
    else if( [s isEqualToString:LM_FMXT] ) //父母学堂
    {
        return @"app_image_fmxt.png";
    }
    else if( [s isEqualToString:LM_YEZZB] ) //育儿掌中宝
    {
        return @"app_image_fmxt.png";
    }
    else //默认
    {
        return @"app_image_qqhk.png";
    }
}


+(int)getBtnTagWithCode:(NSString*)sCode
{
    if ( sCode ) {
        if ( [sCode isEqualToString:LM_QQHK] )  //亲情会客
        {
            return 1004;
        }
        else if( [sCode isEqualToString:LM_PAJS] ) //平安接送
        {
            return 1003;
        }
        else if( [sCode isEqualToString:LM_GRKJ] ) //个人空间(学校空间)
        {
            return 1001;
        }
        else if( [sCode isEqualToString:LM_BJKJ] ) //班级空间
        {
            return 1000;
        }
        else if( [sCode isEqualToString:LM_PM] )
        {
            return 1002;
        }
    }
    return -1;
}


+(NSString *)getAppCodeWithBtnTag:(int)tag
{
    if ( tag == 1004 ) return LM_QQHK;  //亲情会客
    else if ( tag == 1003 ) return LM_PAJS; //平安接送
    else if ( tag == 1001 ) return LM_GRKJ; //个人空间(学校空间)
    else if ( tag == 1000 ) return LM_BJKJ; //班级空间
    else if ( tag == 1002 ) return LM_PM;
    else return @"";
}



@end


