//
//  Logger.h
//  Untitled
//
//  Created by huangyan on 09-2-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MASK 1<<0

//是否显示详细目录，1：显示全部路径 0：只显示文件名
#define SHOWFULLPATH 0
#if defined(__cplusplus)
extern "C" {
#endif
	void simulatorLog(NSString *logStr,const char* f, int l);
#if defined(__cplusplus)
}
#endif

#define DLOG(...) simulatorLog([NSString stringWithFormat:__VA_ARGS__], __FILE__, __LINE__)

#if TARGET_IPHONE_SIMULATOR
#define MLOG(...) simulatorLog([NSString stringWithFormat:__VA_ARGS__], __FILE__, __LINE__)
#else
#define MLOG(...) LOG(__VA_ARGS__)
#endif

#define MMLOG(m,...) [Logger log:[NSString stringWithFormat:__VA_ARGS__] file:__FILE__ linnum:__LINE__ to:m]

//日志文件目录
//#define LOGFILEPATH [[[NSBundle mainBundle] bundlePath]	stringByAppendingPathComponent:@"log.txt"]
#define LOGFILEPATH @"/tmp/log.txt"
#define DEBUG_LOG_FLAG_FILE "/tmp/log.ini"
#define LOG(...) [Logger log:[NSString stringWithFormat:__VA_ARGS__] file:__FILE__ linnum:__LINE__];
@interface Logger : NSObject {
	NSFileHandle *h_file;
}
+ (void)log:(NSString*)s file:(const char*)f linnum:(int)l;
+ (void)log:(NSString*)s file:(const char*)f linnum:(int)l to:(NSString*)n;
@end
