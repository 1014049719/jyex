//
//  Logger.m
//  Untitled
//
//  Created by huangyan on 09-2-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Logger.h"
#import <fcntl.h>
Logger *g_logger = NULL;
void simulatorLog(NSString *logStr,const char* f, int l){
	char *p;
	p = (char*)f;
	char *cur = (char*)f;
	while (*p!=0) {
		if(*p=='/') cur = p+1;
		p++;
	}
	NSString *fullstr = [NSString stringWithFormat:@"%s#%d:%@\n",cur,l,logStr];
	printf([fullstr UTF8String]);
}


@implementation Logger
+ (Logger*)shared{
	return g_logger;
}

- (Logger*)initWithFilePath:(NSString*)path{
	if(self=[super init]){
		if (access(DEBUG_LOG_FLAG_FILE, 0) == 0)
		{
			int r = creat([path UTF8String], 0777);
			close(r);
			h_file = [[NSFileHandle fileHandleForWritingAtPath:path] retain];
			[h_file seekToEndOfFile];
			NSString *s=[NSString stringWithFormat:
						 @"**********************Start************************"
						 "\n----------------------------------------------------"
						 "\nNOW:%@\n"
						 "----------------------------------------------------\n"
						 ,[NSDate date]];
			[h_file writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];
			[h_file synchronizeFile];			
		}
	}
	return self;
}

- (void)log:(NSString*)s{
	[h_file seekToEndOfFile];
	[h_file writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];
	[h_file synchronizeFile];
}

- (void)dealloc
{
	[h_file closeFile];
	[h_file release];
	[super dealloc];
}
+ (void)log:(NSString*)s file:(char*)f linnum:(int)l to:(NSString*)n{
	static NSMutableDictionary *dict = nil;
	if(dict==nil) dict = [[NSMutableDictionary alloc] init];
	Logger *logger = [dict objectForKey:n];
	char *p;
	p = f;
	char *cur = f;
	while (*p!=0) 
	{
		if(*p=='/') cur = p+1;
		p++;
	}	
	if(logger==NULL) {
		logger = [[[Logger alloc] initWithFilePath:[NSString stringWithFormat:@"/tmp/%@",n]] autorelease];
		[dict setObject:logger forKey:n];
	}
	[logger log:[NSString stringWithFormat:@"%s#%d:%@\n",cur,l,s]];
}

+ (void)log:(NSString*)s file:(char*)f linnum:(int)l{
	char *p;
	p = f;
	char *cur = f;
	while (*p!=0) {
		if(*p=='/') cur = p+1;
		p++;
	}
	if(g_logger==NULL) g_logger=[[Logger alloc] initWithFilePath:LOGFILEPATH];
	[g_logger log:[NSString stringWithFormat:@"%s#%d:%@\n",cur,l,s]];
}
@end
