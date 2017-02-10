//
//  PFunctions.m
//  pass91
//
//  Created by Zhaolin He on 09-8-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PFunctions.h"
#import <Foundation/NSString.h>
#import "Common.h"
#import "Logger.h"
#import "Constant.h"

#import "CommonDirectory.h"

static NSString * G_userName = nil;
static NSString * G_passName = nil;
static BOOL       G_isBackLogin = NO;


void jiami(char* buffer)  
{  
    int i=0;  
    while(buffer[i]!='\0')  
    {  
		printf("%c",buffer[i]);
        buffer[i] += 3;  
        i++;  
    }  
	
}  
void jiemi(char *buffer)  
{  
    int i=0;  
    while(buffer[i]!='\0')  
    {  
		
        buffer[i] -= 3;  
        i++;  
    }  
}  

 
const char base[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
char *base64_encode(char* data, int data_len)
{
	//jiami(data);
	int prepare = 0;
    int ret_len;
    int temp = 0;
    char *ret = NULL;
    char *f = NULL;
    int tmp = 0;
    char changed[4];
    int i = 0;
    ret_len = data_len / 3;
    temp = data_len % 3;
    if (temp > 0)
    {
        ret_len += 1;
    }
    ret_len = ret_len*4 + 1;
    ret = (char *)malloc(ret_len);
	
    if ( ret == NULL)
    {
        MLOG(@"No enough memory.\n");
        return NULL;
    }
    memset(ret, 0, ret_len);
    f = ret;
    while (tmp < data_len)
    {
        temp = 0;
        prepare = 0;
        memset(changed, '\0', 4);
        while (temp < 3)
        {
            //printf("tmp = %d\n", tmp);
            if (tmp >= data_len)
            {
                break;
            }
            prepare = ((prepare << 8) | (data[tmp] & 0xFF));
            tmp++;
            temp++;
        }
        prepare = (prepare<<((3-temp)*8));
        //printf("before for : temp = %d, prepare = %d\n", temp, prepare);
        for (i = 0; i < 4 ;i++ )
        {
            if (temp < i)
            {
                changed[i] = 0x40;
            }
            else
            {
                changed[i] = (prepare>>((3-i)*6)) & 0x3F;
            }
            *f = base[changed[i]];
            //printf("%.2X", changed[i]);
            f++;
        }
    }
    *f = '\0';
	
    return ret;
	
}


/* */
static char find_pos(char ch)
{
    char *ptr = (char*)strrchr(base, ch);//the last position (the only) in base[]
    return (ptr - base);
}

/* */
NSString* base64_decode(char *data, int data_len)
{	
    int ret_len = (data_len / 4) * 3;
    int equal_count = 0;
    char *ret = NULL;
    char *f = NULL;
    int tmp = 0;
    int temp = 0;
    char need[3];
    int prepare = 0;
    int i = 0;
    if (*(data + data_len - 1) == '=')
    {
        equal_count += 1;
    }
    if (*(data + data_len - 2) == '=')
    {
        equal_count += 1;
    }
    if (*(data + data_len - 3) == '=')
    {//seems impossible
        equal_count += 1;
    }
    switch (equal_count)
    {
		case 0:
			ret_len += 4;//3 + 1 [1 for NULL]
			break;
		case 1:
			ret_len += 4;//Ceil((6*3)/8)+1
			break;
		case 2:
			ret_len += 3;//Ceil((6*2)/8)+1
			break;
		case 3:
			ret_len += 2;//Ceil((6*1)/8)+1
			break;
    }
    ret = (char *)malloc(ret_len);
    if (ret == NULL)
    {
        MLOG(@"No enough memory.\n");
        return NULL;
    }
    memset(ret, 0, ret_len);
    f = ret;
    while (tmp < (data_len - equal_count))
    {
        temp = 0;
        prepare = 0;
        memset(need, 0, 4);
        while (temp < 4)
        {
            if (tmp >= (data_len - equal_count))
            {
                break;
            }
            prepare = (prepare << 6) | (find_pos(data[tmp]));
            temp++;
            tmp++;
        }
        prepare = prepare << ((4-temp) * 6);
        for (i=0; i<3 ;i++ )
        {
            if (i == temp)
            {
                break;
            }
            *f = (char)((prepare>>((2-i)*8)) & 0xFF);
            f++;
        }
    }
    *f = '\0';
	//jiemi(ret);
	
	NSString* result = [NSString stringWithUTF8String:ret];
	free(ret);
    return result;
}


////////////////////////////////////////////////////////////////////////


@implementation PFunctions

+ (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *str_r= [NSString stringWithFormat:
					  @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
					  result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
					  ];
	return [str_r lowercaseString];
}

//存取配置文件
+(void)createConfigFile
{ 
	NSString *savePath=[PFunctions getConfigFile];
	NSLog(savePath);
	
	//[CommonFunc checkUserDirectory:@"guest"];
	
	NSFileManager *filem=[NSFileManager defaultManager];
	if(![filem fileExistsAtPath:savePath])
	{
		NSMutableDictionary *dic=[NSMutableDictionary dictionary];
		[dic setObject:@"YES" forKey:@"KeepPass"];
		[dic setObject:@"NO" forKey:@"KeepLogin"];
		[dic setObject:@"" forKey:@"Username"];
		[dic setObject:@"" forKey:@"Password"];
        [dic setObject:@"" forKey:@"MasterKey"];
		[dic setObject:@"guest" forKey:@"Account"];
		[dic setObject:_(@"unlogin") forKey:@"Loginfo"];
		[dic setObject:@"-1" forKey:@"UserId"];
		[dic setObject:@"Low" forKey:@"PhotoQuality"];
		NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:(id)dic format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
		
		if (plistData) {
			[plistData writeToFile:savePath atomically:YES];
		}
		else 
        {
			MLOG(@"create ConfigFile data error!");
		}
	}
}

+(NSString *)getConfigFile
{
    //	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    //	NSString *savePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"config.plist"];
    
//#if !TARGET_IPHONE_SIMULATOR
	
	NSString * savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/91NoteDat/NoteBookConfig.plist"];
//#else
//	NSString * savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/NoteBookConfig.plist"];;
//#endif
	
	//MLOG(savePath);
	return savePath;
}
+(void)setBackgroudLogin:(BOOL)login
{
	G_isBackLogin = login;
}
+(BOOL)getBackgroudLogin
{
	return G_isBackLogin;
}
+(void)initUsername:(NSString *)userName
{
	G_userName = userName;
}
+(void)initPassname:(NSString *)passName
{
	G_passName = passName;
}
+(NSString *)getUsernameFromKeyboard
{
	return G_userName;
}
+(NSString *)getPassnameFromKeyboard
{
	return G_passName;
}
+(NSString *)getUserName
{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	NSString * str = [dic objectForKey:@"Username"];
	if(str == nil) str = @""; 
	return str;
}

+(NSString *)getPassword
{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	NSString *enc_pass=[dic objectForKey:@"Password"];
	
	if(enc_pass==nil)return @"";
	
	//	char *temp=base64_decode((char *)[enc_pass UTF8String], [enc_pass lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	
	NSString *dec_pass = base64_decode((char *)[enc_pass UTF8String], [enc_pass lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
	//	if(NULL!=temp)
	//	{
	//		dec_pass=[NSString stringWithUTF8String:temp];
	//		free(temp);
	//	}
	//	if(dec_pass == nil) dec_pass = @"";
	return dec_pass;
}
+(NSString *)getSavedState{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	return [dic objectForKey:@"KeepPass"];
}
+(NSData *)getMasterKey {
    /*NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
    return [dic objectForKey:@"MasterKey"];*/
    NSFileHandle *file  = [NSFileHandle fileHandleForReadingAtPath:[[CommonFunc getDBDir] stringByAppendingString:@"/masterkey.bin"]];
    return [file readDataToEndOfFile];
}

+(NSString *)getLoginKeepState
{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	return [dic objectForKey:@"KeepLogin"];
}

+(NSString *)getAccount{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	NSString *strReturn = [dic objectForKey:@"Account"];
	if (nil == strReturn)
		strReturn = _(@"guest");
	return strReturn;
}
+(NSString *)getLoginfo{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	NSString *strReturn = [dic objectForKey:@"Loginfo"];
	if (nil == strReturn)
		strReturn = _(@"unlogin");
	return strReturn;
}
+(NSString *)getUserId{
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];	
	NSString *strReturn = [dic objectForKey:@"UserId"];
	if (nil == strReturn)
		strReturn = @"-1";
	return strReturn;
}
+(NSString *)getPhotoQuality {
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];	
	NSString *strReturn = [dic objectForKey:@"PhotoQuality"];
	if (nil == strReturn)
		strReturn = @"High";
	return strReturn;
}

+(void)setUsername:(NSString *)user Password:(NSString *)pass
{
	[PFunctions createConfigFile];
	NSString *enc_pass=@"";
	
	if(pass!=nil)
	{
		const char * str = [[NSString stringWithString:pass] UTF8String];
		char * newChar = new char[strlen(str)];
		//memcpy(newChar,str,sizeof(str));
		
		//strcpy(newChar, str);
		strncpy(newChar, str, strlen(str));
		
		char *temp=base64_encode(newChar, [pass lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
		delete newChar;
		if(NULL!=temp)
		{
			enc_pass=[NSString stringWithUTF8String:temp];
			free(temp);
		}
	}
	
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:user forKey:@"Username"];
	[dic setObject:enc_pass forKey:@"Password"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}

+(void)setMasterKey:(NSData *)masterkey {
    /*[PFunctions createConfigFile];
	//MLOG(@"Config_file[%@]",[PFunctions getConfigFile]);
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:masterkey forKey:@"MasterKey"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];*/
    if (masterkey != nil) {
        [masterkey writeToFile:[[CommonFunc getDBDir] stringByAppendingString:@"/masterkey.bin"] atomically:NO];
    }
}

+(void)setSavedState:(NSString *)state
{
	[PFunctions createConfigFile];
	//MLOG(@"Config_file[%@]",[PFunctions getConfigFile]);
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:state forKey:@"KeepPass"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}

+(void)setLoginKeepState:(NSString *)state{
	[PFunctions createConfigFile];
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:state forKey:@"KeepLogin"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}

+(void)setAccount:(NSString *)account {
	[PFunctions createConfigFile];
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:account forKey:@"Account"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}
+(void)setLogInfo:(NSString *)loginfo {
	[PFunctions createConfigFile];
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:loginfo forKey:@"Loginfo"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}
+(void)setUserId:(NSString *)UserId {
	[PFunctions createConfigFile];
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:UserId forKey:@"UserId"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}

+(void)setPhotoQuality:(NSString *)quality {
	[PFunctions createConfigFile];
	NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:[PFunctions getConfigFile]];
	[dic setObject:quality forKey:@"PhotoQuality"];
	[dic writeToFile:[PFunctions getConfigFile] atomically:NO];
}

@end
