///*
// *  AT.c
// *  Untitled
// *
// *  Created by QiLiang Shen on 09-2-16.
// *  Copyright 2009 __MyCompanyName__. All rights reserved.
// *
// */
//
//#import "PPGetPhoneInfoFunctions.h"
//#import "NetworkController.h"
//#import "CoreTelephony.h"
//
//
//
//NSString *getSysPhoneNum(){
//	NSString *s=(NSString *)CTSettingCopyMyPhoneNumber();		
//	if(s) return [s autorelease];
//	return @"";
//}
//
//NSString *getSysICCID(){
//	return @"Unsupported!2";
//}
//
//NSString *getSysIMEI(){
//#if TARGET_IPHONE_SIMULATOR
//	return SIMULATOR_IMEI;
//#else
//	NetworkController *nc = [NetworkController sharedInstance];
//	return [nc IMEI];
//#endif
//}
//
//NSString *getSysIMSI(){
//#if TARGET_IPHONE_SIMULATOR
//	return SIMULATOR_IMSI;
//#else	
//	NSString *s = (NSString *)CTSIMSupportCopyMobileSubscriberIdentity(nil);
//	if(s) return [s autorelease];
//	return @"";
//#endif
//}
//BOOL isSIMCardInserted(){
//#if TARGET_IPHONE_SIMULATOR
//	return YES;
//#else
//	if(CTSIMSupportGetSIMStatus()==kCTSIMSupportSIMStatusNotInserted) return NO;
//	else return YES;
//#endif
//}