//
//  UapMgr.m
//  NoteBook
//
//  Created by wangsc on 10-11-25.
//  Copyright 2010 ND. All rights reserved.
//

#import "UapMgr.h"
#import "PFunctions.h"

@implementation NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end


static UapMgr* s_uapMgr = nil;
@implementation UapMgr
@synthesize sessionId;

+ (UapMgr*)instance {
	if (s_uapMgr == nil) {
		s_uapMgr = [[UapMgr alloc] init];
	}
	return s_uapMgr;
}

- (void)uapLogin {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *userName = [PFunctions getUsernameFromKeyboard];
	NSString *password = [PFunctions getPassnameFromKeyboard];
	
	NSString* myRequestString = [NSString stringWithFormat:@"{\"appid\":\"81\",\"username\":\"%@\", \"password\":\"%@\"}", userName, password];
	NSData *myRequestData = [myRequestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [myRequestData length]];
	
	NSURL *url = [NSURL URLWithString:@"https://uap.91.com/login"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:myRequestData];
	
	NSHTTPURLResponse* response = nil;
//	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	if (response != nil) {
		NSLog(@"login code = %d", [response statusCode]);
	}
	
//	NSString *retString = [NSString stringWithUTF8String:[returnData bytes]];
//	NSLog(@"%@", retString);
	
	[pool drain];
}

- (BOOL)uapLoginAsync {
	[self performSelectorInBackground:@selector(uapLogin) withObject:nil];
	return YES;
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
	return YES;
}

@end
