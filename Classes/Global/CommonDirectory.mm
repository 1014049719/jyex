//
//  Common.mm
//  NoteBook
//
//  Created by wangsc on 10-9-16.
//  Copyright 2010 ND. All rights reserved.
//

#import "CommonDirectory.h"
#import "CommonDefine.h"
//#import "Logger.h"
//#import "Global.h"
#import "GlobalVar.h"
#import "logging.h"
#import "PubFunction.h"
#import "UIImage+Scale.h"
#import "CImagePicker.h"

#import "TFHpple.h"


@implementation CommonFunc (ForDirectory)


#pragma mark -
#pragma mark file相关

+ (BOOL)isImageFile:(NSString *)strExt
{
    if (  [strExt isEqualToString:@"png"] || [strExt isEqualToString:@"PNG"]
        || [strExt isEqualToString:@"jpg"] || [strExt isEqualToString:@"jpg"]
        || [strExt isEqualToString:@"gif"] || [strExt isEqualToString:@"GIF"] 
        || [strExt isEqualToString:@"bmp"] || [strExt isEqualToString:@"BMP"] )
        return YES;
    else return NO;
}

+ (BOOL)isFileExisted:(NSString *)fileName {
    BOOL bSuccess = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bSuccess = [fileManager fileExistsAtPath:fileName];
	return bSuccess;
}

+ (BOOL) deleteFile: (NSString *) fileName{
	BOOL bSuccess = YES;
	if ([self isFileExisted:fileName]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		bSuccess = [fileManager removeItemAtPath:fileName error:nil];
	}
    
	return bSuccess;
}

+ (NSString *) getFullFileName: (NSString *) fileNameNoPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent: fileNameNoPath];
	return path;
}

+ (NSString *) getFullDirectoryName: (BOOL) ifNotCreateIt : (BOOL) isTempDirectory : (NSString *) directoryName : (NSError **) error{
	NSArray *paths;
	NSString *path;
	if (isTempDirectory) {
		path = [NSTemporaryDirectory() stringByAppendingPathComponent: directoryName];
	}
	else {
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		path = [documentsDirectory stringByAppendingPathComponent: directoryName];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		//NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath: path withIntermediateDirectories:NO attributes:nil error:error]) {
            return @"";
		}
    }
	return path;
}

+ (NSString *) getFullDirectoryNameOnBaseDirectoryName: (BOOL) ifNotCreateIt : (NSString *) baseDirectoryName : (NSString *) directoryName : (NSError **) error{
	NSArray *paths;
	NSString *path;
    
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	path = [documentsDirectory stringByAppendingPathComponent: directoryName];
	NSString *newPath=@"";
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		//NSError *error;
		newPath = [path stringByAppendingPathComponent:path];
		if (![[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
			if (![[NSFileManager defaultManager] createDirectoryAtPath: newPath withIntermediateDirectories:NO attributes:nil error:error]) {
				return @"";
			}
		}
    }
	return newPath;
}


+ (NSString*) getDocumentDir
{
	// 获取程序Documents目录路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


+ (BOOL) EnsureFilePathExist:(NSString*) fullPath
{
	//如果路径不存在，就创建
	NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:fullPath])
    {
        BOOL result = [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		return result;
    }
	else
	{
		return YES;
	}
	
}


+(BOOL) CopySouceToTarget:(NSString*) source Target:(NSString*) target 
{
	NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:target error:&err];
	BOOL b = [[NSFileManager defaultManager] copyItemAtPath:source toPath:target error:&err];
	return b;
}

//获取文件的大小，以K为单位
+(long long)GetFileSize:(NSString *)strFilename
{
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:
                         strFilename error:nil];
    if ( !dic ) return 0;
    
    long long lfilesize = [dic fileSize];
    //if ( lfilesize == 0 ) return 0;
    //else if ( lfilesize < 1024 && lfilesize >= 1 ) return 1;
    //else return (lfilesize/1024);  
    return lfilesize;
}



//获取HTML文件body之间的内容
+(NSString *)getHTMLFileBody:(NSString *)strHTMLFile
{
    NSString *strEditAllHTML = [NSString stringWithContentsOfFile:strHTMLFile encoding:NSUTF8StringEncoding error:nil];  
    
    NSRange rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<body"];  //开头
    if ( rangeFileBodyStart.length == 0 ) rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<BODY"];
    NSRange rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</body>"];  //结尾
    if ( rangeFileBodyEnd.length == 0 ) rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</BODY>"];
    
    if ( rangeFileBodyStart.length == 0 || rangeFileBodyEnd.length == 0 ||
         rangeFileBodyStart.location >= rangeFileBodyEnd.location ) return @"";
    
    NSRange rangeFileBodyContent = NSMakeRange(rangeFileBodyStart.location,rangeFileBodyEnd.location-rangeFileBodyStart.location);  //中间的内容，包括<body>标签，要除去
    NSString *strEditFileBody = [strEditAllHTML substringWithRange:rangeFileBodyContent];
    //除去<body>标签，第一个>
    NSRange rangeFileBodyTagEnd = [strEditFileBody rangeOfString:@">"];
    if ( rangeFileBodyTagEnd.length == 0 ) return @"";
    NSString *strEditFileContent = [strEditFileBody substringFromIndex:rangeFileBodyTagEnd.location+1];   
    return strEditFileContent;
}

//替换HTML文件body之间的内容,strNewContent不含<body>标签, 如果文件不在，用模版文件
+(BOOL)replaceHTMLBody:(NSString *)strHTMLFile content:(NSString *)strNewContent
{
    NSString *strEditAllHTML;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:strHTMLFile] ) {
        strEditAllHTML = [NSString stringWithContentsOfFile:strHTMLFile encoding:NSUTF8StringEncoding error:nil];  
    }
    else {
        //NSString *strPath = [[NSBundle mainBundle] bundlePath];
        //NSString *strResourcePath  = [[NSBundle mainBundle] resourcePath];
        NSString *strModelFileName = [CommonFunc getSaveModelFile];//[NSString stringWithFormat:@"%@/note_model.html",strPath];
        strEditAllHTML = [NSString stringWithContentsOfFile:strModelFileName encoding:NSUTF8StringEncoding error:nil]; 
    }

    NSRange rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<body"];  //开头
    if ( rangeFileBodyStart.length == 0 ) rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<BODY"];
    NSRange rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</body>"];  //结尾
    if ( rangeFileBodyEnd.length == 0 ) rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</BODY>"];

    if ( rangeFileBodyStart.length == 0 || rangeFileBodyEnd.length == 0 ||
        rangeFileBodyStart.location >= rangeFileBodyEnd.location ) return NO;
    
    NSRange rangeFileBodyContent = NSMakeRange(rangeFileBodyStart.location,rangeFileBodyEnd.location-rangeFileBodyStart.location);  //中间的内容，包括<body>标签
    
    //除去<body>标签
    NSString *strEditFileBody = [strEditAllHTML substringWithRange:rangeFileBodyContent];
    //除去<body>标签，第一个>
    NSRange rangeFileBodyTagEnd = [strEditFileBody rangeOfString:@">"];  //子串的位置
    if ( rangeFileBodyTagEnd.length == 0) return NO;
    
    //不包括<body>标签的位置
    rangeFileBodyContent = NSMakeRange(rangeFileBodyContent.location+rangeFileBodyTagEnd.location+1,rangeFileBodyContent.length-rangeFileBodyTagEnd.location-1);  
    
    //替换内容
    NSString *strNewAllHTML = [strEditAllHTML stringByReplacingCharactersInRange:rangeFileBodyContent withString:strNewContent];
    
    
    //再写回文件,用UTF8
    NSData * data = [NSData dataWithBytes:[strNewAllHTML UTF8String] length:strlen([strNewAllHTML UTF8String])];
    BOOL ret = [data writeToFile:strHTMLFile atomically:YES]; 
    
    return ret;
}

//用新的内容替换HTML模版<tag id=content>之间的内容,如果内容为空，就不替换
+(NSString *)replaceDemoContent:(NSString *)strModelFile content:(NSString *)strContent
{
    NSString *strDemoAllHTML = [NSString stringWithContentsOfFile:strModelFile encoding:NSUTF8StringEncoding error:nil];
    
    if (!strContent) return strDemoAllHTML;
    
    //计算替换的位置
    NSString *strDivTag = @"<div id=\"content\" contenteditable=\"true\"";
    NSRange rangeDemoHead = [strDemoAllHTML rangeOfString:strDivTag];
    NSString *strTmp = [strDemoAllHTML substringFromIndex:rangeDemoHead.location];
    NSRange rangeTmp = [strTmp rangeOfString:@">"];
    rangeDemoHead.length =  rangeTmp.location + rangeTmp.length;
    NSRange rangeDemoTail = [strDemoAllHTML rangeOfString:@"</div>"];
    //中间内容的位置和长度，已时完整的<div>头了
    NSRange rangDemoReplace = NSMakeRange(rangeDemoHead.location+rangeDemoHead.length,rangeDemoTail.location-rangeDemoHead.location-rangeDemoHead.length); 
    
    //替换demo串的内容
    NSString *strNewDemoAllHTML = [strDemoAllHTML stringByReplacingCharactersInRange:rangDemoReplace withString:strContent];
    
    return strNewDemoAllHTML;
}


//替换item的GUID
+(BOOL)replaceHTMLItemGuid:(NSString *)strHTMLFile oldguid:(NSArray *)arrOldItemGuid newguid:(NSArray *)arrNewItemGuid
{
    NSString *strEditAllHTML;
    
    strEditAllHTML = [NSString stringWithContentsOfFile:strHTMLFile encoding:NSUTF8StringEncoding error:nil];  
    if ( !strEditAllHTML ) return FALSE;
    
    for (int i=0;i<[arrOldItemGuid count];i++) {
        NSString *strOldItemGuid = [arrOldItemGuid objectAtIndex:i];
        NSString *strNewItemGuid = [arrNewItemGuid objectAtIndex:i];
        
        //替换
        strEditAllHTML = [strEditAllHTML stringByReplacingOccurrencesOfString:strOldItemGuid withString:strNewItemGuid];
    }
    
    //再写回文件,用UTF8
    NSData * data = [NSData dataWithBytes:[strEditAllHTML UTF8String] length:strlen([strEditAllHTML UTF8String])];
    BOOL ret = [data writeToFile:strHTMLFile atomically:YES]; 
    
    return ret;
}


//获取一个HTML文件的正文
+(NSString *)getHTMLFileBodyText:(NSString *)strHTMLFile
{
    NSString *strEditFileContent=@"";
    
    long long size = [CommonFunc GetFileSize:strHTMLFile];
    if ( size >= 8*1024 ) {  //大于等于8K，只读出1部分处理
        //long long nReadSize = 0;
        int packsize = 4*1024;
        long long offset = 0;
        for (int tt=0;tt<1;tt++) { //只读一次
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:strHTMLFile];
            [fileHandle seekToFileOffset:offset];
            NSData *data = [fileHandle readDataOfLength:packsize]; 
            //NSString *strContent = [NSString stringWithUTF8String:(char *)[data bytes]];
            //由于UTF8的长度不定,可以是1到6个字节
            NSString *strContent = nil;
            for ( int kk=0;kk<6;kk++) {
                if ( ([data length]-kk)  <= 0 ) break;
                NSData *data1 = [NSData dataWithBytes:[data bytes] length:([data length]-kk) ];
                strContent = [[[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding] autorelease];
                if ( strContent ) break;
            }
            
            NSRange rangeFileBodyStart = [strContent rangeOfString:@"<body"];  //开头
            if ( rangeFileBodyStart.length == 0 ) rangeFileBodyStart = [strContent rangeOfString:@"<BODY"];
            if ( rangeFileBodyStart.length > 0 ) {
                //offset += rangeFileBodyStart.location;
                //[fileHandle seekToFileOffset:offset];
                //data = [fileHandle readDataOfLength:packsize*2]; //读2倍出来
                
                //for ( int kk=0;kk<6;kk++) {
                //    if ( ([data length]-kk) <= 0 ) break;
                //    NSData *data1 = [NSData dataWithBytes:[data bytes] length:([data length]-kk) ];
                //    strEditFileContent = [[[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding] autorelease];
                //    if ( strEditFileContent ) break;
                //}
                
                strEditFileContent = [strContent substringFromIndex:rangeFileBodyStart.location];
                break;
            }
        
            offset += [data length];
            if ( offset >= size ) break;
            offset -= 6;  //防止 <body 分隔开
        }
        if ( !strEditFileContent || [strEditFileContent length] < 1 ) return @"";
    }
    else {
        NSString *strEditAllHTML = [NSString stringWithContentsOfFile:strHTMLFile encoding:NSUTF8StringEncoding error:nil];  
    
        NSRange rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<body"];  //开头
        if ( rangeFileBodyStart.length == 0 ) rangeFileBodyStart = [strEditAllHTML rangeOfString:@"<BODY"];
        NSRange rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</body>"];  //结尾
        if ( rangeFileBodyEnd.length == 0 ) rangeFileBodyEnd = [strEditAllHTML rangeOfString:@"</BODY>"];
    
        if ( rangeFileBodyStart.length == 0 || rangeFileBodyEnd.length == 0 ||
            rangeFileBodyStart.location >= rangeFileBodyEnd.location ) return @"";
    
        NSRange rangeFileBodyContent = NSMakeRange(rangeFileBodyStart.location,rangeFileBodyEnd.location-rangeFileBodyStart.location);  //中间的内容，包括<body>标签，要除去
        NSString *strEditFileBody = [strEditAllHTML substringWithRange:rangeFileBodyContent];
        //除去<body>标签，第一个>
        NSRange rangeFileBodyTagEnd = [strEditFileBody rangeOfString:@">"];
        if ( rangeFileBodyTagEnd.length == 0 ) return @"";
    
        strEditFileContent = [strEditFileBody substringFromIndex:rangeFileBodyTagEnd.location+1];
    }
    
    //body中间的<STYLE></STYLE> 要除去掉
    for (int jj=0;jj<4;jj++)
    {
        NSString *strStart1,*strStart2;
        NSString *strEnd1,*strEnd2;
        
        if ( 0 == jj ) {
            strStart1 = @"<STYLE";strStart2=@"<style";strEnd1 = @"</STYLE>";strEnd2=@"</style>";
        }
        else if ( 1 == jj ) {
            strStart1 = @"<SCRIPT";strStart2=@"<script";strEnd1 = @"</SCRIPT>";strEnd2=@"</script>";
        }
        else if ( 2 == jj ) {
            strStart1 = @"<META";strStart2=@"<meta";strEnd1 = @"</META>";strEnd2=@"</meta>";
        }
        else {
            strStart1 = @"<LINK";strStart2=@"<link";strEnd1 = @"</LINK>";strEnd2=@"</link>";
        }
        
        for (;;)
        {
            NSRange rangTagStart = [strEditFileContent rangeOfString:strStart1];  //开头
            if ( rangTagStart.length == 0 ) rangTagStart = [strEditFileContent rangeOfString:strStart2];
            NSRange rangeTagEnd = [strEditFileContent rangeOfString:strEnd1];  //结尾
            if ( rangeTagEnd.length == 0 ) rangeTagEnd = [strEditFileContent rangeOfString:strEnd2];
            
            if ( rangTagStart.length > 0 && rangeTagEnd.length > 0 )
            {
                if ( rangTagStart.location < rangeTagEnd.location )
                {
                    NSRange rangDemoReplace = NSMakeRange(rangTagStart.location,
                                                      rangeTagEnd.location-rangTagStart.location + rangeTagEnd.length);
                    //替换d
                    strEditFileContent = [strEditFileContent stringByReplacingCharactersInRange:rangDemoReplace withString:@""];
                }
                else
                {
                    //不匹配， 把 </style> 替换掉
                    strEditFileContent = [strEditFileContent stringByReplacingCharactersInRange:rangeTagEnd withString:@""];
                }
            }
            else break;
        }
    }
    
    
    //除去各种标签
    for (;;)
    {
        NSRange rangTagStart = [strEditFileContent rangeOfString:@"<"];  //开头
        NSRange rangeTagEnd = [strEditFileContent rangeOfString:@">"];  //结尾
        if ( rangTagStart.length > 0 && rangeTagEnd.length > 0 )
        {
            if ( rangTagStart.location < rangeTagEnd.location ) 
            {
                NSRange rangDemoReplace = NSMakeRange(rangTagStart.location, 
                                        rangeTagEnd.location-rangTagStart.location + rangeTagEnd.length); 
                //替换d
                strEditFileContent = [strEditFileContent stringByReplacingCharactersInRange:rangDemoReplace withString:@""];
            }
            else 
            {
                //不匹配， 把 > 替换掉
                strEditFileContent = [strEditFileContent stringByReplacingCharactersInRange:rangeTagEnd withString:@""];
            }
        }
        else break;
    }
    
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&ensp;" withString:@""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&emsp;" withString:@""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    strEditFileContent = [strEditFileContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return strEditFileContent;
}


//-------------------------------------



+ (void)checkUserDirectory:(NSString*)strUserName
{
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:[self getUserDBDir:strUserName]];
    [arr addObject:[self getTempDir]];
    [arr addObject:[self getTempDownDir]];
    [arr addObject:[self getDecryptDir]];
    [arr addObject:[self getImgDir]];
    [arr addObject:[self getStaticDir]];
    [arr addObject:[self getJsDir]];
    [arr addObject:[self getMobImgDir]];
    [arr addObject:[self getMobV5]];
    [arr addObject:[self getMobV5_css]];
    [arr addObject:[self getMobV5_images]];
    [arr addObject:[self getMobV5_images_ico]];
    [arr addObject:[self getMobV5_js]];
    [arr addObject:[self getMobV51]];
    [arr addObject:[self getMobV51_css]];
    [arr addObject:[self getMobV51_images]];
    [arr addObject:[self getMobV51_images_ico]];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *strDir in arr) {
        if(![fileManager fileExistsAtPath:strDir])
        {
            BOOL result = [fileManager createDirectoryAtPath:strDir withIntermediateDirectories:YES attributes:nil error:nil];
            if(!result){
                LOG_ERROR(@"Create Directory %@ failed!", strDir);
            }
            else {
                NSLog(@"create dir:%@",strDir);
            }
            
        }
    }
    
    /*
    NSString *strDBDir = [self getUserDBDir:strUserName];
    NSString *strTmpDir = [self getTempDir];
    NSString *strDownDir = [self getTempDownDir];
    NSString *strDecryptPath = [self getDecryptDir];
    NSString *strImgDir = [self getImgDir];
    NSString *strStaticDir = [self getStaticDir];
    NSString *strJSDir = [self getJsDir];
    NSString *strMobImgDir = [self getMobImgDir];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:strDBDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strDBDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strDBDir);
        }
    }
    
    if(![fileManager fileExistsAtPath:strTmpDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strTmpDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strTmpDir);
        }
    }
    
    if(![fileManager fileExistsAtPath:strDownDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strDownDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strDownDir);
        }
    }
        
    if(![fileManager fileExistsAtPath:strDecryptPath])
    {
        BOOL result = [fileManager createDirectoryAtPath:strDecryptPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strDecryptPath);
        }
    }
    
    if(![fileManager fileExistsAtPath:strImgDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strImgDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strImgDir);
        }
    }
    
    if(![fileManager fileExistsAtPath:strStaticDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strStaticDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strStaticDir);
        }
    }
    
    if(![fileManager fileExistsAtPath:strJSDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strJSDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strJSDir);
        }
    }
    
    if(![fileManager fileExistsAtPath:strMobImgDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strMobImgDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            LOG_ERROR(@"Create Directory %@ failed!", strMobImgDir);
        }
    }
    */
}


+ (NSString *)getNoteDataPath {
	NSString *strNoteDataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/91NoteDat"];
	return strNoteDataPath;
}


+ (NSString*)getUserDBDir:(NSString *)strUser
{
    NSString *strMainDir = [[NSHomeDirectory() 
                             stringByAppendingPathComponent:@"Documents/91NoteDat"]
                            stringByAppendingPathComponent:strUser];  
    NSLog(@"%@", strMainDir);
    NSString *strDBDir = [NSString stringWithFormat:@"%@/Data", strMainDir];
    return strDBDir;
}

+ (NSString*)getTempDir
{
    NSString *strMainDir = [[NSHomeDirectory() 
                             stringByAppendingPathComponent:@"Documents/91NoteDat"]
                            stringByAppendingPathComponent:TheCurUser.sUserName];
    NSString *strTmpDir = [NSString stringWithFormat:@"%@/Temp", strMainDir];
    return strTmpDir;
}


+ (NSString*)getTempDir:(NSString *)strUser
{
    NSString *strMainDir = [[NSHomeDirectory()
                             stringByAppendingPathComponent:@"Documents/91NoteDat"]
                            stringByAppendingPathComponent:strUser];
    NSString *strTmpDir = [NSString stringWithFormat:@"%@/Temp", strMainDir];
    return strTmpDir;
}



+ (NSString*)getTempDownDir
{
    NSString *strMainDir = [[NSHomeDirectory() 
                             stringByAppendingPathComponent:@"Documents/91NoteDat"]
                            stringByAppendingPathComponent:TheCurUser.sUserName];
    NSString *strDownDir = [NSString stringWithFormat:@"%@/temp_download", strMainDir];
    return strDownDir;
}

+ (NSString*)getDecryptDir
{
    return [NSString stringWithFormat:@"%@/decrypted", [self getTempDir]];
}

+ (NSString*)getImgDir
{
    return [NSString stringWithFormat:@"%@/img", [self getTempDir]];
}

+ (NSString*)getStaticDir
{
    return [NSString stringWithFormat:@"%@/static", [self getTempDir]];
}

+ (NSString*)getJsDir
{
    return [NSString stringWithFormat:@"%@/js", [self getStaticDir]];
}

+ (NSString*)getMobImgDir
{
    return [NSString stringWithFormat:@"%@/mobimg", [self getStaticDir]];
}

//-------
+ (NSString*)getMobV5
{
    return [NSString stringWithFormat:@"%@/mobv5", [self getStaticDir]];
}

+ (NSString*)getMobV5_css
{
    return [NSString stringWithFormat:@"%@/mobv5/css", [self getStaticDir]];
}

+ (NSString*)getMobV5_images
{
    return [NSString stringWithFormat:@"%@/mobv5/images", [self getStaticDir]];
}
+ (NSString*)getMobV5_images_ico
{
    return [NSString stringWithFormat:@"%@/mobv5/images/ico", [self getStaticDir]];
}
+ (NSString*)getMobV5_js
{
    return [NSString stringWithFormat:@"%@/mobv5/js", [self getStaticDir]];
}
//------
+ (NSString*)getMobV51
{
    return [NSString stringWithFormat:@"%@/mobv51", [self getStaticDir]];
}

+ (NSString*)getMobV51_css
{
    return [NSString stringWithFormat:@"%@/mobv51/css", [self getStaticDir]];
}

+ (NSString*)getMobV51_images
{
    return [NSString stringWithFormat:@"%@/mobv51/images", [self getStaticDir]];
}
+ (NSString*)getMobV51_images_ico
{
    return [NSString stringWithFormat:@"%@/mobv51/images/ico", [self getStaticDir]];
}




+ (NSString*)getItemPath:(NSString *)guidItem fileExt:(NSString *)fileExt
{
    NSString * strRet = [NSString stringWithFormat:@"%@/%@.%@", [self getTempDir], guidItem, fileExt];
    return strRet;
}

+ (NSString*)getItemPathAddSrc:(NSString *)guidItem fileExt:(NSString *)fileExt
{
    NSString * strRet = [NSString stringWithFormat:@"%@/%@_src.%@", [self getTempDir], guidItem, fileExt];
    return strRet;
}


+ (NSString*)getDecryptItemPath:(NSString *)guidItem fileExt:(NSString *)fileExt
{
    NSString * strRet = [NSString stringWithFormat:@"%@/decrypted/%@.%@", [self getTempDir], guidItem, fileExt];
    return strRet;
}

+ (NSString*)getProperItemPath:(TNoteInfo*)pNoteInfo
{
    /*
    if (pNoteInfo->nEncryptFlag != EF_NOT_ENCRYPTED)
    {
        return [self getDecryptItemPath:pNoteInfo->guidFirstItem fileExt:pNoteInfo->wszFileExt];
    }
    else
    {
        return [self getItemPath:pNoteInfo->guidFirstItem fileExt:pNoteInfo->wszFileExt];
    }
    */
    
    return @"";
}


//取编辑模版文件
+ (NSString *)getEditModelFile
{
    NSString *strResourcePath  = [[NSBundle mainBundle] resourcePath];
    
    NSString * strRet = [NSString stringWithFormat:@"%@/index.html", strResourcePath];
    return strRet;    
}

//取保存模版文件
+ (NSString *)getSaveModelFile
{
    NSString *strResourcePath  = [[NSBundle mainBundle] resourcePath];
    
    NSString * strRet = [NSString stringWithFormat:@"%@/note_model.html", strResourcePath];
    return strRet;    
}

//取随手画临时文件
+ (NSString *)getDrawTmpFile
{
    NSString * strRet = [NSString stringWithFormat:@"%@/Documents/drawtmp.jpg", NSHomeDirectory()];
    return strRet;    
}

//录音临时文件
+ (NSString *)getRecordTmpFile
{
    NSString * strRet = [NSString stringWithFormat:@"%@/Documents/recordtmp.wav", NSHomeDirectory()];//recordtmp.tif
    return strRet;    
}


//头像下载全路径文件
+ (NSString*)getAvatarDownloadPath
{
    NSString * strRet = [NSString stringWithFormat:@"%@/%@", [self getTempDir], @"avatar.jpg"];
    return strRet;
}
//头像存放全路径文件
+ (NSString*)getAvatarPath
{
    NSString * strRet = [NSString stringWithFormat:@"%@/%@", [self getUserDBDir:TheCurUser.sUserName], @"avatar.jpg"];
    return strRet;
}

+ (NSString*)getAvatarPath:(NSString *)strUserName
{
    NSString * strRet = [NSString stringWithFormat:@"%@/%@", [self getUserDBDir:strUserName], @"avatar.jpg"];
    return strRet;
}




//---------------------------------
+(void)moveDbFile_1_1
{
    NSString *docDir = [self getDocumentDir];
    NSString *dbPath = [docDir stringByAppendingPathComponent:@"91AstroData"];
    
    dbPath = [self getNoteDataPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //if (![fileManager fileExistsAtPath:dbPath])
    //    return;
    
    NSString *path = [docDir  stringByAppendingPathComponent:DBFILE_PATHBASE_FT];
    //if ([fileManager fileExistsAtPath:path])
    //    return;
    
    path = [docDir  stringByAppendingPathComponent:DBFILE_PATHBASE_JT];
    //if ([fileManager fileExistsAtPath:path])
    //    return;
    
    NSArray* fps = [fileManager contentsOfDirectoryAtPath:dbPath error:nil];
    
    BOOL result = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (!result)
    {
        LOG_ERROR(@"升级数据库，新建目录失败");
        //return;
    }
    
    NSString* curPath;
    NSString* toPath;
    
    for (NSString* fp in fps)
    {
        if ([[fp substringToIndex:1] isEqualToString:@"."])
            continue;
        
        if ([fp isEqualToString:DBFILE_CUSTOM1]
            || [fp isEqualToString:DBFILE_CUSTOM2]
            || [fp isEqualToString:DBFILE_CUSTOM3])
        {
            curPath = [dbPath stringByAppendingPathComponent:fp];
            [fileManager removeItemAtPath:curPath error:nil];
            continue;
        }
        
        curPath = [dbPath stringByAppendingPathComponent:fp];
        toPath = [path stringByAppendingPathComponent:fp];
        result = [fileManager moveItemAtPath:curPath toPath:toPath error:nil];
        
        if (!result)
            LOG_ERROR(@"升级数据库，移动文件或路径错误");
    }
    
}


#pragma mark -
#pragma mark 数据库管理-数据库文件操作

+ (NSString* ) getCommonDataBaseDir
{
    NSString *strBaseDir;
	
    strBaseDir = [[self getDocumentDir] stringByAppendingPathComponent:@"91NoteDat/Data"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:strBaseDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strBaseDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            return @"";
        }
    }
	return strBaseDir;
}

/*
+ (NSString* ) getDataBaseDir_UserLocal
{
    NSString *strBaseDir;
	 
    strBaseDir = [[self getDocumentDir] stringByAppendingPathComponent:@"91NoteDat/Data"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:strBaseDir])
    {
        BOOL result = [fileManager createDirectoryAtPath:strBaseDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result)
        {
            return @"";
        }
    }
	return strBaseDir;
}
*/


+ (NSString*) getDbFilePathBy:(EDataBaseType) dbType UserName:(NSString*) user
{
	switch (dbType)
	{
        /*
		case EDbTypeCustom1:
		case EDbTypeCustom2:
		case EDbTypeCustom3:
        {
            NSString* path = [[NSBundle mainBundle] resourcePath];
            
            path = [path stringByAppendingPathComponent:@"db/jt"];
            
            return path;
        }
            break;
        */    
            
		case EDbTypeAstroCommon:
		{
            //NSString* path = [AstroDBMng getDataBaseDir];
            NSString* path = [CommonFunc getCommonDataBaseDir];  //update 2012.8.20            
			return path;
		}
			break;
		
        /*
		case EDbTypeUserLocal:
		{
            //NSString* path = [AstroDBMng getDataBaseDir];   
            NSString* path = [CommonFunc getDataBaseDir_UserLocal];  //update 2012.8.20
            if ([PubFunction stringIsNullOrEmpty:path])
            {
                return nil;
            }
            
			if([PubFunction stringIsNullOrEmpty:user])
			{
				return nil;
			}
			
			NSString *userPath = [path stringByAppendingPathComponent:user];
            
			return userPath;
		}
			break;
        
        */
        case EDbType91Note:
		{
            return [CommonFunc getUserDBDir:user];
 
		}
			break;	
            
            
		default:
			break;
	}
	
	
	return nil;
}

+ (NSString*) getDbFileNameBy:(EDataBaseType) dbType
{
	switch (dbType)
	{
        /*
		case EDbTypeCustom1:
		{
			return DBFILE_CUSTOM1;	
		}
			break;
			
		case EDbTypeCustom2:
		{
			return DBFILE_CUSTOM2;
		}
			break;
            
		case EDbTypeCustom3:
		{
			return DBFILE_CUSTOM3;
		}
			break;
		*/
            
		case EDbTypeAstroCommon:
		{
			return DBFILE_ASTROCOMMON;
		}
			break;
        /*    
		case EDbTypeUserLocal:
		{
			return DBFILE_USERLOCAL;
		}
			break;
		*/	
        case EDbType91Note:
        {
            return DBFILE_91NOTE;
        }
            break;
            
		default:
			break;
	}
	
	return nil;
}


+(NSString *)getDbFileFullName:(EDataBaseType) dbType UserName:(NSString*) user
{
    //目标数据库文件路径
    NSString* path = [self getDbFilePathBy:dbType UserName:user];
        
    //数据库文件名
    NSString *dbName = [self getDbFileNameBy:dbType];
 
    //目标数据库文件路径
    NSString *dbFullPathName = [path stringByAppendingPathComponent:dbName];
    NSLog(@"%@",dbFullPathName);
    
    return dbFullPathName; 
}

+(BOOL) EnsureDbFileExist:(EDataBaseType) dbType UserName:(NSString*) user
{
	//目标数据库文件路径
	NSString* path = [self getDbFilePathBy:dbType UserName:user];
	if ( [PubFunction stringIsNullOrEmpty:path])
	{
		return NO;
	}
	
	//数据库文件名
	NSString *dbName = [self getDbFileNameBy:dbType];
	if ( [PubFunction stringIsNullOrEmpty:dbName])
	{
		return NO;
	}
	
	//目标数据库文件路径
	NSString *dbFullPathName = [path stringByAppendingPathComponent:dbName];
    NSLog(@"%@",dbFullPathName);
    
	if (![CommonFunc isFileExisted:dbFullPathName])
	{
		[CommonFunc EnsureFilePathExist:path];
		
        /*
        //91数据库自己创建
        if ( dbType == EDbType91Note ) 
        {
            //不存在，先创建文件，后面再创建表
            //判断数据库文件是否存在
            if(![[NSFileManager defaultManager] fileExistsAtPath:dbFullPathName])
            {
                BOOL result = [[NSFileManager defaultManager] createFileAtPath:dbFullPathName contents:nil attributes:nil];
                if(!result)
                {
                    NSLog(@"Create Directory %@ failed!", dbFullPathName);
                    return false;
                }
            }
        }
        else*/ 
        {
            //源数据库文件（数据库模板文件）全路径
            //NSString* resoucepath = [[NSBundle mainBundle] resourcePath];
            //resoucepath = [resoucepath stringByAppendingPathComponent:@"db/"];
            //NSString *tmplFilePath = [resoucepath stringByAppendingPathComponent:dbName];
            
            NSRange range = [dbName rangeOfString:@"."];
            NSString *filename = [dbName substringToIndex:range.location];
            NSString *ext = [dbName substringFromIndex:range.location+1];
            NSString *tmplFilePath = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
        
            //copy
            if ([CommonFunc isFileExisted:tmplFilePath])
            {
                if ( ![CommonFunc CopySouceToTarget:tmplFilePath Target:dbFullPathName] )
                {
                    NSLog(@"copy %@ to %@ fail",tmplFilePath,dbFullPathName);
                }
                else 
                {
                    NSLog(@"copy %@ to %@ success",tmplFilePath,dbFullPathName);
                }
            }
            
            //不成功就创建
            if ( dbType == EDbType91Note ) 
            {
                //不存在，先创建文件，后面再创建表
                if(![[NSFileManager defaultManager] fileExistsAtPath:dbFullPathName])
                {
                    BOOL result = [[NSFileManager defaultManager] createFileAtPath:dbFullPathName contents:nil attributes:nil];
                    if(!result)
                    {
                        NSLog(@"Create file %@ failed!", dbFullPathName);
                        return false;
                    }
                }
            }        
        }
	}
    else {
        NSLog(@"db file(%@) is exist", dbFullPathName);
    }
    
	return [CommonFunc isFileExisted:dbFullPathName];
}



+(BOOL) isDbFileExist:(EDataBaseType)dbType UserName:(NSString*)user
{
	//目标数据库文件路径
	NSString* path = [self getDbFilePathBy:dbType UserName:user];
	if ( [PubFunction stringIsNullOrEmpty:path])
	{
		return NO;
	}
	
	//数据库文件名
	NSString *dbName = [self getDbFileNameBy:dbType];
	if ( [PubFunction stringIsNullOrEmpty:dbName])
	{
		return NO;
	}
	
	//目标数据库文件路径
	NSString *dbFullPathName = [path stringByAppendingPathComponent:dbName];
	return [CommonFunc isFileExisted:dbFullPathName];
}




+(EDataBaseType) getDbTypeFromFile:(NSString*) dbFile
{
	if ([PubFunction stringIsNullOrEmpty:dbFile])
	{
		return EDbTypeNull;
	}
	
	NSString* fileName = [dbFile lastPathComponent];
	if ([PubFunction stringIsNullOrEmpty:fileName])
	{
		return EDbTypeNull;
	}
	
    /*
	if ([fileName caseInsensitiveCompare:DBFILE_CUSTOM1] == 0)
	{
		return EDbTypeCustom1;
	}
	else if ([fileName caseInsensitiveCompare:DBFILE_CUSTOM2] == 0)
	{
		return EDbTypeCustom2;
	}
	else if ([fileName caseInsensitiveCompare:DBFILE_CUSTOM3] == 0)
	{
		return EDbTypeCustom3;
	}
    
	else */
    if ([fileName caseInsensitiveCompare:DBFILE_ASTROCOMMON] == 0)
	{
		return EDbTypeAstroCommon;
	}
	/*else if ([fileName caseInsensitiveCompare:DBFILE_USERLOCAL] == 0)
	{
		return EDbTypeUserLocal;
	}*/
    //add 2012.10.22
    else if ([fileName caseInsensitiveCompare:DBFILE_91NOTE] == 0)
	{
		return EDbType91Note;
	}
	
	return EDbTypeNull;
}


//保存jyex图片
+(BOOL)saveJYEXPic:(UIImage *)image fileguid:(NSString *)strFileGuid mode:(NSString *)strQuality
{
    image = [CImagePicker fixOrientation:image] ;//add 2014-10-21
    
    NSLog(@"src image size=%@,scale=%.0f oriention=%ld quality=%@",NSStringFromCGSize(image.size),image.scale,(long)image.imageOrientation,strQuality);

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    CGFloat fRate = 0.5;
    //--------
    UIImage *imageSave;
    if ([strQuality isEqualToString:@"H"]) {
        imageSave = image;
        fRate = 1.0;
    }
    else  {
        CGFloat maxsize = 640;  //小边限制为640或1400
        if ([strQuality isEqualToString:@"M"]) maxsize = 1600; //高清
        
        if (image.size.height > maxsize && image.size.height < image.size.width  ) {//height为小边
            CGFloat fScale = maxsize / image.size.height;
            CGFloat fWidth = image.size.width * fScale;
            imageSave = [image scaleToSize:CGSizeMake(fWidth, maxsize)];
        }
        else if (image.size.width > maxsize && image.size.width < image.size.height  ) { //width为小边
            CGFloat fScale = maxsize / image.size.width;
            CGFloat fHeight = image.size.height * fScale;
            imageSave = [image scaleToSize:CGSizeMake(maxsize, fHeight)];
        }
        else {
            imageSave = image;
        }
    }
 
    NSLog(@"proc image size=%@,scale=%.0f",NSStringFromCGSize(imageSave.size),imageSave.scale);
    
    
    //图像还可以压缩
    NSData *data = UIImageJPEGRepresentation(imageSave, fRate);
    
    NSString *imagePath = [CommonFunc getItemPath:strFileGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    NSString *imagePathSrc = [CommonFunc getItemPathAddSrc:strFileGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    BOOL ret = [data writeToFile:imagePathSrc atomically:YES];
    if ( !ret ) {
        LOG_ERROR(@"保存图片1不成功");
        NSLog(@"保存图片1不成功");
        MESSAGEBOX(@"保存图片1不成功");
        return FALSE;
    }
    
    //生成展现看的
    ret = [UIImage createScreenWidthImageFile:imageSave filename:imagePath];
    if ( !ret ) {
        LOG_ERROR(@"保存图片2不成功");
        NSLog(@"保存图片2不成功");
        MESSAGEBOX(@"保存图片2不成功");
        return FALSE;
    }
    
    NSLog(@"jyexPic:src img:(src filesize=%lld,thumb filesize=%lld)",
          [CommonFunc GetFileSize:imagePathSrc], [CommonFunc GetFileSize:imagePath]);
    
    
    [pool drain];
 
    

    return TRUE;
}


//从html文件中读取标签值
+(NSString *)getTagValueFromHtml:(NSString *)strHtmlFile tagname:(NSString *)strTagName
{
    int flag = 0;
    NSString *value = @"";
    
    NSData *data;
    TFHpple *xpathParser;
    
    do {
        
        data = [[NSData alloc] initWithContentsOfFile:strHtmlFile];
    
        // Create parser
        xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
        //Get all the cells of the 2nd row of the 3rd table
        //NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[@id='img_json']"];
        //NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[last()]"];
        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input"];
        if ( !elements || [elements count] < 1 ) break;
    
        for (int jj=0;jj<[elements count];jj++) {
            // Access the first cell
            TFHppleElement *element = [elements objectAtIndex:jj];
    
            // Get the text within the cell tag
            //NSString *content = [element content];
            //[e text];                       // The text inside the HTML element (the content of the first text node)
            //[e tagName];                    // "a"
            //[e attributes];                 // NSDictionary of href, class, id, etc.
            //[e objectForKey:@"href"];       // Easy access to single attribute
            //[e firstChildWithTagName:@"b"]; // The first "b" child node
    
            NSString *idStr = [element objectForKey:@"id"];
            if ( ![idStr isEqualToString:strTagName])  continue; //@"img_json"
            value = [element objectForKey:@"value"];
    
            if( (![value hasPrefix:@"{"])  && (![value hasPrefix:@"["])){
                NSRange r1 = [value rangeOfString:@"{"];
                NSRange r2 = [value rangeOfString:@"["];
                if ( r1.location == NSNotFound && r2.location == NSNotFound ) {
                    continue;
                }
                else {
                    r1.location = ((r1.location <= r2.location) ? r1.location : r2.location);
                    value = [value substringFromIndex:r1.location];
                }
            }
            flag = 1;
            break;
        }
        break;
        
    }while(1);
 
    if ( xpathParser ) [xpathParser release];
    if ( data ) [data release];
    
    if ( 0 == flag ) return @"";
 
    return value;
}



@end


